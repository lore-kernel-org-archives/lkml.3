Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015Ab3FFQN0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 12:13:26 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:47601 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753552Ab3FFQLj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 12:11:39 -0400
From: Johannes Schilling <of82ecuq@cip.cs.fau.de>
To: linux-kernel@vger.kernel.org
Cc: linux-kernel@i4.cs.fau.de, Al Cho <acho@novell.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Amarjargal Gundjalam <amarjargal16@gmail.com>,
        Kurt Kanzenbach <shifty91@gmail.com>, devel@driverdev.osuosl.org,
        Laura Lawniczak <laura.lawniczak@googlemail.com>,
        Johannes Schilling <of82ecuq@cip.cs.fau.de>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH 5/6] keucr: moved function to other file
Date: Thu,  6 Jun 2013 18:10:49 +0200
Message-Id: <1370535050-7167-6-git-send-email-of82ecuq@cip.cs.fau.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1370535050-7167-1-git-send-email-of82ecuq@cip.cs.fau.de>
References: <20130605094517.GS28112@mwanda>
 <1370535050-7167-1-git-send-email-of82ecuq@cip.cs.fau.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Laura Lawniczak <laura.lawniczak@googlemail.com>

Function usb_stor_print_cmd was declared in init.c but only used
in transport.c. So it was reasonable to move it there and declare
it static

Signed-off-by: Laura Lawniczak <laura.lawniczak@googlemail.com>
---
 drivers/staging/keucr/init.c      |   51 -------------------------------------
 drivers/staging/keucr/transport.c |   50 ++++++++++++++++++++++++++++++++++++
 drivers/staging/keucr/transport.h |    1 -
 3 files changed, 50 insertions(+), 52 deletions(-)

diff --git a/drivers/staging/keucr/init.c b/drivers/staging/keucr/init.c
index 08b6c3d..53478e1 100644
--- a/drivers/staging/keucr/init.c
+++ b/drivers/staging/keucr/init.c
@@ -322,54 +322,3 @@ int ENE_Write_Data(struct us_data *us, void *buf, unsigned int length)
 	return USB_STOR_TRANSPORT_GOOD;
 }
 
