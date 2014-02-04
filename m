Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754800AbaBDTbr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 14:31:47 -0500
Received: from www.linutronix.de ([62.245.132.108]:48847 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752735AbaBDTbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 14:31:44 -0500
Date: Tue, 4 Feb 2014 20:31:48 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andy Lutomirski <luto@amacapital.net>
cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Remove hpet vclock support
In-Reply-To: <d348afdb2f6acc41dde0381396226b69a0358f8b.1391210357.git.luto@amacapital.net>
Message-ID: <alpine.DEB.2.02.1402042011400.24986@ionos.tec.linutronix.de>
References: <d348afdb2f6acc41dde0381396226b69a0358f8b.1391210357.git.luto@amacapital.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 Jan 2014, Andy Lutomirski wrote:

> The HPET is so amazingly slow that this is barely a win.  It adds

That's nonsense. It's definitely a win to access HPET directly
especially on older systems with TSC wreckage. Why do you want to
enforce a syscall if we can read out the data straight from user
space. The systems which are forced to use HPET have slower syscalls
than those which have a proper TSC.

> complexity, and it scares me a tiny bit to map a piece of crappy
> hardware where every userspace program can poke at it (even if said
> poking is read-only).  Let's just remove it.

What's scary about granting user space access to a read only resource?
 
> This is probably a tiny speedup on kvmclock systems.
 
Oh, now you are coming to the real point of your change:

    You want to save a few cycles in a guest system.

So you justify that by completely unbacked assumptions and a pointless
blurb about scariness.

We are not removing existing functionality which is useful for parts
of our userbase just to make financial online gambling faster.

>  #ifdef CONFIG_PARAVIRT_CLOCK
>  
>  static notrace const struct pvclock_vsyscall_time_info *get_pvti(int cpu)
> @@ -157,8 +151,6 @@ notrace static inline u64 vgetsns(int *mode)
>  	cycles_t cycles;
>  	if (gtod->clock.vclock_mode == VCLOCK_TSC)
>  		cycles = vread_tsc();
> -	else if (gtod->clock.vclock_mode == VCLOCK_HPET)
> -		cycles = vread_hpet();
>  #ifdef CONFIG_PARAVIRT_CLOCK
>  	else if (gtod->clock.vclock_mode == VCLOCK_PVCLOCK)
>  		cycles = vread_pvclock(mode);

I really doubt, that your tiny speedup is even measurable simply
because the branch prediction wont fail and the cache foot print is
not that excitingly smaller. I could be wrong as usual, but its up to
you to provide proper numbers which prove that:

    - there is no impact for the actual forced to use HPET systems

    - there is a measurable improvement for the PV clock case

and not before you tried to revert the evaluation order of VCLOCK_HPET
and VCLOCK_PVCLOCK.

Thanks,

	tglx
