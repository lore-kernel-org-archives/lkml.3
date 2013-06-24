Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752053Ab3FXWAW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 18:00:22 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:55100 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830Ab3FXWAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 18:00:20 -0400
Message-ID: <51C8C172.8020207@codeaurora.org>
Date: Mon, 24 Jun 2013 15:00:18 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: srinivas.kandagatla@st.com
CC: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Stuart Menefy <stuart.menefy@st.com>, Arnd Bergmann <arnd@arndb.de>,
        Rob Herring <robherring2@gmail.com>, Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v5] clocksource:arm_global_timer: Add ARM global timer
 support.
References: <1372089195-29219-1-git-send-email-srinivas.kandagatla@st.com> <51C8A6C8.8000009@codeaurora.org> <51C8B551.9080203@st.com>
In-Reply-To: <51C8B551.9080203@st.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/24/13 14:08, Srinivas KANDAGATLA wrote:
> On 24/06/13 21:06, Stephen Boyd wrote:
>> On 06/24/13 08:53, Srinivas KANDAGATLA wrote:
>>> +
>>> +static void gt_clockevents_stop(struct clock_event_device *clk)
>>> +{
>>> +	gt_clockevent_set_mode(CLOCK_EVT_MODE_UNUSED, clk);
>>> +	disable_percpu_irq(clk->irq);
>>> +}
>>> +
>>> +static int __cpuinit gt_clockevents_setup(struct clock_event_device *clk)
>>> +{
>>> +	struct clock_event_device *evt = this_cpu_ptr(gt_evt);
>>> +	return evt->name ? 0 : gt_clockevents_init(evt);
>>> +}
>> How does this work? gt_clockevents_stop() is using the
>> clock_event_device struct from the ARM local timer layer whereas
>> gt_clockevents_setup() is using a driver private allocation.
> Thanks for pointing this..
> This should fix it.
>
> static void gt_clockevents_stop(struct clock_event_device *clk)
> {
> 	struct clock_event_device *evt = this_cpu_ptr(gt_evt);
> 	gt_clockevent_set_mode(CLOCK_EVT_MODE_UNUSED, evt);
> 	disable_percpu_irq(evt->irq);
> }

Looks good, but even better would be to not use the local timer API.

>  Please just
>> don't use the local timer API at all and use cpu notifiers instead.
> Last time when I did try using cpu notifiers like arm_arch_timer, the
> broadcast dummy timer did kick off and took over the local timer on the
> secondary cpus. Resulting in lot of broadcast IPI's.
>
> If I use cpu notifiers I will end up two clk events on a each core (one
> dummy from arm/kernel/smp.c and other gt clk_evt). I think I can only
> use cpu notifiers in my case once your patches are in.
> Also I cant disable LOCAL_TIMERS as it y by default.
>
> Am I missing something?
>
> Am happy to move to cpu notifiers if it works, else the driver will be
> broken.

I think the problem is your clockevent has no rating. Please give it a
rating (300?) so that it prevents the dummy from taking over. You don't
need to worry about disabling the local timer API, it will register a
harmless clockevent with a low rating (100) that should be ignored.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

