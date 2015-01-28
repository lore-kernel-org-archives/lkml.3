Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755030AbbA2JAH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 04:00:07 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44737 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754553AbbA2I77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 03:59:59 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Sasha Levin <sasha.levin@oracle.com>,
        David Howells <dhowells@redhat.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 164/176] KEYS: close race between key lookup and freeing
Date: Wed, 28 Jan 2015 15:29:54 +0100
Message-Id: <3e0ae20f2dd1ff034e48efbbb989e495f4eef0b7.1422455352.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
References: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
In-Reply-To: <cover.1422455352.git.jslaby@suse.cz>
References: <cover.1422455352.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sasha Levin <sasha.levin@oracle.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit a3a8784454692dd72e5d5d34dcdab17b4420e74c upstream.

When a key is being garbage collected, it's key->user would get put before
the ->destroy() callback is called, where the key is removed from it's
respective tracking structures.

This leaves a key hanging in a semi-invalid state which leaves a window open
for a different task to try an access key->user. An example is
find_keyring_by_name() which would dereference key->user for a key that is
in the process of being garbage collected (where key->user was freed but
->destroy() wasn't called yet - so it's still present in the linked list).

This would cause either a panic, or corrupt memory.

Fixes CVE-2014-9529.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 security/keys/gc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/security/keys/gc.c b/security/keys/gc.c
index d67c97bb1025..797818695c87 100644
--- a/security/keys/gc.c
+++ b/security/keys/gc.c
@@ -201,12 +201,12 @@ static noinline void key_gc_unused_keys(struct list_head *keys)
 		if (test_bit(KEY_FLAG_INSTANTIATED, &key->flags))
 			atomic_dec(&key->user->nikeys);
 
-		key_user_put(key->user);
-
 		/* now throw away the key memory */
 		if (key->type->destroy)
 			key->type->destroy(key);
 
+		key_user_put(key->user);
+
 		kfree(key->description);
 
 #ifdef KEY_DEBUGGING
-- 
2.2.2

