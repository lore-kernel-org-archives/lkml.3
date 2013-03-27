Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755409Ab3C0KrO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 06:47:14 -0400
Received: from cpsmtpb-ews10.kpnxchange.com ([213.75.39.15]:53902 "EHLO
	cpsmtpb-ews10.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754851Ab3C0KrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 06:47:10 -0400
Message-ID: <1364381223.1345.18.camel@x61.thuisdomein>
Subject: [PATCH] powerpc: remove PReP
From: Paul Bolle <pebolle@tiscali.nl>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Rob Landley <rob@landley.net>,
        Adam Belay <abelay@mit.edu>, Bjorn Helgaas <bhelgaas@google.com>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Michael Ellerman <michael@ellerman.id.au>, linuxppc-dev@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 27 Mar 2013 11:47:03 +0100
In-Reply-To: <20130322042159.GC26908@concordia>
References: <1363864206.1390.117.camel@x61.thuisdomein>
	 <20130322042159.GC26908@concordia>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Mar 2013 10:47:03.0980 (UTC) FILETIME=[6B2DF6C0:01CE2AD8]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PPC_PREP is marked as BROKEN since v2.6.15. Remove all PReP specific
code now.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) Suggested by Michael. 

1) Sent as one patch. powerpc is the biggest chunk (if one includes the
doc changes). Is it easier if I split this into a number maintainer
specific patches? Ie, split into: powerpc, doc, pnp and fb.

2) None of this is tested. None! Since I'm not actually involved in
powerpc in any way, not everyone might consider me the first choice to
do this cleanup.

3) I removed two files in documentation that are almost entirely PReP
specific. The remaining lines looked uninteresting.

4) I grepped thoroughly for second order effects. I also grepped for
remaining references to PReP. This patch has all things I thought that
could be dropped. Perhaps doing
    git grep -n PReP | grep -v -i -e rewritten -e dougan

might still reveal, to those familiar with PReP, a few places of
outdated stuff. 

 Documentation/powerpc/00-INDEX          |  4 --
 Documentation/powerpc/sound.txt         | 81 ---------------------------------
 Documentation/powerpc/zImage_layout.txt | 47 -------------------
 arch/powerpc/Kconfig                    |  8 ++--
 arch/powerpc/include/asm/dma.h          |  5 --
 arch/powerpc/include/asm/io.h           |  4 --
 arch/powerpc/include/asm/processor.h    |  9 +---
 arch/powerpc/kernel/setup-common.c      |  6 ---
 arch/powerpc/platforms/Kconfig          |  3 +-
 arch/powerpc/platforms/prep/Kconfig     | 23 ----------
 drivers/pnp/pnpbios/core.c              |  9 +---
 drivers/video/cirrusfb.c                | 62 +++++--------------------
 12 files changed, 19 insertions(+), 242 deletions(-)
 delete mode 100644 Documentation/powerpc/sound.txt
 delete mode 100644 Documentation/powerpc/zImage_layout.txt
 delete mode 100644 arch/powerpc/platforms/prep/Kconfig

diff --git a/Documentation/powerpc/00-INDEX b/Documentation/powerpc/00-INDEX
index 5620fb5..dd9e928 100644
--- a/Documentation/powerpc/00-INDEX
+++ b/Documentation/powerpc/00-INDEX
@@ -14,10 +14,6 @@ hvcs.txt
 	- IBM "Hypervisor Virtual Console Server" Installation Guide
 mpc52xx.txt
 	- Linux 2.6.x on MPC52xx family
-sound.txt
-	- info on sound support under Linux/PPC
-zImage_layout.txt
-	- info on the kernel images for Linux/PPC
 qe_firmware.txt
 	- describes the layout of firmware binaries for the Freescale QUICC
 	  Engine and the code that parses and uploads the microcode therein.
