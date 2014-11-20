Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756576AbaKTLaN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 06:30:13 -0500
Received: from mail1.bemta5.messagelabs.com ([195.245.231.142]:39686 "EHLO
	mail1.bemta5.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750953AbaKTLaL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 06:30:11 -0500
X-Greylist: delayed 420 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 Nov 2014 06:30:10 EST
X-Env-Sender: stwiss.opensource@diasemi.com
X-Msg-Ref: server-6.tower-178.messagelabs.com!1416482585!35730876!1
X-Originating-IP: [94.185.165.51]
X-StarScan-Received: 
X-StarScan-Version: 6.12.4; banners=-,-,-
X-VirusChecked: Checked
From: "Opensource [Steve Twiss]" <stwiss.opensource@diasemi.com>
To: Dmitry Lavnikevich <d.lavnikevich@sam-solutions.com>,
        Support Opensource <Support.Opensource@diasemi.com>,
        "a.zummo@towertech.it" <a.zummo@towertech.it>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] rtc: da9063: Fix ALARM interrupt registration.
Thread-Topic: [PATCH] rtc: da9063: Fix ALARM interrupt registration.
Thread-Index: AQHQBKgC9623rLeXOUGgGvryE55nuJxpXOmw
Date: Thu, 20 Nov 2014 11:23:02 +0000
Message-ID: <6ED8E3B22081A4459DAC7699F3695FB7D0B4836D@SW-EX-MBX02.diasemi.com>
References: <1416477273-975-1-git-send-email-d.lavnikevich@sam-solutions.com>
In-Reply-To: <1416477273-975-1-git-send-email-d.lavnikevich@sam-solutions.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.20.26.77]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20 November 2014 09:55 Dmitry Lavnikevich wrote:

> Call platform_get_irq_byname() returns local IRQ number. Use
> regmap_irq_get_virq() to get VIRQ instead.
> This fixes rtc initialization error:
> da9063-rtc da9063-rtc: Failed to request ALARM IRQ 1: -22
> 
> Signed-off-by: Dmitry Lavnikevich <d.lavnikevich@sam-solutions.com>

Hi Dmitry,

Please refer to the previous patch :
http://patchwork.ozlabs.org/patch/329051/

Using platform_get_irq_byname() to retrieve the IRQ number
returns the VIRQ number rather than the local IRQ number for
the device. Passing that value then into regmap_irq_get_virq()
causes a failure because the function is expecting the local
IRQ number (e.g. 0, 1, 2, 3, etc).

> ---
>  drivers/rtc/rtc-da9063.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/rtc/rtc-da9063.c b/drivers/rtc/rtc-da9063.c
> index 731ed1a..04743a6 100644
> --- a/drivers/rtc/rtc-da9063.c
> +++ b/drivers/rtc/rtc-da9063.c
> @@ -315,6 +315,7 @@ static int da9063_rtc_probe(struct platform_device
> *pdev)
>  	platform_set_drvdata(pdev, rtc);
> 
>  	irq_alarm = platform_get_irq_byname(pdev, "ALARM");
> +	irq_alarm = regmap_irq_get_virq(da9063->regmap_irq, irq_alarm);
>  	ret = devm_request_threaded_irq(&pdev->dev, irq_alarm, NULL,
>  					da9063_alarm_event,
>  					IRQF_TRIGGER_LOW |
> IRQF_ONESHOT,
> --
> 2.1.3

This patch above gives the following error when running on the DA9063:

da9063-rtc da9063-rtc: Failed to request ALARM IRQ -22: -22
da9063-rtc: probe of da9063-rtc failed with error -22

Regards,
Steve