-/*
- * usb_stor_print_cmd():
- */
-void usb_stor_print_cmd(struct us_data *us,struct scsi_cmnd *srb)
-{
-	PBYTE	Cdb = srb->cmnd;
-	DWORD	cmd = Cdb[0];
-	DWORD	bn  =	((Cdb[2] << 24) & 0xff000000) |
-			((Cdb[3] << 16) & 0x00ff0000) |
-			((Cdb[4] << 8) & 0x0000ff00) |
-			((Cdb[5] << 0) & 0x000000ff);
-	WORD	blen = ((Cdb[7] << 8) & 0xff00) | ((Cdb[8] << 0) & 0x00ff);
-
-	switch (cmd) {
-	case TEST_UNIT_READY:
-		/* dev_dbg(
-			 &us->pusb_dev->dev, "scsi cmd %X --- SCSIOP_TEST_UNIT_READY\n", cmd); */
-		break;
-	case INQUIRY:
-		dev_dbg(&us->pusb_dev->dev, "scsi cmd %X --- SCSIOP_INQUIRY\n", cmd);
-		break;
-	case MODE_SENSE:
-		dev_dbg(&us->pusb_dev->dev, "scsi cmd %X --- SCSIOP_MODE_SENSE\n", cmd);
-		break;
-	case START_STOP:
-		dev_dbg(&us->pusb_dev->dev, "scsi cmd %X --- SCSIOP_START_STOP\n", cmd);
-		break;
-	case READ_CAPACITY:
-		dev_dbg(&us->pusb_dev->dev, "scsi cmd %X --- SCSIOP_READ_CAPACITY\n", cmd);
-		break;
-	case READ_10:
-		/*  dev_dbg(
-			   &us->pusb_dev->dev, "scsi cmd %X --- SCSIOP_READ,bn = %X, blen = %X\n"
-			   ,cmd, bn, blen); */
-		break;
-	case WRITE_10:
-		/* dev_dbg(
-			  &us->pusb_dev->dev, "scsi cmd %X --- SCSIOP_WRITE,
-			  bn = %X, blen = %X\n" , cmd, bn, blen); */
-		break;
-	case ALLOW_MEDIUM_REMOVAL:
-		dev_dbg(&us->pusb_dev->dev, "scsi cmd %X --- SCSIOP_ALLOW_MEDIUM_REMOVAL\n", cmd);
-		break;
-	default:
-		dev_dbg(&us->pusb_dev->dev, "scsi cmd %X --- Other cmd\n", cmd);
-		break;
-	}
-	bn = 0;
-	blen = 0;
-}
-
diff --git a/drivers/staging/keucr/transport.c b/drivers/staging/keucr/transport.c
index 1de1115..b3c25d0 100644
--- a/drivers/staging/keucr/transport.c
+++ b/drivers/staging/keucr/transport.c
@@ -79,6 +79,56 @@ static int usb_stor_msg_common(struct us_data *us, int timeout)
 }
 
 /*
+ * usb_stor_print_cmd():
+ */
+static void usb_stor_print_cmd(struct us_data *us, struct scsi_cmnd *srb)
+{
+	PBYTE   Cdb = srb->cmnd;
+	DWORD   cmd = Cdb[0];
+	DWORD   bn  =   ((Cdb[2] << 24) & 0xff000000) |
+			((Cdb[3] << 16) & 0x00ff0000) |
+			((Cdb[4] << 8) & 0x0000ff00) |
+			((Cdb[5] << 0) & 0x000000ff);
+	WORD    blen = ((Cdb[7] << 8) & 0xff00) | ((Cdb[8] << 0) & 0x00ff);
+
+	switch (cmd) {
+	case TEST_UNIT_READY:
+		/* dev_dbg(
+			   &us->pusb_dev->dev, "scsi cmd %X --- SCSIOP_TEST_UNIT_READY\n", cmd); */
+		break;
+	case INQUIRY:
+		dev_dbg(&us->pusb_dev->dev, "scsi cmd %X --- SCSIOP_INQUIRY\n", cmd);
+		break;
+	case MODE_SENSE:
+		dev_dbg(&us->pusb_dev->dev, "scsi cmd %X --- SCSIOP_MODE_SENSE\n", cmd);
+		break;
+	case START_STOP:
+		dev_dbg(&us->pusb_dev->dev, "scsi cmd %X --- SCSIOP_START_STOP\n", cmd);
+		break;
+	case READ_CAPACITY:
+		dev_dbg(&us->pusb_dev->dev, "scsi cmd %X --- SCSIOP_READ_CAPACITY\n", cmd);
+		break;
+	case READ_10:
+		/*  dev_dbg(
+			    &us->pusb_dev->dev, "scsi cmd %X --- SCSIOP_READ,bn = %X, blen = %X\n"
+			    cmd, bn, blen); */
+		break;
+	case WRITE_10:
+		/* dev_dbg(
+			   &us->pusb_dev->dev, "scsi cmd %X --- SCSIOP_WRITE,
+			   bn = %X, blen = %X\n" , cmd, bn, blen); */
+		break;
+	case ALLOW_MEDIUM_REMOVAL:
+		dev_dbg(&us->pusb_dev->dev, "scsi cmd %X --- SCSIOP_ALLOW_MEDIUM_REMOVAL\n", cmd);
+		break;
+	default:
+		dev_dbg(&us->pusb_dev->dev, "scsi cmd %X --- Other cmd\n", cmd);
+		break;
+	}
+	bn = 0;
+}
+
+/*
  * usb_stor_control_msg()
  */
 int usb_stor_control_msg(struct us_data *us, unsigned int pipe,
diff --git a/drivers/staging/keucr/transport.h b/drivers/staging/keucr/transport.h
index 2cdaa49..df34474 100644
--- a/drivers/staging/keucr/transport.h
+++ b/drivers/staging/keucr/transport.h
@@ -29,7 +29,6 @@
 extern int usb_stor_Bulk_transport(struct scsi_cmnd *, struct us_data*);
 extern int usb_stor_Bulk_max_lun(struct us_data *);
 extern int usb_stor_Bulk_reset(struct us_data *);
-extern void usb_stor_print_cmd(struct us_data *, struct scsi_cmnd *);
 extern void usb_stor_invoke_transport(struct scsi_cmnd *, struct us_data*);
 extern void usb_stor_stop_transport(struct us_data *);
 extern int usb_stor_control_msg(struct us_data *us, unsigned int pipe,
-- 
1.7.10.4