diff --git a/Documentation/powerpc/sound.txt b/Documentation/powerpc/sound.txt
deleted file mode 100644
index df23d95..0000000
--- a/Documentation/powerpc/sound.txt
+++ /dev/null
@@ -1,81 +0,0 @@
-            Information about PowerPC Sound support
-=====================================================================
-
-Please mail me (Cort Dougan, cort@fsmlabs.com) if you have questions,
-comments or corrections.
-
-Last Change: 6.16.99
-
-This just covers sound on the PReP and CHRP systems for now and later
-will contain information on the PowerMac's.
-
-Sound on PReP has been tested and is working with the PowerStack and IBM
-Power Series onboard sound systems which are based on the cs4231(2) chip.
-The sound options when doing the make config are a bit different from
-the default, though.
-
-The I/O base, irq and dma lines that you enter during the make config
-are ignored and are set when booting according to the machine type.
-This is so that one binary can be used for Motorola and IBM machines
-which use different values and isn't allowed by the driver, so things
-are hacked together in such a way as to allow this information to be
-set automatically on boot.
-
-1. Motorola PowerStack PReP machines
-
-  Enable support for "Crystal CS4232 based (PnP) cards" and for the
-  Microsoft Sound System.  The MSS isn't used, but some of the routines
-  that the CS4232 driver uses are in it.
-
-  Although the options you set are ignored and determined automatically
-  on boot these are included for information only:
-
-  (830) CS4232 audio I/O base 530, 604, E80 or F40
-  (10) CS4232 audio IRQ 5, 7, 9, 11, 12 or 15
-  (6) CS4232 audio DMA 0, 1 or 3
-  (7) CS4232 second (duplex) DMA 0, 1 or 3
-
-  This will allow simultaneous record and playback, as 2 different dma
-  channels are used.
-
-  The sound will be all left channel and very low volume since the
-  auxiliary input isn't muted by default.  I had the changes necessary
-  for this in the kernel but the sound driver maintainer didn't want
-  to include them since it wasn't common in other machines.  To fix this
-  you need to mute it using a mixer utility of some sort (if you find one
-  please let me know) or by patching the driver yourself and recompiling.
-
-  There is a problem on the PowerStack 2's (PowerStack Pro's) using a
-  different irq/drq than the kernel expects.  Unfortunately, I don't know
-  which irq/drq it is so if anyone knows please email me.
-
-  Midi is not supported since the cs4232 driver doesn't support midi yet.
-
-2. IBM PowerPersonal PReP machines
-
-  I've only tested sound on the Power Personal Series of IBM workstations
-  so if you try it on others please let me know the result.  I'm especially
-  interested in the 43p's sound system, which I know nothing about.
-
-  Enable support for "Crystal CS4232 based (PnP) cards" and for the
-  Microsoft Sound System.  The MSS isn't used, but some of the routines
-  that the CS4232 driver uses are in it.
-
-  Although the options you set are ignored and determined automatically
-  on boot these are included for information only:
-
-  (530) CS4232 audio I/O base 530, 604, E80 or F40
-  (5) CS4232 audio IRQ 5, 7, 9, 11, 12 or 15
-  (1) CS4232 audio DMA 0, 1 or 3
-  (7) CS4232 second (duplex) DMA 0, 1 or 3
-  (330) CS4232 MIDI I/O base 330, 370, 3B0 or 3F0
-  (9) CS4232 MIDI IRQ 5, 7, 9, 11, 12 or 15
-
-  This setup does _NOT_ allow for recording yet.
-
-  Midi is not supported since the cs4232 driver doesn't support midi yet.
-
-2. IBM CHRP
-
-  I have only tested this on the 43P-150.  Build the kernel with the cs4232
-  set as a module and load the module with irq=9 dma=1 dma2=2 io=0x550
diff --git a/Documentation/powerpc/zImage_layout.txt b/Documentation/powerpc/zImage_layout.txt
deleted file mode 100644
index 048e015..0000000
--- a/Documentation/powerpc/zImage_layout.txt
+++ /dev/null
@@ -1,47 +0,0 @@
-          Information about the Linux/PPC kernel images
-=====================================================================
-
-Please mail me (Cort Dougan, cort@fsmlabs.com) if you have questions,
-comments or corrections.
-
-This document is meant to answer several questions I've had about how
-the PReP system boots and how Linux/PPC interacts with that mechanism.
-It would be nice if we could have information on how other architectures
-boot here as well.  If you have anything to contribute, please
-let me know.
-
-
-1. PReP boot file
-
-  This is the file necessary to boot PReP systems from floppy or
-  hard drive.  The firmware reads the PReP partition table entry
-  and will load the image accordingly.
-
-  To boot the zImage, copy it onto a floppy with dd if=zImage of=/dev/fd0h1440
-  or onto a PReP hard drive partition with dd if=zImage of=/dev/sda4
-  assuming you've created a PReP partition (type 0x41) with fdisk on
-  /dev/sda4.
-
-  The layout of the image format is:
-
-  0x0     +------------+
-          |            | PReP partition table entry
-          |            |
-  0x400   +------------+
-          |            | Bootstrap program code + data
-          |            |
-          |            |
-          +------------+
-          |            | compressed kernel, elf header removed
-          +------------+
-          |            | initrd (if loaded)
-          +------------+
-          |            | Elf section table for bootstrap program
-          +------------+
-
-
-2. MBX boot file
-
-  The MBX boards can load an elf image, and relocate it to the
-  proper location in memory - it copies the image to the location it was
-  linked at.
diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index ea5bb04..bc0a44f 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -647,14 +647,14 @@ menu "Bus options"
 
 config ISA
 	bool "Support for ISA-bus hardware"
