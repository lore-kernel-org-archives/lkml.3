Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751413AbaLEOwD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 09:52:03 -0500
Received: from mail.kmu-office.ch ([178.209.48.109]:38840 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134AbaLEOwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 09:52:01 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Date: Fri, 05 Dec 2014 15:54:15 +0100
From: Stefan Agner <stefan@agner.ch>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Sanchayan Maity <maitysanchayan@gmail.com>, a.zummo@towertech.it,
        rtc-linux@googlegroups.com, shawn.guo@linaro.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RESEND PATCHv2] drivers/rtc/rtc-snvs: Add clock support
In-Reply-To: <20141204161207.0753031dc675793e9534c1de@linux-foundation.org>
References: <cover.1417585458.git.maitysanchayan@gmail.com>
 <bf8571fc7474877be39a5a4e9d4705358e63d840.1417585458.git.maitysanchayan@gmail.com>
 <20141204161207.0753031dc675793e9534c1de@linux-foundation.org>
Message-ID: <5536a0707e516d0f4a0c6eaf9d4d9291@agner.ch>
User-Agent: Roundcube Webmail/1.0.3
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Fri Dec  5 15:51:19 2014
X-DSPAM-Confidence: 0.9899
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 5481c66712811323039139
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-12-05 01:12, Andrew Morton wrote:
> On Wed,  3 Dec 2014 11:28:55 +0530 Sanchayan Maity
> <maitysanchayan@gmail.com> wrote:
> 
>> This patch adds clock enable and disable support for
>> the SNVS peripheral, which is required for using the
>> RTC within the SNVS block.
>>
>> The clock is not strictly enforced, as this would
>> break the i.MX devices. The clocking for the i.MX
>> devices seems to be enabled elsewhere and enabling
>> RTC SNVS for Vybrid results in a crash. This patch
>> adds the clock support but also makes it optional
>> so Vybrid platform can use the clock if defined
>> while making sure not to break i.MX .
>>
>> ...
> 
> I assume this hasn't been tested with CONFIG_HAVE_CLK=n.  It all
> *looks* OK, but the clk API does its tests for clk==NULL in some very
> deep places.
> 
>> --- a/drivers/rtc/rtc-snvs.c
>> +++ b/drivers/rtc/rtc-snvs.c
> .
>> ...
>>
>> @@ -288,10 +302,16 @@ static int snvs_rtc_probe(struct platform_device *pdev)
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
>> +	if (data->clk)
>> +		clk_disable_unprepare(data->clk);
> 
> From my reading, there's no need to test data->clk here -
> clk_disable_unprepare() handles that.
> 
> It doesn't hurt to test it - a reasonable approach would be to look
> around at what other users of the clk API are doing, and do that.
> 
> 
>> +	return ret;
>>  }
>>
>>  #ifdef CONFIG_PM_SLEEP
>> @@ -302,16 +322,26 @@ static int snvs_rtc_suspend(struct device *dev)
>>  	if (device_may_wakeup(dev))
>>  		enable_irq_wake(data->irq);
>>
>> +	if (data->clk)
>> +		clk_disable_unprepare(data->clk);
> 
> Ditto.
> 
>>  	return 0;
>>  }
>>
>>  static int snvs_rtc_resume(struct device *dev)
>>  {
>>  	struct snvs_rtc_data *data = dev_get_drvdata(dev);
>> +	int ret;
>>
>>  	if (device_may_wakeup(dev))
>>  		disable_irq_wake(data->irq);
>>
>> +	if (data->clk) {
>> +		ret = clk_prepare_enable(data->clk);
>> +		if (ret)
>> +			return ret;
>> +	}
> 

Just discovered issue with suspend/resume I am testing right now: The
alarm interrupt handler also reads registers which are part of SNVS and
need clocks enabled. However, the resume function is called after IRQ's
have been enabled, hence this leads to a abort:

[   90.755222] Unhandled fault: external abort on non-linefetch (0x1008)
at 0x908c604c
[   90.762892] Internal error: : 1008 [#1] ARM
[   90.767082] Modules linked in:
[   90.770174] CPU: 0 PID: 421 Comm: sh Not tainted
3.18.0-rc5-00135-g0689c67-dirty #1592
[   90.778100] task: 8e03e800 ti: 8cad8000 task.ti: 8cad8000
[   90.783530] PC is at snvs_rtc_irq_handler+0x14/0x74
[   90.788424] LR is at handle_irq_event_percpu+0x3c/0x144

It can be fixed, with something like this:

@@ -346,7 +347,10 @@ static int snvs_rtc_resume(struct device *dev)
 }
 #endif
 
-static SIMPLE_DEV_PM_OPS(snvs_rtc_pm_ops, snvs_rtc_suspend,
snvs_rtc_resume);
+static const struct dev_pm_ops snvs_rtc_pm_ops = {
+       .suspend_noirq = snvs_rtc_suspend,
+       .resume_noirq = snvs_rtc_resume,
+};
 
 static const struct of_device_id snvs_dt_ids[] = {
        { .compatible = "fsl,sec-v4.0-mon-rtc-lp", },



Andrew, this patch is already merged, so it would need another fix for
this, right?

--
Stefan

> It could be omitted here also.
> 
>>  	return 0;
>>  }
>>  #endif




