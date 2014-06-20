Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934686AbaFTJUK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 05:20:10 -0400
Received: from ducie-dc1.codethink.co.uk ([185.25.241.215]:47514 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S934595AbaFTJUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 05:20:08 -0400
Message-ID: <53A3FCC0.6050705@codethink.co.uk>
Date: Fri, 20 Jun 2014 10:20:00 +0100
From: Rob Jones <rob.jones@codethink.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: linus.walleij@linaro.org, gnurou@gmail.com, lgirdwood@gmail.com,
        broonie@kernel.org, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kernel@codethink.co.uk,
        ian.molton@codethink.co.uk, ben.dooks@codethink.co.uk, heiko@sntech.de
Subject: Re: [PATCH 3/4] drivers/base: devres.c: use devm_kmemdup() from with
 devm_kstrdup()
References: <1403192765-3258-1-git-send-email-rob.jones@codethink.co.uk>	 <1403192765-3258-4-git-send-email-rob.jones@codethink.co.uk> <1403193567.7875.4.camel@joe-AO725>
In-Reply-To: <1403193567.7875.4.camel@joe-AO725>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 19/06/14 16:59, Joe Perches wrote:
> On Thu, 2014-06-19 at 16:46 +0100, Rob Jones wrote:
>> Avoid code duplication by using devm_kmemdup() to copy data instead
>> of having a separate loop within devm_kstrdup().
>>
>> Reviewed-by: Ian Molton <ian.molton@codethink.co.uk>
>> Signed-off-by: Rob Jones <rob.jones@codethink.co.uk>
> []
>> diff --git a/drivers/base/devres.c b/drivers/base/devres.c
> []
>> @@ -802,17 +802,10 @@ EXPORT_SYMBOL_GPL(devm_kmalloc);
>>    */
>>   char *devm_kstrdup(struct device *dev, const char *s, gfp_t gfp)
>>   {
> []
>> +	return devm_kmemdup(dev, s, (strlen(s) + 1), gfp);
>>   }
>>   EXPORT_SYMBOL_GPL(devm_kstrdup);
> Making this static inline in the header and dropping
> EXPORT_SYMBOL_GPL might be smaller code.
>
> static inline
> char *devm_kstrdup(struct device *dev, const char *s, gfp_t gfp)
> {
> 	return devm_kmemdup(dev, s, strlen(s) + 1, gfp);
> }
>

Is it wise not to check for (s == NULL)? Surely the behaviour of 
strlen(NULL) is undefined.

Consequently, I am, on balance, against making the function static 
inline. Given that inline is only a recommendation to the compiler, it 
may well not inline it anyway if the NULL test is present, in which case 
we would end up with a copy of the code in each module that uses it 
rather than a single, global, copy. If it didn't need the NULL test, I 
would agree that it would be best as a static inline but I think it does 
need it.

-- 
Rob Jones
Project Manager
Codethink Ltd
mailto:rob.jones@codethink.co.uk
tel:+44 161 236 5575

