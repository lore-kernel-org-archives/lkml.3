Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756614Ab3B0Wsh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 17:48:37 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58682 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672Ab3B0Wsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 17:48:35 -0500
Date: Wed, 27 Feb 2013 14:46:28 -0800
Message-Id: <201302272246.r1RMkShg014105@terminus.zytor.com>
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] Additional x86 fixes for v3.9-rc1
Cc: <stable@vger.kernel.org>, Darren Hart <dvhart@linux.intel.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Matt Fleming <matt.fleming@intel.com>,
        Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>,
        Thomas Gleixner <tglx@linutronix.de>, Thomas Renninger <trenn@suse.de>,
        Yinghai Lu <yinghai@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 27 Feb 2013 14:46:34 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Additional x86 fixes.  Three of these patches are pure documentation,
two are pretty trivial; the remaining one fixes boot problems on
some non-BIOS machines.

The following changes since commit a8aed3e0752b4beb2e37cbed6df69faae88268da:

  x86/mm/pageattr: Prevent PSE and GLOABL leftovers to confuse pmd/pte_present and pmd_huge (2013-02-24 13:01:45 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-urgent-for-linus

for you to fetch changes up to 7c10093692ed2e6f318387d96b829320aa0ca64c:

  x86: Make sure we can boot in the case the BDA contains pure garbage (2013-02-27 13:38:57 -0800)

----------------------------------------------------------------
H. Peter Anvin (1):
      x86: Make sure we can boot in the case the BDA contains pure garbage

Konrad Rzeszutek Wilk (3):
      doc, xen: Mention 'earlyprintk=xen' in the documentation.
      doc, kernel-parameters: Document 'console=hvc<n>'
      x86, doc: Fix incorrect comment about 64-bit code segment descriptors

Matt Fleming (1):
      x86, efi: Mark disable_runtime as __initdata

Thomas Renninger (1):
      ACPI: Overriding ACPI tables via initrd only works with an initrd and on X86

 Documentation/kernel-parameters.txt |  5 ++++
 arch/x86/kernel/head.c              | 53 ++++++++++++++++++++++++-------------
 arch/x86/kernel/head_64.S           |  4 +--
 arch/x86/platform/efi/efi.c         |  2 +-
 drivers/acpi/Kconfig                |  3 ++-
 5 files changed, 44 insertions(+), 23 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 6c72381..986614d 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -564,6 +564,8 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			UART at the specified I/O port or MMIO address,
 			switching to the matching ttyS device later.  The
 			options are the same as for ttyS, above.
+		hvc<n>	Use the hypervisor console device <n>. This is for
+			both Xen and PowerPC hypervisors.
 
                 If the device connected to the port is not a TTY but a braille
                 device, prepend "brl," before the device type, for instance
@@ -754,6 +756,7 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 
 	earlyprintk=	[X86,SH,BLACKFIN]
 			earlyprintk=vga
+			earlyprintk=xen
 			earlyprintk=serial[,ttySn[,baudrate]]
 			earlyprintk=ttySn[,baudrate]
 			earlyprintk=dbgp[debugController#]
@@ -771,6 +774,8 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			The VGA output is eventually overwritten by the real
 			console.
 
+			The xen output can only be used by Xen PV guests.
+
 	ekgdboc=	[X86,KGDB] Allow early kernel console debugging
 			ekgdboc=kbd
 
diff --git a/arch/x86/kernel/head.c b/arch/x86/kernel/head.c
index 48d9d4e..992f442 100644
--- a/arch/x86/kernel/head.c
+++ b/arch/x86/kernel/head.c
@@ -5,8 +5,6 @@
 #include <asm/setup.h>
 #include <asm/bios_ebda.h>
 
-#define BIOS_LOWMEM_KILOBYTES 0x413
-
 /*
  * The BIOS places the EBDA/XBDA at the top of conventional
  * memory, and usually decreases the reported amount of
@@ -16,17 +14,30 @@
  * chipset: reserve a page before VGA to prevent PCI prefetch
  * into it (errata #56). Usually the page is reserved anyways,
  * unless you have no PS/2 mouse plugged in.
+ *
+ * This functions is deliberately very conservative.  Losing
+ * memory in the bottom megabyte is rarely a problem, as long
+ * as we have enough memory to install the trampoline.  Using
+ * memory that is in use by the BIOS or by some DMA device
+ * the BIOS didn't shut down *is* a big problem.
  */
+
+#define BIOS_LOWMEM_KILOBYTES	0x413
+#define LOWMEM_CAP		0x9f000U	/* Absolute maximum */
+#define INSANE_CUTOFF		0x20000U	/* Less than this = insane */
+
 void __init reserve_ebda_region(void)
 {
 	unsigned int lowmem, ebda_addr;
 
-	/* To determine the position of the EBDA and the */
-	/* end of conventional memory, we need to look at */
-	/* the BIOS data area. In a paravirtual environment */
-	/* that area is absent. We'll just have to assume */
-	/* that the paravirt case can handle memory setup */
-	/* correctly, without our help. */
+	/*
+	 * To determine the position of the EBDA and the
+	 * end of conventional memory, we need to look at
+	 * the BIOS data area. In a paravirtual environment
+	 * that area is absent. We'll just have to assume
+	 * that the paravirt case can handle memory setup
+	 * correctly, without our help.
+	 */
 	if (paravirt_enabled())
 		return;
 
@@ -37,19 +48,23 @@ void __init reserve_ebda_region(void)
 	/* start of EBDA area */
 	ebda_addr = get_bios_ebda();
 
-	/* Fixup: bios puts an EBDA in the top 64K segment */
-	/* of conventional memory, but does not adjust lowmem. */
-	if ((lowmem - ebda_addr) <= 0x10000)
-		lowmem = ebda_addr;
+	/*
+	 * Note: some old Dells seem to need 4k EBDA without
+	 * reporting so, so just consider the memory above 0x9f000
+	 * to be off limits (bugzilla 2990).
+	 */
+
+	/* If the EBDA address is below 128K, assume it is bogus */
+	if (ebda_addr < INSANE_CUTOFF)
+		ebda_addr = LOWMEM_CAP;
 
-	/* Fixup: bios does not report an EBDA at all. */
-	/* Some old Dells seem to need 4k anyhow (bugzilla 2990) */
-	if ((ebda_addr == 0) && (lowmem >= 0x9f000))
-		lowmem = 0x9f000;
+	/* If lowmem is less than 128K, assume it is bogus */
+	if (lowmem < INSANE_CUTOFF)
+		lowmem = LOWMEM_CAP;
 
-	/* Paranoia: should never happen, but... */
-	if ((lowmem == 0) || (lowmem >= 0x100000))
-		lowmem = 0x9f000;
+	/* Use the lower of the lowmem and EBDA markers as the cutoff */
+	lowmem = min(lowmem, ebda_addr);
+	lowmem = min(lowmem, LOWMEM_CAP); /* Absolute cap */
 
 	/* reserve all memory between lowmem and the 1MB mark */
 	memblock_reserve(lowmem, 0x100000 - lowmem);
diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index 980053c..37f5304 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -49,7 +49,7 @@ L3_START_KERNEL = pud_index(__START_KERNEL_map)
 startup_64:
 
 	/*
-	 * At this point the CPU runs in 64bit mode CS.L = 1 CS.D = 1,
+	 * At this point the CPU runs in 64bit mode CS.L = 1 CS.D = 0,
 	 * and someone has loaded an identity mapped page table
 	 * for us.  These identity mapped page tables map all of the
 	 * kernel pages and possibly all of memory.
@@ -146,7 +146,7 @@ ident_complete:
 	jmp secondary_startup_64
 ENTRY(secondary_startup_64)
 	/*
-	 * At this point the CPU runs in 64bit mode CS.L = 1 CS.D = 1,
+	 * At this point the CPU runs in 64bit mode CS.L = 1 CS.D = 0,
 	 * and someone has loaded a mapped page table.
 	 *
 	 * %esi holds a physical pointer to real_mode_data.
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index e2cd38f..ec9f325 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -85,7 +85,7 @@ int efi_enabled(int facility)
 }
 EXPORT_SYMBOL(efi_enabled);
 
-static bool disable_runtime = false;
+static bool __initdata disable_runtime = false;
 static int __init setup_noefi(char *arg)
 {
 	disable_runtime = true;
diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
index 38c5078..f5ae996 100644
--- a/drivers/acpi/Kconfig
+++ b/drivers/acpi/Kconfig
@@ -268,7 +268,8 @@ config ACPI_CUSTOM_DSDT
 	default ACPI_CUSTOM_DSDT_FILE != ""
 
 config ACPI_INITRD_TABLE_OVERRIDE
-	bool "ACPI tables can be passed via uncompressed cpio in initrd"
+	bool "ACPI tables override via initrd"
+	depends on BLK_DEV_INITRD && X86
 	default n
 	help
 	  This option provides functionality to override arbitrary ACPI tables
