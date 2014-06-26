Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755619AbaFZHhV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 03:37:21 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:44398 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754061AbaFZHhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 03:37:19 -0400
Message-ID: <1403768234.5948.14.camel@marge.simpson.net>
Subject: Re: [RFC PATCH V2] rt/aio: fix rcu garbage collection might_sleep()
 splat
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Benjamin LaHaise <bcrl@kvack.org>
Cc: Kent Overstreet <kmo@daterainc.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        RT <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Thu, 26 Jun 2014 09:37:14 +0200
In-Reply-To: <20140625152445.GS23137@kvack.org>
References: <1402216538.31630.7.camel@marge.simpson.net>
	 <5395172E.4010007@cn.fujitsu.com>
	 <1402372048.5124.20.camel@marge.simpson.net>
	 <20140610175001.GF27015@kvack.org> <20140612202602.GI10871@kmo-pixel>
	 <20140625152445.GS23137@kvack.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben,

On Wed, 2014-06-25 at 11:24 -0400, Benjamin LaHaise wrote:

> I finally have some time to look at this patch in detail.  I'd rather do the 
> below variant that does what Kent suggested.  Mike, can you confirm that 
> this fixes the issue you reported?  It's on top of my current aio-next tree 
> at git://git.kvack.org/~bcrl/aio-next.git .  If that's okay, I'll queue it 
> up.  Does this bug fix need to end up in -stable kernels as well or would it 
> end up in the -rt tree?

It's an -rt specific problem, so presumably any fix would only go into
-rt trees until it manages to get merged.

I knew intervening change wasn't likely to fix the might_sleep() splat
up, but did the test anyway with fixed up CONFIG_PREEMPT_RT_BASE typo.
schedule_work() leads to an rtmutex, so -rt still has to ship that out
from under rcu_read_lock_sched().

marge:/usr/local/src/kernel/linux-3.14-rt # quilt applied|tail
patches/mm-memcg-make-refill_stock-use-get_cpu_light.patch
patches/printk-fix-lockdep-instrumentation-of-console_sem.patch
patches/aio-block-io_destroy-until-all-context-requests-are-completed.patch
patches/fs-aio-Remove-ctx-parameter-in-kiocb_cancel.patch
patches/aio-report-error-from-io_destroy-when-threads-race-in-io_destroy.patch
patches/aio-cleanup-flatten-kill_ioctx.patch
patches/aio-fix-aio-request-leak-when-events-are-reaped-by-userspace.patch
patches/aio-fix-kernel-memory-disclosure-in-io_getevents-introduced-in-v3.10.patch
patches/aio-change-exit_aio-to-load-mm-ioctx_table-once-and-avoid-rcu_read_lock.patch
patches/rt-aio-fix-rcu-garbage-collection-might_sleep-splat-ben.patch

[  191.057656] BUG: sleeping function called from invalid context at kernel/locking/rtmutex.c:792
[  191.057672] in_atomic(): 1, irqs_disabled(): 0, pid: 22, name: rcuc/0
[  191.057674] 2 locks held by rcuc/0/22:
[  191.057684]  #0:  (rcu_callback){.+.+..}, at: [<ffffffff810ceb87>] rcu_cpu_kthread+0x2d7/0x840
[  191.057691]  #1:  (rcu_read_lock_sched){.+.+..}, at: [<ffffffff812e52f6>] percpu_ref_kill_rcu+0xa6/0x1c0
[  191.057694] Preemption disabled at:[<ffffffff810cebca>] rcu_cpu_kthread+0x31a/0x840
[  191.057695] 
[  191.057698] CPU: 0 PID: 22 Comm: rcuc/0 Tainted: GF       W    3.14.8-rt5 #47
[  191.057699] Hardware name: MEDIONPC MS-7502/MS-7502, BIOS 6.00 PG 12/26/2007
[  191.057704]  ffff88007c5d8000 ffff88007c5d7c98 ffffffff815696ed 0000000000000000
[  191.057708]  ffff88007c5d7cb8 ffffffff8108c3e5 ffff88007dc0e120 000000000000e120
[  191.057711]  ffff88007c5d7cd8 ffffffff8156f404 ffff88007dc0e120 ffff88007dc0e120
[  191.057712] Call Trace:
[  191.057716]  [<ffffffff815696ed>] dump_stack+0x4e/0x9c
[  191.057720]  [<ffffffff8108c3e5>] __might_sleep+0x105/0x180
[  191.057723]  [<ffffffff8156f404>] rt_spin_lock+0x24/0x70
[  191.057727]  [<ffffffff81078897>] queue_work_on+0x67/0x1a0
[  191.057731]  [<ffffffff81216fc2>] free_ioctx_users+0x72/0x80
[  191.057734]  [<ffffffff812e5404>] percpu_ref_kill_rcu+0x1b4/0x1c0
[  191.057737]  [<ffffffff812e52f6>] ? percpu_ref_kill_rcu+0xa6/0x1c0
[  191.057740]  [<ffffffff812e5250>] ? percpu_ref_kill_and_confirm+0x70/0x70
[  191.057742]  [<ffffffff810cebca>] rcu_cpu_kthread+0x31a/0x840
[  191.057745]  [<ffffffff810ceb87>] ? rcu_cpu_kthread+0x2d7/0x840
[  191.057749]  [<ffffffff8108a76d>] smpboot_thread_fn+0x1dd/0x340
[  191.057752]  [<ffffffff8156c45a>] ? schedule+0x2a/0xa0
[  191.057755]  [<ffffffff8108a590>] ? smpboot_register_percpu_thread+0x100/0x100
[  191.057758]  [<ffffffff81081ca6>] kthread+0xd6/0xf0
[  191.057761]  [<ffffffff81081bd0>] ? __kthread_parkme+0x70/0x70
[  191.057764]  [<ffffffff815780bc>] ret_from_fork+0x7c/0xb0
[  191.057767]  [<ffffffff81081bd0>] ? __kthread_parkme+0x70/0x70


