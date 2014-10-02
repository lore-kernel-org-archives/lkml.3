Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751788AbaJBJWD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 05:22:03 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:61664 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665AbaJBJWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 05:22:00 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-83-542d1933f655
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
To: zohar@linux.vnet.ibm.com, linux-ima-devel@lists.sourceforge.net,
        linux-security-module@vger.kernel.org, roberto.sassu@polito.it
Cc: linux-kernel@vger.kernel.org, dmitry.kasatkin@gmail.com,
        Dmitry Kasatkin <d.kasatkin@samsung.com>
Subject: [PATCH 1/1] ima: check ima_policy_flag in the ima_file_free() hook
Date: Thu, 02 Oct 2014 12:21:44 +0300
Message-id: <2b752cc0ffc2738b9b0b69878ca6c304a6e3eb4b.1412241704.git.d.kasatkin@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <542D0C33.2010700@polito.it>
References: <542D0C33.2010700@polito.it>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFJMWRmVeSWpSXmKPExsVy+t/xa7rGkrohBisfiVrc+ruX2eLL0jqL
	lzPmsVtc3jWHzeJDzyM2i5e7vrFbfFoxidmB3WPnrLvsHg8ObWbx2L3gM5PH6ZXFHn1bVjF6
	fN4kF8AWxWWTkpqTWZZapG+XwJXx+2YTY8ES4Ypnv28yNzBOEuhi5OSQEDCRWLuwhR3CFpO4
	cG89WxcjF4eQwFJGid+zGlggnE4mif7GM6wgVWwCehIbmn+wgyREBFoZJU5MWsoIkmAWSJf4
	NKkXbJSwgLfEz6NNTCA2i4CqRFPvQ7A4r0CcxM+tq5kg1slJnDw2GWwop4CmxJUdU5hBbCEB
	DYnn63+yTGDkXcDIsIpRNLU0uaA4KT3XUK84Mbe4NC9dLzk/dxMjJLy+7GBcfMzqEKMAB6MS
	D29Gg06IEGtiWXFl7iFGCQ5mJRHeX8K6IUK8KYmVValF+fFFpTmpxYcYmTg4pRoYN+x+L2q7
	4bSw8TYBnqyeh48jpL0YdjttduLpzjiWmhPiyXatSkTAc6vtRb4Cnce++ut3+Pyz+xi6hrnz
	2OsErX3xz0wcBRiu+XpzKC35LSr0/8uVIx7BTb4qGokv32nqrdzGVfmBMzk+YM56mf/fe+2c
	FCuzd8sIaW7K1Tz7vvNRdK7BxGAlluKMREMt5qLiRABC8fWxDQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ima_file_free() checks 'iint_initialized' unnecessarily, because
S_IMA flag would not be set if iint was not allocated. At the
same time integrity cache is allocated with SLAB_PANIC and kernel
will panic if allocation fails during kernel initialization.
So on running system iint_initialized is always true and can be
removed.

This patch uses lately introduced ima_policy_flag to test if IMA
is enabled by policy.

Changes in v3:
* not limiting test to IMA_APPRAISE (spotted by Roberto Sassu)

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
index 62f59ec..72faf0b 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -143,7 +143,7 @@ void ima_file_free(struct file *file)
 	struct inode *inode = file_inode(file);
 	struct integrity_iint_cache *iint;
 
-	if (!iint_initialized || !S_ISREG(inode->i_mode))
+	if (!ima_policy_flag || !S_ISREG(inode->i_mode))
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

