Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755923AbaEHVtZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 17:49:25 -0400
Received: from mailout.micron.com ([137.201.242.129]:53341 "EHLO
	mailout.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755461AbaEHVtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 17:49:24 -0400
Message-ID: <536BFBE1.8020503@micron.com>
Date: Thu, 8 May 2014 14:49:21 -0700
From: Asai Thambi S P <asamymuthupa@micron.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:28.0) Gecko/20100101 Thunderbird/28.0
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        Sam Bradshaw <sbradshaw@micron.com>, Selvan Mani <smani@micron.com>
Subject: mtip32xx: fix incorrectly setting MTIP_DDF_SEC_LOCK_BIT
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-TM-AS-Product-Ver: SMEX-10.0.0.4152-7.000.1014-20682.002
X-TM-AS-Result: No--1.553600-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-MT-CheckInternalSenderRule: True
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Fix incorrectly setting MTIP_DDF_SEC_LOCK_BIT

Signed-off-by: Selvan Mani <smani@micron.com>
Signed-off-by: Asai Thambi S P <asamymuthupa@micron.com>
---
 drivers/block/mtip32xx/mtip32xx.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
index fb62446..7dc4fb4 100644
--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -1236,15 +1236,11 @@ static bool mtip_pause_ncq(struct mtip_port *port,
 	reply = port->rxfis + RX_FIS_D2H_REG;
 	task_file_data = readl(port->mmio+PORT_TFDATA);
 
-	if (fis->command == ATA_CMD_SEC_ERASE_UNIT)
-		clear_bit(MTIP_DDF_SEC_LOCK_BIT, &port->dd->dd_flag);
-
 	if ((task_file_data & 1))
 		return false;
 
 	if (fis->command == ATA_CMD_SEC_ERASE_PREP) {
 		set_bit(MTIP_PF_SE_ACTIVE_BIT, &port->flags);
-		set_bit(MTIP_DDF_SEC_LOCK_BIT, &port->dd->dd_flag);
 		port->ic_pause_timer = jiffies;
 		return true;
 	} else if ((fis->command == ATA_CMD_DOWNLOAD_MICRO) &&
@@ -1256,6 +1252,7 @@ static bool mtip_pause_ncq(struct mtip_port *port,
 		((fis->command == 0xFC) &&
 			(fis->features == 0x27 || fis->features == 0x72 ||
 			 fis->features == 0x62 || fis->features == 0x26))) {
+		clear_bit(MTIP_DDF_SEC_LOCK_BIT, &port->dd->dd_flag);
 		/* Com reset after secure erase or lowlevel format */
 		mtip_restart_port(port);
 		return false;
-- 
1.7.1

