Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934488Ab3JPNbk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 09:31:40 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53778 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934252Ab3JPNbj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 09:31:39 -0400
Date: Wed, 16 Oct 2013 15:31:25 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Don Zickus <dzickus@redhat.com>
Cc: dave.hansen@linux.intel.com, eranian@google.com, ak@linux.intel.com,
        jmario@redhat.com, linux-kernel@vger.kernel.org, acme@infradead.org,
        mingo@kernel.org
Subject: Re: [PATCH] perf, x86: Optimize intel_pmu_pebs_fixup_ip()
Message-ID: <20131016133125.GY10651@twins.programming.kicks-ass.net>
References: <20131014203549.GY227855@redhat.com>
 <20131015101404.GD10651@twins.programming.kicks-ass.net>
 <20131015130226.GX26785@twins.programming.kicks-ass.net>
 <20131015143227.GY26785@twins.programming.kicks-ass.net>
 <20131015150736.GZ26785@twins.programming.kicks-ass.net>
 <20131015154104.GA227855@redhat.com>
 <20131016105755.GX10651@twins.programming.kicks-ass.net>
 <20131016124649.GG227855@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131016124649.GG227855@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 16, 2013 at 08:46:49AM -0400, Don Zickus wrote:
> On Wed, Oct 16, 2013 at 12:57:55PM +0200, Peter Zijlstra wrote:
> > A prettier patch below. The main difference is on-demand allocation of
> > the scratch buffer.
> 
> I'll see if I can sanity test this in the next couple hours.
> 
> Further testing yesterday showed that intel_pmu_drain_pebs_nhm still
> has long latencies somewhere.  With 15 minute reboots, isolation goes
> slooow.

Pick a smaller box? I seem to be able to reproduce on my wsm-ep, which
boots inside a minute :-)

root@westmere:~# cd /debug/tracing/
root@westmere:/debug/tracing# echo function > current_tracer
root@westmere:/debug/tracing# cat available_filter_functions | grep ^inat > set_ftrace_notrace
root@westmere:/debug/tracing# cat available_filter_functions | grep ^insn | grep -v get_length >> set_ftrace_notrace

Run: perf top --stdio -e 'cycles:pp' in another window and when the
console output shows:

[  610.319486] perf samples too long (19310 > 19230), lowering kernel.perf_event_max_sample_rate to 7000

quickly press enter here:

