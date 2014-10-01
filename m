Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754101AbaJASnx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 14:43:53 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:49505 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753898AbaJASnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 14:43:11 -0400
From: Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
X-Google-Original-From: Dmitry Kasatkin <d.kasatkin@samsung.com>
To: zohar@linux.vnet.ibm.com, linux-ima-devel@lists.sourceforge.net,
        linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Dmitry Kasatkin <d.kasatkin@samsung.com>
Subject: [PATCH v2 3/4] ima: check appraisal flag in the ima_file_free() hook
Date: Wed,  1 Oct 2014 21:43:09 +0300
Message-Id: <600aeb6a5b8eca7eb381392e142ca71484717e9c.1412188590.git.d.kasatkin@samsung.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <cover.1412188590.git.d.kasatkin@samsung.com>
References: <cover.1412188590.git.d.kasatkin@samsung.com>
In-Reply-To: <cover.1412188590.git.d.kasatkin@samsung.com>
References: <cover.1412188590.git.d.kasatkin@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ima_file_free() hook is only used by appraisal module to update hash
when file was modified. When there were no integrity checks on inode,
S_IMA flag is not set, integrity_iint_find() returns NULL and it
quits. When inode is only measured/audited but not appraised, iint
is allocated and it will cause calling ima_check_last_writer() which
unnecessarily locks i_mutex.

Currently ima_file_free() checks 'iint_initialized'. But it looks that
it is a mistake and originally 'ima_appraise' had to be used instead.
In fact usage of 'iint_initialized' is completely unnecessary because
S_IMA flag would not be set if iint was not allocated.

This patch uses lately introduced ima_policy_flag to test if appraisal
was enabled by policy.

With this change 'iint_initialized' is no longer used anywhere. Indeed,
integrity cache is allocated with SLAB_PANIC and kernel will panic if
allocation fails during kernel initialization. So this variable is
unnecessary and thus this patch removes it.

Changes in v2:
* 'iint_initialized' removal patch merged to this patch (requested
   by Mimi)

Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
---
 security/integrity/iint.c         | 3 ---
 security/integrity/ima/ima_main.c | 2 +-
 security/integrity/integrity.h    | 3 ---
 3 files changed, 1 insertion(+), 7 deletions(-)

diff --git a/security/integrity/iint.c b/security/integrity/iint.c
index a521edf..cc3eb4d 100644
--- a/security/integrity/iint.c
+++ b/security/integrity/iint.c
@@ -25,8 +25,6 @@ static struct rb_root integrity_iint_tree = RB_ROOT;
 static DEFINE_RWLOCK(integrity_iint_lock);
 static struct kmem_cache *iint_cache __read_mostly;
 
-int iint_initialized;
-
 /*
  * __integrity_iint_find - return the iint associated with an inode
  */
@@ -166,7 +164,6 @@ static int __init integrity_iintcache_init(void)
 	iint_cache =
 	    kmem_cache_create("iint_cache", sizeof(struct integrity_iint_cache),
 			      0, SLAB_PANIC, init_once);
-	iint_initialized = 1;
 	return 0;
 }
 security_initcall(integrity_iintcache_init);
diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index 62f59ec..87d7df7 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -143,7 +143,7 @@ void ima_file_free(struct file *file)
 	struct inode *inode = file_inode(file);
 	struct integrity_iint_cache *iint;
 
-	if (!iint_initialized || !S_ISREG(inode->i_mode))
+	if (!(ima_policy_flag & IMA_APPRAISE) || !S_ISREG(inode->i_mode))
 		return;
 
 	iint = integrity_iint_find(inode);
diff --git a/security/integrity/integrity.h b/security/integrity/integrity.h
index aafb468..f51ad65 100644
--- a/security/integrity/integrity.h
+++ b/security/integrity/integrity.h
@@ -169,6 +169,3 @@ static inline void integrity_audit_msg(int audit_msgno, struct inode *inode,
 {
 }
 #endif
-
-/* set during initialization */
-extern int iint_initialized;
-- 
1.9.1

