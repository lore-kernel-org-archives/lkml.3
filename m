Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754101AbbAUQou (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 11:44:50 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:37060 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753222AbbAUQoa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 11:44:30 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-23-54bfd6dbadf7
From: Karol Wrona <k.wrona@samsung.com>
To: Seungwon Jeon <tgih.jun@samsung.com>,
        Jaehoon Chung <jh80.chung@samsung.com>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Karol Wrona <wrona.vy@gmail.com>, Karol Wrona <k.wrona@samsung.com>
Subject: [RFC PATCH 1/1] mmc: dw_mmc: Add runtime pm to dw_mmc
Date: Wed, 21 Jan 2015 17:43:59 +0100
Message-id: <1421858639-14737-2-git-send-email-k.wrona@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1421858639-14737-1-git-send-email-k.wrona@samsung.com>
References: <1421858639-14737-1-git-send-email-k.wrona@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBJMWRmVeSWpSXmKPExsVy+t/xK7q3r+0PMXjXLmSxccZ6Vosbv9pY
	LU4t289kcbbpDbvF5V1z2CyO/O9ntPhw/yKzxfG14RZ71m1hcuD02DnrLrvHnWt72Dz6tqxi
	9Pi8SS6AJYrLJiU1J7MstUjfLoErY/Lz6IIlYRXzb21lb2DsdO9i5OSQEDCROPn8EiOELSZx
	4d56ti5GLg4hgaWMElvP3WCGcPqYJI60vGcHqWITUJdo3rEYLCEisJlR4uPBVewgDrPAGkaJ
	M2cngFUJC9hJ7F19EWwui4CqxLu+b2BxXgFnic19H4DiHED7FCTmTLIBMTkFXCQWTDYAMYWA
	Ks6s15nAyLuAkWEVo2hqaXJBcVJ6rqFecWJucWleul5yfu4mRkhofdnBuPiY1SFGAQ5GJR7e
	itD9IUKsiWXFlbmHGCU4mJVEeP0OAoV4UxIrq1KL8uOLSnNSiw8xMnFwSjUw5jtwvdwou6ex
	ZfXXGz0p/lWnm6ctLyx5L5avl63043FpnvDuvOXOLxgznkq6rGaNczwyx/jiNdvf9YyS7H/X
	fJedduubiOzBE4dkypLuPliqkM20hOHxose17y88mFDh5Xttl/DTLYsi9fK+zvp9/dvsedXn
	ll32ermY27XX0C9cVd2tVC3WQYmlOCPRUIu5qDgRAKKXTAYLAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds runtime pm handling to dw_mmc and enables it for dw_mmc-exynos.
It mainly uses mci_request/mci_request_end for mmc host state information.

Signed-off-by: Karol Wrona <k.wrona@samsung.com>
---
 drivers/mmc/host/dw_mmc-exynos.c |   69 ++++++++++++++++++++++++++++++++++++--
 drivers/mmc/host/dw_mmc.c        |   65 +++++++++++++++++++++++++++++++++--
 2 files changed, 130 insertions(+), 4 deletions(-)

diff --git a/drivers/mmc/host/dw_mmc-exynos.c b/drivers/mmc/host/dw_mmc-exynos.c
index 12a5eaa..7281c6f 100644
--- a/drivers/mmc/host/dw_mmc-exynos.c
+++ b/drivers/mmc/host/dw_mmc-exynos.c
@@ -17,12 +17,15 @@
 #include <linux/mmc/mmc.h>
 #include <linux/of.h>
 #include <linux/of_gpio.h>
+#include <linux/pm_runtime.h>
 #include <linux/slab.h>
 
 #include "dw_mmc.h"
 #include "dw_mmc-pltfm.h"
 #include "dw_mmc-exynos.h"
 
+#define DWMMC_AUTOSUSPEND_DELAY 200
+
 /* Variations in Exynos specific dw-mshc controller */
 enum dw_mci_exynos_type {
 	DW_MCI_TYPE_EXYNOS4210,
@@ -97,6 +100,30 @@ static int dw_mci_exynos_setup_clock(struct dw_mci *host)
 	return 0;
 }
 
+#ifdef CONFIG_PM
+static int dw_mci_exynos_runtime_suspend(struct device *dev)
+{
+	struct dw_mci *host = dev_get_drvdata(dev);
+
+	/* empty for now */
+
+	return 0;
+}
+
+static int dw_mci_exynos_runtime_resume(struct device *dev)
+{
+	struct dw_mci *host = dev_get_drvdata(dev);
+
+	/* empty for now */
+
+	return 0;
+}
+#else
+#define dw_mci_exynos_runtime_suspend		NULL
+#define dw_mci_exynos_runtime_resume		NULL
+
+#endif /* CONFIG_PM */
+
 #ifdef CONFIG_PM_SLEEP
 static int dw_mci_exynos_suspend(struct device *dev)
 {
@@ -179,6 +206,8 @@ static void dw_mci_exynos_set_ios(struct dw_mci *host, struct mmc_ios *ios)
 	unsigned long actual;
 	u8 div = priv->ciu_div + 1;
 
+	pm_runtime_get_sync(host->dev);
+
 	if (ios->timing == MMC_TIMING_MMC_DDR52) {
 		if (priv->ctrl_type == DW_MCI_TYPE_EXYNOS7 ||
 			priv->ctrl_type == DW_MCI_TYPE_EXYNOS7_SMU)
@@ -196,6 +225,9 @@ static void dw_mci_exynos_set_ios(struct dw_mci *host, struct mmc_ios *ios)
 			mci_writel(host, CLKSEL, priv->sdr_timing);
 	}
 
+	pm_runtime_mark_last_busy(host->dev);
+	pm_runtime_put_autosuspend(host->dev);
+
 	/*
 	 * Don't care if wanted clock is zero or
 	 * ciu clock is unavailable
@@ -405,16 +437,49 @@ MODULE_DEVICE_TABLE(of, dw_mci_exynos_match);
 
 static int dw_mci_exynos_probe(struct platform_device *pdev)
 {
+	int ret;
 	const struct dw_mci_drv_data *drv_data;
 	const struct of_device_id *match;
 
 	match = of_match_node(dw_mci_exynos_match, pdev->dev.of_node);
 	drv_data = match->data;
-	return dw_mci_pltfm_register(pdev, drv_data);
+	ret = dw_mci_pltfm_register(pdev, drv_data);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "register error\n");
+		goto err_pm_dis;
+	}
+
+	pm_runtime_enable(&pdev->dev);
+	pm_runtime_get_sync(&pdev->dev);
+	pm_runtime_set_autosuspend_delay(&pdev->dev, DWMMC_AUTOSUSPEND_DELAY);
+	pm_runtime_use_autosuspend(&pdev->dev);
+
+	pm_runtime_mark_last_busy(&pdev->dev);
+	pm_runtime_put_autosuspend(&pdev->dev);
+
+	return ret;
+
+err_pm_dis:
+	pm_runtime_disable(&pdev->dev);
+	return ret;
 }
 
+static int __exit dw_mci_exynos_remove(struct platform_device *pdev)
+{
+	pm_runtime_get_sync(&pdev->dev);
+
+	dw_mci_pltfm_remove(pdev);
+
+	pm_runtime_put_sync(&pdev->dev);
+	pm_runtime_disable(&pdev->dev);
+
+	return 0;
+
+}
 static const struct dev_pm_ops dw_mci_exynos_pmops = {
 	SET_SYSTEM_SLEEP_PM_OPS(dw_mci_exynos_suspend, dw_mci_exynos_resume)
+	SET_RUNTIME_PM_OPS(dw_mci_exynos_runtime_suspend,
+			dw_mci_exynos_runtime_resume, NULL)
 	.resume_noirq = dw_mci_exynos_resume_noirq,
 	.thaw_noirq = dw_mci_exynos_resume_noirq,
 	.restore_noirq = dw_mci_exynos_resume_noirq,
@@ -422,7 +487,7 @@ static const struct dev_pm_ops dw_mci_exynos_pmops = {
 
 static struct platform_driver dw_mci_exynos_pltfm_driver = {
 	.probe		= dw_mci_exynos_probe,
-	.remove		= __exit_p(dw_mci_pltfm_remove),
+	.remove		= __exit_p(dw_mci_exynos_remove),
 	.driver		= {
 		.name		= "dwmmc_exynos",
 		.of_match_table	= dw_mci_exynos_match,
diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
index 4d2e3c2..1e66d7b 100644
--- a/drivers/mmc/host/dw_mmc.c
+++ b/drivers/mmc/host/dw_mmc.c
@@ -38,6 +38,7 @@
 #include <linux/of.h>
 #include <linux/of_gpio.h>
 #include <linux/mmc/slot-gpio.h>
+#include <linux/pm_runtime.h>
 
 #include "dw_mmc.h"
 
@@ -112,6 +113,8 @@ static int dw_mci_req_show(struct seq_file *s, void *v)
 	struct mmc_command *stop;
 	struct mmc_data	*data;
 
+	pm_runtime_get_sync(slot->host->dev);
+
 	/* Make sure we get a consistent snapshot */
 	spin_lock_bh(&slot->host->lock);
 	mrq = slot->mrq;
@@ -141,6 +144,9 @@ static int dw_mci_req_show(struct seq_file *s, void *v)
 
 	spin_unlock_bh(&slot->host->lock);
 
+	pm_runtime_mark_last_busy(slot->host->dev);
+	pm_runtime_put_autosuspend(slot->host->dev);
+
 	return 0;
 }
 
@@ -1043,6 +1049,8 @@ static void dw_mci_request(struct mmc_host *mmc, struct mmc_request *mrq)
 
 	WARN_ON(slot->mrq);
 
+	pm_runtime_get_sync(host->dev);
+
 	/*
 	 * The check for card presence and queueing of the request must be
 	 * atomic, otherwise the card could be removed in between and the
@@ -1054,6 +1062,9 @@ static void dw_mci_request(struct mmc_host *mmc, struct mmc_request *mrq)
 		spin_unlock_bh(&host->lock);
 		mrq->cmd->error = -ENOMEDIUM;
 		mmc_request_done(mmc, mrq);
+
+		pm_runtime_mark_last_busy(host->dev);
+		pm_runtime_put_autosuspend(host->dev);
 		return;
 	}
 
@@ -1069,6 +1080,8 @@ static void dw_mci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 	u32 regs;
 	int ret;
 
+	pm_runtime_get_sync(slot->host->dev);
+
 	switch (ios->bus_width) {
 	case MMC_BUS_WIDTH_4:
 		slot->ctype = SDMMC_CTYPE_4BIT;
@@ -1116,7 +1129,7 @@ static void dw_mci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 				dev_err(slot->host->dev,
 					"failed to enable vmmc regulator\n");
 				/*return, if failed turn on vmmc*/
-				return;
+				goto _end;
 			}
 		}
 		set_bit(DW_MMC_CARD_NEED_INIT, &slot->flags);
