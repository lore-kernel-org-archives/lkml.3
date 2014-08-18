Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751894AbaHRNO7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 09:14:59 -0400
Received: from mail.neotion.com ([5.39.84.84]:35196 "EHLO mail.neotion.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751372AbaHRNO4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 09:14:56 -0400
Message-ID: <53F1FBA7.8000707@neotion.com>
Date: Mon, 18 Aug 2014 15:12:07 +0200
From: =?UTF-8?B?R3LDqWdvcnkgU291dGFkw6k=?= <gsoutade@neotion.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Ulf Hansson <ulf.hansson@linaro.org>
CC: Chris Ball <chris@printf.net>, Seungwon Jeon <tgih.jun@samsung.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 0002/0002] mmc: Checks EXT_CSD_PARTITION_SETTING_COMPLETED
 bit before partitions computation
References: <53C7E45E.2060102@neotion.com>	<CAPDyKFoRpQBHGGCMPvEKdeVGjTO-rnyYVostLZGCV3dudD1rmA@mail.gmail.com>	<53EB2DC3.2080002@neotion.com>	<CAPDyKFpjYqVUZ8GHB76gD8pOx_eMg9ecvbWrMEfbhEd5ffk7mw@mail.gmail.com>	<53ECB95F.2030207@neotion.com> <CAPDyKFp2ekmucHVzMWxeKfyTmuFKTXAYwUEpL5QxvEh8AjFopg@mail.gmail.com>
In-Reply-To: <CAPDyKFp2ekmucHVzMWxeKfyTmuFKTXAYwUEpL5QxvEh8AjFopg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Checks EXT_CSD_PARTITION_SETTING_COMPLETED bit before
computing enhanced user area offset and size, and adding
mmc general purpose partitions.
The two needs EXT_CSD_PARTITION_SETTING_COMPLETED bit be set
to be valid (as described in JEDEC standard).

Signed-off-by: Grégory Soutadé <gsoutade@neotion.com>
---
 drivers/mmc/core/mmc.c |  167 +++++++++++++++++++++++++++---------------------
 1 file changed, 95 insertions(+), 72 deletions(-)

Changelog v2:
	Move code for user area and general purpose partitions
	into functions.

diff --git a/drivers/mmc/core/mmc.c b/drivers/mmc/core/mmc.c
index ef25d91..3158470 100644
--- a/drivers/mmc/core/mmc.c
+++ b/drivers/mmc/core/mmc.c
@@ -298,6 +298,99 @@ static void mmc_select_card_type(struct mmc_card *card)
 	card->mmc_avail_type = avail_type;
 }

