Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756364AbaIWRh6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 13:37:58 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:64266 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756267AbaIWRh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 13:37:56 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: balbi@ti.com
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, sebastian.hesselbarth@gmail.com,
        Peter.Chen@freescale.com, p.zabel@pengutronix.de,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        devicetree@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, alexandre.belloni@free-electrons.com,
        jszhang@marvell.com
Subject: Re: [PATCH v6 07/12] usb: chipidea: add a usb2 driver for ci13xxx
Date: Tue, 23 Sep 2014 19:37:25 +0200
Message-ID: <62705234.gKJDtUQLyT@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140923165515.GA26604@saruman>
References: <1411468088-5702-1-git-send-email-antoine.tenart@free-electrons.com> <5140494.LzvyOiyY3U@wuerfel> <20140923165515.GA26604@saruman>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:EQWugCfdbgAqWW3G4yB2+Tx42VCJwlqPqCzYHxpYrvH
 qeQtS3lhHrrfiRWoWe/c2ruuRXnGD0Z5cp8CUn1p5K6Oxtq0Vo
 Z/0ASiPZMGQ3pXxcPFaXpYfY7fmMyMYM6lqZpS8gbvQ/QFqOPJ
 fx+R2yuaoW3qyGAORFNyv8Z+BpOzVymE12KpuEvGvYxi/ISepS
 zXyOw67eWe6KsQkyKDm4fmX9DCamFqExMONosZVp5qf3VtAvvF
 pNntUeqew3D9j81VjAOFGQADwUA3xBLMOkjJl0IA7EdPpI/hF4
 pY3vuG4/wBK/mX7tCELXjZn5J09QqIhXHbCgsWqZY6KeTs4rHS
 DXOBrotxUgYRZMmmuMHY=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 September 2014 11:55:15 Felipe Balbi wrote:
> On Tue, Sep 23, 2014 at 06:44:40PM +0200, Arnd Bergmann wrote:
> > On Tuesday 23 September 2014 15:36:45 Antoine Tenart wrote:
> > > On Tue, Sep 23, 2014 at 12:39:04PM +0200, Arnd Bergmann wrote:
> > > > On Tuesday 23 September 2014 12:28:03 Antoine Tenart wrote:
> > > > > +       if (dev->of_node) {
> > > > > +               ret = ci_hdrc_usb2_dt_probe(dev, ci_pdata);
> > > > > +               if (ret)
> > > > > +                       goto clk_err;
> > > > > +       } else {
> > > > > +               ret = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
> > > > > +               if (ret)
> > > > > +                       goto clk_err;
> > > > > +       }
> > > > > 
> > > > 
> > > > Why do you care about the non-DT case here? I think it would be nicer to
> > > > open-code the ci_hdrc_usb2_dt_probe() function in here and remove
> > > > the dma_set_mask_and_coherent(), which should not even be necessary for
> > > > the case where you have a hardwired platform device.
> > > > 
> > > 
> > > I thought we agreed to call dma_set_mask_and_coherent():
> > > http://lists.infradead.org/pipermail/linux-arm-kernel/2014-July/273335.html
> > > 
> > > I do not have a strong opinion on this as I only use the dt case for my
> > > usage.
> > 
> > The question is more about who actually wants the non-DT case.
> > 
> > Since this is a new driver, I suspect that the answer is "nobody",
> > as the existing board files are all for legacy platforms that we
> > are not going to adapt for this driver.
> 
> wait a minute... will the legacy platforms be adapted to DT and, thus,
> to this driver in the future ? I really don't want to keep several
> copies of chipidea driver just because there are still some legacy
> platforms still using them. I have said in the past and will say again,
> everybody should move to the generic chipidea driver at the earliest
> opportunity so we avoid duplication of work.
> 

Sorry, my mistake. The intention that this new driver is meant to
replace the existing ones wasn't clear to me from the changelog,
and if I'd been involved in the discussion before, then I've forgotten
about it.

It absolutely makes sense to migrate to a common driver, and in that
case we should keep the platform_data handling and dma_set_mask_and_coherent()
call in there, so we can do the two conversions (migrating from platform
specific frontends to the generic one, and migrating from platform_data
to DT) on independent schedules. Eventually I'd like all of the existing
users of the platform_data path to move to DT, but that should not
hold up the other cleanup if it takes longer.

There is however still my point that we shouldn't have an extra platform
device that is not attached to the device node. I think the generic driver
should just be part of the common code, without an extra framework.
Something like the (entirely untested) patch below.

	Arnd

---
diff --git a/drivers/usb/chipidea/ci.h b/drivers/usb/chipidea/ci.h
index 9563cb56d564..a2b20c1342f1 100644
--- a/drivers/usb/chipidea/ci.h
+++ b/drivers/usb/chipidea/ci.h
@@ -207,6 +207,7 @@ struct ci_hdrc {
 	bool				id_event;
 	bool				b_sess_valid_event;
 	bool				imx28_write_fix;
+	struct clk			*clk;
 };
 
 static inline struct ci_role_driver *ci_role(struct ci_hdrc *ci)
