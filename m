Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932433AbaD1OnR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 10:43:17 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:58436 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756054AbaD1OnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 10:43:14 -0400
Message-ID: <1398696191.14475.14.camel@marge.simpson.net>
Subject: Re: [ANNOUNCE] 3.14-rt1
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Nicholas Mc Guire <der.herr@hofr.at>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, John Kacur <jkacur@redhat.com>
Date: Mon, 28 Apr 2014 16:43:11 +0200
In-Reply-To: <1398695832.14475.10.camel@marge.simpson.net>
References: <20140411185739.GA6644@linutronix.de>
	 <1397918766.5436.16.camel@marge.simpson.net>
	 <1398411635.11930.45.camel@marge.simpson.net>
	 <1398501491.12941.5.camel@marge.simpson.net>
	 <1398520699.28726.22.camel@marge.simpson.net>
	 <1398661784.30930.33.camel@marge.simpson.net>
	 <1398676186.30930.49.camel@marge.simpson.net>
	 <20140428101805.75032f45@gandalf.local.home>
	 <1398695832.14475.10.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-04-28 at 16:37 +0200, Mike Galbraith wrote: 
> On Mon, 2014-04-28 at 10:18 -0400, Steven Rostedt wrote: 
> > On Mon, 28 Apr 2014 11:09:46 +0200
> > Mike Galbraith <umgwanakikbuti@gmail.com> wrote:
> >  
> > > migrate_disable-pushd-down-in-atomic_dec_and_spin_lo.patch
> > > 
> > > bug: migrate_disable() after blocking is too late.
> > > 
> > > @@ -1028,12 +1028,12 @@ int atomic_dec_and_spin_lock(atomic_t *a
> > >         /* Subtract 1 from counter unless that drops it to 0 (ie. it was 1) */
> > >         if (atomic_add_unless(atomic, -1, 1))
> > >                 return 0;
> > > -       migrate_disable();
> > >         rt_spin_lock(lock);
> > > -       if (atomic_dec_and_test(atomic))
> > > +       if (atomic_dec_and_test(atomic)){
> > > +               migrate_disable();
> > 
> > Makes sense, as the CPU can go offline right after the lock is grabbed
> > and before the migrate_disable() is called.
> > 
> > Seems that migrate_disable() must be called before taking the lock as
> > it is done in every other location.
> 
> And for tasklist_lock, seems you also MUST do that prior to trylock as
> well, else you'll run afoul of the hotplug beast.

This lockdep gripe is from the deadlocked crashdump with only the
clearly busted bits patched up.

[  193.033224] ======================================================
[  193.033225] [ INFO: possible circular locking dependency detected ]
[  193.033227] 3.12.18-rt25 #19 Not tainted
[  193.033227] -------------------------------------------------------
[  193.033228] boot.kdump/5422 is trying to acquire lock:
[  193.033237]  (&hp->lock){+.+...}, at: [<ffffffff81044974>] pin_current_cpu+0x84/0x1d0
[  193.033238] 
               but task is already holding lock:
[  193.033241]  (tasklist_lock){+.+...}, at: [<ffffffff81046a5b>] do_wait+0xbb/0x2a0
[  193.033242] 
               which lock already depends on the new lock.
               
[  193.033242] 
               the existing dependency chain (in reverse order) is:
[  193.033244] 
               -> #1 (tasklist_lock){+.+...}:
[  193.033248]        [<ffffffff810ae4a8>] check_prevs_add+0xf8/0x180
[  193.033250]        [<ffffffff810aeada>] validate_chain.isra.45+0x5aa/0x750
[  193.033252]        [<ffffffff810af4f6>] __lock_acquire+0x3f6/0x9f0
[  193.033253]        [<ffffffff810b01bc>] lock_acquire+0x8c/0x160
[  193.033257]        [<ffffffff8155e99c>] rt_write_lock+0x2c/0x40
[  193.033260]        [<ffffffff81548169>] _cpu_down+0x219/0x440
[  193.033261]        [<ffffffff815483c0>] cpu_down+0x30/0x50
[  193.033264]        [<ffffffff813711dc>] cpu_subsys_offline+0x1c/0x30
[  193.033267]        [<ffffffff8136c2d5>] device_offline+0x95/0xc0
[  193.033269]        [<ffffffff8136c3e0>] online_store+0x40/0x80
[  193.033271]        [<ffffffff81369813>] dev_attr_store+0x13/0x30
[  193.033274]        [<ffffffff811c8820>] sysfs_write_file+0xf0/0x170
[  193.033277]        [<ffffffff8115a068>] vfs_write+0xc8/0x1d0
[  193.033279]        [<ffffffff8115a500>] SyS_write+0x50/0xa0
[  193.033282]        [<ffffffff81566ca2>] system_call_fastpath+0x16/0x1b
[  193.033284] 
               -> #0 (&hp->lock){+.+...}:
[  193.033286]        [<ffffffff810ae39d>] check_prev_add+0x7bd/0x7d0
[  193.033287]        [<ffffffff810ae4a8>] check_prevs_add+0xf8/0x180
[  193.033289]        [<ffffffff810aeada>] validate_chain.isra.45+0x5aa/0x750
[  193.033291]        [<ffffffff810af4f6>] __lock_acquire+0x3f6/0x9f0
[  193.033293]        [<ffffffff810b01bc>] lock_acquire+0x8c/0x160
[  193.033295]        [<ffffffff8155e6a5>] rt_spin_lock+0x55/0x70
[  193.033296]        [<ffffffff81044974>] pin_current_cpu+0x84/0x1d0
[  193.033299]        [<ffffffff81079ef1>] migrate_disable+0x81/0x100
[  193.033301]        [<ffffffff8155e947>] rt_read_lock+0x47/0x60
[  193.033303]        [<ffffffff81046a5b>] do_wait+0xbb/0x2a0
[  193.033305]        [<ffffffff8104777e>] SyS_wait4+0x9e/0x100
[  193.033307]        [<ffffffff81566ca2>] system_call_fastpath+0x16/0x1b
[  193.033307] 
               other info that might help us debug this:
               
[  193.033308]  Possible unsafe locking scenario:
               
[  193.033309]        CPU0                    CPU1
[  193.033309]        ----                    ----
[  193.033310]   lock(tasklist_lock);
[  193.033312]                                lock(&hp->lock);
[  193.033313]                                lock(tasklist_lock);
[  193.033314]   lock(&hp->lock);
[  193.033315] 
                *** DEADLOCK ***
               
[  193.033316] 1 lock held by boot.kdump/5422:
[  193.033319]  #0:  (tasklist_lock){+.+...}, at: [<ffffffff81046a5b>] do_wait+0xbb/0x2a0
[  193.033320] 
               stack backtrace:
[  193.033322] CPU: 0 PID: 5422 Comm: boot.kdump Not tainted 3.12.18-rt25 #19
[  193.033323] Hardware name: MEDIONPC MS-7502/MS-7502, BIOS 6.00 PG 12/26/2007
[  193.033326]  ffff880200550818 ffff8802004e5ad8 ffffffff8155538c 0000000000000000
[  193.033328]  0000000000000000 ffff8802004e5b28 ffffffff8154d0df ffff8802004e5b18
[  193.033330]  ffff8802004e5b50 ffff880200550818 ffff8802005507e0 ffff880200550818
[  193.033331] Call Trace:
[  193.033335]  [<ffffffff8155538c>] dump_stack+0x4f/0x91
[  193.033337]  [<ffffffff8154d0df>] print_circular_bug+0xd3/0xe4
[  193.033339]  [<ffffffff810ae39d>] check_prev_add+0x7bd/0x7d0
[  193.033342]  [<ffffffff8107e1f5>] ? sched_clock_local+0x25/0x90
[  193.033344]  [<ffffffff8107e388>] ? sched_clock_cpu+0xa8/0x120
[  193.033346]  [<ffffffff810ae4a8>] check_prevs_add+0xf8/0x180
[  193.033348]  [<ffffffff810aeada>] validate_chain.isra.45+0x5aa/0x750
[  193.033350]  [<ffffffff810af4f6>] __lock_acquire+0x3f6/0x9f0
[  193.033352]  [<ffffffff8155da11>] ? rt_spin_lock_slowlock+0x231/0x280
[  193.033354]  [<ffffffff8155d911>] ? rt_spin_lock_slowlock+0x131/0x280
[  193.033356]  [<ffffffff81044974>] ? pin_current_cpu+0x84/0x1d0
[  193.033358]  [<ffffffff810b01bc>] lock_acquire+0x8c/0x160
[  193.033360]  [<ffffffff81044974>] ? pin_current_cpu+0x84/0x1d0
[  193.033362]  [<ffffffff8155e6a5>] rt_spin_lock+0x55/0x70
[  193.033363]  [<ffffffff81044974>] ? pin_current_cpu+0x84/0x1d0
[  193.033365]  [<ffffffff81044974>] pin_current_cpu+0x84/0x1d0
[  193.033367]  [<ffffffff81079ef1>] migrate_disable+0x81/0x100
[  193.033369]  [<ffffffff8155e947>] rt_read_lock+0x47/0x60
[  193.033371]  [<ffffffff81046a5b>] ? do_wait+0xbb/0x2a0
[  193.033373]  [<ffffffff8155cd39>] ? schedule+0x29/0x90
[  193.033374]  [<ffffffff81046a5b>] do_wait+0xbb/0x2a0
[  193.033378]  [<ffffffff8112ded6>] ? might_fault+0x56/0xb0
[  193.033380]  [<ffffffff8104777e>] SyS_wait4+0x9e/0x100
[  193.033382]  [<ffffffff81566cc7>] ? sysret_check+0x1b/0x56
[  193.033384]  [<ffffffff81045d50>] ? task_stopped_code+0xa0/0xa0
[  193.033386]  [<ffffffff81566ca2>] system_call_fastpath+0x16/0x1b
[  193.033845] SMP alternatives: lockdep: fixing up alternatives


