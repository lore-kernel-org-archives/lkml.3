Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753815Ab3FEJDY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 05:03:24 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:33564 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753429Ab3FEJBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 05:01:08 -0400
From: Johannes Schilling <of82ecuq@cip.cs.fau.de>
To: linux-kernel@vger.kernel.org
Cc: linux-kernel@i4.cs.fau.de, Al Cho <acho@novell.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Amarjargal Gundjalam <amarjargal16@gmail.com>,
        Kurt Kanzenbach <shifty91@gmail.com>, devel@driverdev.osuosl.org,
        Johannes Schilling <of82ecuq@cip.cs.fau.de>,
        Laura Lawniczak <laura.lawniczak@googlemail.com>
Subject: [PATCH 3/6] keucr: migrate printk to dev_dbg/info/warn/err
Date: Wed,  5 Jun 2013 10:50:03 +0200
Message-Id: <1370422206-14961-4-git-send-email-of82ecuq@cip.cs.fau.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1370422206-14961-1-git-send-email-of82ecuq@cip.cs.fau.de>
References: <1370422206-14961-1-git-send-email-of82ecuq@cip.cs.fau.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

as per suggestion of checkpatch.pl; this resolves warnings like "Prefer
netdev_info .. then dev_info .. to printk".

Signed-off-by: Laura Lawniczak <laura.lawniczak@googlemail.com>
Signed-off-by: Johannes Schilling <of82ecuq@cip.cs.fau.de>
---
 drivers/staging/keucr/init.c     |   62 ++++++++++++++++++--------------------
 drivers/staging/keucr/scsiglue.c |    2 +-
 drivers/staging/keucr/smilsub.c  |   14 ++++-----
 drivers/staging/keucr/smscsi.c   |    6 ++--
 4 files changed, 41 insertions(+), 43 deletions(-)

diff --git a/drivers/staging/keucr/init.c b/drivers/staging/keucr/init.c
index a0fdffd..0e8ced1 100644
--- a/drivers/staging/keucr/init.c
+++ b/drivers/staging/keucr/init.c
@@ -19,13 +19,13 @@ int ENE_InitMedia(struct us_data *us)
 	int	result;
 	BYTE	MiscReg03 = 0;
 
-	printk(KERN_INFO "--- Init Media ---\n");
+	dev_info("--- Init Media ---\n");
 	result = ene_read_byte(us, REG_CARD_STATUS, &MiscReg03);
 	if (result != USB_STOR_XFER_GOOD) {
-		printk(KERN_ERR "Read register fail !!\n");
+		dev_err("Read register fail !!\n");
 		return USB_STOR_TRANSPORT_ERROR;
 	}
