Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757407AbaKULBk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 06:01:40 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:37352 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750856AbaKULBj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 06:01:39 -0500
Message-ID: <546F1B7D.1020209@ti.com>
Date: Fri, 21 Nov 2014 13:01:17 +0200
From: Grygorii Strashko <grygorii.strashko@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: =?windows-1252?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Rob Herring <robherring2@gmail.com>,
        Grant Likely <grant.likely@linaro.org>
CC: Wolfram Sang <wsa@the-dreams.de>, <linux-i2c@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Sekhar Nori <nsekhar@ti.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Santosh Shilimkar <ssantosh@kernel.org>,
        Murali Karicheri <m-karicheri2@ti.com>
Subject: Re: [1/5] i2c: i2c-davinci: switch to use platform_get_irq
References: <1416477788-5544-2-git-send-email-grygorii.strashko@ti.com> <20141120214838.GA346@pengutronix.de>
In-Reply-To: <20141120214838.GA346@pengutronix.de>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/20/2014 11:48 PM, Uwe Kleine-König wrote:
> Hello Grygorii,
> 
> On Thu, Nov 20, 2014 at 12:03:04PM +0200, Grygorii Strashko wrote:
>> Switch Davinci I2C driver to use platform_get_irq(), because
>> - it is not recommened to use
>>    platform_get_resource(pdev, IORESOURCE_IRQ, ..) for requesting IRQ's
>>    resources any more, as they can be not ready yet in case of DT-booting.
>> - it makes code simpler
>>
>> CC: Sekhar Nori <nsekhar@ti.com>
>> CC: Kevin Hilman <khilman@deeprootsystems.com>
>> CC: Santosh Shilimkar <ssantosh@kernel.org>
>> CC: Murali Karicheri <m-karicheri2@ti.com>
>> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
>> ---
>>   drivers/i2c/busses/i2c-davinci.c | 14 +++++++-------
>>   1 file changed, 7 insertions(+), 7 deletions(-)
>>
>> diff --git a/drivers/i2c/busses/i2c-davinci.c b/drivers/i2c/busses/i2c-davinci.c
>> index 4d96147..9bbfb8f 100644
>> --- a/drivers/i2c/busses/i2c-davinci.c
>> +++ b/drivers/i2c/busses/i2c-davinci.c
>> @@ -640,13 +640,13 @@ static int davinci_i2c_probe(struct platform_device *pdev)
>>   {
>>   	struct davinci_i2c_dev *dev;
>>   	struct i2c_adapter *adap;
>> -	struct resource *mem, *irq;
>> -	int r;
>> +	struct resource *mem;
>> +	int r, irq;
>>   
>> -	irq = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
>> -	if (!irq) {
>> -		dev_err(&pdev->dev, "no irq resource?\n");
>> -		return -ENODEV;
>> +	irq = platform_get_irq(pdev, 0);
> One bad thing about platform_get_irq is its unusual handling of irq=0.
> I'm pretty sure you don't want to use this value, so adding something
> like:
> 
> 	if (!irq)
> 		irq = -ENXIO
> 
> would be welcome because the usual value for "invalid irq" is 0 and not
> -ESOMETHING. platform_get_irq is one of the very few functions that
> don't adhere to this convention. With handling <= 0 as error your code
> is immune to changes in this area. Although I notice that
> platform_get_irq got worse in this respect to handle -EPROBE_DEFER. hmm.
> 
> Apart from your change I wonder if platform_get_irq should handle
> of_irq_get returning 0 as an error.

I think you are right and It seems like, the check for !irq should
be added/restored for OF case in platform_get_irq() too.

Also, I've simulated irq == 0 case - the .probe() failed with error -EINVAL
which is returned by request_threaded_irq() because of !irq_settings_can_request(desc).
 i2c_davinci 2530000.i2c: failure requesting irq 0
 i2c_davinci: probe of 2530000.i2c failed with error -22

I'm not sure that above will work for everyone because it depends on ARCH_IRQ_INIT_FLAGS
and ARCH_IRQ_INIT_FLAGS = (IRQ_NOREQUEST | IRQ_NOPROBE) for ARM.

> 
>> +	if (irq < 0) {
>> +		dev_err(&pdev->dev, "can't get irq resource ret=%d\n", irq);
> Please don't print an error if irq=-EPROBE_DEFER.
ok.

regards,
-grygorii

