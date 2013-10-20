Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751061Ab3JTAhf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Oct 2013 20:37:35 -0400
Received: from mail-qc0-f182.google.com ([209.85.216.182]:49914 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725Ab3JTAhd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Oct 2013 20:37:33 -0400
Message-ID: <526325C9.7030705@gmail.com>
Date: Sat, 19 Oct 2013 20:37:29 -0400
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Linux-Kernel mailing list <linux-kernel@vger.kernel.org>, x86@kernel.org
CC: Linux Torvalds <torvalds@osdl.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCHv2] x86: add kconfig options for newer 64-bit processors
X-Enigmail-Version: 1.5.2
OpenPGP: id=85D2EC0F
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Austin S. Hemmelgarn <ahferroin7@gmail.com>

This patch adds options to specifically optimize for a number of newer 64-bit microarchitectures; specifically, Intel's Nehalem, Westmere, Ivy Bridge, and Sandy Bridge, and AMD's Family 10h, Bobcat, Jaguar, Bulldozer, Piledriver, and Steamroller.  This serves primarily as an attempt to render this particular sub-menu up-to-date with respect to the options offered by current versions of GCC.

Signed-Off-By: Austin S. Hemmelgarn <ahferroin7@gmail.com>
---
Based on some testing of MIVYBRIDGE, MAMDFAM10, and MPILEDRIVER (the only three that I personally have the hardware to test on), most of these should preform better than GENERIC_CPU on the right hardware, and none of them will preform any worse than GENERIC_CPU on the correct hardware.  Furthermore, testing of MPILEDRIVER seems to indicate an improvement to energy efficiency over GENERIC_CPU as it causes the on cpu power sensor to consistently read an average of 1.5 watts lower under idle load than when using GENERIC_CPU (this corresponds to about 5% decrease in power consumption on a idle-tickless system, and about 2% on a non-dynticks system.).  In addition, most of the people who would be likely to use this are almost certainly going to use it regardless because they either don't care how much of an improvement it provides, or use Linux on such a large scale that any performance improvement is significant (i.e. if you have need for 1000 servers to meet load requirements, then a 1% 
performance boost means that you need 10 fewer servers to meet the same load).

diff -urNp linux/arch/x86/Kconfig.cpu linux-patched/arch/x86/Kconfig.cpu
--- linux/arch/x86/Kconfig.cpu	2013-10-16 16:16:06.722058808 -0400
+++ linux-patched/arch/x86/Kconfig.cpu	2013-10-16 16:29:38.532078946 -0400
@@ -158,6 +158,7 @@ config MK8
 	bool "Opteron/Athlon64/Hammer/K8"
 	---help---
 	  Select this for an AMD Opteron or Athlon64 Hammer-family processor.
+	  These processors show a CPU family of 8 in /proc/cpuinfo.
 	  Enables use of some extended instructions, and passes appropriate
 	  optimization flags to GCC.
 @@ -269,6 +270,105 @@ config MATOM
 	  accordingly optimized code. Use a recent GCC with specific Atom
 	  support in order to fully benefit from selecting this option.
 +config MNEHALEM
+	bool "Intel Nehalem/Westmere"
+	depends on X86_64
+	---help---
+	  Select this for first and second generation Core i3, i5, and i7
+	  processors and other Nehalem or Westmere based processors
+	  This also includes some Xeon server processors.
+
+config MSANDYBRIDGE
+	bool "Intel Sandy Bridge"
+	depends on X86_64
+	---help---
+         Select this for third generation Core i3, i5, and i7
+	  processors and other Sandy Bridge based processors
+	  In addition, this includes some Xeon processors, and many recent
+	  mobile processors branded as Pentium or Celeron.
+
+config MIVYBRIDGE
+	bool "Intel Ivy Bridge"
+	depends on X86_64
+	---help---
+	  Select this for fourth generation Core i3, i5, and i7 processors
+	  and other Ivy Bridge based processors.  This also includes some
+	  Xeon, Pentium, and Celeron processors.
+
+config MAMDFAM10
+	bool "AMD Family 10h (Athlon II, Phenom II, and Opteron)"
+	depends on X86_64
+	---help---
+	  Select this for AMD Family 10h processors.
+	  This includes Athlon II, Phenom II, early third-generation
+	  Opterons, and a number of other Socket AM2, AM2+, AM3, and
+	  Socket F processors.  CPU's in this series show cpu family
+	  16 in /proc/cpuinfo.
+
+config MBOBCAT
+	bool "AMD Bobcat (C, E, G, and Z series APU's)"
+	depends on X86_64
+	---help---
+	  Select this for AMD C, E, G, and Z series APU's.  These are
+	  ultra low power CPU+GPU combos that are similar to the
+	  Bulldozer CPU cores, but have a significantly different
+	  instruction pipeline, and fewer instruction set extensions.
+
+config MJAGUAR
+	bool "AMD Jaguar (Newer E and A series APU's)"
+	depends on X86_64
+	---help---
+	  Select this for AMD Jaguar based CPU's.  These are the successors
+	  of the Bobcat microarchitecture.  CPU's based on this microarchitecture
+	  will show a CPU family of 22 in /proc/cpuinfo.
+
+config MBULLDOZER
+	bool "AMD Bulldozer (FX and Opteron)"
+	depends on X86_64
+	---help---
+	  Select this for AMD Bulldozer microarchitecture processors.
+	  This includes the following CPUs:
+	    FX-41x0
+	    FX-61x0
+	    FX-6200
+	    FX-81x0
+	    Opteron 32xx
+	    Opteron 42xx
+	    Opteron 62xx
+
+config MPILEDRIVER
+	bool "AMD Piledriver (FX, APU, and Opteron)"
+	depends on X86_64
+	---help---
+	  Select this for AMD Piledriver microarchitecture processors.
+	  This includes the Following CPUs:
+	    'Trinity' APUs
+	    'Richland' APUs
+	    FX-43xx
+	    FX-63xx
+	    FX-83xx
+	    FX-9370
+	    FX-9590
+	    Opteron 33xx
+	    Opteron 43xx
+	    Opteron 63xx
+
+config MSTEAMROLLER
+	bool "AMD Steamroller (Kaveri and Berlin APU's)"
+	depends on X86_64
+	---help---
+	  Select this for AMD's 'Kaveri' and 'Berlin' APU's.  These are the
+	  next generation of Bulldozer derived processors.
+
 config GENERIC_CPU
 	bool "Generic-x86-64"
 	depends on X86_64
