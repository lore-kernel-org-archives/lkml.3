Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758185AbaCTJcP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 05:32:15 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:42990 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756907AbaCTJV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 05:21:28 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        computersforpeace@gmail.com
Cc: linux-mtd@lists.infradead.org, dwmw2@infradead.org, Angus.Clark@st.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH v6 05/36] mtd: st_spi_fsm: Supply a method to read from the FSM's FIFO
Date: Thu, 20 Mar 2014 09:20:37 +0000
Message-Id: <1395307268-12721-6-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1395307268-12721-1-git-send-email-lee.jones@linaro.org>
References: <1395307268-12721-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When invoked the driver will attempt to read any available data from
the FSM's data register. Any data collected from this FIFO would have
originated from the flash chip.

Acked-by Angus Clark <angus.clark@st.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mtd/devices/st_spi_fsm.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/drivers/mtd/devices/st_spi_fsm.c b/drivers/mtd/devices/st_spi_fsm.c
index 5e22c86..73e0f27 100644
--- a/drivers/mtd/devices/st_spi_fsm.c
+++ b/drivers/mtd/devices/st_spi_fsm.c
@@ -281,6 +281,32 @@ static void stfsm_wait_seq(struct stfsm *fsm)
 	dev_err(fsm->dev, "timeout on sequence completion\n");
 }
 
+static void stfsm_read_fifo(struct stfsm *fsm, uint32_t *buf,
+			    const uint32_t size)
+{
+	uint32_t remaining = size >> 2;
+	uint32_t avail;
+	uint32_t words;
+
+	dev_dbg(fsm->dev, "Reading %d bytes from FIFO\n", size);
+
+	BUG_ON((((uint32_t)buf) & 0x3) || (size & 0x3));
+
+	while (remaining) {
+		for (;;) {
+			avail = stfsm_fifo_available(fsm);
+			if (avail)
+				break;
+			udelay(1);
+		}
+		words = min(avail, remaining);
+		remaining -= words;
+
+		readsl(fsm->base + SPI_FAST_SEQ_DATA_REG, buf, words);
+		buf += words;
+	}
+}
+
 static int stfsm_set_mode(struct stfsm *fsm, uint32_t mode)
 {
 	int ret, timeout = 10;
-- 
1.8.3.2

