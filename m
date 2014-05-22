Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760AbaEVLZz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 07:25:55 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:48582 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754515AbaEVLYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 07:24:32 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: computersforpeace@gmail.com, linux-mtd@lists.infradead.org,
        Angus Clark <angus.clark@st.com>,
        Carmelo Amoroso <carmelo.amoroso@st.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 06/10] mtd: st_spi_fsm: Update Spansion device entries
Date: Thu, 22 May 2014 12:24:04 +0100
Message-Id: <1400757848-18075-7-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1400757848-18075-1-git-send-email-lee.jones@linaro.org>
References: <1400757848-18075-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Angus Clark <angus.clark@st.com>

This patch updates various Spansion device entries in the flash_types[] table:
  - Define full 6-byte READIDs for S25FL128Sx devices (and fix the 4th
    byte). This allows us to differentiate between S25FL129P and S25FL128S
    devices.
  - Add S25FL128Px device entries.

Signed-off-by: Angus Clark <angus.clark@st.com>
Signed-off-by: Carmelo Amoroso <carmelo.amoroso@st.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mtd/devices/st_spi_fsm.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/mtd/devices/st_spi_fsm.c b/drivers/mtd/devices/st_spi_fsm.c
index 3409651..7514a07 100644
--- a/drivers/mtd/devices/st_spi_fsm.c
+++ b/drivers/mtd/devices/st_spi_fsm.c
@@ -445,6 +445,7 @@ static struct flash_info flash_types[] = {
 	/*
 	 * Spansion S25FLxxxP
 	 *     - 256KiB and 64KiB sector variants (identified by ext. JEDEC)
+	 *     - S25FL128Px devices do not support DUAL or QUAD I/O
 	 */
 #define S25FLXXXP_FLAG (FLASH_FLAG_READ_WRITE  |	\
 			FLASH_FLAG_READ_1_1_2   |	\
@@ -455,6 +456,12 @@ static struct flash_info flash_types[] = {
 			FLASH_FLAG_READ_FAST)
 	RDID_INFO("s25fl032p", RDID({0x01, 0x02, 0x15, 0x4d, 0x00}), 5,
 		  64 * 1024,  64, S25FLXXXP_FLAG, 80, stfsm_s25fl_config),
+	RDID_INFO("s25fl128p1", RDID({0x01, 0x20, 0x18, 0x03, 0x00}), 5,
+		  256 * 1024, 64,
+		  (FLASH_FLAG_READ_WRITE | FLASH_FLAG_READ_FAST), 104, NULL),
+	RDID_INFO("s25fl128p0", RDID({0x01, 0x20, 0x18, 0x03, 0x01}), 5,
+		  64 * 1024, 256,
+		  (FLASH_FLAG_READ_WRITE | FLASH_FLAG_READ_FAST), 104, NULL),
 	RDID_INFO("s25fl129p0", RDID({0x01, 0x20, 0x18, 0x4d, 0x00}), 5,
 		  256 * 1024,  64, S25FLXXXP_FLAG, 80, stfsm_s25fl_config),
 	RDID_INFO("s25fl129p1", RDID({0x01, 0x20, 0x18, 0x4d, 0x01}), 5,
@@ -468,17 +475,18 @@ static struct flash_info flash_types[] = {
 	 *       so this information is captured in the board's flags.
 	 *     - Supports 'DYB' sector protection. Depending on variant, sectors
 	 *       may default to locked state on power-on.
+	 *     - S25FL127Sx handled as S25FL128Sx
 	 */
 #define S25FLXXXS_FLAG (S25FLXXXP_FLAG         |	\
 			FLASH_FLAG_RESET        |	\
 			FLASH_FLAG_DYB_LOCKING)
-	RDID_INFO("s25fl128s0", RDID({0x01, 0x20, 0x18, 0x03, 0x00}), 5,
+	RDID_INFO("s25fl128s0", RDID({0x01, 0x20, 0x18, 0x4d, 0x00, 0x80}), 6,
 		  256 * 1024, 64, S25FLXXXS_FLAG, 80, stfsm_s25fl_config),
-	RDID_INFO("s25fl128s1", RDID({0x01, 0x20, 0x18, 0x03, 0x01}), 5,
+	RDID_INFO("s25fl128s1", RDID({0x01, 0x20, 0x18, 0x4d, 0x01, 0x80}), 6,
 		  64 * 1024, 256, S25FLXXXS_FLAG, 80, stfsm_s25fl_config),
-	RDID_INFO("s25fl256s0", RDID({0x01, 0x02, 0x19, 0x4d, 0x00}), 5,
+	RDID_INFO("s25fl256s0", RDID({0x01, 0x02, 0x19, 0x4d, 0x00, 0x80}), 6,
 		  256 * 1024, 128, S25FLXXXS_FLAG, 80, stfsm_s25fl_config),
-	RDID_INFO("s25fl256s1", RDID({0x01, 0x02, 0x19, 0x4d, 0x01}), 5,
+	RDID_INFO("s25fl256s1", RDID({0x01, 0x02, 0x19, 0x4d, 0x01, 0x80}), 6,
 		  64 * 1024, 512, S25FLXXXS_FLAG, 80, stfsm_s25fl_config),
 
 #define W25X_FLAG (FLASH_FLAG_READ_WRITE       |	\
-- 
1.8.3.2

