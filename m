Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965724AbaGRNYu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 09:24:50 -0400
Received: from bband-dyn38.178-41-141.t-com.sk ([178.41.141.38]:17937 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S965914AbaGRNSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 09:18:00 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Asai Thambi S P <asamymuthupa@micron.com>,
        Selvan Mani <smani@micron.com>, Jens Axboe <axboe@fb.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 017/170] mtip32xx: Increase timeout for STANDBY IMMEDIATE command
Date: Fri, 18 Jul 2014 14:10:22 +0200
Message-Id: <a44da38f73befbd7889c81049b5c6a1143ec8402.1405685481.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
References: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
In-Reply-To: <cover.1405685481.git.jslaby@suse.cz>
References: <cover.1405685481.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Asai Thambi S P <asamymuthupa@micron.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 670a641420a3d9586eebe7429dfeec4e7ed447aa upstream.

Increased timeout for STANDBY IMMEDIATE command to 2 minutes.

Signed-off-by: Selvan Mani <smani@micron.com>
Signed-off-by: Asai Thambi S P <asamymuthupa@micron.com>
Signed-off-by: Jens Axboe <axboe@fb.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/block/mtip32xx/mtip32xx.c | 66 +++++++++++++++++++++------------------
 1 file changed, 35 insertions(+), 31 deletions(-)

diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
index 2e98df1a5c93..6fc6beb86493 100644
--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -1493,6 +1493,37 @@ static inline void ata_swap_string(u16 *buf, unsigned int len)
 		be16_to_cpus(&buf[i]);
 }
 
+static void mtip_set_timeout(struct driver_data *dd,
+					struct host_to_dev_fis *fis,
+					unsigned int *timeout, u8 erasemode)
+{
+	switch (fis->command) {
+	case ATA_CMD_DOWNLOAD_MICRO:
+		*timeout = 120000; /* 2 minutes */
+		break;
+	case ATA_CMD_SEC_ERASE_UNIT:
+	case 0xFC:
+		if (erasemode)
+			*timeout = ((*(dd->port->identify + 90) * 2) * 60000);
+		else
+			*timeout = ((*(dd->port->identify + 89) * 2) * 60000);
+		break;
+	case ATA_CMD_STANDBYNOW1:
+		*timeout = 120000;  /* 2 minutes */
+		break;
+	case 0xF7:
+	case 0xFA:
+		*timeout = 60000;  /* 60 seconds */
+		break;
+	case ATA_CMD_SMART:
+		*timeout = 15000;  /* 15 seconds */
+		break;
+	default:
+		*timeout = MTIP_IOCTL_COMMAND_TIMEOUT_MS;
+		break;
+	}
+}
+
 /*
  * Request the device identity information.
  *
@@ -1602,6 +1633,7 @@ static int mtip_standby_immediate(struct mtip_port *port)
 	int rv;
 	struct host_to_dev_fis	fis;
 	unsigned long start;
+	unsigned int timeout;
 
 	/* Build the FIS. */
 	memset(&fis, 0, sizeof(struct host_to_dev_fis));
@@ -1609,6 +1641,8 @@ static int mtip_standby_immediate(struct mtip_port *port)
 	fis.opts	= 1 << 7;
 	fis.command	= ATA_CMD_STANDBYNOW1;
 
+	mtip_set_timeout(port->dd, &fis, &timeout, 0);
+
 	start = jiffies;
 	rv = mtip_exec_internal_command(port,
 					&fis,
@@ -1617,7 +1651,7 @@ static int mtip_standby_immediate(struct mtip_port *port)
 					0,
 					0,
 					GFP_ATOMIC,
-					15000);
+					timeout);
 	dbg_printk(MTIP_DRV_NAME "Time taken to complete standby cmd: %d ms\n",
 			jiffies_to_msecs(jiffies - start));
 	if (rv)
@@ -2156,36 +2190,6 @@ static unsigned int implicit_sector(unsigned char command,
 	}
 	return rv;
 }
-static void mtip_set_timeout(struct driver_data *dd,
-					struct host_to_dev_fis *fis,
-					unsigned int *timeout, u8 erasemode)
-{
-	switch (fis->command) {
-	case ATA_CMD_DOWNLOAD_MICRO:
-		*timeout = 120000; /* 2 minutes */
-		break;
-	case ATA_CMD_SEC_ERASE_UNIT:
-	case 0xFC:
-		if (erasemode)
-			*timeout = ((*(dd->port->identify + 90) * 2) * 60000);
-		else
-			*timeout = ((*(dd->port->identify + 89) * 2) * 60000);
-		break;
-	case ATA_CMD_STANDBYNOW1:
-		*timeout = 120000;  /* 2 minutes */
-		break;
-	case 0xF7:
-	case 0xFA:
-		*timeout = 60000;  /* 60 seconds */
-		break;
-	case ATA_CMD_SMART:
-		*timeout = 15000;  /* 15 seconds */
-		break;
-	default:
-		*timeout = MTIP_IOCTL_COMMAND_TIMEOUT_MS;
-		break;
-	}
-}
 
 /*
  * Executes a taskfile
-- 
2.0.0

