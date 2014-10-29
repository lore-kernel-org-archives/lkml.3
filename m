Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933949AbaJ2OKX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 10:10:23 -0400
Received: from regular1.263xmail.com ([211.150.99.135]:53993 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932961AbaJ2OKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 10:10:18 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: jinkun.hong@rock-chips.com
X-FST-TO: dmitry.torokhov@gmail.com
X-SENDER-IP: 58.22.7.114
X-LOGIN-NAME: jinkun.hong@rock-chips.com
X-UNIQUE-TAG: <7381d3db66b468fb92faea9b4d4e1c10>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
Message-ID: <5450F534.8030501@rock-chips.com>
Date: Wed, 29 Oct 2014 22:09:56 +0800
From: Hong jinkun <jinkun.hong@rock-chips.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Ulf Hansson <ulf.hansson@linaro.org>
CC: Linus Walleij <linus.walleij@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Doug Anderson <dianders@chromium.org>,
        Heiko Stuebner <heiko@sntech.de>, linux-rockchip@lists.infradead.org,
        Jack Dai <jack.dai@rock-chips.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH v5 1/3] power-domain: add power domain drivers for Rockchip
 platform
References: <1413882808-4669-1-git-send-email-jinkun.hong@rock-chips.com>	<1413882808-4669-2-git-send-email-jinkun.hong@rock-chips.com>	<20141021195854.GE8609@dtor-ws>	<544725C4.4040703@rock-chips.com> <CAPDyKFp+aNJd_FEY6=-ubK0zvVDWh+x5ZsVG+AVpuBzpSqynOQ@mail.gmail.com>
In-Reply-To: <CAPDyKFp+aNJd_FEY6=-ubK0zvVDWh+x5ZsVG+AVpuBzpSqynOQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 2014/10/22 15:58, Ulf Hansson wrote:
> [...]
>
>>>> +
>>>> +       list_for_each_entry(de, &pd->dev_list, node) {
>>>> +               i += 1;
>>>> +               pm_clk_resume(pd->dev);
>>> Do you really need to call pm_clk_resume() number of times that there
>>> are devices in power domain? Did you want it to be
>>>
>>>                  pm_clk_resume(de->dev);
>>>
>>> by any chance?
> I was just about to ask the similar question as Dmitry did. :-)
>
>> You are right.I will modify in the next version.
> Now, does that also mean you would like to assign the ->start|stop()
> callbacks in the struct gpd_dev_ops to pm_clk_suspend|resume()? Or do
> you intend to handle that from each driver instead?
If it can call dev_ops.start before calling power_on and power_off is 
the best.But I found dev_ops.start not called.Is not I did add some patch?
>>>> +       }
>>>> +
>>>> +       /* no clk, set power domain will fail */
>>>> +       if (i == 0) {
>>>> +               pr_err("%s: failed to on/off power domain!", __func__);
>>>> +               spin_unlock_irq(&pd->dev_lock);
>>>> +               return ret;
>>>> +       }
>>> Instead of counting I'd do
>>>
>>>          if (list_empty(&pd->dev_list)) {
>>>                  pr_waen("%s: no devices in power domain\n", __func__);
>>>                  goto out;
>>>          }
>>>
>>> in the beginning of the function.
>> This is a good idea.
>>
>>>> +
>>>> +       ret = rockchip_pmu_set_power_domain(pd, power_on);
>>>> +
>>>> +       list_for_each_entry(de, &pd->dev_list, node) {
>>>> +               pm_clk_suspend(pd->dev);
>>> Same here?
>>>
>>>> +       }
>>>> +
>>>> +       spin_unlock_irq(&pd->dev_lock);
>>>> +
>>>> +       return ret;
>>>> +}
>>>> +
>>>> +static int rockchip_pd_power_on(struct generic_pm_domain *domain)
>>>> +{
>>>> +       struct rockchip_domain *pd = to_rockchip_pd(domain);
>>>> +
>>>> +       return rockchip_pd_power(pd, true);
>>>> +}
>>>> +
>>>> +static int rockchip_pd_power_off(struct generic_pm_domain *domain)
>>>> +{
>>>> +       struct rockchip_domain *pd = to_rockchip_pd(domain);
>>>> +
>>>> +       return rockchip_pd_power(pd, false);
>>>> +}
>>>> +
>>>> +void rockchip_pm_domain_attach_dev(struct device *dev)
>>>> +{
>>>> +       int ret;
>>>> +       int i = 0;
>>>> +       struct clk *clk;
>>>> +       struct rockchip_domain *pd;
>>>> +       struct rockchip_dev_entry *de;
>>>> +
>>>> +       pd = (struct rockchip_domain *)dev->pm_domain;
>>>> +       ret = pm_clk_create(dev);
>>>> +       if (ret) {
>>>> +               dev_err(dev, "pm_clk_create failed %d\n", ret);
>>>> +               return;
>>>> +       };
>>> Stray semicolon.
>>>> +
>>>> +       while ((clk = of_clk_get(dev->of_node, i++)) && !IS_ERR(clk)) {
>>>> +               ret = pm_clk_add_clk(dev, clk);
>>>> +               if (ret) {
>>>> +                       dev_err(dev, "pm_clk_add_clk failed %d\n", ret);
>>>> +                       goto clk_err;
>>>> +               };
>>>> +       }
>>>> +
>>>> +       de = devm_kcalloc(pd->dev, 1,
>>>> +                       sizeof(struct rockchip_dev_entry *), GFP_KERNEL);
>>> Why devm_calloc for a single element and not devm_kzalloc? Also, I am a
>>> bit concerned about using devm_* API here. They are better reserved fir
>>> driver's ->probe() paths whereas we are called from
>>> dev_pm_domain_attach() which is more general API (yes, currently it is
>>> used by buses probing code, but that might change in the future).
> Using the devm_*API is supposed to work from here. I have kept this in
> mind, while we added the new dev_pm_domain_attach|detach() API. The
> buses also handles -EPROBE_DEFER.
>
> Now, I just realized that while Geert added attach|detach_dev()
> callbacks for the generic PM domain, those are both "void" callbacks.
> It means the deferred probe error handling is broken for these
> callbacks. We should convert the attach_dev() callback into an int, I
> will cook a patch immediately.
>
>>> Also, where is OOM error handling?
>> Ok,I will change the use  devm_kzalloc.
>> Register to pm domain devices, the number is not a lot.
> [...]
>
> Kind regards
> Uffe
>
>
>


