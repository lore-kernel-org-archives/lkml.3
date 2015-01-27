Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758534AbbA0MYR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 07:24:17 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35422 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758673AbbA0MT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 07:19:58 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 110/126] mmc: sdhci-pxav3: do the mbus window configuration after enabling clocks
Date: Tue, 27 Jan 2015 12:16:55 +0000
Message-Id: <1422361031-19364-111-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
References: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>

commit aa8165f914420f143476305a01894b017d3abe6b upstream.

In commit 5491ce3f79ee ("mmc: sdhci-pxav3: add support for the Armada
38x SDHCI controller"), the sdhci-pxav3 driver was extended to include
support for the SDHCI controller found in the Armada 38x
processor. This mainly involved adding some MBus window related
configuration.

However, this configuration is currently done too early in ->probe():
it is done before clocks are enabled, while this configuration
involves touching the registers of the controller, which will hang the
SoC if the clock is disabled. It wasn't noticed until now because the
bootloader typically leaves gatable clocks enabled, but in situations
where we have a deferred probe (due to a CD GPIO that cannot be taken,
for example), then the probe will be re-tried later, after a clock
disable has been done in the exit path of the failed probe attempt of
the device. This second probe() will hang the system due to the clock
being disabled.

This can for example be produced on Armada 385 GP, which has a CD GPIO
connected to an I2C PCA9555. If the driver for the PCA9555 is not
compiled into the kernel, then we will have the following sequence of
events:

  1. The SDHCI probes
  2. It does the MBus configuration (which works, because the clock is
     left enabled by the bootloader)
  3. It enables the clock
  4. It tries to get the CD GPIO, which fails due to the driver being
     missing, so -EPROBE_DEFER is returned.
  5. Before returning -EPROBE_DEFER, the driver cleans up what was
     done, which includes disabling the clock.
  6. Later on, the SDHCI probe is tried again.
  7. It does the MBus configuration, which hangs because the clock is
     no longer enabled.

This commit does the obvious fix of doing the MBus configuration after
the clock has been enabled by the driver.

Fixes: 5491ce3f79ee ("mmc: sdhci-pxav3: add support for the Armada 38x SDHCI controller")
Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
[ luis: backported to 3.16: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/mmc/host/sdhci-pxav3.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/mmc/host/sdhci-pxav3.c b/drivers/mmc/host/sdhci-pxav3.c
index 6675be324cbc..bdfdf5273252 100644
--- a/drivers/mmc/host/sdhci-pxav3.c
+++ b/drivers/mmc/host/sdhci-pxav3.c
@@ -297,13 +297,6 @@ static int sdhci_pxav3_probe(struct platform_device *pdev)
 		return PTR_ERR(host);
 	}
 
-	if (of_device_is_compatible(np, "marvell,armada-380-sdhci")) {
-		ret = mv_conf_mbus_windows(pdev, mv_mbus_dram_info());
-		if (ret < 0)
-			goto err_mbus_win;
-	}
-
-
 	pltfm_host = sdhci_priv(host);
 	pltfm_host->priv = pxa;
 
@@ -316,6 +309,12 @@ static int sdhci_pxav3_probe(struct platform_device *pdev)
 	pltfm_host->clk = clk;
 	clk_prepare_enable(clk);
 
+	if (of_device_is_compatible(np, "marvell,armada-380-sdhci")) {
+		ret = mv_conf_mbus_windows(pdev, mv_mbus_dram_info());
+		if (ret < 0)
+			goto err_mbus_win;
+	}
+
 	/* enable 1/8V DDR capable */
 	host->mmc->caps |= MMC_CAP_1_8V_DDR;
 
@@ -387,10 +386,10 @@ err_add_host:
 	pm_runtime_disable(&pdev->dev);
 err_of_parse:
 err_cd_req:
+err_mbus_win:
 	clk_disable_unprepare(clk);
 	clk_put(clk);
 err_clk_get:
-err_mbus_win:
 	sdhci_pltfm_free(pdev);
 	kfree(pxa);
 	return ret;
-- 
2.1.4

