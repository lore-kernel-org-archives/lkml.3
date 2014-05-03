Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752860AbaECOfP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2014 10:35:15 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:59227 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751548AbaECOfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2014 10:35:12 -0400
Date: Sat, 3 May 2014 07:35:06 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [GIT PULL] tracing: Use rcu_dereference_sched() for trace event
 triggers
Message-ID: <20140503143506.GA13234@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140502232218.64273fdd@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140502232218.64273fdd@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14050314-8236-0000-0000-00000207F5D3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 02, 2014 at 11:22:18PM -0400, Steven Rostedt wrote:
> 
> Linus,
> 
> This is a small fix where the trigger code used the wrong
> rcu_dereference(). It required rcu_dereference_sched() instead of
> the normal rcu_dereference(). It produces a nasty RCU lockdep splat
> due to the incorrect rcu notation.
> 
> Please pull the latest trace-fixes-v3.15-rc3 tree, which can be found at:
> 
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
> trace-fixes-v3.15-rc3
> 
> Tag SHA1: c06df51860503b3a39a8f37ddaaa047fd51f8201
> Head SHA1: 561a4fe851ccab9dd0d14989ab566f9392d9f8b5
> 
> 
> Steven Rostedt (Red Hat) (1):
>       tracing: Use rcu_dereference_sched() for trace event triggers
> 
> ----
>  kernel/trace/trace_events_trigger.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> ---------------------------
> commit 561a4fe851ccab9dd0d14989ab566f9392d9f8b5
> Author: Steven Rostedt (Red Hat) <rostedt@goodmis.org>

Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> Date:   Fri May 2 13:30:04 2014 -0400
> 
>     tracing: Use rcu_dereference_sched() for trace event triggers
>     
>     As trace event triggers are now part of the mainline kernel, I added
>     my trace event trigger tests to my test suite I run on all my kernels.
>     Now these tests get run under different config options, and one of
>     those options is CONFIG_PROVE_RCU, which checks under lockdep that
>     the rcu locking primitives are being used correctly. This triggered
>     the following splat:
>     
>     ===============================
>     [ INFO: suspicious RCU usage. ]
>     3.15.0-rc2-test+ #11 Not tainted
>     -------------------------------
>     kernel/trace/trace_events_trigger.c:80 suspicious rcu_dereference_check() usage!
>     
>     other info that might help us debug this:
>     
>     rcu_scheduler_active = 1, debug_locks = 0
>     4 locks held by swapper/1/0:
>      #0:  ((&(&j_cdbs->work)->timer)){..-...}, at: [<ffffffff8104d2cc>] call_timer_fn+0x5/0x1be
>      #1:  (&(&pool->lock)->rlock){-.-...}, at: [<ffffffff81059856>] __queue_work+0x140/0x283
>      #2:  (&p->pi_lock){-.-.-.}, at: [<ffffffff8106e961>] try_to_wake_up+0x2e/0x1e8
>      #3:  (&rq->lock){-.-.-.}, at: [<ffffffff8106ead3>] try_to_wake_up+0x1a0/0x1e8
>     
>     stack backtrace:
>     CPU: 1 PID: 0 Comm: swapper/1 Not tainted 3.15.0-rc2-test+ #11
>     Hardware name:                  /DG965MQ, BIOS MQ96510J.86A.0372.2006.0605.1717 06/05/2006
>      0000000000000001 ffff88007e083b98 ffffffff819f53a5 0000000000000006
>      ffff88007b0942c0 ffff88007e083bc8 ffffffff81081307 ffff88007ad96d20
>      0000000000000000 ffff88007af2d840 ffff88007b2e701c ffff88007e083c18
>     Call Trace:
>      <IRQ>  [<ffffffff819f53a5>] dump_stack+0x4f/0x7c
>      [<ffffffff81081307>] lockdep_rcu_suspicious+0x107/0x110
>      [<ffffffff810ee51c>] event_triggers_call+0x99/0x108
>      [<ffffffff810e8174>] ftrace_event_buffer_commit+0x42/0xa4
>      [<ffffffff8106aadc>] ftrace_raw_event_sched_wakeup_template+0x71/0x7c
>      [<ffffffff8106bcbf>] ttwu_do_wakeup+0x7f/0xff
>      [<ffffffff8106bd9b>] ttwu_do_activate.constprop.126+0x5c/0x61
>      [<ffffffff8106eadf>] try_to_wake_up+0x1ac/0x1e8
>      [<ffffffff8106eb77>] wake_up_process+0x36/0x3b
>      [<ffffffff810575cc>] wake_up_worker+0x24/0x26
>      [<ffffffff810578bc>] insert_work+0x5c/0x65
>      [<ffffffff81059982>] __queue_work+0x26c/0x283
>      [<ffffffff81059999>] ? __queue_work+0x283/0x283
>      [<ffffffff810599b7>] delayed_work_timer_fn+0x1e/0x20
>      [<ffffffff8104d3a6>] call_timer_fn+0xdf/0x1be^M
>      [<ffffffff8104d2cc>] ? call_timer_fn+0x5/0x1be
>      [<ffffffff81059999>] ? __queue_work+0x283/0x283
>      [<ffffffff8104d823>] run_timer_softirq+0x1a4/0x22f^M
>      [<ffffffff8104696d>] __do_softirq+0x17b/0x31b^M
>      [<ffffffff81046d03>] irq_exit+0x42/0x97
>      [<ffffffff81a08db6>] smp_apic_timer_interrupt+0x37/0x44
>      [<ffffffff81a07a2f>] apic_timer_interrupt+0x6f/0x80
>      <EOI>  [<ffffffff8100a5d8>] ? default_idle+0x21/0x32
>      [<ffffffff8100a5d6>] ? default_idle+0x1f/0x32
>      [<ffffffff8100ac10>] arch_cpu_idle+0xf/0x11
>      [<ffffffff8107b3a4>] cpu_startup_entry+0x1a3/0x213
>      [<ffffffff8102a23c>] start_secondary+0x212/0x219
>     
>     The cause is that the triggers are protected by rcu_read_lock_sched() but
>     the data is dereferenced with rcu_dereference() which expects it to
>     be protected with rcu_read_lock(). The proper reference should be
>     rcu_dereference_sched().
>     
>     Cc: Tom Zanussi <tom.zanussi@linux.intel.com>
>     Cc: stable@vger.kernel.org # 3.14+
>     Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> 
> diff --git a/kernel/trace/trace_events_trigger.c b/kernel/trace/trace_events_trigger.c
> index 925f537..4747b47 100644
> --- a/kernel/trace/trace_events_trigger.c
> +++ b/kernel/trace/trace_events_trigger.c
> @@ -77,7 +77,7 @@ event_triggers_call(struct ftrace_event_file *file, void *rec)
>  			data->ops->func(data);
>  			continue;
>  		}
> -		filter = rcu_dereference(data->filter);
> +		filter = rcu_dereference_sched(data->filter);
>  		if (filter && !filter_match_preds(filter, rec))
>  			continue;
>  		if (data->cmd_ops->post_trigger) {
> 

