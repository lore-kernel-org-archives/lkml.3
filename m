Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759406Ab3D3IFz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 04:05:55 -0400
Received: from mail-bk0-f42.google.com ([209.85.214.42]:50509 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751586Ab3D3IFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 04:05:46 -0400
Date: Tue, 30 Apr 2013 10:05:41 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/debug changes for v3.10
Message-ID: <20130430080541.GA21225@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-debug-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-debug-for-linus

   HEAD: 147ea09119e45caf2e8bf57c9e54cc930ccfeda9 x86, early-printk: Update earlyprintk documentation (and kill x86 copy)

Two small changes: a documentation update and a constification.

 Thanks,

	Ingo

------------------>
Dave Hansen (1):
      x86, early-printk: Update earlyprintk documentation (and kill x86 copy)

Jan Beulich (1):
      x86: Constify a few items


 Documentation/kernel-parameters.txt       | 16 ++++++++++++++--
 Documentation/x86/x86_64/boot-options.txt | 14 --------------
 arch/x86/kernel/amd_nb.c                  |  2 +-
 arch/x86/kernel/cpu/perf_event_knc.c      |  4 ++--
 arch/x86/kernel/cpu/perf_event_p6.c       |  2 +-
 5 files changed, 18 insertions(+), 20 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 4609e81..b5cfd04 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -757,19 +757,31 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			(mmio) or 32-bit (mmio32).
 			The options are the same as for ttyS, above.
 
-	earlyprintk=	[X86,SH,BLACKFIN]
+	earlyprintk=	[X86,SH,BLACKFIN,ARM]
 			earlyprintk=vga
 			earlyprintk=xen
 			earlyprintk=serial[,ttySn[,baudrate]]
+			earlyprintk=serial[,0x...[,baudrate]]
 			earlyprintk=ttySn[,baudrate]
 			earlyprintk=dbgp[debugController#]
 
+			earlyprintk is useful when the kernel crashes before
+			the normal console is initialized. It is not enabled by
+			default because it has some cosmetic problems.
+
 			Append ",keep" to not disable it when the real console
 			takes over.
 
 			Only vga or serial or usb debug port at a time.
 
-			Currently only ttyS0 and ttyS1 are supported.
+			Currently only ttyS0 and ttyS1 may be specified by
+			name.  Other I/O ports may be explicitly specified
+			on some architectures (x86 and arm at least) by
+			replacing ttySn with an I/O port address, like this:
+				earlyprintk=serial,0x1008,115200
+			You can find the port for a given device in
+			/proc/tty/driver/serial:
+				2: uart:ST16650V2 port:00001008 irq:18 ...
 
 			Interaction with the standard serial driver is not
 			very good.
diff --git a/Documentation/x86/x86_64/boot-options.txt b/Documentation/x86/x86_64/boot-options.txt
index e015a83..e9e8ddb 100644
--- a/Documentation/x86/x86_64/boot-options.txt
+++ b/Documentation/x86/x86_64/boot-options.txt
@@ -91,20 +91,6 @@ APICs
 		 apicmaintimer. Useful when your PIT timer is totally
 		 broken.
 
-Early Console
-
-   syntax: earlyprintk=vga
-           earlyprintk=serial[,ttySn[,baudrate]]
-
-   The early console is useful when the kernel crashes before the
-   normal console is initialized. It is not enabled by
-   default because it has some cosmetic problems.
-   Append ,keep to not disable it when the real console takes over.
-   Only vga or serial at a time, not both.
-   Currently only ttyS0 and ttyS1 are supported.
-   Interaction with the standard serial driver is not very good.
-   The VGA output is eventually overwritten by the real console.
-
 Timing
 
   notsc
diff --git a/arch/x86/kernel/amd_nb.c b/arch/x86/kernel/amd_nb.c
index aadf335..3684129 100644
--- a/arch/x86/kernel/amd_nb.c
+++ b/arch/x86/kernel/amd_nb.c
@@ -24,7 +24,7 @@ const struct pci_device_id amd_nb_misc_ids[] = {
 };
 EXPORT_SYMBOL(amd_nb_misc_ids);
 
-static struct pci_device_id amd_nb_link_ids[] = {
+static const struct pci_device_id amd_nb_link_ids[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_15H_NB_F4) },
 	{}
 };
diff --git a/arch/x86/kernel/cpu/perf_event_knc.c b/arch/x86/kernel/cpu/perf_event_knc.c
index 4b7731b..838fa87 100644
--- a/arch/x86/kernel/cpu/perf_event_knc.c
+++ b/arch/x86/kernel/cpu/perf_event_knc.c
@@ -17,7 +17,7 @@ static const u64 knc_perfmon_event_map[] =
   [PERF_COUNT_HW_BRANCH_MISSES]		= 0x002b,
 };
 
-static __initconst u64 knc_hw_cache_event_ids
+static const u64 __initconst knc_hw_cache_event_ids
 				[PERF_COUNT_HW_CACHE_MAX]
 				[PERF_COUNT_HW_CACHE_OP_MAX]
 				[PERF_COUNT_HW_CACHE_RESULT_MAX] =
@@ -284,7 +284,7 @@ static struct attribute *intel_knc_formats_attr[] = {
 	NULL,
 };
 
-static __initconst struct x86_pmu knc_pmu = {
+static const struct x86_pmu knc_pmu __initconst = {
 	.name			= "knc",
 	.handle_irq		= knc_pmu_handle_irq,
 	.disable_all		= knc_pmu_disable_all,
diff --git a/arch/x86/kernel/cpu/perf_event_p6.c b/arch/x86/kernel/cpu/perf_event_p6.c
index 4820c23..b1e2fe1 100644
--- a/arch/x86/kernel/cpu/perf_event_p6.c
+++ b/arch/x86/kernel/cpu/perf_event_p6.c
@@ -19,7 +19,7 @@ static const u64 p6_perfmon_event_map[] =
 
 };
 
-static u64 p6_hw_cache_event_ids
+static const u64 __initconst p6_hw_cache_event_ids
 				[PERF_COUNT_HW_CACHE_MAX]
 				[PERF_COUNT_HW_CACHE_OP_MAX]
 				[PERF_COUNT_HW_CACHE_RESULT_MAX] =
