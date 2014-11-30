Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751863AbaK3DYg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2014 22:24:36 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:27841 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660AbaK3DYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2014 22:24:35 -0500
From: Sasha Levin <sasha.levin@oracle.com>
To: dhowells@redhat.com, james.l.morris@oracle.com, serge@hallyn.com
Cc: keyrings@linux-nfs.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH] KEYS: Destroy by key type before removing the rest of the key
Date: Sat, 29 Nov 2014 22:24:14 -0500
Message-Id: <1417317854-11799-1-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 2.1.0
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should make sure that the key type does it's destruction dance first
before we start tearing down the key structure itself so that we won't
have a live key in a semi-coherent state.

This would prevent a race between key destruction and lookup in the
keyring case, resulting in a use-after-free.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 security/keys/gc.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/security/keys/gc.c b/security/keys/gc.c
index 9609a7f..8f3b518 100644
--- a/security/keys/gc.c
+++ b/security/keys/gc.c
@@ -134,6 +134,9 @@ static noinline void key_gc_unused_keys(struct list_head *keys)
 		kdebug("- %u", key->serial);
 		key_check(key);
 
+		if (key->type->destroy)
+			key->type->destroy(key);
+
 		security_key_free(key);
 
 		/* deal with the user's key tracking and quota */
@@ -151,9 +154,6 @@ static noinline void key_gc_unused_keys(struct list_head *keys)
 		key_user_put(key->user);
 
 		/* now throw away the key memory */
-		if (key->type->destroy)
-			key->type->destroy(key);
-
 		kfree(key->description);
 
 #ifdef KEY_DEBUGGING
-- 
1.7.10.4

