Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758135Ab3KOLa5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 06:30:57 -0500
Received: from mail-la0-f54.google.com ([209.85.215.54]:44192 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753624Ab3KOLat (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 06:30:49 -0500
Date: Fri, 15 Nov 2013 15:30:46 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>, Dave Jones <davej@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: perf code using smp_processor_id() in preemptible [00000000] code
Message-ID: <20131115113046.GA26143@moon>
References: <20131115032907.GA25243@redhat.com>
 <20131115100254.GC2965@twins.programming.kicks-ass.net>
 <20131115101946.GG1754@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131115101946.GG1754@moon>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 15, 2013 at 02:19:46PM +0400, Cyrill Gorcunov wrote:
> 
> Thanks for report, Dave!

Dave, could you please give the patch a shot?
---
From: Cyrill Gorcunov <gorcunov@openvz.org>
Subject: x86, perf: P4 PMU -- protect p4_pmu_schedule_events from preemption

Dave reported

 | BUG: using smp_processor_id() in preemptible [00000000] code: trinity-main/890
 | caller is p4_pmu_schedule_events+0x25/0x4c0
 | CPU: 0 PID: 890 Comm: trinity-main Not tainted 3.12.0+ #3
 | Hardware name: Dell Inc.                 Precision WorkStation 470    /0P7996, BIOS A05 05/18/2005
 | ffff88001e675668 ffff880025e79d00 ffffffff8171f332 0000000000000000
 | ffff880025e79d18 ffffffff8133132a 0000000000000002 ffff880025e79dc0
 | ffffffff81018e55 ffff88001e675668 00000000000080d0 ffff88001e675668
 |Call Trace:
 | [<ffffffff8171f332>] dump_stack+0x4e/0x7a
 | [<ffffffff8133132a>] debug_smp_processor_id+0xca/0xe0
 | [<ffffffff81018e55>] p4_pmu_schedule_events+0x25/0x4c0
 | [<ffffffff811a5c9f>] ? kmem_cache_alloc_trace+0x12f/0x2d0
 | [<ffffffff810160ff>] ? allocate_fake_cpuc+0x2f/0x90
 | [<ffffffff81016443>] x86_pmu_event_init+0x193/0x440
 | [<ffffffff81146850>] perf_init_event+0x250/0x330
 | [<ffffffff81146600>] ? perf_pmu_unregister+0x160/0x160
 | [<ffffffff81146ca8>] perf_event_alloc+0x378/0x420
 | [<ffffffff81147335>] SYSC_perf_event_open+0x5e5/0xa80
 | [<ffffffff81147b89>] SyS_perf_event_open+0x9/0x10
 | [<ffffffff81731ee4>] tracesys+0xdd/0xe2

When we schedule event we need to disable preempt. The
problem the same as fixed in commit 137351e0feeb (I simply
managed to miss this routine in first place).

Reported-by: Dave Jones <davej@redhat.com>
CC: Ingo Molnar <mingo@kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---
 arch/x86/kernel/cpu/perf_event_p4.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux-2.6.git/arch/x86/kernel/cpu/perf_event_p4.c
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/cpu/perf_event_p4.c
+++ linux-2.6.git/arch/x86/kernel/cpu/perf_event_p4.c
@@ -1207,7 +1207,7 @@ static int p4_pmu_schedule_events(struct
 {
 	unsigned long used_mask[BITS_TO_LONGS(X86_PMC_IDX_MAX)];
 	unsigned long escr_mask[BITS_TO_LONGS(P4_ESCR_MSR_TABLE_SIZE)];
-	int cpu = smp_processor_id();
+	int cpu = get_cpu();
 	struct hw_perf_event *hwc;
 	struct p4_event_bind *bind;
 	unsigned int i, thread, num;
@@ -1267,6 +1267,7 @@ reserve:
 	}
 
 done:
+	put_cpu();
 	return num ? -EINVAL : 0;
 }
 
