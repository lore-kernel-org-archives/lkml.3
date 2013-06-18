Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932103Ab3FRJgA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 05:36:00 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:16098 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755681Ab3FRJf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 05:35:57 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 18 Jun 2013 02:34:21 -0700
Message-ID: <51C029F5.3000205@nvidia.com>
Date: Tue, 18 Jun 2013 12:35:49 +0300
From: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 1/2] mfd: tps65910: Fix crash in i2c_driver .probe
References: <1371491257-23791-1-git-send-email-ttynkkynen@nvidia.com> <1371491257-23791-2-git-send-email-ttynkkynen@nvidia.com> <51BF5060.8060001@wwwdotorg.org>
In-Reply-To: <51BF5060.8060001@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/17/2013 09:07 PM, Stephen Warren wrote:
> On 06/17/2013 11:47 AM, Tuomas Tynkkynen wrote:
>> Commit "i2c: core: make it possible to match a pure device tree driver"
>> changed semantics of the i2c probing for device tree devices.
>> Device tree probed devices now get a NULL i2c_device_id pointer.
>> This caused kernel panics due to NULL dereference.
> 
>> diff --git a/drivers/mfd/tps65910.c b/drivers/mfd/tps65910.c
> 
>>  	pmic_plat_data = dev_get_platdata(&i2c->dev);
>>  
>> -	if (!pmic_plat_data && i2c->dev.of_node) {
>> +	if (id) {
>> +		chip_id = id->driver_data;
>> +	} else if (i2c->dev.of_node) {
>>  		pmic_plat_data = tps65910_parse_dt(i2c, &chip_id);
> 
> That over-writes pmic_plat_data even if it was already set above. This
> should really only happen if the earlier assignment didn't find any
> pdata, i.e. if (!pmic_plat_data) here.

That would cause the probe() to fail since it doesn't have a chip_id.

> 
> Looking at patch 2/2, the structure in that driver is correct, and
> perhaps could be implemented the same or similarly here?
> 

This seems to be the best way, I'll change it that way.

>>  		of_pmic_plat_data = pmic_plat_data;
> 
> Or just swap those assignments:
> 
> of_pmic_plat_data = tps65910_parse_dt(...);
> if (!pmic_plat_data)
>     pmic_plat_data = of_pmic_plat_data;
> 
> (although there's perhaps little point parsing the pdata from DT if it's
> already provided through the device object)

Yeah, especially since tps65910_parse_dt can dev_warn().

> 
>>  	}
>>  
>> -	if (!pmic_plat_data)
>> +	if (!pmic_plat_data || chip_id < 0)
>>  		return -EINVAL;
> 

