Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752953AbaKQWbJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 17:31:09 -0500
Received: from www.linutronix.de ([62.245.132.108]:35909 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791AbaKQWbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 17:31:08 -0500
Date: Mon, 17 Nov 2014 23:31:03 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Jens Axboe <axboe@kernel.dk>, Ingo Molnar <mingo@kernel.org>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>
Subject: Re: frequent lockups in 3.18rc4
In-Reply-To: <CA+55aFyBnd_Hbe46UpeRktS+ePkAdL5k7vEChUMEx3-e8O1Usg@mail.gmail.com>
Message-ID: <alpine.DEB.2.11.1411172303070.3909@nanos>
References: <20141114213124.GB3344@redhat.com> <CA+55aFx16ks_azU0eAcx+qZ5-o8Xo0zzP6aNjrskai8rqp+eMg@mail.gmail.com> <alpine.DEB.2.11.1411142326510.3909@nanos> <CA+55aFxExBiRpPemPECKP9wMnR4F4J=ne8UoHKcXjntGB_OEgA@mail.gmail.com>
 <CA+55aFyBnd_Hbe46UpeRktS+ePkAdL5k7vEChUMEx3-e8O1Usg@mail.gmail.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Nov 2014, Linus Torvalds wrote:
> On Fri, Nov 14, 2014 at 5:59 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > Judging by the code disassembly, it's the "csd_lock_wait(csd)" at the
> > end.
> 
> Btw, looking at this, I grew really suspicious of this code in csd_unlock():
> 
>         WARN_ON((csd->flags & CSD_FLAG_WAIT) && !(csd->flags & CSD_FLAG_LOCK));
> 
> because that makes no sense at all. It basically removes a sanity
> check, yet that sanity check makes a hell of a lot of sense. Unlocking
> a CSD that is not locked is *wrong*.
> 
> The crazy code code comes from commit c84a83e2aaab ("smp: don't warn
> about csd->flags having CSD_FLAG_LOCK cleared for !wait") by Jens, but
> the explanation and the code is pure crap.
> 
> There is no way in hell that it is ever correct to unlock an entry
> that isn't locked, so that whole CSD_FLAG_WAIT thing is buggy as hell.
> 
> The explanation in commit c84a83e2aaab says that  "blk-mq reuses the
> request potentially immediately" and claims that that is somehow ok,
> but that's utter BS. Even if you don't ever wait for it, the CSD lock
> bit fundamentally also protects the "csd->llist" pointer. So what that
> commit actually does is to just remove a safety check, and do so in a
> very unsafe manner. And apparently block-mq re-uses something THAT IS
> STILL ACTIVELY IN USE. That's just horrible.
>  
> Now, I think we might do this differently, by doing the "csd_unlock()"
> after we have loaded everything from the csd, but *before* actually
> calling the callback function. That would seem to be equivalent
> (interrupts are disabled, so this will not result in the func()
> possibly called twice), more efficient, _and_  not remove a useful
> check.
> 
> Hmm? Completely untested patch attached. Jens, does this still work for you?
> 
> Am I missing something?

Yes. :)

> --- a/kernel/smp.c
> +++ b/kernel/smp.c
> @@ -19,7 +19,6 @@
>  
>  enum {
>  	CSD_FLAG_LOCK		= 0x01,
> -	CSD_FLAG_WAIT		= 0x02,
>  };
>  
>  struct call_function_data {
> @@ -126,7 +125,7 @@ static void csd_lock(struct call_single_data *csd)
>  
>  static void csd_unlock(struct call_single_data *csd)
>  {
> -	WARN_ON((csd->flags & CSD_FLAG_WAIT) && !(csd->flags & CSD_FLAG_LOCK));
> +	WARN_ON(!(csd->flags & CSD_FLAG_LOCK));
>  
>  	/*
>  	 * ensure we're all done before releasing data:
> @@ -173,9 +172,6 @@ static int generic_exec_single(int cpu, struct call_single_data *csd,
>  	csd->func = func;
>  	csd->info = info;
>  
> -	if (wait)
> -		csd->flags |= CSD_FLAG_WAIT;
> -
>  	/*
>  	 * The list addition should be visible before sending the IPI
>  	 * handler locks the list to pull the entry off it because of
> @@ -250,8 +246,11 @@ static void flush_smp_call_function_queue(bool warn_cpu_offline)
>  	}
>  
>  	llist_for_each_entry_safe(csd, csd_next, entry, llist) {
> -		csd->func(csd->info);
> +		smp_call_func_t func = csd->func;
> +		void *info = csd->info;
>  		csd_unlock(csd);
> +
> +		func(info);

No, that won't work for synchronous calls:

    CPU 0      	    		CPU 1

    csd_lock(csd);
    queue_csd();
    ipi();
				func = csd->func;
				info = csd->info;
				csd_unlock(csd);
    csd_lock_wait();    
				func(info);
   
The csd_lock_wait() side will succeed and therefor assume that the
call has been completed while the function has not been called at
all. Interesting explosions to follow.

The proper solution is to revert that commit and properly analyze the
problem which Jens was trying to solve and work from there.

Thanks,

	tglx
