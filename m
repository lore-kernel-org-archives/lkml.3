Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754688AbaKYLlo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 06:41:44 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58383 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753149AbaKYKlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:41:24 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Roger Tseng <rogerable@realtek.com>, Ulf Hansson <ulf.hansson@linaro.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 082/254] mmc: rtsx_pci_sdmmc: fix incorrect last byte in R2 response
Date: Tue, 25 Nov 2014 10:37:12 +0000
Message-Id: <1416912004-5928-83-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roger Tseng <rogerable@realtek.com>

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/mmc/host/rtsx_pci_sdmmc.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/mmc/host/rtsx_pci_sdmmc.c b/drivers/mmc/host/rtsx_pci_sdmmc.c
index 0d519649b575..a92a0daddaaa 100644
--- a/drivers/mmc/host/rtsx_pci_sdmmc.c
+++ b/drivers/mmc/host/rtsx_pci_sdmmc.c
@@ -332,6 +332,13 @@ static void sd_send_cmd_get_rsp(struct realtek_pci_sdmmc *host,
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
2.1.0