@@ -1150,6 +1163,10 @@ static void dw_mci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 	default:
 		break;
 	}
+
+_end:
+	pm_runtime_mark_last_busy(slot->host->dev);
+	pm_runtime_put_autosuspend(slot->host->dev);
 }
 
 static int dw_mci_card_busy(struct mmc_host *mmc)
@@ -1157,12 +1174,17 @@ static int dw_mci_card_busy(struct mmc_host *mmc)
 	struct dw_mci_slot *slot = mmc_priv(mmc);
 	u32 status;
 
+	pm_runtime_get_sync(slot->host->dev);
+
 	/*
 	 * Check the busy bit which is low when DAT[3:0]
 	 * (the data lines) are 0000
 	 */
 	status = mci_readl(slot->host, STATUS);
 
+	pm_runtime_mark_last_busy(slot->host->dev);
+	pm_runtime_put_autosuspend(slot->host->dev);
+
 	return !!(status & SDMMC_STATUS_BUSY);
 }
 
@@ -1175,6 +1197,8 @@ static int dw_mci_switch_voltage(struct mmc_host *mmc, struct mmc_ios *ios)
 	int min_uv, max_uv;
 	int ret;
 
+	pm_runtime_get_sync(host->dev);
+
 	/*
 	 * Program the voltage.  Note that some instances of dw_mmc may use
 	 * the UHS_REG for this.  For other instances (like exynos) the UHS_REG
@@ -1202,6 +1226,9 @@ static int dw_mci_switch_voltage(struct mmc_host *mmc, struct mmc_ios *ios)
 	}
 	mci_writel(host, UHS_REG, uhs);
 
+	pm_runtime_mark_last_busy(host->dev);
+	pm_runtime_put_autosuspend(host->dev);
+
 	return 0;
 }
 
@@ -1211,6 +1238,8 @@ static int dw_mci_get_ro(struct mmc_host *mmc)
 	struct dw_mci_slot *slot = mmc_priv(mmc);
 	int gpio_ro = mmc_gpio_get_ro(mmc);
 
+	pm_runtime_get_sync(slot->host->dev);
+
 	/* Use platform get_ro function, else try on board write protect */
 	if ((slot->quirks & DW_MCI_SLOT_QUIRK_NO_WRITE_PROTECT) ||
 			(slot->host->quirks & DW_MCI_QUIRK_NO_WRITE_PROTECT))
