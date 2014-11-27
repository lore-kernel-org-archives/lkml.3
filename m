Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751212AbaK0PVJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 10:21:09 -0500
Received: from mail-bn1on0090.outbound.protection.outlook.com ([157.56.110.90]:2112
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750871AbaK0PVH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 10:21:07 -0500
Date: Thu, 27 Nov 2014 15:46:32 +0100
From: Michal Simek <michal.simek@xilinx.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Kedareswara rao Appana <appana.durga.rao@xilinx.com>, <wg@grandegger.com>,
        <mkl@pengutronix.de>, <michal.simek@xilinx.com>,
        <soren.brinkmann@xilinx.com>, <grant.likely@linaro.org>,
        <robh+dt@kernel.org>
CC: <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>,
        Kedareswara rao Appana <appanad@xilinx.com>
Subject: Re: [PATCH v3] can: Convert to runtime_pm
References: <1417093733-29576-1-git-send-email-appanad@xilinx.com>
In-Reply-To: <1417093733-29576-1-git-send-email-appanad@xilinx.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21132.007
X-TM-AS-User-Approved-Sender: Yes
Message-ID: <e7afe187b4694ca591b2c22adafa8449@BL2FFO11FD053.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:62.221.5.235;CTRY:GB;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(24454002)(479174003)(377454003)(51704005)(189002)(164054003)(199003)(74316001)(54356999)(6806004)(106466001)(83506001)(50466002)(44976005)(20776003)(65806001)(50986999)(87936001)(19580405001)(65956001)(77156002)(104016003)(64706001)(102836001)(95666004)(108616004)(21056001)(107046002)(92566001)(120916001)(64126003)(99396003)(23746002)(4396001)(76176999)(47776003)(2201001)(46102003)(86362001)(62966003)(31966008)(19580395003)(65826006)(107986001)(24736002)(2101003);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2FFO11HUB057;H:xir-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-62-221-5-235.ipspace.xilinx.com;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BL2FFO11HUB057;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BL2FFO11HUB057;
X-Forefront-PRVS: 040866B734
Authentication-Results: spf=pass (sender IP is 62.221.5.235)
 smtp.mailfrom=michal.simek@xilinx.com; 
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BL2FFO11HUB057;
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/27/2014 02:08 PM, Kedareswara rao Appana wrote:
> Instead of enabling/disabling clocks at several locations in the driver,
> use the runtime_pm framework. This consolidates the actions for
> runtime PM in the appropriate callbacks and makes the driver more
> readable and mantainable.
> 
> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> Signed-off-by: Kedareswara rao Appana <appanad@xilinx.com>
> ---
> Changes for v3:
>   - Converted the driver to use runtime_pm.
> Changes for v2:
>   - Removed the struct platform_device* from suspend/resume
>     as suggest by Lothar.
> 
>  drivers/net/can/xilinx_can.c |  119 +++++++++++++++++++++++++----------------
>  1 files changed, 72 insertions(+), 47 deletions(-)
> 
> diff --git a/drivers/net/can/xilinx_can.c b/drivers/net/can/xilinx_can.c
> index 8a998e3..1be28ed 100644
> --- a/drivers/net/can/xilinx_can.c
> +++ b/drivers/net/can/xilinx_can.c
> @@ -32,6 +32,7 @@
>  #include <linux/can/dev.h>
>  #include <linux/can/error.h>
>  #include <linux/can/led.h>
> +#include <linux/pm_runtime.h>
>  
>  #define DRIVER_NAME	"xilinx_can"
>  
> @@ -138,7 +139,7 @@ struct xcan_priv {
>  	u32 (*read_reg)(const struct xcan_priv *priv, enum xcan_reg reg);
>  	void (*write_reg)(const struct xcan_priv *priv, enum xcan_reg reg,
>  			u32 val);
> -	struct net_device *dev;
> +	struct device *dev;
>  	void __iomem *reg_base;
>  	unsigned long irq_flags;
>  	struct clk *bus_clk;
> @@ -842,6 +843,13 @@ static int xcan_open(struct net_device *ndev)
>  	struct xcan_priv *priv = netdev_priv(ndev);
>  	int ret;
>  
> +	ret = pm_runtime_get_sync(priv->dev);
> +	if (ret < 0) {
> +		netdev_err(ndev, "%s: runtime CAN resume failed(%d)\n\r",
> +				__func__, ret);
> +		return ret;
> +	}
> +
>  	ret = request_irq(ndev->irq, xcan_interrupt, priv->irq_flags,
>  			ndev->name, ndev);
>  	if (ret < 0) {
> @@ -849,29 +857,17 @@ static int xcan_open(struct net_device *ndev)
>  		goto err;
>  	}
>  
> -	ret = clk_prepare_enable(priv->can_clk);
> -	if (ret) {
> -		netdev_err(ndev, "unable to enable device clock\n");
> -		goto err_irq;
> -	}
> -
> -	ret = clk_prepare_enable(priv->bus_clk);
> -	if (ret) {
> -		netdev_err(ndev, "unable to enable bus clock\n");
> -		goto err_can_clk;
> -	}
> -
>  	/* Set chip into reset mode */
>  	ret = set_reset_mode(ndev);
>  	if (ret < 0) {
>  		netdev_err(ndev, "mode resetting failed!\n");
> -		goto err_bus_clk;
> +		goto err_irq;
>  	}
>  
>  	/* Common open */
>  	ret = open_candev(ndev);
>  	if (ret)
> -		goto err_bus_clk;
> +		goto err_irq;
>  
>  	ret = xcan_chip_start(ndev);
>  	if (ret < 0) {
> @@ -887,13 +883,11 @@ static int xcan_open(struct net_device *ndev)
>  
>  err_candev:
>  	close_candev(ndev);
> -err_bus_clk:
> -	clk_disable_unprepare(priv->bus_clk);
> -err_can_clk:
> -	clk_disable_unprepare(priv->can_clk);
>  err_irq:
>  	free_irq(ndev->irq, ndev);
>  err:
> +	pm_runtime_put(priv->dev);
> +
>  	return ret;
>  }
>  
> @@ -910,12 +904,11 @@ static int xcan_close(struct net_device *ndev)
>  	netif_stop_queue(ndev);
>  	napi_disable(&priv->napi);
>  	xcan_chip_stop(ndev);
> -	clk_disable_unprepare(priv->bus_clk);
> -	clk_disable_unprepare(priv->can_clk);
>  	free_irq(ndev->irq, ndev);
>  	close_candev(ndev);
>  
>  	can_led_event(ndev, CAN_LED_EVENT_STOP);
> +	pm_runtime_put(priv->dev);
>  
>  	return 0;
>  }
> @@ -934,27 +927,21 @@ static int xcan_get_berr_counter(const struct net_device *ndev,
>  	struct xcan_priv *priv = netdev_priv(ndev);
>  	int ret;
>  
> -	ret = clk_prepare_enable(priv->can_clk);
> -	if (ret)
> -		goto err;
> +	ret = pm_runtime_get_sync(priv->dev);
> +	if (ret < 0) {
> +		netdev_err(ndev, "%s: runtime resume failed(%d)\n\r",
> +				__func__, ret);
> +		return ret;
> +	}
>  
> -	ret = clk_prepare_enable(priv->bus_clk);
> -	if (ret)
> -		goto err_clk;
>  
>  	bec->txerr = priv->read_reg(priv, XCAN_ECR_OFFSET) & XCAN_ECR_TEC_MASK;
>  	bec->rxerr = ((priv->read_reg(priv, XCAN_ECR_OFFSET) &
>  			XCAN_ECR_REC_MASK) >> XCAN_ESR_REC_SHIFT);
>  
> -	clk_disable_unprepare(priv->bus_clk);
> -	clk_disable_unprepare(priv->can_clk);
> +	pm_runtime_put(priv->dev);
>  
>  	return 0;
> -
> -err_clk:
> -	clk_disable_unprepare(priv->can_clk);
> -err:
> -	return ret;
>  }
>  
>  
> @@ -967,15 +954,45 @@ static const struct net_device_ops xcan_netdev_ops = {
>  
>  /**
>   * xcan_suspend - Suspend method for the driver
> - * @dev:	Address of the platform_device structure
> + * @dev:	Address of the net_device structure

This is just the device structure.

>   *
>   * Put the driver into low power mode.
> - * Return: 0 always
> + * Return: 0 on success and failure value on error
>   */
>  static int __maybe_unused xcan_suspend(struct device *dev)
>  {
> -	struct platform_device *pdev = dev_get_drvdata(dev);
> -	struct net_device *ndev = platform_get_drvdata(pdev);
> +	if (!device_may_wakeup(dev))
> +		return pm_runtime_force_suspend(dev);
> +
> +	return 0;
> +}
> +
> +/**
> + * xcan_resume - Resume from suspend
> + * @dev:	Address of the net_device structure

ditto

> + *
> + * Resume operation after suspend.
> + * Return: 0 on success and failure value on error
> + */
> +static int __maybe_unused xcan_resume(struct device *dev)
> +{
> +	if (!device_may_wakeup(dev))
> +		return pm_runtime_force_resume(dev);
> +
> +	return 0;
> +
> +}
> +
> +/**
> + * xcan_runtime_suspend - Runtime suspend method for the driver
> + * @dev:	Address of the net_device structure

ditto.

> + *
> + * Put the driver into low power mode.
> + * Return: 0 always
> + */
> +static int __maybe_unused xcan_runtime_suspend(struct device *dev)
> +{
> +	struct net_device *ndev = dev_get_drvdata(dev);
>  	struct xcan_priv *priv = netdev_priv(ndev);
>  
>  	if (netif_running(ndev)) {
> @@ -993,16 +1010,15 @@ static int __maybe_unused xcan_suspend(struct device *dev)
>  }
>  
>  /**
> - * xcan_resume - Resume from suspend
> - * @dev:	Address of the platformdevice structure
> + * xcan_runtime_resume - Runtime resume from suspend
> + * @dev:	Address of the net_device structure

ditto.

Thanks,
Michal