diff --git a/drivers/usb/chipidea/ci_hdrc_usb2.c b/drivers/usb/chipidea/ci_hdrc_usb2.c
index 6eae1de587f2..03ef35997dd8 100644
--- a/drivers/usb/chipidea/ci_hdrc_usb2.c
+++ b/drivers/usb/chipidea/ci_hdrc_usb2.c
@@ -70,6 +70,7 @@ static int ci_hdrc_usb2_probe(struct platform_device *pdev)
 	}
 
 	if (dev->of_node) {
+		ret = ci_get_platdata(dev, platdata);
 		ret = ci_hdrc_usb2_dt_probe(dev, ci_pdata);
 		if (ret)
 			goto clk_err;
diff --git a/drivers/usb/chipidea/core.c b/drivers/usb/chipidea/core.c
index 619d13e29995..32613751e731 100644
--- a/drivers/usb/chipidea/core.c
+++ b/drivers/usb/chipidea/core.c
@@ -478,6 +478,15 @@ static int ci_get_platdata(struct device *dev,
 	if (of_usb_get_maximum_speed(dev->of_node) == USB_SPEED_FULL)
 		platdata->flags |= CI_HDRC_FORCE_FULLSPEED;
 
+	platdata->phy = of_phy_get(dev->of_node, 0);
+	if (IS_ERR(platdata->phy)) {
+		if (PTR_ERR(platdata->phy) == -EPROBE_DEFER)
+			return -EPROBE_DEFER;
+
+		/* PHY is optional */
+		platdata->phy = NULL;
+	}
+
 	return 0;
 }
 
@@ -559,6 +568,12 @@ static void ci_get_otg_capable(struct ci_hdrc *ci)
 		dev_dbg(ci->dev, "It is OTG capable controller\n");
 }
 
+static const struct ci_hdrc_platform_data ci_default_pdata = {
+	.capoffset	= DEF_CAPOFFSET,
+	.flags		= CI_HDRC_REQUIRE_TRANSCEIVER |
+			  CI_HDRC_DISABLE_STREAMING,
+};
+
 static int ci_hdrc_probe(struct platform_device *pdev)
 {
 	struct device	*dev = &pdev->dev;
@@ -568,11 +583,6 @@ static int ci_hdrc_probe(struct platform_device *pdev)
 	int		ret;
 	enum usb_dr_mode dr_mode;
 
-	if (!dev_get_platdata(dev)) {
-		dev_err(dev, "platform data missing\n");
-		return -ENODEV;
-	}
-
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	base = devm_ioremap_resource(dev, res);
 	if (IS_ERR(base))
@@ -586,6 +596,32 @@ static int ci_hdrc_probe(struct platform_device *pdev)
 
 	ci->dev = dev;
 	ci->platdata = dev_get_platdata(dev);
+	if (!ci->platdata) {
+		ci->platdata = devm_kmemdup(dev, &ci_default_pdata,
+					    sizeof(ci_default_pdata),
+					    GFP_KERNEL);
+
+		if (!ci->platdata)
+			return -ENOMEM;
+
+		ret = ci_get_platdata(dev, platdata);
+		if (ret)
+			return ERR_PTR(ret);
+	}
+
+	priv->clk = devm_clk_get(dev, NULL);
+	if (!IS_ERR(priv->clk)) {
+		ret = clk_prepare_enable(priv->clk);
+		if (ret) {
+			dev_err(dev, "failed to enable the clock: %d\n", ret);
+			return ret;
+		}
+	}
+
+	ret = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
+	if (ret)
+		return ret;
+
 	ci->imx28_write_fix = !!(ci->platdata->flags &
 		CI_HDRC_IMX28_WRITE_FIX);
 
@@ -702,8 +738,8 @@ static int ci_hdrc_probe(struct platform_device *pdev)
 	}
 
 	platform_set_drvdata(pdev, ci);
-	ret = request_irq(ci->irq, ci_irq, IRQF_SHARED, ci->platdata->name,
-			  ci);
+	ret = devm_request_irq(ci->irq, ci_irq, IRQF_SHARED,
+			       ci->platdata->name, ci);
 	if (ret)
 		goto stop;
 
@@ -711,10 +747,13 @@ static int ci_hdrc_probe(struct platform_device *pdev)
 		ci_hdrc_otg_fsm_start(ci);
 
 	ret = dbg_create_files(ci);
-	if (!ret)
-		return 0;
+	if (ret)
+		goto stop;
+
+	pm_runtime_no_callbacks(dev);
+	pm_runtime_enable(dev);
+	return 0;
 
-	free_irq(ci->irq, ci);
 stop:
 	ci_role_destroy(ci);
 deinit_phy:
@@ -727,22 +766,32 @@ static int ci_hdrc_remove(struct platform_device *pdev)
 {
 	struct ci_hdrc *ci = platform_get_drvdata(pdev);
 
+	pm_runtime_disable(&pdev->dev);
 	dbg_remove_files(ci);
 	free_irq(ci->irq, ci);
 	ci_role_destroy(ci);
 	ci_hdrc_enter_lpm(ci, true);
 	usb_phy_shutdown(ci->transceiver);
 	kfree(ci->hw_bank.regmap);
+	clk_disable_unprepare(ci->clk);
 
 	return 0;
 }
 
+static const struct of_device_id ci_hdrc_usb2_of_match[] = {
+	{ .compatible = "chipidea,usb2" },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, ci_hdrc_usb2_of_match);
+
+
 static struct platform_driver ci_hdrc_driver = {
 	.probe	= ci_hdrc_probe,
 	.remove	= ci_hdrc_remove,
 	.driver	= {
 		.name	= "ci_hdrc",
 		.owner	= THIS_MODULE,
+		.of_match_table	= of_match_ptr(ci_hdrc_usb2_of_match),
 	},
 };
 

