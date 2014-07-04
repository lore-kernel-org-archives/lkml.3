Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031859AbaGDXHI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 19:07:08 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56992 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760406AbaGDWQA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 18:16:00 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Selvan Mani <smani@micron.com>,
        Asai Thambi S P <asamymuthupa@micron.com>, Jens Axboe <axboe@fb.com>
Subject: [PATCH 3.15 11/66] mtip32xx: Increase timeout for STANDBY IMMEDIATE command
Date: Fri,  4 Jul 2014 15:14:10 -0700
Message-Id: <20140704221423.344162276@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140704221422.813435485@linuxfoundation.org>
References: <20140704221422.813435485@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Asai Thambi S P <asamymuthupa@micron.com>

commit 670a641420a3d9586eebe7429dfeec4e7ed447aa upstream.

Increased timeout for STANDBY IMMEDIATE command to 2 minutes.

Signed-off-by: Selvan Mani <smani@micron.com>
Signed-off-by: Asai Thambi S P <asamymuthupa@micron.com>
Signed-off-by: Jens Axboe <axboe@fb.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/block/mtip32xx/mtip32xx.c |   66 ++++++++++++++++++++------------------
 1 file changed, 35 insertions(+), 31 deletions(-)

--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -1529,6 +1529,37 @@ static inline void ata_swap_string(u16 *
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
@@ -1644,6 +1675,7 @@ static int mtip_standby_immediate(struct
 	int rv;
 	struct host_to_dev_fis	fis;
 	unsigned long start;
+	unsigned int timeout;
 
 	/* Build the FIS. */
 	memset(&fis, 0, sizeof(struct host_to_dev_fis));
@@ -1651,6 +1683,8 @@ static int mtip_standby_immediate(struct
 	fis.opts	= 1 << 7;
 	fis.command	= ATA_CMD_STANDBYNOW1;
 
+	mtip_set_timeout(port->dd, &fis, &timeout, 0);
+
 	start = jiffies;
 	rv = mtip_exec_internal_command(port,
 					&fis,
@@ -1659,7 +1693,7 @@ static int mtip_standby_immediate(struct
 					0,
 					0,
 					GFP_ATOMIC,
-					15000);
+					timeout);
 	dbg_printk(MTIP_DRV_NAME "Time taken to complete standby cmd: %d ms\n",
 			jiffies_to_msecs(jiffies - start));
 	if (rv)
@@ -2202,36 +2236,6 @@ static unsigned int implicit_sector(unsi
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


