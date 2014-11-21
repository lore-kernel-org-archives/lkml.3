Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758458AbaKUODx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 09:03:53 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:35812 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755380AbaKUODv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 09:03:51 -0500
MIME-Version: 1.0
In-Reply-To: <546F1B7D.1020209@ti.com>
References: <1416477788-5544-2-git-send-email-grygorii.strashko@ti.com>
 <20141120214838.GA346@pengutronix.de> <546F1B7D.1020209@ti.com>
From: Rob Herring <robherring2@gmail.com>
Date: Fri, 21 Nov 2014 08:03:26 -0600
Message-ID: <CAL_JsqJKhtzx9NKQ9R=m_4ReCUM9FP71mE7oRkScxPE7k881AA@mail.gmail.com>
Subject: Re: [1/5] i2c: i2c-davinci: switch to use platform_get_irq
To: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Grant Likely <grant.likely@linaro.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sekhar Nori <nsekhar@ti.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Santosh Shilimkar <ssantosh@kernel.org>,
        Murali Karicheri <m-karicheri2@ti.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 21, 2014 at 5:01 AM, Grygorii Strashko
<grygorii.strashko@ti.com> wrote:
> On 11/20/2014 11:48 PM, Uwe Kleine-König wrote:
>> Hello Grygorii,
>>
>> On Thu, Nov 20, 2014 at 12:03:04PM +0200, Grygorii Strashko wrote:
>>> Switch Davinci I2C driver to use platform_get_irq(), because
>>> - it is not recommened to use
>>>    platform_get_resource(pdev, IORESOURCE_IRQ, ..) for requesting IRQ's
>>>    resources any more, as they can be not ready yet in case of DT-booting.
>>> - it makes code simpler
>>>
>>> CC: Sekhar Nori <nsekhar@ti.com>
>>> CC: Kevin Hilman <khilman@deeprootsystems.com>
>>> CC: Santosh Shilimkar <ssantosh@kernel.org>
>>> CC: Murali Karicheri <m-karicheri2@ti.com>
>>> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
>>> ---
>>>   drivers/i2c/busses/i2c-davinci.c | 14 +++++++-------
>>>   1 file changed, 7 insertions(+), 7 deletions(-)
>>>
>>> diff --git a/drivers/i2c/busses/i2c-davinci.c b/drivers/i2c/busses/i2c-davinci.c
>>> index 4d96147..9bbfb8f 100644
>>> --- a/drivers/i2c/busses/i2c-davinci.c
>>> +++ b/drivers/i2c/busses/i2c-davinci.c
>>> @@ -640,13 +640,13 @@ static int davinci_i2c_probe(struct platform_device *pdev)
>>>   {
>>>      struct davinci_i2c_dev *dev;
>>>      struct i2c_adapter *adap;
>>> -    struct resource *mem, *irq;
>>> -    int r;
>>> +    struct resource *mem;
>>> +    int r, irq;
>>>
>>> -    irq = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
>>> -    if (!irq) {
>>> -            dev_err(&pdev->dev, "no irq resource?\n");
>>> -            return -ENODEV;
>>> +    irq = platform_get_irq(pdev, 0);
>> One bad thing about platform_get_irq is its unusual handling of irq=0.
>> I'm pretty sure you don't want to use this value, so adding something
>> like:
>>
>>       if (!irq)
>>               irq = -ENXIO
>>
>> would be welcome because the usual value for "invalid irq" is 0 and not
>> -ESOMETHING. platform_get_irq is one of the very few functions that
>> don't adhere to this convention. With handling <= 0 as error your code
>> is immune to changes in this area. Although I notice that
>> platform_get_irq got worse in this respect to handle -EPROBE_DEFER. hmm.
>>
>> Apart from your change I wonder if platform_get_irq should handle
>> of_irq_get returning 0 as an error.
>
> I think you are right and It seems like, the check for !irq should
> be added/restored for OF case in platform_get_irq() too.

Changing the return values of platform_get_irq is tricky as it would
potentially break drivers because NO_IRQ can be 0 or -1 depending on
the arch. Drivers checking against specific values of NO_IRQ would
break. We've done some clean-up in this area, but I suspect more is
needed.

Rob
