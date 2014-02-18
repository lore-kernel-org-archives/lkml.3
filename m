Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756033AbaBRO4n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 09:56:43 -0500
Received: from mail-we0-f182.google.com ([74.125.82.182]:34299 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755388AbaBRO4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 09:56:38 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, DCG_UPD_stlinux_kernel@list.st.com,
        dwmw2@infradead.org, linux-mtd@lists.infradead.org,
        computersforpeace@gmail.com, Angus.Clark@st.com
Subject: [PATCH 04/35] mtd: st_spi_fsm: Supply framework for device requests
Date: Tue, 18 Feb 2014 14:55:31 +0000
Message-Id: <1392735362-1245-5-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1392735362-1245-1-git-send-email-lee.jones@linaro.org>
References: <1392735362-1245-1-git-send-email-lee.jones@linaro.org>
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
index 40952f9..ac6b782 100644
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

