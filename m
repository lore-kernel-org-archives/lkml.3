Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756704Ab3AYMfE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 07:35:04 -0500
Received: from smtp4.epfl.ch ([128.178.224.219]:54335 "HELO smtp4.epfl.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754841Ab3AYMfA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 07:35:00 -0500
Message-ID: <51027BEF.8080506@epfl.ch>
Date: Fri, 25 Jan 2013 13:34:55 +0100
From: Florian Vaussard <florian.vaussard@epfl.ch>
Reply-To: florian.vaussard@epfl.ch
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
CC: Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        linux-leds@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] pwm: Add pwm_cansleep() as exported API to users
References: <1359108114-16998-1-git-send-email-florian.vaussard@epfl.ch> <1359108114-16998-2-git-send-email-florian.vaussard@epfl.ch> <51027B43.1080504@ti.com>
In-Reply-To: <51027B43.1080504@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 25/01/2013 13:32, Peter Ujfalusi a écrit :
> On 01/25/2013 11:01 AM, Florian Vaussard wrote:
>> Calls to some external PWM chips can sleep. To help users,
>> add pwm_cansleep() API.
>>
>> Signed-off-by: Florian Vaussard <florian.vaussard@epfl.ch>
>> ---
>>   drivers/pwm/core.c  |   12 ++++++++++++
>>   include/linux/pwm.h |   10 ++++++++++
>>   2 files changed, 22 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/pwm/core.c b/drivers/pwm/core.c
>> index 4a13da4..f49bfa6 100644
>> --- a/drivers/pwm/core.c
>> +++ b/drivers/pwm/core.c
>> @@ -763,6 +763,18 @@ void devm_pwm_put(struct device *dev, struct pwm_device *pwm)
>>   }
>>   EXPORT_SYMBOL_GPL(devm_pwm_put);
>>
>> +/**
>> +  * pwm_can_sleep() - report whether pwm access will sleep
>> +  * @pwm: PWM device
>> +  *
>> +  * It returns nonzero if accessing the PWM can sleep.
>> +  */
>> +int pwm_can_sleep(struct pwm_device *pwm)
>> +{
>> +	return pwm->chip->can_sleep;
>> +}
>> +EXPORT_SYMBOL_GPL(pwm_can_sleep);
>
> Can we name this as pwm_cansleep() to be more alligned with the
> gpio_cansleep() API?
>

Sure

>> +
>>   #ifdef CONFIG_DEBUG_FS
>>   static void pwm_dbg_show(struct pwm_chip *chip, struct seq_file *s)
>>   {
>> diff --git a/include/linux/pwm.h b/include/linux/pwm.h
>> index 70655a2..2aee75d 100644
>> --- a/include/linux/pwm.h
>> +++ b/include/linux/pwm.h
>> @@ -146,6 +146,8 @@ struct pwm_ops {
>>    * @base: number of first PWM controlled by this chip
>>    * @npwm: number of PWMs controlled by this chip
>>    * @pwms: array of PWM devices allocated by the framework
>> + * @can_sleep: flag must be set iff config()/enable()/disable() methods sleep,
>> + *      as they must while accessing PWM chips over I2C or SPI
>>    */
>>   struct pwm_chip {
>>   	struct device		*dev;
>> @@ -159,6 +161,7 @@ struct pwm_chip {
>>   	struct pwm_device *	(*of_xlate)(struct pwm_chip *pc,
>>   					    const struct of_phandle_args *args);
>>   	unsigned int		of_pwm_n_cells;
>> +	unsigned int		can_sleep:1;
>>   };
>>
>>   #if IS_ENABLED(CONFIG_PWM)
>> @@ -182,6 +185,8 @@ struct pwm_device *devm_pwm_get(struct device *dev, const char *con_id);
>>   struct pwm_device *devm_of_pwm_get(struct device *dev, struct device_node *np,
>>   				   const char *con_id);
>>   void devm_pwm_put(struct device *dev, struct pwm_device *pwm);
>> +
>> +int pwm_can_sleep(struct pwm_device *pwm);
>>   #else
>>   static inline int pwm_set_chip_data(struct pwm_device *pwm, void *data)
>>   {
>> @@ -242,6 +247,11 @@ static inline struct pwm_device *devm_of_pwm_get(struct device *dev,
>>   static inline void devm_pwm_put(struct device *dev, struct pwm_device *pwm)
>>   {
>>   }
>> +
>> +static inline int pwm_can_sleep(struct pwm_device *pwm)
>> +{
>> +	return -EINVAL;
>
> I think we should return 0 here instead an error.
>

Ok, it makes sense.

>> +}
>>   #endif
>>
>>   struct pwm_lookup {
>>
>
>

Thank you,

Florian
