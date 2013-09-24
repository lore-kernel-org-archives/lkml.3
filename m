Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754386Ab3IXPq3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 11:46:29 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:60342 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752988Ab3IXPq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 11:46:28 -0400
Message-ID: <5241B3B4.7020603@collabora.co.uk>
Date: Tue, 24 Sep 2013 17:45:56 +0200
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130704 Icedove/17.0.7
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Kevin Hilman <khilman@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Lars Poeschel <larsi@wh2.tu-dresden.de>,
        Grant Likely <grant.likely@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Kumar Gala <galak@codeaurora.org>, Pawel Moll <pawel.moll@arm.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Enric Balletbo i Serra <eballetbo@gmail.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Balaji T K <balajitk@ti.com>, Jon Hunter <jgchunter@gmail.com>,
        linux-gpio@vger.kernel.org, linux-omap@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        r.sricharan@ti.com, holler@ahsoftware.de
Subject: Re: [RFC v2] gpio/omap: auto-setup a GPIO when used as an IRQ
References: <1380009480-4975-1-git-send-email-javier.martinez@collabora.co.uk> <20130924154048.GM2684@atomide.com>
In-Reply-To: <20130924154048.GM2684@atomide.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/2013 05:40 PM, Tony Lindgren wrote:
> * Javier Martinez Canillas <javier.martinez@collabora.co.uk> [130924 01:06]:
>> The OMAP GPIO controller HW requires a pin to be configured in GPIO
>> input mode in order to operate as an interrupt input. Since drivers
>> should not be aware of whether an interrupt pin is also a GPIO or not,
>> the HW should be fully configured/enabled as an IRQ if a driver solely
>> uses IRQ APIs such as request_irq(), and never calls any GPIO-related
>> APIs. As such, add the missing HW setup to the OMAP GPIO controller's
>> irq_chip driver.
>> 
>> Since this bypasses the GPIO subsystem we have to ensure that another
>> caller won't be able to request the same GPIO pin that is used as an
>> IRQ and set its direction as output. Requesting the GPIO and setting
>> its direction as input is allowed though.
> 
> Also please mention the regression that this fixes. So far we know
> that smsc911x for tobi and igep boards in mainline, and also the
> MMC card detect for omap4 boards.
>  

Ok, I'll mention that on the next post.

>> --- a/drivers/gpio/gpio-omap.c
>> +++ b/drivers/gpio/gpio-omap.c
>> @@ -63,6 +63,7 @@ struct gpio_bank {
>>  	struct gpio_chip chip;
>>  	struct clk *dbck;
>>  	u32 mod_usage;
>> +	u32 irq_usage;
>>  	u32 dbck_enable_mask;
>>  	bool dbck_enabled;
>>  	struct device *dev;
>> @@ -86,6 +87,9 @@ struct gpio_bank {
>>  #define GPIO_BIT(bank, gpio) (1 << GPIO_INDEX(bank, gpio))
>>  #define GPIO_MOD_CTRL_BIT	BIT(0)
>>  
>> +#define BANK_USED(bank) (bank->mod_usage || bank->irq_usage)
>> +#define LINE_USED(line, offset) (line & (1 << offset))
> 
> Hmm this patch is hard to read, maybe break it into two patches?
> 
> First you could do a patch to prepare thing by introducing
> BANK_USED and LINE_USED.
> 
>> +static int gpio_is_input(struct gpio_bank *bank, int mask)
>> +{
>> +	void __iomem *reg = bank->base + bank->regs->direction;
>> +
>> +	return __raw_readl(reg) & mask;
>> +}
> 
> And also move gpio_is_input() around in the first patch.
> 
> Then the second patch for the fix would probably be much
> easier to read.
>

Sure will split in more patches, I just wanted to keep in one patch since it was
a RFC but it seems that the change makes sense so I'll post it as a proper
patch-set.

> Regards,
> 
> Tony
> 

Thanks a lot for your feedback and best regards,
Javier