@@ -1221,6 +1250,9 @@ static int dw_mci_get_ro(struct mmc_host *mmc)
 		read_only =
 			mci_readl(slot->host, WRTPRT) & (1 << slot->id) ? 1 : 0;
 
+	pm_runtime_mark_last_busy(slot->host->dev);
+	pm_runtime_put_autosuspend(slot->host->dev);
+
 	dev_dbg(&mmc->class_dev, "card is %s\n",
 		read_only ? "read-only" : "read-write");
 
@@ -1235,6 +1267,8 @@ static int dw_mci_get_cd(struct mmc_host *mmc)
 	struct dw_mci *host = slot->host;
 	int gpio_cd = mmc_gpio_get_cd(mmc);
 
+	pm_runtime_get_sync(host->dev);
+
 	/* Use platform get_cd function, else try onboard card detect */
 	if (brd->quirks & DW_MCI_QUIRK_BROKEN_CARD_DETECTION)
 		present = 1;
@@ -1254,6 +1288,9 @@ static int dw_mci_get_cd(struct mmc_host *mmc)
 	}
 	spin_unlock_bh(&host->lock);
 
+	pm_runtime_mark_last_busy(host->dev);
+	pm_runtime_put_autosuspend(host->dev);
+
 	return present;
 }
 
@@ -1262,6 +1299,8 @@ static void dw_mci_init_card(struct mmc_host *mmc, struct mmc_card *card)
 	struct dw_mci_slot *slot = mmc_priv(mmc);
 	struct dw_mci *host = slot->host;
 
