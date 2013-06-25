Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752221Ab3FYQXk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 12:23:40 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:21820 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274Ab3FYQXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 12:23:39 -0400
X-Authority-Analysis: v=2.0 cv=KtrPKBqN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=XqNnylozy48A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=pkicDPhlfI0A:10 a=QnSCNFxAoQR4iVq5zPwA:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1372177414.18733.211.camel@gandalf.local.home>
Subject: Re: frequent softlockups with 3.10rc6.
From: Steven Rostedt <rostedt@goodmis.org>
To: Dave Jones <davej@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrey Vagin <avagin@openvz.org>
Date: Tue, 25 Jun 2013 12:23:34 -0400
In-Reply-To: <20130625153520.GA7784@redhat.com>
References: <20130621151119.GA1596@redhat.com>
	 <20130621195949.GA15519@redhat.com> <20130622013731.GA22918@redhat.com>
	 <20130622173129.GA29375@redhat.com> <20130622215905.GA28238@redhat.com>
	 <20130623143634.GA2000@redhat.com> <20130623150603.GA32313@redhat.com>
	 <20130623160452.GA11740@redhat.com> <20130624155758.GA5993@redhat.com>
	 <20130624173510.GA1321@redhat.com> <20130625153520.GA7784@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-06-25 at 11:35 -0400, Dave Jones wrote:
> Took a lot longer to trigger this time. (13 hours of runtime).
> 
> This trace may still not be from the first lockup, as a flood of
> them happened at the same time. 
> 
> 
> # tracer: preemptirqsoff
> #
> # preemptirqsoff latency trace v1.1.5 on 3.10.0-rc7+
> # --------------------------------------------------------------------
> # latency: 389877255 us, #4/4, CPU#1 | (M:preempt VP:0, KP:0, SP:0 HP:0 #P:4)
> #    -----------------
> #    | task: trinity-main-9252 (uid:1000 nice:19 policy:0 rt_prio:0)
> #    -----------------
> #  => started at: vprintk_emit
> #  => ended at:   vprintk_emit
> #
> #
> #                  _------=> CPU#            
> #                 / _-----=> irqs-off        
> #                | / _----=> need-resched    
> #                || / _---=> hardirq/softirq 
> #                ||| / _--=> preempt-depth   
> #                |||| /     delay             
> #  cmd     pid   ||||| time  |   caller      
> #     \   /      |||||  \    |   /           
> trinity--9252    1dNh1    0us!: console_unlock <-vprintk_emit
> trinity--9252    1dNh1 389877255us : console_unlock <-vprintk_emit
> trinity--9252    1dNh1 389877255us+: stop_critical_timings <-vprintk_emit
> trinity--9252    1dNh1 389877261us : <stack trace>
>  => console_unlock
>  => vprintk_emit
>  => printk

This is the same as the last one, with no new info to why it started the
tracing at console_unlock :-/

Now, what we can try to do as well, is to add a trigger to disable
tracing, which should (I need to check the code) stop tracing on printk.
To do so:

# echo printk:traceoff > /sys/kernel/debug/tracing/set_ftrace_filter

This will add a trigger to the printk function that when called, will
disable tracing. If it is hit before you get your trace, you can just
re-enable tracing with:

# echo 1 > /sys/kernel/debug/tracing/tracing_on

Hmm, no it needs a fix to make this work. I applied a patch below that
should do this correctly (and will put this into my 3.11 queue).

If you run the test again with this change and with the above filter, it
should stop the trace before overwriting the first dump, as it should
ignore the printk output.

-- Steve


>  => rcu_check_callbacks
>  => update_process_times
>  => tick_sched_handle.isra.16
>  => tick_sched_timer
>  => __run_hrtimer
>  => hrtimer_interrupt
>  => smp_apic_timer_interrupt
>  => apic_timer_interrupt
>  => _raw_spin_lock
>  => evict
>  => iput
>  => dput
>  => proc_flush_task
>  => release_task
>  => wait_consider_task
>  => do_wait
>  => SyS_wait4
>  => tracesys
> 

diff --git a/kernel/trace/trace_irqsoff.c b/kernel/trace/trace_irqsoff.c
index b19d065..2aefbee 100644
--- a/kernel/trace/trace_irqsoff.c
+++ b/kernel/trace/trace_irqsoff.c
@@ -373,7 +373,7 @@ start_critical_timing(unsigned long ip, unsigned long parent_ip)
 	struct trace_array_cpu *data;
 	unsigned long flags;
 
-	if (likely(!tracer_enabled))
+	if (!tracer_enabled || !tracing_is_enabled())
 		return;
 
 	cpu = raw_smp_processor_id();
@@ -416,7 +416,7 @@ stop_critical_timing(unsigned long ip, unsigned long parent_ip)
 	else
 		return;
 
-	if (!tracer_enabled)
+	if (!tracer_enabled || !tracing_is_enabled())
 		return;
 
 	data = per_cpu_ptr(tr->trace_buffer.data, cpu);


