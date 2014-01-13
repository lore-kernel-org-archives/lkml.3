Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752928AbaAMTX1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 14:23:27 -0500
Received: from mga02.intel.com ([134.134.136.20]:2008 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752743AbaAMTXN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 14:23:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,654,1384329600"; 
   d="scan'208";a="438183803"
Subject: [PATCH 09/12] x86 Kconfig: create mtrr menu under processsor options
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, Dave Hansen <dave@sr71.net>
From: Dave Hansen <dave@sr71.net>
Date: Mon, 13 Jan 2014 11:22:57 -0800
References: <20140113192245.3F682C7F@viggo.jf.intel.com>
In-Reply-To: <20140113192245.3F682C7F@viggo.jf.intel.com>
Message-Id: <20140113192257.616E9113@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Dave Hansen <dave.hansen@linux.intel.com>

This groups the MTRR and PAT options under their own menu and
puts them under the "Processor Options..." submenu.  Note that I
slightly changed the MTRR prompt text since PAT is hidden under
here.  This makes PAT easier to find since it "depends on MTRR"
anyway.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
---

 linux.git-davehans/arch/x86/Kconfig |  161 +++++++++++++++++-------------------
 1 file changed, 80 insertions(+), 81 deletions(-)

diff -puN arch/x86/Kconfig~x86-mtrr-menu arch/x86/Kconfig
--- linux.git/arch/x86/Kconfig~x86-mtrr-menu	2014-01-13 11:11:36.201237047 -0800
+++ linux.git-davehans/arch/x86/Kconfig	2014-01-13 11:11:36.204237182 -0800
@@ -481,6 +481,86 @@ config X86_CPUID
 	  with major 203 and minors 0 to 31 for /dev/cpu/0/cpuid to
 	  /dev/cpu/31/cpuid.
 
+menuconfig MTRR
+	def_bool y
+	prompt "MTRR (Memory Type Range Register) and PAT support" if EXPERT
+	---help---
+	  On Intel P6 family processors (Pentium Pro, Pentium II and later)
+	  the Memory Type Range Registers (MTRRs) may be used to control
+	  processor access to memory ranges. This is most useful if you have
+	  a video (VGA) card on a PCI or AGP bus. Enabling write-combining
+	  allows bus write transfers to be combined into a larger transfer
+	  before bursting over the PCI/AGP bus. This can increase performance
+	  of image write operations 2.5 times or more. Saying Y here creates a
+	  /proc/mtrr file which may be used to manipulate your processor's
+	  MTRRs. Typically the X server should use this.
+
+	  This code has a reasonably generic interface so that similar
+	  control registers on other processors can be easily supported
+	  as well:
+
+	  The Cyrix 6x86, 6x86MX and M II processors have Address Range
+	  Registers (ARRs) which provide a similar functionality to MTRRs. For
+	  these, the ARRs are used to emulate the MTRRs.
+	  The AMD K6-2 (stepping 8 and above) and K6-3 processors have two
+	  MTRRs. The Centaur C6 (WinChip) has 8 MCRs, allowing
+	  write-combining. All of these processors are supported by this code
+	  and it makes sense to say Y here if you have one of them.
+
+	  Saying Y here also fixes a problem with buggy SMP BIOSes which only
+	  set the MTRRs for the boot CPU and not for the secondary CPUs. This
+	  can lead to all sorts of problems, so it's good to say Y here.
+
+	  You can safely say Y even if your machine doesn't have MTRRs, you'll
+	  just add about 9 KB to your kernel.
+
+	  See <file:Documentation/x86/mtrr.txt> for more information.
+
+config MTRR_SANITIZER
+	def_bool y
+	prompt "MTRR cleanup support"
+	depends on MTRR
+	---help---
+	  Convert MTRR layout from continuous to discrete, so X drivers can
+	  add writeback entries.
+
+	  Can be disabled with disable_mtrr_cleanup on the kernel command line.
+	  The largest mtrr entry size for a continuous block can be set with
+	  mtrr_chunk_size.
+
+	  If unsure, say Y.
+
+config MTRR_SANITIZER_ENABLE_DEFAULT
+	int "MTRR cleanup enable value (0-1)"
+	range 0 1
+	default "0"
+	depends on MTRR_SANITIZER
+	---help---
+	  Enable mtrr cleanup default value
+
+config MTRR_SANITIZER_SPARE_REG_NR_DEFAULT
+	int "MTRR cleanup spare reg num (0-7)"
+	range 0 7
+	default "1"
+	depends on MTRR_SANITIZER
+	---help---
+	  mtrr cleanup spare entries default, it can be changed via
+	  mtrr_spare_reg_nr=N on the kernel command line.
+
+config X86_PAT
+	def_bool y
+	prompt "x86 PAT support" if EXPERT
+	depends on MTRR
+	---help---
+	  Use PAT attributes to setup page level cache control.
+
+	  PATs are the modern equivalents of MTRRs and are much more
+	  flexible than MTRRs.
+
+	  Say N here if you see bootup problems (boot crash, boot hang,
+	  spontaneous reboots) or a non-working video driver.
+
+	  If unsure, say Y.
 
 endmenu # Processor Options
 
@@ -1246,87 +1326,6 @@ config MATH_EMULATION
 	  If you are not sure, say Y; apart from resulting in a 66 KB bigger
 	  kernel, it won't hurt.
 
-config MTRR
-	def_bool y
-	prompt "MTRR (Memory Type Range Register) support" if EXPERT
-	---help---
-	  On Intel P6 family processors (Pentium Pro, Pentium II and later)
-	  the Memory Type Range Registers (MTRRs) may be used to control
-	  processor access to memory ranges. This is most useful if you have
-	  a video (VGA) card on a PCI or AGP bus. Enabling write-combining
-	  allows bus write transfers to be combined into a larger transfer
-	  before bursting over the PCI/AGP bus. This can increase performance
-	  of image write operations 2.5 times or more. Saying Y here creates a
-	  /proc/mtrr file which may be used to manipulate your processor's
-	  MTRRs. Typically the X server should use this.
-
-	  This code has a reasonably generic interface so that similar
-	  control registers on other processors can be easily supported
-	  as well:
-
-	  The Cyrix 6x86, 6x86MX and M II processors have Address Range
-	  Registers (ARRs) which provide a similar functionality to MTRRs. For
-	  these, the ARRs are used to emulate the MTRRs.
-	  The AMD K6-2 (stepping 8 and above) and K6-3 processors have two
-	  MTRRs. The Centaur C6 (WinChip) has 8 MCRs, allowing
-	  write-combining. All of these processors are supported by this code
-	  and it makes sense to say Y here if you have one of them.
-
-	  Saying Y here also fixes a problem with buggy SMP BIOSes which only
-	  set the MTRRs for the boot CPU and not for the secondary CPUs. This
-	  can lead to all sorts of problems, so it's good to say Y here.
-
-	  You can safely say Y even if your machine doesn't have MTRRs, you'll
-	  just add about 9 KB to your kernel.
-
-	  See <file:Documentation/x86/mtrr.txt> for more information.
-
-config MTRR_SANITIZER
-	def_bool y
-	prompt "MTRR cleanup support"
-	depends on MTRR
-	---help---
-	  Convert MTRR layout from continuous to discrete, so X drivers can
-	  add writeback entries.
-
-	  Can be disabled with disable_mtrr_cleanup on the kernel command line.
-	  The largest mtrr entry size for a continuous block can be set with
-	  mtrr_chunk_size.
-
-	  If unsure, say Y.
-
-config MTRR_SANITIZER_ENABLE_DEFAULT
-	int "MTRR cleanup enable value (0-1)"
-	range 0 1
-	default "0"
-	depends on MTRR_SANITIZER
-	---help---
-	  Enable mtrr cleanup default value
-
-config MTRR_SANITIZER_SPARE_REG_NR_DEFAULT
-	int "MTRR cleanup spare reg num (0-7)"
-	range 0 7
-	default "1"
-	depends on MTRR_SANITIZER
-	---help---
-	  mtrr cleanup spare entries default, it can be changed via
-	  mtrr_spare_reg_nr=N on the kernel command line.
-
-config X86_PAT
-	def_bool y
-	prompt "x86 PAT support" if EXPERT
-	depends on MTRR
-	---help---
-	  Use PAT attributes to setup page level cache control.
-
-	  PATs are the modern equivalents of MTRRs and are much more
-	  flexible than MTRRs.
-
-	  Say N here if you see bootup problems (boot crash, boot hang,
-	  spontaneous reboots) or a non-working video driver.
-
-	  If unsure, say Y.
-
 config ARCH_USES_PG_UNCACHED
 	def_bool y
 	depends on X86_PAT
_
