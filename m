Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934153AbaE3RXd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 13:23:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39844 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933202AbaE3RXc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 13:23:32 -0400
Date: Fri, 30 May 2014 19:23:27 +0200
From: Jan Kara <jack@suse.cz>
To: Jet Chen <jet.chen@intel.com>
Cc: Jan Kara <jack@suse.cz>, Jet Chen <jet.chen@intel.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Yuanhan Liu <yuanhan.liu@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Sasha Levin <sasha.levin@oracle.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [prink]  BUG: spinlock lockup suspected on CPU#0, swapper/1
Message-ID: <20140530172327.GF2419@quack.suse.cz>
References: <538808FD.3060707@intel.com>
 <20140530155051.GD2419@quack.suse.cz>
 <20140530161647.GD11096@twins.programming.kicks-ass.net>
 <20140530161948.GZ13658@twins.programming.kicks-ass.net>
 <20140530165810.GE2419@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140530165810.GE2419@quack.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 30-05-14 18:58:10, Jan Kara wrote:
> On Fri 30-05-14 18:19:48, Peter Zijlstra wrote:
> > On Fri, May 30, 2014 at 06:16:47PM +0200, Peter Zijlstra wrote:
> > > On Fri, May 30, 2014 at 05:50:51PM +0200, Jan Kara wrote:
> > > > > [    7.492350] ======================================================
> > > > > [    7.492350] [ INFO: possible circular locking dependency detected ]
> > > > > [    7.492350] 3.15.0-rc5-00567-gbafe980 #1 Not tainted
> > > > > [    7.492350] -------------------------------------------------------
> > > > > [    7.492350] swapper/1 is trying to acquire lock:
> > > > > [    7.492350]  (&irq_desc_lock_class){-.-...}, at: [<8107dc8c>] __irq_get_desc_lock+0x3c/0x70
> > > > > [    7.492350] 
> > > > > [    7.492350] but task is already holding lock:
> > > > > [    7.492350]  (&port_lock_key){......}, at: [<815f5b27>] serial8250_startup+0x337/0x720
> > > > > [    7.492350] 
> > > > > [    7.492350] which lock already depends on the new lock.
> > > > > [    7.492350] 
> > > > > [    7.492350] 
> > > > > [    7.492350] the existing dependency chain (in reverse order) is:
> > > > > [    7.492350] 
> > > > > -> #2 (&port_lock_key){......}:
> > > > > [    7.492350]        [<810750e5>] lock_acquire+0x85/0x190
> > > > > [    7.492350]        [<81baed9d>] _raw_spin_lock_irqsave+0x4d/0x60
> > > > > [    7.492350]        [<8106eb1c>] down_trylock+0xc/0x30
> > > > > [    7.492350]        [<8107b795>] console_trylock+0x15/0xb0
> > > > > [    7.492350]        [<8107be8f>] vprintk_emit+0x14f/0x4d0
> > > > > [    7.492350]        [<81b969b9>] printk+0x38/0x3a
> > > > > [    7.492350]        [<82137f78>] print_ICs+0x5b/0x3e7
> > > > > [    7.492350]        [<8212bb41>] do_one_initcall+0x8b/0x128
> > > > > [    7.492350]        [<8212bd7d>] kernel_init_freeable+0x19f/0x236
> > > > > [    7.492350]        [<81b9238b>] kernel_init+0xb/0xd0
> > > > > [    7.492350]        [<81bb0080>] ret_from_kernel_thread+0x20/0x30
> > > >
> > > >   But this looks really strange. How can we possibly get port_lock_key in
> > > > down_trylock() which calls raw_spin_lock_irqsave() on console_sem->lock?
> > > > That looks like some strange lockdep key aliasing issue? Peter do you have
> > > > any idea?
> > > 
> > > No, strange that, I can't say I've ever seen a bogus stracktrace in
> > > lockdep reports like this.
> > > 
> > > So this is through: check_prev_add()->save_trace(). And that doesn't
> > > reuse entries, at worst it can truncate a trace when we run out of
> > > entries, but the above looks complete since it terminates in
> > > lock_acquire(), which is the right place to be.
> > > 
> > > But its worse than that, the above trace should link i8259A_lock to
> > > port_lock_key, and I can't see where we would have taken i8259A_lock
> > > either.
> > 
> > Oh, wait, I missed it, that would be: print_ICs()->print_PIC(), it takes
> > that lock there.
>   Yeah, so as much as the lockdep reported stack trace looks strange I can
> now see how a locking problem lockdep reports can happen. We really do call
> printk() under i8259A_lock in print_PIC() and so the locking chain lockdep
> found is real. Luckily it likely cannot lead to any real problems because
> printk only happens during early init.
> 
> In any case it is another example of a problem that was just uncovered by
> my change which increased lockdep coverage of printk code. I'll send a fix
> to x86 maintainers.
  Jet, can you please test the attached patch? Thanks!

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
