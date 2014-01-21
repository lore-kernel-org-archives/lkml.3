Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754289AbaAUWAB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 17:00:01 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:50340 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751408AbaAUV76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 16:59:58 -0500
Message-ID: <52DEEDDA.4060302@codeaurora.org>
Date: Tue, 21 Jan 2014 13:59:54 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Neil Leeder <nleeder@codeaurora.org>,
        Ashwin Chaugule <ashwinc@codeaurora.org>
Subject: Re: [PATCH v2 5/7] ARM: perf_event: Fully support Krait CPU PMU events
References: <1389808535-23852-1-git-send-email-sboyd@codeaurora.org> <1389808535-23852-6-git-send-email-sboyd@codeaurora.org> <20140121180711.GN30706@mudshark.cambridge.arm.com> <52DEBE6B.7000904@codeaurora.org>
In-Reply-To: <52DEBE6B.7000904@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21/14 10:37, Stephen Boyd wrote:
> On 01/21/14 10:07, Will Deacon wrote:
>> Finally, I'd really like to see this get some test coverage, but I don't
>> want to try running mainline on my phone :) Could you give your patches a
>> spin with Vince's perf fuzzer please?
>>
>>   https://github.com/deater/perf_event_tests.git
>>
>> (then build the contents of the fuzzer directory and run it for as long as
>> you can).
>>
> Ok. I'll see what I can do.

Neat. This quickly discovered a problem.

BUG: using smp_processor_id() in preemptible [00000000] code: perf_fuzzer/70
caller is krait_pmu_get_event_idx+0x58/0xd8
CPU: 2 PID: 70 Comm: perf_fuzzer Not tainted 3.13.0-rc7-next-20140108-00041-gb038353c8516-dirty #58
[<c02165dc>] (unwind_backtrace) from [<c0212ffc>] (show_stack+0x10/0x14)
[<c0212ffc>] (show_stack) from [<c06ad5fc>] (dump_stack+0x6c/0xb8)
[<c06ad5fc>] (dump_stack) from [<c04b0928>] (debug_smp_processor_id+0xc4/0xe8)
[<c04b0928>] (debug_smp_processor_id) from [<c021a19c>] (krait_pmu_get_event_idx+0x58/0xd8)
[<c021a19c>] (krait_pmu_get_event_idx) from [<c021833c>] (validate_event+0x2c/0x54)
[<c021833c>] (validate_event) from [<c02186b4>] (armpmu_event_init+0x264/0x2dc)
[<c02186b4>] (armpmu_event_init) from [<c02b28e4>] (perf_init_event+0x138/0x194)
[<c02b28e4>] (perf_init_event) from [<c02b2c04>] (perf_event_alloc+0x2c4/0x348)
[<c02b2c04>] (perf_event_alloc) from [<c02b37e4>] (SyS_perf_event_open+0x7b8/0x9cc)
[<c02b37e4>] (SyS_perf_event_open) from [<c020ef80>] (ret_fast_syscall+0x0/0x48)

This is happening because the pmresrn_used mask is per-cpu but
validate_group() is called in preemptible context. It looks like we'll
need to add another unsigned long * field to struct pmu_hw_events just
for Krait purposes? Or we could use the upper 16 bits of the used_mask
bitmap to hold the pmresr_used values? Sounds sort of hacky but it
avoids adding another bitmap for every PMU user and there aren't any
Krait CPUs with more than 5 counters anyway.

This is the diff for the latter version. I'll let the fuzzer run overnight.

diff --git a/arch/arm/include/asm/pmu.h b/arch/arm/include/asm/pmu.h
index 994ac445e792..ae1919be8f98 100644
--- a/arch/arm/include/asm/pmu.h
+++ b/arch/arm/include/asm/pmu.h
@@ -71,7 +71,8 @@ struct arm_pmu {
 	void		(*disable)(struct perf_event *event);
 	int		(*get_event_idx)(struct pmu_hw_events *hw_events,
 					 struct perf_event *event);
-	void		(*clear_event_idx)(struct perf_event *event);
+	void		(*clear_event_idx)(struct pmu_hw_events *hw_events,
+					 struct perf_event *event);
 	int		(*set_event_filter)(struct hw_perf_event *evt,
 					    struct perf_event_attr *attr);
 	u32		(*read_counter)(struct perf_event *event);
diff --git a/arch/arm/kernel/perf_event.c b/arch/arm/kernel/perf_event.c
index 70191f68c26d..361a1aaee7c8 100644
--- a/arch/arm/kernel/perf_event.c
+++ b/arch/arm/kernel/perf_event.c
@@ -208,7 +208,7 @@ armpmu_del(struct perf_event *event, int flags)
 	hw_events->events[idx] = NULL;
 	clear_bit(idx, hw_events->used_mask);
 	if (armpmu->clear_event_idx)
-		armpmu->clear_event_idx(event);
+		armpmu->clear_event_idx(hw_events, event);
 
 	perf_event_update_userpage(event);
 }
