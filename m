Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932363AbaAHNtM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 08:49:12 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:47744 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932342AbaAHNtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 08:49:07 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: computersforpeace@gmail.com, angus.clark@st.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH v4 27/37] mtd: st_spi_fsm: Write to Flash via the FSM FIFO
Date: Wed,  8 Jan 2014 13:47:10 +0000
Message-Id: <1389188840-14306-28-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389188840-14306-1-git-send-email-lee.jones@linaro.org>
References: <1389188840-14306-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we write data to the FIFO the FSM Controller subsequently writes
that data out to the Serial Flash chip.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mtd/devices/st_spi_fsm.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/mtd/devices/st_spi_fsm.c b/drivers/mtd/devices/st_spi_fsm.c
index b43fed1..c64f741 100644
--- a/drivers/mtd/devices/st_spi_fsm.c
+++ b/drivers/mtd/devices/st_spi_fsm.c
@@ -661,6 +661,20 @@ static void stfsm_read_fifo(struct stfsm *fsm, uint32_t *buf,
 	}
 }
 
+static int stfsm_write_fifo(struct stfsm *fsm,
+			    const uint32_t *buf, const uint32_t size)
+{
+	uint32_t words = size >> 2;
+
+	dev_dbg(fsm->dev, "writing %d bytes to FIFO\n", size);
+
+	BUG_ON((((uint32_t)buf) & 0x3) || (size & 0x3));
+
+	writesl(fsm->base + SPI_FAST_SEQ_DATA_REG, buf, words);
+
+	return size;
+}
+
 static int stfsm_enter_32bit_addr(struct stfsm *fsm, int enter)
 {
 	struct stfsm_seq *seq = &stfsm_seq_en_32bit_addr;
-- 
1.8.3.2

