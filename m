Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757299AbaAHN5p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 08:57:45 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:56735 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932158AbaAHNsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 08:48:41 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: computersforpeace@gmail.com, angus.clark@st.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH v4 11/37] mtd: st_spi_fsm: Search for preferred FSM message sequence configurations
Date: Wed,  8 Jan 2014 13:46:54 +0000
Message-Id: <1389188840-14306-12-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389188840-14306-1-git-send-email-lee.jones@linaro.org>
References: <1389188840-14306-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here we provide a means to traverse though all supplied FSM message
sequence configurations and pick one based on our chip's capabilities.
The first one we match will be the preferred one, as they are
presented in order of preference.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mtd/devices/st_spi_fsm.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/drivers/mtd/devices/st_spi_fsm.c b/drivers/mtd/devices/st_spi_fsm.c
index a70e916..efd8fdb 100644
--- a/drivers/mtd/devices/st_spi_fsm.c
+++ b/drivers/mtd/devices/st_spi_fsm.c
@@ -258,6 +258,18 @@ struct stfsm_seq {
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
@@ -493,6 +505,21 @@ static void stfsm_read_fifo(struct stfsm *fsm, uint32_t *buf,
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

