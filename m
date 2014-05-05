Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932476AbaEENbW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 09:31:22 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:48911 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932352AbaEENbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 09:31:20 -0400
Date: Mon, 5 May 2014 15:31:13 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: linux-kernel@vger.kernel.org, mingo@kernel.org, hpa@zytor.com,
        paulmck@linux.vnet.ibm.com, fweisbec@gmail.com,
        akpm@linux-foundation.org, khilman@linaro.org, tglx@linutronix.de,
        axboe@fb.com
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:timers/nohz] nohz: Move full nohz kick to its own IPI
Message-ID: <20140505133113.GD1429@laptop.programming.kicks-ass.net>
References: <tip-72aacf0259bb7d53b7a3b5b2f7bf982acaa52b61@git.kernel.org>
 <20140505123706.GP17778@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140505123706.GP17778@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 05, 2014 at 02:37:06PM +0200, Peter Zijlstra wrote:
> On Wed, Apr 16, 2014 at 12:40:01AM -0700, tip-bot for Frederic Weisbecker wrote:
> > Commit-ID:  72aacf0259bb7d53b7a3b5b2f7bf982acaa52b61
> > Gitweb:     http://git.kernel.org/tip/72aacf0259bb7d53b7a3b5b2f7bf982acaa52b61
> > Author:     Frederic Weisbecker <fweisbec@gmail.com>
> > AuthorDate: Tue, 18 Mar 2014 21:12:53 +0100
> > Committer:  Frederic Weisbecker <fweisbec@gmail.com>
> > CommitDate: Thu, 3 Apr 2014 18:05:21 +0200
> > 
> > nohz: Move full nohz kick to its own IPI
> > 
> > Now that we have smp_queue_function_single() which can be used to
> > safely queue IPIs when interrupts are disabled and without worrying
> > about concurrent callers, lets use it for the full dynticks kick to
> > notify a CPU that it's exiting single task mode.
> > 
> > This unbloats a bit the scheduler IPI that the nohz code was abusing
> > for its cool "callable anywhere/anytime" properties.
> > 
> > Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: Ingo Molnar <mingo@kernel.org>
> > Cc: Jens Axboe <axboe@fb.com>
> > Cc: Kevin Hilman <khilman@linaro.org>
> > Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > Cc: Peter Zijlstra <peterz@infradead.org>
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> 
> So I suspect this is the patch that makes Ingo's machines unhappy, they
> appear to get stuck thusly:
> 
> [10513.382910] RIP: 0010:[<ffffffff8112b7da>]  [<ffffffff8112b7da>] generic_exec_single+0x9a/0x180
> 
> [10513.481704]  [<ffffffff8112c092>] smp_queue_function_single+0x42/0xa0
> [10513.488251]  [<ffffffff81126ce0>] tick_nohz_full_kick_cpu+0x50/0x80
> [10513.494661]  [<ffffffff810f4b0e>] enqueue_task_fair+0x59e/0x6c0
> [10513.506469]  [<ffffffff810e3d6a>] enqueue_task+0x3a/0x60
> [10513.511836]  [<ffffffff810e8ac3>] __migrate_task+0x123/0x150
> [10513.523535]  [<ffffffff810e8b0d>] migration_cpu_stop+0x1d/0x30
> [10513.529401]  [<ffffffff81143460>] cpu_stopper_thread+0x70/0x120
> 
> I'm not entirely sure how yet, but this is by far the most likely
> candidate. Ingo, if you still have the vmlinuz matching this trace (your
> hang2.txt) could you have a peek where that RIP lands?
> 
> If that is indeed the csd_lock() function, then this is it and
> something's buggered.

On a kernel build from your .config the +0x9a is indeed very close to
that wait loop; of course 0x9a isn't even an instruction boundary for me
so its all a bit of a guess.