-	depends on PPC_PREP || PPC_CHRP
+	depends on PPC_CHRP
 	select PPC_I8259
 	help
 	  Find out whether you have ISA slots on your motherboard.  ISA is the
 	  name of a bus system, i.e. the way the CPU talks to the other stuff
 	  inside your box.  If you have an Apple machine, say N here; if you
-	  have an IBM RS/6000 or pSeries machine or a PReP machine, say Y.  If
-	  you have an embedded board, consult your board documentation.
+	  have an IBM RS/6000 or pSeries machine, say Y.  If you have an
+	  embedded board, consult your board documentation.
 
 config ZONE_DMA
 	bool
@@ -969,7 +969,7 @@ config TASK_SIZE_BOOL
 
 config TASK_SIZE
 	hex "Size of user task space" if TASK_SIZE_BOOL
-	default "0x80000000" if PPC_PREP || PPC_8xx
+	default "0x80000000" if PPC_8xx
 	default "0xc0000000"
 
 config CONSISTENT_SIZE_BOOL
diff --git a/arch/powerpc/include/asm/dma.h b/arch/powerpc/include/asm/dma.h
index f6813e9..a5c6d83 100644
--- a/arch/powerpc/include/asm/dma.h
+++ b/arch/powerpc/include/asm/dma.h
@@ -16,10 +16,6 @@
  *
  * None of this really applies for Power Macintoshes.  There is
  * basically just enough here to get kernel/dma.c to compile.
- *
- * There may be some comments or restrictions made here which are
- * not valid for the PReP platform.  Take what you read
- * with a grain of salt.
  */
 
 #include <asm/io.h>
@@ -57,7 +53,6 @@
  *  - page registers for 5-7 don't use data bit 0, represent 128K pages
  *  - page registers for 0-3 use bit 0, represent 64K pages
  *
- * On PReP, DMA transfers are limited to the lower 16MB of _physical_ memory.
  * On CHRP, the W83C553F (and VLSI Tollgate?) support full 32 bit addressing.
  * Note that addresses loaded into registers must be _physical_ addresses,
  * not logical addresses (which may differ if paging is active).
diff --git a/arch/powerpc/include/asm/io.h b/arch/powerpc/include/asm/io.h
index f94ef42..dd15e5e 100644
--- a/arch/powerpc/include/asm/io.h
+++ b/arch/powerpc/include/asm/io.h
@@ -15,10 +15,6 @@
 extern int check_legacy_ioport(unsigned long base_port);
 #define I8042_DATA_REG	0x60
 #define FDC_BASE	0x3f0
-/* only relevant for PReP */
-#define _PIDXR		0x279
-#define _PNPWRP		0xa79
-#define PNPBIOS_BASE	0xf000
 
 #if defined(CONFIG_PPC64) && defined(CONFIG_PCI)
 extern struct pci_dev *isa_bridge_pcidev;
diff --git a/arch/powerpc/include/asm/processor.h b/arch/powerpc/include/asm/processor.h
index 7ff9eaa..0a4cc5d 100644
--- a/arch/powerpc/include/asm/processor.h
+++ b/arch/powerpc/include/asm/processor.h
@@ -40,7 +40,7 @@
  * -- BenH.
  */
 
-/* PREP sub-platform types see residual.h for these */
+/* PREP sub-platform types. Unused */
 #define _PREP_Motorola	0x01	/* motorola prep */
 #define _PREP_Firm	0x02	/* firmworks prep */
 #define _PREP_IBM	0x00	/* ibm prep */
