Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755654AbaLLSif (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 13:38:35 -0500
Received: from mga09.intel.com ([134.134.136.24]:57024 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752780AbaLLSie (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 13:38:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="497932896"
Subject: [PATCH 2/2] x86, mpx: Give MPX a real config option prompt
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, x86@kernel.org, Dave Hansen <dave@sr71.net>,
        dave.hansen@linux.intel.com
From: Dave Hansen <dave@sr71.net>
Date: Fri, 12 Dec 2014 10:38:36 -0800
References: <20141212183834.1F8D01E5@viggo.jf.intel.com>
In-Reply-To: <20141212183834.1F8D01E5@viggo.jf.intel.com>
Message-Id: <20141212183836.2569D58D@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Dave Hansen <dave.hansen@linux.intel.com>

Give MPX a real config option.  The CPUs that support it
(referenced here):

	https://software.intel.com/en-us/forums/topic/402393

are not available publicly, so we need to make it somewhat
easy to disable.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
---

 b/Documentation/x86/intel_mpx.txt |    6 +++++-
 b/arch/x86/Kconfig                |   30 ++++++++++++++++++++++++++----
 2 files changed, 31 insertions(+), 5 deletions(-)

diff -puN arch/x86/Kconfig~x86-mpx-real-config-option-v4 arch/x86/Kconfig
--- a/arch/x86/Kconfig~x86-mpx-real-config-option-v4	2014-12-12 10:12:53.531938223 -0800
+++ b/arch/x86/Kconfig	2014-12-12 10:12:53.536938449 -0800
@@ -248,10 +248,6 @@ config HAVE_INTEL_TXT
 	def_bool y
 	depends on INTEL_IOMMU && ACPI
 
-config X86_INTEL_MPX
-	def_bool y
-	depends on CPU_SUP_INTEL
-
 config X86_32_SMP
 	def_bool y
 	depends on X86_32 && SMP
@@ -1593,6 +1589,32 @@ config X86_SMAP
 
 	  If unsure, say Y.
 
+config X86_INTEL_MPX
+	prompt "Intel MPX (Memory Protection Extensions)"
+	def_bool y
+	depends on CPU_SUP_INTEL
+	---help---
+	  MPX provides hardware features that can be used in
+	  conjunction with compiler-instrumented code to check
+	  memory references.  It is designed to detect buffer
+	  overflow or underflow bugs.
+
+	  This option enables running applications which are
+	  instrumented or otherwise use MPX.  It does not use MPX
+	  itself inside the kernel or to protect the kernel
+	  against bad memory references.
+
+	  Enabling this option will make the kernel larger:
+	  ~8k of kernel text and 36 bytes of data on a 64-bit
+	  defconfig.  It adds a long to the 'mm_struct' which
+	  will increase the kernel memory overhead of each
+	  process and adds some branches to paths used during
+	  exec() and munmap().
+
+	  For details, see Documentation/x86/intel_mpx.txt
+
+	  If unsure, say Y.
+
 config EFI
 	bool "EFI runtime service support"
 	depends on ACPI
diff -puN Documentation/x86/intel_mpx.txt~x86-mpx-real-config-option-v4 Documentation/x86/intel_mpx.txt
--- a/Documentation/x86/intel_mpx.txt~x86-mpx-real-config-option-v4	2014-12-12 10:12:53.532938268 -0800
+++ b/Documentation/x86/intel_mpx.txt	2014-12-12 10:12:53.537938494 -0800
@@ -7,11 +7,15 @@ that can be used in conjunction with com
 references, for those references whose compile-time normal intentions are
 usurped at runtime due to buffer overflow or underflow.
 
+You can tell if your CPU supports MPX by looking in /proc/cpuinfo:
+
+	cat /proc/cpuinfo  | grep ' mpx '
+
 For more information, please refer to Intel(R) Architecture Instruction
 Set Extensions Programming Reference, Chapter 9: Intel(R) Memory Protection
 Extensions.
 
-Note: Currently no hardware with MPX ISA is available but it is always
+Note: As of December 2014, no hardware with MPX is available but it is
 possible to use SDE (Intel(R) Software Development Emulator) instead, which
 can be downloaded from
 http://software.intel.com/en-us/articles/intel-software-development-emulator
_
