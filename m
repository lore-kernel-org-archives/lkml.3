Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753421AbaKZQ27 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 11:28:59 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:45198 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751565AbaKZQ25 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 11:28:57 -0500
Message-ID: <5475FF95.6030502@ti.com>
Date: Wed, 26 Nov 2014 18:28:05 +0200
From: Grygorii Strashko <grygorii.strashko@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: =?windows-1252?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
CC: Wolfram Sang <wsa@the-dreams.de>, Sekhar Nori <nsekhar@ti.com>,
        <linux-i2c@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        Mike Looijmans <milo-software@users.sourceforge.net>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Santosh Shilimkar <ssantosh@kernel.org>,
        Murali Karicheri <m-karicheri2@ti.com>
Subject: Re: [PATCH v2 1/5] i2c: i2c-davinci: switch to use platform_get_irq
References: <1417010393-30598-1-git-send-email-grygorii.strashko@ti.com> <1417010393-30598-2-git-send-email-grygorii.strashko@ti.com> <20141126155431.GK4431@pengutronix.de>
In-Reply-To: <20141126155431.GK4431@pengutronix.de>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/2014 05:54 PM, Uwe Kleine-König wrote:
> Hello Grygorii,
>
> On Wed, Nov 26, 2014 at 03:59:49PM +0200, Grygorii Strashko wrote:
>> Switch Davinci I2C driver to use platform_get_irq(), because
>> it is not recommened to use platform_get_resource(pdev, IORESOURCE_IRQ, ..)
>> for requesting IRQ resources any more, as they can be not ready yet
>> in case of DT-boot.
>>
>> CC: Sekhar Nori <nsekhar@ti.com>
>> CC: Kevin Hilman <khilman@deeprootsystems.com>
>> CC: Santosh Shilimkar <ssantosh@kernel.org>
>> CC: Murali Karicheri <m-karicheri2@ti.com>
>> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
>> ---
>>   drivers/i2c/busses/i2c-davinci.c | 20 ++++++++++++--------
>>   1 file changed, 12 insertions(+), 8 deletions(-)
>>
>> diff --git a/drivers/i2c/busses/i2c-davinci.c b/drivers/i2c/busses/i2c-davinci.c
>> index 4d96147..7f54903 100644
>> --- a/drivers/i2c/busses/i2c-davinci.c
>> +++ b/drivers/i2c/busses/i2c-davinci.c
>> @@ -640,13 +640,17 @@ static int davinci_i2c_probe(struct platform_device *pdev)
>>   {
>>   	struct davinci_i2c_dev *dev;
>>   	struct i2c_adapter *adap;
>> -	struct resource *mem, *irq;
>> -	int r;
>> -
>> -	irq = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
>> -	if (!irq) {
>> -		dev_err(&pdev->dev, "no irq resource?\n");
>> -		return -ENODEV;
>> +	struct resource *mem;
>> +	int r, irq;
>> +
>> +	irq = platform_get_irq(pdev, 0);
>> +	if (irq <= 0) {
>> +		if (irq == -EPROBE_DEFER)
>> +			return irq;
>> +		if (!irq)
>> +			irq = -ENXIO;
>> +		dev_err(&pdev->dev, "can't get irq resource ret=%d\n", irq);
>> +		return irq;
> The simpler and I think also more usual logic is:
>
> 	if (!irq)
> 		irq = -ENXIO;
> 	if (irq != -EPROBE_DEFER)
> 		dev_err(...);
> 	return irq;
>
> Other than that the patch looks fine.

Ok. will change and add your ack.

regards,
-grygorii

