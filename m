Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757150AbaAFXAf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 18:00:35 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:48562 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933238AbaAFWmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:42:04 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Mark Brown <broonie@kernel.org>
Subject: [PATCH 3.10 128/129] arm64: Do not flush the D-cache for anonymous pages
Date: Mon,  6 Jan 2014 14:39:17 -0800
Message-Id: <20140106223903.256932537@linuxfoundation.org>
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

commit 7249b79f6b4cc3c2aa9138dca52e535a4c789107 upstream.

The D-cache on AArch64 is VIPT non-aliasing, so there is no need to
flush it for anonymous pages.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Reported-by: Will Deacon <will.deacon@arm.com>
Acked-by: Will Deacon <will.deacon@arm.com>
Cc: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/mm/flush.c |    8 +++-----
 arch/arm64/mm/mmu.c   |    1 -
 2 files changed, 3 insertions(+), 6 deletions(-)

--- a/arch/arm64/mm/flush.c
+++ b/arch/arm64/mm/flush.c
@@ -77,14 +77,12 @@ void __flush_dcache_page(struct page *pa
 
 void __sync_icache_dcache(pte_t pte, unsigned long addr)
 {
-	unsigned long pfn;
-	struct page *page;
+	struct page *page = pte_page(pte);
 
-	pfn = pte_pfn(pte);
-	if (!pfn_valid(pfn))
+	/* no flushing needed for anonymous pages */
+	if (!page_mapping(page))
 		return;
 
-	page = pfn_to_page(pfn);
 	if (!test_and_set_bit(PG_dcache_clean, &page->flags)) {
 		__flush_dcache_page(page);
 		__flush_icache_all();
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -339,7 +339,6 @@ void __init paging_init(void)
 	bootmem_init();
 
 	empty_zero_page = virt_to_page(zero_page);
-	__flush_dcache_page(empty_zero_page);
 
 	/*
 	 * TTBR0 is only used for the identity mapping at this stage. Make it


