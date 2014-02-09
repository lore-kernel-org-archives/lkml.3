Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751581AbaBIHV2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 02:21:28 -0500
Received: from mga09.intel.com ([134.134.136.24]:61241 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751379AbaBIHV1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 02:21:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,811,1384329600"; 
   d="scan'208";a="452171160"
Date: Sat, 8 Feb 2014 23:21:23 -0800
From: Andi Kleen <ak@linux.intel.com>
To: stefani@seibold.net
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        aarcange@redhat.com, john.stultz@linaro.org, luto@amacapital.net,
        xemul@parallels.com, gorcunov@openvz.org,
        andriy.shevchenko@linux.intel.com, Martin.Runge@rohde-schwarz.com,
        Andreas.Brief@rohde-schwarz.com
Subject: Re: [PATCH v13 8/9] Add 32 bit VDSO time support for 32 bit kernel
Message-ID: <20140209072123.GA23964@tassilo.jf.intel.com>
References: <1391894951-6381-1-git-send-email-stefani@seibold.net>
 <1391894951-6381-9-git-send-email-stefani@seibold.net>
 <20140209052230.GL12219@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140209052230.GL12219@tassilo.jf.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 08, 2014 at 09:22:30PM -0800, Andi Kleen wrote:
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

Actually thinking about it more you likely did that to avoid errors
with -fPIC right? In this case you still need to supply correct dwarf2
unwind annotations.

Also this change is still needed:

> Also I if this calls syscall.S:__kernel_vsyscall it clobbers more registers
> (ecx at least?) and you need to describe that to gcc with a + 
> 
> Same in the other sys calls.
> 
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
> -Andi
> 
> -- 
> ak@linux.intel.com -- Speaking for myself only

-- 
ak@linux.intel.com -- Speaking for myself only
