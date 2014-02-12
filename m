Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214AbaBLVCp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 16:02:45 -0500
Received: from mail-qa0-f50.google.com ([209.85.216.50]:54933 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753820AbaBLVCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 16:02:44 -0500
Date: Wed, 12 Feb 2014 16:04:30 -0500 (EST)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Peter Zijlstra <peterz@infradead.org>
cc: Vince Weaver <vincent.weaver@maine.edu>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>
Subject: Re: x86_pmu_start WARN_ON.
In-Reply-To: <20140211132956.GY9987@twins.programming.kicks-ass.net>
Message-ID: <alpine.DEB.2.10.1402121559350.20738@vincent-weaver-1.um.maine.edu>
References: <20140130190253.GA11819@redhat.com> <alpine.DEB.2.10.1402101620170.29602@vincent-weaver-1.um.maine.edu> <20140211132956.GY9987@twins.programming.kicks-ass.net>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Feb 2014, Peter Zijlstra wrote:
> 
> I'll see if I can run through the reproduction case by hand.

I've come up with an even simpler test case with all of the extraneous 
settings removed.  Included below.

It is triggered in this case when you have:

  An event group of breakpoint, cycles, branches
  An event of instructions with precise=1
  A tracepoint

and then you close the tracepoint.

---


/* log_to_code output from ./warning29.log */
/* by Vince Weaver <vincent.weaver _at_ maine.edu */

#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <sys/syscall.h>
#include <linux/hw_breakpoint.h>
#include <linux/perf_event.h>

static int fd[1024];
static struct perf_event_attr pe[1024];

int perf_event_open(struct perf_event_attr *hw_event_uptr,
	pid_t pid, int cpu, int group_fd, unsigned long flags) {

	return syscall(__NR_perf_event_open,hw_event_uptr, pid, cpu,
		group_fd, flags);
}

int main(int argc, char **argv) {

/* Random Seed was 1392048997 */
/* /proc/sys/kernel/perf_event_max_sample_rate was 100000 */


	memset(&pe[3],0,sizeof(struct perf_event_attr));
	pe[3].type=PERF_TYPE_BREAKPOINT;
	pe[3].size=72;
	pe[3].bp_type=HW_BREAKPOINT_R|HW_BREAKPOINT_W; /*3*/
	pe[3].bp_len=0x8;

	fd[3]=perf_event_open(&pe[3],
				0, /* current thread */
				-1, /* all cpus */
				-1, /* group leader */
				0);

	memset(&pe[23],0,sizeof(struct perf_event_attr));
	pe[23].type=PERF_TYPE_HARDWARE;
	pe[23].config=PERF_COUNT_HW_INSTRUCTIONS;
	pe[23].precise_ip=1; /* this needs to be set to trigger? */

	fd[23]=perf_event_open(&pe[23],
				0, /* current thread */
				-1, /* all cpus */
				-1, /* group leader */
				0 /*0*/ );

	memset(&pe[4],0,sizeof(struct perf_event_attr));
	pe[4].type=PERF_TYPE_HARDWARE;
	pe[4].config=PERF_COUNT_HW_CPU_CYCLES;

	fd[4]=perf_event_open(&pe[4],
				0, /* current thread */
				-1, /* all cpus */
				fd[3], /* 3 is group leader */
				0 /*0*/ );


	memset(&pe[5],0,sizeof(struct perf_event_attr));
	pe[5].type=PERF_TYPE_TRACEPOINT;
	pe[5].config=0x1d;
				/* 29 irq_vectors/error_apic_entry */
				/* Config of tracepoint doesn't seem to matter */

	fd[5]=perf_event_open(&pe[5],
				0, /* current thread */
				-1, /* all cpus */
				-1, /* New Group Leader */
				0 /*0*/ );

	memset(&pe[15],0,sizeof(struct perf_event_attr));
	pe[15].type=PERF_TYPE_HARDWARE;
	pe[15].config=PERF_COUNT_HW_BRANCH_INSTRUCTIONS;

	fd[15]=perf_event_open(&pe[15],
				0, /* current thread */
				-1, /* all cpus */
				fd[3], /* 3 is group leader */
				0 /*0*/ );
	close(fd[5]);

	return 0;
}
