Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161242AbaDQD2J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 23:28:09 -0400
Received: from mailout.micron.com ([137.201.242.129]:19497 "EHLO
	mailout.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756259AbaDQD2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 23:28:07 -0400
Message-ID: <534F4A3A.5050805@micron.com>
Date: Wed, 16 Apr 2014 20:27:54 -0700
From: Asai Thambi S P <asamymuthupa@micron.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:28.0) Gecko/20100101 Thunderbird/28.0
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        Sam Bradshaw <sbradshaw@micron.com>, Selvan Mani <smani@micron.com>
Subject: mtip32xx: Increase timeout for STANDBY IMMEDIATE command
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-TM-AS-Product-Ver: SMEX-10.0.0.4152-7.000.1014-20636.003
X-TM-AS-Result: No--8.194300-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-MT-CheckInternalSenderRule: True
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Increased timeout for STANDBY IMMEDIATE command to 2 minutes.

Signed-off-by: Selvan Mani <smani@micron.com>
Signed-off-by: Asai Thambi S P <asamymuthupa@micron.com>
---
 drivers/block/mtip32xx/mtip32xx.c |   66 +++++++++++++++++++-----------------
 1 files changed, 35 insertions(+), 31 deletions(-)

diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
index 59c5abe..51628eb 100644
--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -1529,6 +1529,37 @@ static inline void ata_swap_string(u16 *buf, unsigned int len)
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
@@ -1644,6 +1675,7 @@ static int mtip_standby_immediate(struct mtip_port *port)
 	int rv;
 	struct host_to_dev_fis	fis;
 	unsigned long start;
+	unsigned int timeout;
 
 	/* Build the FIS. */
 	memset(&fis, 0, sizeof(struct host_to_dev_fis));
@@ -1651,6 +1683,8 @@ static int mtip_standby_immediate(struct mtip_port *port)
 	fis.opts	= 1 << 7;
 	fis.command	= ATA_CMD_STANDBYNOW1;
 
+	mtip_set_timeout(port->dd, &fis, &timeout, 0);
+
 	start = jiffies;
 	rv = mtip_exec_internal_command(port,
 					&fis,
@@ -1659,7 +1693,7 @@ static int mtip_standby_immediate(struct mtip_port *port)
 					0,
 					0,
 					GFP_ATOMIC,
-					15000);
+					timeout);
 	dbg_printk(MTIP_DRV_NAME "Time taken to complete standby cmd: %d ms\n",
 			jiffies_to_msecs(jiffies - start));
 	if (rv)
@@ -2202,36 +2236,6 @@ static unsigned int implicit_sector(unsigned char command,
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
1.7.1

