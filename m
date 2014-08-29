Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752580AbaH2GBG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 02:01:06 -0400
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:10758 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751559AbaH2GBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 02:01:04 -0400
Date: Thu, 28 Aug 2014 23:01:00 -0700
From: Bjorn Andersson <bjorn.andersson@sonymobile.com>
To: Georgi Djakov <gdjakov@mm-sol.com>
CC: "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "agross@codeaurora.org" <agross@codeaurora.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "sboyd@codeaurora.org" <sboyd@codeaurora.org>,
        "iivanov@mm-sol.com" <iivanov@mm-sol.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Subject: Re: [PATCH v2 1/3] pinctrl: qcom: Add APQ8084 pinctrl support
Message-ID: <20140829060059.GG12494@sonymobile.com>
References: <1409057156-1201-1-git-send-email-gdjakov@mm-sol.com>
 <1409057156-1201-2-git-send-email-gdjakov@mm-sol.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1409057156-1201-2-git-send-email-gdjakov@mm-sol.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 26 Aug 05:45 PDT 2014, Georgi Djakov wrote:

Hi Georgi,

Sorry for missing this before, but I did a quick walkthrough and unfortunately
the gpio configuration needs a few updates.

> diff --git a/drivers/pinctrl/qcom/pinctrl-apq8084.c b/drivers/pinctrl/qcom/pinctrl-apq8084.c
[...]
> +
> +#define PINGROUP(id, f1, f2, f3, f4, f5, f6, f7)        \
> +       {                                               \
> +               .name = "gpio" #id,                     \
> +               .pins = gpio##id##_pins,                \
> +               .npins = ARRAY_SIZE(gpio##id##_pins),   \
> +               .funcs = (int[]){                       \
> +                       APQ_MUX_gpio,                   \
> +                       APQ_MUX_##f1,                   \
> +                       APQ_MUX_##f2,                   \
> +                       APQ_MUX_##f3,                   \
> +                       APQ_MUX_##f4,                   \
> +                       APQ_MUX_##f5,                   \
> +                       APQ_MUX_##f6,                   \
> +                       APQ_MUX_##f7                    \
> +               },                                      \
> +               .nfuncs = 8,                            \
> +               .ctl_reg = 0x1000 + 0x10 * id,          \
> +               .io_reg = 0x1004 + 0x10 * id,           \
> +               .intr_cfg_reg = 0x1008 + 0x10 * id,     \
> +               .intr_status_reg = 0x100c + 0x10 * id,  \
> +               .intr_target_reg = 0x400 + 0x4 * id,    \

The routing of the interrupt is specified in TLMM_GPIO_INTR_CFG(n),
i.e: 0x1008 + 0x10 * n

Apparently the HW guys wanted to give us more work, so in 8084 they use 3 to
specify routing the interrupts to KPSS, instead of the previous 4. So the
static define of INTR_TARGET_PROC_APPS is no longer adequate.

My suggestion is that you create an additional patch and add to your series
that moves todays hardcoded 4 into the soc_data for the existing platforms (or
include it in this struct).

> +               .mux_bit = 2,                           \
> +               .pull_bit = 0,                          \
> +               .drv_bit = 6,                           \
> +               .oe_bit = 9,                            \
> +               .in_bit = 0,                            \
> +               .out_bit = 1,                           \
> +               .intr_enable_bit = 0,                   \
> +               .intr_status_bit = 0,                   \
> +               .intr_ack_high = 1,                     \

With the 8084 TLMM chip you ack the interrupt status by clearing this bit, so
intr_ack_high should be 0.

> +               .intr_target_bit = 0,                   \

Target bit is 5.

> +               .intr_raw_status_bit = 3,               \

Raw interrupt status bit is 4.

> +               .intr_polarity_bit = 1,                 \
> +               .intr_detection_bit = 2,                \
> +               .intr_detection_width = 1,              \

You can do level, raise, fall and both edge detection with 8084, so the width
of his part is 2.

> +       }
> +

Regards,
Bjorn
