Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351AbaAUShe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 13:37:34 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:34887 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755179AbaAUShc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 13:37:32 -0500
Message-ID: <52DEBE6B.7000904@codeaurora.org>
Date: Tue, 21 Jan 2014 10:37:31 -0800
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
References: <1389808535-23852-1-git-send-email-sboyd@codeaurora.org> <1389808535-23852-6-git-send-email-sboyd@codeaurora.org> <20140121180711.GN30706@mudshark.cambridge.arm.com>
In-Reply-To: <20140121180711.GN30706@mudshark.cambridge.arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21/14 10:07, Will Deacon wrote:
> Hi Stephen,
>
> Thanks for the updates. A few more comments inline.
>
> On Wed, Jan 15, 2014 at 05:55:33PM +0000, Stephen Boyd wrote:
>> Krait supports a set of performance monitor region event
>> selection registers (PMRESR) sitting behind a cp15 based
>> interface that extend the architected PMU events to include Krait
>> CPU and Venum VFP specific events. To use these events the user
>> is expected to program the region register (PMRESRn) with the
>> event code shifted into the group they care about and then point
>> the PMNx event at that region+group combo by writing a
>> PMRESRn_GROUPx event. Add support for this hardware.
>>
>> Note: the raw event number is a pure software construct that
>> allows us to map the multi-dimensional number space of regions,
>> groups, and event codes into a flat event number space suitable
>> for use by the perf framework.
> [...]
>
>> +static u32 krait_read_pmresrn(int n)
>> +{
>> +       u32 val;
>> +
>> +       switch (n) {
>> +       case 0:
>> +               asm volatile("mrc p15, 1, %0, c9, c15, 0" : "=r" (val));
>> +               break;
>> +       case 1:
>> +               asm volatile("mrc p15, 1, %0, c9, c15, 1" : "=r" (val));
>> +               break;
>> +       case 2:
>> +               asm volatile("mrc p15, 1, %0, c9, c15, 2" : "=r" (val));
>> +               break;
>> +       default:
>> +               BUG(); /* Should be validated in krait_pmu_get_event_idx() */
>> +       }
>> +
>> +       return val;
>> +}
>> +
>> +static void krait_write_pmresrn(int n, u32 val)
>> +{
>> +       switch (n) {
>> +       case 0:
>> +               asm volatile("mcr p15, 1, %0, c9, c15, 0" : : "r" (val));
>> +               break;
>> +       case 1:
>> +               asm volatile("mcr p15, 1, %0, c9, c15, 1" : : "r" (val));
>> +               break;
>> +       case 2:
>> +               asm volatile("mcr p15, 1, %0, c9, c15, 2" : : "r" (val));
>> +               break;
>> +       default:
>> +               BUG(); /* Should be validated in krait_pmu_get_event_idx() */
>> +       }
>> +}
> Do you need isbs to ensure the pmresrn side-effects have happened, or are
> the registers self-synchronising? Similarly for your other IMP DEF
> registers.

There aren't any isbs in the downstream android sources so I assume
they're self synchronizing. I'll confirm with the CPU designers to make
sure.

>
>> +static void krait_pre_vpmresr0(u32 *venum_orig_val, u32 *fp_orig_val)
>> +{
>> +       u32 venum_new_val;
>> +       u32 fp_new_val;
>> +
>> +       /* CPACR Enable CP10 and CP11 access */
>> +       *venum_orig_val = get_copro_access();
>> +       venum_new_val = *venum_orig_val | CPACC_SVC(10) | CPACC_SVC(11);
>> +       set_copro_access(venum_new_val);
>> +
>> +       /* Enable FPEXC */
>> +       *fp_orig_val = fmrx(FPEXC);
>> +       fp_new_val = *fp_orig_val | FPEXC_EN;
>> +       fmxr(FPEXC, fp_new_val);
> Messing around with the lot (especially with kernel-mode neon now in
> mainline) does scare me. I'd like some BUG_ON(preemptible()) and you could
> consider using kernel_neon_{begin,end} but they're a lot heavier than you
> need (due to non-lazy switching)
>
> Finally, I'd really like to see this get some test coverage, but I don't
> want to try running mainline on my phone :) Could you give your patches a
> spin with Vince's perf fuzzer please?
>
>   https://github.com/deater/perf_event_tests.git
>
> (then build the contents of the fuzzer directory and run it for as long as
> you can).
>

Ok. I'll see what I can do.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

