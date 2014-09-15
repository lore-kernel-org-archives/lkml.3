Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753851AbaIOPuU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 11:50:20 -0400
Received: from mail.neotion.com ([5.39.84.84]:59774 "EHLO mail.neotion.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753738AbaIOPuS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 11:50:18 -0400
Message-ID: <541709FF.6010408@neotion.com>
Date: Mon, 15 Sep 2014 17:47:11 +0200
From: =?UTF-8?B?R3LDqWdvcnkgU291dGFkw6k=?= <gsoutade@neotion.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Ulf Hansson <ulf.hansson@linaro.org>
CC: Chris Ball <chris@printf.net>, Seungwon Jeon <tgih.jun@samsung.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v6 0003/0003] mmc: Checks EXT_CSD_PARTITION_SETTING_COMPLETED
 before partitions computation
References: <53C7E45E.2060102@neotion.com>	<CAPDyKFoRpQBHGGCMPvEKdeVGjTO-rnyYVostLZGCV3dudD1rmA@mail.gmail.com>	<53EB2DC3.2080002@neotion.com>	<CAPDyKFpjYqVUZ8GHB76gD8pOx_eMg9ecvbWrMEfbhEd5ffk7mw@mail.gmail.com>	<53ECB95F.2030207@neotion.com> <CAPDyKFp2ekmucHVzMWxeKfyTmuFKTXAYwUEpL5QxvEh8AjFopg@mail.gmail.com> <53F1FBA3.6060108@neotion.com> <5411435C.3080905@neotion.com> <541303BB.1000602@neotion.com>
In-Reply-To: <541303BB.1000602@neotion.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Checks EXT_CSD_PARTITION_SETTING_COMPLETED bit before
 computing enhanced user area offset and size, and
 adding mmc general purpose partitions. The two needs
 EXT_CSD_PARTITION_SETTING_COMPLETED bit be set to be
 valid (as described in JEDEC standard).
Warn user in case of misconfiguration.

Signed-off-by: Grégory Soutadé <gsoutade@neotion.com>
---
 drivers/mmc/core/mmc.c |   81 ++++++++++++++++++++++++++----------------------
 1 file changed, 44 insertions(+), 37 deletions(-)

