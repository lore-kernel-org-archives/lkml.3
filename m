Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069Ab3CKTHQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 15:07:16 -0400
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:64098 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751247Ab3CKTHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 15:07:14 -0400
Message-ID: <513E2BED.5070405@metafoo.de>
Date: Mon, 11 Mar 2013 20:09:33 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Icedove/3.0.11
MIME-Version: 1.0
To: Alexander Shiyan <shc_work@mail.ru>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] tty: max310x: Use dev_pm_ops
References: <1363023892-15957-1-git-send-email-lars@metafoo.de> <1363027278.637327455@f338.mail.ru> <513E2756.2050300@metafoo.de> <1363028084.750587948@f282.mail.ru>
In-Reply-To: <1363028084.750587948@f282.mail.ru>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11/2013 07:54 PM, Alexander Shiyan wrote:
>> On 03/11/2013 07:41 PM, Alexander Shiyan wrote:
>>>> On 03/11/2013 07:10 PM, Alexander Shiyan wrote:
>>>>> Hello.
>>>>>
>>>>>> Use dev_pm_ops instead of the deprecated legacy suspend/resume for the
>>>>>> max310x driver.
>>>>>>
>>>>>> Cc: Alexander Shiyan <shc_work@mail.ru>
>>>>>> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
>>>>>> ---
>>>>>>  drivers/tty/serial/max310x.c | 24 ++++++++++++++++--------
>>>>>>  1 file changed, 16 insertions(+), 8 deletions(-)
>>>>>>
>>>>>> diff --git a/drivers/tty/serial/max310x.c b/drivers/tty/serial/max310x.c
>>>>>> index 0c2422c..8941e64 100644
>>>>>> --- a/drivers/tty/serial/max310x.c
>>>>>> +++ b/drivers/tty/serial/max310x.c
>>>>>> @@ -881,12 +881,14 @@ static struct uart_ops max310x_ops = {
>>>>>>  	.verify_port	= max310x_verify_port,
>>>>>>  };
>>>>>>  
>>>>>> -static int max310x_suspend(struct spi_device *spi, pm_message_t state)
>>>>>> +#ifdef CONFIG_PM_SLEEP
>>>>>> +
>>>>>> +static int max310x_suspend(struct device *dev)
>>>>>>  {
>>>>>>  	int ret;
>>>>>> -	struct max310x_port *s = dev_get_drvdata(&spi->dev);
>>>>>> +	struct max310x_port *s = dev_get_drvdata(dev);
>>>>>>  
>>>>>> -	dev_dbg(&spi->dev, "Suspend\n");
>>>>>> +	dev_dbg(dev, "Suspend\n");
>>>>>>  
>>>>>>  	ret = uart_suspend_port(&s->uart, &s->port);
>>>>>>  
>>>>>> @@ -905,11 +907,11 @@ static int max310x_suspend(struct spi_device *spi, pm_message_t state)
>>>>>>  	return ret;
>>>>>>  }
>>>>>>  
>>>>>> -static int max310x_resume(struct spi_device *spi)
>>>>>> +static int max310x_resume(struct device *dev)
>>>>>>  {
>>>>>> -	struct max310x_port *s = dev_get_drvdata(&spi->dev);
>>>>>> +	struct max310x_port *s = dev_get_drvdata(dev);
>>>>>>  
>>>>>> -	dev_dbg(&spi->dev, "Resume\n");
>>>>>> +	dev_dbg(dev, "Resume\n");
>>>>>>  
>>>>>>  	if (s->pdata->suspend)
>>>>>>  		s->pdata->suspend(0);
>>>>>> @@ -928,6 +930,13 @@ static int max310x_resume(struct spi_device *spi)
>>>>>>  	return uart_resume_port(&s->uart, &s->port);
>>>>>>  }
>>>>>>  
>>>>>> +static SIMPLE_DEV_PM_OPS(max310x_pm_ops, max310x_suspend, max310x_resume);
>>>>>> +#define MAX310X_PM_OPS (&max310x_pm_ops)
>>>>>> +
>>>>>> +#else
>>>>>> +#define MAX310X_PM_OPS NULL
>>>>>> +#endif
>>>>>> +
>>>>>>  #ifdef CONFIG_GPIOLIB
>>>>>>  static int max310x_gpio_get(struct gpio_chip *chip, unsigned offset)
>>>>>>  {
>>>>>> @@ -1242,11 +1251,10 @@ static struct spi_driver max310x_driver = {
>>>>>>  	.driver = {
>>>>>>  		.name	= "max310x",
>>>>>>  		.owner	= THIS_MODULE,
>>>>>> +		.pm	= MAX310X_PM_OPS,
>>>>>
>>>>> Check for CONFIG_PM_SLEEP not necessary at all.
>>>>> <linux/pm.h> will do all for us.
>>>>
>>>> No it wont, you'll end up with a dev_pm_ops struct full of zeros and two
>>> I.e. NULL, it is OK.
>>
>> But what's the point of keeping it around?
> 
> This allows you to keep checking the code at compile time,
> as well as macro IS_ENABLED() inside the code.
> #ifdef does not allow this.

Hm, ok that actually makes sense. But one of the reasons why you'd want to
disable suspend support is because you don't need it and want to save some
memory. Quite often the dev_pm_ops struct is about the same order of size than
the actually suspend/resume code. So even though you disable suspend support
the memory is still used.

> 
>>
>>>
>>>> warnings from your compiler about unused functions.
>>> I think attribute "__maybe_unused" can help here.
>>
>> Or a #ifdef
>>
>>>
>>>>>>  	},
>>>>>>  	.probe		= max310x_probe,
>>>>>>  	.remove		= max310x_remove,
>>>>>> -	.suspend	= max310x_suspend,
>>>>>> -	.resume		= max310x_resume,
>>>>>>  	.id_table	= max310x_id_table,
>>>>>>  };
>>>>>>  module_spi_driver(max310x_driver);
>>>>>> -- 
>>>>>> 1.8.0
> 
> ---

