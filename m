Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753493AbaI1D5K (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2014 23:57:10 -0400
Received: from mail-by2on0134.outbound.protection.outlook.com ([207.46.100.134]:31648
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752322AbaI1D5J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2014 23:57:09 -0400
Date: Sun, 28 Sep 2014 11:56:33 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Sanchayan Maity <maitysanchayan@gmail.com>
CC: <kernel@pengutronix.de>, <a.zummo@towertech.it>, <b35083@freescale.com>,
        <rtc-linux@googlegroups.com>, <stefan@agner.ch>,
        <linux@arm.linux.org.uk>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] drivers/rtc/rtc-snvs: Add clock support
Message-ID: <20140928035631.GF12999@dragon>
References: <cover.1411736171.git.maitysanchayan@gmail.com>
 <8a1904a59f7b171a7cf1e71b9e80f0cf7b1061c0.1411736171.git.maitysanchayan@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <8a1904a59f7b171a7cf1e71b9e80f0cf7b1061c0.1411736171.git.maitysanchayan@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [221.225.208.47]
X-ClientProxiedBy: HKXPR01CA005.apcprd01.prod.exchangelabs.com (10.242.96.15)
 To BLUPR03MB343.namprd03.prod.outlook.com (10.141.48.21)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR03MB343;
X-Forefront-PRVS: 03484C0ABF
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(6009001)(51704005)(189002)(199003)(24454002)(83506001)(97756001)(66066001)(31966008)(47776003)(20776003)(101416001)(4396001)(76176999)(54356999)(42186005)(50986999)(97736003)(83072002)(85852003)(87976001)(1411001)(46406003)(64706001)(107046002)(92726001)(110136001)(92566001)(86362001)(33716001)(50466002)(83322001)(90102001)(19580395003)(19580405001)(23726002)(21056001)(76482002)(81342003)(33656002)(77096002)(10300001)(120916001)(105586002)(95666004)(81542003)(77982003)(102836001)(80022003)(74502003)(74662003)(46102003)(79102003)(106356001)(85306004)(99396003);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR03MB343;H:dragon;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 26, 2014 at 06:44:01PM +0530, Sanchayan Maity wrote:
> This patch adds clock enable and disable support
> for the SNVS peripheral which is required by the
> SNVS RTC.
> 
> Signed-off-by: Sanchayan Maity <maitysanchayan@gmail.com>
> ---
>  drivers/rtc/rtc-snvs.c |   48 +++++++++++++++++++++++++++++++++++++++---------
>  1 file changed, 39 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/rtc/rtc-snvs.c b/drivers/rtc/rtc-snvs.c
> index fa384fe..f3e8f05 100644
> --- a/drivers/rtc/rtc-snvs.c
> +++ b/drivers/rtc/rtc-snvs.c
> @@ -17,6 +17,7 @@
>  #include <linux/of_device.h>
>  #include <linux/platform_device.h>
>  #include <linux/rtc.h>
> +#include <linux/clk.h>
>  
>  /* These register offsets are relative to LP (Low Power) range */
>  #define SNVS_LPCR		0x04
> @@ -39,6 +40,7 @@ struct snvs_rtc_data {
>  	void __iomem *ioaddr;
>  	int irq;
>  	spinlock_t lock;
> +	struct clk *clk;
>  };
>  
>  static u32 rtc_read_lp_counter(void __iomem *ioaddr)
> @@ -260,8 +262,31 @@ static int snvs_rtc_probe(struct platform_device *pdev)
>  	if (data->irq < 0)
>  		return data->irq;
>  
> +	ret = devm_request_irq(&pdev->dev, data->irq, snvs_rtc_irq_handler,
> +			       IRQF_SHARED, "rtc alarm", &pdev->dev);
> +	if (ret) {
> +		dev_err(&pdev->dev, "failed to request irq %d: %d\n",
> +			data->irq, ret);
> +		return ret;
> +	}
> +
> +	data->clk = devm_clk_get(&pdev->dev, "snvs");
> +	if (IS_ERR(data->clk)) {
> +		dev_err(&pdev->dev, "failed getting clock, err = %ld\n",
> +						PTR_ERR(data->clk));
> +		ret = PTR_ERR(data->clk);
> +		return ret;
> +	}

No. This will break all i.MX6 devices running a DTB without clock
definition.

Shawn

> +
>  	platform_set_drvdata(pdev, data);
>  
> +	ret = clk_prepare_enable(data->clk);
> +	if (ret) {
> +		dev_err(&pdev->dev,
> +			"Could not prepare or enable the snvs clock\n");
> +		return ret;
> +	}
> +
>  	spin_lock_init(&data->lock);
>  
>  	/* Initialize glitch detect */
> @@ -275,23 +300,20 @@ static int snvs_rtc_probe(struct platform_device *pdev)
>  
>  	device_init_wakeup(&pdev->dev, true);
>  
> -	ret = devm_request_irq(&pdev->dev, data->irq, snvs_rtc_irq_handler,
> -			       IRQF_SHARED, "rtc alarm", &pdev->dev);
> -	if (ret) {
> -		dev_err(&pdev->dev, "failed to request irq %d: %d\n",
> -			data->irq, ret);
> -		return ret;
> -	}
> -
>  	data->rtc = devm_rtc_device_register(&pdev->dev, pdev->name,
>  					&snvs_rtc_ops, THIS_MODULE);
>  	if (IS_ERR(data->rtc)) {
>  		ret = PTR_ERR(data->rtc);
>  		dev_err(&pdev->dev, "failed to register rtc: %d\n", ret);
> -		return ret;
> +		goto error_rtc_device_register;
>  	}
>  
>  	return 0;
> +
> +error_rtc_device_register:
> +	clk_disable_unprepare(data->clk);
> +
> +	return ret;
>  }
>  
>  #ifdef CONFIG_PM_SLEEP
> @@ -302,16 +324,24 @@ static int snvs_rtc_suspend(struct device *dev)
>  	if (device_may_wakeup(dev))
>  		enable_irq_wake(data->irq);
>  
> +	clk_disable_unprepare(data->clk);
> +
>  	return 0;
>  }
>  
>  static int snvs_rtc_resume(struct device *dev)
>  {
> +	int ret;
> +
>  	struct snvs_rtc_data *data = dev_get_drvdata(dev);
>  
>  	if (device_may_wakeup(dev))
>  		disable_irq_wake(data->irq);
>  
> +	ret = clk_prepare_enable(data->clk);
> +	if (ret)
> +		return ret;
> +
>  	return 0;
>  }
>  #endif
> -- 
> 1.7.9.5
> 
