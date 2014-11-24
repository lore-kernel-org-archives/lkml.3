Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753864AbaKXNQY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 08:16:24 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:32995 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753308AbaKXNQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 08:16:22 -0500
Message-ID: <54732F8E.4080105@ti.com>
Date: Mon, 24 Nov 2014 15:15:58 +0200
From: Grygorii Strashko <grygorii.strashko@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: =?windows-1252?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
CC: Wolfram Sang <wsa@the-dreams.de>, <linux-i2c@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Sekhar Nori <nsekhar@ti.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Santosh Shilimkar <ssantosh@kernel.org>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Ben Gardiner <bengardiner@nanometrics.ca>,
        Mike Looijmans <milo-software@users.sourceforge.net>
Subject: Re: [5/5] i2c: davinci: use ICPFUNC to toggle I2C as gpio for bus
 recovery
References: <1416477788-5544-6-git-send-email-grygorii.strashko@ti.com> <20141123170400.GC4431@pengutronix.de>
In-Reply-To: <20141123170400.GC4431@pengutronix.de>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Uwe,
On 11/23/2014 07:04 PM, Uwe Kleine-König wrote:
> On Thu, Nov 20, 2014 at 12:03:08PM +0200, Grygorii Strashko wrote:
>> @@ -664,6 +759,7 @@ static int davinci_i2c_probe(struct platform_device *pdev)
>>   		if (!of_property_read_u32(pdev->dev.of_node, "clock-frequency",
>>   			&prop))
>>   			dev->pdata->bus_freq = prop / 1000;
>> +		dev->pdata->has_pfunc = true;
> I don't understand this. Why does this ICPFUNC recovery work if the bus
> is probed by oftree, but doesn't if not?

I've mentioned this in commit message:
 Allow platforms to indicate the presence of the ICPFUNC registers with a has_pfunc
 platform data flag and enable this mode for platforms which supports DT (da850 and
 Keystone 2 are two SoCs which support DT now and they also support ICPFUNC registers).

I'll add proper comment here.

> 
>>   	} else if (!dev->pdata) {
>>   		dev->pdata = &davinci_i2c_platform_data_default;
>>   	}
>> @@ -705,7 +801,9 @@ static int davinci_i2c_probe(struct platform_device *pdev)
>>   	adap->timeout = DAVINCI_I2C_TIMEOUT;
>>   	adap->dev.of_node = pdev->dev.of_node;
>>   
>> -	if (dev->pdata->scl_pin) {
>> +	if (dev->pdata->has_pfunc)
>> +		adap->bus_recovery_info = &davinci_i2c_scl_recovery_info;
>> +	else if (dev->pdata->scl_pin) {
>>   		adap->bus_recovery_info = &davinci_i2c_gpio_recovery_info;
>>   		adap->bus_recovery_info->scl_gpio = dev->pdata->scl_pin;
>>   		adap->bus_recovery_info->sda_gpio = dev->pdata->sda_pin;
>> diff --git a/include/linux/platform_data/i2c-davinci.h b/include/linux/platform_data/i2c-davinci.h
>> index 2312d19..89fd347 100644
>> --- a/include/linux/platform_data/i2c-davinci.h
>> +++ b/include/linux/platform_data/i2c-davinci.h
>> @@ -18,6 +18,7 @@ struct davinci_i2c_platform_data {
>>   	unsigned int	bus_delay;	/* post-transaction delay (usec) */
>>   	unsigned int    sda_pin;        /* GPIO pin ID to use for SDA */
>>   	unsigned int    scl_pin;        /* GPIO pin ID to use for SCL */
>> +	bool		has_pfunc;	/*chip has a ICPFUNC register */
> Space after /* please
> 

regards,
-grygorii

