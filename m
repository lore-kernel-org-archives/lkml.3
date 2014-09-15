Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758319AbaIOUpd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 16:45:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8957 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755689AbaIOUp2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 16:45:28 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 05/10] KEYS: Make the key matching functions return bool
 [ver #2]
From: David Howells <dhowells@redhat.com>
To: vgoyal@redhat.com
Cc: dhowells@redhat.com, keyrings@linux-nfs.org, linux-kernel@vger.kernel.org
Date: Mon, 15 Sep 2014 21:45:22 +0100
Message-ID: <20140915204522.27499.20166.stgit@warthog.procyon.org.uk>
In-Reply-To: <20140915204456.27499.40234.stgit@warthog.procyon.org.uk>
References: <20140915204456.27499.40234.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the key matching functions pointed to by key_match_data::cmp return bool
rather than int.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 crypto/asymmetric_keys/asymmetric_type.c |    4 ++--
 include/linux/key-type.h                 |   10 ++++++----
 net/dns_resolver/dns_key.c               |    4 ++--
 security/keys/internal.h                 |    8 ++++----
 security/keys/keyring.c                  |    4 ++--
 security/keys/process_keys.c             |    4 ++--
 6 files changed, 18 insertions(+), 16 deletions(-)

diff --git a/crypto/asymmetric_keys/asymmetric_type.c b/crypto/asymmetric_keys/asymmetric_type.c
index 7c0498968975..7755f918e8d9 100644
--- a/crypto/asymmetric_keys/asymmetric_type.c
+++ b/crypto/asymmetric_keys/asymmetric_type.c
@@ -59,8 +59,8 @@ EXPORT_SYMBOL_GPL(asymmetric_keyid_match);
  *	"id:<id>"	- request a key matching the ID
  *	"<subtype>:<id>" - request a key of a subtype
  */
-static int asymmetric_key_cmp(const struct key *key,
-			      const struct key_match_data *match_data)
+static bool asymmetric_key_cmp(const struct key *key,
+			       const struct key_match_data *match_data)
 {
 	const struct asymmetric_key_subtype *subtype = asymmetric_key_subtype(key);
 	const char *description = match_data->raw_data;
diff --git a/include/linux/key-type.h b/include/linux/key-type.h
index c14816bd3b44..ff9f1d394235 100644
--- a/include/linux/key-type.h
+++ b/include/linux/key-type.h
@@ -56,10 +56,12 @@ typedef int (*request_key_actor_t)(struct key_construction *key,
  * Preparsed matching criterion.
  */
 struct key_match_data {
-	/* Comparison function, defaults to type->match, but can be replaced by
-	 * type->match_preparse(). */
-	int (*cmp)(const struct key *key,
-		   const struct key_match_data *match_data);
+	/* Comparison function, defaults to exact description match, but can be
+	 * overridden by type->match_preparse().  Should return true if a match
+	 * is found and false if not.
+	 */
+	bool (*cmp)(const struct key *key,
+		    const struct key_match_data *match_data);
 
 	const void	*raw_data;	/* Raw match data */
 	void		*preparsed;	/* For ->match_preparse() to stash stuff */
diff --git a/net/dns_resolver/dns_key.c b/net/dns_resolver/dns_key.c
index a07b9ba7e0b7..31cd4fd75486 100644
--- a/net/dns_resolver/dns_key.c
+++ b/net/dns_resolver/dns_key.c
@@ -176,8 +176,8 @@ static void dns_resolver_free_preparse(struct key_preparsed_payload *prep)
  * The domain name may be a simple name or an absolute domain name (which
  * should end with a period).  The domain name is case-independent.
  */
-static int dns_resolver_cmp(const struct key *key,
-			    const struct key_match_data *match_data)
+static bool dns_resolver_cmp(const struct key *key,
+			     const struct key_match_data *match_data)
 {
 	int slen, dlen, ret = 0;
 	const char *src = key->description, *dsp = match_data->raw_data;
diff --git a/security/keys/internal.h b/security/keys/internal.h
index e66a16cb63e1..b8960c4959a5 100644
--- a/security/keys/internal.h
+++ b/security/keys/internal.h
@@ -127,8 +127,8 @@ struct keyring_search_context {
 	struct timespec		now;
 };
 
-extern int key_default_cmp(const struct key *key,
-			   const struct key_match_data *match_data);
+extern bool key_default_cmp(const struct key *key,
+			    const struct key_match_data *match_data);
 extern key_ref_t keyring_search_aux(key_ref_t keyring_ref,
 				    struct keyring_search_context *ctx);
 
@@ -150,8 +150,8 @@ extern struct key *request_key_and_link(struct key_type *type,
 					struct key *dest_keyring,
 					unsigned long flags);
 
-extern int lookup_user_key_possessed(const struct key *key,
-				     const struct key_match_data *match_data);
+extern bool lookup_user_key_possessed(const struct key *key,
+				      const struct key_match_data *match_data);
 extern key_ref_t lookup_user_key(key_serial_t id, unsigned long flags,
 				 key_perm_t perm);
 #define KEY_LOOKUP_CREATE	0x01
diff --git a/security/keys/keyring.c b/security/keys/keyring.c
index 253c9a0eb092..8177010174f7 100644
--- a/security/keys/keyring.c
+++ b/security/keys/keyring.c
@@ -513,8 +513,8 @@ EXPORT_SYMBOL(keyring_alloc);
 /*
  * By default, we keys found by getting an exact match on their descriptions.
  */
-int key_default_cmp(const struct key *key,
-		    const struct key_match_data *match_data)
+bool key_default_cmp(const struct key *key,
+		     const struct key_match_data *match_data)
 {
 	return strcmp(key->description, match_data->raw_data) == 0;
 }
diff --git a/security/keys/process_keys.c b/security/keys/process_keys.c
index 08bd533d014f..bd536cb221e2 100644
--- a/security/keys/process_keys.c
+++ b/security/keys/process_keys.c
@@ -489,8 +489,8 @@ found:
 /*
  * See if the key we're looking at is the target key.
  */
-int lookup_user_key_possessed(const struct key *key,
-			      const struct key_match_data *match_data)
+bool lookup_user_key_possessed(const struct key *key,
+			       const struct key_match_data *match_data)
 {
 	return key == match_data->raw_data;
 }

