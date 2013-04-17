Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756982Ab3DQFo0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 01:44:26 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:44600 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753416Ab3DQFoZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 01:44:25 -0400
Message-ID: <1366177447.28609.25.camel@joe-AO722>
Subject: [PATCH] usb: storage: Add usb_stor_dbg, reduce object size
From: Joe Perches <joe@perches.com>
To: Matthew Dharm <mdharm-usb@one-eyed-alien.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb <linux-usb@vger.kernel.org>,
        usb-storage <usb-storage@lists.one-eyed-alien.net>,
        LKML <linux-kernel@vger.kernel.org>
Date: Tue, 16 Apr 2013 22:44:07 -0700
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reduce the size of the objects by consolidating
the duplicated USB_STORAGE into a single function.

Add function usb_stor_dbg to emit debugging messages.
Always validate the format and arguments.
Reduce the number of uses of CONFIG_USB_STORAGE_DEBUG.

Reduces size of objects ~7KB when CONFIG_USB_STORAGE_DEBUG
is set.

$ size drivers/usb/storage/built-in.o*
   text	   data	    bss	    dec	    hex	filename
 140133	  55296	  70312	 265741	  40e0d	drivers/usb/storage/built-in.o.new
 147494	  55248	  70296	 273038	  42a8e	drivers/usb/storage/built-in.o.old

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/usb/storage/debug.c  | 20 +++++++++++++++++++-
 drivers/usb/storage/debug.h  | 14 +++++++++-----
 drivers/usb/storage/isd200.c | 12 ++++++------
 3 files changed, 34 insertions(+), 12 deletions(-)

diff --git a/drivers/usb/storage/debug.c b/drivers/usb/storage/debug.c
index a2b5526..b428129 100644
--- a/drivers/usb/storage/debug.c
+++ b/drivers/usb/storage/debug.c
@@ -150,7 +150,7 @@ void usb_stor_show_command(struct scsi_cmnd *srb)
 	default: what = "(unknown command)"; break;
 	}
 	US_DEBUGP("Command %s (%d bytes)\n", what, srb->cmd_len);
-	US_DEBUGP("");
+	US_DEBUGP("bytes: ");
 	for (i = 0; i < srb->cmd_len && i < 16; i++)
 		US_DEBUGPX(" %02x", srb->cmnd[i]);
 	US_DEBUGPX("\n");
@@ -175,3 +175,21 @@ void usb_stor_show_sense(
 	US_DEBUGPX(what, ascq);
 	US_DEBUGPX("\n");
 }
+
+int usb_stor_dbg(const char *fmt, ...)
+{
+	struct va_format vaf;
+	va_list args;
+	int r;
+
+	va_start(args, fmt);
+
+	vaf.fmt = fmt;
+	vaf.va = &args;
+
+	r = printk(KERN_DEBUG USB_STORAGE "%pV", &vaf);
+
+	va_end(args);
+
+	return r;
+}
diff --git a/drivers/usb/storage/debug.h b/drivers/usb/storage/debug.h
index dbb985d..d4280e1 100644
--- a/drivers/usb/storage/debug.h
+++ b/drivers/usb/storage/debug.h
@@ -50,12 +50,16 @@
 void usb_stor_show_command(struct scsi_cmnd *srb);
 void usb_stor_show_sense( unsigned char key,
 		unsigned char asc, unsigned char ascq );
-#define US_DEBUGP(x...) printk( KERN_DEBUG USB_STORAGE x )
-#define US_DEBUGPX(x...) printk( x )
-#define US_DEBUG(x) x 
+__printf(1, 2) int usb_stor_dbg(const char *fmt, ...);
+
+#define US_DEBUGP(fmt, ...)	usb_stor_dbg(fmt, ##__VA_ARGS__)
+#define US_DEBUGPX(fmt, ...)	printk(fmt, ##__VA_ARGS__)
+#define US_DEBUG(x)		x
 #else
-#define US_DEBUGP(x...)
-#define US_DEBUGPX(x...)
+#define US_DEBUGP(fmt, ...)					\
+	do { if (0) printk(fmt, ##__VA_ARGS__); } while (0)
+#define US_DEBUGPX(fmt, ...)					\
+	do { if (0) printk(fmt, ##__VA_ARGS__); } while (0)
 #define US_DEBUG(x)
 #endif
 
diff --git a/drivers/usb/storage/isd200.c b/drivers/usb/storage/isd200.c
index 06a3d22..55571ae 100644
--- a/drivers/usb/storage/isd200.c
+++ b/drivers/usb/storage/isd200.c
@@ -926,10 +926,6 @@ static int isd200_try_enum(struct us_data *us, unsigned char master_slave,
 
 	/* loop until we detect !BSY or timeout */
 	while(1) {
-#ifdef CONFIG_USB_STORAGE_DEBUG
-		char* mstr = master_slave == ATA_ADDRESS_DEVHEAD_STD ?
-			"Master" : "Slave";
-#endif
 
 		status = isd200_action( us, ACTION_ENUM, NULL, master_slave );
 		if ( status != ISD200_GOOD )
@@ -942,9 +938,13 @@ static int isd200_try_enum(struct us_data *us, unsigned char master_slave,
 
 		if (!detect) {
 			if (regs[ATA_REG_STATUS_OFFSET] & ATA_BUSY) {
-				US_DEBUGP("   %s status is still BSY, try again...\n",mstr);
+				US_DEBUGP("   %s status is still BSY, try again...\n",
+					  master_slave == ATA_ADDRESS_DEVHEAD_STD ?
+					  "Master" : "Slave");
 			} else {
-				US_DEBUGP("   %s status !BSY, continue with next operation\n",mstr);
+				US_DEBUGP("   %s status !BSY, continue with next operation\n",
+					  master_slave == ATA_ADDRESS_DEVHEAD_STD ?
+					  "Master" : "Slave");
 				break;
 			}
 		}


