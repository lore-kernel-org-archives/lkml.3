Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932327Ab3L3SoX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 13:44:23 -0500
Received: from mga01.intel.com ([192.55.52.88]:13102 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932104Ab3L3Skt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 13:40:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,575,1384329600"; 
   d="scan'208";a="457777376"
Subject: [PATCH 01/12] x86 Kconfig: create extended platforms menu
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, Dave Hansen <dave@sr71.net>
From: Dave Hansen <dave@sr71.net>
Date: Mon, 30 Dec 2013 10:40:47 -0800
References: <20131230184046.F5E42919@viggo.jf.intel.com>
In-Reply-To: <20131230184046.F5E42919@viggo.jf.intel.com>
Message-Id: <20131230184047.59278144@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Dave Hansen <dave.hansen@linux.intel.com>

This takes the relatively obscure (NUMA-Q anyone?) platforms
(both 32 and 64-bit) and sticks them in their own menu.
Virtually nobody needs to set these, and those that do know how
to find them the hard way.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
---

 linux.git-davehans/arch/x86/Kconfig |  103 ++++++++++++++++--------------------
 1 file changed, 46 insertions(+), 57 deletions(-)

diff -puN arch/x86/Kconfig~x86-extended-platforms arch/x86/Kconfig
--- linux.git/arch/x86/Kconfig~x86-extended-platforms	2013-12-30 10:37:43.691164956 -0800
+++ linux.git-davehans/arch/x86/Kconfig	2013-12-30 10:37:43.696165181 -0800
@@ -331,8 +331,7 @@ config GOLDFISH
        def_bool y
        depends on X86_GOLDFISH
 
-if X86_32
-config X86_EXTENDED_PLATFORM
+menuconfig X86_EXTENDED_PLATFORM
 	bool "Support for extended (non-PC) x86 platforms"
 	default y
 	---help---
@@ -341,7 +340,12 @@ config X86_EXTENDED_PLATFORM
 	  systems out there.)
 
 	  If you enable this option then you'll be able to select support
-	  for the following (non-PC) 32 bit x86 platforms:
+	  for the following (non-PC) 64 bit x86 platforms:
+		Numascale NumaChip
+		ScaleMP vSMP
+		SGI Ultraviolet
+
+	  and these (non-PC) 32 bit x86 platforms:
 		Goldfish (Android emulator)
 		AMD Elan
 		NUMAQ (IBM/Sequent)
@@ -354,26 +358,9 @@ config X86_EXTENDED_PLATFORM
 
 	  If you have one of these systems, or if you want to build a
 	  generic distribution kernel, say Y here - otherwise say N.
-endif
-
-if X86_64
-config X86_EXTENDED_PLATFORM
-	bool "Support for extended (non-PC) x86 platforms"
-	default y
-	---help---
-	  If you disable this option then the kernel will only support
-	  standard PC platforms. (which covers the vast majority of
-	  systems out there.)
 
-	  If you enable this option then you'll be able to select support
-	  for the following (non-PC) 64 bit x86 platforms:
-		Numascale NumaChip
-		ScaleMP vSMP
-		SGI Ultraviolet
+if X86_EXTENDED_PLATFORM
 
-	  If you have one of these systems, or if you want to build a
-	  generic distribution kernel, say Y here - otherwise say N.
-endif
 # This is an alphabetically sorted list of 64 bit extended platforms
 # Please maintain the alphabetic order if and when there are additions
 config X86_NUMACHIP
@@ -447,6 +434,44 @@ config X86_WANT_INTEL_MID
 	  systems which do not have the PCI legacy interfaces (Moorestown,
 	  Medfield). If you are building for a PC class system say N here.
 
+config X86_RDC321X
+	bool "RDC R-321x SoC"
+	depends on X86_32
+	depends on X86_EXTENDED_PLATFORM
+	select M486
+	select X86_REBOOTFIXUPS
+	---help---
+	  This option is needed for RDC R-321x system-on-chip, also known
+	  as R-8610-(G).
+	  If you don't have one of these chips, you should say N here.
+
+config X86_32_NON_STANDARD
+	bool "Support non-standard 32-bit SMP architectures"
+	depends on X86_32 && SMP
+	depends on X86_EXTENDED_PLATFORM
+	---help---
+	  This option compiles in the NUMAQ, Summit, bigsmp, ES7000,
+	  STA2X11, default subarchitectures.  It is intended for a generic
+	  binary kernel. If you select them all, kernel will probe it
+	  one by one and will fallback to default.
+
+# Alphabetically sorted list of Non standard 32 bit platforms
+
+config X86_NUMAQ
+	bool "NUMAQ (IBM/Sequent)"
+	depends on X86_32_NON_STANDARD
+	depends on PCI
+	select NUMA
+	select X86_MPPARSE
+	---help---
+	  This option is used for getting Linux to run on a NUMAQ (IBM/Sequent)
+	  NUMA multiquad box. This changes the way that processors are
+	  bootstrapped, and uses Clustered Logical APIC addressing mode instead
+	  of Flat Logical.  You will need a new lynxer.elf file to flash your
+	  firmware with - send email to <Martin.Bligh@us.ibm.com>.
+
+endif # X86_EXTENDED_PLATFORM
+
 if X86_WANT_INTEL_MID
 
 config X86_INTEL_MID
@@ -486,42 +511,6 @@ config X86_INTEL_LPSS
 	  things like clock tree (common clock framework) and pincontrol
 	  which are needed by the LPSS peripheral drivers.
 
-config X86_RDC321X
-	bool "RDC R-321x SoC"
-	depends on X86_32
-	depends on X86_EXTENDED_PLATFORM
-	select M486
-	select X86_REBOOTFIXUPS
-	---help---
-	  This option is needed for RDC R-321x system-on-chip, also known
-	  as R-8610-(G).
-	  If you don't have one of these chips, you should say N here.
-
-config X86_32_NON_STANDARD
-	bool "Support non-standard 32-bit SMP architectures"
-	depends on X86_32 && SMP
-	depends on X86_EXTENDED_PLATFORM
-	---help---
-	  This option compiles in the NUMAQ, Summit, bigsmp, ES7000,
-	  STA2X11, default subarchitectures.  It is intended for a generic
-	  binary kernel. If you select them all, kernel will probe it
-	  one by one and will fallback to default.
-
-# Alphabetically sorted list of Non standard 32 bit platforms
-
-config X86_NUMAQ
-	bool "NUMAQ (IBM/Sequent)"
-	depends on X86_32_NON_STANDARD
-	depends on PCI
-	select NUMA
-	select X86_MPPARSE
-	---help---
-	  This option is used for getting Linux to run on a NUMAQ (IBM/Sequent)
-	  NUMA multiquad box. This changes the way that processors are
-	  bootstrapped, and uses Clustered Logical APIC addressing mode instead
-	  of Flat Logical.  You will need a new lynxer.elf file to flash your
-	  firmware with - send email to <Martin.Bligh@us.ibm.com>.
-
 config X86_SUPPORTS_MEMORY_FAILURE
 	def_bool y
 	# MCE code calls memory_failure():
_