+	pm_runtime_get_sync(host->dev);
+
 	/*
 	 * Low power mode will stop the card clock when idle.  According to the
 	 * description of the CLKENA register we should disable low power mode
@@ -1289,6 +1328,9 @@ static void dw_mci_init_card(struct mmc_host *mmc, struct mmc_card *card)
 				     SDMMC_CMD_PRV_DAT_WAIT, 0);
 		}
 	}
+
+	pm_runtime_mark_last_busy(host->dev);
+	pm_runtime_put_autosuspend(host->dev);
 }
 
 static void dw_mci_enable_sdio_irq(struct mmc_host *mmc, int enb)
@@ -1298,6 +1340,9 @@ static void dw_mci_enable_sdio_irq(struct mmc_host *mmc, int enb)
 	unsigned long irqflags;
 	u32 int_mask;
 
+	if (enb)
+		pm_runtime_get_sync(slot->host->dev);
+
 	spin_lock_irqsave(&host->irq_lock, irqflags);
 
 	/* Enable/disable Slot Specific SDIO interrupt */
@@ -1309,6 +1354,12 @@ static void dw_mci_enable_sdio_irq(struct mmc_host *mmc, int enb)
 	mci_writel(host, INTMASK, int_mask);
 
 	spin_unlock_irqrestore(&host->irq_lock, irqflags);
+
+	/* If interrupt is enabled leave device active. */
+	if (!enb) {
+		pm_runtime_mark_last_busy(slot->host->dev);
+		pm_runtime_put_autosuspend(slot->host->dev);
+	}
 }
 
 static int dw_mci_execute_tuning(struct mmc_host *mmc, u32 opcode)
@@ -1318,8 +1369,14 @@ static int dw_mci_execute_tuning(struct mmc_host *mmc, u32 opcode)
 	const struct dw_mci_drv_data *drv_data = host->drv_data;
 	int err = -ENOSYS;
 
+	pm_runtime_get_sync(host->dev);
+
 	if (drv_data && drv_data->execute_tuning)
 		err = drv_data->execute_tuning(slot);
+
+	pm_runtime_mark_last_busy(host->dev);
+	pm_runtime_put_autosuspend(host->dev);
+
 	return err;
 }
 
@@ -1361,8 +1418,12 @@ static void dw_mci_request_end(struct dw_mci *host, struct mmc_request *mrq)
 
 		if (host->state == STATE_SENDING_CMD11)
 			host->state = STATE_WAITING_CMD11_DONE;
-		else
+		else {
+			pm_runtime_mark_last_busy(host->dev);
+			pm_runtime_put_autosuspend(host->dev);
+
 			host->state = STATE_IDLE;
+		}
 	}
 
 	spin_unlock(&host->lock);
-- 
1.7.9.5

