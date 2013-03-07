Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755993Ab3CGKLa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 05:11:30 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:13496 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754255Ab3CGKL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 05:11:29 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 07 Mar 2013 02:11:28 -0800
Message-ID: <513867CD.4030201@nvidia.com>
Date: Thu, 7 Mar 2013 19:11:25 +0900
From: Alex Courbot <acourbot@nvidia.com>
Organization: NVIDIA
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: Andrew Chew <AChew@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1 v4] pwm_bl: Add support for backlight enable regulator
References: <1362590238-27692-1-git-send-email-achew@nvidia.com> <20130307071102.GB3451@avionic-0098.mockup.avionic-design.de>
In-Reply-To: <20130307071102.GB3451@avionic-0098.mockup.avionic-design.de>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/07/2013 04:11 PM, Thierry Reding wrote:
>> +	bool			en_supply_enabled;
>
> This boolean can be dropped. As discussed in a previous thread, the
> pwm-backlight driver shouldn't need to know about any other uses of the
> regulator.

Sorry for being obstinate - but I'm still not convinced we can get rid 
of it. I checked the regulator code, and as you mentioned in the 
previous version, calls to regulator_enable() and regulator_disable() 
*must* be balanced in this driver.

Without this variable we would call regulator_enable() every time 
pwm_backlight_enable() is called (and same thing when disabling). Now 
imagine the driver is asked to set the following intensities: 5, 12, 
then 0. You would have two calls to regulator_enable() but only one to 
regulator_disable(), which would result in the enable GPIO remaining 
active even though it would be shut down. Or I missed something obvious.

The regulator must be enabled/disabled on transitions from/to 0, and 
AFAICT there is no way for this driver to detect them.

>> +static void pwm_backlight_enable(struct backlight_device *bl)
>> +{
>> +	struct pwm_bl_data *pb = dev_get_drvdata(&bl->dev);
>> +
>> +	pwm_enable(pb->pwm);
>> +
>> +	if (pb->en_supply && !pb->en_supply_enabled) {
>> +		if (regulator_enable(pb->en_supply) != 0)
>> +			dev_warn(&bl->dev, "Failed to enable regulator");
>> +		else
>> +			pb->en_supply_enabled = true;
>> +	}
>> +}
>> +
>> +static void pwm_backlight_disable(struct backlight_device *bl)
>> +{
>> +	struct pwm_bl_data *pb = dev_get_drvdata(&bl->dev);
>> +
>> +	if (pb->en_supply && pb->en_supply_enabled) {
>> +		if (regulator_disable(pb->en_supply) != 0)
>> +			dev_warn(&bl->dev, "Failed to disable regulator");
>> +		else
>> +			pb->en_supply_enabled = false;
>> +	}
>> +
>> +	pwm_disable(pb->pwm);
>> +}
>
> Alex already brought this up: shouldn't the sequences be reversed. That
> is, when enabling the backlight, turn on the regulator first, then
> enable the PWM. When disabling, disable the PWM first, then turn off the
> regulator?

Actually the current sequence seems to make sense - the PWM is always 
active when the enable GPIO is switched. If we do the contrary, we might 
have a short time where the backlight is enabled without receiving 
anything from the PWM. Don't think that would be serious, but the 
current behavior is similar to e.g. panels which we enable only after a 
signal is available.

>> @@ -213,6 +238,13 @@ static int pwm_backlight_probe(struct platform_device *pdev)
>>   	pb->exit = data->exit;
>>   	pb->dev = &pdev->dev;
>>
>> +	pb->en_supply = devm_regulator_get(&pdev->dev, "enable");
>> +	if (IS_ERR(pb->en_supply)) {
>> +		ret = PTR_ERR(pb->en_supply);
>> +		pb->en_supply = NULL;
>> +		goto err_alloc;
>> +	}
>
> This effectively makes the regulator mandatory, so the board files that
> use pwm-backlight need to be updated or otherwise will break.

Yes. Btw, should such changes go into the same patch? This seems 
difficult to split without breaking things at some point.

Alex.

