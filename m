Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751703AbaBIIK0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 03:10:26 -0500
Received: from www84.your-server.de ([213.133.104.84]:52485 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481AbaBIIKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 03:10:25 -0500
Message-ID: <1391933453.1014.20.camel@wall-e.seibold.net>
Subject: Re: [PATCH v13 8/9] Add 32 bit VDSO time support for 32 bit kernel
From: Stefani Seibold <stefani@seibold.net>
To: Andi Kleen <ak@linux.intel.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        aarcange@redhat.com, john.stultz@linaro.org, luto@amacapital.net,
        xemul@parallels.com, gorcunov@openvz.org,
        andriy.shevchenko@linux.intel.com, Martin.Runge@rohde-schwarz.com,
        Andreas.Brief@rohde-schwarz.com
Date: Sun, 09 Feb 2014 09:10:53 +0100
In-Reply-To: <20140209052230.GL12219@tassilo.jf.intel.com>
References: <1391894951-6381-1-git-send-email-stefani@seibold.net>
	 <1391894951-6381-9-git-send-email-stefani@seibold.net>
	 <20140209052230.GL12219@tassilo.jf.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag, den 08.02.2014, 21:22 -0800 schrieb Andi Kleen:
> > +notrace static long vdso_fallback_gettime(long clock, struct timespec *ts)
> > +{
> > +	long ret;
> > +
> > +	asm(
> > +		"push %%ebx \n"
> > +		"mov %2,%%ebx \n"
> > +		"call VDSO32_vsyscall \n"
> > +		"pop %%ebx \n"
> > +		: "=a" (ret)
> > +		: "0" (__NR_clock_gettime), "d" (clock), "c" (ts)
> > +		: "memory");
> 
> The push/mov/pop could be just replaced with "b"?

EBX is a reserved as the base register when compiling with -fPIC.
Otherwise it get a "error: can't find a register in class 'BREG' while
reloading 'asm'".
 
> Also I if this calls syscall.S:__kernel_vsyscall it clobbers more registers
> (ecx at least?) and you need to describe that to gcc with a + 

Sine ECX is in use as the second parameter it is still marked as
clobbered. 

> Same in the other sys calls.
> 

I think it should word... As i know a system call will preserve all
register expect the EAX, which is marked as in and out for this asm()
directive. 

> > @@ -310,6 +311,11 @@ int arch_setup_additional_pages(struct linux_binprm *bprm, int uses_interp)
> >  	unsigned long addr;
> >  	int ret = 0;
> >  	bool compat;
> > +	struct vm_area_struct *vma;
> > +	extern char __vvar_page;
> > +#ifdef CONFIG_HPET_TIMER
> > +	extern unsigned long hpet_address;
> > +#endif
> 
> Put this into a header.
> 

Okay...

> > +++ b/arch/x86/vdso/vdso32/vclock_gettime.c
> > @@ -0,0 +1,16 @@
> > +#define BUILD_VDSO32
> > +
> > +#ifdef CONFIG_X86_64
> > +
> > +#define _ASM_X86_PAGE_H
> > +
> > +#define __pa(x)                0
> > +#define __va(x)                0
> > +
> > +#undef CONFIG_ILLEGAL_POINTER_VALUE
> > +#define CONFIG_ILLEGAL_POINTER_VALUE   0
> 
> This needs some comments.
> 
> Why are the __pa/__va defines safe?
> 
> The rest of the patchkit looks reasonable to me from a quick read.
> Much better than the first version.
> 

This is due the -m32 compilation, i will get a log of 
"warning: integer constant is too large for 'unsigned long' type",
because a unsigned long is only 32 bit.

Since the vclocktime.c use a lot of kernel header a little bit hacking
is necessary, because the CONFIG_X86_64 will attract a lot of x86-64
headers, which are not compatible with 32 bit compilation. 

The _ASM_X86_PAGE_H prevents the include of arch/x86/include/asm/page.h.

But the inline function phys_to_virt() in arch/x86/include/asm/io.h
depends on the __pa() and __va() functions, which comes from
arch/x86/include/asm/page.h. So i need two dummys for this.

Since non of this is functions is used in arch/x86/vdso/vclock_gettime.c
it is save.

I have no idea how to fix this weaved include file web without change a
lot in many include files.

The define of CONFIG_ILLEGAL_POINTER_VALUE is also to prevent the
""warning: integer constant is too large...".

- Stefani