@@ -56,13 +56,6 @@
 
 extern int _chrp_type;
 
-#ifdef CONFIG_PPC_PREP
-
-/* what kind of prep workstation we are */
-extern int _prep_type;
-
-#endif /* CONFIG_PPC_PREP */
-
 #endif /* defined(__KERNEL__) && defined(CONFIG_PPC32) */
 
 /*
diff --git a/arch/powerpc/kernel/setup-common.c b/arch/powerpc/kernel/setup-common.c
index bdc499c..63d051f 100644
--- a/arch/powerpc/kernel/setup-common.c
+++ b/arch/powerpc/kernel/setup-common.c
@@ -621,12 +621,6 @@ int check_legacy_ioport(unsigned long base_port)
 	case FDC_BASE: /* FDC1 */
 		np = of_find_node_by_type(NULL, "fdc");
 		break;
-#ifdef CONFIG_PPC_PREP
-	case _PIDXR:
-	case _PNPWRP:
-	case PNPBIOS_BASE:
-		/* implement me */
-#endif
 	default:
 		/* ipmi is supposed to fail here */
 		break;
diff --git a/arch/powerpc/platforms/Kconfig b/arch/powerpc/platforms/Kconfig
index 52de8bc..9089ae7 100644
--- a/arch/powerpc/platforms/Kconfig
+++ b/arch/powerpc/platforms/Kconfig
@@ -6,7 +6,6 @@ source "arch/powerpc/platforms/chrp/Kconfig"
 source "arch/powerpc/platforms/512x/Kconfig"
 source "arch/powerpc/platforms/52xx/Kconfig"
 source "arch/powerpc/platforms/powermac/Kconfig"
-source "arch/powerpc/platforms/prep/Kconfig"
 source "arch/powerpc/platforms/maple/Kconfig"
 source "arch/powerpc/platforms/pasemi/Kconfig"
 source "arch/powerpc/platforms/ps3/Kconfig"
@@ -233,7 +232,7 @@ endmenu
 
 config PPC601_SYNC_FIX
 	bool "Workarounds for PPC601 bugs"
-	depends on 6xx && (PPC_PREP || PPC_PMAC)
+	depends on 6xx && PPC_PMAC
 	help
 	  Some versions of the PPC601 (the first PowerPC chip) have bugs which
 	  mean that extra synchronization instructions are required near
