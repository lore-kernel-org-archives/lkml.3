Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754223Ab3CKSlr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 14:41:47 -0400
Received: from fallback3.mail.ru ([94.100.176.58]:56655 "EHLO
	fallback3.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752686Ab3CKSlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 14:41:46 -0400
From: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
To: =?UTF-8?B?TGFycy1QZXRlciBDbGF1c2Vu?= <lars@metafoo.de>
Cc: =?UTF-8?B?R3JlZyBLcm9haC1IYXJ0bWFu?= <gregkh@linuxfoundation.org>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: =?UTF-8?B?UmVbMl06IFtQQVRDSCAyLzRdIHR0eTogbWF4MzEweDogVXNlIGRldl9wbV9v?=
 =?UTF-8?B?cHM=?=
Mime-Version: 1.0
X-Mailer: Mail.Ru Mailer 1.0
X-Originating-IP: [188.134.40.128]
Date: Mon, 11 Mar 2013 22:41:18 +0400
Reply-To: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
X-Priority: 3 (Normal)
Message-ID: <1363027278.637327455@f338.mail.ru>
Content-Type: text/plain; charset=utf-8
X-Spam: Not detected
X-Mras: Ok
In-Reply-To: <513E23DA.90100@metafoo.de>
References: <1363023892-15957-1-git-send-email-lars@metafoo.de> <1363025431.558252587@f43.mail.ru> <513E23DA.90100@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r2BIfohW009411

> On 03/11/2013 07:10 PM, Alexander Shiyan wrote:
> > Hello.
> > 
> >> Use dev_pm_ops instead of the deprecated legacy suspend/resume for the
> >> max310x driver.
> >>
> >> Cc: Alexander Shiyan <shc_work@mail.ru>
> >> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> >> ---
> >>  drivers/tty/serial/max310x.c | 24 ++++++++++++++++--------
> >>  1 file changed, 16 insertions(+), 8 deletions(-)
> >>
> >> diff --git a/drivers/tty/serial/max310x.c b/drivers/tty/serial/max310x.c
> >> index 0c2422c..8941e64 100644
> >> --- a/drivers/tty/serial/max310x.c
> >> +++ b/drivers/tty/serial/max310x.c
> >> @@ -881,12 +881,14 @@ static struct uart_ops max310x_ops = {
> >>  	.verify_port	= max310x_verify_port,
> >>  };
> >>  
> >> -static int max310x_suspend(struct spi_device *spi, pm_message_t state)
> >> +#ifdef CONFIG_PM_SLEEP
> >> +
> >> +static int max310x_suspend(struct device *dev)
> >>  {
> >>  	int ret;
> >> -	struct max310x_port *s = dev_get_drvdata(&spi->dev);
> >> +	struct max310x_port *s = dev_get_drvdata(dev);
> >>  
> >> -	dev_dbg(&spi->dev, "Suspend\n");
> >> +	dev_dbg(dev, "Suspend\n");
> >>  
> >>  	ret = uart_suspend_port(&s->uart, &s->port);
> >>  
> >> @@ -905,11 +907,11 @@ static int max310x_suspend(struct spi_device *spi, pm_message_t state)
> >>  	return ret;
> >>  }
> >>  
> >> -static int max310x_resume(struct spi_device *spi)
> >> +static int max310x_resume(struct device *dev)
> >>  {
> >> -	struct max310x_port *s = dev_get_drvdata(&spi->dev);
> >> +	struct max310x_port *s = dev_get_drvdata(dev);
> >>  
> >> -	dev_dbg(&spi->dev, "Resume\n");
> >> +	dev_dbg(dev, "Resume\n");
> >>  
> >>  	if (s->pdata->suspend)
> >>  		s->pdata->suspend(0);
> >> @@ -928,6 +930,13 @@ static int max310x_resume(struct spi_device *spi)
> >>  	return uart_resume_port(&s->uart, &s->port);
> >>  }
> >>  
> >> +static SIMPLE_DEV_PM_OPS(max310x_pm_ops, max310x_suspend, max310x_resume);
> >> +#define MAX310X_PM_OPS (&max310x_pm_ops)
> >> +
> >> +#else
> >> +#define MAX310X_PM_OPS NULL
> >> +#endif
> >> +
> >>  #ifdef CONFIG_GPIOLIB
> >>  static int max310x_gpio_get(struct gpio_chip *chip, unsigned offset)
> >>  {
> >> @@ -1242,11 +1251,10 @@ static struct spi_driver max310x_driver = {
> >>  	.driver = {
> >>  		.name	= "max310x",
> >>  		.owner	= THIS_MODULE,
> >> +		.pm	= MAX310X_PM_OPS,
> > 
> > Check for CONFIG_PM_SLEEP not necessary at all.
> > <linux/pm.h> will do all for us.
> 
> No it wont, you'll end up with a dev_pm_ops struct full of zeros and two
I.e. NULL, it is OK.

> warnings from your compiler about unused functions.
I think attribute "__maybe_unused" can help here.

> >>  	},
> >>  	.probe		= max310x_probe,
> >>  	.remove		= max310x_remove,
> >> -	.suspend	= max310x_suspend,
> >> -	.resume		= max310x_resume,
> >>  	.id_table	= max310x_id_table,
> >>  };
> >>  module_spi_driver(max310x_driver);
> >> -- 
> >> 1.8.0
> > 
> > ---

---
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
