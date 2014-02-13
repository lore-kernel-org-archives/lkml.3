Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752039AbaBMVPN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 16:15:13 -0500
Received: from mail.windriver.com ([147.11.1.11]:37399 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511AbaBMVPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 16:15:12 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <sparclinux@vger.kernel.org>
CC: "David S. Miller" <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH] sparc32: make copy_to/from_user_page() usable from modular code
Date: Thu, 13 Feb 2014 16:15:01 -0500
Message-ID: <1392326101-20388-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While copy_to/from_user_page() users are uncommon, there is one in
drivers/staging/lustre/lustre/libcfs/linux/linux-curproc.c which leads
to the following:

ERROR: "sparc32_cachetlb_ops" [drivers/staging/lustre/lustre/libcfs/libcfs.ko] undefined!

during routine allmodconfig build coverage.  The reason this happens
is as follows:

In arch/sparc/include/asm/cacheflush_32.h we have:

 #define flush_cache_page(vma,addr,pfn) \
        sparc32_cachetlb_ops->cache_page(vma, addr)

 #define copy_to_user_page(vma, page, vaddr, dst, src, len) \
        do {                                                    \
                flush_cache_page(vma, vaddr, page_to_pfn(page));\
                memcpy(dst, src, len);                          \
        } while (0)
 #define copy_from_user_page(vma, page, vaddr, dst, src, len) \
        do {                                                    \
                flush_cache_page(vma, vaddr, page_to_pfn(page));\
                memcpy(dst, src, len);                          \
        } while (0)

However, sparc32_cachetlb_ops isn't exported and hence the error.

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/sparc/mm/srmmu.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/sparc/mm/srmmu.c b/arch/sparc/mm/srmmu.c
index 869023abe5a4..cfbe53c17b0d 100644
--- a/arch/sparc/mm/srmmu.c
+++ b/arch/sparc/mm/srmmu.c
@@ -14,6 +14,7 @@
 #include <linux/pagemap.h>
 #include <linux/vmalloc.h>
 #include <linux/kdebug.h>
+#include <linux/export.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/log2.h>
@@ -62,6 +63,7 @@ extern unsigned long last_valid_pfn;
 static pgd_t *srmmu_swapper_pg_dir;
 
 const struct sparc32_cachetlb_ops *sparc32_cachetlb_ops;
+EXPORT_SYMBOL(sparc32_cachetlb_ops);
 
 #ifdef CONFIG_SMP
 const struct sparc32_cachetlb_ops *local_ops;
-- 
1.8.5.2

