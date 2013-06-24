Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751255Ab3FXWIb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 18:08:31 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:55440 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745Ab3FXWIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 18:08:30 -0400
Message-ID: <51C8C35C.70307@codeaurora.org>
Date: Mon, 24 Jun 2013 15:08:28 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
CC: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Stuart Menefy <stuart.menefy@st.com>, Arnd Bergmann <arnd@arndb.de>,
        Rob Herring <robherring2@gmail.com>, Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v5] clocksource:arm_global_timer: Add ARM global timer
 support.
References: <1372089195-29219-1-git-send-email-srinivas.kandagatla@st.com>
In-Reply-To: <1372089195-29219-1-git-send-email-srinivas.kandagatla@st.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/24/13 08:53, Srinivas KANDAGATLA wrote:
> +#include <linux/clkdev.h>

Why do you need this include?

> +#include <asm/mach/irq.h>

And this one?

> +static u64 gt_counter_read(void)
> +{
> +	u64 counter;
> +	u32 lower;
> +	u32 upper, old_upper;
> +
> +	upper = readl_relaxed(gt_base + GT_COUNTER1);
> +	do {
> +		old_upper = upper;
> +		lower = readl_relaxed(gt_base + GT_COUNTER0);
> +		upper = readl_relaxed(gt_base + GT_COUNTER1);
[snip]
> +static void gt_compare_set(unsigned long delta, int periodic)
> +{
> +	u64 counter = gt_counter_read();
> +	unsigned long ctrl = readl(gt_base + GT_CONTROL);
> +
> +	counter += delta;
> +	ctrl &=  ~(GT_CONTROL_COMP_ENABLE | GT_CONTROL_IRQ_ENABLE);
> +
> +	writel(ctrl, gt_base + GT_CONTROL);
> +	writel(lower_32_bits(counter), gt_base + GT_COMP0);
> +	writel(upper_32_bits(counter), gt_base + GT_COMP1);
> +
> +	if (periodic) {
> +		writel(delta, gt_base + GT_AUTO_INC);
> +		ctrl |= GT_CONTROL_AUTO_INC;
> +	}
> +
> +	ctrl |= GT_CONTROL_COMP_ENABLE | GT_CONTROL_IRQ_ENABLE;
> +	writel(ctrl, gt_base + GT_CONTROL);
> +}

Why is there a mix of the relaxed and non-relaxed io accessors?

> +#ifdef CONFIG_CLKSRC_ARM_GLOBAL_TIMER_SCHED_CLOCK
> +static u32 gt_sched_clock_read(void)

notrace

> +{
> +	if (!gt_base)
> +		return 0;

Seems impossible? Remove this check?

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

