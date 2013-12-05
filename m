Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756639Ab3LEXh3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 18:37:29 -0500
Received: from mail.skyhub.de ([78.46.96.112]:40272 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756084Ab3LEXhX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 18:37:23 -0500
Date: Fri, 6 Dec 2013 00:37:21 +0100
From: Borislav Petkov <bp@alien8.de>
To: X86 ML <x86@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        Kim Naru <kim.naru@amd.com>, Thomas Renninger <trenn@suse.de>
Subject: [PATCH -v1.1 4/4] x86, microcode: Move to a proper location
Message-ID: <20131205233720.GA4100@pd.tnic>
References: <1386286348-5144-1-git-send-email-bp@alien8.de>
 <1386286348-5144-5-git-send-email-bp@alien8.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1386286348-5144-5-git-send-email-bp@alien8.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>
Subject: [PATCH -v1.1 4/4] x86, microcode: Move to a proper location

We've grown a bunch of microcode loader files all prefixed with
"microcode_". They should be under cpu/ because this is strictly
CPU-related functionality so do that and drop the prefix since they're
in their own directory now which gives that prefix. :)

While at it, drop MICROCODE_INTEL_LIB config item and stash the
functionality under CONFIG_MICROCODE_INTEL as it was its only user.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/Kconfig                                                 | 4 ----
 arch/x86/kernel/Makefile                                         | 9 ---------
 arch/x86/kernel/cpu/Makefile                                     | 1 +
 arch/x86/kernel/cpu/microcode/Makefile                           | 7 +++++++
 arch/x86/kernel/{microcode_amd.c => cpu/microcode/amd.c}         | 0
 .../kernel/{microcode_amd_early.c => cpu/microcode/amd_early.c}  | 0
 arch/x86/kernel/{microcode_core.c => cpu/microcode/core.c}       | 0
 .../{microcode_core_early.c => cpu/microcode/core_early.c}       | 0
 arch/x86/kernel/{microcode_intel.c => cpu/microcode/intel.c}     | 0
 .../{microcode_intel_early.c => cpu/microcode/intel_early.c}     | 0
 .../kernel/{microcode_intel_lib.c => cpu/microcode/intel_lib.c}  | 0
 11 files changed, 8 insertions(+), 13 deletions(-)
 create mode 100644 arch/x86/kernel/cpu/microcode/Makefile
 rename arch/x86/kernel/{microcode_amd.c => cpu/microcode/amd.c} (100%)
 rename arch/x86/kernel/{microcode_amd_early.c => cpu/microcode/amd_early.c} (100%)
 rename arch/x86/kernel/{microcode_core.c => cpu/microcode/core.c} (100%)
 rename arch/x86/kernel/{microcode_core_early.c => cpu/microcode/core_early.c} (100%)
 rename arch/x86/kernel/{microcode_intel.c => cpu/microcode/intel.c} (100%)
 rename arch/x86/kernel/{microcode_intel_early.c => cpu/microcode/intel_early.c} (100%)
 rename arch/x86/kernel/{microcode_intel_lib.c => cpu/microcode/intel_lib.c} (100%)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index c84cf90ca693..cb3a8602b67a 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1111,10 +1111,6 @@ config MICROCODE_OLD_INTERFACE
 	def_bool y
 	depends on MICROCODE
 
-config MICROCODE_INTEL_LIB
-	def_bool y
-	depends on MICROCODE_INTEL
-
 config MICROCODE_INTEL_EARLY
 	def_bool n
 
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 9b0a34e2cd79..4d0094dbb6c9 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -91,15 +91,6 @@ obj-$(CONFIG_PARAVIRT_CLOCK)	+= pvclock.o
 
 obj-$(CONFIG_PCSPKR_PLATFORM)	+= pcspeaker.o
 
