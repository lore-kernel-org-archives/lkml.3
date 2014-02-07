Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932551AbaBGLw0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 06:52:26 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42391 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754041AbaBGLwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:52:17 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Helge Deller <deller@gmx.de>, John David Anglin <dave.anglin@bell.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 200/233] parisc: fix cache-flushing
Date: Fri,  7 Feb 2014 11:46:59 +0000
Message-Id: <1391773652-25214-201-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
References: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Helge Deller <deller@gmx.de>

commit 57737c49dd72c96cfbcd4f66559f3ffc399aeb4f upstream.

This commit:
f8dae00684d678afa13041ef170cecfd1297ed40: parisc: Ensure full cache coherency for kmap/kunmap
caused negative caching side-effects, e.g. hanging processes with expect and
too many inequivalent alias messages from flush_dcache_page() on Debian 5 systems.

This patch now partly reverts it and has been in production use on our debian buildd
makeservers since a week without any major problems.

Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: John David Anglin <dave.anglin@bell.net>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/parisc/include/asm/cacheflush.h |  2 --
 arch/parisc/include/asm/page.h       |  3 ++-
 arch/parisc/kernel/cache.c           | 14 ++++++++++++++
 3 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/arch/parisc/include/asm/cacheflush.h b/arch/parisc/include/asm/cacheflush.h
index 2f9b751..de65f66 100644
--- a/arch/parisc/include/asm/cacheflush.h
+++ b/arch/parisc/include/asm/cacheflush.h
@@ -132,7 +132,6 @@ void mark_rodata_ro(void);
 static inline void *kmap(struct page *page)
 {
 	might_sleep();
-	flush_dcache_page(page);
 	return page_address(page);
 }
 
@@ -144,7 +143,6 @@ static inline void kunmap(struct page *page)
 static inline void *kmap_atomic(struct page *page)
 {
 	pagefault_disable();
-	flush_dcache_page(page);
 	return page_address(page);
 }
 
diff --git a/arch/parisc/include/asm/page.h b/arch/parisc/include/asm/page.h
index c53fc63..637fe03 100644
--- a/arch/parisc/include/asm/page.h
+++ b/arch/parisc/include/asm/page.h
@@ -29,7 +29,8 @@ struct page;
 void clear_page_asm(void *page);
 void copy_page_asm(void *to, void *from);
 #define clear_user_page(vto, vaddr, page) clear_page_asm(vto)
-#define copy_user_page(vto, vfrom, vaddr, page) copy_page_asm(vto, vfrom)
+void copy_user_page(void *vto, void *vfrom, unsigned long vaddr,
+			struct page *pg);
 
 /* #define CONFIG_PARISC_TMPALIAS */
 
diff --git a/arch/parisc/kernel/cache.c b/arch/parisc/kernel/cache.c
index a725455..ac87a40 100644
--- a/arch/parisc/kernel/cache.c
+++ b/arch/parisc/kernel/cache.c
@@ -388,6 +388,20 @@ void flush_kernel_dcache_page_addr(void *addr)
 }
 EXPORT_SYMBOL(flush_kernel_dcache_page_addr);
 
+void copy_user_page(void *vto, void *vfrom, unsigned long vaddr,
+	struct page *pg)
+{
+       /* Copy using kernel mapping.  No coherency is needed (all in
+	  kunmap) for the `to' page.  However, the `from' page needs to
+	  be flushed through a mapping equivalent to the user mapping
+	  before it can be accessed through the kernel mapping. */
+	preempt_disable();
+	flush_dcache_page_asm(__pa(vfrom), vaddr);
+	preempt_enable();
+	copy_page_asm(vto, vfrom);
+}
+EXPORT_SYMBOL(copy_user_page);
+
 void purge_tlb_entries(struct mm_struct *mm, unsigned long addr)
 {
 	unsigned long flags;
-- 
1.8.3.2

