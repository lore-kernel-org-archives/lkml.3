Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966106Ab3E2TN5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 15:13:57 -0400
Received: from mail-vb0-f43.google.com ([209.85.212.43]:44048 "EHLO
	mail-vb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965810Ab3E2TNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 15:13:50 -0400
Date: Wed, 29 May 2013 15:18:32 -0400 (EDT)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Peter Zijlstra <peterz@infradead.org>
cc: Vince Weaver <vincent.weaver@maine.edu>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        trinity@vger.kernel.org
Subject: Re: OOPS in perf_mmap_close()
In-Reply-To: <20130529074433.GB12193@twins.programming.kicks-ass.net>
Message-ID: <alpine.DEB.2.10.1305291516310.2609@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.10.1305221953370.11450@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1305222344060.12929@vincent-weaver-1.um.maine.edu> <20130523044803.GA25399@ZenIV.linux.org.uk> <20130523125218.GB23650@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1305231006280.17701@vincent-weaver-1.um.maine.edu> <20130523152611.GE23650@twins.programming.kicks-ass.net> <alpine.DEB.2.10.1305231936210.2452@vincent-weaver-1.um.maine.edu> <20130528085548.GA12193@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1305281217370.19080@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1305281418120.19080@vincent-weaver-1.um.maine.edu> <20130529074433.GB12193@twins.programming.kicks-ass.net>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 May 2013, Peter Zijlstra wrote:
> 
> Hurm.. I don't suppose you have an easy reproducer handy eh? I'll go
> stare at it. At least the current state is better than before, but
> clearly we're not quite there yet.

OK, below is an easy reproducer.  Just run it two or three times.
It leaks 129 pages in user->locked_vm each time you run it.

It took me a while to bisect this down from 10,000 syscalls to just 3.
I now have a tool that can generate valid perf test_cases from my fuzzer 
traces, which should be useful.

Vince

/* log_to_code output from bisect19.log */
/* by Vince Weaver <vincent.weaver _at_ maine.edu */

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <sys/mman.h>
#include <sys/syscall.h>
#include <sys/ioctl.h>
#include <linux/hw_breakpoint.h>
#include <linux/perf_event.h>

int fd[1024];
struct perf_event_attr pe[1024];
char *mmap_result[1024];

int perf_event_open(struct perf_event_attr *hw_event_uptr,
	pid_t pid, int cpu, int group_fd, unsigned long flags) {

	return syscall(__NR_perf_event_open,hw_event_uptr, pid, cpu,
		group_fd, flags);
}

int main(int argc, char **argv) {

	memset(&pe[7],0,sizeof(struct perf_event_attr));
	pe[7].type=PERF_TYPE_BREAKPOINT;
	pe[7].size=96;
	pe[7].config=0x0;
	pe[7].sample_type=0; /* 0 */
	pe[7].read_format=PERF_FORMAT_ID; /* 4 */
	pe[7].inherit=1;
	pe[7].pinned=1;
	pe[7].exclusive=1;
	pe[7].exclude_idle=1;
	pe[7].mmap=1;
	pe[7].comm=1;
	pe[7].task=1;
	pe[7].precise_ip=3; /* must have zero skid */
	pe[7].exclude_host=1;
	pe[7].wakeup_events=1886953739;
	pe[7].bp_type=HW_BREAKPOINT_R|HW_BREAKPOINT_W; /*3*/
	pe[7].bp_addr=0x60ac86c7;
	pe[7].bp_len=0x1;

	fd[7]=perf_event_open(&pe[7],0,0,-1,0 /*0*/ );

	mmap_result[7]=mmap(NULL, 129*4096,PROT_READ|PROT_WRITE, MAP_SHARED,fd[7], 0);
	if (mmap_result[7]==MAP_FAILED) {
		printf("MMAP FAILED!\n");
		exit(1);
	}

	memset(&pe[8],0,sizeof(struct perf_event_attr));
	pe[8].type=PERF_TYPE_HARDWARE;
	pe[8].size=96;
	pe[8].config=PERF_COUNT_HW_BUS_CYCLES;
	pe[8].sample_type=0; /* 0 */
	pe[8].read_format=PERF_FORMAT_ID; /* 4 */
	pe[8].disabled=1;
	pe[8].inherit=1;
	pe[8].pinned=1;
	pe[8].exclude_kernel=1;
	pe[8].comm=1;
	pe[8].watermark=1;
	pe[8].precise_ip=0; /* arbitrary skid */
	pe[8].sample_id_all=1;
	pe[8].exclude_guest=1;
	pe[8].wakeup_watermark=1153443849;
	pe[8].bp_type=HW_BREAKPOINT_EMPTY;

	fd[8]=perf_event_open(&pe[8],0,0,fd[7],PERF_FLAG_FD_NO_GROUP|PERF_FLAG_FD_OUTPUT /*3*/ );

	/* Replayed 3 syscalls */
	return 0;
}
