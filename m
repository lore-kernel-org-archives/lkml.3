Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752089Ab3IIKGB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 06:06:01 -0400
Received: from merlin.infradead.org ([205.233.59.134]:46783 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751714Ab3IIKF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 06:05:59 -0400
Date: Mon, 9 Sep 2013 12:05:44 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, eranian@googlemail.com,
        andi@firstfloor.org
Subject: Re: [GIT PULL] perf changes for v3.12
Message-ID: <20130909100544.GI31370@twins.programming.kicks-ass.net>
References: <20130903132933.GA24955@gmail.com>
 <CA+55aFxBTjfx304zstOVq3Hm3vmjgC5gOJaxXG5E_iWq_WXGTw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxBTjfx304zstOVq3Hm3vmjgC5gOJaxXG5E_iWq_WXGTw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 07, 2013 at 07:17:28PM -0700, Linus Torvalds wrote:
> This is new for me, but I suspect it is more related to the new
> Haswell CPU I have than necessarily the 3.12 perf pull request.
> 
> Regardless, nothing bad happened, but my dmesg has this in it:
> 
>    Unexpected number of pebs records 10
> 
> when I was profiling some git workloads. Full trace appended.

>  ------------[ cut here ]------------
>  WARNING: CPU: 1 PID: 3270 at
> arch/x86/kernel/cpu/perf_event_intel_ds.c:1003
> intel_pmu_drain_pebs_hsw+0x91/0xa0()
>  Unexpected number of pebs records 10
>  Modules linked in: fuse ip6t_REJECT nf_conntrack_ipv4
> nf_conntrack_ipv6 nf_defrag_ipv4 nf_defrag_ipv6 xt_conntrack
> ip6table_filter nf_conntrack ip6_tables snd_hda_codec_realtek
> snd_hda_codec_hdmi snd_hda_intel snd_hda_codec snd_hwdep snd_seq
> snd_seq_device snd_pcm e1000e serio_raw snd_page_alloc snd_timer ptp
> lpc_ich snd i2c_i801 pps_core mfd_core soundcore uinput nfsd
> auth_rpcgss nfs_acl lockd sunrpc binfmt_misc hid_logitech_dj i915
> i2c_algo_bit drm_kms_helper drm i2c_core video
>  CPU: 1 PID: 3270 Comm: git Not tainted 3.11.0-07749-ge7d33bb5ea82-dirty #4
>  Hardware name:                  /DH87RL, BIOS
> RLH8710H.86A.0317.2013.0426.1724 04/26/2013
>   0000000000000009 ffff88041fa46ca0 ffffffff815fc637 ffff88041fa46ce8
>   ffff88041fa46cd8 ffffffff81051e78 ffff88040f42f000 ffff88040f42f780
>   ffff88041fa46ef8 ffffffff81c15860 0000000000000002 ffff88041fa46d38
>  Call Trace:
>   <NMI>  [<ffffffff815fc637>] dump_stack+0x45/0x56
>   [<ffffffff81051e78>] warn_slowpath_common+0x78/0xa0
>   [<ffffffff81051ee7>] warn_slowpath_fmt+0x47/0x50
>   [<ffffffff8101b051>] intel_pmu_drain_pebs_hsw+0x91/0xa0
>   [<ffffffff8101c5d0>] intel_pmu_handle_irq+0x210/0x390
>   [<ffffffff81604deb>] perf_event_nmi_handler+0x2b/0x50
>   [<ffffffff81604670>] nmi_handle.isra.3+0x80/0x180
>   [<ffffffff81604840>] do_nmi+0xd0/0x310
>   [<ffffffff81603d37>] end_repeat_nmi+0x1e/0x2e
>   <<EOE>>  [<ffffffff810167df>] perf_events_lapic_init+0x2f/0x40
>   [<ffffffff81016a50>] x86_pmu_enable+0x260/0x310
>   [<ffffffff81111d87>] perf_pmu_enable+0x27/0x30
>   [<ffffffff81112140>] perf_event_context_sched_in+0x80/0xc0
>   [<ffffffff811127eb>] __perf_event_task_sched_in+0x16b/0x180
>   [<ffffffff8107c300>] finish_task_switch+0x70/0xa0
>   [<ffffffff81600f48>] __schedule+0x368/0x7c0
>   [<ffffffff816013c4>] schedule+0x24/0x70
>   [<ffffffff816038a4>] retint_careful+0xd/0x21
>  ---[ end trace 52dad7a9d8d96b5f ]---

So I'm not entirely sure how this can happen. We do _not_ set
ds->pebs_event_reset[] so once a PEBS assist happens we do not
automatically re-engage. We wait for the PMI to happen, consume the data
and reprogram the hardware.

We allow for up to x86_pmu.max_pebs_events (4 on hsw afaik) of PEBS
entries to be in the buffer so each PEBS capable counter can trigger the
assist once while we 'wait' for the PMI to hit.

There's a little 'funny' with the hsw PEBS code in that it doesn't
unconditionally clear the buffer in intel_pmu_drain_pebs_hsw() but that
would only make a difference if n actually was < 0 -- again something
that shouldn't ever happen.

That said, there's two peculiar things about your report. First and
foremost HSW; I'm not at all sure how it deals with a transaction being
undone if a PEBS assist had happened during it. Does it reset the
hardware but not remove the data? If so, this could cause excess
entries. 

Stephane, Andi, it this at all possible?, section 18.10.5.1 (June 2013)
seems to suggest not; the way I read it PEBS assist will cause an abort
(and the PMI certainly would) and we'll process the entire thing outside
of transaction context.

That said, 18.10.5.1 mentions that entries from inside a transaction
will only have 0xb0 and 0xb8 aka perf_record::real_ip and
perf_record::tsx_tuning set, I don't think __intel_pmu_drain_pebs_nhm()
will do the right thing for them. In particular, when no
perf_record::status bit is set we'll drop the event on the ground.

Dropping them means we do not do intel_pmu_save_and_restart() to
reprogram the hardware and the counter would get 'stuck'. Then again,
without a status bit we have no idea what event to re-program so we're
pretty much up shit creek without no stinkin' paddle.

Another possibility is that the meaning of pebs_record::status has
changed -- it was 'broken' and Peggy agreed and said she would look into
it, not sure this has been 'fixed' but I couldn't find anything on it.
That said, I think the code always assumed it was 'sane' so it having
been fixed shouldn't matter.

Secondly you seem to have triggered the nested NMI replay path. I'm not
immediately sure how that could have messed up the PEBS state, but it
sure is a complication.

I think we can do something like the below as a pure code reduction --
completely untested:

---
 arch/x86/kernel/cpu/perf_event_intel_ds.c | 109 +++++++++---------------------
 1 file changed, 32 insertions(+), 77 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index 63438aa..bfda50e 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -178,20 +178,14 @@ struct pebs_record_nhm {
 	u64 status, dla, dse, lat;
 };
 
-/*
- * Same as pebs_record_nhm, with two additional fields.
- */
 struct pebs_record_hsw {
-	struct pebs_record_nhm nhm;
-	/*
-	 * Real IP of the event. In the Intel documentation this
-	 * is called eventingrip.
-	 */
-	u64 real_ip;
-	/*
-	 * TSX tuning information field: abort cycles and abort flags.
-	 */
-	u64 tsx_tuning;
+	u64 flags, ip;
+	u64 ax, bx, cx, dx;
+	u64 si, di, bp, sp;
+	u64 r8,  r9,  r10, r11;
+	u64 r12, r13, r14, r15;
+	u64 status, dla, dse, lat;
+	u64 real_ip, tsx_tuning;
 };
 
 void init_debug_store_on_cpu(int cpu)
@@ -789,12 +783,11 @@ static void __intel_pmu_pebs_event(struct perf_event *event,
 				   struct pt_regs *iregs, void *__pebs)
 {
 	/*
-	 * We cast to pebs_record_nhm to get the load latency data
-	 * if extra_reg MSR_PEBS_LD_LAT_THRESHOLD used
+	 * We cast to the biggest pebs_record but are careful not to
+	 * unconditionally access the 'extra' entries.
 	 */
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
-	struct pebs_record_nhm *pebs = __pebs;
-	struct pebs_record_hsw *pebs_hsw = __pebs;
+	struct pebs_record_hsw *pebs = __pebs;
 	struct perf_sample_data data;
 	struct pt_regs regs;
 	u64 sample_type;
@@ -853,7 +846,7 @@ static void __intel_pmu_pebs_event(struct perf_event *event,
 	regs.sp = pebs->sp;
 
 	if (event->attr.precise_ip > 1 && x86_pmu.intel_cap.pebs_format >= 2) {
-		regs.ip = pebs_hsw->real_ip;
+		regs.ip = pebs->real_ip;
 		regs.flags |= PERF_EFLAGS_EXACT;
 	} else if (event->attr.precise_ip > 1 && intel_pmu_pebs_fixup_ip(&regs))
 		regs.flags |= PERF_EFLAGS_EXACT;
@@ -912,17 +905,34 @@ static void intel_pmu_drain_pebs_core(struct pt_regs *iregs)
 	__intel_pmu_pebs_event(event, iregs, at);
 }
 
-static void __intel_pmu_drain_pebs_nhm(struct pt_regs *iregs, void *at,
-					void *top)
+static void intel_pmu_drain_pebs_nhm(struct pt_regs *iregs)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	struct debug_store *ds = cpuc->ds;
 	struct perf_event *event = NULL;
+	void *at, *top;
 	u64 status = 0;
-	int bit;
+	int bit, n;
+
+	if (!x86_pmu.pebs_active)
+		return;
+
+	at  = (struct pebs_record_nhm *)(unsigned long)ds->pebs_buffer_base;
+	top = (struct pebs_record_nhm *)(unsigned long)ds->pebs_index;
 
 	ds->pebs_index = ds->pebs_buffer_base;
 
+	n = (top - at) / x86_pmu.pebs_record_size;
+	if (n <= 0)
+		return;
+
+	/*
+	 * Should not happen, we program the threshold at 1 and do not
+	 * set a reset value.
+	 */
+	WARN_ONCE(n > x86_pmu.max_pebs_events,
+		  "Unexpected number of pebs records %d\n", n);
+
 	for (; at < top; at += x86_pmu.pebs_record_size) {
 		struct pebs_record_nhm *p = at;
 
@@ -950,61 +960,6 @@ static void __intel_pmu_drain_pebs_nhm(struct pt_regs *iregs, void *at,
 	}
 }
 
-static void intel_pmu_drain_pebs_nhm(struct pt_regs *iregs)
-{
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
-	struct debug_store *ds = cpuc->ds;
-	struct pebs_record_nhm *at, *top;
-	int n;
-
-	if (!x86_pmu.pebs_active)
-		return;
-
-	at  = (struct pebs_record_nhm *)(unsigned long)ds->pebs_buffer_base;
-	top = (struct pebs_record_nhm *)(unsigned long)ds->pebs_index;
-
-	ds->pebs_index = ds->pebs_buffer_base;
-
-	n = top - at;
-	if (n <= 0)
-		return;
-
-	/*
-	 * Should not happen, we program the threshold at 1 and do not
-	 * set a reset value.
-	 */
-	WARN_ONCE(n > x86_pmu.max_pebs_events,
-		  "Unexpected number of pebs records %d\n", n);
-
-	return __intel_pmu_drain_pebs_nhm(iregs, at, top);
-}
-
-static void intel_pmu_drain_pebs_hsw(struct pt_regs *iregs)
-{
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
-	struct debug_store *ds = cpuc->ds;
-	struct pebs_record_hsw *at, *top;
-	int n;
-
-	if (!x86_pmu.pebs_active)
-		return;
-
-	at  = (struct pebs_record_hsw *)(unsigned long)ds->pebs_buffer_base;
-	top = (struct pebs_record_hsw *)(unsigned long)ds->pebs_index;
-
-	n = top - at;
-	if (n <= 0)
-		return;
-	/*
-	 * Should not happen, we program the threshold at 1 and do not
-	 * set a reset value.
-	 */
-	WARN_ONCE(n > x86_pmu.max_pebs_events,
-		  "Unexpected number of pebs records %d\n", n);
-
-	return __intel_pmu_drain_pebs_nhm(iregs, at, top);
-}
-
 /*
  * BTS, PEBS probe and setup
  */
@@ -1039,7 +994,7 @@ void intel_ds_init(void)
 		case 2:
 			pr_cont("PEBS fmt2%c, ", pebs_type);
 			x86_pmu.pebs_record_size = sizeof(struct pebs_record_hsw);
-			x86_pmu.drain_pebs = intel_pmu_drain_pebs_hsw;
+			x86_pmu.drain_pebs = intel_pmu_drain_pebs_nhm;
 			break;
 
 		default:
