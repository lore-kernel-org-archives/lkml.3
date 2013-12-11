Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751268Ab3LKBmr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 20:42:47 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:46910 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917Ab3LKBmp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 20:42:45 -0500
Message-ID: <52A7C313.8090208@codeaurora.org>
Date: Tue, 10 Dec 2013 17:42:43 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Bjorn Andersson <bjorn.andersson@sonymobile.com>
CC: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 1/3] pinctrl: Add Qualcomm TLMM driver
References: <1386295805-13708-1-git-send-email-bjorn.andersson@sonymobile.com> <1386295805-13708-2-git-send-email-bjorn.andersson@sonymobile.com> <52A24438.4000908@codeaurora.org> <20131210081031.GD11990@sonymobile.com>
In-Reply-To: <20131210081031.GD11990@sonymobile.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/13 00:10, Bjorn Andersson wrote:
> On Fri 06 Dec 13:40 PST 2013, Stephen Boyd wrote:
>>> +config PINCTRL_MSM
>>> +     bool
>> Why not tristate?
>>
> I have a hard time seeing an situation where you would like to build a system
> with this driver as a module; it would force almost the entire system to be
> loaded at a later time...

We're going to need to build everything but the essentials as modules
for the multi-platform kernel because we're going to run into the
problem where the kernel can't link anymore. Data heavy drivers such as
this are  targets for that because they waste more space being built-in
and they're not absolutely necessary to boot into an initrd that holds
the modules for a particular device.

>
>
>>> +     val = readl(pctrl->regs + g->intr_cfg_reg);
>>> +     val |= BIT(g->intr_raw_status_bit);
>>> +     if (g->intr_detection_width == 2) {
>>> +             val &= ~(3 << g->intr_detection_bit);
>>> +             val &= ~(1 << g->intr_polarity_bit);
>>> +             switch (type) {
>>> +             case IRQ_TYPE_EDGE_RISING:
>>> +                     val |= 1 << g->intr_detection_bit;
>>> +                     val |= BIT(g->intr_polarity_bit);
>>> +                     break;
>>> +             case IRQ_TYPE_EDGE_FALLING:
>>> +                     val |= 2 << g->intr_detection_bit;
>>> +                     val |= BIT(g->intr_polarity_bit);
>>> +                     break;
>>> +             case IRQ_TYPE_EDGE_BOTH:
>>> +                     val |= 3 << g->intr_detection_bit;
>>> +                     val |= BIT(g->intr_polarity_bit);
>>> +                     break;
>>> +             case IRQ_TYPE_LEVEL_LOW:
>>> +                     break;
>>> +             case IRQ_TYPE_LEVEL_HIGH:
>>> +                     val |= BIT(g->intr_polarity_bit);
>>> +                     break;
>>> +             }
>>> +     } else if (g->intr_detection_width == 1) {
>>> +             val &= ~(1 << g->intr_detection_bit);
>>> +             val &= ~(1 << g->intr_polarity_bit);
>>> +             switch (type) {
>>> +             case IRQ_TYPE_EDGE_RISING:
>>> +                     val |= BIT(g->intr_detection_bit);
>>> +                     val |= BIT(g->intr_polarity_bit);
>>> +                     break;
>>> +             case IRQ_TYPE_EDGE_FALLING:
>>> +                     val |= BIT(g->intr_detection_bit);
>>> +                     break;
>>> +             case IRQ_TYPE_EDGE_BOTH:
>>> +                     val |= BIT(g->intr_detection_bit);
>>> +                     break;
>>> +             case IRQ_TYPE_LEVEL_LOW:
>>> +                     break;
>>> +             case IRQ_TYPE_LEVEL_HIGH:
>>> +                     val |= BIT(g->intr_polarity_bit);
>>> +                     break;
>>> +             }
>>> +     } else {
>>> +             BUG();
>>> +     }
>> This would be better written as a collection of ifs so that
>> IRQ_TYPE_EDGE_BOTH doesn't have to be tested and we duplicate less code.
>>
> I've rewritten this numerous times and this is the cleanest way I can find
> to do this in. Yes, there's some duplication but it has a cleaner structure
> and easier to follow than the nested if/elseif/else statements.
>
> So I would like to keep it as is.

Isn't this the same?

+     val = readl(pctrl->regs + g->intr_cfg_reg);
+     val |= BIT(g->intr_raw_status_bit);
+
+     detection_mask = BIT(g->intr_detection_width) - 1;
+     val &= ~(detection_mask << g->intr_detection_bit);
+     val &= ~BIT(g->intr_polarity_bit);
+
+     if (type & IRQ_TYPE_EDGE_RISING)
+             val |= BIT(g->intr_detection_bit);
+
+     if (type & IRQ_TYPE_EDGE_FALLING)
+             val |= g->intr_detection_width << g->intr_detection_bit;
+
+     if (!(type & IRQ_TYPE_LEVEL_LOW))
+             val |= BIT(g->intr_polarity_bit);
+

>
>
>
>>> +#include <linux/pinctrl/pinctrl.h>
>>> +#include <linux/pinctrl/pinmux.h>
>>> +#include <linux/pinctrl/pinconf.h>
>>> +#include <linux/pinctrl/machine.h>
>> Are any of these includes actually necessary? Can't we just forward
>> declare struct pinctrl_pin_desc?
>>
> None of them are needed in the current set of patches, as these are already
> included in the c-files before including this.
>
> But the right set should be: platform_device.h and pinctrl.h.

We should be able to get away with forward declaring the structs we care
about. C files that include this header should be including the
pinctrl.h header file anyway, no?

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

