Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752602Ab3LXTgs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Dec 2013 14:36:48 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:34247 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752410Ab3LXTgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Dec 2013 14:36:46 -0500
Date: Tue, 24 Dec 2013 11:36:36 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mike Galbraith <bitbucket@online.de>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-rt-users@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] rcu: Eliminate softirq processing from rcutree
Message-ID: <20131224193636.GD19211@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20131221193900.GA8427@linutronix.de>
 <1387681647.5412.25.camel@marge.simpson.net>
 <1387702631.5412.101.camel@marge.simpson.net>
 <1387773533.5369.16.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387773533.5369.16.camel@marge.simpson.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13122419-0928-0000-0000-00000504C4F4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 23, 2013 at 05:38:53AM +0100, Mike Galbraith wrote:
> On Sun, 2013-12-22 at 09:57 +0100, Mike Galbraith wrote: 
> > I'll let the box give
> > RCU something to do for a couple days.  No news is good news.
> 
> Ho ho hum, merry christmas, gift attached.

Hmmm...  I guess I should take a moment to work out who has been
naughty and nice...

> I'll beat on virgin -rt7, see if it survives, then re-apply RCU patch
> and retest.  This kernel had nohz_full enabled, along with Sebastian's
> pending -rt fix for same, so RCU patch was not only not running solo,
> box was running a known somewhat buggy config as well.  Box was doing
> endless tbench 64 when it started stalling fwiw.

[72788.040872] NMI backtrace for cpu 31
[72788.040874] CPU: 31 PID: 13975 Comm: tbench Tainted: G        W    3.12.6-rt7-nohz #192
[72788.040874] Hardware name: Hewlett-Packard ProLiant DL980 G7, BIOS P66 07/07/2010
[72788.040875] task: ffff8802728e3db0 ti: ffff88026deb2000 task.ti: ffff88026deb2000
[72788.040877] RIP: 0010:[<ffffffff815e34e4>]  [<ffffffff815e34e4>] _raw_spin_trylock+0x14/0x80
[72788.040878] RSP: 0018:ffff8802769e3e58  EFLAGS: 00000002
[72788.040879] RAX: ffff88026deb3fd8 RBX: ffff880273544000 RCX: 000000007bc87bc6
[72788.040879] RDX: 0000000000000000 RSI: ffff8802728e3db0 RDI: ffff880273544000
[72788.040880] RBP: ffff88026deb39f8 R08: 0000063c14effd0f R09: 0000000000000119
[72788.040881] R10: 0000000000000005 R11: ffff8802769f2260 R12: ffff8802728e3db0
[72788.040881] R13: 000000000000001f R14: ffff8802769ebcc0 R15: ffffffff810c4730
[72788.040883] FS:  00007f7cd380a700(0000) GS:ffff8802769e0000(0000) knlGS:0000000000000000
[72788.040883] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[72788.040884] CR2: 000000000068a0e8 CR3: 0000000267ba4000 CR4: 00000000000007e0
[72788.040885] Stack:
[72788.040886]  ffff88026deb39f8 ffffffff815e2aa0 0000000000000000 ffffffff8106711a
[72788.040887]  ffff8802769ec4e0 ffff8802769ec4e0 ffff8802769e3f58 ffffffff810c44bd
[72788.040888]  ffff88026deb39f8 ffff88026deb39f8 000015ed4f5ff89b ffffffff810c476e
[72788.040889] Call Trace:
[72788.040889]  <IRQ> 
[72788.040891]  [<ffffffff815e2aa0>] ? rt_spin_lock_slowunlock_hirq+0x10/0x20
[72788.040893]  [<ffffffff8106711a>] ? update_process_times+0x3a/0x60
[72788.040895]  [<ffffffff810c44bd>] ? tick_sched_handle+0x2d/0x70
[72788.040896]  [<ffffffff810c476e>] ? tick_sched_timer+0x3e/0x70
[72788.040898]  [<ffffffff810839dd>] ? __run_hrtimer+0x13d/0x260
[72788.040900]  [<ffffffff81083c2c>] ? hrtimer_interrupt+0x12c/0x310
[72788.040901]  [<ffffffff8109593e>] ? vtime_account_system+0x4e/0xf0
[72788.040903]  [<ffffffff81035656>] ? smp_apic_timer_interrupt+0x36/0x50
[72788.040904]  [<ffffffff815ebc9d>] ? apic_timer_interrupt+0x6d/0x80
[72788.040905]  <EOI> 
[72788.040906]  [<ffffffff815e338a>] ? _raw_spin_lock+0x2a/0x40
[72788.040908]  [<ffffffff815e23b3>] ? rt_spin_lock_slowlock+0x33/0x2d0
[72788.040910]  [<ffffffff8108ee44>] ? migrate_enable+0xc4/0x220
[72788.040911]  [<ffffffff8152f888>] ? ip_finish_output+0x258/0x450
[72788.040913]  [<ffffffff81067011>] ? lock_timer_base+0x41/0x80
[72788.040914]  [<ffffffff81068db6>] ? mod_timer+0x66/0x290
[72788.040916]  [<ffffffff814df02f>] ? sk_reset_timer+0xf/0x20
[72788.040917]  [<ffffffff81547d7f>] ? tcp_write_xmit+0x1cf/0x5d0
[72788.040919]  [<ffffffff815481e5>] ? __tcp_push_pending_frames+0x25/0x60
[72788.040921]  [<ffffffff81539e34>] ? tcp_sendmsg+0x114/0xbb0
[72788.040923]  [<ffffffff814dbc1f>] ? sock_sendmsg+0xaf/0xf0
[72788.040925]  [<ffffffff811bf5e5>] ? touch_atime+0x65/0x150
[72788.040927]  [<ffffffff814dbd78>] ? SyS_sendto+0x118/0x190
[72788.040929]  [<ffffffff81095b66>] ? vtime_account_user+0x66/0x100
[72788.040930]  [<ffffffff8100f36a>] ? syscall_trace_enter+0x2a/0x260
[72788.040932]  [<ffffffff815eb249>] ? tracesys+0xdd/0xe2

The most likely suspect is the rt_spin_lock_slowlock() that is apparently
being acquired by migrate_enable().  This could be due to:

1.	Massive contention on that lock.

2.	Someone else holding that lock for excessive time periods.
	Evidence in favor: CPU 0 appears to be running within
	migrate_enable().  But isn't migrate_enable() really quite
	lightweight?

3.	Possible looping in the networking stack -- but this seems
	unlikely given that we appear to have caught a lock acquisition
	in the act.  (Not impossible, however, if there are lots of
	migrate_enable() calls in the networking stack, which there
	are due to all the per-CPU work.)

So which code do you think deserves the big lump of coal?  ;-)

							Thanx, Paul

