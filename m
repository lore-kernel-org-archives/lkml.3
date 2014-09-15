Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753718AbaIOPuR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 11:50:17 -0400
Received: from mail.neotion.com ([5.39.84.84]:46133 "EHLO mail.neotion.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752224AbaIOPuO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 11:50:14 -0400
Message-ID: <541709FA.3070906@neotion.com>
Date: Mon, 15 Sep 2014 17:47:06 +0200
From: =?UTF-8?B?R3LDqWdvcnkgU291dGFkw6k=?= <gsoutade@neotion.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Ulf Hansson <ulf.hansson@linaro.org>
CC: Chris Ball <chris@printf.net>, Seungwon Jeon <tgih.jun@samsung.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v6 0001/0003] mmc: Move code that manages user area and gp
 partitions into functions
References: <53C7E45E.2060102@neotion.com>	<CAPDyKFoRpQBHGGCMPvEKdeVGjTO-rnyYVostLZGCV3dudD1rmA@mail.gmail.com>	<53EB2DC3.2080002@neotion.com>	<CAPDyKFpjYqVUZ8GHB76gD8pOx_eMg9ecvbWrMEfbhEd5ffk7mw@mail.gmail.com>	<53ECB95F.2030207@neotion.com> <CAPDyKFp2ekmucHVzMWxeKfyTmuFKTXAYwUEpL5QxvEh8AjFopg@mail.gmail.com> <53F1FBA3.6060108@neotion.com> <5411435C.3080905@neotion.com> <541303B5.6080100@neotion.com>
In-Reply-To: <541303B5.6080100@neotion.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move code that manages user area and general purpose
 partitions into functions.

Signed-off-by: Grégory Soutadé <gsoutade@neotion.com>
---
 drivers/mmc/core/mmc.c |  162 ++++++++++++++++++++++++++----------------------
 1 file changed, 89 insertions(+), 73 deletions(-)

diff --git a/drivers/mmc/core/mmc.c b/drivers/mmc/core/mmc.c
index 1eda8dd..77b4cf3 100644
--- a/drivers/mmc/core/mmc.c
+++ b/drivers/mmc/core/mmc.c
@@ -298,6 +298,93 @@ static void mmc_select_card_type(struct mmc_card *card)
 	card->mmc_avail_type = avail_type;
 }

+static void mmc_manage_enhanced_area(struct mmc_card *card, u8 *ext_csd)
+{
+	u8 hc_erase_grp_sz = 0, hc_wp_grp_sz = 0;
+
+	/*
+	 * Enhanced area feature support -- check whether the eMMC
+	 * card has the Enhanced area enabled.  If so, export enhanced
+	 * area offset and size to user by adding sysfs interface.
+	 */
+	if ((ext_csd[EXT_CSD_PARTITION_SUPPORT] & 0x2) &&
+	    (ext_csd[EXT_CSD_PARTITION_ATTRIBUTE] & 0x1)) {
+		hc_erase_grp_sz =
+			ext_csd[EXT_CSD_HC_ERASE_GRP_SIZE];
+		hc_wp_grp_sz =
+			ext_csd[EXT_CSD_HC_WP_GRP_SIZE];
+
+		card->ext_csd.enhanced_area_en = 1;
+		/*
+		 * calculate the enhanced data area offset, in bytes
+		 */
+		card->ext_csd.enhanced_area_offset =
+			(ext_csd[139] << 24) + (ext_csd[138] << 16) +
+			(ext_csd[137] << 8) + ext_csd[136];
+		if (mmc_card_blockaddr(card))
+			card->ext_csd.enhanced_area_offset <<= 9;
+		/*
+		 * calculate the enhanced data area size, in kilobytes
+		 */
+		card->ext_csd.enhanced_area_size =
+			(ext_csd[142] << 16) + (ext_csd[141] << 8) +
+			ext_csd[140];
+		card->ext_csd.enhanced_area_size *=
+			(size_t)(hc_erase_grp_sz * hc_wp_grp_sz);
+		card->ext_csd.enhanced_area_size <<= 9;
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
+	unsigned int part_size;
+	u8 hc_erase_grp_sz = 0, hc_wp_grp_sz = 0;
+	int idx;
+
+	/*
+	 * General purpose partition feature support --
+	 * If ext_csd has the size of general purpose partitions,
+	 * set size, part_cfg, partition name in mmc_part.
+	 */
+	if (ext_csd[EXT_CSD_PARTITION_SUPPORT] &
+	    EXT_CSD_PART_SUPPORT_PART_EN) {
+		if (card->ext_csd.enhanced_area_en != 1) {
+			hc_erase_grp_sz =
+				ext_csd[EXT_CSD_HC_ERASE_GRP_SIZE];
+			hc_wp_grp_sz =
+				ext_csd[EXT_CSD_HC_WP_GRP_SIZE];
+
+			card->ext_csd.enhanced_area_en = 1;
+		}
+
+		for (idx = 0; idx < MMC_NUM_GP_PARTITION; idx++) {
+			if (!ext_csd[EXT_CSD_GP_SIZE_MULT + idx * 3] &&
+			    !ext_csd[EXT_CSD_GP_SIZE_MULT + idx * 3 + 1] &&
+			    !ext_csd[EXT_CSD_GP_SIZE_MULT + idx * 3 + 2])
+				continue;
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
@@ -305,7 +392,6 @@ static int mmc_read_ext_csd(struct mmc_card *card, u8 *ext_csd)
 {
 	int err = 0, idx;
 	unsigned int part_size;
-	u8 hc_erase_grp_sz = 0, hc_wp_grp_sz = 0;

 	BUG_ON(!card);

@@ -402,80 +488,10 @@ static int mmc_read_ext_csd(struct mmc_card *card, u8 *ext_csd)
 		ext_csd[EXT_CSD_TRIM_MULT];
 	card->ext_csd.raw_partition_support = ext_csd[EXT_CSD_PARTITION_SUPPORT];
 	if (card->ext_csd.rev >= 4) {
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
+		mmc_manage_enhanced_area(card, ext_csd);

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
+		mmc_manage_gp_partitions(card, ext_csd);

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
-
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