diff --git a/drivers/mmc/core/mmc.c b/drivers/mmc/core/mmc.c
index 64d0371..66928b0 100644
--- a/drivers/mmc/core/mmc.c
+++ b/drivers/mmc/core/mmc.c
@@ -300,7 +300,13 @@ static void mmc_select_card_type(struct mmc_card *card)

 static void mmc_manage_enhanced_area(struct mmc_card *card, u8 *ext_csd)
 {
-	u8 hc_erase_grp_sz = 0, hc_wp_grp_sz = 0;
+	u8 hc_erase_grp_sz, hc_wp_grp_sz;
+
+	/*
+	 * Disable these attributes by default
+	 */
+	card->ext_csd.enhanced_area_offset = -EINVAL;
+	card->ext_csd.enhanced_area_size = -EINVAL;

 	/*
 	 * Enhanced area feature support -- check whether the eMMC
@@ -309,43 +315,41 @@ static void mmc_manage_enhanced_area(struct mmc_card *card, u8 *ext_csd)
 	 */
 	if ((ext_csd[EXT_CSD_PARTITION_SUPPORT] & 0x2) &&
 	    (ext_csd[EXT_CSD_PARTITION_ATTRIBUTE] & 0x1)) {
-		hc_erase_grp_sz =
-			ext_csd[EXT_CSD_HC_ERASE_GRP_SIZE];
-		hc_wp_grp_sz =
-			ext_csd[EXT_CSD_HC_WP_GRP_SIZE];
+		if (card->ext_csd.partition_setting_completed) {
+			hc_erase_grp_sz =
+				ext_csd[EXT_CSD_HC_ERASE_GRP_SIZE];
+			hc_wp_grp_sz =
+				ext_csd[EXT_CSD_HC_WP_GRP_SIZE];

-		/*
-		 * calculate the enhanced data area offset, in bytes
-		 */
-		card->ext_csd.enhanced_area_offset =
-			(ext_csd[139] << 24) + (ext_csd[138] << 16) +
-			(ext_csd[137] << 8) + ext_csd[136];
-		if (mmc_card_blockaddr(card))
-			card->ext_csd.enhanced_area_offset <<= 9;
-		/*
-		 * calculate the enhanced data area size, in kilobytes
-		 */
-		card->ext_csd.enhanced_area_size =
-			(ext_csd[142] << 16) + (ext_csd[141] << 8) +
-			ext_csd[140];
-		card->ext_csd.enhanced_area_size *=
-			(size_t)(hc_erase_grp_sz * hc_wp_grp_sz);
-		card->ext_csd.enhanced_area_size <<= 9;
-	} else {
-		/*
-		 * If the enhanced area is not enabled, disable these
-		 * device attributes.
-		 */
-		card->ext_csd.enhanced_area_offset = -EINVAL;
-		card->ext_csd.enhanced_area_size = -EINVAL;
+			/*
+			 * calculate the enhanced data area offset, in bytes
+			 */
+			card->ext_csd.enhanced_area_offset =
+				(ext_csd[139] << 24) + (ext_csd[138] << 16) +
+				(ext_csd[137] << 8) + ext_csd[136];
+			if (mmc_card_blockaddr(card))
+				card->ext_csd.enhanced_area_offset <<= 9;
+			/*
+			 * calculate the enhanced data area size, in kilobytes
+			 */
+			card->ext_csd.enhanced_area_size =
+				(ext_csd[142] << 16) + (ext_csd[141] << 8) +
+				ext_csd[140];
+			card->ext_csd.enhanced_area_size *=
+				(size_t)(hc_erase_grp_sz * hc_wp_grp_sz);
+			card->ext_csd.enhanced_area_size <<= 9;
+		} else {
+			pr_warn("%s: defines enhanced area without partition setting complete\n",
+				mmc_hostname(card->host));
+		}
 	}
 }

 static void mmc_manage_gp_partitions(struct mmc_card *card, u8 *ext_csd)
 {
-	unsigned int part_size;
-	u8 hc_erase_grp_sz = 0, hc_wp_grp_sz = 0;
 	int idx;
+	u8 hc_erase_grp_sz, hc_wp_grp_sz;
+	unsigned int part_size;

 	/*
 	 * General purpose partition feature support --
@@ -354,18 +358,21 @@ static void mmc_manage_gp_partitions(struct mmc_card *card, u8 *ext_csd)
 	 */
 	if (ext_csd[EXT_CSD_PARTITION_SUPPORT] &
 	    EXT_CSD_PART_SUPPORT_PART_EN) {
-		if (card->ext_csd.partition_setting_completed) {
-			hc_erase_grp_sz =
-				ext_csd[EXT_CSD_HC_ERASE_GRP_SIZE];
-			hc_wp_grp_sz =
-				ext_csd[EXT_CSD_HC_WP_GRP_SIZE];
-		}
+		hc_erase_grp_sz =
+			ext_csd[EXT_CSD_HC_ERASE_GRP_SIZE];
+		hc_wp_grp_sz =
+			ext_csd[EXT_CSD_HC_WP_GRP_SIZE];

 		for (idx = 0; idx < MMC_NUM_GP_PARTITION; idx++) {
 			if (!ext_csd[EXT_CSD_GP_SIZE_MULT + idx * 3] &&
 			    !ext_csd[EXT_CSD_GP_SIZE_MULT + idx * 3 + 1] &&
 			    !ext_csd[EXT_CSD_GP_SIZE_MULT + idx * 3 + 2])
 				continue;
+			if (card->ext_csd.partition_setting_completed == 0) {
+				pr_warn("%s: has partition size defined without partition complete\n",
+					mmc_hostname(card->host));
+				break;
+			}
 			part_size =
 				(ext_csd[EXT_CSD_GP_SIZE_MULT + idx * 3 + 2]
 				<< 16) +
-- 
1.7.9.5
