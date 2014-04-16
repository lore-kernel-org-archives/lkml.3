Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756104AbaDPLr2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 07:47:28 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:56580 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756005AbaDPLq4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 07:46:56 -0400
From: Steve Capper <steve.capper@linaro.org>
To: linux@arm.linux.org.uk, akpm@linux-foundation.org
Cc: will.deacon@arm.com, catalin.marinas@arm.com, robherring2@gmail.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, gerald.schaefer@de.ibm.com,
        Steve Capper <steve.capper@linaro.org>
Subject: [PATCH V2 3/5] arm: mm: Make mmu_gather aware of huge pages
Date: Wed, 16 Apr 2014 12:46:41 +0100
Message-Id: <1397648803-15961-4-git-send-email-steve.capper@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1397648803-15961-1-git-send-email-steve.capper@linaro.org>
References: <1397648803-15961-1-git-send-email-steve.capper@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Huge pages on short descriptors are arranged as pairs of 1MB sections.
We need to be careful and ensure that the TLBs for both sections are
flushed when we tlb_add_flush on a HugeTLB page.

This patch extends the tlb flush range to HPAGE_SIZE rather than
PAGE_SIZE when addresses belonging to huge page VMAs are added to
the flush range.

Signed-off-by: Steve Capper <steve.capper@linaro.org>
---
 arch/arm/include/asm/tlb.h | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/arm/include/asm/tlb.h b/arch/arm/include/asm/tlb.h
index 0baf7f0..b2498e6 100644
--- a/arch/arm/include/asm/tlb.h
+++ b/arch/arm/include/asm/tlb.h
@@ -81,10 +81,17 @@ static inline void tlb_flush(struct mmu_gather *tlb)
 static inline void tlb_add_flush(struct mmu_gather *tlb, unsigned long addr)
 {
 	if (!tlb->fullmm) {
+		unsigned long size = PAGE_SIZE;
+
 		if (addr < tlb->range_start)
 			tlb->range_start = addr;
-		if (addr + PAGE_SIZE > tlb->range_end)
-			tlb->range_end = addr + PAGE_SIZE;
+
+		if (!config_enabled(CONFIG_ARM_LPAE) && tlb->vma
+				&& is_vm_hugetlb_page(tlb->vma))
+			size = HPAGE_SIZE;
+
+		if (addr + size > tlb->range_end)
+			tlb->range_end = addr + size;
 	}
 }
 
-- 
1.8.1.4

