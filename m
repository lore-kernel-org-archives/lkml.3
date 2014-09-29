Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966AbaI2M5f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 08:57:35 -0400
Received: from mail.kmu-office.ch ([178.209.48.102]:57612 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753AbaI2M5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 08:57:34 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=
Content-Transfer-Encoding: 7bit
Date: Mon, 29 Sep 2014 14:57:28 +0200
From: Stefan Agner <stefan@agner.ch>
To: Shawn Guo <shawn.guo@freescale.com>
Cc: Sanchayan Maity <maitysanchayan@gmail.com>, kernel@pengutronix.de,
        a.zummo@towertech.it, b35083@freescale.com, rtc-linux@googlegroups.com,
        linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] drivers/rtc/rtc-snvs: Add clock support
In-Reply-To: <20140928035631.GF12999@dragon>
References: <cover.1411736171.git.maitysanchayan@gmail.com>
 <8a1904a59f7b171a7cf1e71b9e80f0cf7b1061c0.1411736171.git.maitysanchayan@gmail.com>
 <20140928035631.GF12999@dragon>
Message-ID: <ff3b3c43678ba2e4c35b667af1d6bf20@agner.ch>
User-Agent: Roundcube Webmail/1.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 2014-09-28 05:56, schrieb Shawn Guo:
> On Fri, Sep 26, 2014 at 06:44:01PM +0530, Sanchayan Maity wrote:
>> This patch adds clock enable and disable support
>> for the SNVS peripheral which is required by the
>> SNVS RTC.
>>
>> Signed-off-by: Sanchayan Maity <maitysanchayan@gmail.com>
>> ---
>>  drivers/rtc/rtc-snvs.c |   48 +++++++++++++++++++++++++++++++++++++++---------
>>  1 file changed, 39 insertions(+), 9 deletions(-)
>>
>> diff --git a/drivers/rtc/rtc-snvs.c b/drivers/rtc/rtc-snvs.c
>> index fa384fe..f3e8f05 100644
>> --- a/drivers/rtc/rtc-snvs.c
>> +++ b/drivers/rtc/rtc-snvs.c
>> @@ -17,6 +17,7 @@
>>  #include <linux/of_device.h>
>>  #include <linux/platform_device.h>
>>  #include <linux/rtc.h>
>> +#include <linux/clk.h>
>>
>>  /* These register offsets are relative to LP (Low Power) range */
>>  #define SNVS_LPCR		0x04
>> @@ -39,6 +40,7 @@ struct snvs_rtc_data {
>>  	void __iomem *ioaddr;
>>  	int irq;
>>  	spinlock_t lock;
>> +	struct clk *clk;
>>  };
>>
>>  static u32 rtc_read_lp_counter(void __iomem *ioaddr)
>> @@ -260,8 +262,31 @@ static int snvs_rtc_probe(struct platform_device *pdev)
>>  	if (data->irq < 0)
>>  		return data->irq;
>>
>> +	ret = devm_request_irq(&pdev->dev, data->irq, snvs_rtc_irq_handler,
>> +			       IRQF_SHARED, "rtc alarm", &pdev->dev);
>> +	if (ret) {
>> +		dev_err(&pdev->dev, "failed to request irq %d: %d\n",
>> +			data->irq, ret);
>> +		return ret;
>> +	}
>> +
>> +	data->clk = devm_clk_get(&pdev->dev, "snvs");
>> +	if (IS_ERR(data->clk)) {
>> +		dev_err(&pdev->dev, "failed getting clock, err = %ld\n",
>> +						PTR_ERR(data->clk));
>> +		ret = PTR_ERR(data->clk);
>> +		return ret;
>> +	}
> 
> No. This will break all i.MX6 devices running a DTB without clock
> definition.
> 

Shawn, do you know how this works in i.MX6? Is there no clock gating for
that module or is that clock just missing as of now?

But then, I guess even there is a clock on i.MX6 too, we would still
need to make the clock optional.

--
Stefan


>> +
>>  	platform_set_drvdata(pdev, data);
>>
>> +	ret = clk_prepare_enable(data->clk);
>> +	if (ret) {
>> +		dev_err(&pdev->dev,
>> +			"Could not prepare or enable the snvs clock\n");
>> +		return ret;
>> +	}
>> +
>>  	spin_lock_init(&data->lock);
>>
>>  	/* Initialize glitch detect */
>> @@ -275,23 +300,20 @@ static int snvs_rtc_probe(struct platform_device *pdev)
>>
>>  	device_init_wakeup(&pdev->dev, true);
>>
>> -	ret = devm_request_irq(&pdev->dev, data->irq, snvs_rtc_irq_handler,
>> -			       IRQF_SHARED, "rtc alarm", &pdev->dev);
>> -	if (ret) {
>> -		dev_err(&pdev->dev, "failed to request irq %d: %d\n",
>> -			data->irq, ret);
>> -		return ret;
>> -	}
>> -
>>  	data->rtc = devm_rtc_device_register(&pdev->dev, pdev->name,
>>  					&snvs_rtc_ops, THIS_MODULE);
>>  	if (IS_ERR(data->rtc)) {
>>  		ret = PTR_ERR(data->rtc);
>>  		dev_err(&pdev->dev, "failed to register rtc: %d\n", ret);
>> -		return ret;
>> +		goto error_rtc_device_register;
>>  	}
>>
>>  	return 0;
>> +
>> +error_rtc_device_register:
>> +	clk_disable_unprepare(data->clk);
>> +
>> +	return ret;
>>  }
>>
>>  #ifdef CONFIG_PM_SLEEP
>> @@ -302,16 +324,24 @@ static int snvs_rtc_suspend(struct device *dev)
>>  	if (device_may_wakeup(dev))
>>  		enable_irq_wake(data->irq);
>>
>> +	clk_disable_unprepare(data->clk);
>> +
>>  	return 0;
>>  }
>>
>>  static int snvs_rtc_resume(struct device *dev)
>>  {
>> +	int ret;
>> +
>>  	struct snvs_rtc_data *data = dev_get_drvdata(dev);
>>
>>  	if (device_may_wakeup(dev))
>>  		disable_irq_wake(data->irq);
>>
>> +	ret = clk_prepare_enable(data->clk);
>> +	if (ret)
>> +		return ret;
>> +
>>  	return 0;
>>  }
>>  #endif
>> --
>> 1.7.9.5
>>
