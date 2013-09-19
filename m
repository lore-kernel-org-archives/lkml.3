Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753449Ab3ISQNy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 12:13:54 -0400
Received: from smtp.newsguy.com ([74.209.136.69]:55385 "EHLO smtp.newsguy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751894Ab3ISQNx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 12:13:53 -0400
Message-ID: <523B2297.8000602@newsguy.com>
Date: Thu, 19 Sep 2013 09:13:11 -0700
From: Mike Dunn <mikedunn@newsguy.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.6
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>
CC: Richard Purdie <rpurdie@rpsys.net>, Jingoo Han <jg1.han@samsung.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, linux-pwm@vger.kernel.org,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Robert Jarzmik <robert.jarzmik@free.fr>,
        Marek Vasut <marex@denx.de>
Subject: Re: [PATCH] pwm-backlight: allow for non-increasing brightness levels
References: <1379010952-8928-1-git-send-email-mikedunn@newsguy.com> <20130919115650.GE10852@ulmo>
In-Reply-To: <20130919115650.GE10852@ulmo>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/19/2013 04:56 AM, Thierry Reding wrote:
> On Thu, Sep 12, 2013 at 11:35:52AM -0700, Mike Dunn wrote:
>> Currently the driver assumes that the values specified in the brightness-levels
>> device tree property increase as they are parsed from left to right.  But boards
>> that invert the signal between the PWM output and the backlight will need to
>> specify decreasing brightness-levels.  This patch removes the assumption that
>> the last element of the array is the max value, and instead searches the array
>> for the max value and uses that as the normalizing value when determining the
>> duty cycle.
> 
> "maximum value", "... and uses that as the scale to normalize the duty
> cycle"?


It's been a while since my last math class... is "normalizing value" not the
correct term?  Maybe just "uses that in the duty cycle calculation"?


> 
> Also please wrap commit messages at 72 characters.


OK.  Sorry, didn't know.


> 
>> diff --git a/drivers/video/backlight/pwm_bl.c b/drivers/video/backlight/pwm_bl.c
>> index 1fea627..d66aaa0 100644
>> --- a/drivers/video/backlight/pwm_bl.c
>> +++ b/drivers/video/backlight/pwm_bl.c
>> @@ -27,6 +27,7 @@ struct pwm_bl_data {
>>  	unsigned int		period;
>>  	unsigned int		lth_brightness;
>>  	unsigned int		*levels;
>> +	unsigned int		max_level;
> 
> Perhaps call this "scale"? Otherwise there some potential to mix it up
> with max_brightness.


Yes, this name is thorny.  The code was somewhat confusing to me until I
realized that for the DT case, brightness and max_brightness are indices into
the levels[] array, whereas they are actual values for the platform_data case.
I'll go with "scale" if you prefer.


> 
>> @@ -195,7 +196,15 @@ static int pwm_backlight_probe(struct platform_device *pdev)
>>  	}
>>  
>>  	if (data->levels) {
>> -		max = data->levels[data->max_brightness];
>> +		int i, max_value = 0, max_idx = 0;
> 
> i should be unsigned int to match the type of data->max_brightness.


Yes, thanks.  I'm surprised there's no warning from the compiler.  I'm also
assigning an unsigned to a signed.


> 
>> +		for (i = 0; i <= data->max_brightness; i++) {
> 
> There should be a blank line above this one to increase readability.
> 
>> +			if (data->levels[i] > max_value) {
>> +				max_value = data->levels[i];
>> +				max_idx = i;
>> +			}
>> +		}
>> +		pb->max_level = max_idx;
> 
> Some here.
> 
> Also I suggest to just drop the max_ prefix from the local variables.
> Perhaps also simplify all of it to something like:
> 
> 	for (i = 0; i <= data->max_brightness; i++)
> 		if (data->levels[i] > pb->scale)
> 			pb->scale = data->levels[i];
> 
> And get rid of the index altogether. That way you can use pb->scale
> directly during the computation of the duty cycle and don't have to
> index the levels array over and over again.


Ok, if you prefer.  The reason I made max_level an index is for consistency.
For the DT case, brightness and max_brightness are indices, and I had already
been confused by the value-versus-index issue.

Thanks much for the review!  I'll ready a v2 patch.

Mike

