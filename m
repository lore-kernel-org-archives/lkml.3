Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754524AbbAUP0o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 10:26:44 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:41807 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754149AbbAUPY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 10:24:58 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, kernel@stlinux.com, linux-mtd@lists.infradead.org,
        computersforpeace@gmail.com, Angus Clark <angus.clark@st.com>
Subject: [PATCH v4 07/10] mtd: st_spi_fsm: Improve busy wait handling
Date: Wed, 21 Jan 2015 15:24:25 +0000
Message-Id: <1421853868-8262-8-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1421853868-8262-1-git-send-email-lee.jones@linaro.org>
References: <1421853868-8262-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Angus Clark <angus.clark@st.com>

In this patch, the fsm_wait_busy() function is updated to a take a timeout
parameter.  This allows us to specify different timeout delays depending on
the operation being performed.  Previously, a fixed, worst-case delay
(corresponding to the Chip Erase operation, ~300s!) was used. For the moment,
we have defined conservative delays for each relevant operation, which should
accommodate all existing devices.  In principle, one could set the delays
according the device probed, but there is probably little to be gained.

Signed-off-by: Angus Clark <angus.clark@st.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mtd/devices/st_spi_fsm.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/mtd/devices/st_spi_fsm.c b/drivers/mtd/devices/st_spi_fsm.c
index f452276e..5e365ef 100644
--- a/drivers/mtd/devices/st_spi_fsm.c
+++ b/drivers/mtd/devices/st_spi_fsm.c
@@ -267,7 +267,12 @@
 
 #define FLASH_PAGESIZE         256			/* In Bytes    */
 #define FLASH_PAGESIZE_32      (FLASH_PAGESIZE / 4)	/* In uint32_t */
-#define FLASH_MAX_BUSY_WAIT    (300 * HZ)	/* Maximum 'CHIPERASE' time */
+/* Maximum operation times (in ms) */
+#define FLASH_MAX_CHIP_ERASE_MS 500000          /* Chip Erase time */
+#define FLASH_MAX_SEC_ERASE_MS  30000           /* Sector Erase time */
+#define FLASH_MAX_PAGE_WRITE_MS 100             /* Write Page time */
+#define FLASH_MAX_STA_WRITE_MS  4000            /* Write status reg time */
+#define FSM_MAX_WAIT_SEQ_MS     1000            /* FSM execution time */
 
 /*
  * Flags to tweak operation of default read/write/erase routines
@@ -1003,7 +1008,7 @@ static int stfsm_enter_32bit_addr(struct stfsm *fsm, int enter)
 	return 0;
 }
 
-static uint8_t stfsm_wait_busy(struct stfsm *fsm)
+static uint8_t stfsm_wait_busy(struct stfsm *fsm, unsigned int max_time_ms)
 {
 	struct stfsm_seq *seq = &stfsm_seq_read_status_fifo;
 	unsigned long deadline;
@@ -1021,7 +1026,7 @@ static uint8_t stfsm_wait_busy(struct stfsm *fsm)
 	/*
 	 * Repeat until busy bit is deasserted, or timeout, or error (S25FLxxxS)
 	 */
-	deadline = jiffies + FLASH_MAX_BUSY_WAIT;
+	deadline = jiffies + msecs_to_jiffies(max_time_ms);
 	while (!timeout) {
 		if (time_after_eq(jiffies, deadline))
 			timeout = 1;
@@ -1100,7 +1105,7 @@ static int stfsm_write_status(struct stfsm *fsm, uint8_t cmd,
 	stfsm_wait_seq(fsm);
 
 	if (wait_busy)
-		stfsm_wait_busy(fsm);
+		stfsm_wait_busy(fsm, FLASH_MAX_STA_WRITE_MS);
 
 	return 0;
 }
@@ -1497,7 +1502,7 @@ static void stfsm_s25fl_write_dyb(struct stfsm *fsm, uint32_t offs, uint8_t dby)
 	stfsm_load_seq(fsm, &seq);
 	stfsm_wait_seq(fsm);
 
-	stfsm_wait_busy(fsm);
+	stfsm_wait_busy(fsm, FLASH_MAX_STA_WRITE_MS);
 }
 
 static int stfsm_s25fl_clear_status_reg(struct stfsm *fsm)
@@ -1800,7 +1805,7 @@ static int stfsm_write(struct stfsm *fsm, const uint8_t *buf,
 	stfsm_wait_seq(fsm);
 
 	/* Wait for completion */
-	ret = stfsm_wait_busy(fsm);
+	ret = stfsm_wait_busy(fsm, FLASH_MAX_PAGE_WRITE_MS);
 	if (ret && fsm->configuration & CFG_S25FL_CHECK_ERROR_FLAGS)
 		stfsm_s25fl_clear_status_reg(fsm);
 
@@ -1872,7 +1877,7 @@ static int stfsm_erase_sector(struct stfsm *fsm, uint32_t offset)
 	stfsm_wait_seq(fsm);
 
 	/* Wait for completion */
-	ret = stfsm_wait_busy(fsm);
+	ret = stfsm_wait_busy(fsm, FLASH_MAX_SEC_ERASE_MS);
 	if (ret && fsm->configuration & CFG_S25FL_CHECK_ERROR_FLAGS)
 		stfsm_s25fl_clear_status_reg(fsm);
 
@@ -1902,7 +1907,7 @@ static int stfsm_erase_chip(struct stfsm *fsm)
 
 	stfsm_wait_seq(fsm);
 
-	return stfsm_wait_busy(fsm);
+	return stfsm_wait_busy(fsm, FLASH_MAX_CHIP_ERASE_MS);
 }
 
 /*
-- 
1.9.1

