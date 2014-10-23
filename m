Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932085AbaJWXnL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 19:43:11 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:41626 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753761AbaJWXnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 19:43:09 -0400
Message-ID: <54499287.5070803@amacapital.net>
Date: Thu, 23 Oct 2014 16:43:03 -0700
From: Andy Lutomirski <luto@amacapital.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Ben Harris <bjh21@bjh21.me.uk>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Don't allow stackprotector without TSC
References: <alpine.DEB.2.10.1410232227580.28125@snap.ds.cam.ac.uk>
In-Reply-To: <alpine.DEB.2.10.1410232227580.28125@snap.ds.cam.ac.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/23/2014 03:10 PM, Ben Harris wrote:
> On x86, boot_init_stack_canary() unconditionally calls
> __native_read_tsc().  This means that when a kernel with
> CONFIG_CC_STACKPROTECTOR enabled is booted on a CPU without a TSC, the
> kernel hangs at startup.  See <https://bugs.debian.org/766105> for an
> example.
> 
> To avoid this, make HAVE_CC_STACKPROTECTOR dependent on X86_TSC, which
> is defined iff all supported processors have a TSC.  Setting the minimum
> processor type to one without TSC thus disables the stack protector,
> making the kernel bootable on such processors.

Presumably the actual failure is a #GP when trying to do the rdtsc.  If
so, wouldn't a better fix be to make that rdtsc check cpuid first?  Can
we easily check cpuid that early?

--Andy

> 
> Signed-off-by: Ben Harris <bjh21@bjh21.me.uk>
> 
> ---
> 
> This patch is against v3.18-rc1.
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index f2327e8..5acee0f 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -129,7 +129,6 @@ config X86
>      select RTC_LIB
>      select HAVE_DEBUG_STACKOVERFLOW
>      select HAVE_IRQ_EXIT_ON_IRQ_STACK if X86_64
> -    select HAVE_CC_STACKPROTECTOR
>      select GENERIC_CPU_AUTOPROBE
>      select HAVE_ARCH_AUDITSYSCALL
>      select ARCH_SUPPORTS_ATOMIC_RMW
> diff --git a/arch/x86/Kconfig.cpu b/arch/x86/Kconfig.cpu
> index 6983314..9626e47 100644
> --- a/arch/x86/Kconfig.cpu
> +++ b/arch/x86/Kconfig.cpu
> @@ -360,6 +360,7 @@ config X86_P6_NOP
>  config X86_TSC
>      def_bool y
>      depends on (MWINCHIP3D || MCRUSOE || MEFFICEON || MCYRIXIII || MK7
> || MK6 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 ||
> M586MMX || M586TSC || MK8 || MVIAC3_2 || MVIAC7 || MGEODEGX1 ||
> MGEODE_LX || MCORE2 || MATOM) || X86_64
> +    select HAVE_CC_STACKPROTECTOR
> 
>  config X86_CMPXCHG64
>      def_bool y
> 

