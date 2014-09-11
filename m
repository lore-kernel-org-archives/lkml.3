Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752759AbaIKGlc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 02:41:32 -0400
Received: from mail.neotion.com ([5.39.84.84]:55047 "EHLO mail.neotion.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752394AbaIKGla (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 02:41:30 -0400
Message-ID: <54114362.2080709@neotion.com>
Date: Thu, 11 Sep 2014 08:38:26 +0200
From: =?UTF-8?B?R3LDqWdvcnkgU291dGFkw6k=?= <gsoutade@neotion.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Ulf Hansson <ulf.hansson@linaro.org>
CC: Chris Ball <chris@printf.net>, Seungwon Jeon <tgih.jun@samsung.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v4 0002/0003] mmc: Replace "enhanced_area_en" attribute by
 "partition_setting_completed"
References: <53C7E45E.2060102@neotion.com>	<CAPDyKFoRpQBHGGCMPvEKdeVGjTO-rnyYVostLZGCV3dudD1rmA@mail.gmail.com>	<53EB2DC3.2080002@neotion.com>	<CAPDyKFpjYqVUZ8GHB76gD8pOx_eMg9ecvbWrMEfbhEd5ffk7mw@mail.gmail.com>	<53ECB95F.2030207@neotion.com> <CAPDyKFp2ekmucHVzMWxeKfyTmuFKTXAYwUEpL5QxvEh8AjFopg@mail.gmail.com> <53F1FBA3.6060108@neotion.com>
In-Reply-To: <53F1FBA3.6060108@neotion.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace ext_csd "enhanced_area_en" attribute by
 "partition_setting_completed". It was used whether or
 not enhanced user area is defined and without checks of
 EXT_CSD_PARTITION_SETTING_COMPLETED bit.

Signed-off-by: Grégory Soutadé <gsoutade@neotion.com>
---
 drivers/mmc/core/mmc.c   |    9 ++++++++-
 include/linux/mmc/card.h |    2 +-
 include/linux/mmc/mmc.h  |    2 ++
 3 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/core/mmc.c b/drivers/mmc/core/mmc.c
index 77b4cf3..3578e35 100644
--- a/drivers/mmc/core/mmc.c
+++ b/drivers/mmc/core/mmc.c
@@ -488,6 +488,13 @@ static int mmc_read_ext_csd(struct mmc_card *card, u8 *ext_csd)
 		ext_csd[EXT_CSD_TRIM_MULT];
 	card->ext_csd.raw_partition_support = ext_csd[EXT_CSD_PARTITION_SUPPORT];
 	if (card->ext_csd.rev >= 4) {
+		if (ext_csd[EXT_CSD_PARTITION_SETTING_COMPLETED] &
+		    EXT_CSD_PART_SETTING_COMPLETED) {
+			card->ext_csd.partition_setting_completed = 1;
+		} else {
+			card->ext_csd.partition_setting_completed = 0;
+		}
+
 		mmc_manage_enhanced_area(card, ext_csd);

 		mmc_manage_gp_partitions(card, ext_csd);
@@ -1324,7 +1331,7 @@ static int mmc_init_card(struct mmc_host *host, u32 ocr,
 	 * If enhanced_area_en is TRUE, host needs to enable ERASE_GRP_DEF
 	 * bit.  This bit will be lost every time after a reset or power off.
 	 */
-	if (card->ext_csd.enhanced_area_en ||
+	if (card->ext_csd.partition_setting_completed ||
 	    (card->ext_csd.rev >= 3 && (host->caps2 & MMC_CAP2_HC_ERASE_SZ))) {
 		err = mmc_switch(card, EXT_CSD_CMD_SET_NORMAL,
 				 EXT_CSD_ERASE_GROUP_DEF, 1,
diff --git a/include/linux/mmc/card.h b/include/linux/mmc/card.h
index d424b9d..38175be 100644
--- a/include/linux/mmc/card.h
+++ b/include/linux/mmc/card.h
@@ -74,7 +74,7 @@ struct mmc_ext_csd {
 	unsigned int		sec_trim_mult;	/* Secure trim multiplier  */
 	unsigned int		sec_erase_mult;	/* Secure erase multiplier */
 	unsigned int		trim_timeout;		/* In milliseconds */
-	bool			enhanced_area_en;	/* enable bit */
+	bool			partition_setting_completed;	/* enable bit */
 	unsigned long long	enhanced_area_offset;	/* Units: Byte */
 	unsigned int		enhanced_area_size;	/* Units: KB */
 	unsigned int		cache_size;		/* Units: KB */
diff --git a/include/linux/mmc/mmc.h b/include/linux/mmc/mmc.h
index 64ec963..78753bc 100644
--- a/include/linux/mmc/mmc.h
+++ b/include/linux/mmc/mmc.h
@@ -281,6 +281,7 @@ struct _mmc_csd {
 #define EXT_CSD_EXP_EVENTS_CTRL		56	/* R/W, 2 bytes */
 #define EXT_CSD_DATA_SECTOR_SIZE	61	/* R */
 #define EXT_CSD_GP_SIZE_MULT		143	/* R/W */
+#define EXT_CSD_PARTITION_SETTING_COMPLETED 155	/* R/W */
 #define EXT_CSD_PARTITION_ATTRIBUTE	156	/* R/W */
 #define EXT_CSD_PARTITION_SUPPORT	160	/* RO */
 #define EXT_CSD_HPI_MGMT		161	/* R/W */
@@ -349,6 +350,7 @@ struct _mmc_csd {
 #define EXT_CSD_PART_CONFIG_ACC_RPMB	(0x3)
 #define EXT_CSD_PART_CONFIG_ACC_GP0	(0x4)

+#define EXT_CSD_PART_SETTING_COMPLETED	(0x1)
 #define EXT_CSD_PART_SUPPORT_PART_EN	(0x1)

 #define EXT_CSD_CMD_SET_NORMAL		(1<<0)
-- 
1.7.9.5
