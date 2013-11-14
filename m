Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754190Ab3KNOXW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 09:23:22 -0500
Received: from mail-ob0-f171.google.com ([209.85.214.171]:38077 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754003Ab3KNOXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 09:23:00 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: linus.walleij@linaro.org, dwmw2@infradead.org,
        linux-mtd@lists.infradead.org, angus.clark@st.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 04/10] mtd: st_spi_fsm: Supply framework for device requests
Date: Thu, 14 Nov 2013 14:22:30 +0000
Message-Id: <1384438956-31153-5-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1384438956-31153-1-git-send-email-lee.jones@linaro.org>
References: <1384438956-31153-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The FSM hardware works by setting a predetermined sequence of register
writes. Rather than open coding them inside each functional block we're
going to define them in a series of formatted 'sequence structures'.
This patch provides the framework which shall be used for every action.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mtd/devices/st_spi_fsm.c | 49 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 49 insertions(+)

diff --git a/drivers/mtd/devices/st_spi_fsm.c b/drivers/mtd/devices/st_spi_fsm.c
index f560343..02619ee 100644
--- a/drivers/mtd/devices/st_spi_fsm.c
+++ b/drivers/mtd/devices/st_spi_fsm.c
@@ -40,11 +40,60 @@ struct stfsm {
 	uint32_t		fifo_dir_delay;
 };
 
+struct stfsm_seq {
+	uint32_t data_size;
+	uint32_t addr1;
+	uint32_t addr2;
+	uint32_t addr_cfg;
+	uint32_t seq_opc[5];
+	uint32_t mode;
+	uint32_t dummy;
+	uint32_t status;
+	uint8_t  seq[16];
+	uint32_t seq_cfg;
+} __attribute__((__packed__, aligned(4)));
+#define STFSM_SEQ_SIZE sizeof(struct stfsm_seq)
+
+static inline int stfsm_is_idle(struct stfsm *fsm)
+{
+	return readl(fsm->base + SPI_FAST_SEQ_STA) & 0x10;
+}
+
 static inline uint32_t stfsm_fifo_available(struct stfsm *fsm)
 {
 	return (readl(fsm->base + SPI_FAST_SEQ_STA) >> 5) & 0x7f;
 }
 
+static inline void stfsm_load_seq(struct stfsm *fsm,
+				  const struct stfsm_seq *seq)
+{
+	void __iomem *dst = fsm->base + SPI_FAST_SEQ_TRANSFER_SIZE;
+	const uint32_t *src = (const uint32_t *)seq;
+	int words = STFSM_SEQ_SIZE / sizeof(uint32_t);
+
+	BUG_ON(!stfsm_is_idle(fsm));
+
+	while (words--) {
+		writel(*src, dst);
+		src++;
+		dst += 4;
+	}
+}
+
+static void stfsm_wait_seq(struct stfsm *fsm)
+{
+	unsigned long timeo = jiffies + HZ;
+
+	while (time_before(jiffies, timeo)) {
+		if (stfsm_is_idle(fsm))
+			return;
+
+		cond_resched();
+	}
+
+	dev_err(fsm->dev, "timeout on sequence completion\n");
+}
+
 static void stfsm_clear_fifo(struct stfsm *fsm)
 {
 	uint32_t avail;
-- 
1.8.1.2

