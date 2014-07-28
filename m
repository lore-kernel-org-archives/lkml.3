Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751085AbaG1DUZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2014 23:20:25 -0400
Received: from mga01.intel.com ([192.55.52.88]:3164 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750817AbaG1DUY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2014 23:20:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,746,1400050800"; 
   d="scan'208";a="576320504"
Message-ID: <53D5C174.80303@intel.com>
Date: Mon, 28 Jul 2014 11:20:20 +0800
From: "Yan, Zheng" <zheng.z.yan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        mingo@kernel.org, acme@infradead.org, eranian@google.com
Subject: Re: [PATCH v3 6/9] perf, x86: handle multiple records in PEBS buffer
References: <1406016602-31845-1-git-send-email-zheng.z.yan@intel.com> <1406016602-31845-7-git-send-email-zheng.z.yan@intel.com> <20140725081033.GV3935@laptop> <20140725150445.GG18735@two.firstfloor.org> <20140725155332.GC6758@twins.programming.kicks-ass.net> <20140725164041.GH18735@two.firstfloor.org>
In-Reply-To: <20140725164041.GH18735@two.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/26/2014 12:40 AM, Andi Kleen wrote:
>> Suppose two pebs events, one has exclude_kernel set. It overflows,
>> before entering the kernel, the other event generates PEBS records from
>> inside the kernel with both events marked in the overflow field.
>>
>> And only once we leave the kernel can the exclude_kernel event tick
>> again and trigger the assist, finalyl clearing the bit.
>>
>> If you were to report the records to both events, one would get a lot of
>> kernel info he was not entitled to.
> 
> Ok that case can be filtered in software. Shouldn't be too difficult.
> Perhaps just using ip
> 
> 	if (event->attr.exclude_kernel && pebs->ip >= __PAGE_OFFSET)
> 	    skip;
> 	if (event->attr.exclude_user && pebs->ip < __PAGE_OFFSET)
> 	    skip;
> 
> This would also help with the existing skid.
> 
> Any other concerns?
> 
> -Andi
> 

how about following patch
diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index 33b4c0e..ea76507 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -1016,6 +1016,16 @@ static void setup_pebs_sample_data(struct perf_event *event,
 		data->br_stack = &cpuc->lbr_stack;
 }
 
+static inline bool intel_pmu_pebs_filter(struct perf_event *event,
+					 struct pebs_record_nhm *record)
+{
+	if (event->attr.exclude_user && !kernel_ip(record->ip))
+		return true;
+	if (event->attr.exclude_kernel && kernel_ip(record->ip))
+		return true;
+	return false;
+}
+
 static void __intel_pmu_pebs_event(struct perf_event *event,
 				   struct pt_regs *iregs,
 				   void *at, void *top, int count)
@@ -1052,6 +1062,8 @@ static void __intel_pmu_pebs_event(struct perf_event *event,
 		struct pebs_record_nhm *p = at;
 		if (!(p->status & (1 << event->hw.idx)))
 			continue;
+		if (intel_pmu_pebs_filter(event, p))
+			continue;
 
 		setup_pebs_sample_data(event, iregs, at, &data, &regs);
 		perf_output_sample(&handle, &header, &data, event);
@@ -1139,6 +1151,8 @@ static void intel_pmu_drain_pebs_nhm(struct pt_regs *iregs)
 			WARN_ON_ONCE(!event);
 			if (!event->attr.precise_ip)
 				continue;
+			if (intel_pmu_pebs_filter(event, p))
+				continue;
 			counts[bit]++;
 		}
 	}
@@ -1149,7 +1163,8 @@ static void intel_pmu_drain_pebs_nhm(struct pt_regs *iregs)
 		event = cpuc->events[bit];
 		for (at = base; at < top; at += x86_pmu.pebs_record_size) {
 			struct pebs_record_nhm *p = at;
-			if (p->status & (1 << bit))
+			if ((p->status & (1 << bit)) &&
+			    !intel_pmu_pebs_filter(event, p))
 				break;
 		}
 
---

