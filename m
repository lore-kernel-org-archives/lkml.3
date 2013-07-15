Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754267Ab3GOHI6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 03:08:58 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:49471 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754160Ab3GOHH6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 03:07:58 -0400
X-Greylist: delayed 671 seconds by postgrey-1.27 at vger.kernel.org; Mon, 15 Jul 2013 03:07:51 EDT
X-SpamFilter-By: BOX Solutions SpamTrap 5.34 with qID r6F6uP1I017605, This message is accepted by code: ctloc85258
From: <wei_wang@realsil.com.cn>
To: <sameo@linux.intel.com>
CC: <devel@linuxdriverproject.org>, <linux-kernel@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <rogerable@realtek.com>,
        <adam.lee@canonical.com>, Wei WANG <wei_wang@realsil.com.cn>
Subject: [PATCH 5/5] mfd:rtsx: Configure to enter a deeper power-saving mode in S3
Date: Mon, 15 Jul 2013 14:56:14 +0800
Message-ID: <be9c5c69b407039de185acaaf58cdc4011c5a71a.1373871138.git.wei_wang@realsil.com.cn>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1373871135.git.wei_wang@realsil.com.cn>
References: <cover.1373871135.git.wei_wang@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.29.41.8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei WANG <wei_wang@realsil.com.cn>

Set a bit to enable rts5227 and rts5249 to enter a deeper internal
power-saving mode in S3, and recover it after resuming.

Signed-off-by: Wei WANG <wei_wang@realsil.com.cn>
---
 drivers/mfd/rtl8411.c        |    2 +-
 drivers/mfd/rts5209.c        |    2 +-
 drivers/mfd/rts5227.c        |    6 +++++-
 drivers/mfd/rts5229.c        |    2 +-
 drivers/mfd/rts5249.c        |    6 +++++-
 drivers/mfd/rtsx_pcr.c       |    2 +-
 include/linux/mfd/rtsx_pci.h |    5 ++---
 7 files changed, 16 insertions(+), 9 deletions(-)

diff --git a/drivers/mfd/rtl8411.c b/drivers/mfd/rtl8411.c
index dd3981a..7af3f63 100644
--- a/drivers/mfd/rtl8411.c
+++ b/drivers/mfd/rtl8411.c
@@ -82,7 +82,7 @@ static void rtl8411b_init_settings(struct rtsx_pcr *pcr)
 	}
 }
 
-static void rtl8411_force_power_down(struct rtsx_pcr *pcr)
+static void rtl8411_force_power_down(struct rtsx_pcr *pcr, u8 pm_state)
 {
 	rtsx_pci_write_register(pcr, FPDCTL, 0x07, 0x07);
 }
diff --git a/drivers/mfd/rts5209.c b/drivers/mfd/rts5209.c
index eed8b18..a07c6ff 100644
--- a/drivers/mfd/rts5209.c
+++ b/drivers/mfd/rts5209.c
@@ -56,7 +56,7 @@ static void rts5209_init_settings(struct rtsx_pcr *pcr)
 	}
 }
 
-static void rts5209_force_power_down(struct rtsx_pcr *pcr)
+static void rts5209_force_power_down(struct rtsx_pcr *pcr, u8 pm_state)
 {
 	rtsx_pci_write_register(pcr, FPDCTL, 0x07, 0x07);
 }
diff --git a/drivers/mfd/rts5227.c b/drivers/mfd/rts5227.c
index fa4bf80..e6ef305 100644
--- a/drivers/mfd/rts5227.c
+++ b/drivers/mfd/rts5227.c
@@ -80,13 +80,16 @@ static void rts5227_init_settings(struct rtsx_pcr *pcr)
 	}
 }
 
-static void rts5227_force_power_down(struct rtsx_pcr *pcr)
+static void rts5227_force_power_down(struct rtsx_pcr *pcr, u8 pm_state)
 {
 	/* Set relink_time to 0 */
 	rtsx_pci_write_register(pcr, AUTOLOAD_CFG_BASE + 1, 0xFF, 0);
 	rtsx_pci_write_register(pcr, AUTOLOAD_CFG_BASE + 2, 0xFF, 0);
 	rtsx_pci_write_register(pcr, AUTOLOAD_CFG_BASE + 3, 0x01, 0);
 
+	if (pm_state == HOST_ENTER_S3)
+		rtsx_pci_write_register(pcr, PM_CTRL3, 0x10, 0x10);
+
 	rtsx_pci_write_register(pcr, FPDCTL, 0x03, 0x03);
 }
 
