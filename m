Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753867AbbAZLWD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 06:22:03 -0500
Received: from regular1.263xmail.com ([211.150.99.140]:43774 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752855AbbAZLVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 06:21:54 -0500
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-ADDR-CHECKED: 0
X-RL-SENDER: addy.ke@rock-chips.com
X-SENDER-IP: 58.22.7.114
X-LOGIN-NAME: addy.ke@rock-chips.com
X-UNIQUE-TAG: <ca71b927cf9d624ecb663bf26ac6d044>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
From: Addy Ke <addy.ke@rock-chips.com>
To: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        rdunlap@infradead.org, tgih.jun@samsung.com, jh80.chung@samsung.com,
        chris@printf.net, ulf.hansson@linaro.org, dinguyen@altera.com,
        heiko@sntech.de, olof@lixom.net, dianders@chromium.org,
        sonnyrao@chromium.org, amstan@chromium.org
Cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, zhenfu.fang@rock-chips.com,
        cf@rock-chips.com, lintao@rock-chips.com, chenfen@rock-chips.com,
        zyf@rock-chips.com, xjq@rock-chips.com, huangtao@rock-chips.com,
        zyw@rock-chips.com, yzq@rock-chips.com, hj@rock-chips.com,
        kever.yang@rock-chips.com, zhangqing@rock-chips.com, hl@rock-chips.com,
        Addy Ke <addy.ke@rock-chips.com>
Subject: [PATCH 1/2] mmc: core: use card pointer as the first parameter of execute_tuning()
Date: Mon, 26 Jan 2015 19:19:34 +0800
Message-Id: <1422271175-19445-2-git-send-email-addy.ke@rock-chips.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1422271175-19445-1-git-send-email-addy.ke@rock-chips.com>
References: <1422271175-19445-1-git-send-email-addy.ke@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to take the card pointer in execute_tuning() for mmc_send_status(),
but mmc->card is NULL in tuning state. So we need change the first parameter
of execute_tuning() to card pointer(struct mmc_card * card).

Signed-off-by: Addy Ke <addy.ke@rock-chips.com>
---
 drivers/mmc/core/core.c           | 2 +-
 drivers/mmc/host/dw_mmc.c         | 3 ++-
 drivers/mmc/host/rtsx_pci_sdmmc.c | 3 ++-
 drivers/mmc/host/rtsx_usb_sdmmc.c | 3 ++-
 include/linux/mmc/host.h          | 2 +-
 5 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index 1be7055..271f024 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -1101,7 +1101,7 @@ int mmc_execute_tuning(struct mmc_card *card)
 		opcode = MMC_SEND_TUNING_BLOCK;
 
 	mmc_host_clk_hold(host);
-	err = host->ops->execute_tuning(host, opcode);
+	err = host->ops->execute_tuning(card, opcode);
 	mmc_host_clk_release(host);
 
 	if (err)
diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
index 4bd22af..e54e656 100644
--- a/drivers/mmc/host/dw_mmc.c
+++ b/drivers/mmc/host/dw_mmc.c
@@ -1485,8 +1485,9 @@ free_blk_test:
 	return ret;
 }
 
-static int dw_mci_execute_tuning(struct mmc_host *mmc, u32 opcode)
+static int dw_mci_execute_tuning(struct mmc_card *card, u32 opcode)
 {
+	struct mmc_host *mmc = card->host;
 	struct dw_mci_slot *slot = mmc_priv(mmc);
 	struct dw_mci *host = slot->host;
 	const struct dw_mci_drv_data *drv_data = host->drv_data;
diff --git a/drivers/mmc/host/rtsx_pci_sdmmc.c b/drivers/mmc/host/rtsx_pci_sdmmc.c
index 1d3d6c4..230bd2f 100644
--- a/drivers/mmc/host/rtsx_pci_sdmmc.c
+++ b/drivers/mmc/host/rtsx_pci_sdmmc.c
@@ -1270,8 +1270,9 @@ out:
 	return err;
 }
 
-static int sdmmc_execute_tuning(struct mmc_host *mmc, u32 opcode)
+static int sdmmc_execute_tuning(struct mmc_card *card, u32 opcode)
 {
+	struct mmc_host *mmc = card->host;
 	struct realtek_pci_sdmmc *host = mmc_priv(mmc);
 	struct rtsx_pcr *pcr = host->pcr;
 	int err = 0;
diff --git a/drivers/mmc/host/rtsx_usb_sdmmc.c b/drivers/mmc/host/rtsx_usb_sdmmc.c
index 88af827..c494c06 100644
--- a/drivers/mmc/host/rtsx_usb_sdmmc.c
+++ b/drivers/mmc/host/rtsx_usb_sdmmc.c
@@ -1265,8 +1265,9 @@ out:
 		return 0;
 }
 
-static int sdmmc_execute_tuning(struct mmc_host *mmc, u32 opcode)
+static int sdmmc_execute_tuning(struct mmc_card *card, u32 opcode)
 {
+	struct mmc_host *mmc = card->host;
 	struct rtsx_usb_sdmmc *host = mmc_priv(mmc);
 	struct rtsx_ucr *ucr = host->ucr;
 	int err = 0;
diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
index 0c8cbe5..ec4128e 100644
--- a/include/linux/mmc/host.h
+++ b/include/linux/mmc/host.h
@@ -133,7 +133,7 @@ struct mmc_host_ops {
 	int	(*card_busy)(struct mmc_host *host);
 
 	/* The tuning command opcode value is different for SD and eMMC cards */
-	int	(*execute_tuning)(struct mmc_host *host, u32 opcode);
+	int	(*execute_tuning)(struct mmc_card *card, u32 opcode);
 
 	/* Prepare HS400 target operating frequency depending host driver */
 	int	(*prepare_hs400_tuning)(struct mmc_host *host, struct mmc_ios *ios);
-- 
1.8.3.2


