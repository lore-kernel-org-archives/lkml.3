Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754817Ab3GJPmd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 11:42:33 -0400
Received: from mail-qa0-f74.google.com ([209.85.216.74]:41987 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754631Ab3GJPmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 11:42:16 -0400
From: Doug Anderson <dianders@chromium.org>
To: Chris Ball <cjb@laptop.org>
Cc: Olof Johansson <olof@lixom.net>, Jaehoon Chung <jh80.chung@samsung.com>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        James Hogan <james.hogan@imgtec.com>,
        Grant Grundler <grundler@chromium.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Abhilash Kesavan <a.kesavan@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Doug Anderson <dianders@chromium.org>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 2/5] mmc: dw_mmc: Add suspend_noirq/resume_noirq callbacks for dw_mmc-pltfm
Date: Wed, 10 Jul 2013 08:42:03 -0700
Message-Id: <1373470926-19314-3-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 1.8.3
In-Reply-To: <1373470926-19314-1-git-send-email-dianders@chromium.org>
References: <1373411961-23812-1-git-send-email-dianders@chromium.org>
 <1373470926-19314-1-git-send-email-dianders@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On some devices (like exynos5420) the dw_mmc controller may be in a
strange state after we wake up from sleep.  Add callbacks to allow for
dealing with these quirks.  We use the "_noirq" versions of the
callbacks since in the case of exynos5420 the strange state caused
interrupts to fire so we need to deal with it while interrupts are
still off.

At the moment this support is only added to dw_mmc-pltfm which calls
straight to the callback, since nobody but exynos needs it.  We can
add some levels of indirection (a call into the generic dw_mmc code)
when someone finds a need.

Signed-off-by: Doug Anderson <dianders@chromium.org>
Reviewed-by: James Hogan <james.hogan@imgtec.com>
---
Changes in v3:
- Add freeze/thaw and poweroff/restore noirq entries.

Changes in v2:
- Use suspend_noirq as per James Hogan.

 drivers/mmc/host/dw_mmc-pltfm.c | 41 ++++++++++++++++++++++++++++++++++++++---
 drivers/mmc/host/dw_mmc.h       |  4 ++++
 2 files changed, 42 insertions(+), 3 deletions(-)

diff --git a/drivers/mmc/host/dw_mmc-pltfm.c b/drivers/mmc/host/dw_mmc-pltfm.c
index 41c27b7..742ef76 100644
--- a/drivers/mmc/host/dw_mmc-pltfm.c
+++ b/drivers/mmc/host/dw_mmc-pltfm.c
@@ -105,12 +105,47 @@ static int dw_mci_pltfm_resume(struct device *dev)
 
 	return 0;
 }
+
+static int dw_mci_pltfm_suspend_noirq(struct device *dev)
+{
+	struct dw_mci *host = dev_get_drvdata(dev);
+	const struct dw_mci_drv_data *drv_data = host->drv_data;
+
+	if (drv_data && drv_data->suspend_noirq)
+		return drv_data->suspend_noirq(host);
+
+	return 0;
+}
+
+static int dw_mci_pltfm_resume_noirq(struct device *dev)
+{
+	struct dw_mci *host = dev_get_drvdata(dev);
+	const struct dw_mci_drv_data *drv_data = host->drv_data;
+
+	if (drv_data && drv_data->resume_noirq)
+		return drv_data->resume_noirq(host);
+
+	return 0;
+}
+
+
 #else
-#define dw_mci_pltfm_suspend	NULL
-#define dw_mci_pltfm_resume	NULL
+#define dw_mci_pltfm_suspend		NULL
+#define dw_mci_pltfm_resume		NULL
+#define dw_mci_pltfm_suspend_noirq	NULL
+#define dw_mci_pltfm_resume_noirq	NULL
 #endif /* CONFIG_PM_SLEEP */
 
-SIMPLE_DEV_PM_OPS(dw_mci_pltfm_pmops, dw_mci_pltfm_suspend, dw_mci_pltfm_resume);
+const struct dev_pm_ops dw_mci_pltfm_pmops = {
+	SET_SYSTEM_SLEEP_PM_OPS(dw_mci_pltfm_suspend, dw_mci_pltfm_resume)
+	.suspend_noirq = dw_mci_pltfm_suspend_noirq,
+	.resume_noirq = dw_mci_pltfm_resume_noirq,
+	.freeze_noirq = dw_mci_pltfm_suspend_noirq,
+	.thaw_noirq = dw_mci_pltfm_resume_noirq,
+	.poweroff_noirq = dw_mci_pltfm_suspend_noirq,
+	.restore_noirq = dw_mci_pltfm_resume_noirq,
+};
+
 EXPORT_SYMBOL_GPL(dw_mci_pltfm_pmops);
 
 static const struct of_device_id dw_mci_pltfm_match[] = {
diff --git a/drivers/mmc/host/dw_mmc.h b/drivers/mmc/host/dw_mmc.h
index 0b74189..5d0398f 100644
--- a/drivers/mmc/host/dw_mmc.h
+++ b/drivers/mmc/host/dw_mmc.h
@@ -190,6 +190,8 @@ extern int dw_mci_resume(struct dw_mci *host);
  * @prepare_command: handle CMD register extensions.
  * @set_ios: handle bus specific extensions.
  * @parse_dt: parse implementation specific device tree properties.
+ * @suspend_noirq: called late in the suspend process
+ * @resume_noirq: called early in the resume process
  *
  * Provide controller implementation specific extensions. The usage of this
  * data structure is fully optional and usage of each member in this structure
@@ -202,5 +204,7 @@ struct dw_mci_drv_data {
 	void		(*prepare_command)(struct dw_mci *host, u32 *cmdr);
 	void		(*set_ios)(struct dw_mci *host, struct mmc_ios *ios);
 	int		(*parse_dt)(struct dw_mci *host);
+	int		(*suspend_noirq)(struct dw_mci *host);
+	int		(*resume_noirq)(struct dw_mci *host);
 };
 #endif /* _DW_MMC_H_ */
-- 
1.8.3

