Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933061AbaLJUjp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 15:39:45 -0500
Received: from mga02.intel.com ([134.134.136.20]:33901 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756081AbaLJUjo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 15:39:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,553,1413270000"; 
   d="scan'208";a="651789929"
Message-ID: <5488AF8D.5070702@linux.intel.com>
Date: Wed, 10 Dec 2014 12:39:41 -0800
From: Dave Hansen <dave.hansen@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [GIT pull] x86 mpx support for 3.19
References: <alpine.DEB.2.11.1412091504490.16275@nanos>	<CA+55aFyu4HYdWzqOuCYb_pRKOZU==xbxTyuBHSn+wV8gT7q+rw@mail.gmail.com>	<5488A203.7000600@linux.intel.com> <CA+55aFwTpZ8U7vUvBE8xkX1_vfktyVDcCwchssMhhP44M8TzUg@mail.gmail.com>
In-Reply-To: <CA+55aFwTpZ8U7vUvBE8xkX1_vfktyVDcCwchssMhhP44M8TzUg@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------030308050906030700000605"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030308050906030700000605
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

On 12/10/2014 11:49 AM, Linus Torvalds wrote:
> On Wed, Dec 10, 2014 at 11:41 AM, Dave Hansen
> <dave.hansen@linux.intel.com> wrote:
>> But, this is the kind of option that we want to be *sure* is enabled
>> unless folks know exactly what they are doing, so we should probably
>> hide it behind CONFIG_EXPERT as well, just as SMEP is.
> 
> I disagree.
> 
> SMEP doesn't have any performance overhead, and SMEP is available in
> processors available today. So SMEP doesn't even have a config option,
> because there is no downside with having it on and enabled.

I misspoke there.  I meant SMAP (I placed MPX below its config option).

> MPX, in contrast, you don't even normally want to run at all as a
> normal user because of the overheads. That's going to be true even
> when it's available.

The overhead of turning the MPX config option on really is tiny.  We
have a few code touch points like around munmap(), but it should not be
noticeable.

One thing we are *not* doing under this config option is actually
instrumenting kernel code or doing any protection of the kernel itself.
 This is only about supporting user applications that are doing MPX.
This set contains no support for doing MPX _inside_ the kernel.

We probably need to mention this explicitly in the config option.  I've
added:

>           This option enables running applications which are
>           instrumented or otherwise use MPX.  It does not use MPX
>           itself inside the kernel or to protect the kernel
>           against bad memory references.


--------------030308050906030700000605
Content-Type: text/x-patch;
 name="x86-mpx-real-config-option.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="x86-mpx-real-config-option.patch"


From: Dave Hansen <dave.hansen@linux.intel.com>

Give MPX a real config option.  The CPUs that support it
(referenced here):

	https://software.intel.com/en-us/forums/topic/402393

are not available publicly, so we need to make it somewhat
easy to disable.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
---

 b/arch/x86/Kconfig |   25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

diff -puN arch/x86/Kconfig~x86-mpx-real-config-option arch/x86/Kconfig
--- a/arch/x86/Kconfig~x86-mpx-real-config-option	2014-12-10 11:19:13.638835732 -0800
+++ b/arch/x86/Kconfig	2014-12-10 12:30:53.762779608 -0800
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
@@ -1575,6 +1571,27 @@ config X86_SMAP
 
 	  If unsure, say Y.
 
+config X86_INTEL_MPX
+	prompt "Intel MPX (Memory Protection Extensions)" if EXPERT
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
+	  Enabling this option will make the kernel larger and
+	  slightly increase the size of some kernel data
+	  structures.
+
+	  If unsure, say Y.
+
 config EFI
 	bool "EFI runtime service support"
 	depends on ACPI
_

--------------030308050906030700000605--
