Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758223Ab3KIAZR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 19:25:17 -0500
Received: from mail-we0-f180.google.com ([74.125.82.180]:44715 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087Ab3KIAZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 19:25:13 -0500
Date: Sat, 9 Nov 2013 01:25:10 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Dave Jones <davej@redhat.com>
Subject: Re: perf/tracepoint: another fuzzer generated lockup
Message-ID: <20131109002508.GG14606@localhost.localdomain>
References: <alpine.DEB.2.10.1311081440440.7281@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1311081504400.7281@vincent-weaver-1.um.maine.edu>
 <20131108200244.GB14606@localhost.localdomain>
 <alpine.DEB.2.10.1311081515210.16519@vincent-weaver-1.um.maine.edu>
 <20131108204839.GD14606@localhost.localdomain>
 <alpine.DEB.2.10.1311081612190.16519@vincent-weaver-1.um.maine.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1311081612190.16519@vincent-weaver-1.um.maine.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 08, 2013 at 04:15:21PM -0500, Vince Weaver wrote:
> 
> int main(int argc, char **argv) {
> /* 1 */
> /* fd = 82 */
> 
> 	memset(&pe[82],0,sizeof(struct perf_event_attr));
> 	pe[82].type=PERF_TYPE_TRACEPOINT;
> 	pe[82].size=80;
> 	pe[82].config=0x18;

I did some more testing and 0x18 on my setup is the irq_work_exit event. I tried a few
other tracepoints (tried the timer interrupt for example) but they did not trigger the issue.

And since the irq work handles the pending disable and wakeup, maybe that fiddles with some
perf state and make the NMI handler run into some buggy loop.

Perhaps that's triggered with some help of the disable ioctl.

I don't know, my bed is calling so I'll test that further tomorrow or so.

Thanks.

> 	pe[82].sample_period=0xdd95cac7b947b610;
> 	pe[82].sample_type=PERF_SAMPLE_IP|PERF_SAMPLE_TIME|PERF_SAMPLE_READ|PERF_SAMPLE_CALLCHAIN|PERF_SAMPLE_PERIOD|PERF_SAMPLE_DATA_SRC;
> //|PERF_SAMPLE_IDENTIFIER; /* 18135 */
> 	pe[82].read_format=PERF_FORMAT_TOTAL_TIME_ENABLED|PERF_FORMAT_TOTAL_TIME_RUNNING|PERF_FORMAT_ID|PERF_FORMAT_GROUP; /* f */
> 	pe[82].exclude_hv=1;
> 	pe[82].mmap=1;
> 	pe[82].comm=1;
> 	pe[82].watermark=1;
> 	pe[82].precise_ip=1; /* constant skid */
> 	pe[82].mmap_data=1;
> 	pe[82].exclude_host=1;
> 	pe[82].exclude_guest=1;
> 	pe[82].exclude_callchain_user=1;
> 	pe[82].wakeup_watermark=232;
> 	pe[82].bp_type=HW_BREAKPOINT_EMPTY;
> 	pe[82].config1=0x9;
> 	pe[82].branch_sample_type=PERF_SAMPLE_BRANCH_USER|PERF_SAMPLE_BRANCH_KERNEL|PERF_SAMPLE_BRANCH_HV|PERF_SAMPLE_BRANCH_ANY|PERF_SAMPLE_BRANCH_ANY_CALL|PERF_SAMPLE_BRANCH_ANY_RETURN|PERF_SAMPLE_BRANCH_IND_CALL;
> //|PERF_SAMPLE_BRANCH_ABORT_TX;
> 	pe[82].sample_regs_user=39;
> 	pe[82].sample_stack_user=37552;
> 
> 	fd[82]=perf_event_open(&pe[82],
> 				0, /* current thread */
> 				-1, /* all cpus */
> 				-1, /* New Group Leader */
> 				PERF_FLAG_FD_OUTPUT /*2*/ );
> 
> 
> /* 2 */
> 	mmap_result[82]=mmap(NULL, 20480,PROT_READ|PROT_WRITE, MAP_SHARED,fd[82], 0);
> /* 3 */
> 	memset(&sa, 0, sizeof(struct sigaction));
> 	sa.sa_sigaction = our_handler;
> 	sa.sa_flags = SA_SIGINFO;
> 	if (sigaction( SIGRTMIN+2, &sa, NULL) < 0) {
> 		printf("Error setting up signal handler\n");
> 	}
> 	fcntl(fd[82], F_SETFL, O_RDWR|O_NONBLOCK|O_ASYNC);
> 	fcntl(fd[82], F_SETSIG, SIGRTMIN+2);
> 	fcntl(fd[82], F_SETOWN,getpid());
> 	/* Replayed 3 syscalls */
> 	return 0;
> }

