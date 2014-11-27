Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751300AbaK0Wrv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 17:47:51 -0500
Received: from mail-by2on0096.outbound.protection.outlook.com ([207.46.100.96]:14029
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750836AbaK0Wrs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 17:47:48 -0500
Date: Thu, 27 Nov 2014 14:47:41 -0800
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Marc Kleine-Budde <mkl@pengutronix.de>
CC: Kedareswara rao Appana <appana.durga.rao@xilinx.com>, <wg@grandegger.com>,
        <michal.simek@xilinx.com>, <grant.likely@linaro.org>,
        <robh+dt@kernel.org>, <linux-can@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        Kedareswara rao Appana <appanad@xilinx.com>
Subject: Re: [PATCH v3] can: Convert to runtime_pm
References: <6b6db31d46074512a322eae6e4ef64d4@BN1BFFO11FD038.protection.gbl>
 <54779501.8060009@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <54779501.8060009@pengutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21136.001
X-TM-AS-User-Approved-Sender: Yes;Yes
Message-ID: <820358d5369f465188dfa9306eae5658@BL2FFO11FD009.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(51704005)(189002)(24454002)(377454003)(479174003)(199003)(377424004)(19580405001)(85182001)(46102003)(31966008)(86362001)(120916001)(83506001)(19580395003)(77156002)(106466001)(53416004)(50466002)(4396001)(99396003)(110136001)(44976005)(74316001)(21056001)(108616004)(47776003)(85202003)(23676002)(107046002)(54356999)(92566001)(104016003)(62966003)(102836001)(87936001)(50986999)(6806004)(76176999)(20776003)(95666004)(77096003)(64706001)(107986001)(24736002)(23106004);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2FFO11HUB065;H:xsj-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BL2FFO11HUB065;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BL2FFO11HUB065;
X-Forefront-PRVS: 040866B734
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BL2FFO11HUB065;
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-11-27 at 10:17PM +0100, Marc Kleine-Budde wrote:
> On 11/27/2014 02:08 PM, Kedareswara rao Appana wrote:
> > Instead of enabling/disabling clocks at several locations in the driver,
> > use the runtime_pm framework. This consolidates the actions for
> > runtime PM in the appropriate callbacks and makes the driver more
> > readable and mantainable.
> > 
> > Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> > Signed-off-by: Kedareswara rao Appana <appanad@xilinx.com>
> > ---
> > Changes for v3:
> >   - Converted the driver to use runtime_pm.
> > Changes for v2:
> >   - Removed the struct platform_device* from suspend/resume
> >     as suggest by Lothar.
> > 
> >  drivers/net/can/xilinx_can.c |  119 +++++++++++++++++++++++++----------------
> >  1 files changed, 72 insertions(+), 47 deletions(-)
> > 
> > diff --git a/drivers/net/can/xilinx_can.c b/drivers/net/can/xilinx_can.c
> > index 8a998e3..1be28ed 100644
> > --- a/drivers/net/can/xilinx_can.c
> > +++ b/drivers/net/can/xilinx_can.c
[...]
> > @@ -1030,7 +1046,10 @@ static int __maybe_unused xcan_resume(struct device *dev)
> >  	return 0;
> >  }
> >  
> > -static SIMPLE_DEV_PM_OPS(xcan_dev_pm_ops, xcan_suspend, xcan_resume);
> > +static const struct dev_pm_ops xcan_dev_pm_ops = {
> > +	SET_SYSTEM_SLEEP_PM_OPS(xcan_suspend, xcan_resume)
> > +	SET_PM_RUNTIME_PM_OPS(xcan_runtime_suspend, xcan_runtime_resume, NULL)
> > +};
> >  
> >  /**
> >   * xcan_probe - Platform registration call
> > @@ -1071,7 +1090,7 @@ static int xcan_probe(struct platform_device *pdev)
> >  		return -ENOMEM;
> >  
> >  	priv = netdev_priv(ndev);
> > -	priv->dev = ndev;
> > +	priv->dev = &pdev->dev;
> >  	priv->can.bittiming_const = &xcan_bittiming_const;
> >  	priv->can.do_set_mode = xcan_do_set_mode;
> >  	priv->can.do_get_berr_counter = xcan_get_berr_counter;
> > @@ -1137,6 +1156,11 @@ static int xcan_probe(struct platform_device *pdev)
> >  
> >  	netif_napi_add(ndev, &priv->napi, xcan_rx_poll, rx_max);
> >  
> > +	pm_runtime_set_active(&pdev->dev);
> > +	pm_runtime_irq_safe(&pdev->dev);
> 
> You use just clock_enable()/disable() in the runtime functions, thus you
> can say they are irq_safe. On the other the the zync grpio driver uses
> "full" prepare_enable/disable_unprepare calls. What's best practice here?

IIRC, the prepare/unprepare functions can sleep. xcan_get_berr_counter
is called from atomic context. So, I think we have to use the
disable/enable functions without the prepare/unprepare.
In the GPIO driver the that problem does not exist.

	Sören
