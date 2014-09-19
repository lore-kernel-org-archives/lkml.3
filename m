Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757264AbaISP4q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 11:56:46 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:40751 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756002AbaISP4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 11:56:44 -0400
From: Stephen Warren <swarren@wwwdotorg.org>
To: Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>,
        Russell King <linux@arm.linux.org.uk>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH V2] mmc: don't request CD IRQ until mmc_start_host()
Date: Fri, 19 Sep 2014 09:56:54 -0600
Message-Id: <1411142214-14505-1-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.9.1
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

As soon as the CD IRQ is requested, it can trigger, since it's an
externally controlled event. If it does, delayed_work host->detect will
be scheduled.

Many host controller probe()s are roughly structured as:

*_probe() {
    host = sdhci_pltfm_init();
    mmc_of_parse(host->mmc);
    rc = sdhci_add_host(host);
    if (rc) {
        sdhci_pltfm_free();
        return rc;
    }

In 3.17, CD IRQs can are enabled quite early via *_probe() ->
mmc_of_parse() -> mmc_gpio_request_cd() -> mmc_gpiod_request_cd_irq().

Note that in linux-next, mmc_of_parse() calls mmc_gpio*d*_request_cd()
rather than mmc_gpio_request_cd(), and mmc_gpio*d*_request_cd() doesn't
call mmc_gpiod_request_cd_irq(). However, this issue still exists if
mmc_gpio_request_cd() is called directly before mmc_start_host().

sdhci_add_host() may fail part way through (e.g. due to deferred
probe for a vmmc regulator), and sdhci_pltfm_free() does nothing to
unrequest the CD IRQ nor cancel the delayed_work. sdhci_pltfm_free() is
coded to assume that if sdhci_add_host() failed, then the delayed_work
cannot (or should not) have been triggered.

This can lead to the following with CONFIG_DEBUG_OBJECTS_* enabled, when
kfree(host) is eventually called inside sdhci_pltfm_free():

WARNING: CPU: 2 PID: 6 at lib/debugobjects.c:263 debug_print_object+0x8c/0xb4()
ODEBUG: free active (active state 0) object type: timer_list hint: delayed_work_timer_fn+0x0/0x18

The object being complained about is host->detect.

There's no need to request the CD IRQ so early; mmc_start_host() already
requests it. For most SDHCI hosts at least, the typical call path that
does this is: *_probe() -> sdhci_add_host() -> mmc_add_host() ->
mmc_start_host().

Ideally, we would solve this by removing the call to
mmc_gpiod_request_cd_irq() from mmc_gpio_request_cd(). This would match
mmc_gpio*d*_request_cd(), which already doesn't call
mmc_gpiod_request_cd_irq(). However, we need to keep the call and make it
conditional; some host controller drivers call mmc_gpio_request_cd()
after mmc_start_host() has already been called, and assume that this will
also call mmc_gpiod_request_cd_irq(). Unfortunately, the only way I could
find to differentiate the two cases was to add an extra parameter to
mmc_gpio_request_cd() to provide this information.

This solves the problem (eliminates the kernel error message above),
since it guarantees that the IRQ can't trigger before mmc_start_host()
is called.

The critical point here is that once sdhci_add_host() calls
mmc_add_host() -> mmc_start_host(), sdhci_add_host() is coded not to
fail. In other words, if there's a chance that mmc_start_host() may have
been called, and CD IRQs triggered, and the delayed_work scheduled,
sdhci_add_host() won't fail, and so cleanup is no longer via
sdhci_pltfm_free() (which doesn't free the IRQ or cancel the work queue)
but instead must be via sdhci_remove_host(), which calls mmc_remove_host()
-> mmc_stop_host(), which does free the IRQ and cancel the work queue.

CC: Russell King <linux@arm.linux.org.uk>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexandre Courbot <acourbot@nvidia.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
Note: This is a patch for v3.17 (and perhaps earlier); linux-next doesn't
have this problem due to other code re-structing. However, I think those
patches are too large to backport.

v2: Rather than completely removing mmc_gpio_request_cd()'s call to
mmc_gpiod_request_cd_irq(), make the call conditional.
---
 drivers/mmc/core/host.c            |  2 +-
 drivers/mmc/core/slot-gpio.c       | 13 +++++++++++--
 drivers/mmc/host/jz4740_mmc.c      |  3 ++-
 drivers/mmc/host/mmc_spi.c         |  2 +-
 drivers/mmc/host/mmci.c            |  2 +-
 drivers/mmc/host/mvsdio.c          |  2 +-
 drivers/mmc/host/sdhci-esdhc-imx.c |  3 ++-
 drivers/mmc/host/sdhci-pxav3.c     |  2 +-
 drivers/mmc/host/sdhci-sirf.c      |  2 +-
 drivers/mmc/host/sdhci-spear.c     |  3 ++-
 drivers/mmc/host/sh_mmcif.c        |  2 +-
 drivers/mmc/host/tmio_mmc_pio.c    |  2 +-
 include/linux/mmc/slot-gpio.h      |  2 +-
 13 files changed, 26 insertions(+), 14 deletions(-)

diff --git a/drivers/mmc/core/host.c b/drivers/mmc/core/host.c
index 95cceae96944..217d6c99c11d 100644
--- a/drivers/mmc/core/host.c
+++ b/drivers/mmc/core/host.c
@@ -374,7 +374,7 @@ int mmc_of_parse(struct mmc_host *host)
 			if (!(flags & OF_GPIO_ACTIVE_LOW))
 				gpio_inv_cd = true;
 
-			ret = mmc_gpio_request_cd(host, gpio, 0);
+			ret = mmc_gpio_request_cd(host, gpio, 0, false);
 			if (ret < 0) {
 				dev_err(host->parent,
 					"Failed to request CD GPIO #%d: %d!\n",
diff --git a/drivers/mmc/core/slot-gpio.c b/drivers/mmc/core/slot-gpio.c
index 5f89cb83d5f0..b63af8392dc1 100644
--- a/drivers/mmc/core/slot-gpio.c
+++ b/drivers/mmc/core/slot-gpio.c
@@ -176,6 +176,7 @@ EXPORT_SYMBOL(mmc_gpiod_request_cd_irq);
  * @host: mmc host
  * @gpio: gpio number requested
  * @debounce: debounce time in microseconds
+ * @request_irq: Request/enable the IRQ, or defer this until later
  *
  * As devm_* managed functions are used in mmc_gpio_request_cd(), client
  * drivers do not need to explicitly call mmc_gpio_free_cd() for freeing up,
@@ -191,7 +192,7 @@ EXPORT_SYMBOL(mmc_gpiod_request_cd_irq);
  * Returns zero on success, else an error.
  */
 int mmc_gpio_request_cd(struct mmc_host *host, unsigned int gpio,
-			unsigned int debounce)
+			unsigned int debounce, bool request_irq)
 {
 	struct mmc_gpio *ctx;
 	int ret;
@@ -221,7 +222,15 @@ int mmc_gpio_request_cd(struct mmc_host *host, unsigned int gpio,
 	ctx->override_cd_active_level = true;
 	ctx->cd_gpio = gpio_to_desc(gpio);
 
-	mmc_gpiod_request_cd_irq(host);
+	/*
+	 * Ideally, we would never request the IRQ here, but rather rely upon
+	 * mmc_start_host() calling mmc_gpiod_request_cd_irq(). However, some
+	 * controller drivers call mmc_gpio_request_cd() after calling
+	 * mmc_add_host() -> mmc_start_host(), and in that case we need to
+	 * request the IRQ here, since it won't happen anywhere else.
+	 */
+	if (request_irq)
+		mmc_gpiod_request_cd_irq(host);
 
 	return 0;
 }
diff --git a/drivers/mmc/host/jz4740_mmc.c b/drivers/mmc/host/jz4740_mmc.c
index 537d6c7a5ae4..a6eae4764396 100644
--- a/drivers/mmc/host/jz4740_mmc.c
+++ b/drivers/mmc/host/jz4740_mmc.c
@@ -716,7 +716,8 @@ static int jz4740_mmc_request_gpios(struct mmc_host *mmc,
 		mmc->caps2 |= MMC_CAP2_RO_ACTIVE_HIGH;
 
 	if (gpio_is_valid(pdata->gpio_card_detect)) {
-		ret = mmc_gpio_request_cd(mmc, pdata->gpio_card_detect, 0);
+		ret = mmc_gpio_request_cd(mmc, pdata->gpio_card_detect, 0,
+					  false);
 		if (ret)
 			return ret;
 	}
diff --git a/drivers/mmc/host/mmc_spi.c b/drivers/mmc/host/mmc_spi.c
index cc8d4a6099cd..60102ce7073b 100644
--- a/drivers/mmc/host/mmc_spi.c
+++ b/drivers/mmc/host/mmc_spi.c
@@ -1433,7 +1433,7 @@ static int mmc_spi_probe(struct spi_device *spi)
 
 	if (host->pdata && host->pdata->flags & MMC_SPI_USE_CD_GPIO) {
 		status = mmc_gpio_request_cd(mmc, host->pdata->cd_gpio,
-					     host->pdata->cd_debounce);
+					     host->pdata->cd_debounce, true);
 		if (status != 0)
 			goto fail_add_host;
 	}
diff --git a/drivers/mmc/host/mmci.c b/drivers/mmc/host/mmci.c
index e4d470704150..af059635e8d3 100644
--- a/drivers/mmc/host/mmci.c
+++ b/drivers/mmc/host/mmci.c
@@ -1660,7 +1660,7 @@ static int mmci_probe(struct amba_device *dev,
 
 	/* If DT, cd/wp gpios must be supplied through it. */
 	if (!np && gpio_is_valid(plat->gpio_cd)) {
-		ret = mmc_gpio_request_cd(mmc, plat->gpio_cd, 0);
+		ret = mmc_gpio_request_cd(mmc, plat->gpio_cd, 0, false);
 		if (ret)
 			goto clk_disable;
 	}
diff --git a/drivers/mmc/host/mvsdio.c b/drivers/mmc/host/mvsdio.c
index 6b4c5ad3b393..ab08be46f52f 100644
--- a/drivers/mmc/host/mvsdio.c
+++ b/drivers/mmc/host/mvsdio.c
@@ -772,7 +772,7 @@ static int mvsd_probe(struct platform_device *pdev)
 		    gpio_is_valid(mvsd_data->gpio_card_detect)) {
 			ret = mmc_gpio_request_cd(mmc,
 						  mvsd_data->gpio_card_detect,
-						  0);
+						  0, false);
 			if (ret)
 				goto out;
 		} else {
diff --git a/drivers/mmc/host/sdhci-esdhc-imx.c b/drivers/mmc/host/sdhci-esdhc-imx.c
index ccec0e32590f..311d67b3e10c 100644
--- a/drivers/mmc/host/sdhci-esdhc-imx.c
+++ b/drivers/mmc/host/sdhci-esdhc-imx.c
@@ -1068,7 +1068,8 @@ static int sdhci_esdhc_imx_probe(struct platform_device *pdev)
 	/* card_detect */
 	switch (boarddata->cd_type) {
 	case ESDHC_CD_GPIO:
-		err = mmc_gpio_request_cd(host->mmc, boarddata->cd_gpio, 0);
+		err = mmc_gpio_request_cd(host->mmc, boarddata->cd_gpio, 0,
+					  false);
 		if (err) {
 			dev_err(mmc_dev(host->mmc),
 				"failed to request card-detect gpio!\n");
diff --git a/drivers/mmc/host/sdhci-pxav3.c b/drivers/mmc/host/sdhci-pxav3.c
index 6f842fb8e6b8..007af74225eb 100644
--- a/drivers/mmc/host/sdhci-pxav3.c
+++ b/drivers/mmc/host/sdhci-pxav3.c
@@ -347,7 +347,7 @@ static int sdhci_pxav3_probe(struct platform_device *pdev)
 
 		if (gpio_is_valid(pdata->ext_cd_gpio)) {
 			ret = mmc_gpio_request_cd(host->mmc, pdata->ext_cd_gpio,
-						  0);
+						  0, false);
 			if (ret) {
 				dev_err(mmc_dev(host->mmc),
 					"failed to allocate card detect gpio\n");
diff --git a/drivers/mmc/host/sdhci-sirf.c b/drivers/mmc/host/sdhci-sirf.c
index 17004531d089..8e01592007be 100644
--- a/drivers/mmc/host/sdhci-sirf.c
+++ b/drivers/mmc/host/sdhci-sirf.c
@@ -88,7 +88,7 @@ static int sdhci_sirf_probe(struct platform_device *pdev)
 	 * gets setup in sdhci_add_host() and we oops.
 	 */
 	if (gpio_is_valid(priv->gpio_cd)) {
-		ret = mmc_gpio_request_cd(host->mmc, priv->gpio_cd, 0);
+		ret = mmc_gpio_request_cd(host->mmc, priv->gpio_cd, 0, true);
 		if (ret) {
 			dev_err(&pdev->dev, "card detect irq request failed: %d\n",
 				ret);
diff --git a/drivers/mmc/host/sdhci-spear.c b/drivers/mmc/host/sdhci-spear.c
index 9d535c7336ef..e48372529ef7 100644
--- a/drivers/mmc/host/sdhci-spear.c
+++ b/drivers/mmc/host/sdhci-spear.c
@@ -141,7 +141,8 @@ static int sdhci_probe(struct platform_device *pdev)
 	 */
 	if (sdhci->data && sdhci->data->card_int_gpio >= 0) {
 		ret = mmc_gpio_request_cd(host->mmc,
-					  sdhci->data->card_int_gpio, 0);
+					  sdhci->data->card_int_gpio, 0,
+					  false);
 		if (ret < 0) {
 			dev_dbg(&pdev->dev,
 				"failed to request card-detect gpio%d\n",
diff --git a/drivers/mmc/host/sh_mmcif.c b/drivers/mmc/host/sh_mmcif.c
index d11708c815d7..b02e90c52432 100644
--- a/drivers/mmc/host/sh_mmcif.c
+++ b/drivers/mmc/host/sh_mmcif.c
@@ -1464,7 +1464,7 @@ static int sh_mmcif_probe(struct platform_device *pdev)
 	}
 
 	if (pd && pd->use_cd_gpio) {
-		ret = mmc_gpio_request_cd(mmc, pd->cd_gpio, 0);
+		ret = mmc_gpio_request_cd(mmc, pd->cd_gpio, 0, false);
 		if (ret < 0)
 			goto err_clk;
 	}
diff --git a/drivers/mmc/host/tmio_mmc_pio.c b/drivers/mmc/host/tmio_mmc_pio.c
index faf0924e71cb..ce4d92a43d2c 100644
--- a/drivers/mmc/host/tmio_mmc_pio.c
+++ b/drivers/mmc/host/tmio_mmc_pio.c
@@ -1098,7 +1098,7 @@ int tmio_mmc_host_probe(struct tmio_mmc_host **host,
 	dev_pm_qos_expose_latency_limit(&pdev->dev, 100);
 
 	if (pdata->flags & TMIO_MMC_USE_GPIO_CD) {
-		ret = mmc_gpio_request_cd(mmc, pdata->cd_gpio, 0);
+		ret = mmc_gpio_request_cd(mmc, pdata->cd_gpio, 0, true);
 		if (ret < 0) {
 			tmio_mmc_host_remove(_host);
 			return ret;
diff --git a/include/linux/mmc/slot-gpio.h b/include/linux/mmc/slot-gpio.h
index d2433381e828..9b0893050cc7 100644
--- a/include/linux/mmc/slot-gpio.h
+++ b/include/linux/mmc/slot-gpio.h
@@ -19,7 +19,7 @@ void mmc_gpio_free_ro(struct mmc_host *host);
 
 int mmc_gpio_get_cd(struct mmc_host *host);
 int mmc_gpio_request_cd(struct mmc_host *host, unsigned int gpio,
-			unsigned int debounce);
+			unsigned int debounce, bool request_irq);
 void mmc_gpio_free_cd(struct mmc_host *host);
 
 int mmc_gpiod_request_cd(struct mmc_host *host, const char *con_id,
-- 
1.9.1

