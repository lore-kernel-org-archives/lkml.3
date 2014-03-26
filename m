Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932173AbaCZQpu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 12:45:50 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:62774 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755838AbaCZQj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 12:39:56 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, kernel@stlinux.com, computersforpeace@gmail.com,
        linux-mtd@lists.infradead.org, angus.clark@st.com
Subject: [PATCH 03/15] mtd: st_spi_fsm: Update Macronix 'QE' configuration
Date: Wed, 26 Mar 2014 16:39:17 +0000
Message-Id: <1395851969-13520-4-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1395851969-13520-1-git-send-email-lee.jones@linaro.org>
References: <1395851969-13520-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Angus Clark <angus.clark@st.com>

Update the configuration of the Macronix 'QE' bit, such that
we only set or clear the bit if required.

Signed-off-by: Angus Clark <angus.clark@st.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mtd/devices/st_spi_fsm.c | 23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff --git a/drivers/mtd/devices/st_spi_fsm.c b/drivers/mtd/devices/st_spi_fsm.c
index 31bbf28..fabba2c 100644
--- a/drivers/mtd/devices/st_spi_fsm.c
+++ b/drivers/mtd/devices/st_spi_fsm.c
@@ -1163,12 +1163,27 @@ static int stfsm_mx25_config(struct stfsm *fsm)
 					      CFG_ERASESEC_TOGGLE_32BIT_ADDR);
 	}
 
-	/* For QUAD mode, set 'QE' STATUS bit */
+	/* Check status of 'QE' bit */
+	stfsm_read_status(fsm, FLASH_CMD_RDSR, &sta);
 	data_pads = ((fsm->stfsm_seq_read.seq_cfg >> 16) & 0x3) + 1;
 	if (data_pads == 4) {
-		stfsm_read_status(fsm, FLASH_CMD_RDSR, &sta);
-		sta |= MX25_STATUS_QE;
-		stfsm_write_status(fsm, sta, 1);
+		if (!(sta & MX25_STATUS_QE)) {
+			/* Set 'QE' */
+			sta |= MX25_STATUS_QE;
+
+			stfsm_write_status(fsm, sta, 1);
+
+			stfsm_wait_busy(fsm);
+		}
+	} else {
+		if (sta & MX25_STATUS_QE) {
+			/* Clear 'QE' */
+			sta &= ~MX25_STATUS_QE;
+
+			stfsm_write_status(fsm, sta, 1);
+
+			stfsm_wait_busy(fsm);
+		}
 	}
 
 	return 0;
-- 
1.8.3.2

