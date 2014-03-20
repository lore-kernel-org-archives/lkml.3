Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757263AbaCTJbO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 05:31:14 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:57754 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757165AbaCTJVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 05:21:41 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        computersforpeace@gmail.com
Cc: linux-mtd@lists.infradead.org, dwmw2@infradead.org, Angus.Clark@st.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH v6 10/36] mtd: st_spi_fsm: Search for preferred FSM message sequence configurations
Date: Thu, 20 Mar 2014 09:20:42 +0000
Message-Id: <1395307268-12721-11-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1395307268-12721-1-git-send-email-lee.jones@linaro.org>
References: <1395307268-12721-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here we provide a means to traverse though all supplied FSM message
sequence configurations and pick one based on our chip's capabilities.
The first one we match will be the preferred one, as they are
presented in order of preference.

Acked-by Angus Clark <angus.clark@st.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mtd/devices/st_spi_fsm.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/drivers/mtd/devices/st_spi_fsm.c b/drivers/mtd/devices/st_spi_fsm.c
index 9467585..2740ae1 100644
--- a/drivers/mtd/devices/st_spi_fsm.c
+++ b/drivers/mtd/devices/st_spi_fsm.c
@@ -222,6 +222,18 @@ struct stfsm_seq {
 	uint32_t seq_cfg;
 } __packed __aligned(4);
 
+/* Parameters to configure a READ or WRITE FSM sequence */
+struct seq_rw_config {
+	uint32_t        flags;          /* flags to support config */
+	uint8_t         cmd;            /* FLASH command */
+	int             write;          /* Write Sequence */
+	uint8_t         addr_pads;      /* No. of addr pads (MODE & DUMMY) */
+	uint8_t         data_pads;      /* No. of data pads */
+	uint8_t         mode_data;      /* MODE data */
+	uint8_t         mode_cycles;    /* No. of MODE cycles */
+	uint8_t         dummy_cycles;   /* No. of DUMMY cycles */
+};
+
 /* SPI Flash Device Table */
 struct flash_info {
 	char            *name;
@@ -462,6 +474,21 @@ static void stfsm_read_fifo(struct stfsm *fsm, uint32_t *buf,
 	}
 }
 
+/* Search for preferred configuration based on available flags */
+static struct seq_rw_config *
+stfsm_search_seq_rw_configs(struct stfsm *fsm,
+			    struct seq_rw_config cfgs[])
+{
+	struct seq_rw_config *config;
+	int flags = fsm->info->flags;
+
+	for (config = cfgs; config->cmd != 0; config++)
+		if ((config->flags & flags) == config->flags)
+			return config;
+
+	return NULL;
+}
+
 static void stfsm_read_jedec(struct stfsm *fsm, uint8_t *const jedec)
 {
 	const struct stfsm_seq *seq = &stfsm_seq_read_jedec;
-- 
1.8.3.2

