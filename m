Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757180AbaAFXBD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 18:01:03 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:48558 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933229AbaAFWmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:42:04 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Mark Brown <broonie@kernel.org>
Subject: [PATCH 3.10 127/129] arm64: Avoid cache flushing in flush_dcache_page()
Date: Mon,  6 Jan 2014 14:39:16 -0800
Message-Id: <20140106223903.228763015@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140106223859.589799655@linuxfoundation.org>
References: <20140106223859.589799655@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Catalin Marinas <catalin.marinas@arm.com>

commit b5b6c9e9149d8a7c3f1d7b9d0c046c6184e1dd17 upstream.

The flush_dcache_page() function is called when the kernel modified a
page cache page. Since the D-cache on AArch64 does not have aliases
this function can simply mark the page as dirty for later flushing via
set_pte_at()/__sync_icache_dcache() if the page is executable (to ensure
the I-D cache coherency).

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Reported-by: Will Deacon <will.deacon@arm.com>
Acked-by: Will Deacon <will.deacon@arm.com>
Cc: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/mm/flush.c |   22 ++++------------------
 1 file changed, 4 insertions(+), 18 deletions(-)

--- a/arch/arm64/mm/flush.c
+++ b/arch/arm64/mm/flush.c
@@ -94,28 +94,14 @@ void __sync_icache_dcache(pte_t pte, uns
 }
 
 /*
- * Ensure cache coherency between kernel mapping and userspace mapping of this
- * page.
+ * This function is called when a page has been modified by the kernel. Mark
+ * it as dirty for later flushing when mapped in user space (if executable,
+ * see __sync_icache_dcache).
  */
 void flush_dcache_page(struct page *page)
 {
-	struct address_space *mapping;
-
-	/*
-	 * The zero page is never written to, so never has any dirty cache
-	 * lines, and therefore never needs to be flushed.
-	 */
-	if (page == ZERO_PAGE(0))
-		return;
-
-	mapping = page_mapping(page);
-	if (mapping && mapping_mapped(mapping)) {
-		__flush_dcache_page(page);
-		__flush_icache_all();
-		set_bit(PG_dcache_clean, &page->flags);
-	} else {
+	if (test_bit(PG_dcache_clean, &page->flags))
 		clear_bit(PG_dcache_clean, &page->flags);
-	}
 }
 EXPORT_SYMBOL(flush_dcache_page);
 


