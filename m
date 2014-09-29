Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754677AbaI2Qso (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 12:48:44 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:64136 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754568AbaI2Qsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 12:48:41 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Scott Wood <scottwood@freescale.com>, Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, Jojy G Varghese <jojyv@juniper.net>,
        Guenter Roeck <groeck@juniper.net>, Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH] powerpc/fsl: Add support for pci(e) machine check exception on E500MC / E5500
Date: Mon, 29 Sep 2014 09:48:32 -0700
Message-Id: <1412009312-7400-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jojy G Varghese <jojyv@juniper.net>

For E500MC and E5500, a machine check exception in pci(e) memory space
crashes the kernel.

Testing shows that the MCAR(U) register is zero on a MC exception for the
E5500 core. At the same time, DEAR register has been found to have the
address of the faulty load address during an MC exception for this core.

This fix changes the current behavior to fixup the result register
and instruction pointers in the case of a load operation on a faulty
PCI address.

The changes are:
- Added the hook to pci machine check handing to the e500mc machine check
  exception handler.
- For the E5500 core, load faulting address from SPRN_DEAR register.
  As mentioned above, this is necessary because the E5500 core does not
  report the fault address in the MCAR register.

Cc: Scott Wood <scottwood@freescale.com>
Signed-off-by: Jojy G Varghese <jojyv@juniper.net>
[Guenter Roeck: updated description]
Signed-off-by: Guenter Roeck <groeck@juniper.net>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 arch/powerpc/kernel/traps.c   | 3 ++-
 arch/powerpc/sysdev/fsl_pci.c | 5 +++++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/traps.c b/arch/powerpc/kernel/traps.c
index 0dc43f9..ecb709b 100644
--- a/arch/powerpc/kernel/traps.c
+++ b/arch/powerpc/kernel/traps.c
@@ -494,7 +494,8 @@ int machine_check_e500mc(struct pt_regs *regs)
 	int recoverable = 1;
 
 	if (reason & MCSR_LD) {
-		recoverable = fsl_rio_mcheck_exception(regs);
+		recoverable = fsl_rio_mcheck_exception(regs) ||
+			fsl_pci_mcheck_exception(regs);
 		if (recoverable == 1)
 			goto silent_out;
 	}
diff --git a/arch/powerpc/sysdev/fsl_pci.c b/arch/powerpc/sysdev/fsl_pci.c
index c507767..bdb956b 100644
--- a/arch/powerpc/sysdev/fsl_pci.c
+++ b/arch/powerpc/sysdev/fsl_pci.c
@@ -1021,6 +1021,11 @@ int fsl_pci_mcheck_exception(struct pt_regs *regs)
 #endif
 	addr += mfspr(SPRN_MCAR);
 
+#ifdef CONFIG_E5500_CPU
+	if (mfspr(SPRN_EPCR) & SPRN_EPCR_ICM)
+		addr = PFN_PHYS(vmalloc_to_pfn((void *)mfspr(SPRN_DEAR)));
+#endif
+
 	if (is_in_pci_mem_space(addr)) {
 		if (user_mode(regs)) {
 			pagefault_disable();
-- 
1.9.1

