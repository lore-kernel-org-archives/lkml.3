Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757175Ab3K2M0o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 07:26:44 -0500
Received: from mail-yh0-f44.google.com ([209.85.213.44]:49884 "EHLO
	mail-yh0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755155Ab3K2MT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 07:19:57 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        dwmw2@infradead.org
Cc: linus.walleij@linaro.org, linux-mtd@lists.infradead.org,
        angus.clark@st.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH v3 11/36] mtd: st_spi_fsm: Search for preferred FSM message sequence configurations
Date: Fri, 29 Nov 2013 12:19:00 +0000
Message-Id: <1385727565-25794-12-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1385727565-25794-1-git-send-email-lee.jones@linaro.org>
References: <1385727565-25794-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here we provide a means to traverse though all supplied FSM message
sequence configurations and pick one based on our chip's capabilities.
The first one we match will be the preferred one, as they are
presented in order of preference.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mtd/devices/st_spi_fsm.c | 15 +++++++++++++++
 drivers/mtd/devices/st_spi_fsm.h | 12 ++++++++++++
 2 files changed, 27 insertions(+)

diff --git a/drivers/mtd/devices/st_spi_fsm.c b/drivers/mtd/devices/st_spi_fsm.c
index ef177e5..5f21d14 100644
--- a/drivers/mtd/devices/st_spi_fsm.c
+++ b/drivers/mtd/devices/st_spi_fsm.c
@@ -124,6 +124,21 @@ static void stfsm_read_fifo(struct stfsm *fsm, uint32_t *buf,
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
+	for (config = cfgs; cfgs->cmd != 0; config++)
+		if ((config->flags & flags) == config->flags)
+			return config;
+
+	return NULL;
+}
+
 static void stfsm_read_jedec(struct stfsm *fsm, uint8_t *const jedec)
 {
 	const struct stfsm_seq *seq = &stfsm_seq_read_jedec;
diff --git a/drivers/mtd/devices/st_spi_fsm.h b/drivers/mtd/devices/st_spi_fsm.h
index 0a6272c..6fafa07 100644
--- a/drivers/mtd/devices/st_spi_fsm.h
+++ b/drivers/mtd/devices/st_spi_fsm.h
@@ -254,6 +254,18 @@ struct stfsm_seq {
 } __attribute__((__packed__, aligned(4)));
 #define STFSM_SEQ_SIZE sizeof(struct stfsm_seq)
 
+/* Parameters to configure a READ or WRITE FSM sequence */
+struct seq_rw_config {
+	uint32_t	flags;		/* flags to support config */
+	uint8_t		cmd;		/* FLASH command */
+	int		write;		/* Write Sequence */
+	uint8_t		addr_pads;	/* No. of addr pads (MODE & DUMMY) */
+	uint8_t		data_pads;	/* No. of data pads */
+	uint8_t		mode_data;	/* MODE data */
+	uint8_t		mode_cycles;	/* No. of MODE cycles */
+	uint8_t		dummy_cycles;	/* No. of DUMMY cycles */
+};
+
 /* SPI Flash Device Table */
 struct flash_info {
 	char		*name;
-- 
1.8.3.2