diff --git a/arch/powerpc/platforms/prep/Kconfig b/arch/powerpc/platforms/prep/Kconfig
deleted file mode 100644
index 1547f66..0000000
--- a/arch/powerpc/platforms/prep/Kconfig
+++ /dev/null
@@ -1,23 +0,0 @@
-config PPC_PREP
-	bool "PowerPC Reference Platform (PReP) based machines"
-	depends on 6xx && BROKEN
-	select HAVE_PCSPKR_PLATFORM
-	select MPIC
-	select PPC_I8259
-	select PPC_INDIRECT_PCI
-	select PPC_UDBG_16550
-	select PPC_NATIVE
-	default n
-
-config PREP_RESIDUAL
-	bool "Support for PReP Residual Data"
-	depends on PPC_PREP
-	help
-	  Some PReP systems have residual data passed to the kernel by the
-	  firmware.  This allows detection of memory size, devices present and
-	  other useful pieces of information.  Sometimes this information is
-	  not present or incorrect, in which case it could lead to the machine 
-	  behaving incorrectly.  If this happens, either disable PREP_RESIDUAL
-	  or pass the 'noresidual' option to the kernel.
-
-	  If you are running a PReP system, say Y here, otherwise say N.
diff --git a/drivers/pnp/pnpbios/core.c b/drivers/pnp/pnpbios/core.c
index 5d66e55..9b86a01 100644
--- a/drivers/pnp/pnpbios/core.c
+++ b/drivers/pnp/pnpbios/core.c
@@ -513,10 +513,6 @@ static int __init pnpbios_init(void)
 {
 	int ret;
 
-#if defined(CONFIG_PPC)
-	if (check_legacy_ioport(PNPBIOS_BASE))
-		return -ENODEV;
-#endif
 	if (pnpbios_disabled || dmi_check_system(pnpbios_dmi_table) ||
 	    paravirt_enabled()) {
 		printk(KERN_INFO "PnPBIOS: Disabled\n");
@@ -570,10 +566,7 @@ fs_initcall(pnpbios_init);
 static int __init pnpbios_thread_init(void)
 {
 	struct task_struct *task;
-#if defined(CONFIG_PPC)
-	if (check_legacy_ioport(PNPBIOS_BASE))
-		return 0;
-#endif
+
 	if (pnpbios_disabled)
 		return 0;
 
diff --git a/drivers/video/cirrusfb.c b/drivers/video/cirrusfb.c
index c3dbbe6..97db3ba 100644
--- a/drivers/video/cirrusfb.c
+++ b/drivers/video/cirrusfb.c
@@ -53,12 +53,6 @@
 #ifdef CONFIG_AMIGA
 #include <asm/amigahw.h>
 #endif
-#ifdef CONFIG_PPC_PREP
-#include <asm/machdep.h>
-#define isPReP machine_is(prep)
-#else
-#define isPReP 0
-#endif
 
 #include <video/vga.h>
 #include <video/cirrus.h>
@@ -557,30 +551,18 @@ static int cirrusfb_check_var(struct fb_var_screeninfo *var,
 		break;
 
 	case 16:
-		if (isPReP) {
-			var->red.offset = 2;
-			var->green.offset = -3;
-			var->blue.offset = 8;
-		} else {
-			var->red.offset = 11;
-			var->green.offset = 5;
-			var->blue.offset = 0;
-		}
+		var->red.offset = 11;
+		var->green.offset = 5;
+		var->blue.offset = 0;
 		var->red.length = 5;
 		var->green.length = 6;
 		var->blue.length = 5;
 		break;
 
 	case 24:
-		if (isPReP) {
-			var->red.offset = 0;
-			var->green.offset = 8;
-			var->blue.offset = 16;
-		} else {
-			var->red.offset = 16;
-			var->green.offset = 8;
-			var->blue.offset = 0;
-		}
+		var->red.offset = 16;
+		var->green.offset = 8;
+		var->blue.offset = 0;
 		var->red.length = 8;
 		var->green.length = 8;
 		var->blue.length = 8;
@@ -1874,17 +1856,6 @@ static void cirrusfb_imageblit(struct fb_info *info,
 	}
 }
 
-#ifdef CONFIG_PPC_PREP
-#define PREP_VIDEO_BASE ((volatile unsigned long) 0xC0000000)
-#define PREP_IO_BASE    ((volatile unsigned char *) 0x80000000)
-static void get_prep_addrs(unsigned long *display, unsigned long *registers)
-{
-	*display = PREP_VIDEO_BASE;
-	*registers = (unsigned long) PREP_IO_BASE;
-}
-
-#endif				/* CONFIG_PPC_PREP */
-
 #ifdef CONFIG_PCI
 static int release_io_ports;
 
@@ -2139,21 +2110,12 @@ static int cirrusfb_pci_register(struct pci_dev *pdev,
 	dev_dbg(info->device, " base address 1 is 0x%Lx\n",
 		(unsigned long long)pdev->resource[1].start);
 
-	if (isPReP) {
-		pci_write_config_dword(pdev, PCI_BASE_ADDRESS_0, 0x00000000);
-#ifdef CONFIG_PPC_PREP
-		get_prep_addrs(&board_addr, &info->fix.mmio_start);
-#endif
-	/* PReP dies if we ioremap the IO registers, but it works w/out... */
-		cinfo->regbase = (char __iomem *) info->fix.mmio_start;
-	} else {
-		dev_dbg(info->device,
-			"Attempt to get PCI info for Cirrus Graphics Card\n");
-		get_pci_addrs(pdev, &board_addr, &info->fix.mmio_start);
-		/* FIXME: this forces VGA.  alternatives? */
-		cinfo->regbase = NULL;
-		cinfo->laguna_mmio = ioremap(info->fix.mmio_start, 0x1000);
-	}
+	dev_dbg(info->device,
+		"Attempt to get PCI info for Cirrus Graphics Card\n");
+	get_pci_addrs(pdev, &board_addr, &info->fix.mmio_start);
+	/* FIXME: this forces VGA.  alternatives? */
+	cinfo->regbase = NULL;
+	cinfo->laguna_mmio = ioremap(info->fix.mmio_start, 0x1000);
 
 	dev_dbg(info->device, "Board address: 0x%lx, register address: 0x%lx\n",
 		board_addr, info->fix.mmio_start);
-- 
1.7.11.7