@@ -120,6 +123,7 @@ static int rts5227_extra_init_hw(struct rtsx_pcr *pcr)
 	else
 		rtsx_pci_add_cmd(pcr, WRITE_REG_CMD,
 				AUTOLOAD_CFG_BASE + 3, 0xB8, 0x88);
+	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, PM_CTRL3, 0x10, 0x00);
 
 	return rtsx_pci_send_cmd(pcr, 100);
 }
diff --git a/drivers/mfd/rts5229.c b/drivers/mfd/rts5229.c
index 549a1bd..b2bdc91 100644
--- a/drivers/mfd/rts5229.c
+++ b/drivers/mfd/rts5229.c
@@ -53,7 +53,7 @@ static void rts5229_init_settings(struct rtsx_pcr *pcr)
 	}
 }
 
-static void rts5229_force_power_down(struct rtsx_pcr *pcr)
+static void rts5229_force_power_down(struct rtsx_pcr *pcr, u8 pm_state)
 {
 	rtsx_pci_write_register(pcr, FPDCTL, 0x03, 0x03);
 }
diff --git a/drivers/mfd/rts5249.c b/drivers/mfd/rts5249.c
index 3bf9296..1db034c 100644
--- a/drivers/mfd/rts5249.c
+++ b/drivers/mfd/rts5249.c
@@ -87,13 +87,16 @@ static void rts5249_init_settings(struct rtsx_pcr *pcr)
 	}
 }
 
-static void rts5249_force_power_down(struct rtsx_pcr *pcr)
+static void rts5249_force_power_down(struct rtsx_pcr *pcr, u8 pm_state)
 {
 	/* Set relink_time to 0 */
 	rtsx_pci_write_register(pcr, AUTOLOAD_CFG_BASE + 1, 0xFF, 0);
 	rtsx_pci_write_register(pcr, AUTOLOAD_CFG_BASE + 2, 0xFF, 0);
 	rtsx_pci_write_register(pcr, AUTOLOAD_CFG_BASE + 3, 0x01, 0);
 
+	if (pm_state == HOST_ENTER_S3)
+		rtsx_pci_write_register(pcr, PM_CTRL3, 0x10, 0x10);
+
 	rtsx_pci_write_register(pcr, FPDCTL, 0x03, 0x03);
 }
 
@@ -118,6 +121,7 @@ static int rts5249_extra_init_hw(struct rtsx_pcr *pcr)
 	else
 		rtsx_pci_add_cmd(pcr, WRITE_REG_CMD,
 				AUTOLOAD_CFG_BASE + 3, 0xB0, 0x80);
+	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, PM_CTRL3, 0x10, 0x00);
 
 	return rtsx_pci_send_cmd(pcr, 100);
 }
diff --git a/drivers/mfd/rtsx_pcr.c b/drivers/mfd/rtsx_pcr.c
index 0ae5996..dcbad1a 100644
--- a/drivers/mfd/rtsx_pcr.c
+++ b/drivers/mfd/rtsx_pcr.c
@@ -938,7 +938,7 @@ static void rtsx_pci_power_off(struct rtsx_pcr *pcr, u8 pm_state)
 	rtsx_pci_write_register(pcr, HOST_SLEEP_STATE, 0x03, pm_state);
 
 	if (pcr->ops->force_power_down)
-		pcr->ops->force_power_down(pcr);
+		pcr->ops->force_power_down(pcr, pm_state);
 }
 
 static int rtsx_pci_init_hw(struct rtsx_pcr *pcr)
diff --git a/include/linux/mfd/rtsx_pci.h b/include/linux/mfd/rtsx_pci.h
index c19044e..f0a7bfb 100644
--- a/include/linux/mfd/rtsx_pci.h
+++ b/include/linux/mfd/rtsx_pci.h
@@ -24,8 +24,7 @@
 
 #include <linux/sched.h>
 #include <linux/pci.h>
-
-#include "rtsx_common.h"
+#include <linux/mfd/rtsx_common.h>
 
 #define MAX_RW_REG_CNT			1024
 
@@ -764,7 +763,7 @@ struct pcr_ops {
 	unsigned int	(*cd_deglitch)(struct rtsx_pcr *pcr);
 	int		(*conv_clk_and_div_n)(int clk, int dir);
 	void		(*init_settings)(struct rtsx_pcr *pcr);
-	void		(*force_power_down)(struct rtsx_pcr *pcr);
+	void		(*force_power_down)(struct rtsx_pcr *pcr, u8 pm_state);
 };
 
 enum PDEV_STAT  {PDEV_STAT_IDLE, PDEV_STAT_RUN};
-- 
1.7.9.5

