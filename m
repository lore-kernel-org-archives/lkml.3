Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755258Ab3HAMra (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 08:47:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3585 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754785Ab3HAMr3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 08:47:29 -0400
Date: Thu, 1 Aug 2013 14:46:58 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 6/8] perf: Account freq events per cpu
Message-ID: <20130801124658.GC1032@krava.brq.redhat.com>
References: <1374539466-4799-1-git-send-email-fweisbec@gmail.com>
 <1374539466-4799-7-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374539466-4799-7-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 23, 2013 at 02:31:04AM +0200, Frederic Weisbecker wrote:
> This is going to be used by the full dynticks subsystem
> as a finer-grained information to know when to keep and
> when to stop the tick.
> 
> Original-patch-by: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Jiri Olsa <jolsa@redhat.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Cc: Stephane Eranian <eranian@google.com>
> ---
>  kernel/events/core.c |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index b40c3db..f9bd39b 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -141,6 +141,7 @@ enum event_type_t {
>  struct static_key_deferred perf_sched_events __read_mostly;
>  static DEFINE_PER_CPU(atomic_t, perf_cgroup_events);
>  static DEFINE_PER_CPU(atomic_t, perf_branch_stack_events);
> +static DEFINE_PER_CPU(atomic_t, perf_freq_events);
>  
>  static atomic_t nr_mmap_events __read_mostly;
>  static atomic_t nr_comm_events __read_mostly;
> @@ -3139,6 +3140,9 @@ static void unaccount_event_cpu(struct perf_event *event, int cpu)
>  	}
>  	if (is_cgroup_event(event))
>  		atomic_dec(&per_cpu(perf_cgroup_events, cpu));
> +
> +	if (event->attr.freq)
> +		atomic_dec(&per_cpu(perf_freq_events, cpu));
>  }
>  
>  static void unaccount_event(struct perf_event *event)
> @@ -6473,6 +6477,9 @@ static void account_event_cpu(struct perf_event *event, int cpu)
>  	}
>  	if (is_cgroup_event(event))
>  		atomic_inc(&per_cpu(perf_cgroup_events, cpu));
> +
> +	if (event->attr.freq)
> +		atomic_inc(&per_cpu(perf_freq_events, cpu));

cpu could be -1 in here.. getting:

[  178.901881] BUG: unable to handle kernel paging request at 0000000f001cf45a
[  178.901989] IP: [<ffffffff8110c32b>] account_event_cpu+0xbb/0xd0
[  178.901989] PGD 751a5067 PUD 0 
[  178.901989] Oops: 0002 [#2] PREEMPT SMP 
[  178.901989] Modules linked in:
[  178.901989] CPU: 0 PID: 1309 Comm: perf Tainted: G      D W    3.11.0-rc3+ #281
[  178.901989] Hardware name: Intel Corporation Montevina platform/To be filled by O.E.M., BIOS AMVACRB1.86C.0066.B00.0805070703 05/07/2008
[  178.901989] task: ffff88007519e5c0 ti: ffff880074c08000 task.ti: ffff880074c08000
[  178.901989] RIP: 0010:[<ffffffff8110c32b>]  [<ffffffff8110c32b>] account_event_cpu+0xbb/0xd0
[  178.901989] RSP: 0018:ffff880074c09e38  EFLAGS: 00010216
[  178.901989] RAX: 0000000f001cf45a RBX: ffff880074c1a800 RCX: 0000000000100000
[  178.901989] RDX: 000000000000002c RSI: 000000000000002c RDI: ffff880000120400
[  178.901989] RBP: ffff880074c09e48 R08: 0000000000000000 R09: 00000000ffffffff
[  178.901989] R10: 0000000000000000 R11: 0000000000000000 R12: ffffffffffffffff
[  178.901989] R13: ffff880074c0e640 R14: 00000000ffffffff R15: 0000000000000000
[  178.901989] FS:  00007fc670738980(0000) GS:ffff88007a600000(0000) knlGS:0000000000000000
[  178.901989] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  178.901989] CR2: 0000000f001cf45a CR3: 00000000751a8000 CR4: 00000000000407f0
[  178.901989] Stack:
[  178.901989]  ffff880074c1a800 ffff880074c09ee8 ffff880074c09e68 ffffffff8110c3b6
[  178.901989]  00000000ffffffff ffff880074c1a800 ffff880074c09f78 ffffffff81113ae8
[  178.901989]  0000000000000000 0000000000000001 ffff880074c09eb8 ffffffff00000060
[  178.901989] Call Trace:
[  178.901989]  [<ffffffff8110c3b6>] account_event.part.66+0x76/0xa0
[  178.901989]  [<ffffffff81113ae8>] SyS_perf_event_open+0x678/0xdf0
[  178.901989]  [<ffffffff8100ed42>] ? syscall_trace_leave+0xb2/0x240
[  178.901989]  [<ffffffff81641512>] tracesys+0xd0/0xd5
[  178.901989] Code: d4 48 c7 c0 28 f4 1c 00 48 03 04 d5 80 ad ce 81 f0 ff 00 f6 83 c9 00 00 00 04 74 a7 48 c7 c0 4c f4 1c 00 4a 03 04 e5 80 ad ce 81 <f0> ff 00 5b 41 5c 5d c3 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 
[  178.901989] RIP  [<ffffffff8110c32b>] account_event_cpu+0xbb/0xd0
[  178.901989]  RSP <ffff880074c09e38>
[  178.901989] CR2: 0000000f001cf45a
[  179.122749] ---[ end trace 6f2f4f69b01368fb ]---


jirka
