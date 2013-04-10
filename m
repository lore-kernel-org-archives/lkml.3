Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964936Ab3DJMrA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 08:47:00 -0400
Received: from mga03.intel.com ([143.182.124.21]:5311 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759883Ab3DJMq7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 08:46:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,446,1363158000"; 
   d="scan'208";a="284248894"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "patches@opensource.wolfsonmicro.com" 
	<patches@opensource.wolfsonmicro.com>
Subject: RE: mfd, arizona: Fix the deadlock between interrupt handler and
 dpm_suspend
Thread-Topic: mfd, arizona: Fix the deadlock between interrupt handler and
 dpm_suspend
Thread-Index: AQHONecuZTTuWWGP/kehVQcuSJm/lpjPZVbw
Date: Wed, 10 Apr 2013 12:46:55 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4AC114FF@SHSMSX101.ccr.corp.intel.com>
References: <1365597549.12565.4.camel@cliu38-desktop-build>
 <20130410123003.GZ9243@opensource.wolfsonmicro.com>
In-Reply-To: <20130410123003.GZ9243@opensource.wolfsonmicro.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

> -----Original Message-----
> From: Mark Brown [mailto:broonie@opensource.wolfsonmicro.com]
> Sent: Wednesday, April 10, 2013 8:30 PM
> To: Liu, Chuansheng
> Cc: sameo@linux.intel.com; linux-kernel@vger.kernel.org;
> patches@opensource.wolfsonmicro.com
> Subject: Re: mfd, arizona: Fix the deadlock between interrupt handler and
> dpm_suspend
> 
> On Wed, Apr 10, 2013 at 08:39:09PM +0800, Chuansheng Liu wrote:
> 
> > Here the arizona irq is not NOSUSPEND irq, so when doing device suspend,
> > we can disable the arizona irq, and enable it until devices resuming finished.
> 
> Hrm, well - actually the primary IRQ probably ought to be a nosuspend in
Could we set the irq as NOSUSPEND directly?

> the first place so this probably isn't what we want.  Something like the
> below which does a similar thing to what we do on resume might help
> here...  needs testing though.
We will take your patch to do the test, thanks.

> 
> From 538e817db94dc0c689ecfea7151b1a3f86bb204a Mon Sep 17 00:00:00
> 2001
> From: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Date: Wed, 10 Apr 2013 12:40:26 +0100
> Subject: [PATCH] mfd: arizona: Disable interrupts during suspend
> 
> We aren't able to handle interrupts after the device has suspended since
> we need to runtime resume it in order to do so but the controller may not
> be available any more. Handle this in the same way as we handle a similar
> issue on resume.
> 
> Reported-by: Chuansheng Liu <chuansheng.liu@intel.com>
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/mfd/arizona-core.c |   23 ++++++++++++++++++++++-
>  1 file changed, 22 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/mfd/arizona-core.c b/drivers/mfd/arizona-core.c
> index 98023d8..c6be1f6 100644
> --- a/drivers/mfd/arizona-core.c
> +++ b/drivers/mfd/arizona-core.c
> @@ -399,6 +399,26 @@ static int arizona_runtime_suspend(struct device
> *dev)
>  #endif
> 
>  #ifdef CONFIG_PM_SLEEP
> +static int arizona_suspend(struct device *dev)
> +{
> +	struct arizona *arizona = dev_get_drvdata(dev);
> +
> +	dev_dbg(arizona->dev, "Suspend, disabling IRQ\n");
> +	disable_irq(arizona->irq);
> +
> +	return 0;
> +}
> +
> +static int arizona_suspend_late(struct device *dev)
> +{
> +	struct arizona *arizona = dev_get_drvdata(dev);
> +
> +	dev_dbg(arizona->dev, "Late suspend, reenabling IRQ\n");
> +	enable_irq(arizona->irq);
Here, after later suspending, is it possible the irq coming again?
and one more question, why the irq is needed to be enabled even after suspended?

> +
> +	return 0;
> +}
> +
>  static int arizona_resume_noirq(struct device *dev)
>  {
>  	struct arizona *arizona = dev_get_drvdata(dev);
> @@ -424,8 +444,9 @@ const struct dev_pm_ops arizona_pm_ops = {
>  	SET_RUNTIME_PM_OPS(arizona_runtime_suspend,
>  			   arizona_runtime_resume,
>  			   NULL)
> -	SET_SYSTEM_SLEEP_PM_OPS(NULL, arizona_resume)
> +	SET_SYSTEM_SLEEP_PM_OPS(arizona_suspend, arizona_resume)
>  #ifdef CONFIG_PM_SLEEP
> +	.suspend_late = arizona_suspend_late,
>  	.resume_noirq = arizona_resume_noirq,
>  #endif
>  };
> --
> 1.7.10.4

