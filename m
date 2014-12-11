Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934415AbaLKWEv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 17:04:51 -0500
Received: from mga02.intel.com ([134.134.136.20]:21551 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933118AbaLKWEu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 17:04:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="497493707"
Message-ID: <548A147E.1020507@linux.intel.com>
Date: Thu, 11 Dec 2014 14:02:38 -0800
From: Dave Hansen <dave.hansen@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [GIT pull] x86 mpx support for 3.19
References: <alpine.DEB.2.11.1412091504490.16275@nanos> <CA+55aFyu4HYdWzqOuCYb_pRKOZU==xbxTyuBHSn+wV8gT7q+rw@mail.gmail.com> <5488A203.7000600@linux.intel.com> <CA+55aFwTpZ8U7vUvBE8xkX1_vfktyVDcCwchssMhhP44M8TzUg@mail.gmail.com> <5488AF8D.5070702@linux.intel.com> <20141211061935.GA5059@gmail.com>
In-Reply-To: <20141211061935.GA5059@gmail.com>
Content-Type: multipart/mixed;
 boundary="------------020605050402020500010901"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020605050402020500010901
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit

On 12/10/2014 10:19 PM, Ingo Molnar wrote:
> * Dave Hansen <dave.hansen@linux.intel.com> wrote:
>> @@ -1575,6 +1571,27 @@ config X86_SMAP
>>  
>>  	  If unsure, say Y.
>>  
>> +config X86_INTEL_MPX
>> +	prompt "Intel MPX (Memory Protection Extensions)" if EXPERT
> 
> I think the 'if EXPERT' needs to be dropped.

Fine with me.

>> +	def_bool y
>> +	depends on CPU_SUP_INTEL
> 
> On the one hand, the 'def_bool y' might be acceptable, if we 
> think of MPX as X32 or SECCOMP: ABI extensions that are only 
> really useful if all distros enable it.

It's a _bit_ different than X32 or SECCOMP, though.  An x32 app is a
doorstop if the kernel's config option is off.  An MPX-instrumented app
ends up looking like a dumb app running a bunch of noops (for the MPX
instructions and prefixes) and being mean to the icache, but it's not a
doorstop.

That said, we *really* want distros enabling it.  (Putting my Intel hat
on firmly now...)  MPX already requires recompiling binaries, which is a
fairly large burden.  If an application writer goes to that trouble, we
really want to make sure that the kernel support is there.

It'd be a real shame to have an app compiled with MPX support (and all
those noops and their overhead), running on a CPU with silicon that
supports MPX, and a kernel that *can* support MPX... and then not use it.

>> +	  Enabling this option will make the kernel larger and
>> +	  slightly increase the size of some kernel data
>> +	  structures.
> 
> And will add a few branches to critical code paths, right?

Yep, new patch attached.

--------------020605050402020500010901
Content-Type: text/x-patch;
 name="x86-mpx-real-config-option-v3.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="x86-mpx-real-config-option-v3.patch"


From: Dave Hansen <dave.hansen@linux.intel.com>

Give MPX a real config option.  The CPUs that support it
(referenced here):

	https://software.intel.com/en-us/forums/topic/402393

are not available publicly, so we need to make it somewhat
easy to disable.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
---

 b/arch/x86/Kconfig |   28 ++++++++++++++++++++++++----
 1 file changed, 24 insertions(+), 4 deletions(-)

diff -puN arch/x86/Kconfig~x86-mpx-real-config-option-v3 arch/x86/Kconfig
--- a/arch/x86/Kconfig~x86-mpx-real-config-option-v3	2014-12-11 07:37:05.147501580 -0800
+++ b/arch/x86/Kconfig	2014-12-11 07:38:55.864495123 -0800
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
@@ -1575,6 +1571,30 @@ config X86_SMAP
 
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
+	  If unsure, say Y.
+
 config EFI
 	bool "EFI runtime service support"
 	depends on ACPI
_

--------------020605050402020500010901--
