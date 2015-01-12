Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753982AbbALSOZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:14:25 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57718 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753789AbbALSGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:06:35 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 086/216] powerpc/book3s: Fix partial invalidation of TLBs in MCE code.
Date: Mon, 12 Jan 2015 18:03:23 +0000
Message-Id: <1421085933-32536-87-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>

commit 682e77c861c4c60f79ffbeae5e1938ffed24a575 upstream.

The existing MCE code calls flush_tlb hook with IS=0 (single page) resulting
in partial invalidation of TLBs which is not right. This patch fixes
that by passing IS=0xc00 to invalidate whole TLB for successful recovery
from TLB and ERAT errors.

Signed-off-by: Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/powerpc/kernel/mce_power.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kernel/mce_power.c b/arch/powerpc/kernel/mce_power.c
index aa9aff3d6ad3..b6f123ab90ed 100644
--- a/arch/powerpc/kernel/mce_power.c
+++ b/arch/powerpc/kernel/mce_power.c
@@ -79,7 +79,7 @@ static long mce_handle_derror(uint64_t dsisr, uint64_t slb_error_bits)
 	}
 	if (dsisr & P7_DSISR_MC_TLB_MULTIHIT_MFTLB) {
 		if (cur_cpu_spec && cur_cpu_spec->flush_tlb)
-			cur_cpu_spec->flush_tlb(TLBIEL_INVAL_PAGE);
+			cur_cpu_spec->flush_tlb(TLBIEL_INVAL_SET);
 		/* reset error bits */
 		dsisr &= ~P7_DSISR_MC_TLB_MULTIHIT_MFTLB;
 	}
@@ -110,7 +110,7 @@ static long mce_handle_common_ierror(uint64_t srr1)
 		break;
 	case P7_SRR1_MC_IFETCH_TLB_MULTIHIT:
 		if (cur_cpu_spec && cur_cpu_spec->flush_tlb) {
-			cur_cpu_spec->flush_tlb(TLBIEL_INVAL_PAGE);
+			cur_cpu_spec->flush_tlb(TLBIEL_INVAL_SET);
 			handled = 1;
 		}
 		break;
-- 
2.1.4

