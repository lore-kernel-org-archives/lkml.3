Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754814AbaEONov (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 09:44:51 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:37515 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752463AbaEONot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 09:44:49 -0400
MIME-Version: 1.0
In-Reply-To: <53705243.1030704@linaro.org>
References: <1399640410-30957-1-git-send-email-tushar.behera@linaro.org>
	<1399640410-30957-2-git-send-email-tushar.behera@linaro.org>
	<536DA243.6000600@samsung.com>
	<53705243.1030704@linaro.org>
Date: Thu, 15 May 2014 19:14:47 +0530
X-Google-Sender-Auth: lI0cirWxhvFu4C8nnKeFRbnjs6g
Message-ID: <CAPdUM4N=k-pPxdhPQgVHh0fb+nqkgs7StwM2Pb6C8gcjx6dw-w@mail.gmail.com>
Subject: Re: [PATCH 1/4] clk: samsung: out: Add infrastructure to register CLKOUT
From: Rahul Sharma <rahul.sharma@samsung.com>
To: Tushar Behera <tushar.behera@linaro.org>
Cc: Pankaj Dubey <pankaj.dubey@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mike Turquette <mturquette@linaro.org>,
        Tomasz Figa <t.figa@samsung.com>, Kukjin Kim <kgene.kim@samsung.com>,
        Kumar Gala <galak@codeaurora.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Rob Herring <robh+dt@kernel.org>, sunil joshi <joshi@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tushar,

Basically you are adding a new clock-type for Clkout. IMO clkout
is not a special hardware. Existing clock types can be reused to
support clkout. I see 3 major problem here:

1) Clkout -> (Mux + Gate). You clubbed mux and gate together, and
exposing as a single clock which is something like a composite clock.
IMO this is not a recommended way in CCF.

2) New Clock Type: Since clkout is just a combination of a simple
mux and gate which are already supported, it is a unnecessary
duplication.

3) Clkout registered along with CMU: which is not correct. Clkout is in PMU
(Separate physical IP) and should be registered as a independent Clock
provider which provides 1 mux and 1 gate clock (As if now). It should also be
well connected with main CMU.

I understand the challenge in using regmap interface for a clock provider. But
we need to identify a clean solution. IMHO a independent clock provider with
iomap, is relatively cleaner approach till CCF is not ready with regmap based
reg access for clock registers.

Experts!! please comment.

Regards,
Rahul Sharma.

On 12 May 2014 10:16, Tushar Behera <tushar.behera@linaro.org> wrote:
> On 05/10/2014 09:21 AM, Pankaj Dubey wrote:
>> On 05/09/2014 10:00 PM, Tushar Behera wrote:
>>> All SoC in Exynos-series have a clock with name XCLKOUT to provide
>>> debug information about various clocks available in the SoC. The register
>>> controlling the MUX and GATE of this clock is provided within PMU domain.
>>> Since PMU domain can't be dedicatedly mapped by every driver, the
>>> register
>>> needs to be handled through a regmap handle provided by PMU syscon
>>> controller. Right now, CCF doesn't allow regmap based MUX and GATE
>>> clocks,
>>> hence a dedicated clock provider for XCLKOUT is added here.
>>>
>>> Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
>>> CC: Tomasz Figa <t.figa@samsung.com>
>>> ---
>>>   drivers/clk/samsung/Makefile  |    2 +-
>>>   drivers/clk/samsung/clk-out.c |  181
>>> +++++++++++++++++++++++++++++++++++++++++
>>>   drivers/clk/samsung/clk.h     |   33 ++++++++
>>>   3 files changed, 215 insertions(+), 1 deletion(-)
>>>   create mode 100644 drivers/clk/samsung/clk-out.c
>>>
>
> [ ... ]
>
>>> +/**
>>> + * struct samsung_clkout_soc_data: SoC specific register details
>>> + * @reg: Offset of CLKOUT register from PMU base
>>
>> how about naming this variable as "offset" instead of "reg".
>>
>
> Okay, I will change that.
>
> [ ... ]
>
>>> +u8 samsung_clkout_get_parent(struct clk_hw *hw)
>>> +{
>>> +    struct samsung_clkout *clkout = to_clk_out(hw);
>>> +    const struct samsung_clkout_soc_data *soc_data = clkout->soc_data;
>>> +    unsigned int parent_mask = BIT(soc_data->mux_width) - 1;
>>> +    unsigned int val;
>>> +    int ret;
>>> +
>>> +    ret = regmap_read(clkout->regmap, soc_data->reg, &val);
>>
>> Do we really need to keep return value in "ret" as I can't see you are
>> using it anywhere?
>>
>
> Right, we are not using that and can be removed.
>
>>> +
>>> +    return (val >> soc_data->mux_shift) & parent_mask;
>>> +}
>>> +
>
> [ ... ]
>
>>> +/* All existing Exynos serial of SoCs have common values for this
>>> offsets. */
>> typo: serial/series/
>
> Sure. Thanks for your review.
>
> --
> Tushar Behera
> --
> To unsubscribe from this list: send the line "unsubscribe linux-samsung-soc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
