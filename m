Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753797AbaKLBXO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:23:14 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58637 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753762AbaKLBXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:23:09 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Roger Tseng <rogerable@realtek.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 3.17 041/319] mmc: rtsx_usb_sdmmc: fix incorrect last byte in R2 response
Date: Wed, 12 Nov 2014 10:12:59 +0900
Message-Id: <20141112010959.483515726@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112010952.553519040@linuxfoundation.org>
References: <20141112010952.553519040@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roger Tseng <rogerable@realtek.com>

commit 6f67cc6fd1cf339a0f19b9d4a998ec3c0123b1b6 upstream.

Current code erroneously fill the last byte of R2 response with an undefined
value. In addition, the controller actually 'offloads' the last byte
(CRC7, end bit) while receiving R2 response and thus it's impossible to get the
actual value. This could cause mmc stack to obtain inconsistent CID from the
same card after resume and misidentify it as a different card.

Fix by assigning dummy CRC and end bit: {7'b0, 1} = 0x1 to the last byte of R2.

Fixes: c7f6558d84af ("mmc: Add realtek USB sdmmc host driver")
Signed-off-by: Roger Tseng <rogerable@realtek.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/host/rtsx_usb_sdmmc.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/mmc/host/rtsx_usb_sdmmc.c
+++ b/drivers/mmc/host/rtsx_usb_sdmmc.c
@@ -435,6 +435,13 @@ static void sd_send_cmd_get_rsp(struct r
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


