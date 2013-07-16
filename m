Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932958Ab3GPO0f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 10:26:35 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:41150 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932271Ab3GPO0d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 10:26:33 -0400
Message-ID: <51E557D1.4000707@ti.com>
Date: Tue, 16 Jul 2013 17:25:21 +0300
From: Grygorii Strashko <grygorii.strashko@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: <linus.walleij@linaro.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Stephen Warren <swarren@wwwdotorg.org>
Subject: Re: [PATCH 1/4] pinctrl: Remove duplicate code in pinctrl_pm_select_state
 functions
References: <20130716090310.5541.36777.stgit@localhost> <20130716090529.5541.54331.stgit@localhost> <51E5475B.1050900@ti.com> <20130716134118.GC7656@atomide.com>
In-Reply-To: <20130716134118.GC7656@atomide.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tony,

On 07/16/2013 04:41 PM, Tony Lindgren wrote:
> * Grygorii Strashko <grygorii.strashko@ti.com> [130716 06:22]:
>> Hi Tony,
>>
>> This patch causes boot failure when I've applied my patch
>> "[RFC] ARM: OMAP2+: omap_device: add pinctrl handling"
>> https://lkml.org/lkml/2013/6/21/309
>>
>> on top of it:
>
> Hmm this patch alone removes duplicate code and if it causes
> issues I must have made a typo somewhere.

No typo :) You've removed the check for !dev-pins.
And the failure place is:
int pinctrl_pm_select_active_state(struct device *dev)
{
    return pinctrl_pm_select_state(dev, dev->pins->active_state);
                                                 ^^^^ here
}

If I understand everything right, the pinctrl support in Device core
assumed to be optional - so, It's valid case, when there are no
definition for device's pinctrl in DT at all.

And in this case dev->pins == NULL and  pinctrl_pm_select_*() API
should return 0 always.

>
> I cannot see a typo though, but in your dmesg I see something..
>
>> [    0.610565] PC is at pinctrl_pm_select_active_state+0x4/0xc
Yep. This will happen if there are no pinctrl states defined in DT
- currently it's crashed when GPIO driver probed.
>
> ..looks like you have something applied for the active_state
> that only gets introduced later on in this series.
>
> Maybe you have the earlier version of drivers/base/pinctrl.c
> active_state patch that was in linux next for a while but
> got reverted as we noticed we had to rework some things?
>
> So maybe try with v3.11-rc1 + these four patches + your
> omap_device patch?
I'm on v3.11-rc1

>
> Regards,
>
> Tony
>

