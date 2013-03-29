Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756841Ab3C2UOa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 16:14:30 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:48182 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756565Ab3C2UO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 16:14:29 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH] xen/mmu: On early bootup, flush the TLB when changing RO->RW bits Xen provided pagetables.
Date: Fri, 29 Mar 2013 16:14:22 -0400
Message-Id: <1364588062-7519-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.0.2
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Occassionaly on a DL380 G4 the guest would crash quite early with this:

(XEN) d244:v0: unhandled page fault (ec=0003)
(XEN) Pagetable walk from ffffffff84dc7000:
(XEN)  L4[0x1ff] = 00000000c3f18067 0000000000001789
(XEN)  L3[0x1fe] = 00000000c3f14067 000000000000178d
(XEN)  L2[0x026] = 00000000dc8b2067 0000000000004def
(XEN)  L1[0x1c7] = 00100000dc8da067 0000000000004dc7
(XEN) domain_crash_sync called from entry.S
(XEN) Domain 244 (vcpu#0) crashed on cpu#3:
(XEN) ----[ Xen-4.1.3OVM  x86_64  debug=n  Not tainted ]----
(XEN) CPU:    3
(XEN) RIP:    e033:[<ffffffff81263f22>]
(XEN) RFLAGS: 0000000000000216   EM: 1   CONTEXT: pv guest
(XEN) rax: 0000000000000000   rbx: ffffffff81785f88   rcx: 000000000000003f
(XEN) rdx: 0000000000000000   rsi: 00000000dc8da063   rdi: ffffffff84dc7000

The offending code shows it to be a loop writting the value zero
(%rax) in the %rdi (the L4 provided by Xen) register:

   0: 44 00 00             add    %r8b,(%rax)
   3: 31 c0                 xor    %eax,%eax
   5: b9 40 00 00 00       mov    $0x40,%ecx
   a: 66 0f 1f 84 00 00 00 nopw   0x0(%rax,%rax,1)
  11: 00 00
  13: ff c9                 dec    %ecx
  15:* 48 89 07             mov    %rax,(%rdi)     <-- trapping instruction
  18: 48 89 47 08           mov    %rax,0x8(%rdi)
  1c: 48 89 47 10           mov    %rax,0x10(%rdi)

which fails. xen_setup_kernel_pagetable recycles some of the Xen's
page-table entries when it has switched over to its Linux page-tables.

Right before try to clear the page, we  make a hypercall to change
it from _RO to  _RW and that works (otherwise we would hit an BUG()).
And the _RW flag is set for that page:
(XEN)  L1[0x1c7] = 001000004885f067 0000000000004dc7

The error code is 3, so PFEC_page_present and PFEC_write_access, so page is
present (correct), and we tried to write to the page, but a violation
occurred. The one theory is that the the page entries in hardware
(which are cached) are not up to date with what we just set. Especially
as we have just done an CR3 write and flushed the multicalls.

This patch does solve the problem by flusing out the TLB page
entry after changing it from _RO to _RW and we don't hit this
issue anymore.

Fixed-Oracle-Bug: 16243091 [ON OCCASIONS VM START GOES INTO
'CRASH' STATE: CLEAR_PAGE+0X12 ON HP DL380 G4]
Reported-and-Tested-by: Saar Maoz <Saar.Maoz@oracle.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/mmu.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 6afbb2c..a4ea924 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1748,14 +1748,18 @@ static void *m2v(phys_addr_t maddr)
 }
 
 /* Set the page permissions on an identity-mapped pages */
-static void set_page_prot(void *addr, pgprot_t prot)
+static void set_page_prot_flags(void *addr, pgprot_t prot, unsigned long flags)
 {
 	unsigned long pfn = __pa(addr) >> PAGE_SHIFT;
 	pte_t pte = pfn_pte(pfn, prot);
 
-	if (HYPERVISOR_update_va_mapping((unsigned long)addr, pte, 0))
+	if (HYPERVISOR_update_va_mapping((unsigned long)addr, pte, flags))
 		BUG();
 }
+static void set_page_prot(void *addr, pgprot_t prot)
+{
+	return set_page_prot_flags(addr, prot, UVMF_NONE);
+}
 #ifdef CONFIG_X86_32
 static void __init xen_map_identity_early(pmd_t *pmd, unsigned long max_pfn)
 {
@@ -1839,12 +1843,12 @@ static void __init check_pt_base(unsigned long *pt_base, unsigned long *pt_end,
 				 unsigned long addr)
 {
 	if (*pt_base == PFN_DOWN(__pa(addr))) {
-		set_page_prot((void *)addr, PAGE_KERNEL);
+		set_page_prot_flags((void *)addr, PAGE_KERNEL, UVMF_INVLPG);
 		clear_page((void *)addr);
 		(*pt_base)++;
 	}
 	if (*pt_end == PFN_DOWN(__pa(addr))) {
-		set_page_prot((void *)addr, PAGE_KERNEL);
+		set_page_prot_flags((void *)addr, PAGE_KERNEL, UVMF_INVLPG);
 		clear_page((void *)addr);
 		(*pt_end)--;
 	}
-- 
1.8.0.2