-	printk(KERN_INFO "MiscReg03 = %x\n", MiscReg03);
+	dev_info("MiscReg03 = %x\n", MiscReg03);
 
 	if (MiscReg03 & 0x02) {
 		if (!us->SM_Status.Ready && !us->MS_Status.Ready) {
@@ -67,11 +67,11 @@ int ENE_SMInit(struct us_data *us)
 	int	result;
 	BYTE	buf[0x200];
 
-	printk(KERN_INFO "transport --- ENE_SMInit\n");
+	dev_info("transport --- ENE_SMInit\n");
 
 	result = ENE_LoadBinCode(us, SM_INIT_PATTERN);
 	if (result != USB_STOR_XFER_GOOD) {
-		printk(KERN_INFO "Load SM Init Code Fail !!\n");
+		dev_info("Load SM Init Code Fail !!\n");
 		return USB_STOR_TRANSPORT_ERROR;
 	}
 
@@ -84,8 +84,7 @@ int ENE_SMInit(struct us_data *us)
 
 	result = ENE_SendScsiCmd(us, FDIR_READ, &buf, 0);
 	if (result != USB_STOR_XFER_GOOD) {
-		printk(KERN_ERR
-		       "Execution SM Init Code Fail !! result = %x\n", result);
+		dev_err("Execution SM Init Code Fail !! result = %x\n", result);
 		return USB_STOR_TRANSPORT_ERROR;
 	}
 
@@ -95,15 +94,15 @@ int ENE_SMInit(struct us_data *us)
 	us->SM_CardID   = buf[2];
 
 	if (us->SM_Status.Insert && us->SM_Status.Ready) {
-		printk(KERN_INFO "Insert     = %x\n", us->SM_Status.Insert);
-		printk(KERN_INFO "Ready      = %x\n", us->SM_Status.Ready);
-		printk(KERN_INFO "WtP        = %x\n", us->SM_Status.WtP);
-		printk(KERN_INFO "DeviceID   = %x\n", us->SM_DeviceID);
-		printk(KERN_INFO "CardID     = %x\n", us->SM_CardID);
+		dev_info("Insert     = %x\n", us->SM_Status.Insert);
+		dev_info("Ready      = %x\n", us->SM_Status.Ready);
+		dev_info("WtP        = %x\n", us->SM_Status.WtP);
+		dev_info("DeviceID   = %x\n", us->SM_DeviceID);
+		dev_info("CardID     = %x\n", us->SM_CardID);
 		media_change = 1;
 		check_d_media_fmt(us);
 	} else {
-		printk(KERN_ERR "SM Card Not Ready --- %x\n", buf[0]);
+		dev_err("SM Card Not Ready --- %x\n", buf[0]);
 		return USB_STOR_TRANSPORT_ERROR;
 	}
 
@@ -120,7 +119,7 @@ int ENE_LoadBinCode(struct us_data *us, BYTE flag)
 	/* void *buf; */
 	PBYTE buf;
 
-	/* printk(KERN_INFO "transport --- ENE_LoadBinCode\n"); */
+	/* dev_info("transport --- ENE_LoadBinCode\n"); */
 	if (us->BIN_FLAG == flag)
 		return USB_STOR_TRANSPORT_GOOD;
 
@@ -130,11 +129,11 @@ int ENE_LoadBinCode(struct us_data *us, BYTE flag)
 	switch (flag) {
 	/* For SS */
 	case SM_INIT_PATTERN:
-		printk(KERN_INFO "SM_INIT_PATTERN\n");
+		dev_info("SM_INIT_PATTERN\n");
 		memcpy(buf, sm_init, 0x800);
 		break;
 	case SM_RW_PATTERN:
-		printk(KERN_INFO "SM_RW_PATTERN\n");
+		dev_info("SM_RW_PATTERN\n");
 		memcpy(buf, sm_rdwr, 0x800);
 		break;
 	}
@@ -165,12 +164,12 @@ int ENE_SendScsiCmd(struct us_data *us, BYTE fDir, void *buf, int use_sg)
 		     cswlen = 0, partial = 0;
 	unsigned int residue;
 
-	/* printk(KERN_INFO "transport --- ENE_SendScsiCmd\n"); */
+	/* dev_info("transport --- ENE_SendScsiCmd\n"); */
 	/* send cmd to out endpoint */
 	result = usb_stor_bulk_transfer_buf(us, us->send_bulk_pipe,
 					    bcb, US_BULK_CB_WRAP_LEN, NULL);
 	if (result != USB_STOR_XFER_GOOD) {
-		printk(KERN_ERR "send cmd to out endpoint fail ---\n");
+		dev_err("send cmd to out endpoint fail ---\n");
 		return USB_STOR_TRANSPORT_ERROR;
 	}
 
@@ -189,7 +188,7 @@ int ENE_SendScsiCmd(struct us_data *us, BYTE fDir, void *buf, int use_sg)
 			result = usb_stor_bulk_transfer_sg(us, pipe, buf,
 						transfer_length, 0, &partial);
 		if (result != USB_STOR_XFER_GOOD) {
-			printk(KERN_ERR "data transfer fail ---\n");
+			dev_err("data transfer fail ---\n");
 			return USB_STOR_TRANSPORT_ERROR;
 		}
 	}
@@ -199,14 +198,14 @@ int ENE_SendScsiCmd(struct us_data *us, BYTE fDir, void *buf, int use_sg)
 						US_BULK_CS_WRAP_LEN, &cswlen);
 
 	if (result == USB_STOR_XFER_SHORT && cswlen == 0) {
-		printk(KERN_WARNING "Received 0-length CSW; retrying...\n");
+		dev_warn("Received 0-length CSW; retrying...\n");
 		result = usb_stor_bulk_transfer_buf(us, us->recv_bulk_pipe,
 					bcs, US_BULK_CS_WRAP_LEN, &cswlen);
 	}
 
 	if (result == USB_STOR_XFER_STALLED) {
 		/* get the status again */
-		printk(KERN_WARNING "Attempting to get CSW (2nd try)...\n");
+		dev_warn("Attempting to get CSW (2nd try)...\n");
 		result = usb_stor_bulk_transfer_buf(us, us->recv_bulk_pipe,
 						bcs, US_BULK_CS_WRAP_LEN, NULL);
 	}