+static void mmc_manage_enhanced_area(struct mmc_card *card, u8 *ext_csd)
+{
+	u8 hc_erase_grp_sz, hc_wp_grp_sz;
+
+	/*
+	 * Enhanced area feature support -- check whether the eMMC
+	 * card has the Enhanced area enabled.  If so, export enhanced
+	 * area offset and size to user by adding sysfs interface.
+	 */
+	if ((ext_csd[EXT_CSD_PARTITION_SUPPORT] & 0x2) &&
+	    (ext_csd[EXT_CSD_PARTITION_ATTRIBUTE] & 0x1)) {
+		if (card->ext_csd.partition_setting_completed) {
+			hc_erase_grp_sz =
+				ext_csd[EXT_CSD_HC_ERASE_GRP_SIZE];
+			hc_wp_grp_sz =
+				ext_csd[EXT_CSD_HC_WP_GRP_SIZE];
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
+	} else {
+		/*
+		 * If the enhanced area is not enabled, disable these
+		 * device attributes.
+		 */
+		card->ext_csd.enhanced_area_offset = -EINVAL;
+		card->ext_csd.enhanced_area_size = -EINVAL;
+	}
+}
+
+static void mmc_manage_gp_partitions(struct mmc_card *card, u8 *ext_csd)
+{
+	int idx;
+	u8 hc_erase_grp_sz, hc_wp_grp_sz;
+	unsigned int part_size;
+
+	/*
+	 * General purpose partition feature support --
+	 * If ext_csd has the size of general purpose partitions,
+	 * set size, part_cfg, partition name in mmc_part.
+	 */
+	if (ext_csd[EXT_CSD_PARTITION_SUPPORT] &
+	    EXT_CSD_PART_SUPPORT_PART_EN) {
+		hc_erase_grp_sz =
+			ext_csd[EXT_CSD_HC_ERASE_GRP_SIZE];
+		hc_wp_grp_sz =
+			ext_csd[EXT_CSD_HC_WP_GRP_SIZE];
+
+		for (idx = 0; idx < MMC_NUM_GP_PARTITION; idx++) {
+			if (!ext_csd[EXT_CSD_GP_SIZE_MULT + idx * 3] &&
+			    !ext_csd[EXT_CSD_GP_SIZE_MULT + idx * 3 + 1] &&
+			    !ext_csd[EXT_CSD_GP_SIZE_MULT + idx * 3 + 2])
+				continue;
+
+			if (card->ext_csd.partition_setting_completed == 0) {
+				pr_warn("%s: has partition size defined without partition complete\n",
+					mmc_hostname(card->host));
+				break;
+			}
+
+			part_size =
+				(ext_csd[EXT_CSD_GP_SIZE_MULT + idx * 3 + 2]
+				<< 16) +
+				(ext_csd[EXT_CSD_GP_SIZE_MULT + idx * 3 + 1]
+				<< 8) +
+				ext_csd[EXT_CSD_GP_SIZE_MULT + idx * 3];
+			part_size *= (size_t)(hc_erase_grp_sz *
+				hc_wp_grp_sz);
+			mmc_part_add(card, part_size << 19,
+				EXT_CSD_PART_CONFIG_ACC_GP0 + idx,
+				"gp%d", idx, false,
+				MMC_BLK_DATA_AREA_GP);
+		}
+	}
+}
+
 /*
  * Decode extended CSD.
  */
@@ -305,7 +398,6 @@ static int mmc_read_ext_csd(struct mmc_card *card, u8 *ext_csd)
 {
 	int err = 0, idx;
 	unsigned int part_size;
-	u8 hc_erase_grp_sz = 0, hc_wp_grp_sz = 0;

 	BUG_ON(!card);

@@ -409,80 +501,11 @@ static int mmc_read_ext_csd(struct mmc_card *card, u8 *ext_csd)
 		} else {
 			card->ext_csd.partition_setting_completed = 0;
 		}
-		/*
-		 * Enhanced area feature support -- check whether the eMMC
-		 * card has the Enhanced area enabled.  If so, export enhanced
-		 * area offset and size to user by adding sysfs interface.
-		 */
-		if ((ext_csd[EXT_CSD_PARTITION_SUPPORT] & 0x2) &&
-		    (ext_csd[EXT_CSD_PARTITION_ATTRIBUTE] & 0x1)) {
-			hc_erase_grp_sz =
-				ext_csd[EXT_CSD_HC_ERASE_GRP_SIZE];
-			hc_wp_grp_sz =
-				ext_csd[EXT_CSD_HC_WP_GRP_SIZE];

-			card->ext_csd.enhanced_area_en = 1;
-			/*
-			 * calculate the enhanced data area offset, in bytes
-			 */
-			card->ext_csd.enhanced_area_offset =
-				(ext_csd[139] << 24) + (ext_csd[138] << 16) +
-				(ext_csd[137] << 8) + ext_csd[136];
-			if (mmc_card_blockaddr(card))
-				card->ext_csd.enhanced_area_offset <<= 9;
-			/*
-			 * calculate the enhanced data area size, in kilobytes
-			 */
-			card->ext_csd.enhanced_area_size =
-				(ext_csd[142] << 16) + (ext_csd[141] << 8) +
-				ext_csd[140];
-			card->ext_csd.enhanced_area_size *=
-				(size_t)(hc_erase_grp_sz * hc_wp_grp_sz);
-			card->ext_csd.enhanced_area_size <<= 9;
-		} else {
-			/*
-			 * If the enhanced area is not enabled, disable these
-			 * device attributes.
-			 */
-			card->ext_csd.enhanced_area_offset = -EINVAL;
-			card->ext_csd.enhanced_area_size = -EINVAL;
-		}
+		mmc_manage_enhanced_area(card, ext_csd);

-		/*
-		 * General purpose partition feature support --
-		 * If ext_csd has the size of general purpose partitions,
-		 * set size, part_cfg, partition name in mmc_part.
-		 */
-		if (ext_csd[EXT_CSD_PARTITION_SUPPORT] &
-			EXT_CSD_PART_SUPPORT_PART_EN) {
-			if (card->ext_csd.enhanced_area_en != 1) {
-				hc_erase_grp_sz =
-					ext_csd[EXT_CSD_HC_ERASE_GRP_SIZE];
-				hc_wp_grp_sz =
-					ext_csd[EXT_CSD_HC_WP_GRP_SIZE];
-
-				card->ext_csd.enhanced_area_en = 1;
-			}
+		mmc_manage_gp_partitions(card, ext_csd);

-			for (idx = 0; idx < MMC_NUM_GP_PARTITION; idx++) {
-				if (!ext_csd[EXT_CSD_GP_SIZE_MULT + idx * 3] &&
-				!ext_csd[EXT_CSD_GP_SIZE_MULT + idx * 3 + 1] &&
-				!ext_csd[EXT_CSD_GP_SIZE_MULT + idx * 3 + 2])
-					continue;
-				part_size =
-				(ext_csd[EXT_CSD_GP_SIZE_MULT + idx * 3 + 2]
-					<< 16) +
-				(ext_csd[EXT_CSD_GP_SIZE_MULT + idx * 3 + 1]
-					<< 8) +
-				ext_csd[EXT_CSD_GP_SIZE_MULT + idx * 3];
-				part_size *= (size_t)(hc_erase_grp_sz *
-					hc_wp_grp_sz);
-				mmc_part_add(card, part_size << 19,
-					EXT_CSD_PART_CONFIG_ACC_GP0 + idx,
-					"gp%d", idx, false,
-					MMC_BLK_DATA_AREA_GP);
-			}
-		}
 		card->ext_csd.sec_trim_mult =
 			ext_csd[EXT_CSD_SEC_TRIM_MULT];
 		card->ext_csd.sec_erase_mult =
--
1.7.9.5
