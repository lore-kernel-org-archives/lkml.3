Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753838Ab3KLJ2t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 04:28:49 -0500
Received: from www.linutronix.de ([62.245.132.108]:45528 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751595Ab3KLJ2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 04:28:45 -0500
Date: Tue, 12 Nov 2013 10:28:38 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Mike Galbraith <bitbucket@online.de>
cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        RT <linux-rt-users@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Sebastian Sewior <bigeasy@linutronix.de>
Subject: Re: CONFIG_NO_HZ_FULL + CONFIG_PREEMPT_RT_FULL = nogo
In-Reply-To: <1384243595.15180.63.camel@marge.simpson.net>
Message-ID: <alpine.DEB.2.02.1311121024590.30673@ionos.tec.linutronix.de>
References: <1383228427.5272.36.camel@marge.simpson.net>  <alpine.DEB.2.02.1311061842160.23353@ionos.tec.linutronix.de>  <1383794799.5441.16.camel@marge.simpson.net>  <1383798668.5441.25.camel@marge.simpson.net>  <alpine.DEB.2.02.1311071158350.23353@ionos.tec.linutronix.de>
  <20131107125923.GB24644@localhost.localdomain>  <alpine.DEB.2.02.1311071402380.23353@ionos.tec.linutronix.de> <1384243595.15180.63.camel@marge.simpson.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Nov 2013, Mike Galbraith wrote:
> FYI, shiny new (and virgin) 3.12.0-rt1 nohz_full config is deadlock
> prone.  I was measuring fastpath cost yesterday with pinned pipe-test.. 
> 
> x3550 M3 E5620 (bloatware config)
> CONFIG_NO_HZ_IDLE - CPU3
> 2.957012 usecs/loop -- avg 2.957012 676.4 KHz     1.000
> 
> CONFIG_NO_HZ_FULL - CPU1 != nohz_full
> 3.735279 usecs/loop -- avg 3.735279 535.4 KHz      .791
> 
> CONFIG_NO_HZ_FULL - CPU3 == nohz_full
> 5.922986 usecs/loop -- avg 5.922986 337.7 KHz      .499
> 
> (ow)
> 
> ..and noticed box eventually deadlocks, if it boots, which the instance
> below didn't.
 
> --- <RT exception stack> ---
> #11 [ffff88017b243e90] _raw_spin_lock at ffffffff815d2596
> #12 [ffff88017b243e90] rt_mutex_trylock at ffffffff815d15be
> #13 [ffff88017b243eb0] get_next_timer_interrupt at ffffffff81063b42
> #14 [ffff88017b243f00] tick_nohz_stop_sched_tick at ffffffff810bd1fd
> #15 [ffff88017b243f70] tick_nohz_irq_exit at ffffffff810bd7d2
> #16 [ffff88017b243f90] irq_exit at ffffffff8105b02d
> #17 [ffff88017b243fb0] reschedule_interrupt at ffffffff815db3dd
> --- <IRQ stack> ---
> #18 [ffff88017a2a9bc8] reschedule_interrupt at ffffffff815db3dd
>     [exception RIP: task_blocks_on_rt_mutex+51]
>     RIP: ffffffff810c1ed3  RSP: ffff88017a2a9c78  RFLAGS: 00000296
>     RAX: 0000000000080000  RBX: 0000000000000001  RCX: 0000000000000000
>     RDX: ffff88017a27d5a0  RSI: ffff88017a2a9d00  RDI: ffff880179ef8000
>     RBP: ffff880179ef8000   R8: ffff880179cfef50   R9: ffff880179ef8018
>     R10: ffff880179cfef51  R11: 0000000000000002  R12: 0000000000000001
>     R13: 0000000000000001  R14: 0000000100000000  R15: 0000000100000000
>     ORIG_RAX: ffffffffffffff02  CS: 0010  SS: 0018
> #19 [ffff88017a2a9ce0] rt_spin_lock_slowlock at ffffffff815d183c

Grr....
 
     raw_spin_lock(&lock->wait_lock);

Ditto in rt_mutex_slowtrylock()

Thanks,

	tglx
