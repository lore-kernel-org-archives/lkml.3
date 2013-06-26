Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751389Ab3FZGxA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 02:53:00 -0400
Received: from protonic.xs4all.nl ([213.84.116.84]:5777 "EHLO
	protonic.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729Ab3FZGw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 02:52:59 -0400
Message-ID: <51CA8FC8.50208@protonic.nl>
Date: Wed, 26 Jun 2013 08:52:56 +0200
From: Robin van der Gracht <robin@protonic.nl>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>
Cc: linux-pwm@vger.kernel.org, linux-kernel@vger.kernel.org,
        shawn.guo@linaro.org
Subject: Re: [PATCH] pwm: pwm-mxs: Apply configuration before disabling PWM.
References: <1371642686-10300-1-git-send-email-robin@protonic.nl> <20130621100254.GB12441@manwe>
In-Reply-To: <20130621100254.GB12441@manwe>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Thierry,


On 06/21/2013 12:02 PM, Thierry Reding wrote:
> Please use my new email address and Cc the linux-pwm mailing list.
>
> The subject implies some active procedure is used to make sure the
> configuration is applied, but you really only wait for some amount of
> time. Perhaps something like:
>
> 	pwm: pwm-mxs: Wait for configuration to apply before disabling PWM
>
> is more accurate?
Agreed
>
> On Wed, Jun 19, 2013 at 01:51:26PM +0200, Robin van der Gracht wrote:
>> When disabling the pwm, the output state locks at its current state.
> Please use the proper spelling "PWM" in prose.
Ok
>
>> We have to be sure the last configuration applied. Which in most
>> cases sets duty cycle to 0%. To prevent the pwm from taking on
>> 100% duty cycle when disabled during a high state.
>>
>> Configuration applies at the beginning of a new output period.
> I have some trouble understanding this, but I think you mean:
>
> We have to be sure that the last configuration has been applied. In most
> cases drivers will have set the duty-cycle to 0%. To prevent the PWM
> from locking at a 100% duty-cycle for example, we delay disabling the
> PWM for a whole period to make sure any new configuration has been
> latched.
Yes that is correct.
>
>> diff --git a/drivers/pwm/pwm-mxs.c b/drivers/pwm/pwm-mxs.c
>> index 3febddd..4ddc063 100644
>> --- a/drivers/pwm/pwm-mxs.c
>> +++ b/drivers/pwm/pwm-mxs.c
>> @@ -21,6 +21,7 @@
>>   #include <linux/pwm.h>
>>   #include <linux/slab.h>
>>   #include <linux/stmp_device.h>
>> +#include <linux/delay.h>
> Please keep the includes sorted alphabetically.
I'll update that.
>
>>   
>>   #define SET	0x4
>>   #define CLR	0x8
>> @@ -40,6 +41,7 @@ struct mxs_pwm_chip {
>>   	struct pwm_chip chip;
>>   	struct clk *clk;
>>   	void __iomem *base;
>> +	unsigned long period_ns;
> This is not the proper place to put it. The period can be different for
> each PWM channel. But you also don't need to store this separately as in
> latest linux-next this is already done by the core. You can use the
> pwm_get_period() function to obtain the current period from a PWM
> device.
>
>> @@ -113,6 +116,11 @@ static void mxs_pwm_disable(struct pwm_chip *chip, struct pwm_device *pwm)
>>   {
>>   	struct mxs_pwm_chip *mxs = to_mxs_pwm_chip(chip);
>>   
>> +	/*
>> +	 * Ensure latest configuration applied.
>> +	 */
> This comment can go on a single line.
>
>> +	ndelay(mxs->period_ns);
> This introduces a potentially long delay. How about changing this to
> something like:
>
> 	period = pwm_get_period(pwm);
> 	period = DIV_ROUND_UP(period, 1000);
> 	usleep_range(period, period + 1000);
Thanks for the input, I agree on your comment. I'll resubmit the patch.
>
> ?
>
> Thierry


-- 
Robin van der Gracht
Protonic Holland.
tel.: +31 (0) 229 212928
fax.: +31 (0) 229 210930
Factorij 36 / 1689 AL Zwaag

