Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754996Ab3I2RyG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 13:54:06 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:51914 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754345Ab3I2RyC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 13:54:02 -0400
Message-ID: <52486938.4090009@gmail.com>
Date: Sun, 29 Sep 2013 13:54:00 -0400
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Linux-Kernel mailing list <linux-kernel@vger.kernel.org>,
        Linux Torvalds <torvalds@osdl.org>, Alan Cox <alan@redhat.com>
Subject: [PATCH 1/1] x86_64: add config options to optimize for newer AMD
 processors
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Austin S. Hemmelgarn <ahferroin7@gmail.com>

This patch adds Kconfig options to allow optimization for AMD family
10h, AMD Bulldozer, and AMD Piledriver derived CPU's in version
3.12-rc2.  These provide noticeable improvements over the K8 config
option, and allow the kernel to take full advantage of AMD specific
instruction set extensions, such as ABM, LZCNT, and POPCNT.

Signed-Off-By: Austin S. Hemmelgarn <ahferroin7@gmail.com>
---
diff -uprN linux/arch/x86/Kconfig.cpu linux-new/arch/x86/Kconfig.cpu
--- linux/arch/x86/Kconfig.cpu  2013-09-23 18:41:09.000000000 -0400
+++ linux-new/arch/x86/Kconfig.cpu      2013-09-28 21:31:35.782173832 -0400
@@ -155,9 +155,9 @@ config MK7
          flags to GCC.
 
 config MK8
-       bool "Opteron/Athlon64/Hammer/K8"
+       bool "Old Opteron/Athlon64/Hammer/K8"
        ---help---
-         Select this for an AMD Opteron or Athlon64 Hammer-family processor.
+         Select this for an AMD old 64-bit Opteron or Athlon64 Hammer-family processor.
          Enables use of some extended instructions, and passes appropriate
          optimization flags to GCC.
 
@@ -269,6 +269,57 @@ config MATOM
          accordingly optimized code. Use a recent GCC with specific Atom
          support in order to fully benefit from selecting this option.
 
+config MAMDFAM10
+       bool "AMD Family 10h (Athlon II, Phenom II, and Opteron)"
+       depends on X86_64
+       ---help---
+
+         Select this for AMD Family 10h processors.
+         This includes Athlon II, Phenom II, early third-generation
+         Opterons, and a number of other Socket AM2, AM2+, AM3, and
+         Socket F processors.  CPU's in this series show cpu family
+         16 in /proc/cpuinfo.  Note that a kernel compiled with this
+         option may not run correctly on non-AMD processors.
+
+config MBULLDOZER
+       bool "AMD Bulldozer (FX and Opteron)"
+       depends on X86_64
+       ---help---
+
+         Select this for AMD Buldozer microarchitecture processors.
+         This includes the following CPUs:
+           FX-41x0
+           FX-61x0
+           FX-6200
+           FX-81x0
+           Opteron 32xx
+           Opteron 42xx
+           Opteron 62xx
+
+         Note that a kernel compiled with this option may not run
+         correctly on non-Bulldozer derived processors, if it runs at all.
+
+config MPILEDRIVER
+       bool "AMD Piledriver (FX, APU, and Opteron)"
+       depends on X86_64
+       ---help---
+
+         Select this for AMD Piledriver microarchitecture processors.
+         This includes the Following CPUs:
+           'Trinity' APUs
+           'Richland' APUs
+           FX-43xx
+           FX-63xx
+           FX-83xx
+           FX-9370
+           FX-9590
+           Opteron 33xx
+           Opteron 43xx
+           Opteron 63xx
+
+         Note that a kernel compiled with this option may not run
+         correctly on non-Piledriver derived processors, if it runs at all.
+
 config GENERIC_CPU
        bool "Generic-x86-64"
        depends on X86_64
@@ -300,7 +351,7 @@ config X86_INTERNODE_CACHE_SHIFT
 config X86_L1_CACHE_SHIFT
        int
        default "7" if MPENTIUM4 || MPSC
-       default "6" if MK7 || MK8 || MPENTIUMM || MCORE2 || MATOM || MVIAC7 || X86_GENERIC || GENERIC_CPU
+       default "6" if MK7 || MK8 || MPENTIUMM || MCORE2 || MATOM || MVIAC7 || MAMDFAM10 || MBULLDOZER || MPILEDRIVER || X86_GENERIC || GENERIC_CPU
        default "4" if MELAN || M486 || MGEODEGX1
        default "5" if MWINCHIP3D || MWINCHIPC6 || MCRUSOE || MEFFICEON || MCYRIXIII || MK6 || MPENTIUMIII || MPENTIUMII || M686 || M586MMX || M586TSC || M586 || MVIAC3_2 || MGEODE_LX
 
diff -uprN linux/arch/x86/Makefile linux-new/arch/x86/Makefile
--- linux/arch/x86/Makefile     2013-09-23 18:41:09.000000000 -0400
+++ linux-new/arch/x86/Makefile 2013-09-28 21:20:41.869697978 -0400
@@ -68,6 +68,12 @@ else
                 $(call cc-option,-march=core2,$(call cc-option,-mtune=generic))
        cflags-$(CONFIG_MATOM) += $(call cc-option,-march=atom) \
                $(call cc-option,-mtune=atom,$(call cc-option,-mtune=generic))
+        cflags-$(CONFIG_AMDFAM10) += $(call cc-option,-march=amdfam10) \
+                $(call cc-option,-mtune=amdfam10,$(call cc-option,-mtune=generic))
+        cflags-$(CONFIG_MBULLCOZER) += $(call cc-option,-march=bdver1) \
+                $(call cc-option,-mtune=bdver1,$(call cc-option,-mtune=generic))
+        cflags-$(CONFIG_MPILEDRIVER) += $(call cc-option,-march=bdver2) \
+                $(call cc-option,-mtune=bdver2,$(call cc-option,-mtune=generic))
         cflags-$(CONFIG_GENERIC_CPU) += $(call cc-option,-mtune=generic)
         KBUILD_CFLAGS += $(cflags-y)
 
