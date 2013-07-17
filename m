Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752722Ab3GQILW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 04:11:22 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:57854 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752029Ab3GQIKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 04:10:14 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.34 with qID r6H8A5e0029573, This message is accepted by code: ctloc85258
From: <wei_wang@realsil.com.cn>
To: <sameo@linux.intel.com>
CC: <devel@linuxdriverproject.org>, <linux-kernel@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <rogerable@realtek.com>,
        Wei WANG <wei_wang@realsil.com.cn>
Subject: [PATCH v2 5/5] mfd:rtsx: Configure to enter a deeper power-saving mode in S3
Date: Wed, 17 Jul 2013 16:09:55 +0800
Message-ID: <fddad89c1f95f7f0cf872d2850c59277ef870268.1373953200.git.wei_wang@realsil.com.cn>
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
index 2bff119..bfe65f6 100644
--- a/drivers/mfd/rtl8411.c
+++ b/drivers/mfd/rtl8411.c
@@ -86,7 +86,7 @@ static void rtl8411b_init_settings(struct rtsx_pcr *pcr)
 	}
 }
 
-static void rtl8411_force_power_down(struct rtsx_pcr *pcr)
+static void rtl8411_force_power_down(struct rtsx_pcr *pcr, u8 pm_state)
 {
 	rtsx_pci_write_register(pcr, FPDCTL, 0x07, 0x07);
 }
diff --git a/drivers/mfd/rts5209.c b/drivers/mfd/rts5209.c
index e2ee30e..a5261f9 100644
--- a/drivers/mfd/rts5209.c
+++ b/drivers/mfd/rts5209.c
@@ -58,7 +58,7 @@ static void rts5209_init_settings(struct rtsx_pcr *pcr)
 	}
 }
 
-static void rts5209_force_power_down(struct rtsx_pcr *pcr)
+static void rts5209_force_power_down(struct rtsx_pcr *pcr, u8 pm_state)
 {
 	rtsx_pci_write_register(pcr, FPDCTL, 0x07, 0x07);
 }
diff --git a/drivers/mfd/rts5227.c b/drivers/mfd/rts5227.c
index c931018..4c7309c 100644
--- a/drivers/mfd/rts5227.c
+++ b/drivers/mfd/rts5227.c
@@ -82,13 +82,16 @@ static void rts5227_init_settings(struct rtsx_pcr *pcr)
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
 
@@ -122,6 +125,7 @@ static int rts5227_extra_init_hw(struct rtsx_pcr *pcr)
 	else
 		rtsx_pci_add_cmd(pcr, WRITE_REG_CMD,
 				AUTOLOAD_CFG_BASE + 3, 0xB8, 0x88);
+	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, PM_CTRL3, 0x10, 0x00);
 
 	return rtsx_pci_send_cmd(pcr, 100);
 }
diff --git a/drivers/mfd/rts5229.c b/drivers/mfd/rts5229.c
index a91462d..e8e34de 100644
--- a/drivers/mfd/rts5229.c
+++ b/drivers/mfd/rts5229.c
@@ -55,7 +55,7 @@ static void rts5229_init_settings(struct rtsx_pcr *pcr)
 	}
 }
 
-static void rts5229_force_power_down(struct rtsx_pcr *pcr)
+static void rts5229_force_power_down(struct rtsx_pcr *pcr, u8 pm_state)
 {
 	rtsx_pci_write_register(pcr, FPDCTL, 0x03, 0x03);
 }
diff --git a/drivers/mfd/rts5249.c b/drivers/mfd/rts5249.c
index f18bb27..205344d 100644
--- a/drivers/mfd/rts5249.c
+++ b/drivers/mfd/rts5249.c
@@ -89,13 +89,16 @@ static void rts5249_init_settings(struct rtsx_pcr *pcr)
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
 
@@ -120,6 +123,7 @@ static int rts5249_extra_init_hw(struct rtsx_pcr *pcr)
 	else
 		rtsx_pci_add_cmd(pcr, WRITE_REG_CMD,
 				AUTOLOAD_CFG_BASE + 3, 0xB0, 0x80);
+	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, PM_CTRL3, 0x10, 0x00);
 
 	return rtsx_pci_send_cmd(pcr, 100);
 }
diff --git a/drivers/mfd/rtsx_pcr.c b/drivers/mfd/rtsx_pcr.c
index 13e1c24..1d7cc2e 100644
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
index 9763859..8deabc8 100644
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

