Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752286AbaL2Ojh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 09:39:37 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:23229 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751611AbaL2Oje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 09:39:34 -0500
From: Sasha Levin <sasha.levin@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: Sasha Levin <sasha.levin@oracle.com>, David Howells <dhowells@redhat.com>,
        James Morris <james.l.morris@oracle.com>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        keyrings@linux-nfs.org (open list:KEYS/KEYRINGS:),
        linux-security-module@vger.kernel.org (open list:SECURITY SUBSYSTEM)
Subject: [PATCH] KEYS: close race between key lookup and freeing
Date: Mon, 29 Dec 2014 09:39:01 -0500
Message-Id: <1419863941-16403-1-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 2.1.0
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a key is being garbage collected, it's key->user would get put before
the ->destroy() callback is called, where the key is removed from it's
respective tracking structures.

This leaves a key hanging in a semi-invalid state which leaves a window open
for a different task to try an access key->user. An example is
find_keyring_by_name() which would dereference key->user for a key that is
in the process of being garbage collected (where key->user was freed but
->destroy() wasn't called yet - so it's still present in the linked list).

This would cause either a panic, or corrupt memory.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 security/keys/gc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/security/keys/gc.c b/security/keys/gc.c
index 9609a7f..c795237 100644
--- a/security/keys/gc.c
+++ b/security/keys/gc.c
@@ -148,12 +148,12 @@ static noinline void key_gc_unused_keys(struct list_head *keys)
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
1.7.10.4

