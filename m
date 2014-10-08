Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755864AbaJHKlZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 06:41:25 -0400
Received: from casper.infradead.org ([85.118.1.10]:60679 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755831AbaJHKlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 06:41:23 -0400
Date: Wed, 8 Oct 2014 12:41:20 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Jet Chen <jet.chen@intel.com>,
        Su Tao <tao.su@intel.com>, Yuanhan Liu <yuanhan.liu@intel.com>,
        LKP <lkp@01.org>, linux-kernel@vger.kernel.org
Subject: Re: [trace events] WARNING: CPU: 0 PID: 91 at
 kernel/sched/core.c:7253 __might_sleep()
Message-ID: <20141008104120.GH10832@worktop.programming.kicks-ass.net>
References: <20141008100613.GA17869@wfg-t540p.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141008100613.GA17869@wfg-t540p.sh.intel.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 08, 2014 at 06:06:13PM +0800, Fengguang Wu wrote:
> [    8.867644] WARNING: CPU: 0 PID: 91 at kernel/sched/core.c:7253 __might_sleep+0x9a/0x378()
> [    8.869031] do not call blocking ops when !TASK_RUNNING; state=1 set at [<ffffffff8d79b511>] event_test_thread+0x48/0x93
> [    8.870533] Modules linked in:
> [    8.870979] CPU: 0 PID: 91 Comm: test-events Not tainted 3.17.0-rc7-00109-g2f85d18 #37
> [    8.872061] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    8.873428]  0000000000000000 ffff880010ec3c80 ffffffff8c696943 ffff880010ec3cb8
> [    8.874503]  ffffffff8be7cae5 ffffffff8bead236 0000000000000001 ffff88001161fa01
> [    8.888390]  0000000000000001 0000000000000000 ffff880010ec3d20 ffffffff8be7cb46
> [    8.890628] Call Trace:
> [    8.890978]  [<ffffffff8c696943>] dump_stack+0x19/0x1b
> [    8.891689]  [<ffffffff8be7cae5>] warn_slowpath_common+0x8f/0xa8
> [    8.892535]  [<ffffffff8bead236>] ? __might_sleep+0x9a/0x378
> [    8.893307]  [<ffffffff8be7cb46>] warn_slowpath_fmt+0x48/0x50
> [    8.894083]  [<ffffffff8be0dd55>] ? sched_clock+0x9/0xd
> [    8.894797]  [<ffffffff8d79b511>] ? event_test_thread+0x48/0x93
> [    8.895602]  [<ffffffff8d79b511>] ? event_test_thread+0x48/0x93
> [    8.896421]  [<ffffffff8bead236>] __might_sleep+0x9a/0x378
> [    8.897164]  [<ffffffff8c6a0227>] down_read+0x26/0x98
> [    8.897855]  [<ffffffff8be8f503>] exit_signals+0x27/0x1c2
> [    8.898598]  [<ffffffff8be7fedd>] do_exit+0x193/0x10bd
> [    8.899298]  [<ffffffff8bfd1969>] ? kfree+0x4a0/0x4d7
> [    8.900028]  [<ffffffff8d79b4c9>] ? event_trace_self_tests+0x6d7/0x6d7
> [    8.900946]  [<ffffffff8d79b4c9>] ? event_trace_self_tests+0x6d7/0x6d7
> [    8.914871]  [<ffffffff8bea4b65>] kthread+0x156/0x156
> [    8.915571]  [<ffffffff8c69c0f8>] ? wait_for_common+0x3e/0x224
> [    8.916381]  [<ffffffff8bea4a0f>] ? insert_kthread_work+0xe7/0xe7
> [    8.917203]  [<ffffffff8c6a353a>] ret_from_fork+0x7a/0xb0
> [    8.917937]  [<ffffffff8bea4a0f>] ? insert_kthread_work+0xe7/0xe7
> [    8.918800] ---[ end trace 14d02ef17adbc114 ]---


Steve, wth is that thing supposed to do?

	set_current_state(TASK_INTERRUPTIBLE);
	while (!kthread_should_stop())
		schedule();

That looks broken alright. It'll revert to a yield() 'spin' loop if it
ever gets a wakeup for anything other than the kthread_stop().

Did you mean to write something like:

	set_current_state(TASK_INTERRUPTIBLE);
	while (!kthread_should_stop()) {
		schedule();
		set_current_state(TASK_INTERRUPTIBLE);
	}
	__set_current_state(TASK_RUNNING);

?
