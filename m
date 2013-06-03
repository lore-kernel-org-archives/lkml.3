Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760007Ab3FCWca (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 18:32:30 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:6009 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759715Ab3FCWaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 18:30:11 -0400
X-Authority-Analysis: v=2.0 cv=H8VZMpki c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=eOv55hH2Cb4A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=UmiSj7iJHQMA:10 a=FBHGMhGWAAAA:8 a=qKut6vf5NQ5U0iUWEcgA:9 a=j9nzo_0lS1QA:10 a=_RhRFcbxBZMA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130603221202.015994447@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 03 Jun 2013 18:11:13 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: John David Anglin <dave.anglin@bell.net>, Helge Deller <deller@gmx.de>
Subject: [57/65] parisc: fix SMP races when updating PTE and TLB entries in entry.S
References: <20130603221016.243553628@goodmis.org>
Content-Disposition: inline; filename=0057-parisc-fix-SMP-races-when-updating-PTE-and-TLB-entri.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.5 stable review patch.
If anyone has any objections, please let me know.

------------------

From: John David Anglin <dave.anglin@bell.net>

[ Upstream commit f0a18819e261afc5fdbd8c5c6f9943123c5461ba ]

Currently, race conditions exist in the handling of TLB interruptions in
entry.S.  In particular, dirty bit updates can be lost if an accessed
interruption occurs just after the dirty bit interruption on a different
cpu.  Lost dirty bit updates result in user pages not being flushed and
general system instability.  This change adds lock and unlock macros to
synchronize all PTE and TLB updates done in entry.S.  As a result,
userspace stability is significantly improved.

Signed-off-by: John David Anglin  <dave.anglin@bell.net>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/parisc/kernel/entry.S |  155 ++++++++++++++++++++++++--------------------
 1 file changed, 83 insertions(+), 72 deletions(-)

diff --git a/arch/parisc/kernel/entry.S b/arch/parisc/kernel/entry.S
index 38a4998..1818c65 100644
--- a/arch/parisc/kernel/entry.S
+++ b/arch/parisc/kernel/entry.S
@@ -444,9 +444,41 @@
 	L2_ptep		\pgd,\pte,\index,\va,\fault
 	.endm
 
+	/* Acquire pa_dbit_lock lock. */
+	.macro		dbit_lock	spc,tmp,tmp1
+#ifdef CONFIG_SMP
+	cmpib,COND(=),n	0,\spc,2f
+	load32		PA(pa_dbit_lock),\tmp
+1:	LDCW		0(\tmp),\tmp1
+	cmpib,COND(=)	0,\tmp1,1b
+	nop
+2:
+#endif
+	.endm
+
+	/* Release pa_dbit_lock lock without reloading lock address. */
+	.macro		dbit_unlock0	spc,tmp
+#ifdef CONFIG_SMP
+	or,COND(=)	%r0,\spc,%r0
+	stw             \spc,0(\tmp)
+#endif
+	.endm
+
+	/* Release pa_dbit_lock lock. */
+	.macro		dbit_unlock1	spc,tmp
+#ifdef CONFIG_SMP
+	load32		PA(pa_dbit_lock),\tmp
+	dbit_unlock0	\spc,\tmp
+#endif
+	.endm
+
 	/* Set the _PAGE_ACCESSED bit of the PTE.  Be clever and
 	 * don't needlessly dirty the cache line if it was already set */
-	.macro		update_ptep	ptep,pte,tmp,tmp1
+	.macro		update_ptep	spc,ptep,pte,tmp,tmp1
+#ifdef CONFIG_SMP
+	or,COND(=)	%r0,\spc,%r0
+	LDREG		0(\ptep),\pte
+#endif
 	ldi		_PAGE_ACCESSED,\tmp1
 	or		\tmp1,\pte,\tmp
 	and,COND(<>)	\tmp1,\pte,%r0
@@ -455,7 +487,11 @@
 
 	/* Set the dirty bit (and accessed bit).  No need to be
 	 * clever, this is only used from the dirty fault */
-	.macro		update_dirty	ptep,pte,tmp
+	.macro		update_dirty	spc,ptep,pte,tmp
+#ifdef CONFIG_SMP
+	or,COND(=)	%r0,\spc,%r0
+	LDREG		0(\ptep),\pte
+#endif
 	ldi		_PAGE_ACCESSED|_PAGE_DIRTY,\tmp
 	or		\tmp,\pte,\pte
 	STREG		\pte,0(\ptep)
@@ -1187,11 +1223,13 @@ dtlb_miss_20w:
 
 	L3_ptep		ptp,pte,t0,va,dtlb_check_alias_20w
 
-	update_ptep	ptp,pte,t0,t1
+	dbit_lock	spc,t0,t1
+	update_ptep	spc,ptp,pte,t0,t1
 
 	make_insert_tlb	spc,pte,prot
 	
 	idtlbt          pte,prot
+	dbit_unlock1	spc,t0
 
 	rfir
 	nop
@@ -1211,11 +1249,13 @@ nadtlb_miss_20w:
 
 	L3_ptep		ptp,pte,t0,va,nadtlb_check_alias_20w
 
-	update_ptep	ptp,pte,t0,t1
+	dbit_lock	spc,t0,t1
+	update_ptep	spc,ptp,pte,t0,t1
 
 	make_insert_tlb	spc,pte,prot
 
 	idtlbt          pte,prot
+	dbit_unlock1	spc,t0
 
 	rfir
 	nop
@@ -1237,7 +1277,8 @@ dtlb_miss_11:
 
 	L2_ptep		ptp,pte,t0,va,dtlb_check_alias_11
 
-	update_ptep	ptp,pte,t0,t1
+	dbit_lock	spc,t0,t1
+	update_ptep	spc,ptp,pte,t0,t1
 
 	make_insert_tlb_11	spc,pte,prot
 
@@ -1248,6 +1289,7 @@ dtlb_miss_11:
 	idtlbp		prot,(%sr1,va)
 
 	mtsp		t0, %sr1	/* Restore sr1 */
+	dbit_unlock1	spc,t0
 
 	rfir
 	nop
@@ -1268,7 +1310,8 @@ nadtlb_miss_11:
 
 	L2_ptep		ptp,pte,t0,va,nadtlb_check_alias_11
 
-	update_ptep	ptp,pte,t0,t1
+	dbit_lock	spc,t0,t1
+	update_ptep	spc,ptp,pte,t0,t1
 
 	make_insert_tlb_11	spc,pte,prot
 
@@ -1280,6 +1323,7 @@ nadtlb_miss_11:
 	idtlbp		prot,(%sr1,va)
 
 	mtsp		t0, %sr1	/* Restore sr1 */
+	dbit_unlock1	spc,t0
 
 	rfir
 	nop
@@ -1300,13 +1344,15 @@ dtlb_miss_20:
 
 	L2_ptep		ptp,pte,t0,va,dtlb_check_alias_20
 
-	update_ptep	ptp,pte,t0,t1
+	dbit_lock	spc,t0,t1
+	update_ptep	spc,ptp,pte,t0,t1
 
 	make_insert_tlb	spc,pte,prot
 
 	f_extend	pte,t0
 
 	idtlbt          pte,prot
+	dbit_unlock1	spc,t0
 
 	rfir
 	nop
@@ -1326,13 +1372,15 @@ nadtlb_miss_20:
 
 	L2_ptep		ptp,pte,t0,va,nadtlb_check_alias_20
 
-	update_ptep	ptp,pte,t0,t1
+	dbit_lock	spc,t0,t1
+	update_ptep	spc,ptp,pte,t0,t1
 
 	make_insert_tlb	spc,pte,prot
 
 	f_extend	pte,t0
 	
         idtlbt          pte,prot
+	dbit_unlock1	spc,t0
 
 	rfir
 	nop
@@ -1433,11 +1481,13 @@ itlb_miss_20w:
 
 	L3_ptep		ptp,pte,t0,va,itlb_fault
 
-	update_ptep	ptp,pte,t0,t1
+	dbit_lock	spc,t0,t1
+	update_ptep	spc,ptp,pte,t0,t1
 
 	make_insert_tlb	spc,pte,prot
 	
 	iitlbt          pte,prot
+	dbit_unlock1	spc,t0
 
 	rfir
 	nop
@@ -1455,11 +1505,13 @@ naitlb_miss_20w:
 
 	L3_ptep		ptp,pte,t0,va,naitlb_check_alias_20w
 
-	update_ptep	ptp,pte,t0,t1
+	dbit_lock	spc,t0,t1
+	update_ptep	spc,ptp,pte,t0,t1
 
 	make_insert_tlb	spc,pte,prot
 
 	iitlbt          pte,prot
+	dbit_unlock1	spc,t0
 
 	rfir
 	nop
@@ -1481,7 +1533,8 @@ itlb_miss_11:
 
 	L2_ptep		ptp,pte,t0,va,itlb_fault
 
-	update_ptep	ptp,pte,t0,t1
+	dbit_lock	spc,t0,t1
+	update_ptep	spc,ptp,pte,t0,t1
 
 	make_insert_tlb_11	spc,pte,prot
 
@@ -1492,6 +1545,7 @@ itlb_miss_11:
 	iitlbp		prot,(%sr1,va)
 
 	mtsp		t0, %sr1	/* Restore sr1 */
+	dbit_unlock1	spc,t0
 
 	rfir
 	nop
@@ -1503,7 +1557,8 @@ naitlb_miss_11:
 
 	L2_ptep		ptp,pte,t0,va,naitlb_check_alias_11
 
-	update_ptep	ptp,pte,t0,t1
+	dbit_lock	spc,t0,t1
+	update_ptep	spc,ptp,pte,t0,t1
 
 	make_insert_tlb_11	spc,pte,prot
 
@@ -1514,6 +1569,7 @@ naitlb_miss_11:
 	iitlbp		prot,(%sr1,va)
 
 	mtsp		t0, %sr1	/* Restore sr1 */
+	dbit_unlock1	spc,t0
 
 	rfir
 	nop
@@ -1535,13 +1591,15 @@ itlb_miss_20:
 
 	L2_ptep		ptp,pte,t0,va,itlb_fault
 
-	update_ptep	ptp,pte,t0,t1
+	dbit_lock	spc,t0,t1
+	update_ptep	spc,ptp,pte,t0,t1
 
 	make_insert_tlb	spc,pte,prot
 
 	f_extend	pte,t0	
 
 	iitlbt          pte,prot
+	dbit_unlock1	spc,t0
 
 	rfir
 	nop
@@ -1553,13 +1611,15 @@ naitlb_miss_20:
 
 	L2_ptep		ptp,pte,t0,va,naitlb_check_alias_20
 
-	update_ptep	ptp,pte,t0,t1
+	dbit_lock	spc,t0,t1
+	update_ptep	spc,ptp,pte,t0,t1
 
 	make_insert_tlb	spc,pte,prot
 
 	f_extend	pte,t0
 
 	iitlbt          pte,prot
+	dbit_unlock1	spc,t0
 
 	rfir
 	nop
@@ -1583,29 +1643,13 @@ dbit_trap_20w:
 
 	L3_ptep		ptp,pte,t0,va,dbit_fault
 
-#ifdef CONFIG_SMP
-	cmpib,COND(=),n        0,spc,dbit_nolock_20w
-	load32		PA(pa_dbit_lock),t0
-
-dbit_spin_20w:
-	LDCW		0(t0),t1
-	cmpib,COND(=)         0,t1,dbit_spin_20w
-	nop
-
-dbit_nolock_20w:
-#endif
-	update_dirty	ptp,pte,t1
+	dbit_lock	spc,t0,t1
+	update_dirty	spc,ptp,pte,t1
 
 	make_insert_tlb	spc,pte,prot
 		
 	idtlbt          pte,prot
-#ifdef CONFIG_SMP
-	cmpib,COND(=),n        0,spc,dbit_nounlock_20w
-	ldi             1,t1
-	stw             t1,0(t0)
-
-dbit_nounlock_20w:
-#endif
+	dbit_unlock0	spc,t0
 
 	rfir
 	nop
@@ -1619,18 +1663,8 @@ dbit_trap_11:
 
 	L2_ptep		ptp,pte,t0,va,dbit_fault
 
-#ifdef CONFIG_SMP
-	cmpib,COND(=),n        0,spc,dbit_nolock_11
-	load32		PA(pa_dbit_lock),t0
-
-dbit_spin_11:
-	LDCW		0(t0),t1
-	cmpib,=         0,t1,dbit_spin_11
-	nop
-
-dbit_nolock_11:
-#endif
-	update_dirty	ptp,pte,t1
+	dbit_lock	spc,t0,t1
+	update_dirty	spc,ptp,pte,t1
 
 	make_insert_tlb_11	spc,pte,prot
 
@@ -1641,13 +1675,7 @@ dbit_nolock_11:
 	idtlbp		prot,(%sr1,va)
 
 	mtsp            t1, %sr1     /* Restore sr1 */
-#ifdef CONFIG_SMP
-	cmpib,COND(=),n        0,spc,dbit_nounlock_11
-	ldi             1,t1
-	stw             t1,0(t0)
-
-dbit_nounlock_11:
-#endif
+	dbit_unlock0	spc,t0
 
 	rfir
 	nop
@@ -1659,32 +1687,15 @@ dbit_trap_20:
 
 	L2_ptep		ptp,pte,t0,va,dbit_fault
 
-#ifdef CONFIG_SMP
-	cmpib,COND(=),n        0,spc,dbit_nolock_20
-	load32		PA(pa_dbit_lock),t0
-
-dbit_spin_20:
-	LDCW		0(t0),t1
-	cmpib,=         0,t1,dbit_spin_20
-	nop
-
-dbit_nolock_20:
-#endif
-	update_dirty	ptp,pte,t1
+	dbit_lock	spc,t0,t1
+	update_dirty	spc,ptp,pte,t1
 
 	make_insert_tlb	spc,pte,prot
 
 	f_extend	pte,t1
 	
         idtlbt          pte,prot
-
-#ifdef CONFIG_SMP
-	cmpib,COND(=),n        0,spc,dbit_nounlock_20
-	ldi             1,t1
-	stw             t1,0(t0)
-
-dbit_nounlock_20:
-#endif
+	dbit_unlock0	spc,t0
 
 	rfir
 	nop
-- 
1.7.10.4


