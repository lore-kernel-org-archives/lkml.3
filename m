Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752633Ab3FZCta (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 22:49:30 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54113 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751458Ab3FZCpY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 22:45:24 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Catalin Marinas" <catalin.marinas@arm.com>,
        "Russell King" <rmk+kernel@arm.linux.org.uk>,
        "Simon Baatz" <gmbnomis@gmail.com>
Date: Wed, 26 Jun 2013 03:35:58 +0100
Message-ID: <lsq.1372214158.657310117@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [04/26] ARM: 7755/1: handle user space mapped pages in
 flush_kernel_dcache_page
In-Reply-To: <lsq.1372214158.425780530@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.48-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/arm/include/asm/cacheflush.h |    4 +---
 arch/arm/mm/flush.c               |   33 +++++++++++++++++++++++++++++++++
 2 files changed, 34 insertions(+), 3 deletions(-)

--- a/arch/arm/include/asm/cacheflush.h
+++ b/arch/arm/include/asm/cacheflush.h
@@ -301,9 +301,7 @@ static inline void flush_anon_page(struc
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
@@ -304,6 +304,39 @@ void flush_dcache_page(struct page *page
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

