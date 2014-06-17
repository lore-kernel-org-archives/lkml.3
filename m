Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965467AbaFQVVS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 17:21:18 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:37924 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964976AbaFQVVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 17:21:12 -0400
Date: Tue, 17 Jun 2014 16:26:52 -0500
From: Calvin Owens <jcalvinowens@gmail.com>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: tty/vt: Lockdep splat when Magic Sysrq SAK invoked
Message-ID: <20140617212652.GA21424@gmail.com>
References: <20130621223711.GA1686@gmail.com>
 <538C8D0C.3050801@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <538C8D0C.3050801@hurleysoftware.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 06/02 at 10:41 -0400, Peter Hurley wrote:
> Hi Calvin,
> 
> On 06/21/2013 06:37 PM, Calvin Owens wrote:
> > Hello all,
> >
> > I get the following lockdep splat when I invoke the "ALT+SYSRQ+K"
> > combination on the keyboard. It usually happens the first time, but
> > doing it repeatedly always triggers it.

Sorry for not getting back to you sooner: I managed to break my GMail
filter for dumping LKML messages addressed to me into my inbox...

> I know this is a year old but I believe this is fixed.
> 
> Could you confirm that you no longer can reproduce a lockdep report
> invoking SAK on 3.12+?

That's correct, it is fixed.

