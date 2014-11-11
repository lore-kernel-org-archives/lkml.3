Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752685AbaKKMAT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 07:00:19 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57298 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753708AbaKKLJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 06:09:40 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: David Daney <david.daney@cavium.com>, Huacai Chen <chenhc@lemote.com>,
        Fuxin Zhang <zhangfx@lemote.com>, Zhangjin Wu <wuzhangjin@gmail.com>,
        linux-mips@linux-mips.org, Ralf Baechle <ralf@linux-mips.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 039/170] MIPS: tlbex: Properly fix HUGE TLB Refill exception handler
Date: Tue, 11 Nov 2014 11:06:38 +0000
Message-Id: <1415704129-12709-40-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
References: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Daney <david.daney@cavium.com>

commit 9e0f162a36914937a937358fcb45e0609ef2bfc4 upstream.

In commit 8393c524a25609 (MIPS: tlbex: Fix a missing statement for
HUGETLB), the TLB Refill handler was fixed so that non-OCTEON targets
would work properly with huge pages.  The change was incorrect in that
it broke the OCTEON case.

The problem is shown here:

    xxx0:	df7a0000 	ld	k0,0(k1)
    .
    .
    .
    xxxc0:	df610000 	ld	at,0(k1)
    xxxc4:	335a0ff0 	andi	k0,k0,0xff0
    xxxc8:	e825ffcd 	bbit1	at,0x5,0x0
    xxxcc:	003ad82d 	daddu	k1,at,k0
    .
    .
    .

In the non-octeon case there is a destructive test for the huge PTE
bit, and then at 0, $k0 is reloaded (that is what the 8393c524a25609
patch added).

In the octeon case, we modify k1 in the branch delay slot, but we
never need k0 again, so the new load is not needed, but since k1 is
modified, if we do the load, we load from a garbage location and then
get a nested TLB Refill, which is seen in userspace as either SIGBUS
or SIGSEGV (depending on the garbage).

The real fix is to only do this reloading if it is needed, and never
where it is harmful.

Signed-off-by: David Daney <david.daney@cavium.com>
Cc: Huacai Chen <chenhc@lemote.com>
Cc: Fuxin Zhang <zhangfx@lemote.com>
Cc: Zhangjin Wu <wuzhangjin@gmail.com>
Cc: linux-mips@linux-mips.org
Patchwork: https://patchwork.linux-mips.org/patch/8151/
Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/mips/mm/tlbex.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/mips/mm/tlbex.c b/arch/mips/mm/tlbex.c
index 343fe0f559b1..b2e89a1aad68 100644
--- a/arch/mips/mm/tlbex.c
+++ b/arch/mips/mm/tlbex.c
@@ -1061,6 +1061,7 @@ static void build_update_entries(u32 **p, unsigned int tmp, unsigned int ptep)
 struct mips_huge_tlb_info {
 	int huge_pte;
 	int restore_scratch;
+	bool need_reload_pte;
 };
 
 static struct mips_huge_tlb_info
@@ -1075,6 +1076,7 @@ build_fast_tlb_refill_handler (u32 **p, struct uasm_label **l,
 
 	rv.huge_pte = scratch;
 	rv.restore_scratch = 0;
+	rv.need_reload_pte = false;
 
 	if (check_for_high_segbits) {
 		UASM_i_MFC0(p, tmp, C0_BADVADDR);
@@ -1263,6 +1265,7 @@ static void build_r4000_tlb_refill_handler(void)
 	} else {
 		htlb_info.huge_pte = K0;
 		htlb_info.restore_scratch = 0;
+		htlb_info.need_reload_pte = true;
 		vmalloc_mode = refill_noscratch;
 		/*
 		 * create the plain linear handler
@@ -1299,7 +1302,8 @@ static void build_r4000_tlb_refill_handler(void)
 	}
 #ifdef CONFIG_MIPS_HUGE_TLB_SUPPORT
 	uasm_l_tlb_huge_update(&l, p);
-	UASM_i_LW(&p, K0, 0, K1);
+	if (htlb_info.need_reload_pte)
+		UASM_i_LW(&p, htlb_info.huge_pte, 0, K1);
 	build_huge_update_entries(&p, htlb_info.huge_pte, K1);
 	build_huge_tlb_write_entry(&p, &l, &r, K0, tlb_random,
 				   htlb_info.restore_scratch);
-- 
2.1.0

