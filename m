Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751689AbaBIIOr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 03:14:47 -0500
Received: from www84.your-server.de ([213.133.104.84]:52679 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379AbaBIIOq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 03:14:46 -0500
Message-ID: <1391933733.1014.25.camel@wall-e.seibold.net>
Subject: Re: [PATCH v13 8/9] Add 32 bit VDSO time support for 32 bit kernel
From: Stefani Seibold <stefani@seibold.net>
To: Andi Kleen <ak@linux.intel.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        aarcange@redhat.com, john.stultz@linaro.org, luto@amacapital.net,
        xemul@parallels.com, gorcunov@openvz.org,
        andriy.shevchenko@linux.intel.com, Martin.Runge@rohde-schwarz.com,
        Andreas.Brief@rohde-schwarz.com
Date: Sun, 09 Feb 2014 09:15:33 +0100
In-Reply-To: <20140209072123.GA23964@tassilo.jf.intel.com>
References: <1391894951-6381-1-git-send-email-stefani@seibold.net>
	 <1391894951-6381-9-git-send-email-stefani@seibold.net>
	 <20140209052230.GL12219@tassilo.jf.intel.com>
	 <20140209072123.GA23964@tassilo.jf.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag, den 08.02.2014, 23:21 -0800 schrieb Andi Kleen:
> On Sat, Feb 08, 2014 at 09:22:30PM -0800, Andi Kleen wrote:
> > > +notrace static long vdso_fallback_gettime(long clock, struct timespec *ts)
> > > +{
> > > +	long ret;
> > > +
> > > +	asm(
> > > +		"push %%ebx \n"
> > > +		"mov %2,%%ebx \n"
> > > +		"call VDSO32_vsyscall \n"
> > > +		"pop %%ebx \n"
> > > +		: "=a" (ret)
> > > +		: "0" (__NR_clock_gettime), "d" (clock), "c" (ts)
> > > +		: "memory");
> > 
> > The push/mov/pop could be just replaced with "b"?
> 
> Actually thinking about it more you likely did that to avoid errors
> with -fPIC right? In this case you still need to supply correct dwarf2
> unwind annotations.
> 

Right... But i have no idea why and how to supply dwarf2 unwind
annotations. Can you give my some hints?

> Also this change is still needed:
> 
> > Also I if this calls syscall.S:__kernel_vsyscall it clobbers more registers
> > (ecx at least?) and you need to describe that to gcc with a + 
> > 
> > Same in the other sys calls.
> > 

ECX is still marked as clobberd as is in use for the second parameter.

All other registers will be saved by __kernel_vsyscall, expect the EAX
which is marked as in and out register in the asm() directive.

- Stefani


