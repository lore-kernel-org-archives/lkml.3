Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755543AbaCCTQx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 14:16:53 -0500
Received: from mail-qa0-f47.google.com ([209.85.216.47]:35619 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755254AbaCCTQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 14:16:50 -0500
From: Johnson Thomas <johnsonthomas@nanometrics.ca>
To: cjb@laptop.org
Cc: dbrownell@users.sourceforge.net, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, johnsonthomas@nanometrics.ca,
        jamesnuss@nanometrics.ca
Subject: [PATCH] mmc: mmc_spi: synchronize STOP_TRANSMISSION with next data token during block reads
Date: Mon,  3 Mar 2014 14:17:11 -0500
Message-Id: <1393874231-21929-1-git-send-email-johnsonthomas@nanometrics.ca>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Certain SD cards respond with an invalid response (ie,. response
not defined in the SD protocol) during block reads when the
OUT_OF_RANGE data token is sent back from the card at the same time
as the host sends a STOP_TRANSMISSION command (CMD12). As a result,
the card enters a bad state which leads to rejecting any subsequent
commands until the card is reset.

Synchronize with the subsequent data token for every block read before
issuing a STOP_TRANSMISSION command (CMD12). The synchronization is
done by issuing 0xff bytes until a data token is received.

Signed-off-by: Johnson Thomas <johnsonthomas@nanometrics.ca>
---
 drivers/mmc/host/mmc_spi.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/mmc/host/mmc_spi.c b/drivers/mmc/host/mmc_spi.c
index 7c1e16a..7703a15 100644
--- a/drivers/mmc/host/mmc_spi.c
+++ b/drivers/mmc/host/mmc_spi.c
@@ -984,6 +984,14 @@ mmc_spi_data_do(struct mmc_spi_host *host, struct mmc_command *cmd,
 		}
 	}
 
+	if (direction == DMA_FROM_DEVICE && multiple) {
+		int status = mmc_spi_readtoken(host, timeout);
+		if (status < 0)
+			dev_dbg(&spi->dev,
+				"read error for data token, returned status: 0x%02x (%d)\n",
+				status, status);
+	}
+
 	/* NOTE some docs describe an MMC-only SET_BLOCK_COUNT (CMD23) that
 	 * can be issued before multiblock writes.  Unlike its more widely
 	 * documented analogue for SD cards (SET_WR_BLK_ERASE_COUNT, ACMD23),
-- 
1.7.1

