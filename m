Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752894Ab3GQIL3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 04:11:29 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:57849 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969Ab3GQIKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 04:10:11 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.34 with qID r6H8A12D029361, This message is accepted by code: ctloc85258
From: <wei_wang@realsil.com.cn>
To: <sameo@linux.intel.com>
CC: <devel@linuxdriverproject.org>, <linux-kernel@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <rogerable@realtek.com>,
        Wei WANG <wei_wang@realsil.com.cn>
Subject: [PATCH v2 2/5] mfd:rtsx: Add shutdown callback in rtsx_pci_driver
Date: Wed, 17 Jul 2013 16:09:52 +0800
Message-ID: <d622c638fd9524899ee1d5ef01c3e9326b405888.1373953200.git.wei_wang@realsil.com.cn>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1373953200.git.wei_wang@realsil.com.cn>
References: <cover.1373953200.git.wei_wang@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.29.41.8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei WANG <wei_wang@realsil.com.cn>

Some actions to clear power state should be handled in .shutdown
callback in rtsx_pci_driver. This patch adopts the following measures to
catch this goal:
1. Add a function rtsx_pci_power_off to abstract the common ops in
.shutdown and .suspend
2. Add pcr->ops->force_power_down to fulfill the individual action for
each reader model

Signed-off-by: Wei WANG <wei_wang@realsil.com.cn>
---
 drivers/mfd/rtl8411.c        |    7 +++++++
 drivers/mfd/rts5209.c        |    6 ++++++
 drivers/mfd/rts5227.c        |   11 +++++++++++
 drivers/mfd/rts5229.c        |    6 ++++++
 drivers/mfd/rts5249.c        |   11 +++++++++++
 drivers/mfd/rtsx_pcr.c       |   43 ++++++++++++++++++++++++++++++++----------
 include/linux/mfd/rtsx_pci.h |   10 ++++++++++
 7 files changed, 84 insertions(+), 10 deletions(-)

diff --git a/drivers/mfd/rtl8411.c b/drivers/mfd/rtl8411.c
index 1fbb978..80c6fbc 100644
--- a/drivers/mfd/rtl8411.c
+++ b/drivers/mfd/rtl8411.c
@@ -86,6 +86,11 @@ static void rtl8411b_init_settings(struct rtsx_pcr *pcr)
 	}
 }
 
