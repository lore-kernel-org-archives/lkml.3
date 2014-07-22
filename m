Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933910AbaGVWzj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 18:55:39 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44397 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932284AbaGVWWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 18:22:37 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Selvan Mani <smani@micron.com>, Asai Thambi S P <asamymuthupa@micron.com>,
        Jens Axboe <axboe@fb.com>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 006/116] mtip32xx: Increase timeout for STANDBY IMMEDIATE command
Date: Tue, 22 Jul 2014 15:20:17 -0700
Message-Id: <1406067727-19683-7-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406067727-19683-1-git-send-email-kamal@canonical.com>
References: <1406067727-19683-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.27 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Asai Thambi S P <asamymuthupa@micron.com>

commit 670a641420a3d9586eebe7429dfeec4e7ed447aa upstream.

Increased timeout for STANDBY IMMEDIATE command to 2 minutes.

Signed-off-by: Selvan Mani <smani@micron.com>
Signed-off-by: Asai Thambi S P <asamymuthupa@micron.com>
Signed-off-by: Jens Axboe <axboe@fb.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/block/mtip32xx/mtip32xx.c | 66 +++++++++++++++++++++------------------
 1 file changed, 35 insertions(+), 31 deletions(-)

diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
index ca69cf9..6a748ff 100644
--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -1419,6 +1419,37 @@ static inline void ata_swap_string(u16 *buf, unsigned int len)
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
@@ -1520,6 +1551,7 @@ static int mtip_standby_immediate(struct mtip_port *port)
 	int rv;
 	struct host_to_dev_fis	fis;
 	unsigned long start;
+	unsigned int timeout;
 
 	/* Build the FIS. */
 	memset(&fis, 0, sizeof(struct host_to_dev_fis));
@@ -1527,6 +1559,8 @@ static int mtip_standby_immediate(struct mtip_port *port)
 	fis.opts	= 1 << 7;
 	fis.command	= ATA_CMD_STANDBYNOW1;
 
+	mtip_set_timeout(port->dd, &fis, &timeout, 0);
+
 	start = jiffies;
 	rv = mtip_exec_internal_command(port,
 					&fis,
@@ -1535,7 +1569,7 @@ static int mtip_standby_immediate(struct mtip_port *port)
 					0,
 					0,
 					GFP_ATOMIC,
-					15000);
+					timeout);
 	dbg_printk(MTIP_DRV_NAME "Time taken to complete standby cmd: %d ms\n",
 			jiffies_to_msecs(jiffies - start));
 	if (rv)
@@ -2037,36 +2071,6 @@ static unsigned int implicit_sector(unsigned char command,
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
1.9.1

