Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751922AbaI3E5m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 00:57:42 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:52124 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915AbaI3E5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 00:57:41 -0400
Message-ID: <542A383F.3000900@gmail.com>
Date: Tue, 30 Sep 2014 10:27:35 +0530
From: Sanchayan Maity <maitysanchayan@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Stefan Agner <stefan@agner.ch>
CC: kernel@pengutronix.de, a.zummo@towertech.it, b35083@freescale.com,
        rtc-linux@googlegroups.com, shawn.guo@freescale.com,
        linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] drivers/rtc/rtc-snvs: Add clock support
References: <cover.1411736171.git.maitysanchayan@gmail.com> <8a1904a59f7b171a7cf1e71b9e80f0cf7b1061c0.1411736171.git.maitysanchayan@gmail.com> <8e48ef6e52a8c6eaa1cda95fbd3c1bc7@agner.ch>
In-Reply-To: <8e48ef6e52a8c6eaa1cda95fbd3c1bc7@agner.ch>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
> 
> Is there a reason why you moved the irq request before enabling/getting
> the clocks? AFAIK the irq is quite independent from the clock of that
> IP, so you could that leave here. Try to make as few changes to the code
> as possible to archive your goal.

Ok. Will fix this, if the patch gets accepted in some form. Seems separating the
patch for SNVS node addition to the VF610 dts will be better. 

> 
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
