Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754862Ab3GPJOZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 05:14:25 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:38006 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754148Ab3GPJOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 05:14:16 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/ObN8DC7MeZEpGTnDkuiLM
Date: Tue, 16 Jul 2013 02:14:14 -0700
From: Tony Lindgren <tony@atomide.com>
To: linus.walleij@linaro.org
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/4] improved support for runtime muxing for pinctrl
Message-ID: <20130716091413.GT7656@atomide.com>
References: <20130716090310.5541.36777.stgit@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130716090310.5541.36777.stgit@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Tony Lindgren <tony@atomide.com> [130716 02:12]:
> 
> As discussed earlier, the pinctrl support for changing some of the
> consumer device pins during runtime needs some improvment.
> 
> Here are the patches to do that, I'll also post a minimal sample
> patch as a reply to this thread on how to do the muxing for
> runtime PM.

Here's a patch showing the suggested usage remuxing SDIO IRQ
to GPIO mode for runtime PM. Note that this patch depends on
three other patches for the hsmmc driver, I'll post that series
separately.

Regards,

Tony


From: Tony Lindgren <tony@atomide.com>
Date: Mon, 15 Jul 2013 07:39:39 -0700
Subject: [PATCH] mmc: omap_hsmmc: Remux pins to support SDIO interrupt and PM runtime

On some omaps we need to remux MMC pins for PM, and for some omaps
we need to remux the SDIO IRQ pin.

Based on an earlier patch by Andreas Fenkart <afenkart@gmail.com>.

Cc: Andreas Fenkart <afenkart@gmail.com>
Cc: Balaji T K <balajitk@ti.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Tony Lindgren <tony@atomide.com>

--- a/drivers/mmc/host/omap_hsmmc.c
+++ b/drivers/mmc/host/omap_hsmmc.c
@@ -1869,7 +1869,6 @@ static int omap_hsmmc_probe(struct platform_device *pdev)
 	const struct of_device_id *match;
 	dma_cap_mask_t mask;
 	unsigned tx_req, rx_req;
-	struct pinctrl *pinctrl;
 
 	match = of_match_device(of_match_ptr(omap_mmc_of_match), &pdev->dev);
 	if (match) {
@@ -2114,21 +2113,19 @@ static int omap_hsmmc_probe(struct platform_device *pdev)
 
 	omap_hsmmc_disable_irq(host);
 
-	pinctrl = devm_pinctrl_get_select_default(&pdev->dev);
-	if (IS_ERR(pinctrl))
-		dev_warn(&pdev->dev,
-			"pins are not configured from the driver\n");
-
 	/*
-	 * For now, only support SDIO interrupt if we are doing
-	 * muxing of dat1 when booted with DT. This is because the
+	 * For now, only support SDIO interrupt if we are doing dynamic
+	 * remuxing of dat1 when booted with DT. This is because the
 	 * supposedly the wake-up events for CTPL don't work from deeper
 	 * idle states. And we don't want to add new legacy mux platform
 	 * init code callbacks any longer as we are moving to DT based
 	 * booting anyways.
 	 */
 	if (match) {
-		if (!IS_ERR(pinctrl) && mmc_slot(host).sdio_irq)
+		struct device *dev = &pdev->dev;
+
+		if (!pinctrl_pm_check_idle_state(dev) &&
+		    mmc_slot(host).sdio_irq)
 			mmc->caps |= MMC_CAP_SDIO_IRQ;
 	}
 
@@ -2348,6 +2345,10 @@ static int omap_hsmmc_runtime_suspend(struct device *dev)
 		OMAP_HSMMC_WRITE(host->base, STAT, STAT_CLEAR);
 		spin_unlock_irqrestore(&host->irq_lock, flags);
 
+		ret = pinctrl_pm_select_idle_state(dev);
+		if (ret < 0)
+			dev_err(dev, "Unable to select idle pinmux\n");
+
 		if (mmc_slot(host).sdio_irq)
 			enable_irq(mmc_slot(host).sdio_irq);
 	}
@@ -2371,6 +2372,10 @@ static int omap_hsmmc_runtime_resume(struct device *dev)
 		if (mmc_slot(host).sdio_irq)
 			disable_irq(mmc_slot(host).sdio_irq);
 
+		ret = pinctrl_pm_select_active_state(dev);
+		if (ret < 0)
+			dev_err(dev, "Unable to select active pinmux\n");
+
 		spin_lock_irqsave(&host->irq_lock, flags);
 		host->active_pinmux = true;
 
