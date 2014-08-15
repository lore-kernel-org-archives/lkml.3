Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754266AbaHOGGK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 02:06:10 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:44381 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752482AbaHOGFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 02:05:54 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.39 with qID s7F65LgZ011311, This message is accepted by code: ctloc85258
From: <rogerable@realtek.com>
To: Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <rogerable@realtek.com>, Dan Carpenter <dan.carpenter@oracle.com>,
        <linux-kernel@vger.kernel.org>, <linux-mmc@vger.kernel.org>,
        <driverdev-devel@linuxdriverproject.org>, <wei_wang@realsil.com.cn>,
        <micky_ching@realsil.com.cn>
Subject: [PATCH 2/2] mmc: rtsx_usb_sdmmc: fix incorrect last byte in R2 response
Date: Fri, 15 Aug 2014 14:06:01 +0800
Message-ID: <1408082761-15333-3-git-send-email-rogerable@realtek.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1408082761-15333-1-git-send-email-rogerable@realtek.com>
References: <1408082761-15333-1-git-send-email-rogerable@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.81.121]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roger Tseng <rogerable@realtek.com>

Current code erroneously fill the last byte of R2 response with an undefined
value. In addition, the controller actually 'offloads' the last byte
(CRC7, end bit) while receiving R2 response and thus it's impossible to get the
actual value. This could cause mmc stack to obtain inconsistent CID from the
same card after resume and misidentify it as a different card.

Fix by assigning dummy CRC and end bit: {7'b0, 1} = 0x1 to the last byte of R2.

Cc: <stable@vger.kernel.org> # v3.16+
Fixes: c7f6558d84af ("mmc: Add realtek USB sdmmc host driver")
Signed-off-by: Roger Tseng <rogerable@realtek.com>
---
 drivers/mmc/host/rtsx_usb_sdmmc.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/mmc/host/rtsx_usb_sdmmc.c b/drivers/mmc/host/rtsx_usb_sdmmc.c
index 5d3766e792f0..d9153a7d160d 100644
--- a/drivers/mmc/host/rtsx_usb_sdmmc.c
+++ b/drivers/mmc/host/rtsx_usb_sdmmc.c
@@ -435,6 +435,13 @@ static void sd_send_cmd_get_rsp(struct rtsx_usb_sdmmc *host,
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
1.7.10.4