> Regards,
> Peter Hurley
> 
> > [  175.523980] SysRq : SAK
> > [  175.524066] SAK: killed process 1629 (agetty): task_session(p)==tty->session
> > [  178.213640] SysRq : SAK
> > [  178.213745] SAK: killed process 1648 (agetty): task_session(p)==tty->session
> > [  179.154891] SysRq : SAK
> > [  179.154981] SAK: killed process 1649 (agetty): task_session(p)==tty->session
> > [  180.409357] SysRq : SAK
> > [  180.409429] SAK: killed process 1650 (agetty): task_session(p)==tty->session
> > [  181.102312] SysRq : SAK
> > [  181.102400] SAK: killed process 1651 (agetty): task_session(p)==tty->session
> > [  181.866974] SysRq : SAK
> > [  181.867057] SAK: killed process 1652 (agetty): task_session(p)==tty->session
> > [  182.929591] SysRq : SAK
> > [  182.929665] SAK: killed process 1653 (agetty): task_session(p)==tty->session
> > [  184.221174] ======================================================
> > [  184.221174] [ INFO: possible circular locking dependency detected ]
> > [  184.221175] 3.10.0-rc6-newinteloldnohz-00136-gf71194a #3 Not tainted
> > [  184.221176] -------------------------------------------------------
> > [  184.221177] kworker/0:1/78 is trying to acquire lock:
> > [  184.221182]  (console_lock){+.+.+.}, at: [<ffffffff812f25a0>] do_con_write.part.25+0x40/0x1ed0
> > [  184.221182]
> > but task is already holding lock:
> > [  184.221185]  (&ldata->echo_lock){+.+...}, at: [<ffffffff812dd422>] process_echoes+0x62/0x310
> > [  184.221185]
> > which lock already depends on the new lock.
> >
> > [  184.221186]
> > the existing dependency chain (in reverse order) is:
> > [  184.221187]
> > -> #1 (&ldata->echo_lock){+.+...}:
> > [  184.221190]        [<ffffffff81095987>] lock_acquire+0x57/0x70
> > [  184.221193]        [<ffffffff816bbaa2>] mutex_lock_nested+0x62/0x400
> > [  184.221194]        [<ffffffff812deb73>] reset_buffer_flags+0x53/0x120
> > [  184.221195]        [<ffffffff812dec58>] n_tty_flush_buffer+0x18/0x40
> > [  184.221197]        [<ffffffff812e2a91>] tty_ldisc_flush+0x31/0x50
> > [  184.221198]        [<ffffffff812da047>] __do_SAK+0x27/0x2b0
> > [  184.221199]        [<ffffffff812e7feb>] vc_SAK+0x2b/0x40
> > [  184.221201]        [<ffffffff8105fa4a>] process_one_work+0x1ca/0x480
> > [  184.221203]        [<ffffffff8106015b>] worker_thread+0x11b/0x370
> > [  184.221204]        [<ffffffff810682f6>] kthread+0xd6/0xe0
> > [  184.221205]        [<ffffffff816c0a6c>] ret_from_fork+0x7c/0xb0
> > [  184.221206]
> > -> #0 (console_lock){+.+.+.}:
> > [  184.221208]        [<ffffffff810951d8>] __lock_acquire+0x1ae8/0x1d50
> > [  184.221209]        [<ffffffff81095987>] lock_acquire+0x57/0x70
> > [  184.221211]        [<ffffffff810432af>] console_lock+0x6f/0x80
> > [  184.221212]        [<ffffffff812f25a0>] do_con_write.part.25+0x40/0x1ed0
> > [  184.221213]        [<ffffffff812f4464>] con_put_char+0x34/0x40
> > [  184.221214]        [<ffffffff812da7bf>] tty_put_char+0x1f/0x40
> > [  184.221215]        [<ffffffff812dd1bd>] do_output_char+0x7d/0x210
> > [  184.221217]        [<ffffffff812dd537>] process_echoes+0x177/0x310
> > [  184.221218]        [<ffffffff812dfac2>] n_tty_receive_buf+0xa12/0x1570
> > [  184.221219]        [<ffffffff812e3716>] flush_to_ldisc+0x116/0x160
> > [  184.221220]        [<ffffffff8105fa4a>] process_one_work+0x1ca/0x480
> > [  184.221221]        [<ffffffff8106015b>] worker_thread+0x11b/0x370
> > [  184.221222]        [<ffffffff810682f6>] kthread+0xd6/0xe0
> > [  184.221223]        [<ffffffff816c0a6c>] ret_from_fork+0x7c/0xb0
> > [  184.221223]
> > other info that might help us debug this:
> >
> > [  184.221223]  Possible unsafe locking scenario:
> >
> > [  184.221224]        CPU0                    CPU1
> > [  184.221224]        ----                    ----
> > [  184.221224]   lock(&ldata->echo_lock);
> > [  184.221225]                                lock(console_lock);
> > [  184.221226]                                lock(&ldata->echo_lock);
> > [  184.221226]   lock(console_lock);
> > [  184.221226]
> >   *** DEADLOCK ***
> >
> > [  184.221227] 4 locks held by kworker/0:1/78:
> > [  184.221229]  #0:  (events){.+.+.+}, at: [<ffffffff8105f9ed>] process_one_work+0x16d/0x480
> > [  184.221231]  #1:  ((&buf->work)){+.+...}, at: [<ffffffff8105f9ed>] process_one_work+0x16d/0x480
> > [  184.221233]  #2:  (&ldata->output_lock){+.+...}, at: [<ffffffff812dd40d>] process_echoes+0x4d/0x310
> > [  184.221234]  #3:  (&ldata->echo_lock){+.+...}, at: [<ffffffff812dd422>] process_echoes+0x62/0x310
> > [  184.221235]
> > stack backtrace:
> > [  184.221236] CPU: 0 PID: 78 Comm: kworker/0:1 Not tainted 3.10.0-rc6-newinteloldnohz-00136-gf71194a #3
> > [  184.221237] Hardware name: ASUSTeK COMPUTER INC. K55A/K55A, BIOS K55A.404 08/20/2012
> > [  184.221238] Workqueue: events flush_to_ldisc
> > [  184.221241]  ffffffff8259f260 ffff8801199038c8 ffffffff816b77ab ffff880119903918
> > [  184.221242]  ffffffff816b4dd7 0000000000000001 ffff8801199039a0 ffff88011a34e970
> > [  184.221243]  ffff88011a34eff8 ffff88011a34e970 ffff88011a34f020 ffffffff8259f260
> > [  184.221244] Call Trace:
> > [  184.221245]  [<ffffffff816b77ab>] dump_stack+0x19/0x1b
> > [  184.221248]  [<ffffffff816b4dd7>] print_circular_bug+0x1fb/0x20c
> > [  184.221249]  [<ffffffff810951d8>] __lock_acquire+0x1ae8/0x1d50
> > [  184.221251]  [<ffffffff81095987>] lock_acquire+0x57/0x70
> > [  184.221252]  [<ffffffff812f25a0>] ? do_con_write.part.25+0x40/0x1ed0
> > [  184.221253]  [<ffffffff810432af>] console_lock+0x6f/0x80
> > [  184.221254]  [<ffffffff812f25a0>] ? do_con_write.part.25+0x40/0x1ed0
> > [  184.221255]  [<ffffffff812f25a0>] do_con_write.part.25+0x40/0x1ed0
> > [  184.221257]  [<ffffffff816bbd36>] ? mutex_lock_nested+0x2f6/0x400
> > [  184.221258]  [<ffffffff8109216d>] ? trace_hardirqs_on_caller+0xfd/0x1c0
> > [  184.221259]  [<ffffffff812f4464>] con_put_char+0x34/0x40
> > [  184.221261]  [<ffffffff812da7bf>] tty_put_char+0x1f/0x40
> > [  184.221262]  [<ffffffff812dd1bd>] do_output_char+0x7d/0x210
> > [  184.221263]  [<ffffffff812dd537>] process_echoes+0x177/0x310
> > [  184.221265]  [<ffffffff812dfac2>] n_tty_receive_buf+0xa12/0x1570
> > [  184.221266]  [<ffffffff81091fb2>] ? mark_held_locks+0x72/0x130
> > [  184.221267]  [<ffffffff816bf6f5>] ? _raw_spin_unlock_irqrestore+0x65/0x80
> > [  184.221269]  [<ffffffff8109216d>] ? trace_hardirqs_on_caller+0xfd/0x1c0
> > [  184.221270]  [<ffffffff812e3716>] flush_to_ldisc+0x116/0x160
> > [  184.221271]  [<ffffffff8105fa4a>] process_one_work+0x1ca/0x480
> > [  184.221272]  [<ffffffff8105f9ed>] ? process_one_work+0x16d/0x480
> > [  184.221273]  [<ffffffff8106015b>] worker_thread+0x11b/0x370
> > [  184.221274]  [<ffffffff81060040>] ? rescuer_thread+0x300/0x300
> > [  184.221275]  [<ffffffff810682f6>] kthread+0xd6/0xe0
> > [  184.221276]  [<ffffffff816bf73b>] ? _raw_spin_unlock_irq+0x2b/0x60
> > [  184.221277]  [<ffffffff81068220>] ? __kthread_unpark+0x50/0x50
> > [  184.221278]  [<ffffffff816c0a6c>] ret_from_fork+0x7c/0xb0
> > [  184.221279]  [<ffffffff81068220>] ? __kthread_unpark+0x50/0x50
> 
> 
