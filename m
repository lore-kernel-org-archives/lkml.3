Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934869AbaBDVYr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 16:24:47 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57478 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934698AbaBDVMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 16:12:37 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Helge Deller <deller@gmx.de>, John David Anglin <dave.anglin@bell.net>
Subject: [PATCH 3.13 125/140] parisc: fix cache-flushing
Date: Tue,  4 Feb 2014 13:11:52 -0800
Message-Id: <20140204211040.542649214@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140204211036.967663852@linuxfoundation.org>
References: <20140204211036.967663852@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/parisc/include/asm/cacheflush.h |    2 --
 arch/parisc/include/asm/page.h       |    3 ++-
 arch/parisc/kernel/cache.c           |   14 ++++++++++++++
 3 files changed, 16 insertions(+), 3 deletions(-)

--- a/arch/parisc/include/asm/cacheflush.h
+++ b/arch/parisc/include/asm/cacheflush.h
@@ -132,7 +132,6 @@ void mark_rodata_ro(void);
 static inline void *kmap(struct page *page)
 {
 	might_sleep();
-	flush_dcache_page(page);
 	return page_address(page);
 }
 
@@ -144,7 +143,6 @@ static inline void kunmap(struct page *p
 static inline void *kmap_atomic(struct page *page)
 {
 	pagefault_disable();
-	flush_dcache_page(page);
 	return page_address(page);
 }
 
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
 
--- a/arch/parisc/kernel/cache.c
+++ b/arch/parisc/kernel/cache.c
@@ -388,6 +388,20 @@ void flush_kernel_dcache_page_addr(void
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


