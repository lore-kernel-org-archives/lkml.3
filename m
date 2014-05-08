Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752766AbaEHHiD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 03:38:03 -0400
Received: from mail-lb0-f172.google.com ([209.85.217.172]:56538 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751853AbaEHHiA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 03:38:00 -0400
Date: Thu, 8 May 2014 11:37:56 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Don Zickus <dzickus@redhat.com>, Vince Weaver <vincent.weaver@maine.edu>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: perf_fuzzer crash on pentium 4
Message-ID: <20140508073756.GM8607@moon>
References: <alpine.DEB.2.10.1405061137560.3220@vincent-weaver-1.umelst.maine.edu>
 <20140506202307.GA1458@moon>
 <20140508020050.GX39568@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140508020050.GX39568@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 07, 2014 at 10:00:50PM -0400, Don Zickus wrote:
> 
> I think my commit 13beacee817d27a40ffc6f065ea0042685611dd5 explains this
> corruption.  Though I have to admit I haven't looked through the problem
> very closely yet.
> 
> IOW my lazy fix in that commit doesn't cover fuzzers and the real problem
> in p4_pmu_schedule_events. :-)

Don, Vince, could you please give the patch a run? I've only compile tested
it obviously since I've no real p4 hw. And the patch itself is a bit ugly
but should bring the light if we're still having problems in events
scheduling.
---
 arch/x86/kernel/cpu/perf_event_p4.c |   61 +++++++++++++++---------------------
 1 file changed, 27 insertions(+), 34 deletions(-)

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
@@ -1208,6 +1210,7 @@ static int p4_pmu_schedule_events(struct
 	unsigned long used_mask[BITS_TO_LONGS(X86_PMC_IDX_MAX)];
 	unsigned long escr_mask[BITS_TO_LONGS(P4_ESCR_MSR_TABLE_SIZE)];
 	int cpu = smp_processor_id();
+	u64 config[X86_PMC_IDX_MAX];
 	struct hw_perf_event *hwc;
 	struct p4_event_bind *bind;
 	unsigned int i, thread, num;
@@ -1233,12 +1236,13 @@ again:
 		if (pass > 2)
 			goto done;
 
-		bind = p4_config_get_bind(hwc->config);
+		config[i] = hwc->config;
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
@@ -1284,6 +1271,12 @@ reserve:
 	}
 
 done:
+	if (num == 0) {
+		for (i = 0; i < n; i++, num--) {
+			hwc = &cpuc->event_list[i]->hw;
+			hwc->config = config[i];
+		}
+	}
 	return num ? -EINVAL : 0;
 }
 
