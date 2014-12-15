Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753876AbaLOPCR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 10:02:17 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49952 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952AbaLOPCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 10:02:14 -0500
Date: Mon, 15 Dec 2014 07:02:01 -0800
From: tip-bot for Dave Hansen <tipbot@zytor.com>
Message-ID: <tip-72e9b5fe9bee0826e7ce7599adbdc64e544780ef@git.kernel.org>
Cc: dave.hansen@linux.intel.com, mingo@kernel.org, hpa@zytor.com,
        tglx@linutronix.de, dave@sr71.net, linux-kernel@vger.kernel.org
Reply-To: linux-kernel@vger.kernel.org, mingo@kernel.org, hpa@zytor.com,
        tglx@linutronix.de, dave@sr71.net, dave.hansen@linux.intel.com
In-Reply-To: <20141212183836.2569D58D@viggo.jf.intel.com>
References: <20141212183836.2569D58D@viggo.jf.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mpx] x86, mpx: Give MPX a real config option prompt
Git-Commit-ID: 72e9b5fe9bee0826e7ce7599adbdc64e544780ef
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  72e9b5fe9bee0826e7ce7599adbdc64e544780ef
Gitweb:     http://git.kernel.org/tip/72e9b5fe9bee0826e7ce7599adbdc64e544780ef
Author:     Dave Hansen <dave.hansen@linux.intel.com>
AuthorDate: Fri, 12 Dec 2014 10:38:36 -0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 15 Dec 2014 15:58:57 +0100

x86, mpx: Give MPX a real config option prompt

Give MPX a real config option. The CPUs that support it (referenced
here):

  https://software.intel.com/en-us/forums/topic/402393

are not available publicly yet. Right now only the software emulator
provides MPX for the general public.

[ tglx: Make it default off. There is no point in having it on right
        now as no hardware and no proper tooling support are available ]

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Dave Hansen <dave@sr71.net>
Link: http://lkml.kernel.org/r/20141212183836.2569D58D@viggo.jf.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 Documentation/x86/intel_mpx.txt |  6 +++++-
 arch/x86/Kconfig                | 30 ++++++++++++++++++++++++++----
 2 files changed, 31 insertions(+), 5 deletions(-)

diff --git a/Documentation/x86/intel_mpx.txt b/Documentation/x86/intel_mpx.txt
index 6ca6e2b..818518a 100644
--- a/Documentation/x86/intel_mpx.txt
+++ b/Documentation/x86/intel_mpx.txt
@@ -7,11 +7,15 @@ that can be used in conjunction with compiler changes to check memory
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
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 967dfe0..cc91e5e 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
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
@@ -1575,6 +1571,32 @@ config X86_SMAP
 
 	  If unsure, say Y.
 
+config X86_INTEL_MPX
+	prompt "Intel MPX (Memory Protection Extensions)"
+	def_bool n
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
+	  If unsure, say N.
+
 config EFI
 	bool "EFI runtime service support"
 	depends on ACPI
