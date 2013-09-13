Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755142Ab3IMLPA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 07:15:00 -0400
Received: from merlin.infradead.org ([205.233.59.134]:45093 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751964Ab3IMLO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 07:14:56 -0400
Date: Fri, 13 Sep 2013 13:14:47 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: trinity finds ftrace/perf bug. Film at 11.
Message-ID: <20130913111447.GN31370@twins.programming.kicks-ass.net>
References: <20130911135434.GA678@redhat.com>
 <20130912141913.2ffc7077@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130912141913.2ffc7077@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 12, 2013 at 02:19:13PM -0400, Steven Rostedt wrote:
> > WARNING: CPU: 3 PID: 861 at kernel/events/core.c:5566 perf_swevent_add+0x18d/0x1a0()
> > Modules linked in: ipt_ULOG nfnetlink can_bcm can scsi_transport_iscsi ax25 nfc rfkill af_802154 irda crc_ccitt rds x25 atm appletalk ipx p8023 psnap p8022 llc snd_hda_codec_realtek snd_hda_codec_hdmi xfs snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm snd_page_alloc libcrc32c snd_timer snd e1000e pcspkr ptp pps_core soundcore usb_debug
> > CPU: 3 PID: 861 Comm: trinity-child31 Not tainted 3.11.0+ #67 
> >  ffffffff81a2aa43 ffff8801e6c65ae8 ffffffff8171d5cb 0000000000000000
> >  ffff8801e6c65b20 ffffffff81053e5d ffff8801e66a2e68 ffff880245dcf3e0
> >  0000000000000004 0000000000000001 0000000004392ac6 ffff8801e6c65b30
> > Call Trace:
> >  [<ffffffff8171d5cb>] dump_stack+0x54/0x74
> >  [<ffffffff81053e5d>] warn_slowpath_common+0x7d/0xa0
> >  [<ffffffff81053f3a>] warn_slowpath_null+0x1a/0x20
> >  [<ffffffff8114302d>] perf_swevent_add+0x18d/0x1a0
> >  [<ffffffff81143ba7>] event_sched_in.isra.78+0x87/0x1c0
> >  [<ffffffff81144a9a>] group_sched_in+0x6a/0x1c0
> >  [<ffffffff8114580c>] ctx_sched_in+0x17c/0x290
> >  [<ffffffff8114595a>] perf_event_sched_in+0x3a/0x90
> >  [<ffffffff8114940b>] perf_event_context_sched_in+0x7b/0xc0
> >  [<ffffffff81149f67>] __perf_event_task_sched_in+0x477/0x490

So I've got an idea how this can happen. If we have a per-cpu swevent
and group it with an uncore counter which lives on another cpu we'll
migrate the swevent using perf_pmu_migrate_context() but it doesn't
migrate the swhash.

The below should be able to confirm that theory if one can reproduce the
issue.

---
 kernel/events/core.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 2207efc..e1441f5 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -5621,11 +5621,6 @@ static void swevent_hlist_put(struct perf_event *event)
 {
 	int cpu;
 
-	if (event->cpu != -1) {
-		swevent_hlist_put_cpu(event, event->cpu);
-		return;
-	}
-
 	for_each_possible_cpu(cpu)
 		swevent_hlist_put_cpu(event, cpu);
 }
@@ -5659,9 +5654,6 @@ static int swevent_hlist_get(struct perf_event *event)
 	int err;
 	int cpu, failed_cpu;
 
-	if (event->cpu != -1)
-		return swevent_hlist_get_cpu(event, event->cpu);
-
 	get_online_cpus();
 	for_each_possible_cpu(cpu) {
 		err = swevent_hlist_get_cpu(event, cpu);