+static void rtl8411_force_power_down(struct rtsx_pcr *pcr)
+{
+	rtsx_pci_write_register(pcr, FPDCTL, 0x07, 0x07);
+}
+
 static int rtl8411_extra_init_hw(struct rtsx_pcr *pcr)
 {
 	rtsx_pci_init_cmd(pcr);
@@ -285,6 +290,7 @@ static const struct pcr_ops rtl8411_pcr_ops = {
 	.switch_output_voltage = rtl8411_switch_output_voltage,
 	.cd_deglitch = rtl8411_cd_deglitch,
 	.conv_clk_and_div_n = rtl8411_conv_clk_and_div_n,
+	.force_power_down = rtl8411_force_power_down,
 };
 
 static const struct pcr_ops rtl8411b_pcr_ops = {
@@ -300,6 +306,7 @@ static const struct pcr_ops rtl8411b_pcr_ops = {
 	.switch_output_voltage = rtl8411_switch_output_voltage,
 	.cd_deglitch = rtl8411_cd_deglitch,
 	.conv_clk_and_div_n = rtl8411_conv_clk_and_div_n,
+	.force_power_down = rtl8411_force_power_down,
 };
 
 /* SD Pull Control Enable:
diff --git a/drivers/mfd/rts5209.c b/drivers/mfd/rts5209.c
index 99e0ee2..524a5c5 100644
--- a/drivers/mfd/rts5209.c
+++ b/drivers/mfd/rts5209.c
@@ -58,6 +58,11 @@ static void rts5209_init_settings(struct rtsx_pcr *pcr)
 	}
 }
 
+static void rts5209_force_power_down(struct rtsx_pcr *pcr)
+{
+	rtsx_pci_write_register(pcr, FPDCTL, 0x07, 0x07);
+}
+
 static int rts5209_extra_init_hw(struct rtsx_pcr *pcr)
 {
 	rtsx_pci_init_cmd(pcr);
@@ -196,6 +201,7 @@ static const struct pcr_ops rts5209_pcr_ops = {
 	.switch_output_voltage = rts5209_switch_output_voltage,
 	.cd_deglitch = NULL,
 	.conv_clk_and_div_n = NULL,
+	.force_power_down = rts5209_force_power_down,
 };
 
 /* SD Pull Control Enable:
diff --git a/drivers/mfd/rts5227.c b/drivers/mfd/rts5227.c
index 6159f7a..fd95ab4 100644
--- a/drivers/mfd/rts5227.c
+++ b/drivers/mfd/rts5227.c
@@ -82,6 +82,16 @@ static void rts5227_init_settings(struct rtsx_pcr *pcr)
 	}
 }
 
+static void rts5227_force_power_down(struct rtsx_pcr *pcr)
+{
+	/* Set relink_time to 0 */
+	rtsx_pci_write_register(pcr, AUTOLOAD_CFG_BASE + 1, 0xFF, 0);
+	rtsx_pci_write_register(pcr, AUTOLOAD_CFG_BASE + 2, 0xFF, 0);
+	rtsx_pci_write_register(pcr, AUTOLOAD_CFG_BASE + 3, 0x01, 0);
+
+	rtsx_pci_write_register(pcr, FPDCTL, 0x03, 0x03);
+}
+
 static int rts5227_extra_init_hw(struct rtsx_pcr *pcr)
 {
 	u16 cap;
@@ -217,6 +227,7 @@ static const struct pcr_ops rts5227_pcr_ops = {
 	.switch_output_voltage = rts5227_switch_output_voltage,
 	.cd_deglitch = NULL,
 	.conv_clk_and_div_n = NULL,
+	.force_power_down = rts5227_force_power_down,
 };
 
 /* SD Pull Control Enable:
diff --git a/drivers/mfd/rts5229.c b/drivers/mfd/rts5229.c
index 9a3edfd..b283511 100644
--- a/drivers/mfd/rts5229.c
+++ b/drivers/mfd/rts5229.c
@@ -55,6 +55,11 @@ static void rts5229_init_settings(struct rtsx_pcr *pcr)
 	}
 }
 
+static void rts5229_force_power_down(struct rtsx_pcr *pcr)
+{
+	rtsx_pci_write_register(pcr, FPDCTL, 0x03, 0x03);
+}
+
 static int rts5229_extra_init_hw(struct rtsx_pcr *pcr)
 {
 	rtsx_pci_init_cmd(pcr);
@@ -178,6 +183,7 @@ static const struct pcr_ops rts5229_pcr_ops = {
 	.switch_output_voltage = rts5229_switch_output_voltage,
 	.cd_deglitch = NULL,
 	.conv_clk_and_div_n = NULL,
+	.force_power_down = rts5229_force_power_down,
 };
 
 /* SD Pull Control Enable:
diff --git a/drivers/mfd/rts5249.c b/drivers/mfd/rts5249.c
index 277b2dd..066d6ff 100644
--- a/drivers/mfd/rts5249.c
+++ b/drivers/mfd/rts5249.c
@@ -89,6 +89,16 @@ static void rts5249_init_settings(struct rtsx_pcr *pcr)
 	}
 }
 
+static void rts5249_force_power_down(struct rtsx_pcr *pcr)
+{
+	/* Set relink_time to 0 */
+	rtsx_pci_write_register(pcr, AUTOLOAD_CFG_BASE + 1, 0xFF, 0);
+	rtsx_pci_write_register(pcr, AUTOLOAD_CFG_BASE + 2, 0xFF, 0);
+	rtsx_pci_write_register(pcr, AUTOLOAD_CFG_BASE + 3, 0x01, 0);
+
+	rtsx_pci_write_register(pcr, FPDCTL, 0x03, 0x03);
+}
+
 static int rts5249_extra_init_hw(struct rtsx_pcr *pcr)
 {
 	rtsx_pci_init_cmd(pcr);
@@ -218,6 +228,7 @@ static const struct pcr_ops rts5249_pcr_ops = {
 	.card_power_on = rts5249_card_power_on,
 	.card_power_off = rts5249_card_power_off,
 	.switch_output_voltage = rts5249_switch_output_voltage,
+	.force_power_down = rts5249_force_power_down,
 };
 
 /* SD Pull Control Enable:
diff --git a/drivers/mfd/rtsx_pcr.c b/drivers/mfd/rtsx_pcr.c
index e81d6cf..a178173 100644
--- a/drivers/mfd/rtsx_pcr.c
+++ b/drivers/mfd/rtsx_pcr.c
@@ -926,6 +926,21 @@ static void rtsx_pci_idle_work(struct work_struct *work)
 	mutex_unlock(&pcr->pcr_mutex);
 }
 
+static void rtsx_pci_power_off(struct rtsx_pcr *pcr, u8 pm_state)
+{
+	if (pcr->ops->turn_off_led)
+		pcr->ops->turn_off_led(pcr);
+
+	rtsx_pci_writel(pcr, RTSX_BIER, 0);
+	pcr->bier = 0;
+
+	rtsx_pci_write_register(pcr, PETXCFG, 0x08, 0x08);
+	rtsx_pci_write_register(pcr, HOST_SLEEP_STATE, 0x03, pm_state);
+
+	if (pcr->ops->force_power_down)
+		pcr->ops->force_power_down(pcr);
+}
+
 static int rtsx_pci_init_hw(struct rtsx_pcr *pcr)
 {
 	int err;
@@ -1254,7 +1269,6 @@ static int rtsx_pci_suspend(struct pci_dev *pcidev, pm_message_t state)
 {
 	struct pcr_handle *handle;
 	struct rtsx_pcr *pcr;
-	int ret = 0;
 
 	dev_dbg(&(pcidev->dev), "--> %s\n", __func__);
 
@@ -1266,14 +1280,7 @@ static int rtsx_pci_suspend(struct pci_dev *pcidev, pm_message_t state)
 
 	mutex_lock(&pcr->pcr_mutex);
 
-	if (pcr->ops->turn_off_led)
-		pcr->ops->turn_off_led(pcr);
-
-	rtsx_pci_writel(pcr, RTSX_BIER, 0);
-	pcr->bier = 0;
-
-	rtsx_pci_write_register(pcr, PETXCFG, 0x08, 0x08);
-	rtsx_pci_write_register(pcr, HOST_SLEEP_STATE, 0x03, 0x02);
+	rtsx_pci_power_off(pcr, HOST_ENTER_S3);
 
 	pci_save_state(pcidev);
 	pci_enable_wake(pcidev, pci_choose_state(pcidev, state), 0);
@@ -1281,7 +1288,7 @@ static int rtsx_pci_suspend(struct pci_dev *pcidev, pm_message_t state)
 	pci_set_power_state(pcidev, pci_choose_state(pcidev, state));
 
 	mutex_unlock(&pcr->pcr_mutex);
-	return ret;
+	return 0;
 }
 
 static int rtsx_pci_resume(struct pci_dev *pcidev)
@@ -1319,10 +1326,25 @@ out:
 	return ret;
 }
 
+static void rtsx_pci_shutdown(struct pci_dev *pcidev)
+{
+	struct pcr_handle *handle;
+	struct rtsx_pcr *pcr;
+
+	dev_dbg(&(pcidev->dev), "--> %s\n", __func__);
+
+	handle = pci_get_drvdata(pcidev);
+	pcr = handle->pcr;
+	rtsx_pci_power_off(pcr, HOST_ENTER_S1);
+
+	pci_disable_device(pcidev);
+}
+
 #else /* CONFIG_PM */
 
 #define rtsx_pci_suspend NULL
 #define rtsx_pci_resume NULL
+#define rtsx_pci_shutdown NULL
 
 #endif /* CONFIG_PM */
 
@@ -1333,6 +1355,7 @@ static struct pci_driver rtsx_pci_driver = {
 	.remove = rtsx_pci_remove,
 	.suspend = rtsx_pci_suspend,
 	.resume = rtsx_pci_resume,
+	.shutdown = rtsx_pci_shutdown,
 };
 module_pci_driver(rtsx_pci_driver);
 
diff --git a/include/linux/mfd/rtsx_pci.h b/include/linux/mfd/rtsx_pci.h
index 9101c5f..41d10e9 100644
--- a/include/linux/mfd/rtsx_pci.h
+++ b/include/linux/mfd/rtsx_pci.h
@@ -520,6 +520,10 @@
 #define SAMPLE_VAR_CLK0			(0x01 << 4)
 #define SAMPLE_VAR_CLK1			(0x02 << 4)
 
+/* HOST_SLEEP_STATE */
+#define HOST_ENTER_S1			1
+#define HOST_ENTER_S3			2
+
 #define MS_CFG				0xFD40
 #define MS_TPC				0xFD41
 #define MS_TRANS_CFG			0xFD42
@@ -685,6 +689,11 @@
 
 #define AUTOLOAD_CFG_BASE		0xFF00
 
+#define PM_CTRL1			0xFF44
+#define PM_CTRL2			0xFF45
+#define PM_CTRL3			0xFF46
+#define PM_CTRL4			0xFF47
+
 /* Memory mapping */
 #define SRAM_BASE			0xE600
 #define RBUF_BASE			0xF400
@@ -754,6 +763,7 @@ struct pcr_ops {
 	unsigned int	(*cd_deglitch)(struct rtsx_pcr *pcr);
 	int		(*conv_clk_and_div_n)(int clk, int dir);
 	void		(*init_settings)(struct rtsx_pcr *pcr);
+	void		(*force_power_down)(struct rtsx_pcr *pcr);
 };
 
 enum PDEV_STAT  {PDEV_STAT_IDLE, PDEV_STAT_RUN};
-- 
1.7.9.5

