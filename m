Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752858Ab3F0Hzw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 03:55:52 -0400
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:54462 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752683Ab3F0Hzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 03:55:50 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ar0PALDuy1F5LKwQ/2dsb2JhbABbgwkxuiOFIAQBfBd0giMBAQQBOhwoCwgDGAklDwUlAyEBEogIBQ26JgQWjiKBJIMCYQOXRJFGgyMq
Date: Thu, 27 Jun 2013 17:55:43 +1000
From: Dave Chinner <david@fromorbit.com>
To: Dave Jones <davej@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrey Vagin <avagin@openvz.org>, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: frequent softlockups with 3.10rc6.
Message-ID: <20130627075543.GA32195@dastard>
References: <20130622173129.GA29375@redhat.com>
 <20130622215905.GA28238@redhat.com>
 <20130623143634.GA2000@redhat.com>
 <20130623150603.GA32313@redhat.com>
 <20130623160452.GA11740@redhat.com>
 <20130624155758.GA5993@redhat.com>
 <20130624173510.GA1321@redhat.com>
 <20130625153520.GA7784@redhat.com>
 <20130626191853.GA29049@redhat.com>
 <20130627002255.GA16553@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130627002255.GA16553@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 26, 2013 at 08:22:55PM -0400, Dave Jones wrote:
> On Wed, Jun 26, 2013 at 09:18:53PM +0200, Oleg Nesterov wrote:
>  > On 06/25, Dave Jones wrote:
>  > >
>  > > Took a lot longer to trigger this time. (13 hours of runtime).
>  > 
>  > And _perhaps_ this means that 3.10-rc7 without 8aac6270 needs more
>  > time to hit the same bug ;)
....
> What I've gathered so far:
> 
> - Only affects two machines I have (both Intel Quad core Haswell, one with SSD, one with hybrid SSD)
> - One machine is XFS, the other EXT4.
> - When the lockup occurs, it happens on all cores.
> - It's nearly always a sync() call that triggers it looking like this..
> 
>   irq event stamp: 8465043
>   hardirqs last  enabled at (8465042): [<ffffffff816ebc60>] restore_args+0x0/0x30
>   hardirqs last disabled at (8465043): [<ffffffff816f476a>] apic_timer_interrupt+0x6a/0x80
>   softirqs last  enabled at (8464292): [<ffffffff81054204>] __do_softirq+0x194/0x440
>   softirqs last disabled at (8464295): [<ffffffff8105466d>] irq_exit+0xcd/0xe0
>   RIP: 0010:[<ffffffff81054121>]  [<ffffffff81054121>] __do_softirq+0xb1/0x440
> 
>   Call Trace:
>    <IRQ> 
>    [<ffffffff8105466d>] irq_exit+0xcd/0xe0
>    [<ffffffff816f560b>] smp_apic_timer_interrupt+0x6b/0x9b
>    [<ffffffff816f476f>] apic_timer_interrupt+0x6f/0x80
>    <EOI> 
>    [<ffffffff816ebc60>] ? retint_restore_args+0xe/0xe
>    [<ffffffff810b9c56>] ? lock_acquire+0xa6/0x1f0
>    [<ffffffff811da892>] ? sync_inodes_sb+0x1c2/0x2a0
>    [<ffffffff816eaba0>] _raw_spin_lock+0x40/0x80
>    [<ffffffff811da892>] ? sync_inodes_sb+0x1c2/0x2a0
>    [<ffffffff811da892>] sync_inodes_sb+0x1c2/0x2a0
>    [<ffffffff816e8206>] ? wait_for_completion+0x36/0x110
>    [<ffffffff811e04f0>] ? generic_write_sync+0x70/0x70
>    [<ffffffff811e0509>] sync_inodes_one_sb+0x19/0x20
>    [<ffffffff811b0e62>] iterate_supers+0xb2/0x110
>    [<ffffffff811e0775>] sys_sync+0x35/0x90
>    [<ffffffff816f3d14>] tracesys+0xdd/0xe2

Is this just a soft lockup warning? Or is the system hung?

I mean, what you see here is probably sync_inodes_sb() having called
wait_sb_inodes() and is spinning on the inode_sb_list_lock.

There's nothing stopping multiple sys_sync() calls from executing on
the same superblock simulatenously, and if there's lots of cached
inodes on a single filesystem and nothing much to write back then
concurrent sync() calls will enter wait_sb_inodes() concurrently and
contend on the inode_sb_list_lock.

Get enough sync() calls running at the same time, and you'll see
this. e.g. I just ran a parallel find/stat workload over a
filesystem with 50 million inodes in it, and once that had reached a
steady state of about 2 million cached inodes in RAM:

$ for i in `seq 0 1 100`; do time sync & done
.....

real    0m38.508s
user    0m0.000s
sys     0m2.849s
$

While the syncs were running the system is essentially unresponsive.
It's takes seconds to respond to a single keypress, and it's
completely CPU bound. what is running on each CPU? from echo l >
/proc/sysrq:

