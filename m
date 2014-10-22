Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752852AbaJVPJl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 11:09:41 -0400
Received: from mail-lb0-f175.google.com ([209.85.217.175]:53669 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751755AbaJVPJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 11:09:39 -0400
MIME-Version: 1.0
In-Reply-To: <CAPDyKFo97D3XbwDQrDzHw+qr4b24Fsq9EwDbdOMhy_L-RoYsLw@mail.gmail.com>
References: <1413809764-21995-1-git-send-email-grygorii.strashko@ti.com>
	<1413809764-21995-3-git-send-email-grygorii.strashko@ti.com>
	<5446A065.9050308@gmail.com>
	<544793B5.6080601@ti.com>
	<CAPDyKFo97D3XbwDQrDzHw+qr4b24Fsq9EwDbdOMhy_L-RoYsLw@mail.gmail.com>
Date: Wed, 22 Oct 2014 17:09:36 +0200
X-Google-Sender-Auth: cYkKrLyVgjaBOlbJ62q1xSc2GwQ
Message-ID: <CAMuHMdVsqsSHxirzoWspGz7y+2qBk42p-VUBNkys3_rr6Th_9Q@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] ARM: keystone: pm: switch to use generic pm domains
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Grygorii Strashko <grygorii.strashko@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@gmail.com>, ssantosh@kernel.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Kevin Hilman <khilman@linaro.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ulf,

On Wed, Oct 22, 2014 at 5:01 PM, Ulf Hansson <ulf.hansson@linaro.org> wrote:
>>>> +void keystone_pm_domain_attach_dev(struct device *dev)
>>>>   {
>>>> +    struct clk *clk;
>>>>       int ret;
>>>> +    int i = 0;
>>>>
>>>>       dev_dbg(dev, "%s\n", __func__);
>>>>
>>>> -    ret = pm_generic_runtime_suspend(dev);
>>>> -    if (ret)
>>>> -        return ret;
>>>> -
>>>> -    ret = pm_clk_suspend(dev);
>>>> +    ret = pm_clk_create(dev);
>>>>       if (ret) {
>>>> -        pm_generic_runtime_resume(dev);
>>>> -        return ret;
>>>> +        dev_err(dev, "pm_clk_create failed %d\n", ret);
>>>> +        return;
>>>> +    };
>>>> +
>>>> +    while ((clk = of_clk_get(dev->of_node, i++)) && !IS_ERR(clk)) {
>>>> +        ret = pm_clk_add_clk(dev, clk);
>>>> +        if (ret) {
>>>> +            dev_err(dev, "pm_clk_add_clk failed %d\n", ret);
>>>> +            goto clk_err;
>>>> +        };
>>>>       }
>>>>
>>>> -    return 0;
>>>> +    if (!IS_ENABLED(CONFIG_PM_RUNTIME)) {
>>> Can we not okkup two seperate callbacks instead of above check ?
>>> I don't like this CONFIG check here. Its slightly better version of
>>> ifdef in middle of the code.
>>
>> I've found more-less similar comment on patch
>> "Re: [PATCH v3 1/3] power-domain: add power domain drivers for Rockchip platform"
>> https://lkml.org/lkml/2014/10/17/257
>>
>> So, Would you like me to create patch which will enable clocks in pm_clk_add/_clk()
>> in case !IS_ENABLED(CONFIG_PM_RUNTIME)
>
> I am wondering whether we actually should/could do this, no matter of
> CONFIG_PM_RUNTIME.
>
> Typically, for configurations that uses CONFIG_PM_RUNTIME, the PM
> clocks through pm_clk_suspend(), will be gated once the device becomes
> runtime PM suspended. Right?

Doing it unconditionally means we'll have lots of unneeded clocks running
for a short while.

Are you trying to repeat power-up-all-PM-domains-during-boot for
clocks, too? ;-)

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
