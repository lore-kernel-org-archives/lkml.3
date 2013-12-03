Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754918Ab3LCOx2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 09:53:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36852 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754867Ab3LCOxL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 09:53:11 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH2/5] KEYS: Fix the keyring hash function
From: David Howells <dhowells@redhat.com>
To: torvalds@linux-foundation.org, jmorris@namei.org
Cc: Stephen Gallagher <sgallagh@redhat.com>, keyrings@linux-nfs.org,
        Nalin Dahyabhai <nalin@redhat.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org
Date: Tue, 03 Dec 2013 14:53:05 +0000
Message-ID: <20131203145305.30689.66773.stgit@warthog.procyon.org.uk>
In-Reply-To: <20131203145250.30689.28039.stgit@warthog.procyon.org.uk>
References: <20131203145250.30689.28039.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The keyring hash function (used by the associative array) is supposed to clear
the bottommost nibble of the index key (where the hash value resides) for
keyrings and make sure it is non-zero for non-keyrings.  This is done to make
keyrings cluster together on one branch of the tree separately to other keys.

Unfortunately, the wrong mask is used, so only the bottom two bits are
examined and cleared and not the whole bottom nibble.  This means that keys
and keyrings can still be successfully searched for under most circumstances
as the hash is consistent in its miscalculation, but if a keyring's
associative array bottom node gets filled up then approx 75% of the keyrings
will not be put into the 0 branch.

The consequence of this is that a key in a keyring linked to by another
keyring, ie.

	keyring A -> keyring B -> key

may not be found if the search starts at keyring A and then descends into
keyring B because search_nested_keyrings() only searches up the 0 branch (as it
"knows" all keyrings must be there and not elsewhere in the tree).

The fix is to use the right mask.

This can be tested with:

	r=`keyctl newring sandbox @s`
	for ((i=0; i<=16; i++)); do keyctl newring ring$i $r; done
	for ((i=0; i<=16; i++)); do keyctl add user a$i a %:ring$i; done
	for ((i=0; i<=16; i++)); do keyctl search $r user a$i; done

This creates a sandbox keyring, then creates 17 keyrings therein (labelled
ring0..ring16).  This causes the root node of the sandbox's associative array
to overflow and for the tree to have extra nodes inserted.

Each keyring then is given a user key (labelled aN for ringN) for us to search
for.

We then search for the user keys we added, starting from the sandbox.  If
working correctly, it should return the same ordered list of key IDs as
for...keyctl add... did.  Without this patch, it reports ENOKEY "Required key
not available" for some of the keys.  Just which keys get this depends as the
kernel pointer to the key type forms part of the hash function.

Reported-by: Nalin Dahyabhai <nalin@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Tested-by: Stephen Gallagher <sgallagh@redhat.com>
---

 security/keys/keyring.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/security/keys/keyring.c b/security/keys/keyring.c
index 69f0cb7bab7e..0adbc77a59b9 100644
--- a/security/keys/keyring.c
+++ b/security/keys/keyring.c
@@ -160,7 +160,7 @@ static u64 mult_64x32_and_fold(u64 x, u32 y)
 static unsigned long hash_key_type_and_desc(const struct keyring_index_key *index_key)
 {
 	const unsigned level_shift = ASSOC_ARRAY_LEVEL_STEP;
-	const unsigned long level_mask = ASSOC_ARRAY_LEVEL_STEP_MASK;
+	const unsigned long fan_mask = ASSOC_ARRAY_FAN_MASK;
 	const char *description = index_key->description;
 	unsigned long hash, type;
 	u32 piece;
@@ -194,10 +194,10 @@ static unsigned long hash_key_type_and_desc(const struct keyring_index_key *inde
 	 * ordinary keys by making sure the lowest level segment in the hash is
 	 * zero for keyrings and non-zero otherwise.
 	 */
-	if (index_key->type != &key_type_keyring && (hash & level_mask) == 0)
+	if (index_key->type != &key_type_keyring && (hash & fan_mask) == 0)
 		return hash | (hash >> (ASSOC_ARRAY_KEY_CHUNK_SIZE - level_shift)) | 1;
-	if (index_key->type == &key_type_keyring && (hash & level_mask) != 0)
-		return (hash + (hash << level_shift)) & ~level_mask;
+	if (index_key->type == &key_type_keyring && (hash & fan_mask) != 0)
+		return (hash + (hash << level_shift)) & ~fan_mask;
 	return hash;
 }
 

