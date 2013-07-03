Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965397Ab3GCTQz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 15:16:55 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:19882 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965388Ab3GCTQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 15:16:43 -0400
X-Authority-Analysis: v=2.0 cv=Tr1kdUrh c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=eIhxMilvRf8A:10 a=QyUkXiIAFBYA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=zNXoGfytzK0A:10 a=Hz8Y6HCVgfnjdkpyZEQA:9 a=QEXdDO2ut3YA:10 a=Sf_gFPzhefAA:10 a=_yYU7qdhAUkA:10 a=-0qkl0XTG-IA:10 a=KEgUWUkkXn9Bohfo:21 a=YapHoxbkdk0WIta0:21 a=wZ1ExKGxLlVTp0Nu:21 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1372878997.22688.116.camel@gandalf.local.home>
Subject: Re: [000/141] 3.6.11.6-stable review
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org
Date: Wed, 03 Jul 2013 15:16:37 -0400
In-Reply-To: <20130703183857.307196999@goodmis.org>
References: <20130703183857.307196999@goodmis.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/Makefile b/Makefile
index 98481c0..2f707c7 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 3
 PATCHLEVEL = 6
 SUBLEVEL = 11
-EXTRAVERSION = .5
+EXTRAVERSION = .6
 NAME = Terrified Chipmunk
 
 # *DOCUMENTATION*
diff --git a/arch/arm/boot/compressed/Makefile b/arch/arm/boot/compressed/Makefile
index bb26756..90a482b 100644
--- a/arch/arm/boot/compressed/Makefile
+++ b/arch/arm/boot/compressed/Makefile
@@ -126,7 +126,7 @@ KBUILD_CFLAGS = $(subst -pg, , $(ORIG_CFLAGS))
 endif
 
 ccflags-y := -fpic -fno-builtin -I$(obj)
