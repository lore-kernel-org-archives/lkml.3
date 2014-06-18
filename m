Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752744AbaFRPwa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 11:52:30 -0400
Received: from ducie-dc1.codethink.co.uk ([185.25.241.215]:51403 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752557AbaFRPw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 11:52:28 -0400
Message-ID: <53A1B5B4.2020704@codethink.co.uk>
Date: Wed, 18 Jun 2014 16:52:20 +0100
From: Rob Jones <rob.jones@codethink.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>
CC: linus.walleij@linaro.org, gnurou@gmail.com, lgirdwood@gmail.com,
        broonie@kernel.org, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org, ian.molton@codethink.co.uk,
        ben.dooks@codethink.co.uk
Subject: Re: [PATCH 2/3] drivers/base: devres.c: Add block copy func. for
 managed devices
References: <1402411308-14182-1-git-send-email-rob.jones@codethink.co.uk> <1402411308-14182-3-git-send-email-rob.jones@codethink.co.uk> <1713451.AmufNoybT7@diego>
In-Reply-To: <1713451.AmufNoybT7@diego>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 18/06/14 14:05, Heiko Stübner wrote:
> Am Dienstag, 10. Juni 2014, 15:41:47 schrieb Rob Jones:
>> Add function devm_kmemdup().
>> Rationalise with devm_kstrdup() to avoid code duplication.
>>
>> Reviewed-by: Ian Molton <ian.molton@codethink.co.uk>
>> Signed-off-by: Rob Jones <rob.jones@codethink.co.uk>
>> ---
>>   drivers/base/devres.c  |   42 ++++++++++++++++++++++++++++++++++--------
>>   include/linux/device.h |    2 ++
>>   2 files changed, 36 insertions(+), 8 deletions(-)
>>
>> diff --git a/drivers/base/devres.c b/drivers/base/devres.c
>> index db4e264..978bbe2 100644
>> --- a/drivers/base/devres.c
>> +++ b/drivers/base/devres.c
>> @@ -791,6 +791,20 @@ void * devm_kmalloc(struct device *dev, size_t size,
>> gfp_t gfp) EXPORT_SYMBOL_GPL(devm_kmalloc);
>>
>>   /**
>> + * static function to avoid code duplication when duplicating buffers
>> + */
>> +static void *devm_kmemdup_nochecks(struct device *dev, const void *s,
>> +				    size_t size, gfp_t gfp)
>> +{
>> +	void *buf;
>> +
>> +	buf = devm_kmalloc(dev, size, gfp);
>> +	if (buf)
>> +		memcpy(buf, s, size);
>> +	return buf;
>> +}
>> +
>> +/**
>>    * devm_kstrdup - Allocate resource managed space and
>>    *                copy an existing string into that.
>>    * @dev: Device to allocate memory for
>> @@ -802,21 +816,33 @@ EXPORT_SYMBOL_GPL(devm_kmalloc);
>>    */
>>   char *devm_kstrdup(struct device *dev, const char *s, gfp_t gfp)
>>   {
>> -	size_t size;
>> -	char *buf;
>> -
>>   	if (!s)
>>   		return NULL;
>>
>> -	size = strlen(s) + 1;
>> -	buf = devm_kmalloc(dev, size, gfp);
>> -	if (buf)
>> -		memcpy(buf, s, size);
>> -	return buf;
>> +	return devm_kmemdup_nochecks(dev, s, (strlen(s)+1), gfp);
>>   }
>>   EXPORT_SYMBOL_GPL(devm_kstrdup);
> hmm, this looks like an unrelated change to me and may warrant a separate
> patch for the devm_kstrdup change.

On reflection, I agree, I'll separate out the change to devm_kstrdup() 
and resubmit.

>
>
>>   /**
>> + * devm_kmemdup - Allocate resource managed space and
>> + *                copy existing data into that.
>> + * @dev: Device to allocate memory for
>> + * @s: the memory block to duplicate
>> + * @gfp: the GFP mask used in the devm_kmalloc() call when
>> + *       allocating memory
>> + * RETURNS:
>> + * Pointer to allocated string on success, NULL on failure.
>> + */
>> +void *devm_kmemdup(struct device *dev, const void *s, size_t size, gfp_t
>> gfp) +{
>> +	if (!s || (size == 0))
>> +		return NULL;
>> +
>> +	return devm_kmemdup_nochecks(dev, s, size, gfp);
>> +}
>> +EXPORT_SYMBOL_GPL(devm_kmemdup);
>> +
>> +/**
>>    * devm_kfree - Resource-managed kfree
>>    * @dev: Device this memory belongs to
>>    * @p: Memory to free
>> diff --git a/include/linux/device.h b/include/linux/device.h
>> index d1d1c05..7ace116 100644
>> --- a/include/linux/device.h
>> +++ b/include/linux/device.h
>> @@ -623,6 +623,8 @@ static inline void *devm_kcalloc(struct device *dev,
>>   }
>>   extern void devm_kfree(struct device *dev, void *p);
>>   extern char *devm_kstrdup(struct device *dev, const char *s, gfp_t gfp);
>> +extern void *devm_kmemdup(struct device *dev,
>> +			  const void *s, size_t size, gfp_t gfp);
>>
>>   void __iomem *devm_ioremap_resource(struct device *dev, struct resource
>> *res); void __iomem *devm_request_and_ioremap(struct device *dev,
>
>

-- 
Rob Jones
Project Manager
Codethink Ltd
mailto:rob.jones@codethink.co.uk
tel:+44 161 236 5575