@@ -243,7 +242,7 @@ int ENE_Read_Data(struct us_data *us, void *buf, unsigned int length)
 	struct bulk_cs_wrap *bcs = (struct bulk_cs_wrap *) us->iobuf;
 	int result;
 
-	/* printk(KERN_INFO "transport --- ENE_Read_Data\n"); */
+	/* dev_info("transport --- ENE_Read_Data\n"); */
 	/* set up the command wrapper */
 	memset(bcb, 0, sizeof(struct bulk_cb_wrap));
 	bcb->Signature = cpu_to_le32(US_BULK_CB_SIGN);
@@ -333,37 +332,36 @@ void usb_stor_print_cmd(struct scsi_cmnd *srb)
 
 	switch (cmd) {
 	case TEST_UNIT_READY:
-		/* printk(KERN_INFO
+		/* dev_info(
 			 "scsi cmd %X --- SCSIOP_TEST_UNIT_READY\n", cmd); */
 		break;
 	case INQUIRY:
-		printk(KERN_INFO "scsi cmd %X --- SCSIOP_INQUIRY\n", cmd);
+		dev_info("scsi cmd %X --- SCSIOP_INQUIRY\n", cmd);
 		break;
 	case MODE_SENSE:
-		printk(KERN_INFO "scsi cmd %X --- SCSIOP_MODE_SENSE\n", cmd);
+		dev_info("scsi cmd %X --- SCSIOP_MODE_SENSE\n", cmd);
 		break;
 	case START_STOP:
-		printk(KERN_INFO "scsi cmd %X --- SCSIOP_START_STOP\n", cmd);
+		dev_info("scsi cmd %X --- SCSIOP_START_STOP\n", cmd);
 		break;
 	case READ_CAPACITY:
-		printk(KERN_INFO "scsi cmd %X --- SCSIOP_READ_CAPACITY\n", cmd);
+		dev_info("scsi cmd %X --- SCSIOP_READ_CAPACITY\n", cmd);
 		break;
 	case READ_10:
-		/*  printk(KERN_INFO
+		/*  dev_info(
 			   "scsi cmd %X --- SCSIOP_READ,bn = %X, blen = %X\n"
 			   ,cmd, bn, blen); */
 		break;
 	case WRITE_10:
-		/* printk(KERN_INFO
+		/* dev_info(
 			  "scsi cmd %X --- SCSIOP_WRITE,
 			  bn = %X, blen = %X\n" , cmd, bn, blen); */
 		break;
 	case ALLOW_MEDIUM_REMOVAL:
-		printk(KERN_INFO
-			"scsi cmd %X --- SCSIOP_ALLOW_MEDIUM_REMOVAL\n", cmd);
+		dev_info("scsi cmd %X --- SCSIOP_ALLOW_MEDIUM_REMOVAL\n", cmd);
 		break;
 	default:
-		printk(KERN_INFO "scsi cmd %X --- Other cmd\n", cmd);
+		dev_info("scsi cmd %X --- Other cmd\n", cmd);
 		break;
 	}
 	bn = 0;
diff --git a/drivers/staging/keucr/scsiglue.c b/drivers/staging/keucr/scsiglue.c
index 2894ce7..7f0cf1a 100644
--- a/drivers/staging/keucr/scsiglue.c
+++ b/drivers/staging/keucr/scsiglue.c
@@ -145,7 +145,7 @@ static int command_abort(struct scsi_cmnd *srb)
 	scsi_lock(us_to_host(us));
 	if (us->srb != srb) {
 		scsi_unlock(us_to_host(us));
-		printk("-- nothing to abort\n");
+		dev_info("-- nothing to abort\n");
 		return FAILED;
 	}
 
diff --git a/drivers/staging/keucr/smilsub.c b/drivers/staging/keucr/smilsub.c
index b10e8c2..d5e289b 100644
--- a/drivers/staging/keucr/smilsub.c
+++ b/drivers/staging/keucr/smilsub.c
@@ -214,7 +214,7 @@ int Ssfdc_D_ReadSect(struct us_data *us, BYTE *buf, BYTE *redundant)
 
 	result = ENE_LoadBinCode(us, SM_RW_PATTERN);
 	if (result != USB_STOR_XFER_GOOD) {
-		printk("Load SM RW Code Fail !!\n");
+		dev_err("Load SM RW Code Fail !!\n");
 		return USB_STOR_TRANSPORT_ERROR;
 	}
 