[ 4864.252344] SysRq : Show backtrace of all active CPUs
[ 4864.253565] CPU0:
[ 4864.254037]  dead000000200200 ffff88003ec03f58 ffffffff817f2864 ffff88003ec03f58
[ 4864.255770]  ffff88003ec16e28 ffff88003ec03f98 ffffffff810e32fe ffff88003ec03f68
[ 4864.256010]  ffff88003ec03f68 ffff88003ec03f98 ffffffff820f53c0 0000000000004f02
[ 4864.256010] Call Trace:
[ 4864.256010]  <IRQ>  [<ffffffff817f2864>] showacpu+0x54/0x70
[ 4864.256010]  [<ffffffff810e32fe>] generic_smp_call_function_single_interrupt+0xbe/0x130
[ 4864.256010]  [<ffffffff81067577>] smp_call_function_interrupt+0x27/0x40
[ 4864.256010]  [<ffffffff81c3f15d>] call_function_interrupt+0x6d/0x80
[ 4864.256010]  <EOI>  [<ffffffff817622c1>] ? do_raw_spin_lock+0xb1/0x110
[ 4864.256010]  [<ffffffff817622c1>] ? do_raw_spin_lock+0xb1/0x110
[ 4864.256010]  [<ffffffff810b85a0>] ? try_to_wake_up+0x2f0/0x2f0
[ 4864.256010]  [<ffffffff81c358ae>] _raw_spin_lock+0x1e/0x20
[ 4864.256010]  [<ffffffff811af74c>] sync_inodes_sb+0xdc/0x200
[ 4864.256010]  [<ffffffff811b6010>] ? fdatawrite_one_bdev+0x20/0x20
[ 4864.256010]  [<ffffffff811b6029>] sync_inodes_one_sb+0x19/0x20
[ 4864.256010]  [<ffffffff8118ab59>] iterate_supers+0xe9/0xf0
[ 4864.256010]  [<ffffffff811b61f5>] sys_sync+0x35/0x90
[ 4864.256010]  [<ffffffff81c3e2d9>] system_call_fastpath+0x16/0x1b
[ 4864.256032] CPU7:
[ 4864.256032]  0000000000000000 ffff88011fd03f58 ffffffff817f2864 ffff88011fd03f58
[ 4864.256032]  ffff88011fd16e28 ffff88011fd03f98 ffffffff810e32fe ffff88011fd03f68
[ 4864.256032]  ffff88011fd03f68 ffff88011fd03f98 ffffffff820f53c0 ffff88001eea7fd8
[ 4864.256032] Call Trace:
[ 4864.256032]  <IRQ>  [<ffffffff817f2864>] showacpu+0x54/0x70
[ 4864.256032]  [<ffffffff810e32fe>] generic_smp_call_function_single_interrupt+0xbe/0x130
[ 4864.256032]  [<ffffffff81067577>] smp_call_function_interrupt+0x27/0x40
[ 4864.256032]  [<ffffffff81c3f15d>] call_function_interrupt+0x6d/0x80
[ 4864.256032]  <EOI>  [<ffffffff81144a55>] ? pagevec_lookup_tag+0x25/0x40
[ 4864.256032]  [<ffffffff81759d90>] ? delay_tsc+0x30/0xc0
[ 4864.256032]  [<ffffffff81759c9f>] __delay+0xf/0x20
[ 4864.256032]  [<ffffffff817622d5>] do_raw_spin_lock+0xc5/0x110
[ 4864.256032]  [<ffffffff81c358ae>] _raw_spin_lock+0x1e/0x20
[ 4864.256032]  [<ffffffff811af808>] sync_inodes_sb+0x198/0x200
[ 4864.256032]  [<ffffffff811b6010>] ? fdatawrite_one_bdev+0x20/0x20
[ 4864.256032]  [<ffffffff811b6029>] sync_inodes_one_sb+0x19/0x20
[ 4864.256032]  [<ffffffff8118ab59>] iterate_supers+0xe9/0xf0
[ 4864.256032]  [<ffffffff811b61f5>] sys_sync+0x35/0x90
[ 4864.256032]  [<ffffffff81c3e2d9>] system_call_fastpath+0x16/0x1b
.....

Yup, it's doing exactly what your system is doing - smashing the
inode_sb_list_lock as hard as it can scanning every cached inode in
the system to check whether it is dirty. Well, there ain't no dirty
inodes to be found, so this is just plain wasted CPU.

So, guess what I've been beating the tux3 people up over today? Their
attempt to "optimise" the lock contention problems in 
wait_sb_inodes() by providing a method for tux3 to avoid needing to
call wait_sb_inodes() rather than actually fixing the lock
contention problem. Thread here:

https://lkml.org/lkml/2013/6/26/181

I didn't realise that just calling sync caused this lock contention
problem until I read this thread, so fixing this just went up
several levels of priority given the affect an unprivileged user can
have on the system just by running lots of concurrent sync calls.

> I'll work on trying to narrow down what trinity is doing. That might at least
> make it easier to reproduce it in a shorter timeframe.

This is only occurring on your new machines, right? They have more
memory than your old machines, and faster drives? So the caches are
larger and the IO completion faster? Those combinations will put
more pressure on wait_sb_inodes() from concurrent sync operations...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
