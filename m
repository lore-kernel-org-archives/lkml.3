Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753570AbaKMCTq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 21:19:46 -0500
Received: from regular1.263xmail.com ([211.150.99.138]:46354 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752900AbaKMCTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 21:19:44 -0500
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: addy.ke@rock-chips.com
X-FST-TO: dianders@chromium.org
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: addy.ke@rock-chips.com
X-UNIQUE-TAG: <7b771378d53bbcdd73001720530e6317>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
Message-ID: <5464152E.7040209@rock-chips.com>
Date: Thu, 13 Nov 2014 10:19:26 +0800
From: addy ke <addy.ke@rock-chips.com>
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: dianders@chromium.org, ulf.hansson@linaro.org
CC: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        rdunlap@infradead.org, tgih.jun@samsung.com, jh80.chung@samsung.com,
        chris@printf.net, dinguyen@altera.com, heiko@sntech.de, olof@lixom.net,
        sonnyrao@chromium.org, amstan@chromium.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, zhenfu.fang@rock-chips.com,
        cf@rock-chips.com, lintao@rock-chips.com, chenfen@rock-chips.com,
        zyf@rock-chips.com, xjq@rock-chips.com, huangtao@rock-chips.com,
        zyw@rock-chips.com, yzq@rock-chips.com, hj@rock-chips.com,
        kever.yang@rock-chips.com, zhangqing@rock-chips.com, hl@rock-chips.com
Subject: Re: [PATCH] mmc: dw_mmc: try pick the exact same voltage as vmmc
 for vqmmc
References: <1415109789-7046-1-git-send-email-addy.ke@rock-chips.com>	<1415678573-6093-1-git-send-email-addy.ke@rock-chips.com>	<CAPDyKFqUoBjhsbz8rkLa9PY_dpgMxnimz3k7OoA5WVhi7MacPQ@mail.gmail.com> <CAD=FV=VQHZ6YmcoeAb1OEVLYRrYBnc_dM5Kjt1TZX_CQJC=EfA@mail.gmail.com>
In-Reply-To: <CAD=FV=VQHZ6YmcoeAb1OEVLYRrYBnc_dM5Kjt1TZX_CQJC=EfA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/11/13 02:04, Doug Anderson wrote:
> Ulf,
> 
> On Tue, Nov 11, 2014 at 12:52 AM, Ulf Hansson <ulf.hansson@linaro.org> wrote:
>> On 11 November 2014 05:02, Addy Ke <addy.ke@rock-chips.com> wrote:
>>> SD2.0 cards need vqmmc and vmmc to be the same.
>>
>> No, that's not correct.
>>
>> If I remember the spec correctly, the bus signal threshold is 0.75 * VDD.
> 
> As usual, I will first state my utter lack of knowledge of all things mmc.
> 
> Now that's out of the way, on two separate board with two separate
> SoCs I've heard stories of cards that don't work when there's a big
> gap between vmmc and vqmmc.
> 
> If my memory serves, previously I heard of problems with vmmc=3.3V and
> vqmmc=2.8V.  That means there were problems with .85 * VDD.  Certainly
> Addy seems to have a card that has problems with vmmc=3.3V and
> vqmmc=2.7V (but worked with vmmc=3.3V and vqmmc=2.8V).  That is .82 *
> VDD.
> 
> I have no idea if these old cards are "to spec", but they exist and it
> would be nice to support them.
> 
> It seems like the absolute safest thing would be to try to keep vmmc
> and vqmmc matching if possible, especially during card probe.  Once
> voltage negotiation happened then the vqmmc could go down.
> 
> 
>>> But vqmmc call regulator_set_voltage to set min_uv(2.7v) as far as possible.
>>
>> I guess you want to do that to save as much power as possible.
> 
> I don't think it's Addy wanting it, I think it's the regulator framework.
> 
> If a regulator is current 1.8V and you request 2.7 - 3.3V, the
> framework needs to pick one of those voltages.  I believe it will pick
> 2.7V.
> 
> ...so I think we get into trouble only when the 2.0 card is plugged in
> after a UHS card has negotiated down the voltage, but I could be
> wrong.  Maybe Addy can clarify.
> 
Sure
If the first card is sd2.0 since startup, dw_mci_switch_voltage will not be called,
and card can be identified. But if UHS card is pulgged in first, the vqmmc will be down to 1.8v.

when sd2.0 card is pulgged in, mmc core will call dw_mci_switch_voltage to change vqmmc to 3.3v
(MMC_SINGLE_VOTAGE_330). So vqmmc will be set 2.7v, if we request 2.7-3.6v.

But vmmc is always 3.3v,becuase it be set min_volt = max_volt = 3.3v in dt tables.

So the result:
vmmc = 3.3v and vqmmc = 2.7v, and sd2.0 card is failed to identify in my test.

> 
>>> @@ -1163,8 +1163,14 @@ static int dw_mci_switch_voltage(struct mmc_host *mmc, struct mmc_ios *ios)
>>>          */
>>>         uhs = mci_readl(host, UHS_REG);
>>>         if (ios->signal_voltage == MMC_SIGNAL_VOLTAGE_330) {
>>> -               min_uv = 2700000;
>>> -               max_uv = 3600000;
>>> +               /* try pick the exact same voltage as vmmc for vqmmc */
>>
>> This seems like a generic SD protocol issue.
>>
>> Should we maybe provide some helper function from the mmc core, which
>> in principle take the negotiated card->ocr into account while
>> calculating the signal voltage level. Typically min_uv should be 0.75
>> x (card->ocr), for these cases.
> 
> Yes, if there are ways to make the solution more generic I would
> certainly support that.
> 
> -Doug
> 
> 
> 