root@westmere:/debug/tracing# echo 0 > tracing_on
root@westmere:/debug/tracing# cat trace > ~/trace1
root@westmere:/debug/tracing# cat ~/trace1 | awk '/rcu_nmi_enter/ {
t=gensub(":", "", "g", $4); cpu=gensub("[][]", "", "g", $2);
start[cpu]=t; } /rcu_nmi_exit/ { x=gensub(":", "", "g", $4);
cpu=gensub("[][]", "", "g", $2); t=start[cpu]; printf "%6.6f -- starting
at: %6.6f on cpu: %d\n", x-t, t, cpu } ' | sort -n | tail -10
0.000037 -- starting at: 605.317795 on cpu: 9
0.000039 -- starting at: 602.831019 on cpu: 23
0.000039 -- starting at: 602.831148 on cpu: 6
0.000039 -- starting at: 602.955953 on cpu: 20
0.000040 -- starting at: 602.834012 on cpu: 18
0.000040 -- starting at: 602.956972 on cpu: 21
0.000040 -- starting at: 602.960048 on cpu: 22
0.000040 -- starting at: 609.290776 on cpu: 7
0.000075 -- starting at: 609.773875 on cpu: 0
0.009398 -- starting at: 610.319445 on cpu: 1
root@westmere:/debug/tracing# grep "\[001\]" ~/trace1 | awk 'BEGIN {p=0}
/610.319445/ {p=1} /rcu_nmi_exit/ {p=0} {if (p) print $0}'

Now obviously the whole printk stuff below is insane, but it does show
its one that triggered the check. And the trace does give a fair idea of
what its doing:

          <idle>-0     [001] d.h.   610.319445: rcu_nmi_enter <-do_nmi
          <idle>-0     [001] d.h.   610.319446: nmi_handle.isra.3 <-do_nmi
          <idle>-0     [001] d.h.   610.319447: intel_pmu_handle_irq <-perf_event_nmi_handler
          <idle>-0     [001] d.h.   610.319447: intel_pmu_disable_all <-intel_pmu_handle_irq
          <idle>-0     [001] d.h.   610.319448: intel_pmu_pebs_disable_all <-intel_pmu_disable_all
          <idle>-0     [001] d.h.   610.319448: intel_pmu_lbr_disable_all <-intel_pmu_disable_all
          <idle>-0     [001] d.h.   610.319449: intel_pmu_drain_bts_buffer <-intel_pmu_handle_irq
          <idle>-0     [001] d.h.   610.319449: intel_pmu_lbr_read <-intel_pmu_handle_irq
          <idle>-0     [001] d.h.   610.319453: intel_pmu_drain_pebs_nhm <-intel_pmu_handle_irq
          <idle>-0     [001] d.h.   610.319453: __intel_pmu_pebs_event <-intel_pmu_drain_pebs_nhm
          <idle>-0     [001] d.h.   610.319454: intel_pmu_save_and_restart <-__intel_pmu_pebs_event
          <idle>-0     [001] d.h.   610.319455: insn_get_length <-__intel_pmu_pebs_event
          <idle>-0     [001] d.h.   610.319456: insn_get_length <-__intel_pmu_pebs_event
          <idle>-0     [001] d.h.   610.319457: insn_get_length <-__intel_pmu_pebs_event
          <idle>-0     [001] d.h.   610.319458: insn_get_length <-__intel_pmu_pebs_event
          <idle>-0     [001] d.h.   610.319458: insn_get_length <-__intel_pmu_pebs_event
          <idle>-0     [001] d.h.   610.319459: insn_get_length <-__intel_pmu_pebs_event
          <idle>-0     [001] d.h.   610.319459: insn_get_length <-__intel_pmu_pebs_event
          <idle>-0     [001] d.h.   610.319460: insn_get_length <-__intel_pmu_pebs_event
          <idle>-0     [001] d.h.   610.319460: insn_get_length <-__intel_pmu_pebs_event
          <idle>-0     [001] d.h.   610.319461: insn_get_length <-__intel_pmu_pebs_event
          <idle>-0     [001] d.h.   610.319461: insn_get_length <-__intel_pmu_pebs_event
          <idle>-0     [001] d.h.   610.319462: insn_get_length <-__intel_pmu_pebs_event
          <idle>-0     [001] d.h.   610.319462: insn_get_length <-__intel_pmu_pebs_event
          <idle>-0     [001] d.h.   610.319463: insn_get_length <-__intel_pmu_pebs_event
          <idle>-0     [001] d.h.   610.319464: insn_get_length <-__intel_pmu_pebs_event
          <idle>-0     [001] d.h.   610.319464: insn_get_length <-__intel_pmu_pebs_event
          <idle>-0     [001] d.h.   610.319465: insn_get_length <-__intel_pmu_pebs_event
          <idle>-0     [001] d.h.   610.319465: insn_get_length <-__intel_pmu_pebs_event
          <idle>-0     [001] d.h.   610.319466: insn_get_length <-__intel_pmu_pebs_event
          <idle>-0     [001] d.h.   610.319466: insn_get_length <-__intel_pmu_pebs_event
          <idle>-0     [001] d.h.   610.319467: insn_get_length <-__intel_pmu_pebs_event
          <idle>-0     [001] d.h.   610.319467: insn_get_length <-__intel_pmu_pebs_event
          <idle>-0     [001] d.h.   610.319468: insn_get_length <-__intel_pmu_pebs_event
          <idle>-0     [001] d.h.   610.319469: task_tgid_nr_ns <-perf_event_pid
          <idle>-0     [001] d.h.   610.319469: __task_pid_nr_ns <-perf_event_tid
          <idle>-0     [001] d.h.   610.319470: perf_output_begin <-perf_log_throttle
          <idle>-0     [001] d.h.   610.319470: perf_output_copy <-perf_log_throttle
          <idle>-0     [001] d.h.   610.319470: perf_output_copy <-perf_event__output_id_sample
          <idle>-0     [001] d.h.   610.319471: perf_output_copy <-perf_event__output_id_sample
          <idle>-0     [001] d.h.   610.319472: perf_output_copy <-perf_event__output_id_sample
          <idle>-0     [001] d.h.   610.319472: perf_output_end <-perf_log_throttle
          <idle>-0     [001] d.h.   610.319472: perf_output_put_handle <-perf_output_end
          <idle>-0     [001] d.h.   610.319473: kvm_is_in_guest <-perf_misc_flags
          <idle>-0     [001] d.h.   610.319473: task_tgid_nr_ns <-perf_event_pid
          <idle>-0     [001] d.h.   610.319474: __task_pid_nr_ns <-perf_event_tid
          <idle>-0     [001] d.h.   610.319474: kvm_is_in_guest <-perf_instruction_pointer
          <idle>-0     [001] d.h.   610.319475: perf_output_begin <-__perf_event_overflow
          <idle>-0     [001] d.h.   610.319475: perf_output_copy <-perf_output_sample
          <idle>-0     [001] d.h.   610.319475: perf_output_copy <-perf_output_sample
          <idle>-0     [001] d.h.   610.319476: perf_output_copy <-perf_output_sample
          <idle>-0     [001] d.h.   610.319476: perf_output_copy <-perf_output_sample
          <idle>-0     [001] d.h.   610.319476: perf_output_copy <-perf_output_sample
          <idle>-0     [001] d.h.   610.319477: perf_output_copy <-perf_output_sample
          <idle>-0     [001] d.h.   610.319477: perf_output_end <-__perf_event_overflow
          <idle>-0     [001] d.h.   610.319477: perf_output_put_handle <-perf_output_end
          <idle>-0     [001] d.h.   610.319478: intel_pmu_disable_event <-x86_pmu_stop
          <idle>-0     [001] d.h.   610.319478: intel_pmu_lbr_disable <-intel_pmu_disable_event
          <idle>-0     [001] d.h.   610.319479: intel_pmu_pebs_disable <-intel_pmu_disable_event
          <idle>-0     [001] d.h.   610.319480: intel_pmu_enable_all <-intel_pmu_handle_irq
          <idle>-0     [001] d.h.   610.319480: intel_pmu_pebs_enable_all <-intel_pmu_enable_all
          <idle>-0     [001] d.h.   610.319480: intel_pmu_lbr_enable_all <-intel_pmu_enable_all
          <idle>-0     [001] d.h.   610.319481: _raw_spin_trylock <-___ratelimit
          <idle>-0     [001] d.h.   610.319482: _raw_spin_unlock_irqrestore <-___ratelimit
          <idle>-0     [001] d.h.   610.319482: printk <-perf_sample_event_took
          <idle>-0     [001] d.h.   610.319482: vprintk_emit <-printk

< snip ~8000 lines >

          <idle>-0     [001] d.h.   610.328841: wake_up_klogd <-console_unlock
          <idle>-0     [001] d.h.   610.328841: arch_irq_work_raise <-irq_work_queue
          <idle>-0     [001] d.h.   610.328842: apic_send_IPI_self <-arch_irq_work_raise
          <idle>-0     [001] d.h.   610.328842: native_apic_wait_icr_idle <-arch_irq_work_raise
          <idle>-0     [001] d.h.   610.328843: arch_trigger_all_cpu_backtrace_handler <-nmi_handle.isra.3
