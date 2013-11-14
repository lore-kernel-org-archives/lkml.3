Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754247Ab3KNOXh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 09:23:37 -0500
Received: from mail-ob0-f170.google.com ([209.85.214.170]:58120 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754077Ab3KNOXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 09:23:04 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: linus.walleij@linaro.org, dwmw2@infradead.org,
        linux-mtd@lists.infradead.org, angus.clark@st.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 05/10] mtd: st_spi_fsm: Supply a method to read from the FSM's FIFO
Date: Thu, 14 Nov 2013 14:22:31 +0000
Message-Id: <1384438956-31153-6-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1384438956-31153-1-git-send-email-lee.jones@linaro.org>
References: <1384438956-31153-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When invoked the driver will attempt to read any available data from
the FSM's data register. Any data collected from this FIFO would have
originated from the flash chip.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mtd/devices/st_spi_fsm.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/drivers/mtd/devices/st_spi_fsm.c b/drivers/mtd/devices/st_spi_fsm.c
index 02619ee..a1c2857 100644
--- a/drivers/mtd/devices/st_spi_fsm.c
+++ b/drivers/mtd/devices/st_spi_fsm.c
@@ -94,6 +94,32 @@ static void stfsm_wait_seq(struct stfsm *fsm)
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
 static void stfsm_clear_fifo(struct stfsm *fsm)
 {
 	uint32_t avail;
-- 
1.8.1.2

