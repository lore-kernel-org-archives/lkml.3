Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752617Ab3FYInU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 04:43:20 -0400
Received: from eu1sys200aog108.obsmtp.com ([207.126.144.125]:50568 "EHLO
	eu1sys200aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751389Ab3FYInP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 04:43:15 -0400
Message-ID: <51C956F7.2040502@st.com>
Date: Tue, 25 Jun 2013 09:38:15 +0100
From: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
Reply-To: srinivas.kandagatla@st.com
Organization: STMicroelectronics
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-doc@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        Stuart Menefy <stuart.menefy@st.com>,
        John Stultz <john.stultz@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v5] clocksource:arm_global_timer: Add ARM global timer
 support.
References: <1372089195-29219-1-git-send-email-srinivas.kandagatla@st.com> <51C8C35C.70307@codeaurora.org>
In-Reply-To: <51C8C35C.70307@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thankyou for the comments.
On 24/06/13 23:08, Stephen Boyd wrote:
> On 06/24/13 08:53, Srinivas KANDAGATLA wrote:
>> +#include <linux/clkdev.h>
> 
> Why do you need this include?
> 
>> +#include <asm/mach/irq.h>
> 
> And this one?
Removed them.
> 
>> +static u64 gt_counter_read(void)
>> +{
>> +	u64 counter;
>> +	u32 lower;
>> +	u32 upper, old_upper;
>> +
>> +	upper = readl_relaxed(gt_base + GT_COUNTER1);
>> +	do {
>> +		old_upper = upper;
>> +		lower = readl_relaxed(gt_base + GT_COUNTER0);
>> +		upper = readl_relaxed(gt_base + GT_COUNTER1);
> [snip]
>> +static void gt_compare_set(unsigned long delta, int periodic)
>> +{
>> +	u64 counter = gt_counter_read();
>> +	unsigned long ctrl = readl(gt_base + GT_CONTROL);
>> +
>> +	counter += delta;
>> +	ctrl &=  ~(GT_CONTROL_COMP_ENABLE | GT_CONTROL_IRQ_ENABLE);
>> +
>> +	writel(ctrl, gt_base + GT_CONTROL);
>> +	writel(lower_32_bits(counter), gt_base + GT_COMP0);
>> +	writel(upper_32_bits(counter), gt_base + GT_COMP1);
>> +
>> +	if (periodic) {
>> +		writel(delta, gt_base + GT_AUTO_INC);
>> +		ctrl |= GT_CONTROL_AUTO_INC;
>> +	}
>> +
>> +	ctrl |= GT_CONTROL_COMP_ENABLE | GT_CONTROL_IRQ_ENABLE;
>> +	writel(ctrl, gt_base + GT_CONTROL);
>> +}
> 
> Why is there a mix of the relaxed and non-relaxed io accessors?

gt_counter_read will be used very frequently, so using relaxed can
reduce latencies involved in memory barriers.

> 
>> +#ifdef CONFIG_CLKSRC_ARM_GLOBAL_TIMER_SCHED_CLOCK
>> +static u32 gt_sched_clock_read(void)
> 
> notrace
> 
Ok, fixed it.
>> +{
>> +	if (!gt_base)
>> +		return 0;
> 
> Seems impossible? Remove this check?
Yep, I agree this case is impossible in the code flow.
> 

Thanks,
srini
