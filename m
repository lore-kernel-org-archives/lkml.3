Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966659Ab3HHVLH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 17:11:07 -0400
Received: from mms3.broadcom.com ([216.31.210.19]:3719 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966602Ab3HHVLF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 17:11:05 -0400
X-Server-Uuid: B86B6450-0931-4310-942E-F00ED04CA7AF
Message-ID: <52040962.6040003@broadcom.com>
Date: Thu, 8 Aug 2013 14:10:58 -0700
From: "Christian Daudt" <csd@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803
 Thunderbird/17.0.8
MIME-Version: 1.0
To: "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>
cc: "Chris Ball" <cjb@laptop.org>, "Shawn Guo" <shawn.guo@linaro.org>,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mmc: change mmc_gpio_get_cd to call non-sleep gpio
References: <1375994855-12472-1-git-send-email-csd@broadcom.com>
 <Pine.LNX.4.64.1308082258260.29611@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1308082258260.29611@axis700.grange>
X-WSS-ID: 7E1AD8842L872426877-01-01
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13-08-08 02:06 PM, Guennadi Liakhovetski wrote:
> On Thu, 8 Aug 2013, Christian Daudt wrote:
>
>> Given that mmc_gpio_get_cd can be called in softirq
>> context (by sdhci_tasklet_card -> sdhci_card_event ->
>> sdhci_do_get_cd -> mmc_gpio_get_cd ), it is necessary
>> for it to use gpio_get_value instead of
>> gpio_get_value_cansleep
>> Note that at present sdhci_card_event gets called both
>> from mmc_gpio_cd_irqt and sdhci_tasklet_card, and from
>> both it gets called immediately while the actual cd
>> processing is debounced to 200ms later. I think that
>> the better solution might be to move the sdhci_card_event
>> callback into mmc_rescan and remove it from its 2
>> present locations. That way the cd related callbacks
>> are aligned with the actual cd detection code. I can
>> submit a follow-up patch with these mods if that sounds
>> like a better way to solve this.
>>
>> Signed-off-by: Christian Daudt <csd@broadcom.com>
> I don't think this is a right approach. It will Oops if the card-detect
> GPIO is provided by, e.g. an I2C GPIO controller. Instead the driver
> should be fixed to only call this function from a sleeping context.
I don't think that card-detect would ever be tied to i2c but I might be 
wrong on that one... If there's agreement that moving sdhci_card_event 
into just being called from mmc_rescan is the better way to solve this, 
then I'll drop this patch and replace it with one that does just that.

  Thanks,
    csd