@@ -300,7 +400,7 @@ config X86_INTERNODE_CACHE_SHIFT
 config X86_L1_CACHE_SHIFT
 	int
 	default "7" if MPENTIUM4 || MPSC
-	default "6" if MK7 || MK8 || MPENTIUMM || MCORE2 || MATOM || MVIAC7 || X86_GENERIC || GENERIC_CPU
+	default "6" if MK7 || MK8 || MPENTIUMM || MCORE2 || MATOM || MVIAC7 || MNEHALEM || MSANDYBRIDGE || MIVYBRIDGE || MAMDFAM10 || MBOBCAT || MJAGUAR || MBULLDOZER || MPILEDRIVER || MSTEAMROLLER || X86_GENERIC || GENERIC_CPU
 	default "4" if MELAN || M486 || MGEODEGX1
 	default "5" if MWINCHIP3D || MWINCHIPC6 || MCRUSOE || MEFFICEON || MCYRIXIII || MK6 || MPENTIUMIII || MPENTIUMII || M686 || M586MMX || M586TSC || M586 || MVIAC3_2 || MGEODE_LX
 @@ -331,7 +431,7 @@ config X86_ALIGNMENT_16
  config X86_INTEL_USERCOPY
 	def_bool y
-	depends on MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M586MMX || X86_GENERIC || MK8 || MK7 || MEFFICEON || MCORE2
+	depends on MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M586MMX || MNEHALEM || MSANDYBRIDGE || MIVYBRIDGE || MAMDFAM10 || MBOBCAT || MJAGUAR || MBULLDOZER || MPILEDRIVER || MSTEAMROLLER || X86_GENERIC || MK8 || MK7 || MEFFICEON || MCORE2
  config X86_USE_PPRO_CHECKSUM
 	def_bool y
diff -urNp linux/arch/x86/Makefile linux-patched/arch/x86/Makefile
--- linux/arch/x86/Makefile	2013-10-16 16:16:06.738725130 -0400
+++ linux-patched/arch/x86/Makefile	2013-10-16 17:28:28.200605479 -0400
@@ -68,6 +68,24 @@ else
                 $(call cc-option,-march=core2,$(call cc-option,-mtune=generic))
 	cflags-$(CONFIG_MATOM) += $(call cc-option,-march=atom) \
 		$(call cc-option,-mtune=atom,$(call cc-option,-mtune=generic))
+        cflags-$(CONFIG_MNEHALEM) += $(call cc-option,-marche=corei7) \
+                $(call cc-option,-mtune=corei7,$(call cc-option,-mtune=generic))
+        cflags-$(CONFIG_SANDYBRIDGE) += $(call cc-option,-march=corei7-avx) \
+                $(call cc-option,-mtune=corei7-avx,$(call cc-option,-mtune=generic))
+        cflags-$(CONFIG_MIVYBRIDGE) += $(call cc-option,-march=core-avx-i) \
+                $(call cc-option,-mtune=core-avx-i,$(call cc-option,-mtune=generic))
+        cflags-$(CONFIG_MAMDFAM10) += $(call cc-option,-march=amdfam10) \
+                $(call cc-option,-mtune=amdfam10,$(call cc-option,-mtune=generic))
+        cflags-$(CONFIG_MBOBCAT) += $(call cc-option,-march=btver1) \
+                $(call cc-option,-mtune=btver1,$(call cc-option,-mtune=generic))
+        cflags-$(CONFIG_MJAGUAR) += $(call cc-option,-match=btver2) \
+                $(call cc-option,-mtune=btver2,$(call cc-option,-mtune=generic))
+        cflags-$(CONFIG_MBULLCOZER) += $(call cc-option,-march=bdver1) \
+                $(call cc-option,-mtune=bdver1,$(call cc-option,-mtune=generic)) \
+        cflags-$(CONFIG_MPILEDRIVER) += $(call cc-option,-march=bdver2) \
+                $(call cc-option,-mtune=bdver2,$(call cc-option,-mtune=generic))
+        cflags-$(CONFIG_MSTEAMROLLER) += $(call cc-option,-march=bdver3) \
+                $(call cc-option,-mtune=bdver3,$(call cc-option,-mtune=generic))
         cflags-$(CONFIG_GENERIC_CPU) += $(call cc-option,-mtune=generic)
         KBUILD_CFLAGS += $(cflags-y)
 
