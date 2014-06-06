Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752212AbaFFKaV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 06:30:21 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:59971 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751905AbaFFKaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 06:30:17 -0400
From: Leif Lindholm <leif.lindholm@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: msalter@redhat.com, catalin.marinas@arm.com, will.deacon@arm.com,
        steve.capper@linaro.org
Subject: [PATCH] arm64: Add flush_cache_vmap call in __early_set_fixmap
Date: Fri,  6 Jun 2014 11:29:50 +0100
Message-Id: <1402050590-23877-1-git-send-email-leif.lindholm@linaro.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__early_set_fixmap does not do any synchronization when called to set a
fixmap entry. Add call to flush_vmap_cache().

Tested on hardware.

Signed-off-by: Leif Lindholm <leif.lindholm@linaro.org>
Tested-by: Graeme Gregory <graeme.gregory@linaro.org>
Cc: Steve Capper <steve.capper@linaro.org>
---
 arch/arm64/mm/ioremap.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/mm/ioremap.c b/arch/arm64/mm/ioremap.c
index 7ec3283..5b8766c 100644
--- a/arch/arm64/mm/ioremap.c
+++ b/arch/arm64/mm/ioremap.c
@@ -176,9 +176,10 @@ void __init __early_set_fixmap(enum fixed_addresses idx,
 
 	pte = early_ioremap_pte(addr);
 
-	if (pgprot_val(flags))
+	if (pgprot_val(flags)) {
 		set_pte(pte, pfn_pte(phys >> PAGE_SHIFT, flags));
-	else {
+		flush_cache_vmap(addr, addr + PAGE_SIZE);
+	} else {
 		pte_clear(&init_mm, addr, pte);
 		flush_tlb_kernel_range(addr, addr+PAGE_SIZE);
 	}
-- 
1.7.10.4

