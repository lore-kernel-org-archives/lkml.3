Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753216AbaF0Jme (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 05:42:34 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:33864 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752779AbaF0Jmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 05:42:33 -0400
Message-ID: <53AD3C81.7070607@collabora.co.uk>
Date: Fri, 27 Jun 2014 11:42:25 +0200
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: Samuel Ortiz <sameo@linux.intel.com>, Mark Brown <broonie@kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        Sjoerd Simons <sjoerd.simons@collabora.co.uk>,
        Daniel Stone <daniels@collabora.com>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Yadwinder Singh Brar <yadi.brar01@gmail.com>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 10/14] regulator: Add driver for Maxim 77802 PMIC regulators
References: <1403806546-31122-1-git-send-email-javier.martinez@collabora.co.uk> <1403806546-31122-11-git-send-email-javier.martinez@collabora.co.uk> <20140627092611.GI19645@lee--X1>
In-Reply-To: <20140627092611.GI19645@lee--X1>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Lee,

Thanks a lot for your feedback.

On 06/27/2014 11:26 AM, Lee Jones wrote:
> On Thu, 26 Jun 2014, Javier Martinez Canillas wrote:
>> The MAX77802 PMIC has 10 high-efficiency Buck and 32 Low-dropout
>> (LDO) regulators. This patch adds support for all these regulators
>> found on the MAX77802 PMIC and is based on a driver added by Simon
>> Glass to the Chrome OS kernel 3.8 tree.
>> 
>> Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
>> Tested-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
>> ---
>> 
>> Changes since v4: None
>> 
>> Changes since v3:
>>  - Set the supply_name for regulators to lookup their parent supply node.
>>    Suggested by Mark Brown.
>>  - Change Exyno5 for Exynos5420/Exynos5800 in regulator driver Kconfig.
>>    Suggested by Doug Anderson.
>> 
>> Changes since v2:
>>  - Use dev_warn() instead pr_warn(). Suggested by Mark Brown.
>>  - Add a generic function to regmap core to copy registers instead of
>>    having a driver-specific function. Suggested by Mark Brown.
>>  - Remove unnecessary probe debug log. Suggested by Mark Brown.
>>  - Set struct regulator_config dev field to MFD instead of the platform dev.
>>    Suggested by Mark Brown.
>>  - Read the regulators operational mode from the hardware registers instead
>>    of setting to normal as default on probe. Suggested by Mark Brown.
>>  - Remove unnecessary cross-subsystem dependencies. Suggested by Lee Jones.
>> 
>> Changes since v1:
>>  - Remove unneeded check if num_regulators != MAX77802_MAX_REGULATORS.
>>  - Fix .set_suspend_mode handler comment and split regulators ops for
>>    regulators that behave differently. Suggested by Mark Brown.
>>  - Use module_platform_driver() instead of having init/exit functions.
>>    Suggested by Mark Brown.
>>  - Use the new descriptor-based GPIO interface instead of the deprecated
>>    integer based GPIO one. Suggested by Mark Brown.
>>  - Look for "regulators" child node instead of "voltage-regulators" to be
>>    consistent with other PMIC drivers. Suggested by Mark Brown.
>> 
>>  drivers/mfd/max77802.c               |   8 +-
>>  drivers/regulator/Kconfig            |   9 +
>>  drivers/regulator/Makefile           |   1 +
>>  drivers/regulator/max77802.c         | 694 +++++++++++++++++++++++++++++++++++
>>  include/linux/mfd/max77802-private.h |   3 -
>>  5 files changed, 711 insertions(+), 4 deletions(-)
>>  create mode 100644 drivers/regulator/max77802.c
>> 
>> diff --git a/drivers/mfd/max77802.c b/drivers/mfd/max77802.c
>> index 3d477fb..79d36b6 100644
>> --- a/drivers/mfd/max77802.c
>> +++ b/drivers/mfd/max77802.c
>> @@ -228,7 +228,7 @@ static int max77802_i2c_probe(struct i2c_client *i2c,
>>  
>>  	max77802 = devm_kzalloc(&i2c->dev, sizeof(struct max77802_dev),
>>  				GFP_KERNEL);
>> -	if (max77802 == NULL)
>> +	if (!max77802)
>>  		return -ENOMEM;
>>  
>>  	i2c_set_clientdata(i2c, max77802);
>> @@ -315,6 +315,12 @@ static int max77802_suspend(struct device *dev)
>>  	if (device_may_wakeup(dev))
>>  		enable_irq_wake(max77802->irq);
>>  
>> +	/*
>> +	 * The IRQ must be disabled during suspend since due wakeup
>> +	 * ordering issues it may be possible that the I2C controller
>> +	 * is still suspended when the interrupt happens so the IRQ
>> +	 * handler will fail to read the I2C bus.
>> +	 */
> 
> Please re-word this, the English is a little off.
> 

Ok, I found that drivers/mfd/max14577.c has a similar comment so I'll just reuse
that one since explains it way better.

>>  	disable_irq(max77802->irq);
>>  
>>  	return 0;
> 
> Please separate the MFD changes out.  There is no need for them to be
> munged in with regulator changes.
>

Yes, when preparing v5 I squashed the mfd driver changes into the patch adding
the regulator driver by mistake instead with the one adding the mfd driver.
Sorry about that...

I'll wait for your complete review so I can fix all the issues you find and post
a v6.

Best regards,
Javier
