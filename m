Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757701AbaCTJdF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 05:33:05 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:63083 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756350AbaCTJV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 05:21:26 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        computersforpeace@gmail.com
Cc: linux-mtd@lists.infradead.org, dwmw2@infradead.org, Angus.Clark@st.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH v6 04/36] mtd: st_spi_fsm: Supply framework for device requests
Date: Thu, 20 Mar 2014 09:20:36 +0000
Message-Id: <1395307268-12721-5-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1395307268-12721-1-git-send-email-lee.jones@linaro.org>
References: <1395307268-12721-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The FSM hardware works by setting a predetermined sequence of register
writes. Rather than open coding them inside each functional block we're
going to define them in a series of formatted 'sequence structures'.
This patch provides the framework which shall be used for every action.

Acked-by Angus Clark <angus.clark@st.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mtd/devices/st_spi_fsm.c | 56 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 56 insertions(+)

diff --git a/drivers/mtd/devices/st_spi_fsm.c b/drivers/mtd/devices/st_spi_fsm.c
index 7048ea7..5e22c86 100644
--- a/drivers/mtd/devices/st_spi_fsm.c
+++ b/drivers/mtd/devices/st_spi_fsm.c
@@ -194,6 +194,8 @@
 
 #define STFSM_FLASH_SAFE_FREQ  10000000UL                         /* 10 MHz */
 
+#define STFSM_MAX_WAIT_SEQ_MS  1000     /* FSM execution time */
+
 struct stfsm {
 	struct device		*dev;
 	void __iomem		*base;
@@ -204,6 +206,24 @@ struct stfsm {
 	uint32_t                fifo_dir_delay;
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
+} __packed __aligned(4);
+
+static inline int stfsm_is_idle(struct stfsm *fsm)
+{
+	return readl(fsm->base + SPI_FAST_SEQ_STA) & 0x10;
+}
+
 static inline uint32_t stfsm_fifo_available(struct stfsm *fsm)
 {
 	return (readl(fsm->base + SPI_FAST_SEQ_STA) >> 5) & 0x7f;
@@ -225,6 +245,42 @@ static void stfsm_clear_fifo(struct stfsm *fsm)
 	}
 }
 
+static inline void stfsm_load_seq(struct stfsm *fsm,
+				  const struct stfsm_seq *seq)
+{
+	void __iomem *dst = fsm->base + SPI_FAST_SEQ_TRANSFER_SIZE;
+	const uint32_t *src = (const uint32_t *)seq;
+	int words = sizeof(*seq) / sizeof(*src);
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
+	unsigned long deadline;
+	int timeout = 0;
+
+	deadline = jiffies + msecs_to_jiffies(STFSM_MAX_WAIT_SEQ_MS);
+
+	while (!timeout) {
+		if (time_after_eq(jiffies, deadline))
+			timeout = 1;
+
+		if (stfsm_is_idle(fsm))
+			return;
+
+		cond_resched();
+	}
+
+	dev_err(fsm->dev, "timeout on sequence completion\n");
+}
+
 static int stfsm_set_mode(struct stfsm *fsm, uint32_t mode)
 {
 	int ret, timeout = 10;
-- 
1.8.3.2