-asflags-y := -Wa,-march=all
+asflags-y := -DZIMAGE
 
 # Supply kernel BSS size to the decompressor via a linker symbol.
 KBSS_SZ = $(shell $(CROSS_COMPILE)size $(obj)/../../../../vmlinux | \
diff --git a/arch/arm/boot/compressed/head-sa1100.S b/arch/arm/boot/compressed/head-sa1100.S
index 6179d94..3115e31 100644
--- a/arch/arm/boot/compressed/head-sa1100.S
+++ b/arch/arm/boot/compressed/head-sa1100.S
@@ -11,6 +11,7 @@
 #include <asm/mach-types.h>
 
 		.section        ".start", "ax"
+		.arch	armv4
 
 __SA1100_start:
 
diff --git a/arch/arm/boot/compressed/head-shark.S b/arch/arm/boot/compressed/head-shark.S
index 089c560..92b5689 100644
--- a/arch/arm/boot/compressed/head-shark.S
+++ b/arch/arm/boot/compressed/head-shark.S
@@ -18,6 +18,7 @@
 	
 		.section	".start", "ax"
 
+		.arch armv4
 		b	__beginning
 	
 __ofw_data:	.long	0				@ the number of memory blocks
diff --git a/arch/arm/boot/compressed/head.S b/arch/arm/boot/compressed/head.S
index bc67cbf..a7ae392 100644
--- a/arch/arm/boot/compressed/head.S
+++ b/arch/arm/boot/compressed/head.S
@@ -10,6 +10,7 @@
  */
 #include <linux/linkage.h>
 
+	.arch	armv7-a
 /*
  * Debugging stuff
  *
diff --git a/arch/arm/kernel/topology.c b/arch/arm/kernel/topology.c
index 26c12c6..2d064f9 100644
--- a/arch/arm/kernel/topology.c
+++ b/arch/arm/kernel/topology.c
@@ -13,6 +13,7 @@
 
 #include <linux/cpu.h>
 #include <linux/cpumask.h>
+#include <linux/export.h>
 #include <linux/init.h>
 #include <linux/percpu.h>
 #include <linux/node.h>
@@ -225,6 +226,7 @@ static inline void update_cpu_power(unsigned int cpuid, unsigned int mpidr) {}
  * cpu topology table
  */
 struct cputopo_arm cpu_topology[NR_CPUS];
+EXPORT_SYMBOL_GPL(cpu_topology);
 
 const struct cpumask *cpu_coregroup_mask(int cpu)
 {
diff --git a/arch/arm/mach-kirkwood/ts219-setup.c b/arch/arm/mach-kirkwood/ts219-setup.c
index 73e2b6c..3a73fc7 100644
--- a/arch/arm/mach-kirkwood/ts219-setup.c
+++ b/arch/arm/mach-kirkwood/ts219-setup.c
@@ -124,7 +124,7 @@ static void __init qnap_ts219_init(void)
 static int __init ts219_pci_init(void)
 {
 	if (machine_is_ts219())
-		kirkwood_pcie_init(KW_PCIE0);
+		kirkwood_pcie_init(KW_PCIE1 | KW_PCIE0);
 
 	return 0;
 }
diff --git a/arch/arm/plat-orion/common.c b/arch/arm/plat-orion/common.c
index b8b747a..bd65e73 100644
--- a/arch/arm/plat-orion/common.c
+++ b/arch/arm/plat-orion/common.c
@@ -373,7 +373,7 @@ static struct resource orion_ge10_shared_resources[] = {
 
 static struct platform_device orion_ge10_shared = {
 	.name		= MV643XX_ETH_SHARED_NAME,
-	.id		= 1,
+	.id		= 2,
 	.dev		= {
 		.platform_data	= &orion_ge10_shared_data,
 	},
@@ -388,8 +388,8 @@ static struct resource orion_ge10_resources[] = {
 
 static struct platform_device orion_ge10 = {
 	.name		= MV643XX_ETH_NAME,
-	.id		= 1,
-	.num_resources	= 2,
+	.id		= 2,
+	.num_resources	= 1,
 	.resource	= orion_ge10_resources,
 	.dev		= {
 		.coherent_dma_mask	= DMA_BIT_MASK(32),
@@ -425,7 +425,7 @@ static struct resource orion_ge11_shared_resources[] = {
 
 static struct platform_device orion_ge11_shared = {
 	.name		= MV643XX_ETH_SHARED_NAME,
-	.id		= 1,
+	.id		= 3,
 	.dev		= {
 		.platform_data	= &orion_ge11_shared_data,
 	},
@@ -440,8 +440,8 @@ static struct resource orion_ge11_resources[] = {
 
 static struct platform_device orion_ge11 = {
 	.name		= MV643XX_ETH_NAME,
-	.id		= 1,
-	.num_resources	= 2,
+	.id		= 3,
+	.num_resources	= 1,
 	.resource	= orion_ge11_resources,
 	.dev		= {
 		.coherent_dma_mask	= DMA_BIT_MASK(32),
diff --git a/arch/avr32/kernel/module.c b/arch/avr32/kernel/module.c
index 596f730..2c94129 100644
--- a/arch/avr32/kernel/module.c
+++ b/arch/avr32/kernel/module.c
@@ -264,7 +264,7 @@ int apply_relocate_add(Elf32_Shdr *sechdrs, const char *strtab,
 			break;
 		case R_AVR32_GOT18SW:
 			if ((relocation & 0xfffe0003) != 0
-			    && (relocation & 0xfffc0003) != 0xffff0000)
+			    && (relocation & 0xfffc0000) != 0xfffc0000)
 				return reloc_overflow(module, "R_AVR32_GOT18SW",
 						     relocation);
 			relocation >>= 2;
diff --git a/arch/m68k/kernel/head.S b/arch/m68k/kernel/head.S
index d197e7f..ac85f16 100644
--- a/arch/m68k/kernel/head.S
+++ b/arch/m68k/kernel/head.S
@@ -2752,11 +2752,9 @@ func_return	get_new_page
 #ifdef CONFIG_MAC
 
 L(scc_initable_mac):
-	.byte	9,12		/* Reset */
 	.byte	4,0x44		/* x16, 1 stopbit, no parity */
 	.byte	3,0xc0		/* receiver: 8 bpc */
 	.byte	5,0xe2		/* transmitter: 8 bpc, assert dtr/rts */
-	.byte	9,0		/* no interrupts */
 	.byte	10,0		/* NRZ */
 	.byte	11,0x50		/* use baud rate generator */
 	.byte	12,1,13,0	/* 38400 baud */
@@ -2899,6 +2897,7 @@ func_start	serial_init,%d0/%d1/%a0/%a1
 	is_not_mac(L(serial_init_not_mac))
 
 #ifdef SERIAL_DEBUG
+
 /* You may define either or both of these. */
 #define MAC_USE_SCC_A /* Modem port */
 #define MAC_USE_SCC_B /* Printer port */
@@ -2908,9 +2907,21 @@ func_start	serial_init,%d0/%d1/%a0/%a1
 #define mac_scc_cha_b_data_offset	0x4
 #define mac_scc_cha_a_data_offset	0x6
 
+#if defined(MAC_USE_SCC_A) || defined(MAC_USE_SCC_B)
+	movel	%pc@(L(mac_sccbase)),%a0
+	/* Reset SCC device */
+	moveb	#9,%a0@(mac_scc_cha_a_ctrl_offset)
+	moveb	#0xc0,%a0@(mac_scc_cha_a_ctrl_offset)
+	/* Wait for 5 PCLK cycles, which is about 68 CPU cycles */
+	/* 5 / 3.6864 MHz = approx. 1.36 us = 68 / 50 MHz */
+	movel	#35,%d0
+5:
+	subq	#1,%d0
+	jne	5b
+#endif
+
 #ifdef MAC_USE_SCC_A
 	/* Initialize channel A */
-	movel	%pc@(L(mac_sccbase)),%a0
 	lea	%pc@(L(scc_initable_mac)),%a1
 5:	moveb	%a1@+,%d0
 	jmi	6f
@@ -2922,9 +2933,6 @@ func_start	serial_init,%d0/%d1/%a0/%a1
 
 #ifdef MAC_USE_SCC_B
 	/* Initialize channel B */
-#ifndef MAC_USE_SCC_A	/* Load mac_sccbase only if needed */
-	movel	%pc@(L(mac_sccbase)),%a0
-#endif	/* MAC_USE_SCC_A */
 	lea	%pc@(L(scc_initable_mac)),%a1
 7:	moveb	%a1@+,%d0
 	jmi	8f
@@ -2933,6 +2941,7 @@ func_start	serial_init,%d0/%d1/%a0/%a1
 	jra	7b
 8:
 #endif	/* MAC_USE_SCC_B */
+
 #endif	/* SERIAL_DEBUG */
 
 	jra	L(serial_init_done)
@@ -3006,17 +3015,17 @@ func_start	serial_putc,%d0/%d1/%a0/%a1
 
 #ifdef SERIAL_DEBUG
 
-#ifdef MAC_USE_SCC_A
+#if defined(MAC_USE_SCC_A) || defined(MAC_USE_SCC_B)
 	movel	%pc@(L(mac_sccbase)),%a1
+#endif
+
+#ifdef MAC_USE_SCC_A
 3:	btst	#2,%a1@(mac_scc_cha_a_ctrl_offset)
 	jeq	3b
 	moveb	%d0,%a1@(mac_scc_cha_a_data_offset)
 #endif	/* MAC_USE_SCC_A */
 
 #ifdef MAC_USE_SCC_B
-#ifndef MAC_USE_SCC_A	/* Load mac_sccbase only if needed */
-	movel	%pc@(L(mac_sccbase)),%a1
-#endif	/* MAC_USE_SCC_A */
 4:	btst	#2,%a1@(mac_scc_cha_b_ctrl_offset)
 	jeq	4b
 	moveb	%d0,%a1@(mac_scc_cha_b_data_offset)
diff --git a/arch/powerpc/include/asm/exception-64s.h b/arch/powerpc/include/asm/exception-64s.h
index a43c147..3166d5e 100644
--- a/arch/powerpc/include/asm/exception-64s.h
+++ b/arch/powerpc/include/asm/exception-64s.h
@@ -320,7 +320,7 @@ label##_common:							\
  */
 #define STD_EXCEPTION_COMMON_ASYNC(trap, label, hdlr)		  \
 	EXCEPTION_COMMON(trap, label, hdlr, ret_from_except_lite, \
-			 FINISH_NAP;RUNLATCH_ON;DISABLE_INTS)
+			 FINISH_NAP;DISABLE_INTS;RUNLATCH_ON)
 
 /*
  * When the idle code in power4_idle puts the CPU into NAP mode,
diff --git a/arch/powerpc/include/asm/machdep.h b/arch/powerpc/include/asm/machdep.h
index 42ce570..fd23013 100644
--- a/arch/powerpc/include/asm/machdep.h
+++ b/arch/powerpc/include/asm/machdep.h
@@ -29,6 +29,7 @@ struct rtc_time;
 struct file;
 struct pci_controller;
 struct kimage;
+struct pci_host_bridge;
 
 struct machdep_calls {
 	char		*name;
@@ -107,6 +108,8 @@ struct machdep_calls {
 	void		(*pcibios_fixup)(void);
 	int		(*pci_probe_mode)(struct pci_bus *);
 	void		(*pci_irq_fixup)(struct pci_dev *dev);
+	int		(*pcibios_root_bridge_prepare)(struct pci_host_bridge
+				*bridge);
 
 	/* To setup PHBs when using automatic OF platform driver for PCI */
 	int		(*pci_setup_phb)(struct pci_controller *host);
diff --git a/arch/powerpc/include/asm/pci-bridge.h b/arch/powerpc/include/asm/pci-bridge.h
index 78326de..271af40 100644
--- a/arch/powerpc/include/asm/pci-bridge.h
+++ b/arch/powerpc/include/asm/pci-bridge.h
@@ -154,6 +154,8 @@ struct pci_dn {
 
 	int	pci_ext_config_space;	/* for pci devices */
 
+	int	force_32bit_msi:1;
+
 	struct	pci_dev *pcidev;	/* back-pointer to the pci device */
 #ifdef CONFIG_EEH
 	struct eeh_dev *edev;		/* eeh device */
diff --git a/arch/powerpc/kernel/exceptions-64s.S b/arch/powerpc/kernel/exceptions-64s.S
index 39aa97d..6419923 100644
--- a/arch/powerpc/kernel/exceptions-64s.S
+++ b/arch/powerpc/kernel/exceptions-64s.S
@@ -491,7 +491,7 @@ machine_check_common:
 	STD_EXCEPTION_COMMON(0xb00, trap_0b, .unknown_exception)
 	STD_EXCEPTION_COMMON(0xd00, single_step, .single_step_exception)
 	STD_EXCEPTION_COMMON(0xe00, trap_0e, .unknown_exception)
-        STD_EXCEPTION_COMMON(0xe40, emulation_assist, .program_check_exception)
+	STD_EXCEPTION_COMMON(0xe40, emulation_assist, .emulation_assist_interrupt)
         STD_EXCEPTION_COMMON(0xe60, hmi_exception, .unknown_exception)
 	STD_EXCEPTION_COMMON_ASYNC(0xf00, performance_monitor, .performance_monitor_exception)
 	STD_EXCEPTION_COMMON(0x1300, instruction_breakpoint, .instruction_breakpoint_exception)
diff --git a/arch/powerpc/kernel/irq.c b/arch/powerpc/kernel/irq.c
index 1f017bb..86cb68e 100644
--- a/arch/powerpc/kernel/irq.c
+++ b/arch/powerpc/kernel/irq.c
@@ -162,7 +162,7 @@ notrace unsigned int __check_irq_replay(void)
 	 * in case we also had a rollover while hard disabled
 	 */
 	local_paca->irq_happened &= ~PACA_IRQ_DEC;
-	if (decrementer_check_overflow())
+	if ((happened & PACA_IRQ_DEC) || decrementer_check_overflow())
 		return 0x900;
 
 	/* Finally check if an external interrupt happened */
diff --git a/arch/powerpc/kernel/pci-common.c b/arch/powerpc/kernel/pci-common.c
index 2aa04f2..6fe4341 100644
--- a/arch/powerpc/kernel/pci-common.c
+++ b/arch/powerpc/kernel/pci-common.c
@@ -30,6 +30,7 @@
 #include <linux/irq.h>
 #include <linux/vmalloc.h>
 #include <linux/slab.h>
+#include <linux/vgaarb.h>
 
 #include <asm/processor.h>
 #include <asm/io.h>
@@ -825,6 +826,14 @@ int pci_proc_domain(struct pci_bus *bus)
 	return 1;
 }
 
+int pcibios_root_bridge_prepare(struct pci_host_bridge *bridge)
+{
+	if (ppc_md.pcibios_root_bridge_prepare)
+		return ppc_md.pcibios_root_bridge_prepare(bridge);
+
+	return 0;
+}
+
 /* This header fixup will do the resource fixup for all devices as they are
  * probed, but not for bridge ranges
  */
@@ -1698,3 +1707,15 @@ static void fixup_hide_host_resource_fsl(struct pci_dev *dev)
 }
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_MOTOROLA, PCI_ANY_ID, fixup_hide_host_resource_fsl);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_FREESCALE, PCI_ANY_ID, fixup_hide_host_resource_fsl);
+
+static void fixup_vga(struct pci_dev *pdev)
+{
+	u16 cmd;
+
+	pci_read_config_word(pdev, PCI_COMMAND, &cmd);
+	if ((cmd & (PCI_COMMAND_IO | PCI_COMMAND_MEMORY)) || !vga_default_device())
+		vga_set_default_device(pdev);
+
+}
+DECLARE_PCI_FIXUP_CLASS_FINAL(PCI_ANY_ID, PCI_ANY_ID,
+			      PCI_CLASS_DISPLAY_VGA, 8, fixup_vga);
diff --git a/arch/powerpc/kernel/process.c b/arch/powerpc/kernel/process.c
index 1a1f2dd..b1e4ac1 100644
--- a/arch/powerpc/kernel/process.c
+++ b/arch/powerpc/kernel/process.c
@@ -1221,7 +1221,7 @@ EXPORT_SYMBOL(dump_stack);
 
 #ifdef CONFIG_PPC64
 /* Called with hard IRQs off */
-void __ppc64_runlatch_on(void)
+void notrace __ppc64_runlatch_on(void)
 {
 	struct thread_info *ti = current_thread_info();
 	unsigned long ctrl;
@@ -1234,7 +1234,7 @@ void __ppc64_runlatch_on(void)
 }
 
 /* Called with hard IRQs off */
-void __ppc64_runlatch_off(void)
+void notrace __ppc64_runlatch_off(void)
 {
 	struct thread_info *ti = current_thread_info();
 	unsigned long ctrl;
diff --git a/arch/powerpc/kernel/traps.c b/arch/powerpc/kernel/traps.c
index 3bb7197..5557044 100644
--- a/arch/powerpc/kernel/traps.c
+++ b/arch/powerpc/kernel/traps.c
@@ -1074,6 +1074,16 @@ void __kprobes program_check_exception(struct pt_regs *regs)
 		_exception(SIGILL, regs, ILL_ILLOPC, regs->nip);
 }
 
+/*
+ * This occurs when running in hypervisor mode on POWER6 or later
+ * and an illegal instruction is encountered.
+ */
+void __kprobes emulation_assist_interrupt(struct pt_regs *regs)
+{
+	regs->msr |= REASON_ILLEGAL;
+	program_check_exception(regs);
+}
+
 void alignment_exception(struct pt_regs *regs)
 {
 	int sig, code, fixed = 0;
diff --git a/arch/powerpc/platforms/pseries/eeh_pseries.c b/arch/powerpc/platforms/pseries/eeh_pseries.c
index c33360ec..a81ebd3 100644
--- a/arch/powerpc/platforms/pseries/eeh_pseries.c
+++ b/arch/powerpc/platforms/pseries/eeh_pseries.c
@@ -83,7 +83,11 @@ static int pseries_eeh_init(void)
 	ibm_configure_pe		= rtas_token("ibm,configure-pe");
 	ibm_configure_bridge		= rtas_token("ibm,configure-bridge");
 
-	/* necessary sanity check */
+	/*
+	 * Necessary sanity check. We needn't check "get-config-addr-info"
+	 * and its variant since the old firmware probably support address
+	 * of domain/bus/slot/function for EEH RTAS operations.
+	 */
 	if (ibm_set_eeh_option == RTAS_UNKNOWN_SERVICE) {
 		pr_warning("%s: RTAS service <ibm,set-eeh-option> invalid\n",
 			__func__);
@@ -102,12 +106,6 @@ static int pseries_eeh_init(void)
 		pr_warning("%s: RTAS service <ibm,slot-error-detail> invalid\n",
 			__func__);
 		return -EINVAL;
-	} else if (ibm_get_config_addr_info2 == RTAS_UNKNOWN_SERVICE &&
-		   ibm_get_config_addr_info == RTAS_UNKNOWN_SERVICE) {
-		pr_warning("%s: RTAS service <ibm,get-config-addr-info2> and "
-			"<ibm,get-config-addr-info> invalid\n",
-			__func__);
-		return -EINVAL;
 	} else if (ibm_configure_pe == RTAS_UNKNOWN_SERVICE &&
 		   ibm_configure_bridge == RTAS_UNKNOWN_SERVICE) {
 		pr_warning("%s: RTAS service <ibm,configure-pe> and "
diff --git a/arch/powerpc/platforms/pseries/msi.c b/arch/powerpc/platforms/pseries/msi.c
index 109fdb7..5c9aa89 100644
--- a/arch/powerpc/platforms/pseries/msi.c
+++ b/arch/powerpc/platforms/pseries/msi.c
@@ -24,6 +24,7 @@ static int query_token, change_token;
 #define RTAS_RESET_FN		2
 #define RTAS_CHANGE_MSI_FN	3
 #define RTAS_CHANGE_MSIX_FN	4
+#define RTAS_CHANGE_32MSI_FN	5
 
 static struct pci_dn *get_pdn(struct pci_dev *pdev)
 {
@@ -58,7 +59,8 @@ static int rtas_change_msi(struct pci_dn *pdn, u32 func, u32 num_irqs)
 
 	seq_num = 1;
 	do {
-		if (func == RTAS_CHANGE_MSI_FN || func == RTAS_CHANGE_MSIX_FN)
+		if (func == RTAS_CHANGE_MSI_FN || func == RTAS_CHANGE_MSIX_FN ||
+		    func == RTAS_CHANGE_32MSI_FN)
 			rc = rtas_call(change_token, 6, 4, rtas_ret, addr,
 					BUID_HI(buid), BUID_LO(buid),
 					func, num_irqs, seq_num);
@@ -407,9 +409,12 @@ static int rtas_setup_msi_irqs(struct pci_dev *pdev, int nvec, int type)
 	 * return MSI-Xs.
 	 */
 	if (type == PCI_CAP_ID_MSI) {
-		rc = rtas_change_msi(pdn, RTAS_CHANGE_MSI_FN, nvec);
+		if (pdn->force_32bit_msi)
+			rc = rtas_change_msi(pdn, RTAS_CHANGE_32MSI_FN, nvec);
+		else
+			rc = rtas_change_msi(pdn, RTAS_CHANGE_MSI_FN, nvec);
 
-		if (rc < 0) {
+		if (rc < 0 && !pdn->force_32bit_msi) {
 			pr_debug("rtas_msi: trying the old firmware call.\n");
 			rc = rtas_change_msi(pdn, RTAS_CHANGE_FN, nvec);
 		}
@@ -489,3 +494,13 @@ static int rtas_msi_init(void)
 	return 0;
 }
 arch_initcall(rtas_msi_init);
+
+static void quirk_radeon(struct pci_dev *dev)
+{
+	struct pci_dn *pdn = get_pdn(dev);
+
+	if (pdn)
+		pdn->force_32bit_msi = 1;
+}
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, 0x68f2, quirk_radeon);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, 0xaa68, quirk_radeon);
diff --git a/arch/powerpc/platforms/pseries/pci.c b/arch/powerpc/platforms/pseries/pci.c
index 2c6ded2..7f6f556 100644
--- a/arch/powerpc/platforms/pseries/pci.c
+++ b/arch/powerpc/platforms/pseries/pci.c
@@ -107,3 +107,56 @@ static void fixup_winbond_82c105(struct pci_dev* dev)
 }
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_WINBOND, PCI_DEVICE_ID_WINBOND_82C105,
 			 fixup_winbond_82c105);
+
+int pseries_root_bridge_prepare(struct pci_host_bridge *bridge)
+{
+	struct device_node *dn, *pdn;
+	struct pci_bus *bus;
+	const uint32_t *pcie_link_speed_stats;
+
+	bus = bridge->bus;
+
+	dn = pcibios_get_phb_of_node(bus);
+	if (!dn)
+		return 0;
+
+	for (pdn = dn; pdn != NULL; pdn = of_get_next_parent(pdn)) {
+		pcie_link_speed_stats = (const uint32_t *) of_get_property(pdn,
+			"ibm,pcie-link-speed-stats", NULL);
+		if (pcie_link_speed_stats)
+			break;
+	}
+
+	of_node_put(pdn);
+
+	if (!pcie_link_speed_stats) {
+		pr_err("no ibm,pcie-link-speed-stats property\n");
+		return 0;
+	}
+
+	switch (pcie_link_speed_stats[0]) {
+	case 0x01:
+		bus->max_bus_speed = PCIE_SPEED_2_5GT;
+		break;
+	case 0x02:
+		bus->max_bus_speed = PCIE_SPEED_5_0GT;
+		break;
+	default:
+		bus->max_bus_speed = PCI_SPEED_UNKNOWN;
+		break;
+	}
+
+	switch (pcie_link_speed_stats[1]) {
+	case 0x01:
+		bus->cur_bus_speed = PCIE_SPEED_2_5GT;
+		break;
+	case 0x02:
+		bus->cur_bus_speed = PCIE_SPEED_5_0GT;
+		break;
+	default:
+		bus->cur_bus_speed = PCI_SPEED_UNKNOWN;
+		break;
+	}
+
+	return 0;
+}
diff --git a/arch/powerpc/platforms/pseries/pseries.h b/arch/powerpc/platforms/pseries/pseries.h
index 9a3dda0..b79393d 100644
--- a/arch/powerpc/platforms/pseries/pseries.h
+++ b/arch/powerpc/platforms/pseries/pseries.h
@@ -60,4 +60,8 @@ extern int dlpar_detach_node(struct device_node *);
 /* Snooze Delay, pseries_idle */
 DECLARE_PER_CPU(long, smt_snooze_delay);
 
+/* PCI root bridge prepare function override for pseries */
+struct pci_host_bridge;
+int pseries_root_bridge_prepare(struct pci_host_bridge *bridge);
+
 #endif /* _PSERIES_PSERIES_H */
diff --git a/arch/powerpc/platforms/pseries/setup.c b/arch/powerpc/platforms/pseries/setup.c
index 51ecac9..5f01342 100644
--- a/arch/powerpc/platforms/pseries/setup.c
+++ b/arch/powerpc/platforms/pseries/setup.c
@@ -404,6 +404,9 @@ static void __init pSeries_setup_arch(void)
 		ppc_md.enable_pmcs = pseries_lpar_enable_pmcs;
 	else
 		ppc_md.enable_pmcs = power4_enable_pmcs;
+
+	ppc_md.pcibios_root_bridge_prepare = pseries_root_bridge_prepare;
+
 }
 
 static int __init pSeries_init_panel(void)
diff --git a/arch/x86/kernel/relocate_kernel_64.S b/arch/x86/kernel/relocate_kernel_64.S
index 7a6f3b3..f2bb9c9 100644
--- a/arch/x86/kernel/relocate_kernel_64.S
+++ b/arch/x86/kernel/relocate_kernel_64.S
@@ -160,7 +160,7 @@ identity_mapped:
 	xorq    %rbp, %rbp
 	xorq	%r8,  %r8
 	xorq	%r9,  %r9
-	xorq	%r10, %r9
+	xorq	%r10, %r10
 	xorq	%r11, %r11
 	xorq	%r12, %r12
 	xorq	%r13, %r13
diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index 641c91e..76bce6e 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -17,6 +17,7 @@
 #include <linux/slab.h>
 #include <linux/smp.h>
 #include <linux/irq_work.h>
+#include <linux/tick.h>
 
 #include <asm/paravirt.h>
 #include <asm/desc.h>
@@ -435,6 +436,13 @@ static void __cpuinit xen_play_dead(void) /* used only with HOTPLUG_CPU */
 	HYPERVISOR_vcpu_op(VCPUOP_down, smp_processor_id(), NULL);
 	cpu_bringup();
 	/*
+	 * commit 4b0c0f294 (tick: Cleanup NOHZ per cpu data on cpu down)
+	 * clears certain data that the cpu_idle loop (which called us
+	 * and that we return from) expects. The only way to get that
+	 * data back is to call:
+	 */
+	tick_nohz_idle_enter();
+	/*
 	 * Balance out the preempt calls - as we are running in cpu_idle
 	 * loop which has been called at bootup from cpu_bringup_and_idle.
 	 * The cpucpu_bringup_and_idle called cpu_bringup which made a
diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
index 3837739..69b1677 100644
--- a/drivers/acpi/video.c
+++ b/drivers/acpi/video.c
@@ -447,6 +447,22 @@ static struct dmi_system_id video_dmi_table[] __initdata = {
 		DMI_MATCH(DMI_PRODUCT_NAME, "HP Folio 13 - 2000 Notebook PC"),
 		},
 	},
+	{
+	 .callback = video_ignore_initial_backlight,
+	 .ident = "HP Pavilion g6 Notebook PC",
+	 .matches = {
+		 DMI_MATCH(DMI_BOARD_VENDOR, "Hewlett-Packard"),
+		 DMI_MATCH(DMI_PRODUCT_NAME, "HP Pavilion g6 Notebook PC"),
+		},
+	},
+	{
+	 .callback = video_ignore_initial_backlight,
+	 .ident = "HP Pavilion m4",
+	 .matches = {
+		DMI_MATCH(DMI_BOARD_VENDOR, "Hewlett-Packard"),
+		DMI_MATCH(DMI_PRODUCT_NAME, "HP Pavilion m4 Notebook PC"),
+		},
+	},
 	{}
 };
 
diff --git a/drivers/acpi/video_detect.c b/drivers/acpi/video_detect.c
index 4ac2593..abcae69 100644
--- a/drivers/acpi/video_detect.c
+++ b/drivers/acpi/video_detect.c
@@ -164,6 +164,14 @@ static struct dmi_system_id video_detect_dmi_table[] = {
 		DMI_MATCH(DMI_PRODUCT_NAME, "UL30VT"),
 		},
 	},
+	{
+	.callback = video_detect_force_vendor,
+	.ident = "Asus UL30A",
+	.matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK Computer Inc."),
+		DMI_MATCH(DMI_PRODUCT_NAME, "UL30A"),
+		},
+	},
 	{ },
 };
 
diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index 7bfe093..80c44c30 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -151,6 +151,7 @@ enum piix_controller_ids {
 	piix_pata_vmw,			/* PIIX4 for VMware, spurious DMA_ERR */
 	ich8_sata_snb,
 	ich8_2port_sata_snb,
+	ich8_2port_sata_byt,
 };
 
 struct piix_map_db {
@@ -340,6 +341,9 @@ static const struct pci_device_id piix_pci_tbl[] = {
 	{ 0x8086, 0x9c09, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },
 	/* SATA Controller IDE (DH89xxCC) */
 	{ 0x8086, 0x2326, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },
+	/* SATA Controller IDE (BayTrail) */
+	{ 0x8086, 0x0F20, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata_byt },
+	{ 0x8086, 0x0F21, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata_byt },
 	{ }	/* terminate list */
 };
 
@@ -504,6 +508,7 @@ static const struct piix_map_db *piix_map_db_table[] = {
 	[tolapai_sata]		= &tolapai_map_db,
 	[ich8_sata_snb]		= &ich8_map_db,
 	[ich8_2port_sata_snb]	= &ich8_2port_map_db,
+	[ich8_2port_sata_byt]	= &ich8_2port_map_db,
 };
 
 static struct ata_port_info piix_port_info[] = {
@@ -654,6 +659,16 @@ static struct ata_port_info piix_port_info[] = {
 		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &piix_sata_ops,
 	},
+
+	[ich8_2port_sata_byt] =
+	{
+		.flags          = PIIX_SATA_FLAGS | PIIX_FLAG_SIDPR | PIIX_FLAG_PIO16,
+		.pio_mask       = ATA_PIO4,
+		.mwdma_mask     = ATA_MWDMA2,
+		.udma_mask      = ATA_UDMA6,
+		.port_ops       = &piix_sata_ops,
+	},
+
 };
 
 static struct pci_bits piix_enable_bits[] = {
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 3e351e7..b76e6ea 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -1601,6 +1601,12 @@ unsigned ata_exec_internal_sg(struct ata_device *dev,
 	qc->tf = *tf;
 	if (cdb)
 		memcpy(qc->cdb, cdb, ATAPI_CDB_LEN);
+
+	/* some SATA bridges need us to indicate data xfer direction */
+	if (tf->protocol == ATAPI_PROT_DMA && (dev->flags & ATA_DFLAG_DMADIR) &&
+	    dma_dir == DMA_FROM_DEVICE)
+		qc->tf.feature |= ATAPI_DMADIR;
+
 	qc->flags |= ATA_QCFLAG_RESULT_TF;
 	qc->dma_dir = dma_dir;
 	if (dma_dir != DMA_NONE) {
diff --git a/drivers/block/brd.c b/drivers/block/brd.c
index 531ceb3..4e8213a 100644
--- a/drivers/block/brd.c
+++ b/drivers/block/brd.c
@@ -117,13 +117,13 @@ static struct page *brd_insert_page(struct brd_device *brd, sector_t sector)
 
 	spin_lock(&brd->brd_lock);
 	idx = sector >> PAGE_SECTORS_SHIFT;
+	page->index = idx;
 	if (radix_tree_insert(&brd->brd_pages, idx, page)) {
 		__free_page(page);
 		page = radix_tree_lookup(&brd->brd_pages, idx);
 		BUG_ON(!page);
 		BUG_ON(page->index != idx);
-	} else
-		page->index = idx;
+	}
 	spin_unlock(&brd->brd_lock);
 
 	radix_tree_preload_end();
diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index b0f553b..d3446f6 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -161,8 +161,6 @@ static irqreturn_t do_cciss_msix_intr(int irq, void *dev_id);
 static int cciss_open(struct block_device *bdev, fmode_t mode);
 static int cciss_unlocked_open(struct block_device *bdev, fmode_t mode);
 static int cciss_release(struct gendisk *disk, fmode_t mode);
-static int do_ioctl(struct block_device *bdev, fmode_t mode,
-		    unsigned int cmd, unsigned long arg);
 static int cciss_ioctl(struct block_device *bdev, fmode_t mode,
 		       unsigned int cmd, unsigned long arg);
 static int cciss_getgeo(struct block_device *bdev, struct hd_geometry *geo);
@@ -229,7 +227,7 @@ static const struct block_device_operations cciss_fops = {
 	.owner = THIS_MODULE,
 	.open = cciss_unlocked_open,
 	.release = cciss_release,
-	.ioctl = do_ioctl,
+	.ioctl = cciss_ioctl,
 	.getgeo = cciss_getgeo,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl = cciss_compat_ioctl,
@@ -1140,16 +1138,6 @@ static int cciss_release(struct gendisk *disk, fmode_t mode)
 	return 0;
 }
 
-static int do_ioctl(struct block_device *bdev, fmode_t mode,
-		    unsigned cmd, unsigned long arg)
-{
-	int ret;
-	mutex_lock(&cciss_mutex);
-	ret = cciss_ioctl(bdev, mode, cmd, arg);
-	mutex_unlock(&cciss_mutex);
-	return ret;
-}
-
 #ifdef CONFIG_COMPAT
 
 static int cciss_ioctl32_passthru(struct block_device *bdev, fmode_t mode,
@@ -1176,7 +1164,7 @@ static int cciss_compat_ioctl(struct block_device *bdev, fmode_t mode,
 	case CCISS_REGNEWD:
 	case CCISS_RESCANDISK:
 	case CCISS_GETLUNINFO:
-		return do_ioctl(bdev, mode, cmd, arg);
+		return cciss_ioctl(bdev, mode, cmd, arg);
 
 	case CCISS_PASSTHRU32:
 		return cciss_ioctl32_passthru(bdev, mode, cmd, arg);
@@ -1216,7 +1204,7 @@ static int cciss_ioctl32_passthru(struct block_device *bdev, fmode_t mode,
 	if (err)
 		return -EFAULT;
 
-	err = do_ioctl(bdev, mode, CCISS_PASSTHRU, (unsigned long)p);
+	err = cciss_ioctl(bdev, mode, CCISS_PASSTHRU, (unsigned long)p);
 	if (err)
 		return err;
 	err |=
@@ -1258,7 +1246,7 @@ static int cciss_ioctl32_big_passthru(struct block_device *bdev, fmode_t mode,
 	if (err)
 		return -EFAULT;
 
-	err = do_ioctl(bdev, mode, CCISS_BIG_PASSTHRU, (unsigned long)p);
+	err = cciss_ioctl(bdev, mode, CCISS_BIG_PASSTHRU, (unsigned long)p);
 	if (err)
 		return err;
 	err |=
@@ -1308,11 +1296,14 @@ static int cciss_getpciinfo(ctlr_info_t *h, void __user *argp)
 static int cciss_getintinfo(ctlr_info_t *h, void __user *argp)
 {
 	cciss_coalint_struct intinfo;
+	unsigned long flags;
 
 	if (!argp)
 		return -EINVAL;
+	spin_lock_irqsave(&h->lock, flags);
 	intinfo.delay = readl(&h->cfgtable->HostWrite.CoalIntDelay);
 	intinfo.count = readl(&h->cfgtable->HostWrite.CoalIntCount);
+	spin_unlock_irqrestore(&h->lock, flags);
 	if (copy_to_user
 	    (argp, &intinfo, sizeof(cciss_coalint_struct)))
 		return -EFAULT;
@@ -1353,12 +1344,15 @@ static int cciss_setintinfo(ctlr_info_t *h, void __user *argp)
 static int cciss_getnodename(ctlr_info_t *h, void __user *argp)
 {
 	NodeName_type NodeName;
+	unsigned long flags;
 	int i;
 
 	if (!argp)
 		return -EINVAL;
+	spin_lock_irqsave(&h->lock, flags);
 	for (i = 0; i < 16; i++)
 		NodeName[i] = readb(&h->cfgtable->ServerName[i]);
+	spin_unlock_irqrestore(&h->lock, flags);
 	if (copy_to_user(argp, NodeName, sizeof(NodeName_type)))
 		return -EFAULT;
 	return 0;
@@ -1395,10 +1389,13 @@ static int cciss_setnodename(ctlr_info_t *h, void __user *argp)
 static int cciss_getheartbeat(ctlr_info_t *h, void __user *argp)
 {
 	Heartbeat_type heartbeat;
+	unsigned long flags;
 
 	if (!argp)
 		return -EINVAL;
+	spin_lock_irqsave(&h->lock, flags);
 	heartbeat = readl(&h->cfgtable->HeartBeat);
+	spin_unlock_irqrestore(&h->lock, flags);
 	if (copy_to_user(argp, &heartbeat, sizeof(Heartbeat_type)))
 		return -EFAULT;
 	return 0;
@@ -1407,10 +1404,13 @@ static int cciss_getheartbeat(ctlr_info_t *h, void __user *argp)
 static int cciss_getbustypes(ctlr_info_t *h, void __user *argp)
 {
 	BusTypes_type BusTypes;
+	unsigned long flags;
 
 	if (!argp)
 		return -EINVAL;
+	spin_lock_irqsave(&h->lock, flags);
 	BusTypes = readl(&h->cfgtable->BusTypes);
+	spin_unlock_irqrestore(&h->lock, flags);
 	if (copy_to_user(argp, &BusTypes, sizeof(BusTypes_type)))
 		return -EFAULT;
 	return 0;
diff --git a/drivers/char/random.c b/drivers/char/random.c
index b86eae9..35cfbb0 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -867,16 +867,24 @@ static size_t account(struct entropy_store *r, size_t nbytes, int min,
 	if (r->entropy_count / 8 < min + reserved) {
 		nbytes = 0;
 	} else {
+		int entropy_count, orig;
+retry:
+		entropy_count = orig = ACCESS_ONCE(r->entropy_count);
 		/* If limited, never pull more than available */
-		if (r->limit && nbytes + reserved >= r->entropy_count / 8)
-			nbytes = r->entropy_count/8 - reserved;
-
-		if (r->entropy_count / 8 >= nbytes + reserved)
-			r->entropy_count -= nbytes*8;
-		else
-			r->entropy_count = reserved;
+		if (r->limit && nbytes + reserved >= entropy_count / 8)
+			nbytes = entropy_count/8 - reserved;
+
+		if (entropy_count / 8 >= nbytes + reserved) {
+			entropy_count -= nbytes*8;
+			if (cmpxchg(&r->entropy_count, orig, entropy_count) != orig)
+				goto retry;
+		} else {
+			entropy_count = reserved;
+			if (cmpxchg(&r->entropy_count, orig, entropy_count) != orig)
+				goto retry;
+		}
 
-		if (r->entropy_count < random_write_wakeup_thresh) {
+		if (entropy_count < random_write_wakeup_thresh) {
 			wake_up_interruptible(&random_write_wait);
 			kill_fasync(&fasync, SIGIO, POLL_OUT);
 		}
diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 000d309..6a68d5a 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -1393,10 +1393,12 @@ static void dma_tc_handle(struct d40_chan *d40c)
 			return;
 		}
 
-		if (d40_queue_start(d40c) == NULL)
+		if (d40_queue_start(d40c) == NULL) {
 			d40c->busy = false;
-		pm_runtime_mark_last_busy(d40c->base->dev);
-		pm_runtime_put_autosuspend(d40c->base->dev);
+
+			pm_runtime_mark_last_busy(d40c->base->dev);
+			pm_runtime_put_autosuspend(d40c->base->dev);
+		}
 	}
 
 	d40c->pending_tx++;
diff --git a/drivers/gpu/drm/drm_irq.c b/drivers/gpu/drm/drm_irq.c
index 03f16f3..275bc82 100644
--- a/drivers/gpu/drm/drm_irq.c
+++ b/drivers/gpu/drm/drm_irq.c
@@ -980,7 +980,7 @@ EXPORT_SYMBOL(drm_vblank_off);
  */
 void drm_vblank_pre_modeset(struct drm_device *dev, int crtc)
 {
-	/* vblank is not initialized (IRQ not installed ?) */
+	/* vblank is not initialized (IRQ not installed ?), or has been freed */
 	if (!dev->num_crtcs)
 		return;
 	/*
@@ -1002,6 +1002,10 @@ void drm_vblank_post_modeset(struct drm_device *dev, int crtc)
 {
 	unsigned long irqflags;
 
+	/* vblank is not initialized (IRQ not installed ?), or has been freed */
+	if (!dev->num_crtcs)
+		return;
+
 	if (dev->vblank_inmodeset[crtc]) {
 		spin_lock_irqsave(&dev->vbl_lock, irqflags);
 		dev->vblank_disable_allowed = 1;
diff --git a/drivers/gpu/drm/gma500/cdv_intel_display.c b/drivers/gpu/drm/gma500/cdv_intel_display.c
index a68509b..294fcf5 100644
--- a/drivers/gpu/drm/gma500/cdv_intel_display.c
+++ b/drivers/gpu/drm/gma500/cdv_intel_display.c
@@ -1600,6 +1600,19 @@ static void cdv_intel_crtc_destroy(struct drm_crtc *crtc)
 	kfree(psb_intel_crtc);
 }
 
+static void cdv_intel_crtc_disable(struct drm_crtc *crtc)
+{
+	struct gtt_range *gt;
+	struct drm_crtc_helper_funcs *crtc_funcs = crtc->helper_private;
+
+	crtc_funcs->dpms(crtc, DRM_MODE_DPMS_OFF);
+
+	if (crtc->fb) {
+		gt = to_psb_fb(crtc->fb)->gtt;
+		psb_gtt_unpin(gt);
+	}
+}
+
 const struct drm_crtc_helper_funcs cdv_intel_helper_funcs = {
 	.dpms = cdv_intel_crtc_dpms,
 	.mode_fixup = cdv_intel_crtc_mode_fixup,
@@ -1607,6 +1620,7 @@ const struct drm_crtc_helper_funcs cdv_intel_helper_funcs = {
 	.mode_set_base = cdv_intel_pipe_set_base,
 	.prepare = cdv_intel_crtc_prepare,
 	.commit = cdv_intel_crtc_commit,
+	.disable = cdv_intel_crtc_disable,
 };
 
 const struct drm_crtc_funcs cdv_intel_crtc_funcs = {
diff --git a/drivers/gpu/drm/gma500/framebuffer.c b/drivers/gpu/drm/gma500/framebuffer.c
index 5732b57..71a4b61 100644
--- a/drivers/gpu/drm/gma500/framebuffer.c
+++ b/drivers/gpu/drm/gma500/framebuffer.c
@@ -793,8 +793,8 @@ void psb_modeset_init(struct drm_device *dev)
 	for (i = 0; i < dev_priv->num_pipe; i++)
 		psb_intel_crtc_init(dev, i, mode_dev);
 
-	dev->mode_config.max_width = 2048;
-	dev->mode_config.max_height = 2048;
+	dev->mode_config.max_width = 4096;
+	dev->mode_config.max_height = 4096;
 
 	psb_setup_outputs(dev);
 
diff --git a/drivers/gpu/drm/gma500/psb_intel_display.c b/drivers/gpu/drm/gma500/psb_intel_display.c
index 8033526..8714d6a 100644
--- a/drivers/gpu/drm/gma500/psb_intel_display.c
+++ b/drivers/gpu/drm/gma500/psb_intel_display.c
@@ -1246,6 +1246,19 @@ void psb_intel_crtc_destroy(struct drm_crtc *crtc)
 	kfree(psb_intel_crtc);
 }
 
+static void psb_intel_crtc_disable(struct drm_crtc *crtc)
+{
+	struct gtt_range *gt;
+	struct drm_crtc_helper_funcs *crtc_funcs = crtc->helper_private;
+
+	crtc_funcs->dpms(crtc, DRM_MODE_DPMS_OFF);
+
+	if (crtc->fb) {
+		gt = to_psb_fb(crtc->fb)->gtt;
+		psb_gtt_unpin(gt);
+	}
+}
+
 const struct drm_crtc_helper_funcs psb_intel_helper_funcs = {
 	.dpms = psb_intel_crtc_dpms,
 	.mode_fixup = psb_intel_crtc_mode_fixup,
@@ -1253,6 +1266,7 @@ const struct drm_crtc_helper_funcs psb_intel_helper_funcs = {
 	.mode_set_base = psb_intel_pipe_set_base,
 	.prepare = psb_intel_crtc_prepare,
 	.commit = psb_intel_crtc_commit,
+	.disable = psb_intel_crtc_disable,
 };
 
 const struct drm_crtc_funcs psb_intel_crtc_funcs = {
diff --git a/drivers/gpu/drm/i915/intel_lvds.c b/drivers/gpu/drm/i915/intel_lvds.c
index c78c988..32b6b78 100644
--- a/drivers/gpu/drm/i915/intel_lvds.c
+++ b/drivers/gpu/drm/i915/intel_lvds.c
@@ -742,10 +742,10 @@ static const struct dmi_system_id intel_no_lvds[] = {
 	},
 	{
 		.callback = intel_no_lvds_dmi_callback,
-		.ident = "Hewlett-Packard HP t5740e Thin Client",
+		.ident = "Hewlett-Packard HP t5740",
 		.matches = {
 			DMI_MATCH(DMI_BOARD_VENDOR, "Hewlett-Packard"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "HP t5740e Thin Client"),
+			DMI_MATCH(DMI_PRODUCT_NAME, " t5740"),
 		},
 	},
 	{
diff --git a/drivers/gpu/drm/i915/intel_sdvo.c b/drivers/gpu/drm/i915/intel_sdvo.c
index d554f64..2ee6bf1 100644
--- a/drivers/gpu/drm/i915/intel_sdvo.c
+++ b/drivers/gpu/drm/i915/intel_sdvo.c
@@ -1603,11 +1603,14 @@ static void intel_sdvo_get_lvds_modes(struct drm_connector *connector)
 	 * Assume that the preferred modes are
 	 * arranged in priority order.
 	 */
-	intel_ddc_get_modes(connector, intel_sdvo->i2c);
-	if (list_empty(&connector->probed_modes) == false)
-		goto end;
+	intel_ddc_get_modes(connector, &intel_sdvo->ddc);
 
-	/* Fetch modes from VBT */
+	/*
+	 * Fetch modes from VBT. For SDVO prefer the VBT mode since some
+	 * SDVO->LVDS transcoders can't cope with the EDID mode. Since
+	 * drm_mode_probed_add adds the mode at the head of the list we add it
+	 * last.
+	 */
 	if (dev_priv->sdvo_lvds_vbt_mode != NULL) {
 		newmode = drm_mode_duplicate(connector->dev,
 					     dev_priv->sdvo_lvds_vbt_mode);
@@ -1619,7 +1622,6 @@ static void intel_sdvo_get_lvds_modes(struct drm_connector *connector)
 		}
 	}
 
-end:
 	list_for_each_entry(newmode, &connector->probed_modes, head) {
 		if (newmode->type & DRM_MODE_TYPE_PREFERRED) {
 			intel_sdvo->sdvo_lvds_fixed_mode =
diff --git a/drivers/gpu/drm/mgag200/mgag200_mode.c b/drivers/gpu/drm/mgag200/mgag200_mode.c
index 85ef6cc..64e24f6 100644
--- a/drivers/gpu/drm/mgag200/mgag200_mode.c
+++ b/drivers/gpu/drm/mgag200/mgag200_mode.c
@@ -1042,13 +1042,14 @@ static int mga_crtc_mode_set(struct drm_crtc *crtc,
 			else
 				hi_pri_lvl = 5;
 
-			WREG8(0x1fde, 0x06);
-			WREG8(0x1fdf, hi_pri_lvl);
+			WREG8(MGAREG_CRTCEXT_INDEX, 0x06);
+			WREG8(MGAREG_CRTCEXT_DATA, hi_pri_lvl);
 		} else {
+			WREG8(MGAREG_CRTCEXT_INDEX, 0x06);
 			if (mdev->reg_1e24 >= 0x01)
-				WREG8(0x1fdf, 0x03);
+				WREG8(MGAREG_CRTCEXT_DATA, 0x03);
 			else
-				WREG8(0x1fdf, 0x04);
+				WREG8(MGAREG_CRTCEXT_DATA, 0x04);
 		}
 	}
 	return 0;
diff --git a/drivers/gpu/drm/radeon/atombios_encoders.c b/drivers/gpu/drm/radeon/atombios_encoders.c
index 2eb418e..f14ce9a 100644
--- a/drivers/gpu/drm/radeon/atombios_encoders.c
+++ b/drivers/gpu/drm/radeon/atombios_encoders.c
@@ -396,6 +396,8 @@ atombios_digital_setup(struct drm_encoder *encoder, int action)
 int
 atombios_get_encoder_mode(struct drm_encoder *encoder)
 {
+	struct drm_device *dev = encoder->dev;
+	struct radeon_device *rdev = dev->dev_private;
 	struct radeon_encoder *radeon_encoder = to_radeon_encoder(encoder);
 	struct drm_connector *connector;
 	struct radeon_connector *radeon_connector;
@@ -421,7 +423,8 @@ atombios_get_encoder_mode(struct drm_encoder *encoder)
 	case DRM_MODE_CONNECTOR_DVII:
 	case DRM_MODE_CONNECTOR_HDMIB: /* HDMI-B is basically DL-DVI; analog works fine */
 		if (drm_detect_hdmi_monitor(radeon_connector->edid) &&
-		    radeon_audio)
+		    radeon_audio &&
+		    !ASIC_IS_DCE6(rdev)) /* remove once we support DCE6 */
 			return ATOM_ENCODER_MODE_HDMI;
 		else if (radeon_connector->use_digital)
 			return ATOM_ENCODER_MODE_DVI;
@@ -432,7 +435,8 @@ atombios_get_encoder_mode(struct drm_encoder *encoder)
 	case DRM_MODE_CONNECTOR_HDMIA:
 	default:
 		if (drm_detect_hdmi_monitor(radeon_connector->edid) &&
-		    radeon_audio)
+		    radeon_audio &&
+		    !ASIC_IS_DCE6(rdev)) /* remove once we support DCE6 */
 			return ATOM_ENCODER_MODE_HDMI;
 		else
 			return ATOM_ENCODER_MODE_DVI;
@@ -446,7 +450,8 @@ atombios_get_encoder_mode(struct drm_encoder *encoder)
 		    (dig_connector->dp_sink_type == CONNECTOR_OBJECT_ID_eDP))
 			return ATOM_ENCODER_MODE_DP;
 		else if (drm_detect_hdmi_monitor(radeon_connector->edid) &&
-			 radeon_audio)
+			 radeon_audio &&
+			 !ASIC_IS_DCE6(rdev)) /* remove once we support DCE6 */
 			return ATOM_ENCODER_MODE_HDMI;
 		else
 			return ATOM_ENCODER_MODE_DVI;
diff --git a/drivers/gpu/drm/radeon/evergreen.c b/drivers/gpu/drm/radeon/evergreen.c
index 5cec317..f3e0e8e 100644
--- a/drivers/gpu/drm/radeon/evergreen.c
+++ b/drivers/gpu/drm/radeon/evergreen.c
@@ -3221,6 +3221,12 @@ static int evergreen_startup(struct radeon_device *rdev)
 	}
 
 	/* Enable IRQ */
+	if (!rdev->irq.installed) {
+		r = radeon_irq_kms_init(rdev);
+		if (r)
+			return r;
+	}
+
 	r = r600_irq_init(rdev);
 	if (r) {
 		DRM_ERROR("radeon: IH init failed (%d).\n", r);
@@ -3360,10 +3366,6 @@ int evergreen_init(struct radeon_device *rdev)
 	if (r)
 		return r;
 
-	r = radeon_irq_kms_init(rdev);
-	if (r)
-		return r;
-
 	rdev->ring[RADEON_RING_TYPE_GFX_INDEX].ring_obj = NULL;
 	r600_ring_init(rdev, &rdev->ring[RADEON_RING_TYPE_GFX_INDEX], 1024 * 1024);
 
@@ -3423,8 +3425,7 @@ void evergreen_fini(struct radeon_device *rdev)
 
 void evergreen_pcie_gen2_enable(struct radeon_device *rdev)
 {
-	u32 link_width_cntl, speed_cntl, mask;
-	int ret;
+	u32 link_width_cntl, speed_cntl;
 
 	if (radeon_pcie_gen2 == 0)
 		return;
@@ -3439,11 +3440,8 @@ void evergreen_pcie_gen2_enable(struct radeon_device *rdev)
 	if (ASIC_IS_X2(rdev))
 		return;
 
-	ret = drm_pcie_get_speed_cap_mask(rdev->ddev, &mask);
-	if (ret != 0)
-		return;
-
-	if (!(mask & DRM_PCIE_SPEED_50))
+	if ((rdev->pdev->bus->max_bus_speed != PCIE_SPEED_5_0GT) &&
+		(rdev->pdev->bus->max_bus_speed != PCIE_SPEED_8_0GT))
 		return;
 
 	DRM_INFO("enabling PCIE gen 2 link speeds, disable with radeon.pcie_gen2=0\n");
diff --git a/drivers/gpu/drm/radeon/ni.c b/drivers/gpu/drm/radeon/ni.c
index 62ff39f..b55413e 100644
--- a/drivers/gpu/drm/radeon/ni.c
+++ b/drivers/gpu/drm/radeon/ni.c
@@ -1298,6 +1298,12 @@ static int cayman_startup(struct radeon_device *rdev)
 	}
 
 	/* Enable IRQ */
+	if (!rdev->irq.installed) {
+		r = radeon_irq_kms_init(rdev);
+		if (r)
+			return r;
+	}
+
 	r = r600_irq_init(rdev);
 	if (r) {
 		DRM_ERROR("radeon: IH init failed (%d).\n", r);
@@ -1422,10 +1428,6 @@ int cayman_init(struct radeon_device *rdev)
 	if (r)
 		return r;
 
-	r = radeon_irq_kms_init(rdev);
-	if (r)
-		return r;
-
 	ring->ring_obj = NULL;
 	r600_ring_init(rdev, ring, 1024 * 1024);
 
diff --git a/drivers/gpu/drm/radeon/r100.c b/drivers/gpu/drm/radeon/r100.c
index b08b5b9..1714fbe 100644
--- a/drivers/gpu/drm/radeon/r100.c
+++ b/drivers/gpu/drm/radeon/r100.c
@@ -4038,6 +4038,12 @@ static int r100_startup(struct radeon_device *rdev)
 	}
 
 	/* Enable IRQ */
+	if (!rdev->irq.installed) {
+		r = radeon_irq_kms_init(rdev);
+		if (r)
+			return r;
+	}
+
 	r100_irq_set(rdev);
 	rdev->config.r100.hdp_cntl = RREG32(RADEON_HOST_PATH_CNTL);
 	/* 1M ring buffer */
@@ -4193,9 +4199,6 @@ int r100_init(struct radeon_device *rdev)
 	r = radeon_fence_driver_init(rdev);
 	if (r)
 		return r;
-	r = radeon_irq_kms_init(rdev);
-	if (r)
-		return r;
 	/* Memory manager */
 	r = radeon_bo_init(rdev);
 	if (r)
diff --git a/drivers/gpu/drm/radeon/r300.c b/drivers/gpu/drm/radeon/r300.c
index 646a192..9c96b51 100644
--- a/drivers/gpu/drm/radeon/r300.c
+++ b/drivers/gpu/drm/radeon/r300.c
@@ -1382,6 +1382,12 @@ static int r300_startup(struct radeon_device *rdev)
 	}
 
 	/* Enable IRQ */
+	if (!rdev->irq.installed) {
+		r = radeon_irq_kms_init(rdev);
+		if (r)
+			return r;
+	}
+
 	r100_irq_set(rdev);
 	rdev->config.r300.hdp_cntl = RREG32(RADEON_HOST_PATH_CNTL);
 	/* 1M ring buffer */
@@ -1516,9 +1522,6 @@ int r300_init(struct radeon_device *rdev)
 	r = radeon_fence_driver_init(rdev);
 	if (r)
 		return r;
-	r = radeon_irq_kms_init(rdev);
-	if (r)
-		return r;
 	/* Memory manager */
 	r = radeon_bo_init(rdev);
 	if (r)
diff --git a/drivers/gpu/drm/radeon/r420.c b/drivers/gpu/drm/radeon/r420.c
index f2f5bf6..e12d8df 100644
--- a/drivers/gpu/drm/radeon/r420.c
+++ b/drivers/gpu/drm/radeon/r420.c
@@ -265,6 +265,12 @@ static int r420_startup(struct radeon_device *rdev)
 	}
 
 	/* Enable IRQ */
+	if (!rdev->irq.installed) {
+		r = radeon_irq_kms_init(rdev);
+		if (r)
+			return r;
+	}
+
 	r100_irq_set(rdev);
 	rdev->config.r300.hdp_cntl = RREG32(RADEON_HOST_PATH_CNTL);
 	/* 1M ring buffer */
@@ -411,10 +417,6 @@ int r420_init(struct radeon_device *rdev)
 	if (r) {
 		return r;
 	}
-	r = radeon_irq_kms_init(rdev);
-	if (r) {
-		return r;
-	}
 	/* Memory manager */
 	r = radeon_bo_init(rdev);
 	if (r) {
diff --git a/drivers/gpu/drm/radeon/r520.c b/drivers/gpu/drm/radeon/r520.c
index 079d3c5..f06c2e4 100644
--- a/drivers/gpu/drm/radeon/r520.c
+++ b/drivers/gpu/drm/radeon/r520.c
@@ -194,6 +194,12 @@ static int r520_startup(struct radeon_device *rdev)
 	}
 
 	/* Enable IRQ */
+	if (!rdev->irq.installed) {
+		r = radeon_irq_kms_init(rdev);
+		if (r)
+			return r;
+	}
+
 	rs600_irq_set(rdev);
 	rdev->config.r300.hdp_cntl = RREG32(RADEON_HOST_PATH_CNTL);
 	/* 1M ring buffer */
@@ -297,9 +303,6 @@ int r520_init(struct radeon_device *rdev)
 	r = radeon_fence_driver_init(rdev);
 	if (r)
 		return r;
-	r = radeon_irq_kms_init(rdev);
-	if (r)
-		return r;
 	/* Memory manager */
 	r = radeon_bo_init(rdev);
 	if (r)
diff --git a/drivers/gpu/drm/radeon/r600.c b/drivers/gpu/drm/radeon/r600.c
index d79c639..4c6b4156 100644
--- a/drivers/gpu/drm/radeon/r600.c
+++ b/drivers/gpu/drm/radeon/r600.c
@@ -2395,6 +2395,12 @@ int r600_startup(struct radeon_device *rdev)
 	}
 
 	/* Enable IRQ */
+	if (!rdev->irq.installed) {
+		r = radeon_irq_kms_init(rdev);
+		if (r)
+			return r;
+	}
+
 	r = r600_irq_init(rdev);
 	if (r) {
 		DRM_ERROR("radeon: IH init failed (%d).\n", r);
@@ -2537,10 +2543,6 @@ int r600_init(struct radeon_device *rdev)
 	if (r)
 		return r;
 
-	r = radeon_irq_kms_init(rdev);
-	if (r)
-		return r;
-
 	rdev->ring[RADEON_RING_TYPE_GFX_INDEX].ring_obj = NULL;
 	r600_ring_init(rdev, &rdev->ring[RADEON_RING_TYPE_GFX_INDEX], 1024 * 1024);
 
@@ -3681,8 +3683,6 @@ static void r600_pcie_gen2_enable(struct radeon_device *rdev)
 {
 	u32 link_width_cntl, lanes, speed_cntl, training_cntl, tmp;
 	u16 link_cntl2;
-	u32 mask;
-	int ret;
 
 	if (radeon_pcie_gen2 == 0)
 		return;
@@ -3701,11 +3701,8 @@ static void r600_pcie_gen2_enable(struct radeon_device *rdev)
 	if (rdev->family <= CHIP_R600)
 		return;
 
-	ret = drm_pcie_get_speed_cap_mask(rdev->ddev, &mask);
-	if (ret != 0)
-		return;
-
-	if (!(mask & DRM_PCIE_SPEED_50))
+	if ((rdev->pdev->bus->max_bus_speed != PCIE_SPEED_5_0GT) &&
+		(rdev->pdev->bus->max_bus_speed != PCIE_SPEED_8_0GT))
 		return;
 
 	DRM_INFO("enabling PCIE gen 2 link speeds, disable with radeon.pcie_gen2=0\n");
diff --git a/drivers/gpu/drm/radeon/radeon_device.c b/drivers/gpu/drm/radeon/radeon_device.c
index 7a3daeb..32cea73 100644
--- a/drivers/gpu/drm/radeon/radeon_device.c
+++ b/drivers/gpu/drm/radeon/radeon_device.c
@@ -431,18 +431,17 @@ bool radeon_card_posted(struct radeon_device *rdev)
 		return false;
 
 	/* first check CRTCs */
-	if (ASIC_IS_DCE41(rdev)) {
+	if (ASIC_IS_DCE4(rdev)) {
 		reg = RREG32(EVERGREEN_CRTC_CONTROL + EVERGREEN_CRTC0_REGISTER_OFFSET) |
 			RREG32(EVERGREEN_CRTC_CONTROL + EVERGREEN_CRTC1_REGISTER_OFFSET);
-		if (reg & EVERGREEN_CRTC_MASTER_EN)
-			return true;
-	} else if (ASIC_IS_DCE4(rdev)) {
-		reg = RREG32(EVERGREEN_CRTC_CONTROL + EVERGREEN_CRTC0_REGISTER_OFFSET) |
-			RREG32(EVERGREEN_CRTC_CONTROL + EVERGREEN_CRTC1_REGISTER_OFFSET) |
-			RREG32(EVERGREEN_CRTC_CONTROL + EVERGREEN_CRTC2_REGISTER_OFFSET) |
-			RREG32(EVERGREEN_CRTC_CONTROL + EVERGREEN_CRTC3_REGISTER_OFFSET) |
-			RREG32(EVERGREEN_CRTC_CONTROL + EVERGREEN_CRTC4_REGISTER_OFFSET) |
-			RREG32(EVERGREEN_CRTC_CONTROL + EVERGREEN_CRTC5_REGISTER_OFFSET);
+			if (rdev->num_crtc >= 4) {
+				reg |= RREG32(EVERGREEN_CRTC_CONTROL + EVERGREEN_CRTC2_REGISTER_OFFSET) |
+					RREG32(EVERGREEN_CRTC_CONTROL + EVERGREEN_CRTC3_REGISTER_OFFSET);
+			}
+			if (rdev->num_crtc >= 6) {
+				reg |= RREG32(EVERGREEN_CRTC_CONTROL + EVERGREEN_CRTC4_REGISTER_OFFSET) |
+					RREG32(EVERGREEN_CRTC_CONTROL + EVERGREEN_CRTC5_REGISTER_OFFSET);
+			}
 		if (reg & EVERGREEN_CRTC_MASTER_EN)
 			return true;
 	} else if (ASIC_IS_AVIVO(rdev)) {
diff --git a/drivers/gpu/drm/radeon/rs400.c b/drivers/gpu/drm/radeon/rs400.c
index 2752f7f..21d2d28 100644
--- a/drivers/gpu/drm/radeon/rs400.c
+++ b/drivers/gpu/drm/radeon/rs400.c
@@ -417,6 +417,12 @@ static int rs400_startup(struct radeon_device *rdev)
 	}
 
 	/* Enable IRQ */
+	if (!rdev->irq.installed) {
+		r = radeon_irq_kms_init(rdev);
+		if (r)
+			return r;
+	}
+
 	r100_irq_set(rdev);
 	rdev->config.r300.hdp_cntl = RREG32(RADEON_HOST_PATH_CNTL);
 	/* 1M ring buffer */
@@ -535,9 +541,6 @@ int rs400_init(struct radeon_device *rdev)
 	r = radeon_fence_driver_init(rdev);
 	if (r)
 		return r;
-	r = radeon_irq_kms_init(rdev);
-	if (r)
-		return r;
 	/* Memory manager */
 	r = radeon_bo_init(rdev);
 	if (r)
diff --git a/drivers/gpu/drm/radeon/rs600.c b/drivers/gpu/drm/radeon/rs600.c
index 78aa835..9a156a5 100644
--- a/drivers/gpu/drm/radeon/rs600.c
+++ b/drivers/gpu/drm/radeon/rs600.c
@@ -938,6 +938,12 @@ static int rs600_startup(struct radeon_device *rdev)
 	}
 
 	/* Enable IRQ */
+	if (!rdev->irq.installed) {
+		r = radeon_irq_kms_init(rdev);
+		if (r)
+			return r;
+	}
+
 	rs600_irq_set(rdev);
 	rdev->config.r300.hdp_cntl = RREG32(RADEON_HOST_PATH_CNTL);
 	/* 1M ring buffer */
@@ -1062,9 +1068,6 @@ int rs600_init(struct radeon_device *rdev)
 	r = radeon_fence_driver_init(rdev);
 	if (r)
 		return r;
-	r = radeon_irq_kms_init(rdev);
-	if (r)
-		return r;
 	/* Memory manager */
 	r = radeon_bo_init(rdev);
 	if (r)
diff --git a/drivers/gpu/drm/radeon/rs690.c b/drivers/gpu/drm/radeon/rs690.c
index 3b663fc..c2fc0e0 100644
--- a/drivers/gpu/drm/radeon/rs690.c
+++ b/drivers/gpu/drm/radeon/rs690.c
@@ -628,6 +628,12 @@ static int rs690_startup(struct radeon_device *rdev)
 	}
 
 	/* Enable IRQ */
+	if (!rdev->irq.installed) {
+		r = radeon_irq_kms_init(rdev);
+		if (r)
+			return r;
+	}
+
 	rs600_irq_set(rdev);
 	rdev->config.r300.hdp_cntl = RREG32(RADEON_HOST_PATH_CNTL);
 	/* 1M ring buffer */
@@ -753,9 +759,6 @@ int rs690_init(struct radeon_device *rdev)
 	r = radeon_fence_driver_init(rdev);
 	if (r)
 		return r;
-	r = radeon_irq_kms_init(rdev);
-	if (r)
-		return r;
 	/* Memory manager */
 	r = radeon_bo_init(rdev);
 	if (r)
diff --git a/drivers/gpu/drm/radeon/rv515.c b/drivers/gpu/drm/radeon/rv515.c
index aa8ef49..dd20348 100644
--- a/drivers/gpu/drm/radeon/rv515.c
+++ b/drivers/gpu/drm/radeon/rv515.c
@@ -386,6 +386,12 @@ static int rv515_startup(struct radeon_device *rdev)
 	}
 
 	/* Enable IRQ */
+	if (!rdev->irq.installed) {
+		r = radeon_irq_kms_init(rdev);
+		if (r)
+			return r;
+	}
+
 	rs600_irq_set(rdev);
 	rdev->config.r300.hdp_cntl = RREG32(RADEON_HOST_PATH_CNTL);
 	/* 1M ring buffer */
@@ -516,9 +522,6 @@ int rv515_init(struct radeon_device *rdev)
 	r = radeon_fence_driver_init(rdev);
 	if (r)
 		return r;
-	r = radeon_irq_kms_init(rdev);
-	if (r)
-		return r;
 	/* Memory manager */
 	r = radeon_bo_init(rdev);
 	if (r)
diff --git a/drivers/gpu/drm/radeon/rv770.c b/drivers/gpu/drm/radeon/rv770.c
index ca8ffec..a4c4dc6 100644
--- a/drivers/gpu/drm/radeon/rv770.c
+++ b/drivers/gpu/drm/radeon/rv770.c
@@ -933,6 +933,12 @@ static int rv770_startup(struct radeon_device *rdev)
 	}
 
 	/* Enable IRQ */
+	if (!rdev->irq.installed) {
+		r = radeon_irq_kms_init(rdev);
+		if (r)
+			return r;
+	}
+
 	r = r600_irq_init(rdev);
 	if (r) {
 		DRM_ERROR("radeon: IH init failed (%d).\n", r);
@@ -1059,10 +1065,6 @@ int rv770_init(struct radeon_device *rdev)
 	if (r)
 		return r;
 
-	r = radeon_irq_kms_init(rdev);
-	if (r)
-		return r;
-
 	rdev->ring[RADEON_RING_TYPE_GFX_INDEX].ring_obj = NULL;
 	r600_ring_init(rdev, &rdev->ring[RADEON_RING_TYPE_GFX_INDEX], 1024 * 1024);
 
@@ -1112,8 +1114,6 @@ static void rv770_pcie_gen2_enable(struct radeon_device *rdev)
 {
 	u32 link_width_cntl, lanes, speed_cntl, tmp;
 	u16 link_cntl2;
-	u32 mask;
-	int ret;
 
 	if (radeon_pcie_gen2 == 0)
 		return;
@@ -1128,11 +1128,8 @@ static void rv770_pcie_gen2_enable(struct radeon_device *rdev)
 	if (ASIC_IS_X2(rdev))
 		return;
 
-	ret = drm_pcie_get_speed_cap_mask(rdev->ddev, &mask);
-	if (ret != 0)
-		return;
-
-	if (!(mask & DRM_PCIE_SPEED_50))
+	if ((rdev->pdev->bus->max_bus_speed != PCIE_SPEED_5_0GT) &&
+		(rdev->pdev->bus->max_bus_speed != PCIE_SPEED_8_0GT))
 		return;
 
 	DRM_INFO("enabling PCIE gen 2 link speeds, disable with radeon.pcie_gen2=0\n");
diff --git a/drivers/gpu/drm/radeon/si.c b/drivers/gpu/drm/radeon/si.c
index 7d0026b..d8cc781 100644
--- a/drivers/gpu/drm/radeon/si.c
+++ b/drivers/gpu/drm/radeon/si.c
@@ -1556,7 +1556,7 @@ static void si_gpu_init(struct radeon_device *rdev)
 	default:
 		rdev->config.si.max_shader_engines = 1;
 		rdev->config.si.max_tile_pipes = 4;
-		rdev->config.si.max_cu_per_sh = 2;
+		rdev->config.si.max_cu_per_sh = 5;
 		rdev->config.si.max_sh_per_se = 2;
 		rdev->config.si.max_backends_per_se = 4;
 		rdev->config.si.max_texture_channel_caches = 4;
@@ -3757,6 +3757,12 @@ static int si_startup(struct radeon_device *rdev)
 	}
 
 	/* Enable IRQ */
+	if (!rdev->irq.installed) {
+		r = radeon_irq_kms_init(rdev);
+		if (r)
+			return r;
+	}
+
 	r = si_irq_init(rdev);
 	if (r) {
 		DRM_ERROR("radeon: IH init failed (%d).\n", r);
@@ -3898,10 +3904,6 @@ int si_init(struct radeon_device *rdev)
 	if (r)
 		return r;
 
-	r = radeon_irq_kms_init(rdev);
-	if (r)
-		return r;
-
 	ring = &rdev->ring[RADEON_RING_TYPE_GFX_INDEX];
 	ring->ring_obj = NULL;
 	r600_ring_init(rdev, ring, 1024 * 1024);
diff --git a/drivers/hwmon/adm1021.c b/drivers/hwmon/adm1021.c
index fd1d1b1..f9df316 100644
--- a/drivers/hwmon/adm1021.c
+++ b/drivers/hwmon/adm1021.c
@@ -332,26 +332,68 @@ static int adm1021_detect(struct i2c_client *client,
 	man_id = i2c_smbus_read_byte_data(client, ADM1021_REG_MAN_ID);
 	dev_id = i2c_smbus_read_byte_data(client, ADM1021_REG_DEV_ID);
 
+	if (man_id < 0 || dev_id < 0)
+		return -ENODEV;
+
 	if (man_id == 0x4d && dev_id == 0x01)
 		type_name = "max1617a";
 	else if (man_id == 0x41) {
 		if ((dev_id & 0xF0) == 0x30)
 			type_name = "adm1023";
-		else
+		else if ((dev_id & 0xF0) == 0x00)
 			type_name = "adm1021";
+		else
+			return -ENODEV;
 	} else if (man_id == 0x49)
 		type_name = "thmc10";
 	else if (man_id == 0x23)
 		type_name = "gl523sm";
 	else if (man_id == 0x54)
 		type_name = "mc1066";
-	/* LM84 Mfr ID in a different place, and it has more unused bits */
-	else if (conv_rate == 0x00
-		 && (config & 0x7F) == 0x00
-		 && (status & 0xAB) == 0x00)
-		type_name = "lm84";
-	else
-		type_name = "max1617";
+	else {
+		int lte, rte, lhi, rhi, llo, rlo;
+
+		/* extra checks for LM84 and MAX1617 to avoid misdetections */
+
+		llo = i2c_smbus_read_byte_data(client, ADM1021_REG_THYST_R(0));
+		rlo = i2c_smbus_read_byte_data(client, ADM1021_REG_THYST_R(1));
+
+		/* fail if any of the additional register reads failed */
+		if (llo < 0 || rlo < 0)
+			return -ENODEV;
+
+		lte = i2c_smbus_read_byte_data(client, ADM1021_REG_TEMP(0));
+		rte = i2c_smbus_read_byte_data(client, ADM1021_REG_TEMP(1));
+		lhi = i2c_smbus_read_byte_data(client, ADM1021_REG_TOS_R(0));
+		rhi = i2c_smbus_read_byte_data(client, ADM1021_REG_TOS_R(1));
+
+		/*
+		 * Fail for negative temperatures and negative high limits.
+		 * This check also catches read errors on the tested registers.
+		 */
+		if ((s8)lte < 0 || (s8)rte < 0 || (s8)lhi < 0 || (s8)rhi < 0)
+			return -ENODEV;
+
+		/* fail if all registers hold the same value */
+		if (lte == rte && lte == lhi && lte == rhi && lte == llo
+		    && lte == rlo)
+			return -ENODEV;
+
+		/*
+		 * LM84 Mfr ID is in a different place,
+		 * and it has more unused bits.
+		 */
+		if (conv_rate == 0x00
+		    && (config & 0x7F) == 0x00
+		    && (status & 0xAB) == 0x00) {
+			type_name = "lm84";
+		} else {
+			/* fail if low limits are larger than high limits */
+			if ((s8)llo > lhi || (s8)rlo > rhi)
+				return -ENODEV;
+			type_name = "max1617";
+		}
+	}
 
 	pr_debug("adm1021: Detected chip %s at adapter %d, address 0x%02x.\n",
 		 type_name, i2c_adapter_id(adapter), client->addr);
diff --git a/drivers/iio/frequency/adf4350.c b/drivers/iio/frequency/adf4350.c
index e35bb8f..3e2a01c 100644
--- a/drivers/iio/frequency/adf4350.c
+++ b/drivers/iio/frequency/adf4350.c
@@ -212,7 +212,7 @@ static int adf4350_set_freq(struct adf4350_state *st, unsigned long long freq)
 		(pdata->r2_user_settings & (ADF4350_REG2_PD_POLARITY_POS |
 		ADF4350_REG2_LDP_6ns | ADF4350_REG2_LDF_INT_N |
 		ADF4350_REG2_CHARGE_PUMP_CURR_uA(5000) |
-		ADF4350_REG2_MUXOUT(0x7) | ADF4350_REG2_NOISE_MODE(0x9)));
+		ADF4350_REG2_MUXOUT(0x7) | ADF4350_REG2_NOISE_MODE(0x3)));
 
 	st->regs[ADF4350_REG3] = pdata->r3_user_settings &
 				 (ADF4350_REG3_12BIT_CLKDIV(0xFFF) |
diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 9e1449f..1f269f1 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -2276,6 +2276,27 @@ static void srpt_close_ch(struct srpt_rdma_ch *ch)
 }
 
 /**
+ * srpt_shutdown_session() - Whether or not a session may be shut down.
+ */
+static int srpt_shutdown_session(struct se_session *se_sess)
+{
+	struct srpt_rdma_ch *ch = se_sess->fabric_sess_ptr;
+	unsigned long flags;
+
+	spin_lock_irqsave(&ch->spinlock, flags);
+	if (ch->in_shutdown) {
+		spin_unlock_irqrestore(&ch->spinlock, flags);
+		return true;
+	}
+
+	ch->in_shutdown = true;
+	target_sess_cmd_list_set_waiting(se_sess);
+	spin_unlock_irqrestore(&ch->spinlock, flags);
+
+	return true;
+}
+
+/**
  * srpt_drain_channel() - Drain a channel by resetting the IB queue pair.
  * @cm_id: Pointer to the CM ID of the channel to be drained.
  *
@@ -2313,6 +2334,9 @@ static void srpt_drain_channel(struct ib_cm_id *cm_id)
 	spin_unlock_irq(&sdev->spinlock);
 
 	if (do_reset) {
+		if (ch->sess)
+			srpt_shutdown_session(ch->sess);
+
 		ret = srpt_ch_qp_err(ch);
 		if (ret < 0)
 			printk(KERN_ERR "Setting queue pair in error state"
@@ -3493,14 +3517,6 @@ static void srpt_release_cmd(struct se_cmd *se_cmd)
 }
 
 /**
- * srpt_shutdown_session() - Whether or not a session may be shut down.
- */
-static int srpt_shutdown_session(struct se_session *se_sess)
-{
-	return true;
-}
-
-/**
  * srpt_close_session() - Forcibly close a session.
  *
  * Callback function invoked by the TCM core to clean up sessions associated
diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.h b/drivers/infiniband/ulp/srpt/ib_srpt.h
index 61e52b8..01b7791 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.h
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.h
@@ -326,6 +326,7 @@ struct srpt_rdma_ch {
 	u8			sess_name[36];
 	struct work_struct	release_work;
 	struct completion	*release_done;
+	bool			in_shutdown;
 };
 
 /**
diff --git a/drivers/input/touchscreen/egalax_ts.c b/drivers/input/touchscreen/egalax_ts.c
index 70524dd..be2a271 100644
--- a/drivers/input/touchscreen/egalax_ts.c
+++ b/drivers/input/touchscreen/egalax_ts.c
@@ -203,7 +203,7 @@ static int __devinit egalax_ts_probe(struct i2c_client *client,
 	input_set_abs_params(input_dev,
 			     ABS_MT_POSITION_X, 0, EGALAX_MAX_X, 0, 0);
 	input_set_abs_params(input_dev,
-			     ABS_MT_POSITION_X, 0, EGALAX_MAX_Y, 0, 0);
+			     ABS_MT_POSITION_Y, 0, EGALAX_MAX_Y, 0, 0);
 	input_mt_init_slots(input_dev, MAX_SUPPORT_POINTS);
 
 	input_set_drvdata(input_dev, ts);
diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index c698cf6..e5c773d 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -598,11 +598,23 @@ retry:
 
 static void iommu_poll_events(struct amd_iommu *iommu)
 {
-	u32 head, tail;
+	u32 head, tail, status;
 	unsigned long flags;
 
 	spin_lock_irqsave(&iommu->lock, flags);
 
+	/* enable event interrupts again */
+	do {
+		/*
+		 * Workaround for Erratum ERBT1312
+		 * Clearing the EVT_INT bit may race in the hardware, so read
+		 * it again and make sure it was really cleared
+		 */
+		status = readl(iommu->mmio_base + MMIO_STATUS_OFFSET);
+		writel(MMIO_STATUS_EVT_INT_MASK,
+		       iommu->mmio_base + MMIO_STATUS_OFFSET);
+	} while (status & MMIO_STATUS_EVT_INT_MASK);
+
 	head = readl(iommu->mmio_base + MMIO_EVT_HEAD_OFFSET);
 	tail = readl(iommu->mmio_base + MMIO_EVT_TAIL_OFFSET);
 
@@ -639,16 +651,25 @@ static void iommu_handle_ppr_entry(struct amd_iommu *iommu, u64 *raw)
 static void iommu_poll_ppr_log(struct amd_iommu *iommu)
 {
 	unsigned long flags;
-	u32 head, tail;
+	u32 head, tail, status;
 
 	if (iommu->ppr_log == NULL)
 		return;
 
-	/* enable ppr interrupts again */
-	writel(MMIO_STATUS_PPR_INT_MASK, iommu->mmio_base + MMIO_STATUS_OFFSET);
-
 	spin_lock_irqsave(&iommu->lock, flags);
 
+	/* enable ppr interrupts again */
+	do {
+		/*
+		 * Workaround for Erratum ERBT1312
+		 * Clearing the PPR_INT bit may race in the hardware, so read
+		 * it again and make sure it was really cleared
+		 */
+		status = readl(iommu->mmio_base + MMIO_STATUS_OFFSET);
+		writel(MMIO_STATUS_PPR_INT_MASK,
+		       iommu->mmio_base + MMIO_STATUS_OFFSET);
+	} while (status & MMIO_STATUS_PPR_INT_MASK);
+
 	head = readl(iommu->mmio_base + MMIO_PPR_HEAD_OFFSET);
 	tail = readl(iommu->mmio_base + MMIO_PPR_TAIL_OFFSET);
 
diff --git a/drivers/iommu/amd_iommu_types.h b/drivers/iommu/amd_iommu_types.h
index d0dab86..c6d556c 100644
--- a/drivers/iommu/amd_iommu_types.h
+++ b/drivers/iommu/amd_iommu_types.h
@@ -99,6 +99,7 @@
 #define PASID_MASK		0x000fffff
 
 /* MMIO status bits */
+#define MMIO_STATUS_EVT_INT_MASK	(1 << 1)
 #define MMIO_STATUS_COM_WAIT_INT_MASK	(1 << 2)
 #define MMIO_STATUS_PPR_INT_MASK	(1 << 6)
 
diff --git a/drivers/leds/leds-ot200.c b/drivers/leds/leds-ot200.c
index c464682..676e729 100644
--- a/drivers/leds/leds-ot200.c
+++ b/drivers/leds/leds-ot200.c
@@ -47,37 +47,37 @@ static struct ot200_led leds[] = {
 	{
 		.name = "led_1",
 		.port = 0x49,
-		.mask = BIT(7),
+		.mask = BIT(6),
 	},
 	{
 		.name = "led_2",
 		.port = 0x49,
-		.mask = BIT(6),
+		.mask = BIT(5),
 	},
 	{
 		.name = "led_3",
 		.port = 0x49,
-		.mask = BIT(5),
+		.mask = BIT(4),
 	},
 	{
 		.name = "led_4",
 		.port = 0x49,
-		.mask = BIT(4),
+		.mask = BIT(3),
 	},
 	{
 		.name = "led_5",
 		.port = 0x49,
-		.mask = BIT(3),
+		.mask = BIT(2),
 	},
 	{
 		.name = "led_6",
 		.port = 0x49,
-		.mask = BIT(2),
+		.mask = BIT(1),
 	},
 	{
 		.name = "led_7",
 		.port = 0x49,
-		.mask = BIT(1),
+		.mask = BIT(0),
 	}
 };
 
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 36c6003..4347a70 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -427,7 +427,17 @@ static void raid1_end_write_request(struct bio *bio, int error)
 
 		r1_bio->bios[mirror] = NULL;
 		to_put = bio;
-		set_bit(R1BIO_Uptodate, &r1_bio->state);
+		/*
+		 * Do not set R1BIO_Uptodate if the current device is
+		 * rebuilding or Faulty. This is because we cannot use
+		 * such device for properly reading the data back (we could
+		 * potentially use it, if the current write would have felt
+		 * before rdev->recovery_offset, but for simplicity we don't
+		 * check this here.
+		 */
+		if (test_bit(In_sync, &conf->mirrors[mirror].rdev->flags) &&
+		    !test_bit(Faulty, &conf->mirrors[mirror].rdev->flags))
+			set_bit(R1BIO_Uptodate, &r1_bio->state);
 
 		/* Maybe we can clear some bad blocks. */
 		if (is_badblock(conf->mirrors[mirror].rdev,
@@ -876,17 +886,17 @@ static void allow_barrier(struct r1conf *conf)
 	wake_up(&conf->wait_barrier);
 }
 
-static void freeze_array(struct r1conf *conf)
+static void freeze_array(struct r1conf *conf, int extra)
 {
 	/* stop syncio and normal IO and wait for everything to
 	 * go quite.
 	 * We increment barrier and nr_waiting, and then
-	 * wait until nr_pending match nr_queued+1
+	 * wait until nr_pending match nr_queued+extra
 	 * This is called in the context of one normal IO request
 	 * that has failed. Thus any sync request that might be pending
 	 * will be blocked by nr_pending, and we need to wait for
 	 * pending IO requests to complete or be queued for re-try.
-	 * Thus the number queued (nr_queued) plus this request (1)
+	 * Thus the number queued (nr_queued) plus this request (extra)
 	 * must match the number of pending IOs (nr_pending) before
 	 * we continue.
 	 */
@@ -894,7 +904,7 @@ static void freeze_array(struct r1conf *conf)
 	conf->barrier++;
 	conf->nr_waiting++;
 	wait_event_lock_irq(conf->wait_barrier,
-			    conf->nr_pending == conf->nr_queued+1,
+			    conf->nr_pending == conf->nr_queued+extra,
 			    conf->resync_lock,
 			    flush_pending_writes(conf));
 	spin_unlock_irq(&conf->resync_lock);
@@ -1549,8 +1559,8 @@ static int raid1_add_disk(struct mddev *mddev, struct md_rdev *rdev)
 		 * we wait for all outstanding requests to complete.
 		 */
 		synchronize_sched();
-		raise_barrier(conf);
-		lower_barrier(conf);
+		freeze_array(conf, 0);
+		unfreeze_array(conf);
 		clear_bit(Unmerged, &rdev->flags);
 	}
 	md_integrity_add_rdev(rdev, mddev);
@@ -1598,11 +1608,11 @@ static int raid1_remove_disk(struct mddev *mddev, struct md_rdev *rdev)
 			 */
 			struct md_rdev *repl =
 				conf->mirrors[conf->raid_disks + number].rdev;
-			raise_barrier(conf);
+			freeze_array(conf, 0);
 			clear_bit(Replacement, &repl->flags);
 			p->rdev = repl;
 			conf->mirrors[conf->raid_disks + number].rdev = NULL;
-			lower_barrier(conf);
+			unfreeze_array(conf);
 			clear_bit(WantReplacement, &rdev->flags);
 		} else
 			clear_bit(WantReplacement, &rdev->flags);
@@ -2219,7 +2229,7 @@ static void handle_read_error(struct r1conf *conf, struct r1bio *r1_bio)
 	 * frozen
 	 */
 	if (mddev->ro == 0) {
-		freeze_array(conf);
+		freeze_array(conf, 1);
 		fix_read_error(conf, r1_bio->read_disk,
 			       r1_bio->sector, r1_bio->sectors);
 		unfreeze_array(conf);
@@ -2983,7 +2993,7 @@ static int raid1_reshape(struct mddev *mddev)
 		return -ENOMEM;
 	}
 
-	raise_barrier(conf);
+	freeze_array(conf, 0);
 
 	/* ok, everything is stopped */
 	oldpool = conf->r1bio_pool;
@@ -3014,7 +3024,7 @@ static int raid1_reshape(struct mddev *mddev)
 	conf->raid_disks = mddev->raid_disks = raid_disks;
 	mddev->delta_disks = 0;
 
-	lower_barrier(conf);
+	unfreeze_array(conf);
 
 	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 	md_wakeup_thread(mddev->thread);
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index bec9db8..cd7394b 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -475,7 +475,17 @@ static void raid10_end_write_request(struct bio *bio, int error)
 		sector_t first_bad;
 		int bad_sectors;
 
-		set_bit(R10BIO_Uptodate, &r10_bio->state);
+		/*
+		 * Do not set R10BIO_Uptodate if the current device is
+		 * rebuilding or Faulty. This is because we cannot use
+		 * such device for properly reading the data back (we could
+		 * potentially use it, if the current write would have felt
+		 * before rdev->recovery_offset, but for simplicity we don't
+		 * check this here.
+		 */
+		if (test_bit(In_sync, &rdev->flags) &&
+		    !test_bit(Faulty, &rdev->flags))
+			set_bit(R10BIO_Uptodate, &r10_bio->state);
 
 		/* Maybe we can clear some bad blocks. */
 		if (is_badblock(rdev,
@@ -1011,17 +1021,17 @@ static void allow_barrier(struct r10conf *conf)
 	wake_up(&conf->wait_barrier);
 }
 
-static void freeze_array(struct r10conf *conf)
+static void freeze_array(struct r10conf *conf, int extra)
 {
 	/* stop syncio and normal IO and wait for everything to
 	 * go quiet.
 	 * We increment barrier and nr_waiting, and then
-	 * wait until nr_pending match nr_queued+1
+	 * wait until nr_pending match nr_queued+extra
 	 * This is called in the context of one normal IO request
 	 * that has failed. Thus any sync request that might be pending
 	 * will be blocked by nr_pending, and we need to wait for
 	 * pending IO requests to complete or be queued for re-try.
-	 * Thus the number queued (nr_queued) plus this request (1)
+	 * Thus the number queued (nr_queued) plus this request (extra)
 	 * must match the number of pending IOs (nr_pending) before
 	 * we continue.
 	 */
@@ -1029,7 +1039,7 @@ static void freeze_array(struct r10conf *conf)
 	conf->barrier++;
 	conf->nr_waiting++;
 	wait_event_lock_irq(conf->wait_barrier,
-			    conf->nr_pending == conf->nr_queued+1,
+			    conf->nr_pending == conf->nr_queued+extra,
 			    conf->resync_lock,
 			    flush_pending_writes(conf));
 
@@ -1730,8 +1740,8 @@ static int raid10_add_disk(struct mddev *mddev, struct md_rdev *rdev)
 		 * we wait for all outstanding requests to complete.
 		 */
 		synchronize_sched();
-		raise_barrier(conf, 0);
-		lower_barrier(conf);
+		freeze_array(conf, 0);
+		unfreeze_array(conf);
 		clear_bit(Unmerged, &rdev->flags);
 	}
 	md_integrity_add_rdev(rdev, mddev);
@@ -2524,7 +2534,7 @@ static void handle_read_error(struct mddev *mddev, struct r10bio *r10_bio)
 	r10_bio->devs[slot].bio = NULL;
 
 	if (mddev->ro == 0) {
-		freeze_array(conf);
+		freeze_array(conf, 1);
 		fix_read_error(conf, mddev, r10_bio);
 		unfreeze_array(conf);
 	} else
diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index fbc21a9..06d075c 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -2847,6 +2847,31 @@ static int tg3_5700_link_polarity(struct tg3 *tp, u32 speed)
 	return 0;
 }
 
+static bool tg3_phy_power_bug(struct tg3 *tp)
+{
+	switch (GET_ASIC_REV(tp->pci_chip_rev_id)) {
+	case ASIC_REV_5700:
+	case ASIC_REV_5704:
+		return true;
+	case ASIC_REV_5780:
+		if (tp->phy_flags & TG3_PHYFLG_MII_SERDES)
+			return true;
+		return false;
+	case ASIC_REV_5717:
+		if (!tp->pci_fn)
+			return true;
+		return false;
+	case ASIC_REV_5719:
+	case ASIC_REV_5720:
+		if ((tp->phy_flags & TG3_PHYFLG_PHY_SERDES) &&
+		    !tp->pci_fn)
+			return true;
+		return false;
+	}
+
+	return false;
+}
+
 static void tg3_power_down_phy(struct tg3 *tp, bool do_low_power)
 {
 	u32 val;
@@ -2903,12 +2928,7 @@ static void tg3_power_down_phy(struct tg3 *tp, bool do_low_power)
 	/* The PHY should not be powered down on some chips because
 	 * of bugs.
 	 */
-	if (GET_ASIC_REV(tp->pci_chip_rev_id) == ASIC_REV_5700 ||
-	    GET_ASIC_REV(tp->pci_chip_rev_id) == ASIC_REV_5704 ||
-	    (GET_ASIC_REV(tp->pci_chip_rev_id) == ASIC_REV_5780 &&
-	     (tp->phy_flags & TG3_PHYFLG_MII_SERDES)) ||
-	    (GET_ASIC_REV(tp->pci_chip_rev_id) == ASIC_REV_5717 &&
-	     !tp->pci_fn))
+	if (tg3_phy_power_bug(tp))
 		return;
 
 	if (GET_CHIP_REV(tp->pci_chip_rev_id) == CHIPREV_5784_AX ||
@@ -6752,6 +6772,20 @@ static inline int tg3_4g_overflow_test(dma_addr_t mapping, int len)
 	return (base > 0xffffdcc0) && (base + len + 8 < base);
 }
 
+/* Test for TSO DMA buffers that cross into regions which are within MSS bytes
+ * of any 4GB boundaries: 4G, 8G, etc
+ */
+static inline int tg3_4g_tso_overflow_test(struct tg3 *tp, dma_addr_t mapping,
+					   u32 len, u32 mss)
+{
+	if (GET_ASIC_REV(tp->pci_chip_rev_id) == ASIC_REV_5762 && mss) {
+		u32 base = (u32) mapping & 0xffffffff;
+
+		return ((base + len + (mss & 0x3fff)) < base);
+	}
+	return 0;
+}
+
 /* Test for DMA addresses > 40-bit */
 static inline int tg3_40bit_overflow_test(struct tg3 *tp, dma_addr_t mapping,
 					  int len)
@@ -6788,6 +6822,9 @@ static bool tg3_tx_frag_set(struct tg3_napi *tnapi, u32 *entry, u32 *budget,
 	if (tg3_4g_overflow_test(map, len))
 		hwbug = true;
 
+	if (tg3_4g_tso_overflow_test(tp, map, len, mss))
+		hwbug = true;
+
 	if (tg3_40bit_overflow_test(tp, map, len))
 		hwbug = true;
 
@@ -8662,6 +8699,14 @@ static void tg3_rss_write_indir_tbl(struct tg3 *tp)
 	}
 }
 
+static inline u32 tg3_lso_rd_dma_workaround_bit(struct tg3 *tp)
+{
+	if (GET_ASIC_REV(tp->pci_chip_rev_id) == ASIC_REV_5719)
+		return TG3_LSO_RD_DMA_TX_LENGTH_WA_5719;
+	else
+		return TG3_LSO_RD_DMA_TX_LENGTH_WA_5720;
+}
+
 /* tp->lock is held. */
 static int tg3_reset_hw(struct tg3 *tp, int reset_phy)
 {
@@ -9313,16 +9358,17 @@ static int tg3_reset_hw(struct tg3 *tp, int reset_phy)
 	tw32_f(RDMAC_MODE, rdmac_mode);
 	udelay(40);
 
-	if (GET_ASIC_REV(tp->pci_chip_rev_id) == ASIC_REV_5719) {
+	if (GET_ASIC_REV(tp->pci_chip_rev_id) == ASIC_REV_5719 ||
+	    GET_ASIC_REV(tp->pci_chip_rev_id) == ASIC_REV_5720) {
 		for (i = 0; i < TG3_NUM_RDMA_CHANNELS; i++) {
 			if (tr32(TG3_RDMA_LENGTH + (i << 2)) > TG3_MAX_MTU(tp))
 				break;
 		}
 		if (i < TG3_NUM_RDMA_CHANNELS) {
 			val = tr32(TG3_LSO_RD_DMA_CRPTEN_CTRL);
-			val |= TG3_LSO_RD_DMA_TX_LENGTH_WA;
+			val |= tg3_lso_rd_dma_workaround_bit(tp);
 			tw32(TG3_LSO_RD_DMA_CRPTEN_CTRL, val);
-			tg3_flag_set(tp, 5719_RDMA_BUG);
+			tg3_flag_set(tp, 5719_5720_RDMA_BUG);
 		}
 	}
 
@@ -9678,15 +9724,15 @@ static void tg3_periodic_fetch_stats(struct tg3 *tp)
 	TG3_STAT_ADD32(&sp->tx_ucast_packets, MAC_TX_STATS_UCAST);
 	TG3_STAT_ADD32(&sp->tx_mcast_packets, MAC_TX_STATS_MCAST);
 	TG3_STAT_ADD32(&sp->tx_bcast_packets, MAC_TX_STATS_BCAST);
-	if (unlikely(tg3_flag(tp, 5719_RDMA_BUG) &&
+	if (unlikely(tg3_flag(tp, 5719_5720_RDMA_BUG) &&
 		     (sp->tx_ucast_packets.low + sp->tx_mcast_packets.low +
 		      sp->tx_bcast_packets.low) > TG3_NUM_RDMA_CHANNELS)) {
 		u32 val;
 
 		val = tr32(TG3_LSO_RD_DMA_CRPTEN_CTRL);
-		val &= ~TG3_LSO_RD_DMA_TX_LENGTH_WA;
+		val &= ~tg3_lso_rd_dma_workaround_bit(tp);
 		tw32(TG3_LSO_RD_DMA_CRPTEN_CTRL, val);
-		tg3_flag_clear(tp, 5719_RDMA_BUG);
+		tg3_flag_clear(tp, 5719_5720_RDMA_BUG);
 	}
 
 	TG3_STAT_ADD32(&sp->rx_octets, MAC_RX_STATS_OCTETS);
diff --git a/drivers/net/ethernet/broadcom/tg3.h b/drivers/net/ethernet/broadcom/tg3.h
index 3a58339..786ae2d 100644
--- a/drivers/net/ethernet/broadcom/tg3.h
+++ b/drivers/net/ethernet/broadcom/tg3.h
@@ -168,6 +168,7 @@
 #define   ASIC_REV_USE_PROD_ID_REG	 0x0f
 #define   ASIC_REV_5784			 0x5784
 #define   ASIC_REV_5761			 0x5761
+#define   ASIC_REV_5762			 0x5762
 #define   ASIC_REV_5785			 0x5785
 #define   ASIC_REV_57780		 0x57780
 #define   ASIC_REV_5717			 0x5717
@@ -1378,7 +1379,8 @@
 #define TG3_LSO_RD_DMA_CRPTEN_CTRL	0x00004910
 #define TG3_LSO_RD_DMA_CRPTEN_CTRL_BLEN_BD_4K	 0x00030000
 #define TG3_LSO_RD_DMA_CRPTEN_CTRL_BLEN_LSO_4K	 0x000c0000
-#define TG3_LSO_RD_DMA_TX_LENGTH_WA	 0x02000000
+#define TG3_LSO_RD_DMA_TX_LENGTH_WA_5719	 0x02000000
+#define TG3_LSO_RD_DMA_TX_LENGTH_WA_5720	 0x00200000
 /* 0x4914 --> 0x4be0 unused */
 
 #define TG3_NUM_RDMA_CHANNELS		4
@@ -2965,7 +2967,7 @@ enum TG3_FLAGS {
 	TG3_FLAG_L1PLLPD_EN,
 	TG3_FLAG_APE_HAS_NCSI,
 	TG3_FLAG_4K_FIFO_LIMIT,
-	TG3_FLAG_5719_RDMA_BUG,
+	TG3_FLAG_5719_5720_RDMA_BUG,
 	TG3_FLAG_RESET_TASK_PENDING,
 	TG3_FLAG_5705_PLUS,
 	TG3_FLAG_IS_5788,
diff --git a/drivers/net/wireless/ath/ath9k/Kconfig b/drivers/net/wireless/ath/ath9k/Kconfig
index c7aa664..1b43b83 100644
--- a/drivers/net/wireless/ath/ath9k/Kconfig
+++ b/drivers/net/wireless/ath/ath9k/Kconfig
@@ -89,13 +89,17 @@ config ATH9K_MAC_DEBUG
 	  This option enables collection of statistics for Rx/Tx status
 	  data and some other MAC related statistics
 
-config ATH9K_RATE_CONTROL
+config ATH9K_LEGACY_RATE_CONTROL
 	bool "Atheros ath9k rate control"
 	depends on ATH9K
-	default y
+	default n
 	---help---
 	  Say Y, if you want to use the ath9k specific rate control
-	  module instead of minstrel_ht.
+	  module instead of minstrel_ht. Be warned that there are various
+	  issues with the ath9k RC and minstrel is a more robust algorithm.
+	  Note that even if this option is selected, "ath9k_rate_control"
+	  has to be passed to mac80211 using the module parameter,
+	  ieee80211_default_rc_algo.
 
 config ATH9K_HTC
        tristate "Atheros HTC based wireless cards support"
diff --git a/drivers/net/wireless/ath/ath9k/Makefile b/drivers/net/wireless/ath/ath9k/Makefile
index 2ad8f94..75ee9e7 100644
--- a/drivers/net/wireless/ath/ath9k/Makefile
+++ b/drivers/net/wireless/ath/ath9k/Makefile
@@ -8,7 +8,7 @@ ath9k-y +=	beacon.o \
 		antenna.o
 
 ath9k-$(CONFIG_ATH9K_BTCOEX_SUPPORT) += mci.o
-ath9k-$(CONFIG_ATH9K_RATE_CONTROL) += rc.o
+ath9k-$(CONFIG_ATH9K_LEGACY_RATE_CONTROL) += rc.o
 ath9k-$(CONFIG_ATH9K_PCI) += pci.o
 ath9k-$(CONFIG_ATH9K_AHB) += ahb.o
 ath9k-$(CONFIG_ATH9K_DEBUGFS) += debug.o
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h b/drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h
index 6f7cf49..2ad5703 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h
@@ -778,11 +778,11 @@ static const u32 ar9300Common_rx_gain_table_2p2[][2] = {
 	{0x0000a074, 0x00000000},
 	{0x0000a078, 0x00000000},
 	{0x0000a07c, 0x00000000},
-	{0x0000a080, 0x1a1a1a1a},
-	{0x0000a084, 0x1a1a1a1a},
-	{0x0000a088, 0x1a1a1a1a},
-	{0x0000a08c, 0x1a1a1a1a},
-	{0x0000a090, 0x171a1a1a},
+	{0x0000a080, 0x22222229},
+	{0x0000a084, 0x1d1d1d1d},
+	{0x0000a088, 0x1d1d1d1d},
+	{0x0000a08c, 0x1d1d1d1d},
+	{0x0000a090, 0x171d1d1d},
 	{0x0000a094, 0x11111717},
 	{0x0000a098, 0x00030311},
 	{0x0000a09c, 0x00000000},
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.h b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.h
index 3a1ff55..51dd475 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.h
@@ -68,13 +68,16 @@
 #define AR9300_BASE_ADDR 0x3ff
 #define AR9300_BASE_ADDR_512 0x1ff
 
-#define AR9300_OTP_BASE			0x14000
-#define AR9300_OTP_STATUS		0x15f18
+#define AR9300_OTP_BASE \
+		((AR_SREV_9340(ah) || AR_SREV_9550(ah)) ? 0x30000 : 0x14000)
+#define AR9300_OTP_STATUS \
+		((AR_SREV_9340(ah) || AR_SREV_9550(ah)) ? 0x30018 : 0x15f18)
 #define AR9300_OTP_STATUS_TYPE		0x7
 #define AR9300_OTP_STATUS_VALID		0x4
 #define AR9300_OTP_STATUS_ACCESS_BUSY	0x2
 #define AR9300_OTP_STATUS_SM_BUSY	0x1
-#define AR9300_OTP_READ_DATA		0x15f1c
+#define AR9300_OTP_READ_DATA \
+		((AR_SREV_9340(ah) || AR_SREV_9550(ah)) ? 0x3001c : 0x15f1c)
 
 enum targetPowerHTRates {
 	HT_TARGET_RATE_0_8_16,
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index f337121..d6f6dd3 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -707,8 +707,7 @@ void ath9k_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
 	hw->wiphy->iface_combinations = &if_comb;
 	hw->wiphy->n_iface_combinations = 1;
 
-	if (AR_SREV_5416(sc->sc_ah))
-		hw->wiphy->flags &= ~WIPHY_FLAG_PS_ON_BY_DEFAULT;
+	hw->wiphy->flags &= ~WIPHY_FLAG_PS_ON_BY_DEFAULT;
 
 	hw->wiphy->flags |= WIPHY_FLAG_IBSS_RSN;
 	hw->wiphy->flags |= WIPHY_FLAG_SUPPORTS_TDLS;
@@ -750,10 +749,6 @@ void ath9k_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
 	sc->ant_rx = hw->wiphy->available_antennas_rx;
 	sc->ant_tx = hw->wiphy->available_antennas_tx;
 
-#ifdef CONFIG_ATH9K_RATE_CONTROL
-	hw->rate_control_algorithm = "ath9k_rate_control";
-#endif
-
 	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_2GHZ)
 		hw->wiphy->bands[IEEE80211_BAND_2GHZ] =
 			&sc->sbands[IEEE80211_BAND_2GHZ];
diff --git a/drivers/net/wireless/ath/ath9k/rc.h b/drivers/net/wireless/ath/ath9k/rc.h
index 75f8e9b..12cf122 100644
--- a/drivers/net/wireless/ath/ath9k/rc.h
+++ b/drivers/net/wireless/ath/ath9k/rc.h
@@ -219,7 +219,7 @@ struct ath_rate_priv {
 	struct ath_rc_stats rcstats[RATE_TABLE_SIZE];
 };
 
-#ifdef CONFIG_ATH9K_RATE_CONTROL
+#ifdef CONFIG_ATH9K_LEGACY_RATE_CONTROL
 int ath_rate_control_register(void);
 void ath_rate_control_unregister(void);
 #else
diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 54ecf96..f2e4426 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -2423,7 +2423,7 @@ static void b43_request_firmware(struct work_struct *work)
 	for (i = 0; i < B43_NR_FWTYPES; i++) {
 		errmsg = ctx->errors[i];
 		if (strlen(errmsg))
-			b43err(dev->wl, errmsg);
+			b43err(dev->wl, "%s", errmsg);
 	}
 	b43_print_fw_helptext(dev->wl, 1);
 	goto out;
diff --git a/drivers/net/wireless/iwlwifi/dvm/sta.c b/drivers/net/wireless/iwlwifi/dvm/sta.c
index efe8a4f..12e06f3 100644
--- a/drivers/net/wireless/iwlwifi/dvm/sta.c
+++ b/drivers/net/wireless/iwlwifi/dvm/sta.c
@@ -746,7 +746,7 @@ void iwl_restore_stations(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 					memcpy(&lq, priv->stations[i].lq,
 					       sizeof(struct iwl_link_quality_cmd));
 
-				if (!memcmp(&lq, &zero_lq, sizeof(lq)))
+				if (memcmp(&lq, &zero_lq, sizeof(lq)))
 					send_lq = true;
 			}
 			spin_unlock_bh(&priv->sta_lock);
diff --git a/drivers/net/xen-netback/netback.c b/drivers/net/xen-netback/netback.c
index 6aa059e..9084f8e 100644
--- a/drivers/net/xen-netback/netback.c
+++ b/drivers/net/xen-netback/netback.c
@@ -46,11 +46,33 @@
 #include <asm/xen/hypercall.h>
 #include <asm/xen/page.h>
 
+/*
+ * This is the maximum slots a skb can have. If a guest sends a skb
+ * which exceeds this limit it is considered malicious.
+ */
+#define FATAL_SKB_SLOTS_DEFAULT 20
+static unsigned int fatal_skb_slots = FATAL_SKB_SLOTS_DEFAULT;
+module_param(fatal_skb_slots, uint, 0444);
+
+/*
+ * To avoid confusion, we define XEN_NETBK_LEGACY_SLOTS_MAX indicating
+ * the maximum slots a valid packet can use. Now this value is defined
+ * to be XEN_NETIF_NR_SLOTS_MIN, which is supposed to be supported by
+ * all backend.
+ */
+#define XEN_NETBK_LEGACY_SLOTS_MAX XEN_NETIF_NR_SLOTS_MIN
+
+typedef unsigned int pending_ring_idx_t;
+#define INVALID_PENDING_RING_IDX (~0U)
+
 struct pending_tx_info {
-	struct xen_netif_tx_request req;
+	struct xen_netif_tx_request req; /* coalesced tx request */
 	struct xenvif *vif;
+	pending_ring_idx_t head; /* head != INVALID_PENDING_RING_IDX
+				  * if it is head of one or more tx
+				  * reqs
+				  */
 };
-typedef unsigned int pending_ring_idx_t;
 
 struct netbk_rx_meta {
 	int id;
@@ -101,7 +123,11 @@ struct xen_netbk {
 	atomic_t netfront_count;
 
 	struct pending_tx_info pending_tx_info[MAX_PENDING_REQS];
-	struct gnttab_copy tx_copy_ops[MAX_PENDING_REQS];
+	/* Coalescing tx requests before copying makes number of grant
+	 * copy ops greater or equal to number of slots required. In
+	 * worst case a tx request consumes 2 gnttab_copy.
+	 */
+	struct gnttab_copy tx_copy_ops[2*MAX_PENDING_REQS];
 
 	u16 pending_ring[MAX_PENDING_REQS];
 
@@ -117,6 +143,16 @@ struct xen_netbk {
 static struct xen_netbk *xen_netbk;
 static int xen_netbk_group_nr;
 
+/*
+ * If head != INVALID_PENDING_RING_IDX, it means this tx request is head of
+ * one or more merged tx requests, otherwise it is the continuation of
+ * previous tx request.
+ */
+static inline int pending_tx_is_head(struct xen_netbk *netbk, RING_IDX idx)
+{
+	return netbk->pending_tx_info[idx].head != INVALID_PENDING_RING_IDX;
+}
+
 void xen_netbk_add_xenvif(struct xenvif *vif)
 {
 	int i;
@@ -249,6 +285,7 @@ static int max_required_rx_slots(struct xenvif *vif)
 {
 	int max = DIV_ROUND_UP(vif->dev->mtu, PAGE_SIZE);
 
+	/* XXX FIXME: RX path dependent on MAX_SKB_FRAGS */
 	if (vif->can_sg || vif->gso || vif->gso_prefix)
 		max += MAX_SKB_FRAGS + 1; /* extra_info + frags */
 
@@ -626,6 +663,7 @@ static void xen_netbk_rx_action(struct xen_netbk *netbk)
 		__skb_queue_tail(&rxq, skb);
 
 		/* Filled the batch queue? */
+		/* XXX FIXME: RX path dependent on MAX_SKB_FRAGS */
 		if (count + MAX_SKB_FRAGS >= XEN_NETIF_RX_RING_SIZE)
 			break;
 	}
@@ -873,47 +911,99 @@ static int netbk_count_requests(struct xenvif *vif,
 				int work_to_do)
 {
 	RING_IDX cons = vif->tx.req_cons;
-	int frags = 0;
+	int slots = 0;
+	int drop_err = 0;
+	int more_data;
 
 	if (!(first->flags & XEN_NETTXF_more_data))
 		return 0;
 
 	do {
-		if (frags >= work_to_do) {
-			netdev_err(vif->dev, "Need more frags\n");
+		struct xen_netif_tx_request dropped_tx = { 0 };
+
+		if (slots >= work_to_do) {
+			netdev_err(vif->dev,
+				   "Asked for %d slots but exceeds this limit\n",
+				   work_to_do);
 			netbk_fatal_tx_err(vif);
 			return -ENODATA;
 		}
 
-		if (unlikely(frags >= MAX_SKB_FRAGS)) {
-			netdev_err(vif->dev, "Too many frags\n");
+		/* This guest is really using too many slots and
+		 * considered malicious.
+		 */
+		if (unlikely(slots >= fatal_skb_slots)) {
+			netdev_err(vif->dev,
+				   "Malicious frontend using %d slots, threshold %u\n",
+				   slots, fatal_skb_slots);
 			netbk_fatal_tx_err(vif);
 			return -E2BIG;
 		}
 
-		memcpy(txp, RING_GET_REQUEST(&vif->tx, cons + frags),
+		/* Xen network protocol had implicit dependency on
+		 * MAX_SKB_FRAGS. XEN_NETBK_LEGACY_SLOTS_MAX is set to
+		 * the historical MAX_SKB_FRAGS value 18 to honor the
+		 * same behavior as before. Any packet using more than
+		 * 18 slots but less than fatal_skb_slots slots is
+		 * dropped
+		 */
+		if (!drop_err && slots >= XEN_NETBK_LEGACY_SLOTS_MAX) {
+			if (net_ratelimit())
+				netdev_dbg(vif->dev,
+					   "Too many slots (%d) exceeding limit (%d), dropping packet\n",
+					   slots, XEN_NETBK_LEGACY_SLOTS_MAX);
+			drop_err = -E2BIG;
+		}
+
+		if (drop_err)
+			txp = &dropped_tx;
+
+		memcpy(txp, RING_GET_REQUEST(&vif->tx, cons + slots),
 		       sizeof(*txp));
-		if (txp->size > first->size) {
-			netdev_err(vif->dev, "Frag is bigger than frame.\n");
-			netbk_fatal_tx_err(vif);
-			return -EIO;
+
+		/* If the guest submitted a frame >= 64 KiB then
+		 * first->size overflowed and following slots will
+		 * appear to be larger than the frame.
+		 *
+		 * This cannot be fatal error as there are buggy
+		 * frontends that do this.
+		 *
+		 * Consume all slots and drop the packet.
+		 */
+		if (!drop_err && txp->size > first->size) {
+			if (net_ratelimit())
+				netdev_dbg(vif->dev,
+					   "Invalid tx request, slot size %u > remaining size %u\n",
+					   txp->size, first->size);
+			drop_err = -EIO;
 		}
 
 		first->size -= txp->size;
-		frags++;
+		slots++;
 
 		if (unlikely((txp->offset + txp->size) > PAGE_SIZE)) {
-			netdev_err(vif->dev, "txp->offset: %x, size: %u\n",
+			netdev_err(vif->dev, "Cross page boundary, txp->offset: %x, size: %u\n",
 				 txp->offset, txp->size);
 			netbk_fatal_tx_err(vif);
 			return -EINVAL;
 		}
-	} while ((txp++)->flags & XEN_NETTXF_more_data);
-	return frags;
+
+		more_data = txp->flags & XEN_NETTXF_more_data;
+
+		if (!drop_err)
+			txp++;
+
+	} while (more_data);
+
+	if (drop_err) {
+		netbk_tx_err(vif, first, cons + slots);
+		return drop_err;
+	}
+
+	return slots;
 }
 
 static struct page *xen_netbk_alloc_page(struct xen_netbk *netbk,
-					 struct sk_buff *skb,
 					 u16 pending_idx)
 {
 	struct page *page;
@@ -934,48 +1024,114 @@ static struct gnttab_copy *xen_netbk_get_requests(struct xen_netbk *netbk,
 	struct skb_shared_info *shinfo = skb_shinfo(skb);
 	skb_frag_t *frags = shinfo->frags;
 	u16 pending_idx = *((u16 *)skb->data);
-	int i, start;
+	u16 head_idx = 0;
+	int slot, start;
+	struct page *page;
+	pending_ring_idx_t index, start_idx = 0;
+	uint16_t dst_offset;
+	unsigned int nr_slots;
+	struct pending_tx_info *first = NULL;
+
+	/* At this point shinfo->nr_frags is in fact the number of
+	 * slots, which can be as large as XEN_NETBK_LEGACY_SLOTS_MAX.
+	 */
+	nr_slots = shinfo->nr_frags;
 
 	/* Skip first skb fragment if it is on same page as header fragment. */
 	start = (frag_get_pending_idx(&shinfo->frags[0]) == pending_idx);
 
-	for (i = start; i < shinfo->nr_frags; i++, txp++) {
-		struct page *page;
-		pending_ring_idx_t index;
+	/* Coalesce tx requests, at this point the packet passed in
+	 * should be <= 64K. Any packets larger than 64K have been
+	 * handled in netbk_count_requests().
+	 */
+	for (shinfo->nr_frags = slot = start; slot < nr_slots;
+	     shinfo->nr_frags++) {
 		struct pending_tx_info *pending_tx_info =
 			netbk->pending_tx_info;
 
-		index = pending_index(netbk->pending_cons++);
-		pending_idx = netbk->pending_ring[index];
-		page = xen_netbk_alloc_page(netbk, skb, pending_idx);
+		page = alloc_page(GFP_KERNEL|__GFP_COLD);
 		if (!page)
 			goto err;
 
-		gop->source.u.ref = txp->gref;
-		gop->source.domid = vif->domid;
-		gop->source.offset = txp->offset;
-
-		gop->dest.u.gmfn = virt_to_mfn(page_address(page));
-		gop->dest.domid = DOMID_SELF;
-		gop->dest.offset = txp->offset;
-
-		gop->len = txp->size;
-		gop->flags = GNTCOPY_source_gref;
+		dst_offset = 0;
+		first = NULL;
+		while (dst_offset < PAGE_SIZE && slot < nr_slots) {
+			gop->flags = GNTCOPY_source_gref;
+
+			gop->source.u.ref = txp->gref;
+			gop->source.domid = vif->domid;
+			gop->source.offset = txp->offset;
+
+			gop->dest.domid = DOMID_SELF;
+
+			gop->dest.offset = dst_offset;
+			gop->dest.u.gmfn = virt_to_mfn(page_address(page));
+
+			if (dst_offset + txp->size > PAGE_SIZE) {
+				/* This page can only merge a portion
+				 * of tx request. Do not increment any
+				 * pointer / counter here. The txp
+				 * will be dealt with in future
+				 * rounds, eventually hitting the
+				 * `else` branch.
+				 */
+				gop->len = PAGE_SIZE - dst_offset;
+				txp->offset += gop->len;
+				txp->size -= gop->len;
+				dst_offset += gop->len; /* quit loop */
+			} else {
+				/* This tx request can be merged in the page */
+				gop->len = txp->size;
+				dst_offset += gop->len;
+
+				index = pending_index(netbk->pending_cons++);
+
+				pending_idx = netbk->pending_ring[index];
+
+				memcpy(&pending_tx_info[pending_idx].req, txp,
+				       sizeof(*txp));
+				xenvif_get(vif);
+
+				pending_tx_info[pending_idx].vif = vif;
+
+				/* Poison these fields, corresponding
+				 * fields for head tx req will be set
+				 * to correct values after the loop.
+				 */
+				netbk->mmap_pages[pending_idx] = (void *)(~0UL);
+				pending_tx_info[pending_idx].head =
+					INVALID_PENDING_RING_IDX;
+
+				if (!first) {
+					first = &pending_tx_info[pending_idx];
+					start_idx = index;
+					head_idx = pending_idx;
+				}
+
+				txp++;
+				slot++;
+			}
 
-		gop++;
+			gop++;
+		}
 
-		memcpy(&pending_tx_info[pending_idx].req, txp, sizeof(*txp));
-		xenvif_get(vif);
-		pending_tx_info[pending_idx].vif = vif;
-		frag_set_pending_idx(&frags[i], pending_idx);
+		first->req.offset = 0;
+		first->req.size = dst_offset;
+		first->head = start_idx;
+		set_page_ext(page, netbk, head_idx);
+		netbk->mmap_pages[head_idx] = page;
+		frag_set_pending_idx(&frags[shinfo->nr_frags], head_idx);
 	}
 
+	BUG_ON(shinfo->nr_frags > MAX_SKB_FRAGS);
+
 	return gop;
 err:
 	/* Unwind, freeing all pages and sending error responses. */
-	while (i-- > start) {
-		xen_netbk_idx_release(netbk, frag_get_pending_idx(&frags[i]),
-				      XEN_NETIF_RSP_ERROR);
+	while (shinfo->nr_frags-- > start) {
+		xen_netbk_idx_release(netbk,
+				frag_get_pending_idx(&frags[shinfo->nr_frags]),
+				XEN_NETIF_RSP_ERROR);
 	}
 	/* The head too, if necessary. */
 	if (start)
@@ -991,8 +1147,10 @@ static int xen_netbk_tx_check_gop(struct xen_netbk *netbk,
 	struct gnttab_copy *gop = *gopp;
 	u16 pending_idx = *((u16 *)skb->data);
 	struct skb_shared_info *shinfo = skb_shinfo(skb);
+	struct pending_tx_info *tx_info;
 	int nr_frags = shinfo->nr_frags;
 	int i, err, start;
+	u16 peek; /* peek into next tx request */
 
 	/* Check status of header. */
 	err = gop->status;
@@ -1004,11 +1162,20 @@ static int xen_netbk_tx_check_gop(struct xen_netbk *netbk,
 
 	for (i = start; i < nr_frags; i++) {
 		int j, newerr;
+		pending_ring_idx_t head;
 
 		pending_idx = frag_get_pending_idx(&shinfo->frags[i]);
+		tx_info = &netbk->pending_tx_info[pending_idx];
+		head = tx_info->head;
 
 		/* Check error status: if okay then remember grant handle. */
-		newerr = (++gop)->status;
+		do {
+			newerr = (++gop)->status;
+			if (newerr)
+				break;
+			peek = netbk->pending_ring[pending_index(++head)];
+		} while (!pending_tx_is_head(netbk, peek));
+
 		if (likely(!newerr)) {
 			/* Had a previous error? Invalidate this fragment. */
 			if (unlikely(err))
@@ -1233,11 +1400,12 @@ static unsigned xen_netbk_tx_build_gops(struct xen_netbk *netbk)
 	struct sk_buff *skb;
 	int ret;
 
-	while (((nr_pending_reqs(netbk) + MAX_SKB_FRAGS) < MAX_PENDING_REQS) &&
+	while ((nr_pending_reqs(netbk) + XEN_NETBK_LEGACY_SLOTS_MAX
+		< MAX_PENDING_REQS) &&
 		!list_empty(&netbk->net_schedule_list)) {
 		struct xenvif *vif;
 		struct xen_netif_tx_request txreq;
-		struct xen_netif_tx_request txfrags[MAX_SKB_FRAGS];
+		struct xen_netif_tx_request txfrags[XEN_NETBK_LEGACY_SLOTS_MAX];
 		struct page *page;
 		struct xen_netif_extra_info extras[XEN_NETIF_EXTRA_TYPE_MAX-1];
 		u16 pending_idx;
@@ -1325,7 +1493,7 @@ static unsigned xen_netbk_tx_build_gops(struct xen_netbk *netbk)
 		pending_idx = netbk->pending_ring[index];
 
 		data_len = (txreq.size > PKT_PROT_LEN &&
-			    ret < MAX_SKB_FRAGS) ?
+			    ret < XEN_NETBK_LEGACY_SLOTS_MAX) ?
 			PKT_PROT_LEN : txreq.size;
 
 		skb = alloc_skb(data_len + NET_SKB_PAD + NET_IP_ALIGN,
@@ -1352,7 +1520,7 @@ static unsigned xen_netbk_tx_build_gops(struct xen_netbk *netbk)
 		}
 
 		/* XXX could copy straight to head */
-		page = xen_netbk_alloc_page(netbk, skb, pending_idx);
+		page = xen_netbk_alloc_page(netbk, pending_idx);
 		if (!page) {
 			kfree_skb(skb);
 			netbk_tx_err(vif, &txreq, idx);
@@ -1375,6 +1543,7 @@ static unsigned xen_netbk_tx_build_gops(struct xen_netbk *netbk)
 		memcpy(&netbk->pending_tx_info[pending_idx].req,
 		       &txreq, sizeof(txreq));
 		netbk->pending_tx_info[pending_idx].vif = vif;
+		netbk->pending_tx_info[pending_idx].head = index;
 		*((u16 *)skb->data) = pending_idx;
 
 		__skb_put(skb, data_len);
@@ -1505,7 +1674,10 @@ static void xen_netbk_idx_release(struct xen_netbk *netbk, u16 pending_idx,
 {
 	struct xenvif *vif;
 	struct pending_tx_info *pending_tx_info;
-	pending_ring_idx_t index;
+	pending_ring_idx_t head;
+	u16 peek; /* peek into next tx request */
+
+	BUG_ON(netbk->mmap_pages[pending_idx] == (void *)(~0UL));
 
 	/* Already complete? */
 	if (netbk->mmap_pages[pending_idx] == NULL)
@@ -1514,19 +1686,40 @@ static void xen_netbk_idx_release(struct xen_netbk *netbk, u16 pending_idx,
 	pending_tx_info = &netbk->pending_tx_info[pending_idx];
 
 	vif = pending_tx_info->vif;
+	head = pending_tx_info->head;
+
+	BUG_ON(!pending_tx_is_head(netbk, head));
+	BUG_ON(netbk->pending_ring[pending_index(head)] != pending_idx);
 
-	make_tx_response(vif, &pending_tx_info->req, status);
+	do {
+		pending_ring_idx_t index;
+		pending_ring_idx_t idx = pending_index(head);
+		u16 info_idx = netbk->pending_ring[idx];
 
-	index = pending_index(netbk->pending_prod++);
-	netbk->pending_ring[index] = pending_idx;
+		pending_tx_info = &netbk->pending_tx_info[info_idx];
+		make_tx_response(vif, &pending_tx_info->req, status);
 
-	xenvif_put(vif);
+		/* Setting any number other than
+		 * INVALID_PENDING_RING_IDX indicates this slot is
+		 * starting a new packet / ending a previous packet.
+		 */
+		pending_tx_info->head = 0;
+
+		index = pending_index(netbk->pending_prod++);
+		netbk->pending_ring[index] = netbk->pending_ring[info_idx];
+
+		xenvif_put(vif);
+
+		peek = netbk->pending_ring[pending_index(++head)];
+
+	} while (!pending_tx_is_head(netbk, peek));
 
 	netbk->mmap_pages[pending_idx]->mapping = 0;
 	put_page(netbk->mmap_pages[pending_idx]);
 	netbk->mmap_pages[pending_idx] = NULL;
 }
 
+
 static void make_tx_response(struct xenvif *vif,
 			     struct xen_netif_tx_request *txp,
 			     s8       st)
@@ -1579,8 +1772,9 @@ static inline int rx_work_todo(struct xen_netbk *netbk)
 static inline int tx_work_todo(struct xen_netbk *netbk)
 {
 
-	if (((nr_pending_reqs(netbk) + MAX_SKB_FRAGS) < MAX_PENDING_REQS) &&
-			!list_empty(&netbk->net_schedule_list))
+	if ((nr_pending_reqs(netbk) + XEN_NETBK_LEGACY_SLOTS_MAX
+	     < MAX_PENDING_REQS) &&
+	     !list_empty(&netbk->net_schedule_list))
 		return 1;
 
 	return 0;
@@ -1663,6 +1857,13 @@ static int __init netback_init(void)
 	if (!xen_domain())
 		return -ENODEV;
 
+	if (fatal_skb_slots < XEN_NETBK_LEGACY_SLOTS_MAX) {
+		printk(KERN_INFO
+		       "xen-netback: fatal_skb_slots too small (%d), bump it to XEN_NETBK_LEGACY_SLOTS_MAX (%d)\n",
+		       fatal_skb_slots, XEN_NETBK_LEGACY_SLOTS_MAX);
+		fatal_skb_slots = XEN_NETBK_LEGACY_SLOTS_MAX;
+	}
+
 	xen_netbk_group_nr = num_online_cpus();
 	xen_netbk = vzalloc(sizeof(struct xen_netbk) * xen_netbk_group_nr);
 	if (!xen_netbk)
diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
index 650f79a..ecac034 100644
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -36,7 +36,7 @@
 #include <linux/skbuff.h>
 #include <linux/ethtool.h>
 #include <linux/if_ether.h>
-#include <linux/tcp.h>
+#include <net/tcp.h>
 #include <linux/udp.h>
 #include <linux/moduleparam.h>
 #include <linux/mm.h>
@@ -491,6 +491,16 @@ static int xennet_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	unsigned int len = skb_headlen(skb);
 	unsigned long flags;
 
+	/* If skb->len is too big for wire format, drop skb and alert
+	 * user about misconfiguration.
+	 */
+	if (unlikely(skb->len > XEN_NETIF_MAX_TX_SIZE)) {
+		net_alert_ratelimited(
+			"xennet: skb->len = %u, too big for wire format\n",
+			skb->len);
+		goto drop;
+	}
+
 	frags += DIV_ROUND_UP(offset + len, PAGE_SIZE);
 	if (unlikely(frags > MAX_SKB_FRAGS + 1)) {
 		printk(KERN_ALERT "xennet: skb rides the rocket: %d frags\n",
@@ -1026,7 +1036,8 @@ err:
 
 static int xennet_change_mtu(struct net_device *dev, int mtu)
 {
-	int max = xennet_can_sg(dev) ? 65535 - ETH_HLEN : ETH_DATA_LEN;
+	int max = xennet_can_sg(dev) ?
+		XEN_NETIF_MAX_TX_SIZE - MAX_TCP_HEADER : ETH_DATA_LEN;
 
 	if (mtu > max)
 		return -EINVAL;
@@ -1330,6 +1341,8 @@ static struct net_device * __devinit xennet_create_dev(struct xenbus_device *dev
 	SET_ETHTOOL_OPS(netdev, &xennet_ethtool_ops);
 	SET_NETDEV_DEV(netdev, &dev->dev);
 
+	netif_set_gso_max_size(netdev, XEN_NETIF_MAX_TX_SIZE - MAX_TCP_HEADER);
+
 	np->netdev = netdev;
 
 	netif_carrier_off(netdev);
diff --git a/drivers/rapidio/devices/tsi721.c b/drivers/rapidio/devices/tsi721.c
index 5d44252..7fca1da 100644
--- a/drivers/rapidio/devices/tsi721.c
+++ b/drivers/rapidio/devices/tsi721.c
@@ -471,6 +471,10 @@ static irqreturn_t tsi721_irqhandler(int irq, void *ptr)
 	u32 intval;
 	u32 ch_inte;
 
+	/* For MSI mode disable all device-level interrupts */
+	if (priv->flags & TSI721_USING_MSI)
+		iowrite32(0, priv->regs + TSI721_DEV_INTE);
+
 	dev_int = ioread32(priv->regs + TSI721_DEV_INT);
 	if (!dev_int)
 		return IRQ_NONE;
@@ -560,6 +564,14 @@ static irqreturn_t tsi721_irqhandler(int irq, void *ptr)
 		}
 	}
 #endif
+
+	/* For MSI mode re-enable device-level interrupts */
+	if (priv->flags & TSI721_USING_MSI) {
+		dev_int = TSI721_DEV_INT_SR2PC_CH | TSI721_DEV_INT_SRIO |
+			TSI721_DEV_INT_SMSG_CH | TSI721_DEV_INT_BDMA_CH;
+		iowrite32(dev_int, priv->regs + TSI721_DEV_INTE);
+	}
+
 	return IRQ_HANDLED;
 }
 
diff --git a/drivers/regulator/palmas-regulator.c b/drivers/regulator/palmas-regulator.c
index 46c7e88..f9e8a2b 100644
--- a/drivers/regulator/palmas-regulator.c
+++ b/drivers/regulator/palmas-regulator.c
@@ -685,7 +685,7 @@ static __devinit int palmas_probe(struct platform_device *pdev)
 			pmic->desc[id].vsel_mask = SMPS10_VSEL;
 			pmic->desc[id].enable_reg =
 					PALMAS_BASE_TO_REG(PALMAS_SMPS_BASE,
-							PALMAS_SMPS10_STATUS);
+							PALMAS_SMPS10_CTRL);
 			pmic->desc[id].enable_mask = SMPS10_BOOST_EN;
 			pmic->desc[id].min_uV = 3750000;
 			pmic->desc[id].uV_step = 1250000;
diff --git a/drivers/rtc/rtc-twl.c b/drivers/rtc/rtc-twl.c
index 9277d94..1789a25 100644
--- a/drivers/rtc/rtc-twl.c
+++ b/drivers/rtc/rtc-twl.c
@@ -523,6 +523,7 @@ static int __devinit twl_rtc_probe(struct platform_device *pdev)
 	}
 
 	platform_set_drvdata(pdev, rtc);
+	device_init_wakeup(&pdev->dev, 1);
 	return 0;
 
 out2:
diff --git a/drivers/target/iscsi/iscsi_target_parameters.c b/drivers/target/iscsi/iscsi_target_parameters.c
index 0c4760f..3282c8f 100644
--- a/drivers/target/iscsi/iscsi_target_parameters.c
+++ b/drivers/target/iscsi/iscsi_target_parameters.c
@@ -713,9 +713,9 @@ static int iscsi_add_notunderstood_response(
 	}
 	INIT_LIST_HEAD(&extra_response->er_list);
 
-	strncpy(extra_response->key, key, strlen(key) + 1);
-	strncpy(extra_response->value, NOTUNDERSTOOD,
-			strlen(NOTUNDERSTOOD) + 1);
+	strlcpy(extra_response->key, key, sizeof(extra_response->key));
+	strlcpy(extra_response->value, NOTUNDERSTOOD,
+		sizeof(extra_response->value));
 
 	list_add_tail(&extra_response->er_list,
 			&param_list->extra_response_list);
@@ -1554,8 +1554,6 @@ int iscsi_decode_text_input(
 
 		if (phase & PHASE_SECURITY) {
 			if (iscsi_check_for_auth_key(key) > 0) {
-				char *tmpptr = key + strlen(key);
-				*tmpptr = '=';
 				kfree(tmpbuf);
 				return 1;
 			}
diff --git a/drivers/target/iscsi/iscsi_target_parameters.h b/drivers/target/iscsi/iscsi_target_parameters.h
index 6a37fd6..83eed65 100644
--- a/drivers/target/iscsi/iscsi_target_parameters.h
+++ b/drivers/target/iscsi/iscsi_target_parameters.h
@@ -1,8 +1,10 @@
 #ifndef ISCSI_PARAMETERS_H
 #define ISCSI_PARAMETERS_H
 
+#include <scsi/iscsi_proto.h>
+
 struct iscsi_extra_response {
-	char key[64];
+	char key[KEY_MAXLEN];
 	char value[32];
 	struct list_head er_list;
 } ____cacheline_aligned;
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 140bfb3..725ab56 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -232,6 +232,7 @@ struct se_session *transport_init_session(void)
 	INIT_LIST_HEAD(&se_sess->sess_list);
 	INIT_LIST_HEAD(&se_sess->sess_acl_list);
 	INIT_LIST_HEAD(&se_sess->sess_cmd_list);
+	INIT_LIST_HEAD(&se_sess->sess_wait_list);
 	spin_lock_init(&se_sess->sess_cmd_lock);
 	kref_init(&se_sess->sess_kref);
 
@@ -2469,11 +2470,14 @@ void target_sess_cmd_list_set_waiting(struct se_session *se_sess)
 	unsigned long flags;
 
 	spin_lock_irqsave(&se_sess->sess_cmd_lock, flags);
-
-	WARN_ON(se_sess->sess_tearing_down);
+	if (se_sess->sess_tearing_down) {
+		spin_unlock_irqrestore(&se_sess->sess_cmd_lock, flags);
+		return;
+	}
 	se_sess->sess_tearing_down = 1;
+	list_splice_init(&se_sess->sess_cmd_list, &se_sess->sess_wait_list);
 
-	list_for_each_entry(se_cmd, &se_sess->sess_cmd_list, se_cmd_list)
+	list_for_each_entry(se_cmd, &se_sess->sess_wait_list, se_cmd_list)
 		se_cmd->cmd_wait_set = 1;
 
 	spin_unlock_irqrestore(&se_sess->sess_cmd_lock, flags);
@@ -2490,9 +2494,10 @@ void target_wait_for_sess_cmds(
 {
 	struct se_cmd *se_cmd, *tmp_cmd;
 	bool rc = false;
+	unsigned long flags;
 
 	list_for_each_entry_safe(se_cmd, tmp_cmd,
-				&se_sess->sess_cmd_list, se_cmd_list) {
+				&se_sess->sess_wait_list, se_cmd_list) {
 		list_del(&se_cmd->se_cmd_list);
 
 		pr_debug("Waiting for se_cmd: %p t_state: %d, fabric state:"
@@ -2520,6 +2525,11 @@ void target_wait_for_sess_cmds(
 
 		se_cmd->se_tfo->release_cmd(se_cmd);
 	}
+
+	spin_lock_irqsave(&se_sess->sess_cmd_lock, flags);
+	WARN_ON(!list_empty(&se_sess->sess_cmd_list));
+	spin_unlock_irqrestore(&se_sess->sess_cmd_lock, flags);
+
 }
 EXPORT_SYMBOL(target_wait_for_sess_cmds);
 
diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index 26f0d0e..72d3ff8 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -1529,6 +1529,14 @@ static void n_tty_set_termios(struct tty_struct *tty, struct ktermios *old)
 			tty->real_raw = 0;
 	}
 	n_tty_set_room(tty);
+	/*
+	 * Fix tty hang when I_IXON(tty) is cleared, but the tty
+	 * been stopped by STOP_CHAR(tty) before it.
+	 */
+	if (!I_IXON(tty) && old && (old->c_iflag & IXON) && !tty->flow_stopped) {
+		start_tty(tty);
+	}
+
 	/* The termios change make the tty ready for I/O */
 	wake_up_interruptible(&tty->write_wait);
 	wake_up_interruptible(&tty->read_wait);
diff --git a/drivers/usb/atm/cxacru.c b/drivers/usb/atm/cxacru.c
index b7eb86a..8a7eb77 100644
--- a/drivers/usb/atm/cxacru.c
+++ b/drivers/usb/atm/cxacru.c
@@ -686,7 +686,8 @@ static int cxacru_cm_get_array(struct cxacru_data *instance, enum cxacru_cm_requ
 {
 	int ret, len;
 	__le32 *buf;
-	int offb, offd;
+	int offb;
+	unsigned int offd;
 	const int stride = CMD_PACKET_SIZE / (4 * 2) - 1;
 	int buflen =  ((size - 1) / stride + 1 + size * 2) * 4;
 
diff --git a/drivers/usb/core/quirks.c b/drivers/usb/core/quirks.c
index e77a8e8..6af23f2 100644
--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -85,6 +85,9 @@ static const struct usb_device_id usb_quirk_list[] = {
 	/* Edirol SD-20 */
 	{ USB_DEVICE(0x0582, 0x0027), .driver_info = USB_QUIRK_RESET_RESUME },
 
+	/* Alcor Micro Corp. Hub */
+	{ USB_DEVICE(0x058f, 0x9254), .driver_info = USB_QUIRK_RESET_RESUME },
+
 	/* appletouch */
 	{ USB_DEVICE(0x05ac, 0x021a), .driver_info = USB_QUIRK_RESET_RESUME },
 
diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index eb0fd10..8212dbb 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -1650,10 +1650,21 @@ static void dwc3_gadget_free_endpoints(struct dwc3 *dwc)
 
 	for (epnum = 0; epnum < DWC3_ENDPOINTS_NUM; epnum++) {
 		dep = dwc->eps[epnum];
-		dwc3_free_trb_pool(dep);
-
-		if (epnum != 0 && epnum != 1)
+		if (!dep)
+			continue;
+		/*
+		 * Physical endpoints 0 and 1 are special; they form the
+		 * bi-directional USB endpoint 0.
+		 *
+		 * For those two physical endpoints, we don't allocate a TRB
+		 * pool nor do we add them the endpoints list. Due to that, we
+		 * shouldn't do these two operations otherwise we would end up
+		 * with all sorts of bugs when removing dwc3.ko.
+		 */
+		if (epnum != 0 && epnum != 1) {
+			dwc3_free_trb_pool(dep);
 			list_del(&dep->endpoint.ep_list);
+		}
 
 		kfree(dep);
 	}
diff --git a/drivers/usb/host/uhci-hub.c b/drivers/usb/host/uhci-hub.c
index 768d542..c994655 100644
--- a/drivers/usb/host/uhci-hub.c
+++ b/drivers/usb/host/uhci-hub.c
@@ -222,7 +222,8 @@ static int uhci_hub_status_data(struct usb_hcd *hcd, char *buf)
 		/* auto-stop if nothing connected for 1 second */
 		if (any_ports_active(uhci))
 			uhci->rh_state = UHCI_RH_RUNNING;
-		else if (time_after_eq(jiffies, uhci->auto_stop_time))
+		else if (time_after_eq(jiffies, uhci->auto_stop_time) &&
+				!uhci->wait_for_hp)
 			suspend_rh(uhci, UHCI_RH_AUTO_STOPPED);
 		break;
 
diff --git a/drivers/usb/host/xhci-mem.c b/drivers/usb/host/xhci-mem.c
index 487bc08..419d34a 100644
--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -1436,15 +1436,17 @@ int xhci_endpoint_init(struct xhci_hcd *xhci,
 	ep_ctx->ep_info2 |= cpu_to_le32(xhci_get_endpoint_type(udev, ep));
 
 	/* Set the max packet size and max burst */
+	max_packet = GET_MAX_PACKET(usb_endpoint_maxp(&ep->desc));
+	max_burst = 0;
 	switch (udev->speed) {
 	case USB_SPEED_SUPER:
-		max_packet = usb_endpoint_maxp(&ep->desc);
-		ep_ctx->ep_info2 |= cpu_to_le32(MAX_PACKET(max_packet));
 		/* dig out max burst from ep companion desc */
-		max_packet = ep->ss_ep_comp.bMaxBurst;
-		ep_ctx->ep_info2 |= cpu_to_le32(MAX_BURST(max_packet));
+		max_burst = ep->ss_ep_comp.bMaxBurst;
 		break;
 	case USB_SPEED_HIGH:
+		/* Some devices get this wrong */
+		if (usb_endpoint_xfer_bulk(&ep->desc))
+			max_packet = 512;
 		/* bits 11:12 specify the number of additional transaction
 		 * opportunities per microframe (USB 2.0, section 9.6.6)
 		 */
@@ -1452,17 +1454,16 @@ int xhci_endpoint_init(struct xhci_hcd *xhci,
 				usb_endpoint_xfer_int(&ep->desc)) {
 			max_burst = (usb_endpoint_maxp(&ep->desc)
 				     & 0x1800) >> 11;
-			ep_ctx->ep_info2 |= cpu_to_le32(MAX_BURST(max_burst));
 		}
-		/* Fall through */
+		break;
 	case USB_SPEED_FULL:
 	case USB_SPEED_LOW:
-		max_packet = GET_MAX_PACKET(usb_endpoint_maxp(&ep->desc));
-		ep_ctx->ep_info2 |= cpu_to_le32(MAX_PACKET(max_packet));
 		break;
 	default:
 		BUG();
 	}
+	ep_ctx->ep_info2 |= cpu_to_le32(MAX_PACKET(max_packet) |
+			MAX_BURST(max_burst));
 	max_esit_payload = xhci_get_max_esit_payload(xhci, udev, ep);
 	ep_ctx->tx_info = cpu_to_le32(MAX_ESIT_PAYLOAD_FOR_EP(max_esit_payload));
 
@@ -1839,6 +1840,9 @@ void xhci_mem_cleanup(struct xhci_hcd *xhci)
 	}
 	spin_unlock_irqrestore(&xhci->lock, flags);
 
+	if (!xhci->rh_bw)
+		goto no_bw;
+
 	num_ports = HCS_MAX_PORTS(xhci->hcs_params1);
 	for (i = 0; i < num_ports; i++) {
 		struct xhci_interval_bw_table *bwt = &xhci->rh_bw[i].bw_table;
@@ -1857,6 +1861,7 @@ void xhci_mem_cleanup(struct xhci_hcd *xhci)
 		}
 	}
 
+no_bw:
 	xhci->num_usb2_ports = 0;
 	xhci->num_usb3_ports = 0;
 	xhci->num_active_eps = 0;
@@ -2268,6 +2273,9 @@ int xhci_mem_init(struct xhci_hcd *xhci, gfp_t flags)
 	u32 page_size, temp;
 	int i;
 
+	INIT_LIST_HEAD(&xhci->lpm_failed_devs);
+	INIT_LIST_HEAD(&xhci->cancel_cmd_list);
+
 	page_size = xhci_readl(xhci, &xhci->op_regs->page_size);
 	xhci_dbg(xhci, "Supported page size register = 0x%x\n", page_size);
 	for (i = 0; i < 16; i++) {
@@ -2346,7 +2354,6 @@ int xhci_mem_init(struct xhci_hcd *xhci, gfp_t flags)
 	xhci->cmd_ring = xhci_ring_alloc(xhci, 1, 1, TYPE_COMMAND, flags);
 	if (!xhci->cmd_ring)
 		goto fail;
-	INIT_LIST_HEAD(&xhci->cancel_cmd_list);
 	xhci_dbg(xhci, "Allocated command ring at %p\n", xhci->cmd_ring);
 	xhci_dbg(xhci, "First segment DMA is 0x%llx\n",
 			(unsigned long long)xhci->cmd_ring->first_seg->dma);
@@ -2457,8 +2464,6 @@ int xhci_mem_init(struct xhci_hcd *xhci, gfp_t flags)
 	if (xhci_setup_port_arrays(xhci, flags))
 		goto fail;
 
-	INIT_LIST_HEAD(&xhci->lpm_failed_devs);
-
 	/* Enable USB 3.0 device notifications for function remote wake, which
 	 * is necessary for allowing USB 3.0 devices to do remote wakeup from
 	 * U3 (device suspend).
diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
index dcb72f7..cd0fc48 100644
--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -221,12 +221,22 @@ static void xhci_pci_remove(struct pci_dev *dev)
 static int xhci_pci_suspend(struct usb_hcd *hcd, bool do_wakeup)
 {
 	struct xhci_hcd	*xhci = hcd_to_xhci(hcd);
+	struct pci_dev		*pdev;
 	int	retval = 0;
 
 	if (hcd->state != HC_STATE_SUSPENDED ||
 			xhci->shared_hcd->state != HC_STATE_SUSPENDED)
 		return -EINVAL;
 
+	pdev = to_pci_dev(hcd->self.controller);
+
+	/*
+	 * Systems with the TI redriver that loses port status change events
+	 * need to have the registers polled during D3, so avoid D3cold.
+	 */
+	if (xhci_compliance_mode_recovery_timer_quirk_check())
+		pdev->no_d3cold = true;
+
 	retval = xhci_suspend(xhci);
 
 	return retval;
diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index fd36acd..2c117ec 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -466,7 +466,7 @@ static void compliance_mode_recovery_timer_init(struct xhci_hcd *xhci)
  * Systems:
  * Vendor: Hewlett-Packard -> System Models: Z420, Z620 and Z820
  */
-static bool compliance_mode_recovery_timer_quirk_check(void)
+bool xhci_compliance_mode_recovery_timer_quirk_check(void)
 {
 	const char *dmi_product_name, *dmi_sys_vendor;
 
@@ -517,7 +517,7 @@ int xhci_init(struct usb_hcd *hcd)
 	xhci_dbg(xhci, "Finished xhci_init\n");
 
 	/* Initializing Compliance Mode Recovery Data If Needed */
-	if (compliance_mode_recovery_timer_quirk_check()) {
+	if (xhci_compliance_mode_recovery_timer_quirk_check()) {
 		xhci->quirks |= XHCI_COMP_MODE_QUIRK;
 		compliance_mode_recovery_timer_init(xhci);
 	}
@@ -942,6 +942,7 @@ int xhci_resume(struct xhci_hcd *xhci, bool hibernated)
 	struct usb_hcd		*hcd = xhci_to_hcd(xhci);
 	struct usb_hcd		*secondary_hcd;
 	int			retval = 0;
+	bool			comp_timer_running = false;
 
 	/* Wait a bit if either of the roothubs need to settle from the
 	 * transition into bus suspend.
@@ -979,6 +980,13 @@ int xhci_resume(struct xhci_hcd *xhci, bool hibernated)
 
 	/* If restore operation fails, re-initialize the HC during resume */
 	if ((temp & STS_SRE) || hibernated) {
+
+		if ((xhci->quirks & XHCI_COMP_MODE_QUIRK) &&
+				!(xhci_all_ports_seen_u0(xhci))) {
+			del_timer_sync(&xhci->comp_mode_recovery_timer);
+			xhci_dbg(xhci, "Compliance Mode Recovery Timer deleted!\n");
+		}
+
 		/* Let the USB core know _both_ roothubs lost power. */
 		usb_root_hub_lost_power(xhci->main_hcd->self.root_hub);
 		usb_root_hub_lost_power(xhci->shared_hcd->self.root_hub);
@@ -1021,6 +1029,8 @@ int xhci_resume(struct xhci_hcd *xhci, bool hibernated)
 		retval = xhci_init(hcd->primary_hcd);
 		if (retval)
 			return retval;
+		comp_timer_running = true;
+
 		xhci_dbg(xhci, "Start the primary HCD\n");
 		retval = xhci_run(hcd->primary_hcd);
 		if (!retval) {
@@ -1062,7 +1072,7 @@ int xhci_resume(struct xhci_hcd *xhci, bool hibernated)
 	 * to suffer the Compliance Mode issue again. It doesn't matter if
 	 * ports have entered previously to U0 before system's suspension.
 	 */
-	if (xhci->quirks & XHCI_COMP_MODE_QUIRK)
+	if ((xhci->quirks & XHCI_COMP_MODE_QUIRK) && !comp_timer_running)
 		compliance_mode_recovery_timer_init(xhci);
 
 	return retval;
diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index 212d408..f056e9f 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -1852,4 +1852,7 @@ struct xhci_input_control_ctx *xhci_get_input_control_ctx(struct xhci_hcd *xhci,
 struct xhci_slot_ctx *xhci_get_slot_ctx(struct xhci_hcd *xhci, struct xhci_container_ctx *ctx);
 struct xhci_ep_ctx *xhci_get_ep_ctx(struct xhci_hcd *xhci, struct xhci_container_ctx *ctx, unsigned int ep_index);
 
+/* xHCI quirks */
+bool xhci_compliance_mode_recovery_timer_quirk_check(void);
+
 #endif /* __LINUX_XHCI_HCD_H */
diff --git a/drivers/usb/serial/ark3116.c b/drivers/usb/serial/ark3116.c
index 5f9eaaf..415c23f 100644
--- a/drivers/usb/serial/ark3116.c
+++ b/drivers/usb/serial/ark3116.c
@@ -49,7 +49,7 @@ static bool debug;
 #define DRIVER_NAME "ark3116"
 
 /* usb timeout of 1 second */
-#define ARK_TIMEOUT (1*HZ)
+#define ARK_TIMEOUT 1000
 
 static const struct usb_device_id id_table[] = {
 	{ USB_DEVICE(0x6547, 0x0232) },
diff --git a/drivers/usb/serial/cypress_m8.c b/drivers/usb/serial/cypress_m8.c
index 61de7e1..d7a16ba 100644
--- a/drivers/usb/serial/cypress_m8.c
+++ b/drivers/usb/serial/cypress_m8.c
@@ -70,6 +70,7 @@ static const struct usb_device_id id_table_earthmate[] = {
 static const struct usb_device_id id_table_cyphidcomrs232[] = {
 	{ USB_DEVICE(VENDOR_ID_CYPRESS, PRODUCT_ID_CYPHIDCOM) },
 	{ USB_DEVICE(VENDOR_ID_POWERCOM, PRODUCT_ID_UPS) },
+	{ USB_DEVICE(VENDOR_ID_FRWD, PRODUCT_ID_CYPHIDCOM_FRWD) },
 	{ }						/* Terminating entry */
 };
 
@@ -83,6 +84,7 @@ static const struct usb_device_id id_table_combined[] = {
 	{ USB_DEVICE(VENDOR_ID_DELORME, PRODUCT_ID_EARTHMATEUSB_LT20) },
 	{ USB_DEVICE(VENDOR_ID_CYPRESS, PRODUCT_ID_CYPHIDCOM) },
 	{ USB_DEVICE(VENDOR_ID_POWERCOM, PRODUCT_ID_UPS) },
+	{ USB_DEVICE(VENDOR_ID_FRWD, PRODUCT_ID_CYPHIDCOM_FRWD) },
 	{ USB_DEVICE(VENDOR_ID_DAZZLE, PRODUCT_ID_CA42) },
 	{ }						/* Terminating entry */
 };
@@ -235,6 +237,12 @@ static struct usb_serial_driver * const serial_drivers[] = {
  * Cypress serial helper functions
  *****************************************************************************/
 
+/* FRWD Dongle hidcom needs to skip reset and speed checks */
+static inline bool is_frwd(struct usb_device *dev)
+{
+	return ((le16_to_cpu(dev->descriptor.idVendor) == VENDOR_ID_FRWD) &&
+		(le16_to_cpu(dev->descriptor.idProduct) == PRODUCT_ID_CYPHIDCOM_FRWD));
+}
 
 static int analyze_baud_rate(struct usb_serial_port *port, speed_t new_rate)
 {
@@ -244,6 +252,10 @@ static int analyze_baud_rate(struct usb_serial_port *port, speed_t new_rate)
 	if (unstable_bauds)
 		return new_rate;
 
+	/* FRWD Dongle uses 115200 bps */
+	if (is_frwd(port->serial->dev))
+		return new_rate;
+
 	/*
 	 * The general purpose firmware for the Cypress M8 allows for
 	 * a maximum speed of 57600bps (I have no idea whether DeLorme
@@ -452,7 +464,11 @@ static int cypress_generic_port_probe(struct usb_serial_port *port)
 		return -ENOMEM;
 	}
 
-	usb_reset_configuration(serial->dev);
+	/* Skip reset for FRWD device. It is a workaound:
+	   device hangs if it receives SET_CONFIGURE in Configured
+	   state. */
+	if (!is_frwd(serial->dev))
+		usb_reset_configuration(serial->dev);
 
 	priv->cmd_ctrl = 0;
 	priv->line_control = 0;
diff --git a/drivers/usb/serial/cypress_m8.h b/drivers/usb/serial/cypress_m8.h
index 67cf608..b461311 100644
--- a/drivers/usb/serial/cypress_m8.h
+++ b/drivers/usb/serial/cypress_m8.h
@@ -24,6 +24,10 @@
 #define VENDOR_ID_CYPRESS		0x04b4
 #define PRODUCT_ID_CYPHIDCOM		0x5500
 
+/* FRWD Dongle - a GPS sports watch */
+#define VENDOR_ID_FRWD			0x6737
+#define PRODUCT_ID_CYPHIDCOM_FRWD	0x0001
+
 /* Powercom UPS, chip CY7C63723 */
 #define VENDOR_ID_POWERCOM		0x0d9f
 #define PRODUCT_ID_UPS			0x0002
diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 5843cc8..5c3e249 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -197,6 +197,8 @@ static struct usb_device_id id_table_combined [] = {
 	{ USB_DEVICE(FTDI_VID, FTDI_OPENDCC_GBM_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_OPENDCC_GBM_BOOST_PID) },
 	{ USB_DEVICE(NEWPORT_VID, NEWPORT_AGILIS_PID) },
+	{ USB_DEVICE(NEWPORT_VID, NEWPORT_CONEX_CC_PID) },
+	{ USB_DEVICE(NEWPORT_VID, NEWPORT_CONEX_AGP_PID) },
 	{ USB_DEVICE(INTERBIOMETRICS_VID, INTERBIOMETRICS_IOBOARD_PID) },
 	{ USB_DEVICE(INTERBIOMETRICS_VID, INTERBIOMETRICS_MINI_IOBOARD_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_SPROG_II) },
diff --git a/drivers/usb/serial/ftdi_sio_ids.h b/drivers/usb/serial/ftdi_sio_ids.h
index 5c84306..1e4bff5 100644
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -765,6 +765,8 @@
  */
 #define NEWPORT_VID			0x104D
 #define NEWPORT_AGILIS_PID		0x3000
+#define NEWPORT_CONEX_CC_PID		0x3002
+#define NEWPORT_CONEX_AGP_PID		0x3006
 
 /* Interbiometrics USB I/O Board */
 /* Developed for Interbiometrics by Rudolf Gugler */
diff --git a/drivers/usb/serial/generic.c b/drivers/usb/serial/generic.c
index 9b026bf..3b59dd8 100644
--- a/drivers/usb/serial/generic.c
+++ b/drivers/usb/serial/generic.c
@@ -267,6 +267,37 @@ int usb_serial_generic_chars_in_buffer(struct tty_struct *tty)
 	return chars;
 }
 
+void usb_serial_generic_wait_until_sent(struct tty_struct *tty, long timeout)
+{
+	struct usb_serial_port *port = tty->driver_data;
+	unsigned int bps;
+	unsigned long period;
+	unsigned long expire;
+
+	bps = tty_get_baud_rate(tty);
+	if (!bps)
+		bps = 9600;	/* B0 */
+	/*
+	 * Use a poll-period of roughly the time it takes to send one
+	 * character or at least one jiffy.
+	 */
+	period = max_t(unsigned long, (10 * HZ / bps), 1);
+	period = min_t(unsigned long, period, timeout);
+
+	dev_dbg(&port->dev, "%s - timeout = %u ms, period = %u ms\n",
+					__func__, jiffies_to_msecs(timeout),
+					jiffies_to_msecs(period));
+	expire = jiffies + timeout;
+	while (!port->serial->type->tx_empty(port)) {
+		schedule_timeout_interruptible(period);
+		if (signal_pending(current))
+			break;
+		if (time_after(jiffies, expire))
+			break;
+	}
+}
+EXPORT_SYMBOL_GPL(usb_serial_generic_wait_until_sent);
+
 static int usb_serial_generic_submit_read_urb(struct usb_serial_port *port,
 						int index, gfp_t mem_flags)
 {
diff --git a/drivers/usb/serial/io_ti.c b/drivers/usb/serial/io_ti.c
index d2b6008..93cf729 100644
--- a/drivers/usb/serial/io_ti.c
+++ b/drivers/usb/serial/io_ti.c
@@ -2163,6 +2163,18 @@ static int edge_chars_in_buffer(struct tty_struct *tty)
 	return chars;
 }
 
+static bool edge_tx_empty(struct usb_serial_port *port)
+{
+	struct edgeport_port *edge_port = usb_get_serial_port_data(port);
+	int ret;
+
+	ret = tx_active(edge_port);
+	if (ret > 0)
+		return false;
+
+	return true;
+}
+
 static void edge_throttle(struct tty_struct *tty)
 {
 	struct usb_serial_port *port = tty->driver_data;
@@ -2739,6 +2751,7 @@ static struct usb_serial_driver edgeport_1port_device = {
 	.write			= edge_write,
 	.write_room		= edge_write_room,
 	.chars_in_buffer	= edge_chars_in_buffer,
+	.tx_empty		= edge_tx_empty,
 	.break_ctl		= edge_break,
 	.read_int_callback	= edge_interrupt_callback,
 	.read_bulk_callback	= edge_bulk_in_callback,
@@ -2770,6 +2783,7 @@ static struct usb_serial_driver edgeport_2port_device = {
 	.write			= edge_write,
 	.write_room		= edge_write_room,
 	.chars_in_buffer	= edge_chars_in_buffer,
+	.tx_empty		= edge_tx_empty,
 	.break_ctl		= edge_break,
 	.read_int_callback	= edge_interrupt_callback,
 	.read_bulk_callback	= edge_bulk_in_callback,
diff --git a/drivers/usb/serial/iuu_phoenix.c b/drivers/usb/serial/iuu_phoenix.c
index 8d3692b..ae30f2c 100644
--- a/drivers/usb/serial/iuu_phoenix.c
+++ b/drivers/usb/serial/iuu_phoenix.c
@@ -311,7 +311,7 @@ static int bulk_immediate(struct usb_serial_port *port, u8 *buf, u8 count)
 	    usb_bulk_msg(serial->dev,
 			 usb_sndbulkpipe(serial->dev,
 					 port->bulk_out_endpointAddress), buf,
-			 count, &actual, HZ * 1);
+			 count, &actual, 1000);
 
 	if (status != IUU_OPERATION_OK)
 		dbg("%s - error = %2x", __func__, status);
@@ -331,7 +331,7 @@ static int read_immediate(struct usb_serial_port *port, u8 *buf, u8 count)
 	    usb_bulk_msg(serial->dev,
 			 usb_rcvbulkpipe(serial->dev,
 					 port->bulk_in_endpointAddress), buf,
-			 count, &actual, HZ * 1);
+			 count, &actual, 1000);
 
 	if (status != IUU_OPERATION_OK)
 		dbg("%s - error = %2x", __func__, status);
diff --git a/drivers/usb/serial/keyspan.c b/drivers/usb/serial/keyspan.c
index 059d44b..caf85ab 100644
--- a/drivers/usb/serial/keyspan.c
+++ b/drivers/usb/serial/keyspan.c
@@ -1622,7 +1622,7 @@ static int keyspan_usa26_send_setup(struct usb_serial *serial,
 	d_details = s_priv->device_details;
 	device_port = port->number - port->serial->minor;
 
-	outcont_urb = d_details->outcont_endpoints[port->number];
+	outcont_urb = d_details->outcont_endpoints[device_port];
 	this_urb = p_priv->outcont_urb;
 
 	dbg("%s - endpoint %d", __func__, usb_pipeendpoint(this_urb->pipe));
diff --git a/drivers/usb/serial/mos7720.c b/drivers/usb/serial/mos7720.c
index eb84767..b691404 100644
--- a/drivers/usb/serial/mos7720.c
+++ b/drivers/usb/serial/mos7720.c
@@ -44,7 +44,7 @@
 #define DRIVER_DESC "Moschip USB Serial Driver"
 
 /* default urb timeout */
-#define MOS_WDR_TIMEOUT	(HZ * 5)
+#define MOS_WDR_TIMEOUT	5000
 
 #define MOS_MAX_PORT	0x02
 #define MOS_WRITE	0x0E
@@ -234,11 +234,22 @@ static int read_mos_reg(struct usb_serial *serial, unsigned int serial_portnum,
 	__u8 requesttype = (__u8)0xc0;
 	__u16 index = get_reg_index(reg);
 	__u16 value = get_reg_value(reg, serial_portnum);
-	int status = usb_control_msg(usbdev, pipe, request, requesttype, value,
-				     index, data, 1, MOS_WDR_TIMEOUT);
-	if (status < 0)
+	u8 *buf;
+	int status;
+
+	buf = kmalloc(1, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	status = usb_control_msg(usbdev, pipe, request, requesttype, value,
+				     index, buf, 1, MOS_WDR_TIMEOUT);
+	if (status == 1)
+		*data = *buf;
+	else if (status < 0)
 		dev_err(&usbdev->dev,
 			"mos7720: usb_control_msg() failed: %d", status);
+	kfree(buf);
+
 	return status;
 }
 
@@ -1684,7 +1695,7 @@ static void change_port_settings(struct tty_struct *tty,
 		mos7720_port->shadowMCR |= (UART_MCR_XONANY);
 		/* To set hardware flow control to the specified *
 		 * serial port, in SP1/2_CONTROL_REG             */
-		if (port->number)
+		if (port_number)
 			write_mos_reg(serial, dummy, SP_CONTROL_REG, 0x01);
 		else
 			write_mos_reg(serial, dummy, SP_CONTROL_REG, 0x02);
@@ -2063,7 +2074,7 @@ static int mos7720_startup(struct usb_serial *serial)
 
 	/* setting configuration feature to one */
 	usb_control_msg(serial->dev, usb_sndctrlpipe(serial->dev, 0),
-			(__u8)0x03, 0x00, 0x01, 0x00, NULL, 0x00, 5*HZ);
+			(__u8)0x03, 0x00, 0x01, 0x00, NULL, 0x00, 5000);
 
 	/* start the interrupt urb */
 	ret_val = usb_submit_urb(serial->port[0]->interrupt_in_urb, GFP_KERNEL);
@@ -2106,7 +2117,7 @@ static void mos7720_release(struct usb_serial *serial)
 		/* wait for synchronous usb calls to return */
 		if (mos_parport->msg_pending)
 			wait_for_completion_timeout(&mos_parport->syncmsg_compl,
-						    MOS_WDR_TIMEOUT);
+					    msecs_to_jiffies(MOS_WDR_TIMEOUT));
 
 		parport_remove_port(mos_parport->pp);
 		usb_set_serial_data(serial, NULL);
diff --git a/drivers/usb/serial/mos7840.c b/drivers/usb/serial/mos7840.c
index 8654df0..3193d25 100644
--- a/drivers/usb/serial/mos7840.c
+++ b/drivers/usb/serial/mos7840.c
@@ -2341,13 +2341,21 @@ static int mos7840_ioctl(struct tty_struct *tty,
 static int mos7810_check(struct usb_serial *serial)
 {
 	int i, pass_count = 0;
+	u8 *buf;
 	__u16 data = 0, mcr_data = 0;
 	__u16 test_pattern = 0x55AA;
+	int res;
+
+	buf = kmalloc(VENDOR_READ_LENGTH, GFP_KERNEL);
+	if (!buf)
+		return 0;	/* failed to identify 7810 */
 
 	/* Store MCR setting */
-	usb_control_msg(serial->dev, usb_rcvctrlpipe(serial->dev, 0),
+	res = usb_control_msg(serial->dev, usb_rcvctrlpipe(serial->dev, 0),
 		MCS_RDREQ, MCS_RD_RTYPE, 0x0300, MODEM_CONTROL_REGISTER,
-		&mcr_data, VENDOR_READ_LENGTH, MOS_WDR_TIMEOUT);
+		buf, VENDOR_READ_LENGTH, MOS_WDR_TIMEOUT);
+	if (res == VENDOR_READ_LENGTH)
+		mcr_data = *buf;
 
 	for (i = 0; i < 16; i++) {
 		/* Send the 1-bit test pattern out to MCS7810 test pin */
@@ -2357,9 +2365,12 @@ static int mos7810_check(struct usb_serial *serial)
 			MODEM_CONTROL_REGISTER, NULL, 0, MOS_WDR_TIMEOUT);
 
 		/* Read the test pattern back */
-		usb_control_msg(serial->dev, usb_rcvctrlpipe(serial->dev, 0),
-			MCS_RDREQ, MCS_RD_RTYPE, 0, GPIO_REGISTER, &data,
-			VENDOR_READ_LENGTH, MOS_WDR_TIMEOUT);
+		res = usb_control_msg(serial->dev,
+				usb_rcvctrlpipe(serial->dev, 0), MCS_RDREQ,
+				MCS_RD_RTYPE, 0, GPIO_REGISTER, buf,
+				VENDOR_READ_LENGTH, MOS_WDR_TIMEOUT);
+		if (res == VENDOR_READ_LENGTH)
+			data = *buf;
 
 		/* If this is a MCS7810 device, both test patterns must match */
 		if (((test_pattern >> i) ^ (~data >> 1)) & 0x0001)
@@ -2373,6 +2384,8 @@ static int mos7810_check(struct usb_serial *serial)
 		MCS_WR_RTYPE, 0x0300 | mcr_data, MODEM_CONTROL_REGISTER, NULL,
 		0, MOS_WDR_TIMEOUT);
 
+	kfree(buf);
+
 	if (pass_count == 16)
 		return 1;
 
@@ -2382,11 +2395,17 @@ static int mos7810_check(struct usb_serial *serial)
 static int mos7840_calc_num_ports(struct usb_serial *serial)
 {
 	__u16 data = 0x00;
+	u8 *buf;
 	int mos7840_num_ports;
 
-	usb_control_msg(serial->dev, usb_rcvctrlpipe(serial->dev, 0),
-		MCS_RDREQ, MCS_RD_RTYPE, 0, GPIO_REGISTER, &data,
-		VENDOR_READ_LENGTH, MOS_WDR_TIMEOUT);
+	buf = kzalloc(VENDOR_READ_LENGTH, GFP_KERNEL);
+	if (buf) {
+		usb_control_msg(serial->dev, usb_rcvctrlpipe(serial->dev, 0),
+			MCS_RDREQ, MCS_RD_RTYPE, 0, GPIO_REGISTER, buf,
+			VENDOR_READ_LENGTH, MOS_WDR_TIMEOUT);
+		data = *buf;
+		kfree(buf);
+	}
 
 	if (serial->dev->descriptor.idProduct == MOSCHIP_DEVICE_ID_7810 ||
 		serial->dev->descriptor.idProduct == MOSCHIP_DEVICE_ID_7820) {
diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index 1689782..27adfce 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -197,6 +197,7 @@ static void option_instat_callback(struct urb *urb);
 
 #define DELL_PRODUCT_5800_MINICARD_VZW		0x8195  /* Novatel E362 */
 #define DELL_PRODUCT_5800_V2_MINICARD_VZW	0x8196  /* Novatel E362 */
+#define DELL_PRODUCT_5804_MINICARD_ATT		0x819b  /* Novatel E371 */
 
 #define KYOCERA_VENDOR_ID			0x0c88
 #define KYOCERA_PRODUCT_KPC650			0x17da
@@ -340,6 +341,8 @@ static void option_instat_callback(struct urb *urb);
 #define CINTERION_PRODUCT_EU3_E			0x0051
 #define CINTERION_PRODUCT_EU3_P			0x0052
 #define CINTERION_PRODUCT_PH8			0x0053
+#define CINTERION_PRODUCT_AHXX			0x0055
+#define CINTERION_PRODUCT_PLXX			0x0060
 
 /* Olivetti products */
 #define OLIVETTI_VENDOR_ID			0x0b3c
@@ -561,6 +564,8 @@ static const struct usb_device_id option_ids[] = {
 		.driver_info = (kernel_ulong_t) &huawei_cdc12_blacklist },
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_K3765, 0xff, 0xff, 0xff),
 		.driver_info = (kernel_ulong_t) &huawei_cdc12_blacklist },
+	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0x14ac, 0xff, 0xff, 0xff),	/* Huawei E1820 */
+		.driver_info = (kernel_ulong_t) &net_intf1_blacklist },
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_K4605, 0xff, 0xff, 0xff),
 		.driver_info = (kernel_ulong_t) &huawei_cdc12_blacklist },
 	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0xff, 0xff) },
@@ -740,6 +745,7 @@ static const struct usb_device_id option_ids[] = {
 	{ USB_DEVICE(DELL_VENDOR_ID, DELL_PRODUCT_5730_MINICARD_VZW) }, 	/* Dell Wireless 5730 Mobile Broadband EVDO/HSPA Mini-Card */
 	{ USB_DEVICE_AND_INTERFACE_INFO(DELL_VENDOR_ID, DELL_PRODUCT_5800_MINICARD_VZW, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(DELL_VENDOR_ID, DELL_PRODUCT_5800_V2_MINICARD_VZW, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(DELL_VENDOR_ID, DELL_PRODUCT_5804_MINICARD_ATT, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE(ANYDATA_VENDOR_ID, ANYDATA_PRODUCT_ADU_E100A) },	/* ADU-E100, ADU-310 */
 	{ USB_DEVICE(ANYDATA_VENDOR_ID, ANYDATA_PRODUCT_ADU_500A) },
 	{ USB_DEVICE(ANYDATA_VENDOR_ID, ANYDATA_PRODUCT_ADU_620UW) },
@@ -931,6 +937,8 @@ static const struct usb_device_id option_ids[] = {
 	  .driver_info = (kernel_ulong_t)&net_intf4_blacklist },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0330, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0395, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0412, 0xff, 0xff, 0xff), /* Telewell TW-LTE 4G */
+	  .driver_info = (kernel_ulong_t)&net_intf4_blacklist },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0414, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0417, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1008, 0xff, 0xff, 0xff),
@@ -1220,6 +1228,9 @@ static const struct usb_device_id option_ids[] = {
 	{ USB_DEVICE(CINTERION_VENDOR_ID, CINTERION_PRODUCT_EU3_E) },
 	{ USB_DEVICE(CINTERION_VENDOR_ID, CINTERION_PRODUCT_EU3_P) },
 	{ USB_DEVICE(CINTERION_VENDOR_ID, CINTERION_PRODUCT_PH8) },
+	{ USB_DEVICE(CINTERION_VENDOR_ID, CINTERION_PRODUCT_AHXX) },
+	{ USB_DEVICE(CINTERION_VENDOR_ID, CINTERION_PRODUCT_PLXX),
+		.driver_info = (kernel_ulong_t)&net_intf4_blacklist },
 	{ USB_DEVICE(CINTERION_VENDOR_ID, CINTERION_PRODUCT_HC28_MDM) }, 
 	{ USB_DEVICE(CINTERION_VENDOR_ID, CINTERION_PRODUCT_HC28_MDMNET) },
 	{ USB_DEVICE(SIEMENS_VENDOR_ID, CINTERION_PRODUCT_HC25_MDM) },
diff --git a/drivers/usb/serial/pl2303.c b/drivers/usb/serial/pl2303.c
index bf39f1b..058ab8e 100644
--- a/drivers/usb/serial/pl2303.c
+++ b/drivers/usb/serial/pl2303.c
@@ -285,7 +285,7 @@ static void pl2303_set_termios(struct tty_struct *tty,
 	   serial settings even to the same values as before. Thus
 	   we actually need to filter in this specific case */
 
-	if (!tty_termios_hw_change(tty->termios, old_termios))
+	if (old_termios && !tty_termios_hw_change(tty->termios, old_termios))
 		return;
 
 	cflag = tty->termios->c_cflag;
@@ -294,7 +294,8 @@ static void pl2303_set_termios(struct tty_struct *tty,
 	if (!buf) {
 		dev_err(&port->dev, "%s - out of memory.\n", __func__);
 		/* Report back no change occurred */
-		*tty->termios = *old_termios;
+		if (old_termios)
+			*tty->termios = *old_termios;
 		return;
 	}
 
@@ -434,7 +435,7 @@ static void pl2303_set_termios(struct tty_struct *tty,
 	control = priv->line_control;
 	if ((cflag & CBAUD) == B0)
 		priv->line_control &= ~(CONTROL_DTR | CONTROL_RTS);
-	else if ((old_termios->c_cflag & CBAUD) == B0)
+	else if (old_termios && (old_termios->c_cflag & CBAUD) == B0)
 		priv->line_control |= (CONTROL_DTR | CONTROL_RTS);
 	if (control != priv->line_control) {
 		control = priv->line_control;
@@ -493,7 +494,6 @@ static void pl2303_close(struct usb_serial_port *port)
 
 static int pl2303_open(struct tty_struct *tty, struct usb_serial_port *port)
 {
-	struct ktermios tmp_termios;
 	struct usb_serial *serial = port->serial;
 	struct pl2303_serial_private *spriv = usb_get_serial_data(serial);
 	int result;
@@ -509,7 +509,7 @@ static int pl2303_open(struct tty_struct *tty, struct usb_serial_port *port)
 
 	/* Setup termios */
 	if (tty)
-		pl2303_set_termios(tty, port, &tmp_termios);
+		pl2303_set_termios(tty, port, NULL);
 
 	result = usb_submit_urb(port->interrupt_in_urb, GFP_KERNEL);
 	if (result) {
diff --git a/drivers/usb/serial/qcserial.c b/drivers/usb/serial/qcserial.c
index 93232ca..cdfd838 100644
--- a/drivers/usb/serial/qcserial.c
+++ b/drivers/usb/serial/qcserial.c
@@ -119,6 +119,7 @@ static const struct usb_device_id id_table[] = {
 	{USB_DEVICE(0x1199, 0x901b)},	/* Sierra Wireless MC7770 */
 	{USB_DEVICE(0x12D1, 0x14F0)},	/* Sony Gobi 3000 QDL */
 	{USB_DEVICE(0x12D1, 0x14F1)},	/* Sony Gobi 3000 Composite */
+	{USB_DEVICE(0x0AF0, 0x8120)},	/* Option GTM681W */
 
 	/* non Gobi Qualcomm serial devices */
 	{USB_DEVICE_INTERFACE_NUMBER(0x0f3d, 0x68a2, 0)},	/* Sierra Wireless MC7700 Device Management */
diff --git a/drivers/usb/serial/spcp8x5.c b/drivers/usb/serial/spcp8x5.c
index 0822a10..cc35b13 100644
--- a/drivers/usb/serial/spcp8x5.c
+++ b/drivers/usb/serial/spcp8x5.c
@@ -319,7 +319,6 @@ static void spcp8x5_set_termios(struct tty_struct *tty,
 	struct spcp8x5_private *priv = usb_get_serial_port_data(port);
 	unsigned long flags;
 	unsigned int cflag = tty->termios->c_cflag;
-	unsigned int old_cflag = old_termios->c_cflag;
 	unsigned short uartdata;
 	unsigned char buf[2] = {0, 0};
 	int baud;
@@ -328,15 +327,15 @@ static void spcp8x5_set_termios(struct tty_struct *tty,
 
 
 	/* check that they really want us to change something */
-	if (!tty_termios_hw_change(tty->termios, old_termios))
+	if (old_termios && !tty_termios_hw_change(tty->termios, old_termios))
 		return;
 
 	/* set DTR/RTS active */
 	spin_lock_irqsave(&priv->lock, flags);
 	control = priv->line_control;
-	if ((old_cflag & CBAUD) == B0) {
+	if (old_termios && (old_termios->c_cflag & CBAUD) == B0) {
 		priv->line_control |= MCR_DTR;
-		if (!(old_cflag & CRTSCTS))
+		if (!(old_termios->c_cflag & CRTSCTS))
 			priv->line_control |= MCR_RTS;
 	}
 	if (control != priv->line_control) {
@@ -426,7 +425,6 @@ static void spcp8x5_set_termios(struct tty_struct *tty,
  * status of the device. */
 static int spcp8x5_open(struct tty_struct *tty, struct usb_serial_port *port)
 {
-	struct ktermios tmp_termios;
 	struct usb_serial *serial = port->serial;
 	struct spcp8x5_private *priv = usb_get_serial_port_data(port);
 	int ret;
@@ -447,7 +445,7 @@ static int spcp8x5_open(struct tty_struct *tty, struct usb_serial_port *port)
 
 	/* Setup termios */
 	if (tty)
-		spcp8x5_set_termios(tty, port, &tmp_termios);
+		spcp8x5_set_termios(tty, port, NULL);
 
 	spcp8x5_get_msr(serial->dev, &status, priv->type);
 
diff --git a/drivers/usb/serial/usb-serial.c b/drivers/usb/serial/usb-serial.c
index 5f38894..ac03c58 100644
--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -377,6 +377,22 @@ static int serial_chars_in_buffer(struct tty_struct *tty)
 	return port->serial->type->chars_in_buffer(tty);
 }
 
+static void serial_wait_until_sent(struct tty_struct *tty, int timeout)
+{
+	struct usb_serial_port *port = tty->driver_data;
+	struct usb_serial *serial = port->serial;
+
+	dev_dbg(tty->dev, "%s\n", __func__);
+
+	if (!port->serial->type->wait_until_sent)
+		return;
+
+	mutex_lock(&serial->disc_mutex);
+	if (!serial->disconnected)
+		port->serial->type->wait_until_sent(tty, timeout);
+	mutex_unlock(&serial->disc_mutex);
+}
+
 static void serial_throttle(struct tty_struct *tty)
 {
 	struct usb_serial_port *port = tty->driver_data;
@@ -1200,6 +1216,7 @@ static const struct tty_operations serial_ops = {
 	.unthrottle =		serial_unthrottle,
 	.break_ctl =		serial_break,
 	.chars_in_buffer =	serial_chars_in_buffer,
+	.wait_until_sent =	serial_wait_until_sent,
 	.tiocmget =		serial_tiocmget,
 	.tiocmset =		serial_tiocmset,
 	.get_icount =		serial_get_icount,
@@ -1332,6 +1349,8 @@ static void fixup_generic(struct usb_serial_driver *device)
 	set_to_generic_if_null(device, close);
 	set_to_generic_if_null(device, write_room);
 	set_to_generic_if_null(device, chars_in_buffer);
+	if (device->tx_empty)
+		set_to_generic_if_null(device, wait_until_sent);
 	set_to_generic_if_null(device, read_bulk_callback);
 	set_to_generic_if_null(device, write_bulk_callback);
 	set_to_generic_if_null(device, disconnect);
diff --git a/drivers/usb/serial/visor.c b/drivers/usb/serial/visor.c
index f253c91..4b53336 100644
--- a/drivers/usb/serial/visor.c
+++ b/drivers/usb/serial/visor.c
@@ -570,10 +570,19 @@ static int treo_attach(struct usb_serial *serial)
 	*/
 #define COPY_PORT(dest, src)						\
 	do { \
+		int i;							\
+									\
+		for (i = 0; i < ARRAY_SIZE(src->read_urbs); ++i) {	\
+			dest->read_urbs[i] = src->read_urbs[i];		\
+			dest->read_urbs[i]->context = dest;		\
+			dest->bulk_in_buffers[i] = src->bulk_in_buffers[i]; \
+		}							\
 		dest->read_urb = src->read_urb;				\
 		dest->bulk_in_endpointAddress = src->bulk_in_endpointAddress;\
 		dest->bulk_in_buffer = src->bulk_in_buffer;		\
+		dest->bulk_in_size = src->bulk_in_size;			\
 		dest->interrupt_in_urb = src->interrupt_in_urb;		\
+		dest->interrupt_in_urb->context = dest;			\
 		dest->interrupt_in_endpointAddress = \
 					src->interrupt_in_endpointAddress;\
 		dest->interrupt_in_buffer = src->interrupt_in_buffer;	\
diff --git a/drivers/usb/serial/whiteheat.c b/drivers/usb/serial/whiteheat.c
index bd36321..e8d650b 100644
--- a/drivers/usb/serial/whiteheat.c
+++ b/drivers/usb/serial/whiteheat.c
@@ -720,7 +720,7 @@ static void firm_setup_port(struct tty_struct *tty)
 	struct whiteheat_port_settings port_settings;
 	unsigned int cflag = tty->termios->c_cflag;
 
-	port_settings.port = port->number + 1;
+	port_settings.port = port->number - port->serial->minor + 1;
 
 	/* get the byte size */
 	switch (cflag & CSIZE) {
diff --git a/fs/ceph/locks.c b/fs/ceph/locks.c
index 80576d05..bb5fb3d 100644
--- a/fs/ceph/locks.c
+++ b/fs/ceph/locks.c
@@ -191,27 +191,23 @@ void ceph_count_locks(struct inode *inode, int *fcntl_count, int *flock_count)
 }
 
 /**
- * Encode the flock and fcntl locks for the given inode into the pagelist.
- * Format is: #fcntl locks, sequential fcntl locks, #flock locks,
- * sequential flock locks.
- * Must be called with lock_flocks() already held.
- * If we encounter more of a specific lock type than expected,
- * we return the value 1.
+ * Encode the flock and fcntl locks for the given inode into the ceph_filelock
+ * array. Must be called with lock_flocks() already held.
+ * If we encounter more of a specific lock type than expected, return -ENOSPC.
  */
-int ceph_encode_locks(struct inode *inode, struct ceph_pagelist *pagelist,
-		      int num_fcntl_locks, int num_flock_locks)
+int ceph_encode_locks_to_buffer(struct inode *inode,
+				struct ceph_filelock *flocks,
+				int num_fcntl_locks, int num_flock_locks)
 {
 	struct file_lock *lock;
-	struct ceph_filelock cephlock;
 	int err = 0;
 	int seen_fcntl = 0;
 	int seen_flock = 0;
+	int l = 0;
 
 	dout("encoding %d flock and %d fcntl locks", num_flock_locks,
 	     num_fcntl_locks);
-	err = ceph_pagelist_append(pagelist, &num_fcntl_locks, sizeof(u32));
-	if (err)
-		goto fail;
+
 	for (lock = inode->i_flock; lock != NULL; lock = lock->fl_next) {
 		if (lock->fl_flags & FL_POSIX) {
 			++seen_fcntl;
@@ -219,19 +215,12 @@ int ceph_encode_locks(struct inode *inode, struct ceph_pagelist *pagelist,
 				err = -ENOSPC;
 				goto fail;
 			}
-			err = lock_to_ceph_filelock(lock, &cephlock);
+			err = lock_to_ceph_filelock(lock, &flocks[l]);
 			if (err)
 				goto fail;
-			err = ceph_pagelist_append(pagelist, &cephlock,
-					   sizeof(struct ceph_filelock));
+			++l;
 		}
-		if (err)
-			goto fail;
 	}
-
-	err = ceph_pagelist_append(pagelist, &num_flock_locks, sizeof(u32));
-	if (err)
-		goto fail;
 	for (lock = inode->i_flock; lock != NULL; lock = lock->fl_next) {
 		if (lock->fl_flags & FL_FLOCK) {
 			++seen_flock;
@@ -239,19 +228,51 @@ int ceph_encode_locks(struct inode *inode, struct ceph_pagelist *pagelist,
 				err = -ENOSPC;
 				goto fail;
 			}
-			err = lock_to_ceph_filelock(lock, &cephlock);
+			err = lock_to_ceph_filelock(lock, &flocks[l]);
 			if (err)
 				goto fail;
-			err = ceph_pagelist_append(pagelist, &cephlock,
-					   sizeof(struct ceph_filelock));
+			++l;
 		}
-		if (err)
-			goto fail;
 	}
 fail:
 	return err;
 }
 
+/**
+ * Copy the encoded flock and fcntl locks into the pagelist.
+ * Format is: #fcntl locks, sequential fcntl locks, #flock locks,
+ * sequential flock locks.
+ * Returns zero on success.
+ */
+int ceph_locks_to_pagelist(struct ceph_filelock *flocks,
+			   struct ceph_pagelist *pagelist,
+			   int num_fcntl_locks, int num_flock_locks)
+{
+	int err = 0;
+	__le32 nlocks;
+
+	nlocks = cpu_to_le32(num_fcntl_locks);
+	err = ceph_pagelist_append(pagelist, &nlocks, sizeof(nlocks));
+	if (err)
+		goto out_fail;
+
+	err = ceph_pagelist_append(pagelist, flocks,
+				   num_fcntl_locks * sizeof(*flocks));
+	if (err)
+		goto out_fail;
+
+	nlocks = cpu_to_le32(num_flock_locks);
+	err = ceph_pagelist_append(pagelist, &nlocks, sizeof(nlocks));
+	if (err)
+		goto out_fail;
+
+	err = ceph_pagelist_append(pagelist,
+				   &flocks[num_fcntl_locks],
+				   num_flock_locks * sizeof(*flocks));
+out_fail:
+	return err;
+}
+
 /*
  * Given a pointer to a lock, convert it to a ceph filelock
  */
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 1bcf712..7b500bb 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -336,9 +336,9 @@ void ceph_put_mds_session(struct ceph_mds_session *s)
 	     atomic_read(&s->s_ref), atomic_read(&s->s_ref)-1);
 	if (atomic_dec_and_test(&s->s_ref)) {
 		if (s->s_auth.authorizer)
-		     s->s_mdsc->fsc->client->monc.auth->ops->destroy_authorizer(
-			     s->s_mdsc->fsc->client->monc.auth,
-			     s->s_auth.authorizer);
+			ceph_auth_destroy_authorizer(
+				s->s_mdsc->fsc->client->monc.auth,
+				s->s_auth.authorizer);
 		kfree(s);
 	}
 }
@@ -2440,39 +2440,44 @@ static int encode_caps_cb(struct inode *inode, struct ceph_cap *cap,
 
 	if (recon_state->flock) {
 		int num_fcntl_locks, num_flock_locks;
-		struct ceph_pagelist_cursor trunc_point;
-
-		ceph_pagelist_set_cursor(pagelist, &trunc_point);
-		do {
-			lock_flocks();
-			ceph_count_locks(inode, &num_fcntl_locks,
-					 &num_flock_locks);
-			rec.v2.flock_len = (2*sizeof(u32) +
-					    (num_fcntl_locks+num_flock_locks) *
-					    sizeof(struct ceph_filelock));
-			unlock_flocks();
-
-			/* pre-alloc pagelist */
-			ceph_pagelist_truncate(pagelist, &trunc_point);
-			err = ceph_pagelist_append(pagelist, &rec, reclen);
-			if (!err)
-				err = ceph_pagelist_reserve(pagelist,
-							    rec.v2.flock_len);
-
-			/* encode locks */
-			if (!err) {
-				lock_flocks();
-				err = ceph_encode_locks(inode,
-							pagelist,
-							num_fcntl_locks,
-							num_flock_locks);
-				unlock_flocks();
-			}
-		} while (err == -ENOSPC);
+		struct ceph_filelock *flocks;
+
+encode_again:
+		lock_flocks();
+		ceph_count_locks(inode, &num_fcntl_locks, &num_flock_locks);
+		unlock_flocks();
+		flocks = kmalloc((num_fcntl_locks+num_flock_locks) *
+				 sizeof(struct ceph_filelock), GFP_NOFS);
+		if (!flocks) {
+			err = -ENOMEM;
+			goto out_free;
+		}
+		lock_flocks();
+		err = ceph_encode_locks_to_buffer(inode, flocks,
+						  num_fcntl_locks,
+						  num_flock_locks);
+		unlock_flocks();
+		if (err) {
+			kfree(flocks);
+			if (err == -ENOSPC)
+				goto encode_again;
+			goto out_free;
+		}
+		/*
+		 * number of encoded locks is stable, so copy to pagelist
+		 */
+		rec.v2.flock_len = cpu_to_le32(2*sizeof(u32) +
+				    (num_fcntl_locks+num_flock_locks) *
+				    sizeof(struct ceph_filelock));
+		err = ceph_pagelist_append(pagelist, &rec, reclen);
+		if (!err)
+			err = ceph_locks_to_pagelist(flocks, pagelist,
+						     num_fcntl_locks,
+						     num_flock_locks);
+		kfree(flocks);
 	} else {
 		err = ceph_pagelist_append(pagelist, &rec, reclen);
 	}
-
 out_free:
 	kfree(path);
 out_dput:
@@ -3399,13 +3404,17 @@ static struct ceph_auth_handshake *get_authorizer(struct ceph_connection *con,
 	struct ceph_auth_handshake *auth = &s->s_auth;
 
 	if (force_new && auth->authorizer) {
-		if (ac->ops && ac->ops->destroy_authorizer)
-			ac->ops->destroy_authorizer(ac, auth->authorizer);
+		ceph_auth_destroy_authorizer(ac, auth->authorizer);
 		auth->authorizer = NULL;
 	}
-	if (!auth->authorizer && ac->ops && ac->ops->create_authorizer) {
-		int ret = ac->ops->create_authorizer(ac, CEPH_ENTITY_TYPE_MDS,
-							auth);
+	if (!auth->authorizer) {
+		int ret = ceph_auth_create_authorizer(ac, CEPH_ENTITY_TYPE_MDS,
+						      auth);
+		if (ret)
+			return ERR_PTR(ret);
+	} else {
+		int ret = ceph_auth_update_authorizer(ac, CEPH_ENTITY_TYPE_MDS,
+						      auth);
 		if (ret)
 			return ERR_PTR(ret);
 	}
@@ -3421,7 +3430,7 @@ static int verify_authorizer_reply(struct ceph_connection *con, int len)
 	struct ceph_mds_client *mdsc = s->s_mdsc;
 	struct ceph_auth_client *ac = mdsc->fsc->client->monc.auth;
 
-	return ac->ops->verify_authorizer_reply(ac, s->s_auth.authorizer, len);
+	return ceph_auth_verify_authorizer_reply(ac, s->s_auth.authorizer, len);
 }
 
 static int invalidate_authorizer(struct ceph_connection *con)
@@ -3430,8 +3439,7 @@ static int invalidate_authorizer(struct ceph_connection *con)
 	struct ceph_mds_client *mdsc = s->s_mdsc;
 	struct ceph_auth_client *ac = mdsc->fsc->client->monc.auth;
 
-	if (ac->ops->invalidate_authorizer)
-		ac->ops->invalidate_authorizer(ac, CEPH_ENTITY_TYPE_MDS);
+	ceph_auth_invalidate_authorizer(ac, CEPH_ENTITY_TYPE_MDS);
 
 	return ceph_monc_validate_auth(&mdsc->fsc->client->monc);
 }
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 66ebe72..bd49b4f 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -847,8 +847,13 @@ extern const struct export_operations ceph_export_ops;
 extern int ceph_lock(struct file *file, int cmd, struct file_lock *fl);
 extern int ceph_flock(struct file *file, int cmd, struct file_lock *fl);
 extern void ceph_count_locks(struct inode *inode, int *p_num, int *f_num);
-extern int ceph_encode_locks(struct inode *i, struct ceph_pagelist *p,
-			     int p_locks, int f_locks);
+extern int ceph_encode_locks_to_buffer(struct inode *inode,
+				       struct ceph_filelock *flocks,
+				       int num_fcntl_locks,
+				       int num_flock_locks);
+extern int ceph_locks_to_pagelist(struct ceph_filelock *flocks,
+				  struct ceph_pagelist *pagelist,
+				  int num_fcntl_locks, int num_flock_locks);
 extern int lock_to_ceph_filelock(struct file_lock *fl, struct ceph_filelock *c);
 
 /* debugfs.c */
diff --git a/fs/cifs/cifs_dfs_ref.c b/fs/cifs/cifs_dfs_ref.c
index ce5cbd7..52527dd 100644
--- a/fs/cifs/cifs_dfs_ref.c
+++ b/fs/cifs/cifs_dfs_ref.c
@@ -18,6 +18,7 @@
 #include <linux/slab.h>
 #include <linux/vfs.h>
 #include <linux/fs.h>
+#include <linux/inet.h>
 #include "cifsglob.h"
 #include "cifsproto.h"
 #include "cifsfs.h"
@@ -150,7 +151,8 @@ char *cifs_compose_mount_options(const char *sb_mountdata,
 	 * assuming that we have 'unc=' and 'ip=' in
 	 * the original sb_mountdata
 	 */
-	md_len = strlen(sb_mountdata) + rc + strlen(ref->node_name) + 12;
+	md_len = strlen(sb_mountdata) + rc + strlen(ref->node_name) + 12 +
+			INET6_ADDRSTRLEN;
 	mountdata = kzalloc(md_len+1, GFP_KERNEL);
 	if (mountdata == NULL) {
 		rc = -ENOMEM;
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index cb79c7e..8808dce 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -169,7 +169,8 @@ cifs_fattr_to_inode(struct inode *inode, struct cifs_fattr *fattr)
 
 	if (fattr->cf_flags & CIFS_FATTR_DFS_REFERRAL)
 		inode->i_flags |= S_AUTOMOUNT;
-	cifs_set_ops(inode);
+	if (inode->i_state & I_NEW)
+		cifs_set_ops(inode);
 }
 
 void
diff --git a/fs/ecryptfs/file.c b/fs/ecryptfs/file.c
index d45ba45..9d5dd5c 100644
--- a/fs/ecryptfs/file.c
+++ b/fs/ecryptfs/file.c
@@ -296,6 +296,12 @@ static int ecryptfs_release(struct inode *inode, struct file *file)
 static int
 ecryptfs_fsync(struct file *file, loff_t start, loff_t end, int datasync)
 {
+	int rc;
+
+	rc = filemap_write_and_wait(file->f_mapping);
+	if (rc)
+		return rc;
+
 	return vfs_fsync(ecryptfs_file_to_lower(file), datasync);
 }
 
diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index 05e897f..ca5241f 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -1212,6 +1212,19 @@ static int fat_read_root(struct inode *inode)
 	return 0;
 }
 
+static unsigned long calc_fat_clusters(struct super_block *sb)
+{
+	struct msdos_sb_info *sbi = MSDOS_SB(sb);
+
+	/* Divide first to avoid overflow */
+	if (sbi->fat_bits != 12) {
+		unsigned long ent_per_sec = sb->s_blocksize * 8 / sbi->fat_bits;
+		return ent_per_sec * sbi->fat_length;
+	}
+
+	return sbi->fat_length * sb->s_blocksize * 8 / sbi->fat_bits;
+}
+
 /*
  * Read the super block of an MS-DOS FS.
  */
@@ -1409,7 +1422,7 @@ int fat_fill_super(struct super_block *sb, void *data, int silent, int isvfat,
 		sbi->fat_bits = (total_clusters > MAX_FAT12) ? 16 : 12;
 
 	/* check that FAT table does not overflow */
-	fat_clusters = sbi->fat_length * sb->s_blocksize * 8 / sbi->fat_bits;
+	fat_clusters = calc_fat_clusters(sb);
 	total_clusters = min(total_clusters, fat_clusters - FAT_START_ENT);
 	if (total_clusters > MAX_FAT(sb)) {
 		if (!silent)
diff --git a/fs/jfs/inode.c b/fs/jfs/inode.c
index 4692bf3..7e54dfd 100644
--- a/fs/jfs/inode.c
+++ b/fs/jfs/inode.c
@@ -125,7 +125,7 @@ int jfs_write_inode(struct inode *inode, struct writeback_control *wbc)
 {
 	int wait = wbc->sync_mode == WB_SYNC_ALL;
 
-	if (test_cflag(COMMIT_Nolink, inode))
+	if (inode->i_nlink == 0)
 		return 0;
 	/*
 	 * If COMMIT_DIRTY is not set, the inode isn't really dirty.
diff --git a/fs/jfs/jfs_logmgr.c b/fs/jfs/jfs_logmgr.c
index 2eb952c..cbe48ea 100644
--- a/fs/jfs/jfs_logmgr.c
+++ b/fs/jfs/jfs_logmgr.c
@@ -1058,7 +1058,8 @@ static int lmLogSync(struct jfs_log * log, int hard_sync)
  */
 void jfs_syncpt(struct jfs_log *log, int hard_sync)
 {	LOG_LOCK(log);
-	lmLogSync(log, hard_sync);
+	if (!test_bit(log_QUIESCE, &log->flag))
+		lmLogSync(log, hard_sync);
 	LOG_UNLOCK(log);
 }
 
diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 4d135ef..24affff 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -1074,7 +1074,7 @@ static struct nfs4_state *nfs4_try_open_cached(struct nfs4_opendata *opendata)
 	struct nfs4_state *state = opendata->state;
 	struct nfs_inode *nfsi = NFS_I(state->inode);
 	struct nfs_delegation *delegation;
-	int open_mode = opendata->o_arg.open_flags & (O_EXCL|O_TRUNC);
+	int open_mode = opendata->o_arg.open_flags;
 	fmode_t fmode = opendata->o_arg.fmode;
 	nfs4_stateid stateid;
 	int ret = -EAGAIN;
diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index 6e2c3db..cbda0a4 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -202,13 +202,32 @@ static int nilfs_writepage(struct page *page, struct writeback_control *wbc)
 
 static int nilfs_set_page_dirty(struct page *page)
 {
-	int ret = __set_page_dirty_buffers(page);
+	int ret = __set_page_dirty_nobuffers(page);
 
-	if (ret) {
+	if (page_has_buffers(page)) {
 		struct inode *inode = page->mapping->host;
-		unsigned nr_dirty = 1 << (PAGE_SHIFT - inode->i_blkbits);
+		unsigned nr_dirty = 0;
+		struct buffer_head *bh, *head;
 
-		nilfs_set_file_dirty(inode, nr_dirty);
+		/*
+		 * This page is locked by callers, and no other thread
+		 * concurrently marks its buffers dirty since they are
+		 * only dirtied through routines in fs/buffer.c in
+		 * which call sites of mark_buffer_dirty are protected
+		 * by page lock.
+		 */
+		bh = head = page_buffers(page);
+		do {
+			/* Do not mark hole blocks dirty */
+			if (buffer_dirty(bh) || !buffer_mapped(bh))
+				continue;
+
+			set_buffer_dirty(bh);
+			nr_dirty++;
+		} while (bh = bh->b_this_page, bh != head);
+
+		if (nr_dirty)
+			nilfs_set_file_dirty(inode, nr_dirty);
 	}
 	return ret;
 }
diff --git a/fs/ocfs2/extent_map.c b/fs/ocfs2/extent_map.c
index 70b5863..4dd0239 100644
--- a/fs/ocfs2/extent_map.c
+++ b/fs/ocfs2/extent_map.c
@@ -791,7 +791,7 @@ int ocfs2_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 						 &hole_size, &rec, &is_last);
 		if (ret) {
 			mlog_errno(ret);
-			goto out;
+			goto out_unlock;
 		}
 
 		if (rec.e_blkno == 0ULL) {
diff --git a/fs/proc/kmsg.c b/fs/proc/kmsg.c
index bd4b5a7..bdfabda 100644
--- a/fs/proc/kmsg.c
+++ b/fs/proc/kmsg.c
@@ -21,12 +21,12 @@ extern wait_queue_head_t log_wait;
 
 static int kmsg_open(struct inode * inode, struct file * file)
 {
-	return do_syslog(SYSLOG_ACTION_OPEN, NULL, 0, SYSLOG_FROM_FILE);
+	return do_syslog(SYSLOG_ACTION_OPEN, NULL, 0, SYSLOG_FROM_PROC);
 }
 
 static int kmsg_release(struct inode * inode, struct file * file)
 {
-	(void) do_syslog(SYSLOG_ACTION_CLOSE, NULL, 0, SYSLOG_FROM_FILE);
+	(void) do_syslog(SYSLOG_ACTION_CLOSE, NULL, 0, SYSLOG_FROM_PROC);
 	return 0;
 }
 
@@ -34,15 +34,15 @@ static ssize_t kmsg_read(struct file *file, char __user *buf,
 			 size_t count, loff_t *ppos)
 {
 	if ((file->f_flags & O_NONBLOCK) &&
-	    !do_syslog(SYSLOG_ACTION_SIZE_UNREAD, NULL, 0, SYSLOG_FROM_FILE))
+	    !do_syslog(SYSLOG_ACTION_SIZE_UNREAD, NULL, 0, SYSLOG_FROM_PROC))
 		return -EAGAIN;
-	return do_syslog(SYSLOG_ACTION_READ, buf, count, SYSLOG_FROM_FILE);
+	return do_syslog(SYSLOG_ACTION_READ, buf, count, SYSLOG_FROM_PROC);
 }
 
 static unsigned int kmsg_poll(struct file *file, poll_table *wait)
 {
 	poll_wait(file, &log_wait, wait);
-	if (do_syslog(SYSLOG_ACTION_SIZE_UNREAD, NULL, 0, SYSLOG_FROM_FILE))
+	if (do_syslog(SYSLOG_ACTION_SIZE_UNREAD, NULL, 0, SYSLOG_FROM_PROC))
 		return POLLIN | POLLRDNORM;
 	return 0;
 }
diff --git a/fs/reiserfs/dir.c b/fs/reiserfs/dir.c
index 66c53b6..6c2d136 100644
--- a/fs/reiserfs/dir.c
+++ b/fs/reiserfs/dir.c
@@ -204,6 +204,8 @@ int reiserfs_readdir_dentry(struct dentry *dentry, void *dirent,
 				next_pos = deh_offset(deh) + 1;
 
 				if (item_moved(&tmp_ih, &path_to_entry)) {
+					set_cpu_key_k_offset(&pos_key,
+							     next_pos);
 					goto research;
 				}
 			}	/* for */
diff --git a/fs/reiserfs/inode.c b/fs/reiserfs/inode.c
index 567c10c..582777f 100644
--- a/fs/reiserfs/inode.c
+++ b/fs/reiserfs/inode.c
@@ -1810,11 +1810,16 @@ int reiserfs_new_inode(struct reiserfs_transaction_handle *th,
 				  TYPE_STAT_DATA, SD_SIZE, MAX_US_INT);
 	memcpy(INODE_PKEY(inode), &(ih.ih_key), KEY_SIZE);
 	args.dirid = le32_to_cpu(ih.ih_key.k_dir_id);
-	if (insert_inode_locked4(inode, args.objectid,
-			     reiserfs_find_actor, &args) < 0) {
+
+	reiserfs_write_unlock(inode->i_sb);
+	err = insert_inode_locked4(inode, args.objectid,
+			     reiserfs_find_actor, &args);
+	reiserfs_write_lock(inode->i_sb);
+	if (err) {
 		err = -EINVAL;
 		goto out_bad_inode;
 	}
+
 	if (old_format_only(sb))
 		/* not a perfect generation count, as object ids can be reused, but
 		 ** this is as good as reiserfs can do right now.
diff --git a/fs/reiserfs/xattr.c b/fs/reiserfs/xattr.c
index d319963..78f823d 100644
--- a/fs/reiserfs/xattr.c
+++ b/fs/reiserfs/xattr.c
@@ -318,7 +318,19 @@ static int delete_one_xattr(struct dentry *dentry, void *data)
 static int chown_one_xattr(struct dentry *dentry, void *data)
 {
 	struct iattr *attrs = data;
-	return reiserfs_setattr(dentry, attrs);
+	int ia_valid = attrs->ia_valid;
+	int err;
+
+	/*
+	 * We only want the ownership bits. Otherwise, we'll do
+	 * things like change a directory to a regular file if
+	 * ATTR_MODE is set.
+	 */
+	attrs->ia_valid &= (ATTR_UID|ATTR_GID);
+	err = reiserfs_setattr(dentry, attrs);
+	attrs->ia_valid = ia_valid;
+
+	return err;
 }
 
 /* No i_mutex, but the inode is unconnected. */
diff --git a/fs/reiserfs/xattr_acl.c b/fs/reiserfs/xattr_acl.c
index 44474f9..84fe30c 100644
--- a/fs/reiserfs/xattr_acl.c
+++ b/fs/reiserfs/xattr_acl.c
@@ -429,6 +429,9 @@ int reiserfs_acl_chmod(struct inode *inode)
 	int depth;
 	int error;
 
+	if (IS_PRIVATE(inode))
+		return 0;
+
 	if (S_ISLNK(inode->i_mode))
 		return -EOPNOTSUPP;
 
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 4e00cf0..53c2145 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -454,6 +454,28 @@ xfs_vn_getattr(
 	return 0;
 }
 
+static void
+xfs_setattr_mode(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip,
+	struct iattr		*iattr)
+{
+	struct inode	*inode = VFS_I(ip);
+	umode_t		mode = iattr->ia_mode;
+
+	ASSERT(tp);
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
+
+	if (!in_group_p(inode->i_gid) && !capable(CAP_FSETID))
+		mode &= ~S_ISGID;
+
+	ip->i_d.di_mode &= S_IFMT;
+	ip->i_d.di_mode |= mode & ~S_IFMT;
+
+	inode->i_mode &= S_IFMT;
+	inode->i_mode |= mode & ~S_IFMT;
+}
+
 int
 xfs_setattr_nonsize(
 	struct xfs_inode	*ip,
@@ -605,18 +627,8 @@ xfs_setattr_nonsize(
 	/*
 	 * Change file access modes.
 	 */
-	if (mask & ATTR_MODE) {
-		umode_t mode = iattr->ia_mode;
-
-		if (!in_group_p(inode->i_gid) && !capable(CAP_FSETID))
-			mode &= ~S_ISGID;
-
-		ip->i_d.di_mode &= S_IFMT;
-		ip->i_d.di_mode |= mode & ~S_IFMT;
-
-		inode->i_mode &= S_IFMT;
-		inode->i_mode |= mode & ~S_IFMT;
-	}
+	if (mask & ATTR_MODE)
+		xfs_setattr_mode(tp, ip, iattr);
 
 	/*
 	 * Change file access or modified times.
@@ -713,9 +725,8 @@ xfs_setattr_size(
 		return XFS_ERROR(error);
 
 	ASSERT(S_ISREG(ip->i_d.di_mode));
-	ASSERT((mask & (ATTR_MODE|ATTR_UID|ATTR_GID|ATTR_ATIME|ATTR_ATIME_SET|
-			ATTR_MTIME_SET|ATTR_KILL_SUID|ATTR_KILL_SGID|
-			ATTR_KILL_PRIV|ATTR_TIMES_SET)) == 0);
+	ASSERT((mask & (ATTR_UID|ATTR_GID|ATTR_ATIME|ATTR_ATIME_SET|
+			ATTR_MTIME_SET|ATTR_KILL_PRIV|ATTR_TIMES_SET)) == 0);
 
 	if (!(flags & XFS_ATTR_NOLOCK)) {
 		lock_flags |= XFS_IOLOCK_EXCL;
@@ -856,6 +867,12 @@ xfs_setattr_size(
 		xfs_iflags_set(ip, XFS_ITRUNCATED);
 	}
 
+	/*
+	 * Change file access modes.
+	 */
+	if (mask & ATTR_MODE)
+		xfs_setattr_mode(tp, ip, iattr);
+
 	if (mask & ATTR_CTIME) {
 		inode->i_ctime = iattr->ia_ctime;
 		ip->i_d.di_ctime.t_sec = iattr->ia_ctime.tv_sec;
diff --git a/include/linux/ceph/auth.h b/include/linux/ceph/auth.h
index d4080f3..5f33868 100644
--- a/include/linux/ceph/auth.h
+++ b/include/linux/ceph/auth.h
@@ -52,6 +52,9 @@ struct ceph_auth_client_ops {
 	 */
 	int (*create_authorizer)(struct ceph_auth_client *ac, int peer_type,
 				 struct ceph_auth_handshake *auth);
+	/* ensure that an existing authorizer is up to date */
+	int (*update_authorizer)(struct ceph_auth_client *ac, int peer_type,
+				 struct ceph_auth_handshake *auth);
 	int (*verify_authorizer_reply)(struct ceph_auth_client *ac,
 				       struct ceph_authorizer *a, size_t len);
 	void (*destroy_authorizer)(struct ceph_auth_client *ac,
@@ -75,6 +78,8 @@ struct ceph_auth_client {
 	u64 global_id;          /* our unique id in system */
 	const struct ceph_crypto_key *key;     /* our secret key */
 	unsigned want_keys;     /* which services we want */
+
+	struct mutex mutex;
 };
 
 extern struct ceph_auth_client *ceph_auth_init(const char *name,
@@ -94,5 +99,18 @@ extern int ceph_build_auth(struct ceph_auth_client *ac,
 		    void *msg_buf, size_t msg_len);
 
 extern int ceph_auth_is_authenticated(struct ceph_auth_client *ac);
+extern int ceph_auth_create_authorizer(struct ceph_auth_client *ac,
+				       int peer_type,
+				       struct ceph_auth_handshake *auth);
+extern void ceph_auth_destroy_authorizer(struct ceph_auth_client *ac,
+					 struct ceph_authorizer *a);
+extern int ceph_auth_update_authorizer(struct ceph_auth_client *ac,
+				       int peer_type,
+				       struct ceph_auth_handshake *a);
+extern int ceph_auth_verify_authorizer_reply(struct ceph_auth_client *ac,
+					     struct ceph_authorizer *a,
+					     size_t len);
+extern void ceph_auth_invalidate_authorizer(struct ceph_auth_client *ac,
+					    int peer_type);
 
 #endif
diff --git a/include/linux/cpu.h b/include/linux/cpu.h
index ce7a074..714e792 100644
--- a/include/linux/cpu.h
+++ b/include/linux/cpu.h
@@ -175,6 +175,8 @@ extern struct bus_type cpu_subsys;
 
 extern void get_online_cpus(void);
 extern void put_online_cpus(void);
+extern void cpu_hotplug_disable(void);
+extern void cpu_hotplug_enable(void);
 #define hotcpu_notifier(fn, pri)	cpu_notifier(fn, pri)
 #define register_hotcpu_notifier(nb)	register_cpu_notifier(nb)
 #define unregister_hotcpu_notifier(nb)	unregister_cpu_notifier(nb)
@@ -198,6 +200,8 @@ static inline void cpu_hotplug_driver_unlock(void)
 
 #define get_online_cpus()	do { } while (0)
 #define put_online_cpus()	do { } while (0)
+#define cpu_hotplug_disable()	do { } while (0)
+#define cpu_hotplug_enable()	do { } while (0)
 #define hotcpu_notifier(fn, pri)	do { (void)(fn); } while (0)
 /* These aren't inline functions due to a GCC bug. */
 #define register_hotcpu_notifier(nb)	({ (void)(nb); 0; })
diff --git a/include/linux/swapops.h b/include/linux/swapops.h
index 47ead51..c5fd30d 100644
--- a/include/linux/swapops.h
+++ b/include/linux/swapops.h
@@ -137,6 +137,7 @@ static inline void make_migration_entry_read(swp_entry_t *entry)
 
 extern void migration_entry_wait(struct mm_struct *mm, pmd_t *pmd,
 					unsigned long address);
+extern void migration_entry_wait_huge(struct mm_struct *mm, pte_t *pte);
 #else
 
 #define make_migration_entry(page, write) swp_entry(0, 0)
@@ -148,6 +149,8 @@ static inline int is_migration_entry(swp_entry_t swp)
 static inline void make_migration_entry_read(swp_entry_t *entryp) { }
 static inline void migration_entry_wait(struct mm_struct *mm, pmd_t *pmd,
 					 unsigned long address) { }
+static inline void migration_entry_wait_huge(struct mm_struct *mm,
+					pte_t *pte) { }
 static inline int is_write_migration_entry(swp_entry_t entry)
 {
 	return 0;
diff --git a/include/linux/syslog.h b/include/linux/syslog.h
index 3891139..98a3153 100644
--- a/include/linux/syslog.h
+++ b/include/linux/syslog.h
@@ -44,8 +44,8 @@
 /* Return size of the log buffer */
 #define SYSLOG_ACTION_SIZE_BUFFER   10
 
-#define SYSLOG_FROM_CALL 0
-#define SYSLOG_FROM_FILE 1
+#define SYSLOG_FROM_READER           0
+#define SYSLOG_FROM_PROC             1
 
 int do_syslog(int type, char __user *buf, int count, bool from_file);
 
diff --git a/include/linux/usb/serial.h b/include/linux/usb/serial.h
index 0b61f01..f0950dc 100644
--- a/include/linux/usb/serial.h
+++ b/include/linux/usb/serial.h
@@ -267,6 +267,8 @@ struct usb_serial_driver {
 			struct usb_serial_port *port, struct ktermios *old);
 	void (*break_ctl)(struct tty_struct *tty, int break_state);
 	int  (*chars_in_buffer)(struct tty_struct *tty);
+	void (*wait_until_sent)(struct tty_struct *tty, long timeout);
+	bool (*tx_empty)(struct usb_serial_port *port);
 	void (*throttle)(struct tty_struct *tty);
 	void (*unthrottle)(struct tty_struct *tty);
 	int  (*tiocmget)(struct tty_struct *tty);
@@ -329,6 +331,8 @@ extern void usb_serial_generic_close(struct usb_serial_port *port);
 extern int usb_serial_generic_resume(struct usb_serial *serial);
 extern int usb_serial_generic_write_room(struct tty_struct *tty);
 extern int usb_serial_generic_chars_in_buffer(struct tty_struct *tty);
+extern void usb_serial_generic_wait_until_sent(struct tty_struct *tty,
+								long timeout);
 extern void usb_serial_generic_read_bulk_callback(struct urb *urb);
 extern void usb_serial_generic_write_bulk_callback(struct urb *urb);
 extern void usb_serial_generic_throttle(struct tty_struct *tty);
diff --git a/include/linux/wait.h b/include/linux/wait.h
index 1dee81c..6c6c20e 100644
--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -233,6 +233,8 @@ do {									\
 		if (!ret)						\
 			break;						\
 	}								\
+	if (!ret && (condition))					\
+		ret = 1;						\
 	finish_wait(&wq, &__wait);					\
 } while (0)
 
@@ -249,8 +251,9 @@ do {									\
  * wake_up() has to be called after changing any variable that could
  * change the result of the wait condition.
  *
- * The function returns 0 if the @timeout elapsed, and the remaining
- * jiffies if the condition evaluated to true before the timeout elapsed.
+ * The function returns 0 if the @timeout elapsed, or the remaining
+ * jiffies (at least 1) if the @condition evaluated to %true before
+ * the @timeout elapsed.
  */
 #define wait_event_timeout(wq, condition, timeout)			\
 ({									\
@@ -318,6 +321,8 @@ do {									\
 		ret = -ERESTARTSYS;					\
 		break;							\
 	}								\
+	if (!ret && (condition))					\
+		ret = 1;						\
 	finish_wait(&wq, &__wait);					\
 } while (0)
 
@@ -334,9 +339,10 @@ do {									\
  * wake_up() has to be called after changing any variable that could
  * change the result of the wait condition.
  *
- * The function returns 0 if the @timeout elapsed, -ERESTARTSYS if it
- * was interrupted by a signal, and the remaining jiffies otherwise
- * if the condition evaluated to true before the timeout elapsed.
+ * Returns:
+ * 0 if the @timeout elapsed, -%ERESTARTSYS if it was interrupted by
+ * a signal, or the remaining jiffies (at least 1) if the @condition
+ * evaluated to %true before the @timeout elapsed.
  */
 #define wait_event_interruptible_timeout(wq, condition, timeout)	\
 ({									\
diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index 475b8c0..0f35895 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -1002,6 +1002,7 @@ void hci_sock_dev_event(struct hci_dev *hdev, int event);
 int mgmt_control(struct sock *sk, struct msghdr *msg, size_t len);
 int mgmt_index_added(struct hci_dev *hdev);
 int mgmt_index_removed(struct hci_dev *hdev);
+int mgmt_set_powered_failed(struct hci_dev *hdev, int err);
 int mgmt_powered(struct hci_dev *hdev, u8 powered);
 int mgmt_discoverable(struct hci_dev *hdev, u8 discoverable);
 int mgmt_connectable(struct hci_dev *hdev, u8 connectable);
diff --git a/include/net/bluetooth/mgmt.h b/include/net/bluetooth/mgmt.h
index 4348ee8..bd0fc7d 100644
--- a/include/net/bluetooth/mgmt.h
+++ b/include/net/bluetooth/mgmt.h
@@ -42,6 +42,7 @@
 #define MGMT_STATUS_NOT_POWERED		0x0f
 #define MGMT_STATUS_CANCELLED		0x10
 #define MGMT_STATUS_INVALID_INDEX	0x11
+#define MGMT_STATUS_RFKILLED		0x12
 
 struct mgmt_hdr {
 	__le16	opcode;
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 5be8937..71f7662 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -613,6 +613,7 @@ struct se_session {
 	struct list_head	sess_list;
 	struct list_head	sess_acl_list;
 	struct list_head	sess_cmd_list;
+	struct list_head	sess_wait_list;
 	spinlock_t		sess_cmd_lock;
 	struct kref		sess_kref;
 };
diff --git a/include/xen/interface/io/netif.h b/include/xen/interface/io/netif.h
index cb94668..d4635cd 100644
--- a/include/xen/interface/io/netif.h
+++ b/include/xen/interface/io/netif.h
@@ -13,6 +13,24 @@
 #include "../grant_table.h"
 
 /*
+ * Older implementation of Xen network frontend / backend has an
+ * implicit dependency on the MAX_SKB_FRAGS as the maximum number of
+ * ring slots a skb can use. Netfront / netback may not work as
+ * expected when frontend and backend have different MAX_SKB_FRAGS.
+ *
+ * A better approach is to add mechanism for netfront / netback to
+ * negotiate this value. However we cannot fix all possible
+ * frontends, so we need to define a value which states the minimum
+ * slots backend must support.
+ *
+ * The minimum value derives from older Linux kernel's MAX_SKB_FRAGS
+ * (18), which is proved to work with most frontends. Any new backend
+ * which doesn't negotiate with frontend should expect frontend to
+ * send a valid packet using slots up to this value.
+ */
+#define XEN_NETIF_NR_SLOTS_MIN 18
+
+/*
  * Notifications after enqueuing any type of message should be conditional on
  * the appropriate req_event or rsp_event field in the shared ring.
  * If the client sends notification for rx requests then it should specify
@@ -47,6 +65,7 @@
 #define _XEN_NETTXF_extra_info		(3)
 #define  XEN_NETTXF_extra_info		(1U<<_XEN_NETTXF_extra_info)
 
+#define XEN_NETIF_MAX_TX_SIZE 0xFFFF
 struct xen_netif_tx_request {
     grant_ref_t gref;      /* Reference to buffer page */
     uint16_t offset;       /* Offset within buffer page */
diff --git a/kernel/cpu.c b/kernel/cpu.c
index 14d3258..2e181cb 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -129,6 +129,27 @@ static void cpu_hotplug_done(void)
 	mutex_unlock(&cpu_hotplug.lock);
 }
 
+/*
+ * Wait for currently running CPU hotplug operations to complete (if any) and
+ * disable future CPU hotplug (from sysfs). The 'cpu_add_remove_lock' protects
+ * the 'cpu_hotplug_disabled' flag. The same lock is also acquired by the
+ * hotplug path before performing hotplug operations. So acquiring that lock
+ * guarantees mutual exclusion from any currently running hotplug operations.
+ */
+void cpu_hotplug_disable(void)
+{
+	cpu_maps_update_begin();
+	cpu_hotplug_disabled = 1;
+	cpu_maps_update_done();
+}
+
+void cpu_hotplug_enable(void)
+{
+	cpu_maps_update_begin();
+	cpu_hotplug_disabled = 0;
+	cpu_maps_update_done();
+}
+
 #else /* #if CONFIG_HOTPLUG_CPU */
 static void cpu_hotplug_begin(void) {}
 static void cpu_hotplug_done(void) {}
@@ -534,36 +555,6 @@ static int __init alloc_frozen_cpus(void)
 core_initcall(alloc_frozen_cpus);
 
 /*
- * Prevent regular CPU hotplug from racing with the freezer, by disabling CPU
- * hotplug when tasks are about to be frozen. Also, don't allow the freezer
- * to continue until any currently running CPU hotplug operation gets
- * completed.
- * To modify the 'cpu_hotplug_disabled' flag, we need to acquire the
- * 'cpu_add_remove_lock'. And this same lock is also taken by the regular
- * CPU hotplug path and released only after it is complete. Thus, we
- * (and hence the freezer) will block here until any currently running CPU
- * hotplug operation gets completed.
- */
-void cpu_hotplug_disable_before_freeze(void)
-{
-	cpu_maps_update_begin();
-	cpu_hotplug_disabled = 1;
-	cpu_maps_update_done();
-}
-
-
-/*
- * When tasks have been thawed, re-enable regular CPU hotplug (which had been
- * disabled while beginning to freeze tasks).
- */
-void cpu_hotplug_enable_after_thaw(void)
-{
-	cpu_maps_update_begin();
-	cpu_hotplug_disabled = 0;
-	cpu_maps_update_done();
-}
-
-/*
  * When callbacks for CPU hotplug notifications are being executed, we must
  * ensure that the state of the system with respect to the tasks being frozen
  * or not, as reported by the notification, remains unchanged *throughout the
@@ -582,12 +573,12 @@ cpu_hotplug_pm_callback(struct notifier_block *nb,
 
 	case PM_SUSPEND_PREPARE:
 	case PM_HIBERNATION_PREPARE:
-		cpu_hotplug_disable_before_freeze();
+		cpu_hotplug_disable();
 		break;
 
 	case PM_POST_SUSPEND:
 	case PM_POST_HIBERNATION:
-		cpu_hotplug_enable_after_thaw();
+		cpu_hotplug_enable();
 		break;
 
 	default:
diff --git a/kernel/printk.c b/kernel/printk.c
index 66a2ea3..2d3fc0e 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -362,6 +362,53 @@ static void log_store(int facility, int level,
 	log_next_seq++;
 }
 
+#ifdef CONFIG_SECURITY_DMESG_RESTRICT
+int dmesg_restrict = 1;
+#else
+int dmesg_restrict;
+#endif
+
+static int syslog_action_restricted(int type)
+{
+	if (dmesg_restrict)
+		return 1;
+	/*
+	 * Unless restricted, we allow "read all" and "get buffer size"
+	 * for everybody.
+	 */
+	return type != SYSLOG_ACTION_READ_ALL &&
+	       type != SYSLOG_ACTION_SIZE_BUFFER;
+}
+
+static int check_syslog_permissions(int type, bool from_file)
+{
+	/*
+	 * If this is from /proc/kmsg and we've already opened it, then we've
+	 * already done the capabilities checks at open time.
+	 */
+	if (from_file && type != SYSLOG_ACTION_OPEN)
+		return 0;
+
+	if (syslog_action_restricted(type)) {
+		if (capable(CAP_SYSLOG))
+			return 0;
+		/*
+		 * For historical reasons, accept CAP_SYS_ADMIN too, with
+		 * a warning.
+		 */
+		if (capable(CAP_SYS_ADMIN)) {
+			pr_warn_once("%s (%d): Attempt to access syslog with "
+				     "CAP_SYS_ADMIN but no CAP_SYSLOG "
+				     "(deprecated).\n",
+				 current->comm, task_pid_nr(current));
+			return 0;
+		}
+		return -EPERM;
+	}
+	return security_syslog(type);
+}
+
+
 /* /dev/kmsg - userspace message inject/listen interface */
 struct devkmsg_user {
 	u64 seq;
@@ -618,7 +665,8 @@ static int devkmsg_open(struct inode *inode, struct file *file)
 	if ((file->f_flags & O_ACCMODE) == O_WRONLY)
 		return 0;
 
-	err = security_syslog(SYSLOG_ACTION_READ_ALL);
+	err = check_syslog_permissions(SYSLOG_ACTION_READ_ALL,
+				       SYSLOG_FROM_READER);
 	if (err)
 		return err;
 
@@ -794,45 +842,6 @@ static inline void boot_delay_msec(void)
 }
 #endif
 
-#ifdef CONFIG_SECURITY_DMESG_RESTRICT
-int dmesg_restrict = 1;
-#else
-int dmesg_restrict;
-#endif
-
-static int syslog_action_restricted(int type)
-{
-	if (dmesg_restrict)
-		return 1;
-	/* Unless restricted, we allow "read all" and "get buffer size" for everybody */
-	return type != SYSLOG_ACTION_READ_ALL && type != SYSLOG_ACTION_SIZE_BUFFER;
-}
-
-static int check_syslog_permissions(int type, bool from_file)
-{
-	/*
-	 * If this is from /proc/kmsg and we've already opened it, then we've
-	 * already done the capabilities checks at open time.
-	 */
-	if (from_file && type != SYSLOG_ACTION_OPEN)
-		return 0;
-
-	if (syslog_action_restricted(type)) {
-		if (capable(CAP_SYSLOG))
-			return 0;
-		/* For historical reasons, accept CAP_SYS_ADMIN too, with a warning */
-		if (capable(CAP_SYS_ADMIN)) {
-			printk_once(KERN_WARNING "%s (%d): "
-				 "Attempt to access syslog with CAP_SYS_ADMIN "
-				 "but no CAP_SYSLOG (deprecated).\n",
-				 current->comm, task_pid_nr(current));
-			return 0;
-		}
-		return -EPERM;
-	}
-	return 0;
-}
-
 #if defined(CONFIG_PRINTK_TIME)
 static bool printk_time = 1;
 #else
@@ -1229,7 +1238,7 @@ out:
 
 SYSCALL_DEFINE3(syslog, int, type, char __user *, buf, int, len)
 {
-	return do_syslog(type, buf, len, SYSLOG_FROM_CALL);
+	return do_syslog(type, buf, len, SYSLOG_FROM_READER);
 }
 
 static bool __read_mostly ignore_loglevel;
diff --git a/kernel/sys.c b/kernel/sys.c
index 61c086b7..7ce45e1 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -356,6 +356,29 @@ int unregister_reboot_notifier(struct notifier_block *nb)
 }
 EXPORT_SYMBOL(unregister_reboot_notifier);
 
+/* Add backwards compatibility for stable trees. */
+#ifndef PF_NO_SETAFFINITY
+#define PF_NO_SETAFFINITY		PF_THREAD_BOUND
+#endif
+
+static void migrate_to_reboot_cpu(void)
+{
+	/* The boot cpu is always logical cpu 0 */
+	int cpu = 0;
+
+	cpu_hotplug_disable();
+
+	/* Make certain the cpu I'm about to reboot on is online */
+	if (!cpu_online(cpu))
+		cpu = cpumask_first(cpu_online_mask);
+
+	/* Prevent races with other tasks migrating this task */
+	current->flags |= PF_NO_SETAFFINITY;
+
+	/* Make certain I only run on the appropriate processor */
+	set_cpus_allowed_ptr(current, cpumask_of(cpu));
+}
+
 /**
  *	kernel_restart - reboot the system
  *	@cmd: pointer to buffer containing command to execute for restart
@@ -367,7 +390,7 @@ EXPORT_SYMBOL(unregister_reboot_notifier);
 void kernel_restart(char *cmd)
 {
 	kernel_restart_prepare(cmd);
-	disable_nonboot_cpus();
+	migrate_to_reboot_cpu();
 	syscore_shutdown();
 	if (!cmd)
 		printk(KERN_EMERG "Restarting system.\n");
@@ -394,7 +417,7 @@ static void kernel_shutdown_prepare(enum system_states state)
 void kernel_halt(void)
 {
 	kernel_shutdown_prepare(SYSTEM_HALT);
-	disable_nonboot_cpus();
+	migrate_to_reboot_cpu();
 	syscore_shutdown();
 	printk(KERN_EMERG "System halted.\n");
 	kmsg_dump(KMSG_DUMP_HALT);
@@ -413,7 +436,7 @@ void kernel_power_off(void)
 	kernel_shutdown_prepare(SYSTEM_POWER_OFF);
 	if (pm_power_off_prepare)
 		pm_power_off_prepare();
-	disable_nonboot_cpus();
+	migrate_to_reboot_cpu();
 	syscore_shutdown();
 	printk(KERN_EMERG "Power down.\n");
 	kmsg_dump(KMSG_DUMP_POWEROFF);
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 6fbd63a..a3e9083 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -672,7 +672,15 @@ __update_max_tr(struct trace_array *tr, struct task_struct *tsk, int cpu)
 
 	memcpy(max_data->comm, tsk->comm, TASK_COMM_LEN);
 	max_data->pid = tsk->pid;
-	max_data->uid = task_uid(tsk);
+	/*
+	 * If tsk == current, then use current_uid(), as that does not use
+	 * RCU. The irq tracer can be called out of RCU scope.
+	 */
+	if (tsk == current)
+		max_data->uid = current_uid();
+	else
+		max_data->uid = task_uid(tsk);
+
 	max_data->nice = tsk->static_prio - 20 - MAX_RT_PRIO;
 	max_data->policy = tsk->policy;
 	max_data->rt_priority = tsk->rt_priority;
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 141dbb6..29301d4 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1954,7 +1954,12 @@ static void collapse_huge_page(struct mm_struct *mm,
 		pte_unmap(pte);
 		spin_lock(&mm->page_table_lock);
 		BUG_ON(!pmd_none(*pmd));
-		set_pmd_at(mm, address, pmd, _pmd);
+		/*
+		 * We can only use set_pmd_at when establishing
+		 * hugepmds and never for establishing regular pmds that
+		 * points to regular pagetables. Use pmd_populate for that
+		 */
+		pmd_populate(mm, pmd, pmd_pgtable(_pmd));
 		spin_unlock(&mm->page_table_lock);
 		anon_vma_unlock(vma->anon_vma);
 		goto out;
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 0bf06e9..7e5ff99 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2825,7 +2825,7 @@ int hugetlb_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 	if (ptep) {
 		entry = huge_ptep_get(ptep);
 		if (unlikely(is_hugetlb_entry_migration(entry))) {
-			migration_entry_wait(mm, (pmd_t *)ptep, address);
+			migration_entry_wait_huge(mm, ptep);
 			return 0;
 		} else if (unlikely(is_hugetlb_entry_hwpoisoned(entry)))
 			return VM_FAULT_HWPOISON_LARGE |
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index a6e2f81..a2c673a 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3030,8 +3030,6 @@ __mem_cgroup_uncharge_common(struct page *page, enum charge_type ctype,
 	if (mem_cgroup_disabled())
 		return NULL;
 
-	VM_BUG_ON(PageSwapCache(page));
-
 	if (PageTransHuge(page)) {
 		nr_pages <<= compound_order(page);
 		VM_BUG_ON(!PageTransHuge(page));
@@ -3127,6 +3125,18 @@ void mem_cgroup_uncharge_page(struct page *page)
 	if (page_mapped(page))
 		return;
 	VM_BUG_ON(page->mapping && !PageAnon(page));
+	/*
+	 * If the page is in swap cache, uncharge should be deferred
+	 * to the swap path, which also properly accounts swap usage
+	 * and handles memcg lifetime.
+	 *
+	 * Note that this check is not stable and reclaim may add the
+	 * page to swap cache at any time after this.  However, if the
+	 * page is not in swap cache by the time page->mapcount hits
+	 * 0, there won't be any page table references to the swap
+	 * slot, and reclaim will free it and not actually write the
+	 * page to disk.
+	 */
 	if (PageSwapCache(page))
 		return;
 	__mem_cgroup_uncharge_common(page, MEM_CGROUP_CHARGE_TYPE_ANON, false);
diff --git a/mm/migrate.c b/mm/migrate.c
index 77ed2d7..733aa9f 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -146,7 +146,7 @@ static int remove_migration_pte(struct page *new, struct vm_area_struct *vma,
 	if (PageHuge(new))
 		pte = pte_mkhuge(pte);
 #endif
-	flush_cache_page(vma, addr, pte_pfn(pte));
+	flush_dcache_page(new);
 	set_pte_at(mm, addr, ptep, pte);
 
 	if (PageHuge(new)) {
@@ -181,15 +181,14 @@ static void remove_migration_ptes(struct page *old, struct page *new)
  * get to the page and wait until migration is finished.
  * When we return from this function the fault will be retried.
  */
-void migration_entry_wait(struct mm_struct *mm, pmd_t *pmd,
-				unsigned long address)
+static void __migration_entry_wait(struct mm_struct *mm, pte_t *ptep,
+				spinlock_t *ptl)
 {
-	pte_t *ptep, pte;
-	spinlock_t *ptl;
+	pte_t pte;
 	swp_entry_t entry;
 	struct page *page;
 
-	ptep = pte_offset_map_lock(mm, pmd, address, &ptl);
+	spin_lock(ptl);
 	pte = *ptep;
 	if (!is_swap_pte(pte))
 		goto out;
@@ -217,6 +216,20 @@ out:
 	pte_unmap_unlock(ptep, ptl);
 }
 
+void migration_entry_wait(struct mm_struct *mm, pmd_t *pmd,
+				unsigned long address)
+{
+	spinlock_t *ptl = pte_lockptr(mm, pmd);
+	pte_t *ptep = pte_offset_map(pmd, address);
+	__migration_entry_wait(mm, ptep, ptl);
+}
+
+void migration_entry_wait_huge(struct mm_struct *mm, pte_t *pte)
+{
+	spinlock_t *ptl = &(mm)->page_table_lock;
+	__migration_entry_wait(mm, pte, ptl);
+}
+
 #ifdef CONFIG_BLOCK
 /* Returns true if all buffers are successfully locked */
 static bool buffer_migrate_lock_buffers(struct buffer_head *head,
diff --git a/mm/pagewalk.c b/mm/pagewalk.c
index 6c118d0..449cad6 100644
--- a/mm/pagewalk.c
+++ b/mm/pagewalk.c
@@ -127,28 +127,7 @@ static int walk_hugetlb_range(struct vm_area_struct *vma,
 	return 0;
 }
 
-static struct vm_area_struct* hugetlb_vma(unsigned long addr, struct mm_walk *walk)
-{
-	struct vm_area_struct *vma;
-
-	/* We don't need vma lookup at all. */
-	if (!walk->hugetlb_entry)
-		return NULL;
-
-	VM_BUG_ON(!rwsem_is_locked(&walk->mm->mmap_sem));
-	vma = find_vma(walk->mm, addr);
-	if (vma && vma->vm_start <= addr && is_vm_hugetlb_page(vma))
-		return vma;
-
-	return NULL;
-}
-
 #else /* CONFIG_HUGETLB_PAGE */
-static struct vm_area_struct* hugetlb_vma(unsigned long addr, struct mm_walk *walk)
-{
-	return NULL;
-}
-
 static int walk_hugetlb_range(struct vm_area_struct *vma,
 			      unsigned long addr, unsigned long end,
 			      struct mm_walk *walk)
@@ -198,30 +177,53 @@ int walk_page_range(unsigned long addr, unsigned long end,
 	if (!walk->mm)
 		return -EINVAL;
 
+	VM_BUG_ON(!rwsem_is_locked(&walk->mm->mmap_sem));
+
 	pgd = pgd_offset(walk->mm, addr);
 	do {
-		struct vm_area_struct *vma;
+		struct vm_area_struct *vma = NULL;
 
 		next = pgd_addr_end(addr, end);
 
 		/*
-		 * handle hugetlb vma individually because pagetable walk for
-		 * the hugetlb page is dependent on the architecture and
-		 * we can't handled it in the same manner as non-huge pages.
+		 * This function was not intended to be vma based.
+		 * But there are vma special cases to be handled:
+		 * - hugetlb vma's
+		 * - VM_PFNMAP vma's
 		 */
-		vma = hugetlb_vma(addr, walk);
+		vma = find_vma(walk->mm, addr);
 		if (vma) {
-			if (vma->vm_end < next)
+			/*
+			 * There are no page structures backing a VM_PFNMAP
+			 * range, so do not allow split_huge_page_pmd().
+			 */
+			if ((vma->vm_start <= addr) &&
+			    (vma->vm_flags & VM_PFNMAP)) {
 				next = vma->vm_end;
+				pgd = pgd_offset(walk->mm, next);
+				continue;
+			}
 			/*
-			 * Hugepage is very tightly coupled with vma, so
-			 * walk through hugetlb entries within a given vma.
+			 * Handle hugetlb vma individually because pagetable
+			 * walk for the hugetlb page is dependent on the
+			 * architecture and we can't handled it in the same
+			 * manner as non-huge pages.
 			 */
-			err = walk_hugetlb_range(vma, addr, next, walk);
-			if (err)
-				break;
-			pgd = pgd_offset(walk->mm, next);
-			continue;
+			if (walk->hugetlb_entry && (vma->vm_start <= addr) &&
+			    is_vm_hugetlb_page(vma)) {
+				if (vma->vm_end < next)
+					next = vma->vm_end;
+				/*
+				 * Hugepage is very tightly coupled with vma,
+				 * so walk through hugetlb entries within a
+				 * given vma.
+				 */
+				err = walk_hugetlb_range(vma, addr, next, walk);
+				if (err)
+					break;
+				pgd = pgd_offset(walk->mm, next);
+				continue;
+			}
 		}
 
 		if (pgd_none_or_clear_bad(pgd)) {
diff --git a/mm/swap_state.c b/mm/swap_state.c
index 0cb36fb..f854fbd 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -314,8 +314,24 @@ struct page *read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
 		 * Swap entry may have been freed since our caller observed it.
 		 */
 		err = swapcache_prepare(entry);
-		if (err == -EEXIST) {	/* seems racy */
+		if (err == -EEXIST) {
 			radix_tree_preload_end();
+			/*
+			 * We might race against get_swap_page() and stumble
+			 * across a SWAP_HAS_CACHE swap_map entry whose page
+			 * has not been brought into the swapcache yet, while
+			 * the other end is scheduled away waiting on discard
+			 * I/O completion at scan_swap_map().
+			 *
+			 * In order to avoid turning this transitory state
+			 * into a permanent loop around this -EEXIST case
+			 * if !CONFIG_PREEMPT and the I/O completion happens
+			 * to be waiting on the CPU waitqueue where we are now
+			 * busy looping, we just conditionally invoke the
+			 * scheduler here, if there are some more important
+			 * tasks to run.
+			 */
+			cond_resched();
 			continue;
 		}
 		if (err) {		/* swp entry is obsolete ? */
diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 0b997c8..d1636e4 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -1076,11 +1076,15 @@ static const struct rfkill_ops hci_rfkill_ops = {
 static void hci_power_on(struct work_struct *work)
 {
 	struct hci_dev *hdev = container_of(work, struct hci_dev, power_on);
+	int err;
 
 	BT_DBG("%s", hdev->name);
 
-	if (hci_dev_open(hdev->id) < 0)
+	err = hci_dev_open(hdev->id);
+	if (err < 0) {
+		mgmt_set_powered_failed(hdev, err);
 		return;
+	}
 
 	if (test_bit(HCI_AUTO_OFF, &hdev->dev_flags))
 		schedule_delayed_work(&hdev->power_off, HCI_AUTO_OFF_TIMEOUT);
diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index 534250a..0fef923 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -2908,6 +2908,27 @@ int mgmt_powered(struct hci_dev *hdev, u8 powered)
 	return err;
 }
 
+int mgmt_set_powered_failed(struct hci_dev *hdev, int err)
+{
+	struct pending_cmd *cmd;
+	u8 status;
+
+	cmd = mgmt_pending_find(MGMT_OP_SET_POWERED, hdev);
+	if (!cmd)
+		return -ENOENT;
+
+	if (err == -ERFKILL)
+		status = MGMT_STATUS_RFKILLED;
+	else
+		status = MGMT_STATUS_FAILED;
+
+	err = cmd_status(cmd->sk, hdev->id, MGMT_OP_SET_POWERED, status);
+
+	mgmt_pending_remove(cmd);
+
+	return err;
+}
+
 int mgmt_discoverable(struct hci_dev *hdev, u8 discoverable)
 {
 	struct cmd_lookup match = { NULL, hdev };
diff --git a/net/ceph/auth.c b/net/ceph/auth.c
index b4bf4ac..6b923bc 100644
--- a/net/ceph/auth.c
+++ b/net/ceph/auth.c
@@ -47,6 +47,7 @@ struct ceph_auth_client *ceph_auth_init(const char *name, const struct ceph_cryp
 	if (!ac)
 		goto out;
 
+	mutex_init(&ac->mutex);
 	ac->negotiating = true;
 	if (name)
 		ac->name = name;
@@ -73,10 +74,12 @@ void ceph_auth_destroy(struct ceph_auth_client *ac)
  */
 void ceph_auth_reset(struct ceph_auth_client *ac)
 {
+	mutex_lock(&ac->mutex);
 	dout("auth_reset %p\n", ac);
 	if (ac->ops && !ac->negotiating)
 		ac->ops->reset(ac);
 	ac->negotiating = true;
+	mutex_unlock(&ac->mutex);
 }
 
 int ceph_entity_name_encode(const char *name, void **p, void *end)
@@ -102,6 +105,7 @@ int ceph_auth_build_hello(struct ceph_auth_client *ac, void *buf, size_t len)
 	int i, num;
 	int ret;
 
+	mutex_lock(&ac->mutex);
 	dout("auth_build_hello\n");
 	monhdr->have_version = 0;
 	monhdr->session_mon = cpu_to_le16(-1);
@@ -122,15 +126,19 @@ int ceph_auth_build_hello(struct ceph_auth_client *ac, void *buf, size_t len)
 
 	ret = ceph_entity_name_encode(ac->name, &p, end);
 	if (ret < 0)
-		return ret;
+		goto out;
 	ceph_decode_need(&p, end, sizeof(u64), bad);
 	ceph_encode_64(&p, ac->global_id);
 
 	ceph_encode_32(&lenp, p - lenp - sizeof(u32));
-	return p - buf;
+	ret = p - buf;
+out:
+	mutex_unlock(&ac->mutex);
+	return ret;
 
 bad:
-	return -ERANGE;
+	ret = -ERANGE;
+	goto out;
 }
 
 static int ceph_build_auth_request(struct ceph_auth_client *ac,
@@ -151,11 +159,13 @@ static int ceph_build_auth_request(struct ceph_auth_client *ac,
 	if (ret < 0) {
 		pr_err("error %d building auth method %s request\n", ret,
 		       ac->ops->name);
-		return ret;
+		goto out;
 	}
 	dout(" built request %d bytes\n", ret);
 	ceph_encode_32(&p, ret);
-	return p + ret - msg_buf;
+	ret = p + ret - msg_buf;
+out:
+	return ret;
 }
 
 /*
@@ -176,6 +186,7 @@ int ceph_handle_auth_reply(struct ceph_auth_client *ac,
 	int result_msg_len;
 	int ret = -EINVAL;
 
+	mutex_lock(&ac->mutex);
 	dout("handle_auth_reply %p %p\n", p, end);
 	ceph_decode_need(&p, end, sizeof(u32) * 3 + sizeof(u64), bad);
 	protocol = ceph_decode_32(&p);
@@ -227,33 +238,103 @@ int ceph_handle_auth_reply(struct ceph_auth_client *ac,
 
 	ret = ac->ops->handle_reply(ac, result, payload, payload_end);
 	if (ret == -EAGAIN) {
-		return ceph_build_auth_request(ac, reply_buf, reply_len);
+		ret = ceph_build_auth_request(ac, reply_buf, reply_len);
 	} else if (ret) {
 		pr_err("auth method '%s' error %d\n", ac->ops->name, ret);
-		return ret;
 	}
-	return 0;
 
-bad:
-	pr_err("failed to decode auth msg\n");
 out:
+	mutex_unlock(&ac->mutex);
 	return ret;
+
+bad:
+	pr_err("failed to decode auth msg\n");
+	ret = -EINVAL;
+	goto out;
 }
 
 int ceph_build_auth(struct ceph_auth_client *ac,
 		    void *msg_buf, size_t msg_len)
 {
+	int ret = 0;
+
+	mutex_lock(&ac->mutex);
 	if (!ac->protocol)
-		return ceph_auth_build_hello(ac, msg_buf, msg_len);
-	BUG_ON(!ac->ops);
-	if (ac->ops->should_authenticate(ac))
-		return ceph_build_auth_request(ac, msg_buf, msg_len);
-	return 0;
+		ret = ceph_auth_build_hello(ac, msg_buf, msg_len);
+	else if (ac->ops->should_authenticate(ac))
+		ret = ceph_build_auth_request(ac, msg_buf, msg_len);
+	mutex_unlock(&ac->mutex);
+	return ret;
 }
 
 int ceph_auth_is_authenticated(struct ceph_auth_client *ac)
 {
-	if (!ac->ops)
-		return 0;
-	return ac->ops->is_authenticated(ac);
+	int ret = 0;
+
+	mutex_lock(&ac->mutex);
+	if (ac->ops)
+		ret = ac->ops->is_authenticated(ac);
+	mutex_unlock(&ac->mutex);
+	return ret;
+}
+EXPORT_SYMBOL(ceph_auth_is_authenticated);
+
+int ceph_auth_create_authorizer(struct ceph_auth_client *ac,
+				int peer_type,
+				struct ceph_auth_handshake *auth)
+{
+	int ret = 0;
+
+	mutex_lock(&ac->mutex);
+	if (ac->ops && ac->ops->create_authorizer)
+		ret = ac->ops->create_authorizer(ac, peer_type, auth);
+	mutex_unlock(&ac->mutex);
+	return ret;
+}
+EXPORT_SYMBOL(ceph_auth_create_authorizer);
+
+void ceph_auth_destroy_authorizer(struct ceph_auth_client *ac,
+				  struct ceph_authorizer *a)
+{
+	mutex_lock(&ac->mutex);
+	if (ac->ops && ac->ops->destroy_authorizer)
+		ac->ops->destroy_authorizer(ac, a);
+	mutex_unlock(&ac->mutex);
+}
+EXPORT_SYMBOL(ceph_auth_destroy_authorizer);
+
+int ceph_auth_update_authorizer(struct ceph_auth_client *ac,
+				int peer_type,
+				struct ceph_auth_handshake *a)
+{
+	int ret = 0;
+
+	mutex_lock(&ac->mutex);
+	if (ac->ops && ac->ops->update_authorizer)
+		ret = ac->ops->update_authorizer(ac, peer_type, a);
+	mutex_unlock(&ac->mutex);
+	return ret;
+}
+EXPORT_SYMBOL(ceph_auth_update_authorizer);
+
+int ceph_auth_verify_authorizer_reply(struct ceph_auth_client *ac,
+				      struct ceph_authorizer *a, size_t len)
+{
+	int ret = 0;
+
+	mutex_lock(&ac->mutex);
+	if (ac->ops && ac->ops->verify_authorizer_reply)
+		ret = ac->ops->verify_authorizer_reply(ac, a, len);
+	mutex_unlock(&ac->mutex);
+	return ret;
+}
+EXPORT_SYMBOL(ceph_auth_verify_authorizer_reply);
+
+void ceph_auth_invalidate_authorizer(struct ceph_auth_client *ac, int peer_type)
+{
+	mutex_lock(&ac->mutex);
+	if (ac->ops && ac->ops->invalidate_authorizer)
+		ac->ops->invalidate_authorizer(ac, peer_type);
+	mutex_unlock(&ac->mutex);
 }
+EXPORT_SYMBOL(ceph_auth_invalidate_authorizer);
diff --git a/net/ceph/auth_x.c b/net/ceph/auth_x.c
index a16bf14..96238ba 100644
--- a/net/ceph/auth_x.c
+++ b/net/ceph/auth_x.c
@@ -298,6 +298,7 @@ static int ceph_x_build_authorizer(struct ceph_auth_client *ac,
 			return -ENOMEM;
 	}
 	au->service = th->service;
+	au->secret_id = th->secret_id;
 
 	msg_a = au->buf->vec.iov_base;
 	msg_a->struct_v = 1;
@@ -555,6 +556,26 @@ static int ceph_x_create_authorizer(
 	return 0;
 }
 
+static int ceph_x_update_authorizer(
+	struct ceph_auth_client *ac, int peer_type,
+	struct ceph_auth_handshake *auth)
+{
+	struct ceph_x_authorizer *au;
+	struct ceph_x_ticket_handler *th;
+
+	th = get_ticket_handler(ac, peer_type);
+	if (IS_ERR(th))
+		return PTR_ERR(th);
+
+	au = (struct ceph_x_authorizer *)auth->authorizer;
+	if (au->secret_id < th->secret_id) {
+		dout("ceph_x_update_authorizer service %u secret %llu < %llu\n",
+		     au->service, au->secret_id, th->secret_id);
+		return ceph_x_build_authorizer(ac, th, au);
+	}
+	return 0;
+}
+
 static int ceph_x_verify_authorizer_reply(struct ceph_auth_client *ac,
 					  struct ceph_authorizer *a, size_t len)
 {
@@ -630,7 +651,7 @@ static void ceph_x_invalidate_authorizer(struct ceph_auth_client *ac,
 
 	th = get_ticket_handler(ac, peer_type);
 	if (!IS_ERR(th))
-		remove_ticket_handler(ac, th);
+		memset(&th->validity, 0, sizeof(th->validity));
 }
 
 
@@ -641,6 +662,7 @@ static const struct ceph_auth_client_ops ceph_x_ops = {
 	.build_request = ceph_x_build_request,
 	.handle_reply = ceph_x_handle_reply,
 	.create_authorizer = ceph_x_create_authorizer,
+	.update_authorizer = ceph_x_update_authorizer,
 	.verify_authorizer_reply = ceph_x_verify_authorizer_reply,
 	.destroy_authorizer = ceph_x_destroy_authorizer,
 	.invalidate_authorizer = ceph_x_invalidate_authorizer,
diff --git a/net/ceph/auth_x.h b/net/ceph/auth_x.h
index f459e93..c5a058d 100644
--- a/net/ceph/auth_x.h
+++ b/net/ceph/auth_x.h
@@ -29,6 +29,7 @@ struct ceph_x_authorizer {
 	struct ceph_buffer *buf;
 	unsigned int service;
 	u64 nonce;
+	u64 secret_id;
 	char reply_buf[128];  /* big enough for encrypted blob */
 };
 
diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index 3ef1759..c245379 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -1552,7 +1552,6 @@ static int process_connect(struct ceph_connection *con)
 			con->error_msg = "connect authorization failure";
 			return -1;
 		}
-		con->auth_retry = 1;
 		con_out_kvec_reset(con);
 		ret = prepare_write_connect(con);
 		if (ret < 0)
@@ -1637,7 +1636,7 @@ static int process_connect(struct ceph_connection *con)
 
 		BUG_ON(con->state != CON_STATE_NEGOTIATING);
 		con->state = CON_STATE_OPEN;
-
+		con->auth_retry = 0;    /* we authenticated; clear flag */
 		con->peer_global_seq = le32_to_cpu(con->in_reply.global_seq);
 		con->connect_seq++;
 		con->peer_features = server_feat;
diff --git a/net/ceph/mon_client.c b/net/ceph/mon_client.c
index 900ea0f..8a9235d 100644
--- a/net/ceph/mon_client.c
+++ b/net/ceph/mon_client.c
@@ -737,7 +737,7 @@ static void delayed_work(struct work_struct *work)
 
 		__validate_auth(monc);
 
-		if (monc->auth->ops->is_authenticated(monc->auth))
+		if (ceph_auth_is_authenticated(monc->auth))
 			__send_subscribe(monc);
 	}
 	__schedule_delayed(monc);
@@ -893,8 +893,7 @@ static void handle_auth_reply(struct ceph_mon_client *monc,
 
 	mutex_lock(&monc->mutex);
 	had_debugfs_info = have_debugfs_info(monc);
-	if (monc->auth->ops)
-		was_auth = monc->auth->ops->is_authenticated(monc->auth);
+	was_auth = ceph_auth_is_authenticated(monc->auth);
 	monc->pending_auth = 0;
 	ret = ceph_handle_auth_reply(monc->auth, msg->front.iov_base,
 				     msg->front.iov_len,
@@ -905,7 +904,7 @@ static void handle_auth_reply(struct ceph_mon_client *monc,
 		wake_up_all(&monc->client->auth_wq);
 	} else if (ret > 0) {
 		__send_prepared_auth_request(monc, ret);
-	} else if (!was_auth && monc->auth->ops->is_authenticated(monc->auth)) {
+	} else if (!was_auth && ceph_auth_is_authenticated(monc->auth)) {
 		dout("authenticated, starting session\n");
 
 		monc->client->msgr.inst.name.type = CEPH_ENTITY_TYPE_CLIENT;
diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index f7b56e2..c9b179d 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -675,8 +675,7 @@ static void put_osd(struct ceph_osd *osd)
 	if (atomic_dec_and_test(&osd->o_ref) && osd->o_auth.authorizer) {
 		struct ceph_auth_client *ac = osd->o_osdc->client->monc.auth;
 
-		if (ac->ops && ac->ops->destroy_authorizer)
-			ac->ops->destroy_authorizer(ac, osd->o_auth.authorizer);
+		ceph_auth_destroy_authorizer(ac, osd->o_auth.authorizer);
 		kfree(osd);
 	}
 }
@@ -2154,13 +2153,17 @@ static struct ceph_auth_handshake *get_authorizer(struct ceph_connection *con,
 	struct ceph_auth_handshake *auth = &o->o_auth;
 
 	if (force_new && auth->authorizer) {
-		if (ac->ops && ac->ops->destroy_authorizer)
-			ac->ops->destroy_authorizer(ac, auth->authorizer);
+		ceph_auth_destroy_authorizer(ac, auth->authorizer);
 		auth->authorizer = NULL;
 	}
-	if (!auth->authorizer && ac->ops && ac->ops->create_authorizer) {
-		int ret = ac->ops->create_authorizer(ac, CEPH_ENTITY_TYPE_OSD,
-							auth);
+	if (!auth->authorizer) {
+		int ret = ceph_auth_create_authorizer(ac, CEPH_ENTITY_TYPE_OSD,
+						      auth);
+		if (ret)
+			return ERR_PTR(ret);
+	} else {
+		int ret = ceph_auth_update_authorizer(ac, CEPH_ENTITY_TYPE_OSD,
+						     auth);
 		if (ret)
 			return ERR_PTR(ret);
 	}
@@ -2176,11 +2179,7 @@ static int verify_authorizer_reply(struct ceph_connection *con, int len)
 	struct ceph_osd_client *osdc = o->o_osdc;
 	struct ceph_auth_client *ac = osdc->client->monc.auth;
 
-	/*
-	 * XXX If ac->ops or ac->ops->verify_authorizer_reply is null,
-	 * XXX which do we do:  succeed or fail?
-	 */
-	return ac->ops->verify_authorizer_reply(ac, o->o_auth.authorizer, len);
+	return ceph_auth_verify_authorizer_reply(ac, o->o_auth.authorizer, len);
 }
 
 static int invalidate_authorizer(struct ceph_connection *con)
@@ -2189,9 +2188,7 @@ static int invalidate_authorizer(struct ceph_connection *con)
 	struct ceph_osd_client *osdc = o->o_osdc;
 	struct ceph_auth_client *ac = osdc->client->monc.auth;
 
-	if (ac->ops && ac->ops->invalidate_authorizer)
-		ac->ops->invalidate_authorizer(ac, CEPH_ENTITY_TYPE_OSD);
-
+	ceph_auth_invalidate_authorizer(ac, CEPH_ENTITY_TYPE_OSD);
 	return ceph_monc_validate_auth(&osdc->client->monc);
 }
 
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index c93d395..9217a94 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1521,6 +1521,15 @@ void ieee80211_remove_interfaces(struct ieee80211_local *local)
 
 	ASSERT_RTNL();
 
+	/*
+	 * Close all AP_VLAN interfaces first, as otherwise they
+	 * might be closed while the AP interface they belong to
+	 * is closed, causing unregister_netdevice_many() to crash.
+	 */
+	list_for_each_entry(sdata, &local->interfaces, list)
+		if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
+			dev_close(sdata->dev);
+
 	mutex_lock(&local->iflist_mtx);
 	list_for_each_entry_safe(sdata, tmp, &local->interfaces, list) {
 		list_del(&sdata->list);
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 37fe5ce..bd11c1c 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2813,6 +2813,9 @@ static int prepare_for_handlers(struct ieee80211_rx_data *rx,
 			 * and location updates. Note that mac80211
 			 * itself never looks at these frames.
 			 */
+			if (!multicast &&
+			    !ether_addr_equal(sdata->vif.addr, hdr->addr1))
+				return 0;
 			if (ieee80211_is_public_action(hdr, skb->len))
 				return 1;
 			if (!ieee80211_is_beacon(hdr->frame_control))
diff --git a/net/sunrpc/sched.c b/net/sunrpc/sched.c
index cd09810..0e09708 100644
--- a/net/sunrpc/sched.c
+++ b/net/sunrpc/sched.c
@@ -305,11 +305,17 @@ EXPORT_SYMBOL_GPL(__rpc_wait_for_completion_task);
  * Note: If the task is ASYNC, and is being made runnable after sitting on an
  * rpc_wait_queue, this must be called with the queue spinlock held to protect
  * the wait queue operation.
+ * Note the ordering of rpc_test_and_set_running() and rpc_clear_queued(),
+ * which is needed to ensure that __rpc_execute() doesn't loop (due to the
+ * lockless RPC_IS_QUEUED() test) before we've had a chance to test
+ * the RPC_TASK_RUNNING flag.
  */
 static void rpc_make_runnable(struct rpc_task *task)
 {
+	bool need_wakeup = !rpc_test_and_set_running(task);
+
 	rpc_clear_queued(task);
-	if (rpc_test_and_set_running(task))
+	if (!need_wakeup)
 		return;
 	if (RPC_IS_ASYNC(task)) {
 		INIT_WORK(&task->u.tk_work, rpc_async_schedule);
diff --git a/net/wireless/core.c b/net/wireless/core.c
index 5797032..a10901b 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -572,17 +572,21 @@ int wiphy_register(struct wiphy *wiphy)
 	 * cfg80211_mutex lock
 	 */
 	res = rfkill_register(rdev->rfkill);
-	if (res)
-		goto out_rm_dev;
+	if (res) {
+		device_del(&rdev->wiphy.dev);
+
+		mutex_lock(&cfg80211_mutex);
+		debugfs_remove_recursive(rdev->wiphy.debugfsdir);
+		list_del_rcu(&rdev->list);
+		wiphy_regulatory_deregister(wiphy);
+		mutex_unlock(&cfg80211_mutex);
+		return res;
+	}
 
 	rtnl_lock();
 	rdev->wiphy.registered = true;
 	rtnl_unlock();
 	return 0;
-
-out_rm_dev:
-	device_del(&rdev->wiphy.dev);
-	return res;
 }
 EXPORT_SYMBOL(wiphy_register);
 
diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index 6f39cb8..1015221 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -222,6 +222,9 @@ void cfg80211_conn_work(struct work_struct *work)
 	mutex_lock(&rdev->devlist_mtx);
 
 	list_for_each_entry(wdev, &rdev->wdev_list, list) {
+		if (!wdev->netdev)
+			continue;
+
 		wdev_lock(wdev);
 		if (!netif_running(wdev->netdev)) {
 			wdev_unlock(wdev);
diff --git a/sound/soc/codecs/cs42l52.c b/sound/soc/codecs/cs42l52.c
index d8cfcc7..d34aa42 100644
--- a/sound/soc/codecs/cs42l52.c
+++ b/sound/soc/codecs/cs42l52.c
@@ -87,7 +87,7 @@ static const struct reg_default cs42l52_reg_defaults[] = {
 	{ CS42L52_BEEP_VOL, 0x00 },	/* r1D Beep Volume off Time */
 	{ CS42L52_BEEP_TONE_CTL, 0x00 },	/* r1E Beep Tone Cfg. */
 	{ CS42L52_TONE_CTL, 0x00 },	/* r1F Tone Ctl */
-	{ CS42L52_MASTERA_VOL, 0x88 },	/* r20 Master A Volume */
+	{ CS42L52_MASTERA_VOL, 0x00 },	/* r20 Master A Volume */
 	{ CS42L52_MASTERB_VOL, 0x00 },	/* r21 Master B Volume */
 	{ CS42L52_HPA_VOL, 0x00 },	/* r22 Headphone A Volume */
 	{ CS42L52_HPB_VOL, 0x00 },	/* r23 Headphone B Volume */
diff --git a/sound/usb/mixer.c b/sound/usb/mixer.c
index 900bf42..9a9da0a 100644
--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -842,6 +842,7 @@ static void volume_control_quirks(struct usb_mixer_elem_info *cval,
 	case USB_ID(0x046d, 0x0808):
 	case USB_ID(0x046d, 0x0809):
 	case USB_ID(0x046d, 0x081d): /* HD Webcam c510 */
+	case USB_ID(0x046d, 0x0825): /* HD Webcam c270 */
 	case USB_ID(0x046d, 0x0991):
 	/* Most audio usb devices lie about volume resolution.
 	 * Most Logitech webcams have res = 384.
diff --git a/sound/usb/quirks-table.h b/sound/usb/quirks-table.h
index d73ac9b..5b9381f 100644
--- a/sound/usb/quirks-table.h
+++ b/sound/usb/quirks-table.h
@@ -157,7 +157,13 @@
 	.bInterfaceSubClass = USB_SUBCLASS_AUDIOCONTROL
 },
 {
-	USB_DEVICE(0x046d, 0x0990),
+	.match_flags = USB_DEVICE_ID_MATCH_DEVICE |
+		       USB_DEVICE_ID_MATCH_INT_CLASS |
+		       USB_DEVICE_ID_MATCH_INT_SUBCLASS,
+	.idVendor = 0x046d,
+	.idProduct = 0x0990,
+	.bInterfaceClass = USB_CLASS_AUDIO,
+	.bInterfaceSubClass = USB_SUBCLASS_AUDIOCONTROL,
 	.driver_info = (unsigned long) & (const struct snd_usb_audio_quirk) {
 		.vendor_name = "Logitech, Inc.",
 		.product_name = "QuickCam Pro 9000",
@@ -1622,7 +1628,11 @@ YAMAHA_DEVICE(0x7010, "UB99"),
 	USB_DEVICE_VENDOR_SPEC(0x0582, 0x0108),
 	.driver_info = (unsigned long) & (const struct snd_usb_audio_quirk) {
 		.ifnum = 0,
-		.type = QUIRK_MIDI_STANDARD_INTERFACE
+		.type = QUIRK_MIDI_FIXED_ENDPOINT,
+		.data = & (const struct snd_usb_midi_endpoint_info) {
+			.out_cables = 0x0007,
+			.in_cables  = 0x0007
+		}
 	}
 },
 {
diff --git a/tools/perf/scripts/python/net_dropmonitor.py b/tools/perf/scripts/python/net_dropmonitor.py
index a4ffc95..4c11605 100755
--- a/tools/perf/scripts/python/net_dropmonitor.py
+++ b/tools/perf/scripts/python/net_dropmonitor.py
@@ -40,9 +40,9 @@ def get_kallsyms_table():
 
 def get_sym(sloc):
 	loc = int(sloc)
-	for i in kallsyms:
-		if (i['loc'] >= loc):
-			return (i['name'], i['loc']-loc)
+	for i in kallsyms[::-1]:
+		if loc >= i['loc']:
+			return (i['name'], loc - i['loc'])
 	return (None, 0)
 
 def print_drop_table():
@@ -64,7 +64,7 @@ def trace_end():
 
 # called from perf, when it finds a correspoinding event
 def skb__kfree_skb(name, context, cpu, sec, nsec, pid, comm,
-			skbaddr, protocol, location):
+		   skbaddr, location, protocol):
 	slocation = str(location)
 	try:
 		drop_log[slocation] = drop_log[slocation] + 1


