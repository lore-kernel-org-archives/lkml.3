Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752227Ab3HTGTL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 02:19:11 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:48318 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071Ab3HTGTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 02:19:10 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.34 with qID r7K6J0os020188, This message is accepted by code: ctloc85258
From: <wei_wang@realsil.com.cn>
To: <sameo@linux.intel.com>
CC: <devel@linuxdriverproject.org>, <linux-kernel@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <rogerable@realtek.com>,
        Wei WANG <wei_wang@realsil.com.cn>
Subject: [PATCH v3 2/6] mfd:rtsx: Add shutdown callback in rtsx_pci_driver
Date: Tue, 20 Aug 2013 14:18:52 +0800
Message-ID: <635eab9619e6588c0c2da3dd1ba6b7cd6b030b5e.1376978825.git.wei_wang@realsil.com.cn>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1376978825.git.wei_wang@realsil.com.cn>
References: <cover.1376978825.git.wei_wang@realsil.com.cn>
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
 include/linux/mfd/rtsx_pci.h |   13 +++++++++++--
 7 files changed, 85 insertions(+), 12 deletions(-)

diff --git a/drivers/mfd/rtl8411.c b/drivers/mfd/rtl8411.c
index 5a68c9b..56cc248 100644
--- a/drivers/mfd/rtl8411.c
+++ b/drivers/mfd/rtl8411.c
@@ -86,6 +86,11 @@ static void rtl8411b_fetch_vendor_settings(struct rtsx_pcr *pcr)
 		map_sd_drive(rtl8411b_reg_to_sd30_drive_sel_3v3(reg));
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
index 2170449..c67935e 100644
--- a/drivers/mfd/rts5209.c
+++ b/drivers/mfd/rts5209.c
@@ -59,6 +59,11 @@ static void rts5209_fetch_vendor_settings(struct rtsx_pcr *pcr)
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
@@ -197,6 +202,7 @@ static const struct pcr_ops rts5209_pcr_ops = {
 	.switch_output_voltage = rts5209_switch_output_voltage,
 	.cd_deglitch = NULL,
 	.conv_clk_and_div_n = NULL,
+	.force_power_down = rts5209_force_power_down,
 };
 
 /* SD Pull Control Enable:
diff --git a/drivers/mfd/rts5227.c b/drivers/mfd/rts5227.c
index c3181d7..42ebf5c 100644
--- a/drivers/mfd/rts5227.c
+++ b/drivers/mfd/rts5227.c
@@ -83,6 +83,16 @@ static void rts5227_fetch_vendor_settings(struct rtsx_pcr *pcr)
 		pcr->flags |= PCR_REVERSE_SOCKET;
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
@@ -218,6 +228,7 @@ static const struct pcr_ops rts5227_pcr_ops = {
 	.switch_output_voltage = rts5227_switch_output_voltage,
 	.cd_deglitch = NULL,
 	.conv_clk_and_div_n = NULL,
+	.force_power_down = rts5227_force_power_down,
 };
 
 /* SD Pull Control Enable:
diff --git a/drivers/mfd/rts5229.c b/drivers/mfd/rts5229.c
index 7a1ad6d..a0b695a 100644
--- a/drivers/mfd/rts5229.c
+++ b/drivers/mfd/rts5229.c
@@ -56,6 +56,11 @@ static void rts5229_fetch_vendor_settings(struct rtsx_pcr *pcr)
 		map_sd_drive(rtsx_reg_to_sd30_drive_sel_3v3(reg));
 }
 
+static void rts5229_force_power_down(struct rtsx_pcr *pcr)
+{
+	rtsx_pci_write_register(pcr, FPDCTL, 0x03, 0x03);
+}
+
 static int rts5229_extra_init_hw(struct rtsx_pcr *pcr)
 {
 	rtsx_pci_init_cmd(pcr);
@@ -179,6 +184,7 @@ static const struct pcr_ops rts5229_pcr_ops = {
 	.switch_output_voltage = rts5229_switch_output_voltage,
 	.cd_deglitch = NULL,
 	.conv_clk_and_div_n = NULL,
+	.force_power_down = rts5229_force_power_down,
 };
 
 /* SD Pull Control Enable:
diff --git a/drivers/mfd/rts5249.c b/drivers/mfd/rts5249.c
index d5db182..79ff212 100644
--- a/drivers/mfd/rts5249.c
+++ b/drivers/mfd/rts5249.c
@@ -88,6 +88,16 @@ static void rts5249_fetch_vendor_settings(struct rtsx_pcr *pcr)
 		pcr->flags |= PCR_REVERSE_SOCKET;
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
@@ -217,6 +227,7 @@ static const struct pcr_ops rts5249_pcr_ops = {
 	.card_power_on = rts5249_card_power_on,
 	.card_power_off = rts5249_card_power_off,
 	.switch_output_voltage = rts5249_switch_output_voltage,
+	.force_power_down = rts5249_force_power_down,
 };
 
 /* SD Pull Control Enable:
diff --git a/drivers/mfd/rtsx_pcr.c b/drivers/mfd/rtsx_pcr.c
index e06d6b0..97526f1 100644
--- a/drivers/mfd/rtsx_pcr.c
+++ b/drivers/mfd/rtsx_pcr.c
@@ -927,6 +927,21 @@ static void rtsx_pci_idle_work(struct work_struct *work)
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
@@ -1255,7 +1270,6 @@ static int rtsx_pci_suspend(struct pci_dev *pcidev, pm_message_t state)
 {
 	struct pcr_handle *handle;
 	struct rtsx_pcr *pcr;
-	int ret = 0;
 
 	dev_dbg(&(pcidev->dev), "--> %s\n", __func__);
 
@@ -1267,14 +1281,7 @@ static int rtsx_pci_suspend(struct pci_dev *pcidev, pm_message_t state)
 
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
@@ -1282,7 +1289,7 @@ static int rtsx_pci_suspend(struct pci_dev *pcidev, pm_message_t state)
 	pci_set_power_state(pcidev, pci_choose_state(pcidev, state));
 
 	mutex_unlock(&pcr->pcr_mutex);
-	return ret;
+	return 0;
 }
 
 static int rtsx_pci_resume(struct pci_dev *pcidev)
@@ -1320,10 +1327,25 @@ out:
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
 
@@ -1334,6 +1356,7 @@ static struct pci_driver rtsx_pci_driver = {
 	.remove = rtsx_pci_remove,
 	.suspend = rtsx_pci_suspend,
 	.resume = rtsx_pci_resume,
+	.shutdown = rtsx_pci_shutdown,
 };
 module_pci_driver(rtsx_pci_driver);
 
diff --git a/include/linux/mfd/rtsx_pci.h b/include/linux/mfd/rtsx_pci.h
index 9cba737..11ab786 100644
--- a/include/linux/mfd/rtsx_pci.h
+++ b/include/linux/mfd/rtsx_pci.h
@@ -25,8 +25,7 @@
 
 #include <linux/sched.h>
 #include <linux/pci.h>
-
-#include "rtsx_common.h"
+#include <linux/mfd/rtsx_common.h>
 
 #define MAX_RW_REG_CNT			1024
 
@@ -536,6 +535,10 @@
 #define SAMPLE_VAR_CLK0			(0x01 << 4)
 #define SAMPLE_VAR_CLK1			(0x02 << 4)
 
+/* HOST_SLEEP_STATE */
+#define HOST_ENTER_S1			1
+#define HOST_ENTER_S3			2
+
 #define MS_CFG				0xFD40
 #define MS_TPC				0xFD41
 #define MS_TRANS_CFG			0xFD42
@@ -701,6 +704,11 @@
 
 #define AUTOLOAD_CFG_BASE		0xFF00
 
+#define PM_CTRL1			0xFF44
+#define PM_CTRL2			0xFF45
+#define PM_CTRL3			0xFF46
+#define PM_CTRL4			0xFF47
+
 /* Memory mapping */
 #define SRAM_BASE			0xE600
 #define RBUF_BASE			0xF400
@@ -770,6 +778,7 @@ struct pcr_ops {
 	unsigned int	(*cd_deglitch)(struct rtsx_pcr *pcr);
 	int		(*conv_clk_and_div_n)(int clk, int dir);
 	void		(*fetch_vendor_settings)(struct rtsx_pcr *pcr);
+	void		(*force_power_down)(struct rtsx_pcr *pcr);
 };
 
 enum PDEV_STAT  {PDEV_STAT_IDLE, PDEV_STAT_RUN};
-- 
1.7.9.5