diff --git a/arch/arm/kernel/perf_event_v7.c b/arch/arm/kernel/perf_event_v7.c
index daa675529c12..1a905395b74c 100644
--- a/arch/arm/kernel/perf_event_v7.c
+++ b/arch/arm/kernel/perf_event_v7.c
@@ -1483,9 +1483,6 @@ static int armv7_a7_pmu_init(struct arm_pmu *cpu_pmu)
 #define VENUM_EVENT		(2 << 16)
 #define KRAIT_EVENT_MASK	(KRAIT_EVENT | VENUM_EVENT)
 #define PMRESRn_EN		BIT(31)
-#define NUM_PMRESR	(KRAIT_VPMRESR0_GROUP0 + 4 - KRAIT_PMRESR0_GROUP0)
-
-static DEFINE_PER_CPU(unsigned long [BITS_TO_LONGS(NUM_PMRESR)], pmresrn_used);
 
 static u32 krait_read_pmresrn(int n)
 {
@@ -1542,6 +1539,7 @@ static void krait_pre_vpmresr0(u32 *venum_orig_val, u32 *fp_orig_val)
 	u32 venum_new_val;
 	u32 fp_new_val;
 
+	BUG_ON(preemptible());
 	/* CPACR Enable CP10 and CP11 access */
 	*venum_orig_val = get_copro_access();
 	venum_new_val = *venum_orig_val | CPACC_SVC(10) | CPACC_SVC(11);
@@ -1555,6 +1553,7 @@ static void krait_pre_vpmresr0(u32 *venum_orig_val, u32 *fp_orig_val)
 
 static void krait_post_vpmresr0(u32 venum_orig_val, u32 fp_orig_val)
 {
+	BUG_ON(preemptible());
 	/* Restore FPEXC */
 	fmxr(FPEXC, fp_orig_val);
 	isb();
@@ -1750,7 +1749,6 @@ static int krait_pmu_get_event_idx(struct pmu_hw_events *cpuc,
 	unsigned int group;
 	bool krait_event;
 	struct hw_perf_event *hwc = &event->hw;
-	unsigned long *bitmap = this_cpu_ptr(pmresrn_used);
 
 	region = (hwc->config_base >> 12) & 0xf;
 	code   = (hwc->config_base >> 4) & 0xff;
@@ -1773,26 +1771,27 @@ static int krait_pmu_get_event_idx(struct pmu_hw_events *cpuc,
 			bit = krait_get_pmresrn_event(region);
 		bit -= krait_get_pmresrn_event(0);
 		bit += group;
+		bit <<= 16; /* Use the upper 16 bits of the used_mask */
 
-		if (test_and_set_bit(bit, bitmap))
+		if (test_and_set_bit(bit, cpuc->used_mask))
 			return -EAGAIN;
 	}
 
 	idx = armv7pmu_get_event_idx(cpuc, event);
 	if (idx < 0 && krait_event)
-		clear_bit(bit, bitmap);
+		clear_bit(bit, cpuc->used_mask);
 
 	return idx;
 }
 
-static void krait_pmu_clear_event_idx(struct perf_event *event)
+static void krait_pmu_clear_event_idx(struct pmu_hw_events *cpuc,
+				      struct perf_event *event)
 {
 	int bit;
 	struct hw_perf_event *hwc = &event->hw;
 	unsigned int region;
 	unsigned int group;
 	bool krait_event;
-	unsigned long *bitmap = this_cpu_ptr(pmresrn_used);
 
 	region = (hwc->config_base >> 12) & 0xf;
 	group  = (hwc->config_base >> 0) & 0xf;
@@ -1805,7 +1804,8 @@ static void krait_pmu_clear_event_idx(struct perf_event *event)
 			bit = krait_get_pmresrn_event(region);
 		bit -= krait_get_pmresrn_event(0);
 		bit += group;
-		clear_bit(bit, bitmap);
+		bit <<= 16;
+		clear_bit(bit, cpuc->used_mask);
 	}
 }

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