-obj-$(CONFIG_MICROCODE_EARLY)		+= microcode_core_early.o
-obj-$(CONFIG_MICROCODE_INTEL_EARLY)	+= microcode_intel_early.o
-obj-$(CONFIG_MICROCODE_INTEL_LIB)	+= microcode_intel_lib.o
-microcode-y				:= microcode_core.o
-microcode-$(CONFIG_MICROCODE_INTEL)	+= microcode_intel.o
-microcode-$(CONFIG_MICROCODE_AMD)	+= microcode_amd.o
-obj-$(CONFIG_MICROCODE_AMD_EARLY)	+= microcode_amd_early.o
-obj-$(CONFIG_MICROCODE)			+= microcode.o
-
 obj-$(CONFIG_X86_CHECK_BIOS_CORRUPTION) += check.o
 
 obj-$(CONFIG_SWIOTLB)			+= pci-swiotlb.o
diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
index 6359506a19ee..7fd54f09b011 100644
--- a/arch/x86/kernel/cpu/Makefile
+++ b/arch/x86/kernel/cpu/Makefile
@@ -42,6 +42,7 @@ endif
 
 obj-$(CONFIG_X86_MCE)			+= mcheck/
 obj-$(CONFIG_MTRR)			+= mtrr/
+obj-$(CONFIG_MICROCODE)			+= microcode/
 
 obj-$(CONFIG_X86_LOCAL_APIC)		+= perfctr-watchdog.o perf_event_amd_ibs.o
 
diff --git a/arch/x86/kernel/cpu/microcode/Makefile b/arch/x86/kernel/cpu/microcode/Makefile
new file mode 100644
index 000000000000..285c85427c32
--- /dev/null
+++ b/arch/x86/kernel/cpu/microcode/Makefile
@@ -0,0 +1,7 @@
+microcode-y				:= core.o
+obj-$(CONFIG_MICROCODE)			+= microcode.o
+microcode-$(CONFIG_MICROCODE_INTEL)	+= intel.o intel_lib.o
+microcode-$(CONFIG_MICROCODE_AMD)	+= amd.o
+obj-$(CONFIG_MICROCODE_EARLY)		+= core_early.o
+obj-$(CONFIG_MICROCODE_INTEL_EARLY)	+= intel_early.o
+obj-$(CONFIG_MICROCODE_AMD_EARLY)	+= amd_early.o
diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/cpu/microcode/amd.c
similarity index 100%
rename from arch/x86/kernel/microcode_amd.c
rename to arch/x86/kernel/cpu/microcode/amd.c
diff --git a/arch/x86/kernel/microcode_amd_early.c b/arch/x86/kernel/cpu/microcode/amd_early.c
similarity index 100%
rename from arch/x86/kernel/microcode_amd_early.c
rename to arch/x86/kernel/cpu/microcode/amd_early.c
diff --git a/arch/x86/kernel/microcode_core.c b/arch/x86/kernel/cpu/microcode/core.c
similarity index 100%
rename from arch/x86/kernel/microcode_core.c
rename to arch/x86/kernel/cpu/microcode/core.c
diff --git a/arch/x86/kernel/microcode_core_early.c b/arch/x86/kernel/cpu/microcode/core_early.c
similarity index 100%
rename from arch/x86/kernel/microcode_core_early.c
rename to arch/x86/kernel/cpu/microcode/core_early.c
diff --git a/arch/x86/kernel/microcode_intel.c b/arch/x86/kernel/cpu/microcode/intel.c
similarity index 100%
rename from arch/x86/kernel/microcode_intel.c
rename to arch/x86/kernel/cpu/microcode/intel.c
diff --git a/arch/x86/kernel/microcode_intel_early.c b/arch/x86/kernel/cpu/microcode/intel_early.c
similarity index 100%
rename from arch/x86/kernel/microcode_intel_early.c
rename to arch/x86/kernel/cpu/microcode/intel_early.c
diff --git a/arch/x86/kernel/microcode_intel_lib.c b/arch/x86/kernel/cpu/microcode/intel_lib.c
similarity index 100%
rename from arch/x86/kernel/microcode_intel_lib.c
rename to arch/x86/kernel/cpu/microcode/intel_lib.c
-- 
1.8.4

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
