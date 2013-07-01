Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755805Ab3GAURQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 16:17:16 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49082 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755485Ab3GAUKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 16:10:43 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Simon Baatz <gmbnomis@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [ 01/13] ARM: 7755/1: handle user space mapped pages in flush_kernel_dcache_page
Date: Mon,  1 Jul 2013 13:10:20 -0700
Message-Id: <20130701200523.286498742@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130701200523.096669485@linuxfoundation.org>
References: <20130701200523.096669485@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Simon Baatz <gmbnomis@gmail.com>

commit 1bc39742aab09248169ef9d3727c9def3528b3f3 upstream.

Commit f8b63c1 made flush_kernel_dcache_page a no-op assuming that
the pages it needs to handle are kernel mapped only.  However, for
example when doing direct I/O, pages with user space mappings may
occur.

Thus, continue to do lazy flushing if there are no user space
mappings.  Otherwise, flush the kernel cache lines directly.

Signed-off-by: Simon Baatz <gmbnomis@gmail.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/include/asm/cacheflush.h |    4 +---
 arch/arm/mm/flush.c               |   33 +++++++++++++++++++++++++++++++++
 2 files changed, 34 insertions(+), 3 deletions(-)

--- a/arch/arm/include/asm/cacheflush.h
+++ b/arch/arm/include/asm/cacheflush.h
@@ -305,9 +305,7 @@ static inline void flush_anon_page(struc
 }
 
 #define ARCH_HAS_FLUSH_KERNEL_DCACHE_PAGE
-static inline void flush_kernel_dcache_page(struct page *page)
-{
-}
+extern void flush_kernel_dcache_page(struct page *);
 
 #define flush_dcache_mmap_lock(mapping) \
 	spin_lock_irq(&(mapping)->tree_lock)
--- a/arch/arm/mm/flush.c
+++ b/arch/arm/mm/flush.c
@@ -299,6 +299,39 @@ void flush_dcache_page(struct page *page
 EXPORT_SYMBOL(flush_dcache_page);
 
 /*
+ * Ensure cache coherency for the kernel mapping of this page. We can
+ * assume that the page is pinned via kmap.
+ *
+ * If the page only exists in the page cache and there are no user
+ * space mappings, this is a no-op since the page was already marked
+ * dirty at creation.  Otherwise, we need to flush the dirty kernel
+ * cache lines directly.
+ */
+void flush_kernel_dcache_page(struct page *page)
+{
+	if (cache_is_vivt() || cache_is_vipt_aliasing()) {
+		struct address_space *mapping;
+
+		mapping = page_mapping(page);
+
+		if (!mapping || mapping_mapped(mapping)) {
+			void *addr;
+
+			addr = page_address(page);
+			/*
+			 * kmap_atomic() doesn't set the page virtual
+			 * address for highmem pages, and
+			 * kunmap_atomic() takes care of cache
+			 * flushing already.
+			 */
+			if (!IS_ENABLED(CONFIG_HIGHMEM) || addr)
+				__cpuc_flush_dcache_area(addr, PAGE_SIZE);
+		}
+	}
+}
+EXPORT_SYMBOL(flush_kernel_dcache_page);
+
+/*
  * Flush an anonymous page so that users of get_user_pages()
  * can safely access the data.  The expected sequence is:
  *


