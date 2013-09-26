Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751102Ab3IZNqa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 09:46:30 -0400
Received: from us02smtp1.synopsys.com ([198.182.60.75]:55788 "EHLO
	vaxjo.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939Ab3IZNq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 09:46:29 -0400
From: Mischa Jonker <Mischa.Jonker@synopsys.com>
To: Vineet.Gupta1@synopsys.com, linux-kernel@vger.kernel.org,
        arc-linux-dev@synopsys.com
Cc: Mischa Jonker <Mischa.Jonker@synopsys.com>
Subject: [PATCH] ARC: Fix array-out-of-bounds issue in tlb overlap handler
Date: Thu, 26 Sep 2013 15:46:22 +0200
Message-Id: <1380203182-5982-1-git-send-email-mjonker@synopsys.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Even after fixing the issue, GCC 4.8 still complains with a warning,
but with the fix, I think it's a false positive. Therefore I have
also added a #pragma to ignore the warning.

Signed-off-by: Mischa Jonker <mjonker@synopsys.com>
---
 arch/arc/mm/tlb.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/arc/mm/tlb.c b/arch/arc/mm/tlb.c
index 129af50..5af7c98 100644
--- a/arch/arc/mm/tlb.c
+++ b/arch/arc/mm/tlb.c
@@ -635,13 +635,20 @@ void do_tlb_overlap_fault(unsigned long cause, unsigned long address,
 			continue;
 
 		/* Scan the set for duplicate ways: needs a nested loop */
-		for (way = 0; way < mmu->ways; way++) {
+		for (way = 0; way < (mmu->ways - 1); way++) {
 			if (!pd0[way])
 				continue;
 
 			for (n = way + 1; n < mmu->ways; n++) {
+/*
+ * GCC 4.8 does not understand that way < (mmu->ways - 1), and as such
+ * n < mmu->ways. So, ignore the warning
+ */
+#pragma GCC diagnostic push
+#pragma GCC diagnostic ignored "-Warray-bounds"
 				if ((pd0[way] & PAGE_MASK) ==
 				    (pd0[n] & PAGE_MASK)) {
+#pragma GCC diagnostic pop
 
 					if (dup_pd_verbose) {
 						pr_info("Duplicate PD's @"
-- 
1.7.9.5

