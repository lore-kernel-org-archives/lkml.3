Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753117AbbAXLfg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2015 06:35:36 -0500
Received: from www.linutronix.de ([62.245.132.108]:40211 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557AbbAXLfc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2015 06:35:32 -0500
Date: Sat, 24 Jan 2015 12:35:01 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Torvald Riegel <triegel@redhat.com>
cc: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        "Carlos O'Donell" <carlos@redhat.com>,
        Darren Hart <dvhart@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
        Jakub Jelinek <jakub@redhat.com>,
        "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Arnd Bergmann <arnd@arndb.de>, Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linux API <linux-api@vger.kernel.org>,
        Darren Hart <dvhart@infradead.org>, Anton Blanchard <anton@samba.org>,
        Petr Baudis <pasky@suse.cz>, Eric Dumazet <edumazet@google.com>,
        bill o gallmeister <bgallmeister@gmail.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Daniel Wagner <wagi@monom.org>,
        Rich Felker <dalias@libc.org>
Subject: Re: futex(2) man page update help request
In-Reply-To: <1422037788.29655.0.camel@triegel.csb>
Message-ID: <alpine.DEB.2.11.1501241116160.5526@nanos>
References: <537346E5.4050407@gmail.com>  <CF98E3EF.90564%dvhart@linux.intel.com>  <CAKgNAkh+PWzT2SByaLk_OtiAXeZSkWoMgu+ivDOt1dTWVtaatQ@mail.gmail.com>  <5373D0CA.2050204@redhat.com>  <alpine.DEB.2.02.1405150121230.6261@ionos.tec.linutronix.de> 
 <CAKgNAkjQ5Dd_U9OojXdgeforpRevvPHNFAw99kBFPCwHgf7Ggg@mail.gmail.com>  <alpine.DEB.2.02.1405151144390.6261@ionos.tec.linutronix.de>  <54B7D87C.3090901@gmail.com> <1422037788.29655.0.camel@triegel.csb>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Jan 2015, Torvald Riegel wrote:
> Second, the current documentation for EINTR is that it can happen due to
> receiving a signal *or* due to a spurious wake-up.  This is difficult to

I don't think so. I went through all callchains again with a fine comb.

futex_wait()
retry:
	ret = futex_wait_setup();
	if (ret) {
		 /*
		  * Possible return codes related to uaddr:
		  * -EINVAL:    Not u32 aligned uaddr
		  * -EFAULT:    No mapping, no RW
		  * -ENOMEM:    Paging ran out of memory
		  * -EHWPOISON: Memory hardware error
		  *
		  * Others:
		  * -EWOULDBLOCK: value at uaddr has changed
		  */
		return ret;
	}

	futex_wait_queue_me();

	if (woken by futex_wake/requeue)
	   	return 0;

	if (timeout)
		return -ETIMEOUT;

	/*
	 * Spurious wakeup, i.e. no signal pending
	 */
	if (!signal_pending())
		goto retry;

	/* Handled in the low level syscall exit code */
	if (!timed_wait)
		return -ERESTARTSYS;
	else
		return -ERESTARTBLOCK;

Now in the low level syscall exit we try to deliver the signal

	if (!signal_delivered())
	      restart_syscall();

	if (sigaction->flags & SA_RESTART)
	      restart_syscall();

	ret_to_userspace -EINTR;

So we should never see -EINTR in the case of a spurious wakeup here.

But, here is the not so good news:

 I did some archaeology. The restart handling of futex_wait() got
 introduced in kernel 2.6.22, so anything older than that will have
 the spurious -EINTR issues.

futex_wait_pi() always had the restart handling and glibc folks back
then (2006) requested that it should never return -EINTR, so it
unconditionally restarts the syscall whether a signal had been
delivered or not.

So kernels >= 2.6.22 should never return -EINTR spuriously. If that
happens it's a bug and needs to be fixed.

> Third, I think it would be useful to -- somewhere -- explain which
> behavior the futex operations would have conceptually when expressed by
> C11 code.  We currently say that they wake up, sleep, etc, and which
> values they return.  But we never say how to properly synchronize with
> them on the userspace side.  The C11 memory model is probably the best
> model to use on the userspace side, so that's why I'm arguing for this.
> Basically, I think we need to (1) tell people that they should use
> memory_order_relaxed accesses to the futex variable (ie, the memory
> location associated with the whole futex construct on the kernel side --
> or do we have another name for this?), and (2) give some conceptual
> guarantees for the kernel-side synchronization so that one use this to
> derive how to use them correctly in userspace.
> 
> The man pages might not be the right place for this, and maybe we just
> need a revision of "Futexes are tricky".  If you have other suggestions
> for where to document this, or on the content, let me know.  (I'm also
> willing to spend time on this :) ).

The current futex code in the kernel has gained documentation about
the required memory ordering recently. That should be a good starting
point.

Thanks,

	tglx
