Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757353AbaKTOpM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 09:45:12 -0500
Received: from coldplug.net ([109.75.184.172]:46502 "EHLO
	external.coldplug.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754574AbaKTOpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 09:45:09 -0500
Message-ID: <546DFE83.8060900@coldplug.net>
Date: Thu, 20 Nov 2014 15:45:23 +0100
From: lautriv <lautriv@coldplug.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Alexey Charkov <alchark@gmail.com>
CC: Fabio Estevam <festevam@gmail.com>, Tony Prisk <linux@prisktech.co.nz>,
        Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mmc: wmt-sdmmc: fix unmatched release_mem_region
References: <1415567571-6144-1-git-send-email-alchark@gmail.com>	<CAOMZO5C+O4h=f=vtLTdBZktnfVWzfeLjOQG-oecxh_c9u-QMqA@mail.gmail.com>	<545FE821.5060107@coldplug.net> <CABjd4YxyUJi6RaGWicFeoJ7C27qhUFsAbq-nJTreACrt-voeYA@mail.gmail.com>
In-Reply-To: <CABjd4YxyUJi6RaGWicFeoJ7C27qhUFsAbq-nJTreACrt-voeYA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 From b0509e27e33326e6dccd67d8ebe67e2bdb0cfdde Mon Sep 17 00:00:00 2001
From: Helmut Stengele <lautriv@coldplug.net>
Date: Thu, 20 Nov 2014 15:27:40 +0100
Subject: [PATCH] mmc: wmt-sdmmc: fix unmatched release_mem_region

Current code calls release_mem_region upon module unload
without requesting the region first. This patch fixes it
by moving to a devres-based ioremap implementation, which
handles requesting and releasing memory region internally.

This also makes the error/unload paths a bit simpler.

Signed-off-by: Helmut Stengele <lautriv@coldplug.net>
---

This is a corrected patch based on the one Alexey sent for me.
I sent it already but since i'm not used to send something upstream
it was an attached file and obviously rejected.
Patch is tested on bare-metal ( wm8850 ) and works like suspected.

  drivers/mmc/host/wmt-sdmmc.c | 14 +++++---------
  1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/mmc/host/wmt-sdmmc.c b/drivers/mmc/host/wmt-sdmmc.c
index 54181b4..bcaa0cc 100644
--- a/drivers/mmc/host/wmt-sdmmc.c
+++ b/drivers/mmc/host/wmt-sdmmc.c
@@ -759,6 +759,7 @@ static int wmt_mci_probe(struct platform_device *pdev)
      const struct wmt_mci_caps *wmt_caps;
      int ret;
      int regular_irq, dma_irq;
+    struct resource *res;

      if (!of_id || !of_id->data) {
          dev_err(&pdev->dev, "Controller capabilities data missing\n");
@@ -813,10 +814,11 @@ static int wmt_mci_probe(struct platform_device *pdev)
      if (of_get_property(np, "cd-inverted", NULL))
          priv->cd_inverted = 1;

-    priv->sdmmc_base = of_iomap(np, 0);
+    res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+    priv->sdmmc_base = devm_ioremap_resource(&pdev->dev, res);
      if (!priv->sdmmc_base) {
          dev_err(&pdev->dev, "Failed to map IO space\n");
-        ret = -ENOMEM;
+        ret = PTR_ERR(priv->sdmmc_base);
          goto fail2;
      }

@@ -826,7 +828,7 @@ static int wmt_mci_probe(struct platform_device *pdev)
      ret = request_irq(regular_irq, wmt_mci_regular_isr, 0, "sdmmc", priv);
      if (ret) {
          dev_err(&pdev->dev, "Register regular IRQ fail\n");
-        goto fail3;
+        goto fail2;
      }

      ret = request_irq(dma_irq, wmt_mci_dma_isr, 0, "sdmmc", priv);
@@ -869,8 +871,6 @@ fail5:
      free_irq(dma_irq, priv);
  fail4:
      free_irq(regular_irq, priv);
-fail3:
-    iounmap(priv->sdmmc_base);
  fail2:
      mmc_free_host(mmc);
  fail1:
@@ -881,7 +881,6 @@ static int wmt_mci_remove(struct platform_device *pdev)
  {
      struct mmc_host *mmc;
      struct wmt_mci_priv *priv;
-    struct resource *res;
      u32 reg_tmp;

      mmc = platform_get_drvdata(pdev);
@@ -909,9 +908,6 @@ static int wmt_mci_remove(struct platform_device *pdev)
      clk_disable_unprepare(priv->clk_sdmmc);
      clk_put(priv->clk_sdmmc);

-    res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-    release_mem_region(res->start, resource_size(res));
-
      mmc_free_host(mmc);

      dev_info(&pdev->dev, "WMT MCI device removed\n");
-- 
2.1.3


