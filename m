Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753911Ab3LUCcA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 21:32:00 -0500
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:64202 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752515Ab3LUCb6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 21:31:58 -0500
X-IronPort-AV: E=Sophos;i="4.95,525,1384329600"; 
   d="scan'208";a="4287923"
Message-ID: <52B4FD8E.1010009@broadcom.com>
Date: Fri, 20 Dec 2013 18:31:42 -0800
From: Sherman Yin <syin@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>, Mark Brown <broonie@kernel.org>
CC: Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Christian Daudt <bcm@fixthebug.org>,
        Russell King <linux@arm.linux.org.uk>,
        =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        bcm-kernel-feedback-list <bcm-kernel-feedback-list@broadcom.com>,
        Rob Landley <rob@landley.net>, Grant Likely <grant.likely@linaro.org>,
        Matt Porter <matt.porter@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 5/6] ARM: pinctrl: Add Broadcom Capri pinctrl driver
References: <1381174108-25168-1-git-send-email-syin@broadcom.com>	<1386787041-6035-1-git-send-email-syin@broadcom.com>	<1386787041-6035-6-git-send-email-syin@broadcom.com> <CACRpkdaeZCodKv6R+4ZS3o-5u=QQuV3JidEp7uaLsN9aYG7bqA@mail.gmail.com> <52B23618.2040508@broadcom.com>
In-Reply-To: <52B23618.2040508@broadcom.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13-12-18 03:56 PM, Sherman Yin wrote:
> On 13-12-12 12:54 PM, Linus Walleij wrote:

>>> +/*
>>> + * Write to the register using the value and mask if current value
>>> is different
>>> + */
>>> +static void capri_reg_write(struct pinctrl_dev *pctldev,
>>> +                           void __iomem *reg,
>>> +                           u32 val,
>>> +                           u32 mask)
>>> +{
>>> +       u32 old_val;
>>> +       u32 new_val;
>>> +
>>> +       old_val = readl(reg);
>>> +       new_val = (old_val & ~mask) | (val & mask);
>>> +
>>> +       if (new_val == old_val) {
>>> +               dev_dbg(pctldev->dev,
>>> +                       "Reg 0x%p=0x%x (no change)\n",
>>> +                       reg, old_val);
>>> +               return;
>>> +       }
>>> +
>>> +       dev_dbg(pctldev->dev,
>>> +               "Reg 0x%p change from 0x%x to 0x%x\n",
>>> +               reg, old_val, new_val);
>>> +       writel(new_val, reg);
>>> +}
>>
>> This is a reimplementation of regmap for MMIO.
>> See drivers/base/regmap/regmap-mmio.c
>> Notice how regmap_update_bits() is used throughout the
>> kernel.
>>
>> If you want to do this, use regmap.
>
> Ok.

As you can see in v4 of my patchset, I've changed my driver to use the 
mmio regmap.  However, as I was tracing through regmap_update_bits(), it 
looks like I have to go through a lot of checks and function pointers 
just to do a simple write to a register.  Also, I have to select 
REGMAP_MMIO which brings in a bunch of code as well.

I understand the benefits of using common code, but in this case it 
seems there is a lot of extra code and run-time overhead to use regmap. 
  In the end it also doesn't buy much in terms of functionality.

Just a quick note - it looks like the 2nd parameter of 
regmap_update_bits() wants the offset of a register (offset from 
regmap_mmio_context.regs).  So calling the parameter "reg" is a little 
confusing, at least in the MMIO case.

Regards,
Sherman
