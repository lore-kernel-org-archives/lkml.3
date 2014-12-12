Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760038AbaLLPr5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 10:47:57 -0500
Received: from mga02.intel.com ([134.134.136.20]:61013 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758717AbaLLPrz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 10:47:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="497848912"
Message-ID: <548B0E14.6040409@linux.intel.com>
Date: Fri, 12 Dec 2014 07:47:32 -0800
From: Dave Hansen <dave.hansen@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [GIT pull] x86 mpx support for 3.19
References: <alpine.DEB.2.11.1412091504490.16275@nanos> <CA+55aFyu4HYdWzqOuCYb_pRKOZU==xbxTyuBHSn+wV8gT7q+rw@mail.gmail.com> <5488A203.7000600@linux.intel.com> <CA+55aFwTpZ8U7vUvBE8xkX1_vfktyVDcCwchssMhhP44M8TzUg@mail.gmail.com> <5488AF8D.5070702@linux.intel.com> <20141211061935.GA5059@gmail.com> <548A147E.1020507@linux.intel.com> <20141212123048.GA31711@amd>
In-Reply-To: <20141212123048.GA31711@amd>
Content-Type: multipart/mixed;
 boundary="------------070704070203050304020701"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070704070203050304020701
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit

On 12/12/2014 04:30 AM, Pavel Machek wrote:
>> +	depends on CPU_SUP_INTEL
>> +	---help---
>> +	  MPX provides hardware features that can be used in
>> +	  conjunction with compiler-instrumented code to check
>> +	  memory references.  It is designed to detect buffer
>> +	  overflow or underflow bugs.
>> +
>> +	  This option enables running applications which are
>> +	  instrumented or otherwise use MPX.  It does not use MPX
>> +	  itself inside the kernel or to protect the kernel
>> +	  against bad memory references.
>> +
>> +	  Enabling this option will make the kernel larger:
>> +	  ~8k of kernel text and 36 bytes of data on a 64-bit
>> +	  defconfig.  It adds a long to the 'mm_struct' which
>> +	  will increase the kernel memory overhead of each
>> +	  process and adds some branches to paths used during
>> +	  exec() and munmap().
> 
> Should you explain what kind of CPUs support it? Basically "the kind
> you don't have, yet"?

On a practical level, you can look for mpx in cpuinfo a la:

	cat /proc/cpuinfo  | grep ' mpx '

to see if your CPU supports it.  I will mention that in the the
Documentation/ and also point folks there from the Kconfig text.


--------------070704070203050304020701
Content-Type: text/x-patch;
 name="x86-mpx-real-config-option-v4.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="x86-mpx-real-config-option-v4.patch"


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
--- a/arch/x86/Kconfig~x86-mpx-real-config-option-v4	2014-12-12 07:33:51.316565922 -0800
+++ b/arch/x86/Kconfig	2014-12-12 07:33:51.323566238 -0800
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
--- a/Documentation/x86/intel_mpx.txt~x86-mpx-real-config-option-v4	2014-12-12 07:33:51.318566012 -0800
+++ b/Documentation/x86/intel_mpx.txt	2014-12-12 07:38:53.971216573 -0800
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

--------------070704070203050304020701--
