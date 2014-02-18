Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756329AbaBRPBE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 10:01:04 -0500
Received: from mail-wg0-f52.google.com ([74.125.82.52]:62728 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932272AbaBRO5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 09:57:36 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, DCG_UPD_stlinux_kernel@list.st.com,
        dwmw2@infradead.org, linux-mtd@lists.infradead.org,
        computersforpeace@gmail.com, Angus.Clark@st.com
Subject: [PATCH 26/35] mtd: st_spi_fsm: Write to Flash via the FSM FIFO
Date: Tue, 18 Feb 2014 14:55:53 +0000
Message-Id: <1392735362-1245-27-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1392735362-1245-1-git-send-email-lee.jones@linaro.org>
References: <1392735362-1245-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we write data to the FIFO the FSM Controller subsequently writes
that data out to the Serial Flash chip.

Acked-by Angus Clark <angus.clark@st.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mtd/devices/st_spi_fsm.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/mtd/devices/st_spi_fsm.c b/drivers/mtd/devices/st_spi_fsm.c
index e4815fe..ea55548 100644
--- a/drivers/mtd/devices/st_spi_fsm.c
+++ b/drivers/mtd/devices/st_spi_fsm.c
@@ -668,6 +668,20 @@ static void stfsm_read_fifo(struct stfsm *fsm, uint32_t *buf,
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