@@ -266,7 +266,7 @@ int Ssfdc_D_ReadBlock(struct us_data *us, WORD count, BYTE *buf,
 
 	result = ENE_LoadBinCode(us, SM_RW_PATTERN);
 	if (result != USB_STOR_XFER_GOOD) {
-		printk("Load SM RW Code Fail !!\n");
+		dev_err("Load SM RW Code Fail !!\n");
 		return USB_STOR_TRANSPORT_ERROR;
 	}
 
@@ -319,7 +319,7 @@ int Ssfdc_D_CopyBlock(struct us_data *us, WORD count, BYTE *buf,
 
 	result = ENE_LoadBinCode(us, SM_RW_PATTERN);
 	if (result != USB_STOR_XFER_GOOD) {
-		printk("Load SM RW Code Fail !!\n");
+		dev_err("Load SM RW Code Fail !!\n");
 		return USB_STOR_TRANSPORT_ERROR;
 	}
 
@@ -365,7 +365,7 @@ int Ssfdc_D_WriteSectForCopy(struct us_data *us, BYTE *buf, BYTE *redundant)
 
 	result = ENE_LoadBinCode(us, SM_RW_PATTERN);
 	if (result != USB_STOR_XFER_GOOD) {
-		printk("Load SM RW Code Fail !!\n");
+		dev_err("Load SM RW Code Fail !!\n");
 		return USB_STOR_TRANSPORT_ERROR;
 	}
 
@@ -403,7 +403,7 @@ int Ssfdc_D_EraseBlock(struct us_data *us)
 
 	result = ENE_LoadBinCode(us, SM_RW_PATTERN);
 	if (result != USB_STOR_XFER_GOOD) {
-		printk("Load SM RW Code Fail !!\n");
+		dev_err("Load SM RW Code Fail !!\n");
 		return USB_STOR_TRANSPORT_ERROR;
 	}
 
@@ -438,7 +438,7 @@ int Ssfdc_D_ReadRedtData(struct us_data *us, BYTE *redundant)
 
 	result = ENE_LoadBinCode(us, SM_RW_PATTERN);
 	if (result != USB_STOR_XFER_GOOD) {
-		printk("Load SM RW Code Fail !!\n");
+		dev_err("Load SM RW Code Fail !!\n");
 		return USB_STOR_TRANSPORT_ERROR;
 	}
 
@@ -477,7 +477,7 @@ int Ssfdc_D_WriteRedtData(struct us_data *us, BYTE *redundant)
 
 	result = ENE_LoadBinCode(us, SM_RW_PATTERN);
 	if (result != USB_STOR_XFER_GOOD) {
-		printk("Load SM RW Code Fail !!\n");
+		dev_err("Load SM RW Code Fail !!\n");
 		return USB_STOR_TRANSPORT_ERROR;
 	}
 
diff --git a/drivers/staging/keucr/smscsi.c b/drivers/staging/keucr/smscsi.c
index cda2447..9f27b2b 100644
--- a/drivers/staging/keucr/smscsi.c
+++ b/drivers/staging/keucr/smscsi.c
@@ -109,14 +109,14 @@ int SM_SCSI_Read_Capacity(struct us_data *us, struct scsi_cmnd *srb)
 	WORD    bl_len;
 	BYTE    buf[8];
 
-	printk("SM_SCSI_Read_Capacity\n");
+	dev_dbg("SM_SCSI_Read_Capacity\n");
 
 	bl_len = 0x200;
 	bl_num = Ssfdc.MaxLogBlocks * Ssfdc.MaxSectors * Ssfdc.MaxZones - 1;
 
 	us->bl_num = bl_num;
-	printk("bl_len = %x\n", bl_len);
-	printk("bl_num = %x\n", bl_num);
+	dev_dbg("bl_len = %x\n", bl_len);
+	dev_dbg("bl_num = %x\n", bl_num);
 
 	buf[0] = (bl_num >> 24) & 0xff;
 	buf[1] = (bl_num >> 16) & 0xff;
-- 
1.7.10.4

