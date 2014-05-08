Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753458AbaEHICl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 04:02:41 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:61791 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753151AbaEHICi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 04:02:38 -0400
Date: Thu, 8 May 2014 12:02:34 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Don Zickus <dzickus@redhat.com>, Vince Weaver <vincent.weaver@maine.edu>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: perf_fuzzer crash on pentium 4
Message-ID: <20140508080234.GO8607@moon>
References: <alpine.DEB.2.10.1405061137560.3220@vincent-weaver-1.umelst.maine.edu>
 <20140506202307.GA1458@moon>
 <20140508020050.GX39568@redhat.com>
 <20140508073756.GM8607@moon>
 <20140508074930.GN8607@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140508074930.GN8607@moon>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 08, 2014 at 11:49:30AM +0400, Cyrill Gorcunov wrote:
> > Don, Vince, could you please give the patch a run? I've only compile tested
> > it obviously since I've no real p4 hw. And the patch itself is a bit ugly
> > but should bring the light if we're still having problems in events
> > scheduling.
> 
> Drop it, won't work.

Updated.
---
 arch/x86/kernel/cpu/perf_event_p4.c |   67 ++++++++++++++++--------------------
 1 file changed, 30 insertions(+), 37 deletions(-)

Index: linux-2.6.git/arch/x86/kernel/cpu/perf_event_p4.c
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/cpu/perf_event_p4.c
+++ linux-2.6.git/arch/x86/kernel/cpu/perf_event_p4.c
@@ -1063,23 +1063,23 @@ static int p4_pmu_handle_irq(struct pt_r
  * swap thread specific fields according to a thread
  * we are going to run on
  */
-static void p4_pmu_swap_config_ts(struct hw_perf_event *hwc, int cpu)
+static u64 p4_pmu_swap_config_ts(u64 config, int cpu)
 {
 	u32 escr, cccr;
 
 	/*
 	 * we either lucky and continue on same cpu or no HT support
 	 */
-	if (!p4_should_swap_ts(hwc->config, cpu))
-		return;
+	if (!p4_should_swap_ts(config, cpu))
+		return config;
 
 	/*
 	 * the event is migrated from an another logical
 	 * cpu, so we need to swap thread specific flags
 	 */
 
-	escr = p4_config_unpack_escr(hwc->config);
-	cccr = p4_config_unpack_cccr(hwc->config);
+	escr = p4_config_unpack_escr(config);
+	cccr = p4_config_unpack_cccr(config);
 
 	if (p4_ht_thread(cpu)) {
 		cccr &= ~P4_CCCR_OVF_PMI_T0;
@@ -1092,9 +1092,9 @@ static void p4_pmu_swap_config_ts(struct
 			escr &= ~P4_ESCR_T0_USR;
 			escr |= P4_ESCR_T1_USR;
 		}
-		hwc->config  = p4_config_pack_escr(escr);
-		hwc->config |= p4_config_pack_cccr(cccr);
-		hwc->config |= P4_CONFIG_HT;
+		config  = p4_config_pack_escr(escr);
+		config |= p4_config_pack_cccr(cccr);
+		config |= P4_CONFIG_HT;
 	} else {
 		cccr &= ~P4_CCCR_OVF_PMI_T1;
 		cccr |= P4_CCCR_OVF_PMI_T0;
@@ -1106,10 +1106,12 @@ static void p4_pmu_swap_config_ts(struct
 			escr &= ~P4_ESCR_T1_USR;
 			escr |= P4_ESCR_T0_USR;
 		}
-		hwc->config  = p4_config_pack_escr(escr);
-		hwc->config |= p4_config_pack_cccr(cccr);
-		hwc->config &= ~P4_CONFIG_HT;
+		config  = p4_config_pack_escr(escr);
+		config |= p4_config_pack_cccr(cccr);
+		config &= ~P4_CONFIG_HT;
 	}
+
+	return config;
 }
 
 /*
@@ -1208,9 +1210,10 @@ static int p4_pmu_schedule_events(struct
 	unsigned long used_mask[BITS_TO_LONGS(X86_PMC_IDX_MAX)];
 	unsigned long escr_mask[BITS_TO_LONGS(P4_ESCR_MSR_TABLE_SIZE)];
 	int cpu = smp_processor_id();
+	u64 config[X86_PMC_IDX_MAX];
 	struct hw_perf_event *hwc;
 	struct p4_event_bind *bind;
-	unsigned int i, thread, num;
+	unsigned int i, thread;
 	int cntr_idx, escr_idx;
 	u64 config_alias;
 	int pass;
@@ -1218,12 +1221,13 @@ static int p4_pmu_schedule_events(struct
 	bitmap_zero(used_mask, X86_PMC_IDX_MAX);
 	bitmap_zero(escr_mask, P4_ESCR_MSR_TABLE_SIZE);
 
-	for (i = 0, num = n; i < n; i++, num--) {
+	for (i = 0; i < n; i++) {
 
 		hwc = &cpuc->event_list[i]->hw;
 		thread = p4_ht_thread(cpu);
 		pass = 0;
 
+		config[i] = hwc->config;
 again:
 		/*
 		 * It's possible to hit a circular lock
@@ -1233,12 +1237,12 @@ again:
 		if (pass > 2)
 			goto done;
 
-		bind = p4_config_get_bind(hwc->config);
+		bind = p4_config_get_bind(config[i]);
 		escr_idx = p4_get_escr_idx(bind->escr_msr[thread]);
 		if (unlikely(escr_idx == -1))
 			goto done;
 
-		if (hwc->idx != -1 && !p4_should_swap_ts(hwc->config, cpu)) {
+		if (hwc->idx != -1 && !p4_should_swap_ts(config[i], cpu)) {
 			cntr_idx = hwc->idx;
 			if (assign)
 				assign[i] = hwc->idx;
@@ -1250,32 +1254,15 @@ again:
 			/*
 			 * Check whether an event alias is still available.
 			 */
-			config_alias = p4_get_alias_event(hwc->config);
+			config_alias = p4_get_alias_event(config[i]);
 			if (!config_alias)
 				goto done;
-			hwc->config = config_alias;
+			config[i] = config_alias;
 			pass++;
 			goto again;
 		}
-		/*
-		 * Perf does test runs to see if a whole group can be assigned
-		 * together succesfully.  There can be multiple rounds of this.
-		 * Unfortunately, p4_pmu_swap_config_ts touches the hwc->config
-		 * bits, such that the next round of group assignments will
-		 * cause the above p4_should_swap_ts to pass instead of fail.
-		 * This leads to counters exclusive to thread0 being used by
-		 * thread1.
-		 *
-		 * Solve this with a cheap hack, reset the idx back to -1 to
-		 * force a new lookup (p4_next_cntr) to get the right counter
-		 * for the right thread.
-		 *
-		 * This probably doesn't comply with the general spirit of how
-		 * perf wants to work, but P4 is special. :-(
-		 */
-		if (p4_should_swap_ts(hwc->config, cpu))
-			hwc->idx = -1;
-		p4_pmu_swap_config_ts(hwc, cpu);
+
+		config[i] = p4_pmu_swap_config_ts(config[i], cpu);
 		if (assign)
 			assign[i] = cntr_idx;
 reserve:
@@ -1284,7 +1271,13 @@ reserve:
 	}
 
 done:
-	return num ? -EINVAL : 0;
+	if (i == n) {
+		for (i = 0; i < n; i++)
+			cpuc->event_list[i]->hw.config = config[i];
+		return 0;
+	}
+
+	return -EINVAL;
 }
 
 PMU_FORMAT_ATTR(cccr, "config:0-31" );
