Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753231AbaGBKNj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 06:13:39 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:36780 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752097AbaGBKNh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 06:13:37 -0400
Message-ID: <53B3DB49.6020604@collabora.co.uk>
Date: Wed, 02 Jul 2014 12:13:29 +0200
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>,
        Yadwinder Singh Brar <yadi.brar01@gmail.com>
CC: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        Sjoerd Simons <sjoerd.simons@collabora.co.uk>,
        Daniel Stone <daniels@collabora.com>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        devicetree <devicetree@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 05/14] clk: Add generic driver for Maxim PMIC clocks
References: <1403806546-31122-1-git-send-email-javier.martinez@collabora.co.uk> <1403806546-31122-6-git-send-email-javier.martinez@collabora.co.uk> <CAKew6eU5X=WxhECtwUUwbXe_fCRU4bD6B7caWiA2dwcBfThd-g@mail.gmail.com> <20140701172616.32686.44374@quantum>
In-Reply-To: <20140701172616.32686.44374@quantum>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Mike,

On 07/01/2014 07:26 PM, Mike Turquette wrote:
> Quoting Yadwinder Singh Brar (2014-06-29 21:01:36)
>> Hi Javier,
>> 
>> On Thu, Jun 26, 2014 at 11:45 PM, Javier Martinez Canillas
>> <javier.martinez@collabora.co.uk> wrote:
>> > Maxim Integrated Power Management ICs are very similar with
>> > regard to their clock outputs. Most of the clock drivers for
>> > these chips are duplicating code and are simpler enough that
>> > can be converted to use a generic driver to consolidate code
>> > and avoid duplication.
>> >
>> > Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
>> > Reviewed-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
>> > ---
>> >
>> > Changes since v4:
>> >  - Return recalc 0 if clock isn't enabled in Suggested by Yadwinder Singh Brar.
>> >
>> 
>> It seems you didn't implement or posted same patch again :) .
>> 
>> > Changes since v3:
>> >  - Add current copyright information. Suggested by Krzysztof Kozlowski
>> >  - Do a single allocation for struct max_gen_clk. Suggested by Krzysztof Kozlowski
>> >  - Add EXPORT_SYMBOL() for exported symbols. Suggested by Krzysztof Kozlowski
>> >
>> >  drivers/clk/Kconfig       |   3 +
>> >  drivers/clk/Makefile      |   1 +
>> >  drivers/clk/clk-max-gen.c | 195 ++++++++++++++++++++++++++++++++++++++++++++++
>> >  drivers/clk/clk-max-gen.h |  32 ++++++++
>> >  4 files changed, 231 insertions(+)
>> >  create mode 100644 drivers/clk/clk-max-gen.c
>> >  create mode 100644 drivers/clk/clk-max-gen.h
>> >
>> 
>> [ .. ]
>> 
>> > +
>> > +static unsigned long max_gen_recalc_rate(struct clk_hw *hw,
>> > +                                        unsigned long parent_rate)
>> > +{
>> > +       return 32768;
>> > +}
>> 
>> Its still same here.
> 
> Changing this would be a new behavior. I do not know of any other clock
> drivers that conditionally returns a rate of 0 based on whether or not
> the clock is gated.
> 

After Yadwinder feedback I searched for clock drivers that returned 0 when the
clock was not enabled/prepared and found for example drivers/clk/clk-s2mps11.c:


static unsigned long s2mps11_clk_recalc_rate(struct clk_hw *hw,
                                             unsigned long parent_rate)
{
        struct s2mps11_clk *s2mps11 = to_s2mps11_clk(hw);
        if (s2mps11->enabled)
                return 32768;
        else
                return 0;
}

> It is also buggy since calls to clk_enable and clk_disable do not invoke
> .recalc_rate, so the rate of your clock would not be updated from the
> framework's perspective until some later point where you call
> clk_set_rate or something.
>

s2ps11->enabled is set in the driver's clk_ops .prepare and .unprepare function
handlers and calls to clk_prepare and clk_unprepare also don't seems to invoke
.recalc_rate so I guess that driver is wrong as well and should just return the
clock rate unconditionally?

> If your driver needs to know whether or not the clock is enabled then we
> could introduce a new bool clk_is_enabled(struct clk *clk); to clk.h,
> but I'd rather not do that. Instead if a driver needs a clock then it
> calls clk_enable on it without any knowledge about the internal state of
> the clock enable_count.
> 
> Regards,
> Mike
>

Thanks a lot for the explanation, I'll revert that change then and return the
clock rate unconditionally on the next version of the patch-set.

Best regards,
Javier
