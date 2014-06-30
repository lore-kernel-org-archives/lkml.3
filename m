Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752126AbaF3K7K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 06:59:10 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:35486 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825AbaF3K7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 06:59:07 -0400
Message-ID: <53B142F1.1050407@collabora.co.uk>
Date: Mon, 30 Jun 2014 12:58:57 +0200
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Yadwinder Singh Brar <yadi.brar01@gmail.com>
CC: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
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
References: <1403806546-31122-1-git-send-email-javier.martinez@collabora.co.uk>	<1403806546-31122-6-git-send-email-javier.martinez@collabora.co.uk> <CAKew6eU5X=WxhECtwUUwbXe_fCRU4bD6B7caWiA2dwcBfThd-g@mail.gmail.com>
In-Reply-To: <CAKew6eU5X=WxhECtwUUwbXe_fCRU4bD6B7caWiA2dwcBfThd-g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Yadwinder,

Thanks a lot for your feedback.

On 06/30/2014 06:01 AM, Yadwinder Singh Brar wrote:
> Hi Javier,
> 
> On Thu, Jun 26, 2014 at 11:45 PM, Javier Martinez Canillas
> <javier.martinez@collabora.co.uk> wrote:
>> Maxim Integrated Power Management ICs are very similar with
>> regard to their clock outputs. Most of the clock drivers for
>> these chips are duplicating code and are simpler enough that
>> can be converted to use a generic driver to consolidate code
>> and avoid duplication.
>>
>> Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
>> Reviewed-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
>> ---
>>
>> Changes since v4:
>>  - Return recalc 0 if clock isn't enabled in Suggested by Yadwinder Singh Brar.
>>
> 
> It seems you didn't implement or posted same patch again :) .
> 

Yeah, I did implement it but seems I was sleepy when I posted the series since I
managed to completely screw up the patch-set... More on that below.

>> Changes since v3:
>>  - Add current copyright information. Suggested by Krzysztof Kozlowski
>>  - Do a single allocation for struct max_gen_clk. Suggested by Krzysztof Kozlowski
>>  - Add EXPORT_SYMBOL() for exported symbols. Suggested by Krzysztof Kozlowski
>>
>>  drivers/clk/Kconfig       |   3 +
>>  drivers/clk/Makefile      |   1 +
>>  drivers/clk/clk-max-gen.c | 195 ++++++++++++++++++++++++++++++++++++++++++++++
>>  drivers/clk/clk-max-gen.h |  32 ++++++++
>>  4 files changed, 231 insertions(+)
>>  create mode 100644 drivers/clk/clk-max-gen.c
>>  create mode 100644 drivers/clk/clk-max-gen.h
>>
> 
> [ .. ]
> 
>> +
>> +static unsigned long max_gen_recalc_rate(struct clk_hw *hw,
>> +                                        unsigned long parent_rate)
>> +{
>> +       return 32768;
>> +}
> 
> Its still same here.
> 

Instead of squashing the delta in this patch I did on "[PATCH v4 05/14] clk: Add
generic driver for Maxim PMIC clocks" [0] so you can look the
max_gen_recalc_rate() on that patch.

I made the same mistake when squashing the mfd changes into the patch adding the
regulator driver [1] :-(

Sorry for the mess... I'll fix that for the next version.

>> +
>> +struct clk_ops max_gen_clk_ops = {
>> +       .prepare        = max_gen_clk_prepare,
>> +       .unprepare      = max_gen_clk_unprepare,
>> +       .is_prepared    = max_gen_clk_is_prepared,
>> +       .recalc_rate    = max_gen_recalc_rate,
>> +};
>> +EXPORT_SYMBOL_GPL(max_gen_clk_ops);
>> +
>> +static struct clk *max_gen_clk_register(struct device *dev,
>> +                                       struct max_gen_clk *max_gen)
>> +{
>> +       struct clk *clk;
>> +       struct clk_hw *hw = &max_gen->hw;
>> +
>> +       clk = clk_register(dev, hw);
>> +       if (IS_ERR(clk))
>> +               return clk;
>> +
>> +       max_gen->lookup = kzalloc(sizeof(struct clk_lookup), GFP_KERNEL);
> 
> As I suggested in other patch[1] also, its better to use
> clkdev_alloc() instead of kzalloc() here.
> 

Perfect, I'll do it on the next version.

>> +       if (!max_gen->lookup)
>> +               return ERR_PTR(-ENOMEM);
>> +
>> +       max_gen->lookup->con_id = hw->init->name;
> 
> Also IMO,  init->name should be over-written if name is provided in DT,
> otherwise generic "clock-output-names" property will go futile,
> perhaps it should be done before clk_register.
> 

Even though Documentation/devicetree/bindings/clock/clock-bindings.txt says that
the "clock-output-names" property is optional I agree with you that will be
better to support it. So I'll add it on the next version as well.

> Regards,
> Yadwinder
> 

Best regards,
Javier

[0]: http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg33085.html
[1]: http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg33168.html
