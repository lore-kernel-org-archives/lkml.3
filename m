Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933575AbaFQQFi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 12:05:38 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:55360 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755414AbaFQQFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 12:05:36 -0400
Message-ID: <53A06749.1010606@collabora.co.uk>
Date: Tue, 17 Jun 2014 18:05:29 +0200
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Mike Turquette <mturquette@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        Sjoerd Simons <sjoerd.simons@collabora.co.uk>,
        Daniel Stone <daniels@collabora.com>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 07/10] regulator: Add driver for Maxim 77802 PMIC regulators
References: <1402941758-11216-1-git-send-email-javier.martinez@collabora.co.uk> <1402941758-11216-8-git-send-email-javier.martinez@collabora.co.uk> <20140616192500.GJ5099@sirena.org.uk> <53A01D54.10506@collabora.co.uk> <20140617141254.GP5099@sirena.org.uk>
In-Reply-To: <20140617141254.GP5099@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Mark,

On 06/17/2014 04:12 PM, Mark Brown wrote:
> On Tue, Jun 17, 2014 at 12:49:56PM +0200, Javier Martinez Canillas wrote:
>> On 06/16/2014 09:25 PM, Mark Brown wrote:
> 
>> >> +	config.dev = &pdev->dev;
> 
>> > Are you sure this shouldn't be the MFD?
> 
>> I just looked at regulator_register() and saw that it does rdev->dev.parent =
>> dev, so yes this has to be the MFD.
>

I noticed that many drivers set config.dev = &pdev->dev. The original Chrome OS
max77xxx driver and max77686 are two examples but others drivers do the same:

$ git grep "config.dev = &pdev->dev" drivers/regulator/ | wc -l
35
$ git grep "config.dev = pdev->dev.parent" drivers/regulator/ | wc -l
11

And also I see that mfd_add_device() calls
devm_regulator_bulk_register_supply_alias(&pdev->dev,...) so I'm confused now
about what the correct device should be...

> Do the regulators manage to get their supplies?
> 

There are no current support in mainline for the devices that use the regulators
in this PMIC so I can't tell you if consumers manage to get their supplies
correctly (e.g: if regulator_dev_lookup succeeds).

But I see in the kernel log that the regulators are registered and configured as
expected [0] and also the driver in the Chrome OS 3.8 kernel is working for sure
and sets config.dev to &pdev->dev instead of the MFD.

>> So, for now I thought it made sense to set the operating mode to normal on
>> probe() but I'll change it to read from the hardware if that is better.
> 
> Yes, otherwise if the device is configured otherwise then when we change
> the configuration we may break something.
> 
>> I guess I should check in the datasheet if a sane default operating mode for
>> LDOs is expected when the chip is reseted or if this is left undefined and also
>> if the bootloader already set this.
> 
> You can't do anything based on the particular bootloader you're using in
> your current system, this has to work in other systems.
> 

Yes, that's why I thought it was a good idea to set to a default operational
mode but I'll change it to read from the hardware instead.

Thanks a lot and best regards,
Javier

[0]: http://pastebin.com/raw.php?i=8yyMXcGD
