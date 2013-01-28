Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755244Ab3A1IqD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 03:46:03 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:46353 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755160Ab3A1Ip7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 03:45:59 -0500
Message-ID: <51063AB5.2060108@ti.com>
Date: Mon, 28 Jan 2013 09:45:41 +0100
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130115 Thunderbird/17.0.2
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: Florian Vaussard <florian.vaussard@epfl.ch>, Bryan Wu <cooloney@gmail.com>,
        Richard Purdie <rpurdie@rpsys.net>, <linux-leds@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/3] pwm: Add pwm_cansleep() as exported API to users
References: <1359121471-21457-1-git-send-email-florian.vaussard@epfl.ch> <1359121471-21457-2-git-send-email-florian.vaussard@epfl.ch> <20130126054024.GB29243@avionic-0098.adnet.avionic-design.de>
In-Reply-To: <20130126054024.GB29243@avionic-0098.adnet.avionic-design.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi Thierry,

On 01/26/2013 06:40 AM, Thierry Reding wrote:
>> +  * @pwm: PWM device
>> +  *
>> +  * It returns nonzero if accessing the PWM can sleep.
>> +  */
>> +int pwm_cansleep(struct pwm_device *pwm)
> 
> I actually liked pwm_can_sleep() better. I find it to be more consistent
> with the naming of other function names. It would furthermore match the
> field name.

I was looking at the GPIO API to suggest this name change, but you are right
we should be consistent with the PWM API here.
Sorry Florian.

> 
>> +{
>> +	return pwm->chip->can_sleep;
>> +}
>> +EXPORT_SYMBOL_GPL(pwm_cansleep);
> 
> Would it make sense to check for NULL pointers here? I guess that
> passing NULL into the function could be considered a programming error
> and an oops would be okay, but in that case there's no point in making
> the function return an int. Also see my next comment.

While it is unlikely to happen it is better to be safe, something like this
will do:

return pwm ? pwm->chip->can_sleep : 0;

> 
>> +
>>  #ifdef CONFIG_DEBUG_FS
>>  static void pwm_dbg_show(struct pwm_chip *chip, struct seq_file *s)
>>  {
>> diff --git a/include/linux/pwm.h b/include/linux/pwm.h
>> index 70655a2..e2cb5c7 100644
>> --- a/include/linux/pwm.h
>> +++ b/include/linux/pwm.h
>> @@ -146,6 +146,8 @@ struct pwm_ops {
>>   * @base: number of first PWM controlled by this chip
>>   * @npwm: number of PWMs controlled by this chip
>>   * @pwms: array of PWM devices allocated by the framework
>> + * @can_sleep: flag must be set iff config()/enable()/disable() methods sleep,
>> + *      as they must while accessing PWM chips over I2C or SPI
>>   */
>>  struct pwm_chip {
>>  	struct device		*dev;
>> @@ -159,6 +161,7 @@ struct pwm_chip {
>>  	struct pwm_device *	(*of_xlate)(struct pwm_chip *pc,
>>  					    const struct of_phandle_args *args);
>>  	unsigned int		of_pwm_n_cells;
>> +	unsigned int		can_sleep:1;
> 
> What's the reason for making this a bitfield? Couldn't we just use a
> bool instead?

I have also overlooked this. In my version I had the can_sleep as bool also.

-- 
Péter
