Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932696Ab3AOWfZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 17:35:25 -0500
Received: from mail.kernel.org ([198.145.19.201]:43492 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932683Ab3AOWfV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:35:21 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Jayachandran C <jchandra@broadcom.com>
Subject: [ 184/221] Revert "MIPS: Optimise TLB handlers for MIPS32/64 R2 cores."
Date: Tue, 15 Jan 2013 10:51:51 -0800
Message-Id: <20130115185011.297977190@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115184958.025580322@linuxfoundation.org>
References: <20130115184958.025580322@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ralf Baechle <ralf@linux-mips.org>

commit 9120963578320532dfb3a9a7947e8d05b39900b5 upstream.

This reverts commit ff401e52100dcdc85e572d1ad376d3307b3fe28e.

This breaks on MIPS64 R2 cores such as Broadcom's.

Signed-off-by: Jayachandran C <jchandra@broadcom.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/mips/mm/tlbex.c |   16 ----------------
 1 file changed, 16 deletions(-)

--- a/arch/mips/mm/tlbex.c
+++ b/arch/mips/mm/tlbex.c
@@ -952,13 +952,6 @@ build_get_pgde32(u32 **p, unsigned int t
 #endif
 	uasm_i_mfc0(p, tmp, C0_BADVADDR); /* get faulting address */
 	uasm_i_lw(p, ptr, uasm_rel_lo(pgdc), ptr);
-
-	if (cpu_has_mips_r2) {
-		uasm_i_ext(p, tmp, tmp, PGDIR_SHIFT, (32 - PGDIR_SHIFT));
-		uasm_i_ins(p, ptr, tmp, PGD_T_LOG2, (32 - PGDIR_SHIFT));
-		return;
-	}
-
 	uasm_i_srl(p, tmp, tmp, PGDIR_SHIFT); /* get pgd only bits */
 	uasm_i_sll(p, tmp, tmp, PGD_T_LOG2);
 	uasm_i_addu(p, ptr, ptr, tmp); /* add in pgd offset */
@@ -994,15 +987,6 @@ static void __cpuinit build_adjust_conte
 
 static void __cpuinit build_get_ptep(u32 **p, unsigned int tmp, unsigned int ptr)
 {
-	if (cpu_has_mips_r2) {
-		/* PTE ptr offset is obtained from BadVAddr */
-		UASM_i_MFC0(p, tmp, C0_BADVADDR);
-		UASM_i_LW(p, ptr, 0, ptr);
-		uasm_i_ext(p, tmp, tmp, PAGE_SHIFT+1, PGDIR_SHIFT-PAGE_SHIFT-1);
-		uasm_i_ins(p, ptr, tmp, PTE_T_LOG2+1, PGDIR_SHIFT-PAGE_SHIFT-1);
-		return;
-	}
-
 	/*
 	 * Bug workaround for the Nevada. It seems as if under certain
 	 * circumstances the move from cp0_context might produce a


