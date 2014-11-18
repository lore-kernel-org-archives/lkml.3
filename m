Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932196AbaKROJz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 09:09:55 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57164 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932103AbaKROJo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:09:44 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Roger Tseng <rogerable@realtek.com>,
        Ulf Hansson <ulf.hansson@linaro.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 058/206] mmc: rtsx_pci_sdmmc: fix incorrect last byte in R2 response
Date: Tue, 18 Nov 2014 15:06:53 +0100
Message-Id: <87394e735e609660eceb70e505f6d8b7c7a1eaba.1416319692.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
References: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
In-Reply-To: <cover.1416319692.git.jslaby@suse.cz>
References: <cover.1416319692.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roger Tseng <rogerable@realtek.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit d1419d50c1bf711e9fd27b516a739c86b23f7cf9 upstream.

Current code erroneously fill the last byte of R2 response with an undefined
value. In addition, the controller actually 'offloads' the last byte
(CRC7, end bit) while receiving R2 response and thus it's impossible to get the
actual value. This could cause mmc stack to obtain inconsistent CID from the
same card after resume and misidentify it as a different card.

Fix by assigning dummy CRC and end bit: {7'b0, 1} = 0x1 to the last byte of R2.

Fixes: ff984e57d36e ("mmc: Add realtek pcie sdmmc host driver")
Signed-off-by: Roger Tseng <rogerable@realtek.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/mmc/host/rtsx_pci_sdmmc.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/mmc/host/rtsx_pci_sdmmc.c b/drivers/mmc/host/rtsx_pci_sdmmc.c
index 54e8ba45c3ad..2985efd7bdb2 100644
--- a/drivers/mmc/host/rtsx_pci_sdmmc.c
+++ b/drivers/mmc/host/rtsx_pci_sdmmc.c
@@ -342,6 +342,13 @@ static void sd_send_cmd_get_rsp(struct realtek_pci_sdmmc *host,
 	}
 
 	if (rsp_type == SD_RSP_TYPE_R2) {
+		/*
+		 * The controller offloads the last byte {CRC-7, end bit 1'b1}
+		 * of response type R2. Assign dummy CRC, 0, and end bit to the
+		 * byte(ptr[16], goes into the LSB of resp[3] later).
+		 */
+		ptr[16] = 1;
+
 		for (i = 0; i < 4; i++) {
 			cmd->resp[i] = get_unaligned_be32(ptr + 1 + i * 4);
 			dev_dbg(sdmmc_dev(host), "cmd->resp[%d] = 0x%08x\n",
-- 
2.1.3

