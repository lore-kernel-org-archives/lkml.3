Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965290Ab3DRDBB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 23:01:01 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:50974 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965065Ab3DRDA5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 23:00:57 -0400
Message-ID: <1366254055.28609.61.camel@joe-AO722>
Subject: [PATCH] usb: storage: Convert US_DEBUGP to usb_stor_dbg
From: Joe Perches <joe@perches.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb <linux-usb@vger.kernel.org>,
        usb-storage <usb-storage@lists.one-eyed-alien.net>,
        LKML <linux-kernel@vger.kernel.org>
Date: Wed, 17 Apr 2013 20:00:55 -0700
In-Reply-To: <Pine.LNX.4.44L0.1304171426460.1623-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1304171426460.1623-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use a more current logging style with dev_printk
where possible.

o Convert uses of US_DEBUGP to usb_stor_dbg
o Add "struct us_data *" to usb_stor_dbg uses
o usb_stor_dbg now uses struct device */dev_vprint_emit
o Removed embedded function names
o Coalesce formats
o Remove trailing whitespace
o Remove useless OOM messages
o Remove useless function entry/exit logging
o Convert some US_DEBUGP uses to dev_info and dev_dbg

$ size drivers/usb/storage/built-in.o*
   text	   data	    bss	    dec	    hex	filename
 137787	  55520	  68584	 261891	  3ff03	drivers/usb/storage/built-in.o.debug.new
 140782	  55200	  68904	 264886	  40ab6	drivers/usb/storage/built-in.o.debug.old
 102709	  54936	  63784	 221429	  360f5	drivers/usb/storage/built-in.o.no_debug.new
 101506	  54568	  63592	 219666	  35a12	drivers/usb/storage/built-in.o.no_debug.old

Increase in no_debug size is because some previously
compiled-out US_DEBUGP are now dev_dbg and are compiled
in and a couple of US_DEBUGP messages are now dev_info.

Signed-off-by: Joe Perches <joe@perches.com>
---

Compiled - untested
Addressed Alan Stern's notes.

 drivers/usb/storage/alauda.c        | 101 ++++++-------
 drivers/usb/storage/cypress_atacb.c |   2 +-
 drivers/usb/storage/datafab.c       |  59 ++++----
 drivers/usb/storage/debug.c         |  28 ++--
 drivers/usb/storage/debug.h         |  17 ++-
 drivers/usb/storage/ene_ub6250.c    |  86 +++++------
 drivers/usb/storage/freecom.c       |  85 +++++------
 drivers/usb/storage/initializers.c  |  10 +-
 drivers/usb/storage/isd200.c        | 292 ++++++++++++++++++------------------
 drivers/usb/storage/jumpshot.c      |  69 ++++-----
 drivers/usb/storage/karma.c         |   6 +-
 drivers/usb/storage/option_ms.c     |  23 +--
 drivers/usb/storage/realtek_cr.c    | 128 ++++++----------
 drivers/usb/storage/scsiglue.c      |  13 +-
 drivers/usb/storage/sddr09.c        | 146 +++++++++---------
 drivers/usb/storage/sddr55.c        |  86 +++++------
 drivers/usb/storage/shuttle_usbat.c | 119 ++++++++-------
 drivers/usb/storage/sierra_ms.c     |  43 +++---
 drivers/usb/storage/transport.c     | 181 +++++++++++-----------
 drivers/usb/storage/usb.c           |  93 +++++-------
 20 files changed, 753 insertions(+), 834 deletions(-)

diff --git a/drivers/usb/storage/alauda.c b/drivers/usb/storage/alauda.c
index be5564c..77a2ddf 100644
--- a/drivers/usb/storage/alauda.c
+++ b/drivers/usb/storage/alauda.c
@@ -326,8 +326,7 @@ static int alauda_get_media_status(struct us_data *us, unsigned char *data)
 	rc = usb_stor_ctrl_transfer(us, us->recv_ctrl_pipe,
 		command, 0xc0, 0, 1, data, 2);
 
-	US_DEBUGP("alauda_get_media_status: Media status %02X %02X\n",
-		data[0], data[1]);
+	usb_stor_dbg(us, "Media status %02X %02X\n", data[0], data[1]);
 
 	return rc;
 }
@@ -402,7 +401,7 @@ static int alauda_init_media(struct us_data *us)
 			ready = 1;
 	}
 
-	US_DEBUGP("alauda_init_media: We are ready for action!\n");
+	usb_stor_dbg(us, "We are ready for action!\n");
 
 	if (alauda_ack_media(us) != USB_STOR_XFER_GOOD)
 		return USB_STOR_TRANSPORT_ERROR;
@@ -413,15 +412,15 @@ static int alauda_init_media(struct us_data *us)
 		return USB_STOR_TRANSPORT_ERROR;
 
 	if (data[0] != 0x14) {
-		US_DEBUGP("alauda_init_media: Media not ready after ack\n");
+		usb_stor_dbg(us, "Media not ready after ack\n");
 		return USB_STOR_TRANSPORT_ERROR;
 	}
 
 	if (alauda_get_media_signature(us, data) != USB_STOR_XFER_GOOD)
 		return USB_STOR_TRANSPORT_ERROR;
 
-	US_DEBUGP("alauda_init_media: Media signature: %02X %02X %02X %02X\n",
-		data[0], data[1], data[2], data[3]);
+	usb_stor_dbg(us, "Media signature: %02X %02X %02X %02X\n",
+		     data[0], data[1], data[2], data[3]);
 	media_info = alauda_card_find_id(data[1]);
 	if (media_info == NULL) {
 		printk(KERN_WARNING
@@ -432,8 +431,8 @@ static int alauda_init_media(struct us_data *us)
 	}
 
 	MEDIA_INFO(us).capacity = 1 << media_info->chipshift;
-	US_DEBUGP("Found media with capacity: %ldMB\n",
-		MEDIA_INFO(us).capacity >> 20);
+	usb_stor_dbg(us, "Found media with capacity: %ldMB\n",
+		     MEDIA_INFO(us).capacity >> 20);
 
 	MEDIA_INFO(us).pageshift = media_info->pageshift;
 	MEDIA_INFO(us).blockshift = media_info->blockshift;
@@ -472,7 +471,7 @@ static int alauda_check_media(struct us_data *us)
 	/* Check for no media or door open */
 	if ((status[0] & 0x80) || ((status[0] & 0x1F) == 0x10)
 		|| ((status[1] & 0x01) == 0)) {
-		US_DEBUGP("alauda_check_media: No media, or door open\n");
+		usb_stor_dbg(us, "No media, or door open\n");
 		alauda_free_maps(&MEDIA_INFO(us));
 		info->sense_key = 0x02;
 		info->sense_asc = 0x3A;
@@ -482,7 +481,7 @@ static int alauda_check_media(struct us_data *us)
 
 	/* Check for media change */
 	if (status[0] & 0x08) {
-		US_DEBUGP("alauda_check_media: Media change detected\n");
+		usb_stor_dbg(us, "Media change detected\n");
 		alauda_free_maps(&MEDIA_INFO(us));
 		alauda_init_media(us);
 
@@ -518,7 +517,7 @@ static int alauda_check_status2(struct us_data *us)
 	if (rc != USB_STOR_XFER_GOOD)
 		return rc;
 
-	US_DEBUGP("alauda_check_status2: %02X %02X %02X\n", data[0], data[1], data[2]);
+	usb_stor_dbg(us, "%02X %02X %02X\n", data[0], data[1], data[2]);
 	if (data[0] & ALAUDA_STATUS_ERROR)
 		return USB_STOR_XFER_ERROR;
 
@@ -584,7 +583,7 @@ static int alauda_read_map(struct us_data *us, unsigned int zone)
 		goto error;
 	}
 
-	US_DEBUGP("alauda_read_map: Mapping blocks for zone %d\n", zone);
+	usb_stor_dbg(us, "Mapping blocks for zone %d\n", zone);
 
 	/* 1024 PBA's per zone */
 	for (i = 0; i < zonesize; i++)
@@ -604,7 +603,7 @@ static int alauda_read_map(struct us_data *us, unsigned int zone)
 			if (data[j] != 0)
 				goto nonz;
 		pba_to_lba[i] = UNUSABLE;
-		US_DEBUGP("alauda_read_map: PBA %d has no logical mapping\n", blocknum);
+		usb_stor_dbg(us, "PBA %d has no logical mapping\n", blocknum);
 		continue;
 
 	nonz:
@@ -617,19 +616,18 @@ static int alauda_read_map(struct us_data *us, unsigned int zone)
 	nonff:
 		/* normal PBAs start with six FFs */
 		if (j < 6) {
-			US_DEBUGP("alauda_read_map: PBA %d has no logical mapping: "
-			       "reserved area = %02X%02X%02X%02X "
-			       "data status %02X block status %02X\n",
-			       blocknum, data[0], data[1], data[2], data[3],
-			       data[4], data[5]);
+			usb_stor_dbg(us, "PBA %d has no logical mapping: reserved area = %02X%02X%02X%02X data status %02X block status %02X\n",
+				     blocknum,
+				     data[0], data[1], data[2], data[3],
+				     data[4], data[5]);
 			pba_to_lba[i] = UNUSABLE;
 			continue;
 		}
 
 		if ((data[6] >> 4) != 0x01) {
-			US_DEBUGP("alauda_read_map: PBA %d has invalid address "
-			       "field %02X%02X/%02X%02X\n",
-			       blocknum, data[6], data[7], data[11], data[12]);
+			usb_stor_dbg(us, "PBA %d has invalid address field %02X%02X/%02X%02X\n",
+				     blocknum, data[6], data[7],
+				     data[11], data[12]);
 			pba_to_lba[i] = UNUSABLE;
 			continue;
 		}
@@ -711,7 +709,7 @@ static int alauda_erase_block(struct us_data *us, u16 pba)
 	};
 	unsigned char buf[2];
 
-	US_DEBUGP("alauda_erase_block: Erasing PBA %d\n", pba);
+	usb_stor_dbg(us, "Erasing PBA %d\n", pba);
 
 	rc = usb_stor_bulk_transfer_buf(us, us->send_bulk_pipe,
 		command, 9, NULL);
@@ -723,8 +721,7 @@ static int alauda_erase_block(struct us_data *us, u16 pba)
 	if (rc != USB_STOR_XFER_GOOD)
 		return rc;
 
-	US_DEBUGP("alauda_erase_block: Erase result: %02X %02X\n",
-		buf[0], buf[1]);
+	usb_stor_dbg(us, "Erase result: %02X %02X\n", buf[0], buf[1]);
 	return rc;
 }
 
@@ -741,8 +738,7 @@ static int alauda_read_block_raw(struct us_data *us, u16 pba,
 		PBA_ZONE(pba), 0, PBA_LO(pba) + page, pages, 0, MEDIA_PORT(us)
 	};
 
-	US_DEBUGP("alauda_read_block: pba %d page %d count %d\n",
-		pba, page, pages);
+	usb_stor_dbg(us, "pba %d page %d count %d\n", pba, page, pages);
 
 	rc = usb_stor_bulk_transfer_buf(us, us->send_bulk_pipe,
 		command, 9, NULL);
@@ -793,7 +789,7 @@ static int alauda_write_block(struct us_data *us, u16 pba, unsigned char *data)
 		PBA_ZONE(pba), 0, PBA_LO(pba), 32, 0, MEDIA_PORT(us)
 	};
 
-	US_DEBUGP("alauda_write_block: pba %d\n", pba);
+	usb_stor_dbg(us, "pba %d\n", pba);
 
 	rc = usb_stor_bulk_transfer_buf(us, us->send_bulk_pipe,
 		command, 9, NULL);
@@ -866,14 +862,14 @@ static int alauda_write_lba(struct us_data *us, u16 lba,
 		cptr = bptr + pagesize;
 		nand_compute_ecc(bptr, ecc);
 		if (!nand_compare_ecc(cptr+13, ecc)) {
-			US_DEBUGP("Warning: bad ecc in page %d- of pba %d\n",
-				  i, pba);
+			usb_stor_dbg(us, "Warning: bad ecc in page %d- of pba %d\n",
+				     i, pba);
 			nand_store_ecc(cptr+13, ecc);
 		}
 		nand_compute_ecc(bptr + (pagesize / 2), ecc);
 		if (!nand_compare_ecc(cptr+8, ecc)) {
-			US_DEBUGP("Warning: bad ecc in page %d+ of pba %d\n",
-				  i, pba);
+			usb_stor_dbg(us, "Warning: bad ecc in page %d+ of pba %d\n",
+				     i, pba);
 			nand_store_ecc(cptr+8, ecc);
 		}
 		cptr[6] = cptr[11] = MSB_of(lbap);
@@ -900,8 +896,7 @@ static int alauda_write_lba(struct us_data *us, u16 lba,
 	new_pba_offset = new_pba - (zone * zonesize);
 	MEDIA_INFO(us).pba_to_lba[zone][new_pba_offset] = lba;
 	MEDIA_INFO(us).lba_to_pba[zone][lba_offset] = new_pba;
-	US_DEBUGP("alauda_write_lba: Remapped LBA %d to PBA %d\n",
-		lba, new_pba);
+	usb_stor_dbg(us, "Remapped LBA %d to PBA %d\n", lba, new_pba);
 
 	if (pba != UNDEF) {
 		unsigned int pba_offset = pba - (zone * zonesize);
@@ -964,8 +959,8 @@ static int alauda_read_data(struct us_data *us, unsigned long address,
 
 		/* Not overflowing capacity? */
 		if (lba >= max_lba) {
-			US_DEBUGP("Error: Requested lba %u exceeds "
-				  "maximum %u\n", lba, max_lba);
+			usb_stor_dbg(us, "Error: Requested lba %u exceeds maximum %u\n",
+				     lba, max_lba);
 			result = USB_STOR_TRANSPORT_ERROR;
 			break;
 		}
@@ -978,8 +973,8 @@ static int alauda_read_data(struct us_data *us, unsigned long address,
 		pba = MEDIA_INFO(us).lba_to_pba[zone][lba_offset];
 
 		if (pba == UNDEF) {	/* this lba was never written */
-			US_DEBUGP("Read %d zero pages (LBA %d) page %d\n",
-				  pages, lba, page);
+			usb_stor_dbg(us, "Read %d zero pages (LBA %d) page %d\n",
+				     pages, lba, page);
 
 			/* This is not really an error. It just means
 			   that the block has never been written.
@@ -988,9 +983,8 @@ static int alauda_read_data(struct us_data *us, unsigned long address,
 
 			memset(buffer, 0, len);
 		} else {
-			US_DEBUGP("Read %d pages, from PBA %d"
-				  " (LBA %d) page %d\n",
-				  pages, pba, lba, page);
+			usb_stor_dbg(us, "Read %d pages, from PBA %d (LBA %d) page %d\n",
+				     pages, pba, lba, page);
 
 			result = alauda_read_block(us, pba, page, pages, buffer);
 			if (result != USB_STOR_TRANSPORT_GOOD)
@@ -1066,8 +1060,8 @@ static int alauda_write_data(struct us_data *us, unsigned long address,
 
 		/* Not overflowing capacity? */
 		if (lba >= max_lba) {
-			US_DEBUGP("alauda_write_data: Requested lba %u exceeds "
-				  "maximum %u\n", lba, max_lba);
+			usb_stor_dbg(us, "Requested lba %u exceeds maximum %u\n",
+				     lba, max_lba);
 			result = USB_STOR_TRANSPORT_ERROR;
 			break;
 		}
@@ -1122,11 +1116,9 @@ static int init_alauda(struct us_data *us)
 	nand_init_ecc();
 
 	us->extra = kzalloc(sizeof(struct alauda_info), GFP_NOIO);
-	if (!us->extra) {
-		US_DEBUGP("init_alauda: Gah! Can't allocate storage for"
-			"alauda info struct!\n");
+	if (!us->extra)
 		return USB_STOR_TRANSPORT_ERROR;
-	}
+
 	info = (struct alauda_info *) us->extra;
 	us->extra_destructor = alauda_info_destructor;
 
@@ -1147,15 +1139,14 @@ static int alauda_transport(struct scsi_cmnd *srb, struct us_data *us)
 	};
 
 	if (srb->cmnd[0] == INQUIRY) {
-		US_DEBUGP("alauda_transport: INQUIRY. "
-			"Returning bogus response.\n");
+		usb_stor_dbg(us, "INQUIRY - Returning bogus response\n");
 		memcpy(ptr, inquiry_response, sizeof(inquiry_response));
 		fill_inquiry_response(us, ptr, 36);
 		return USB_STOR_TRANSPORT_GOOD;
 	}
 
 	if (srb->cmnd[0] == TEST_UNIT_READY) {
-		US_DEBUGP("alauda_transport: TEST_UNIT_READY.\n");
+		usb_stor_dbg(us, "TEST_UNIT_READY\n");
 		return alauda_check_media(us);
 	}
 
@@ -1193,8 +1184,7 @@ static int alauda_transport(struct scsi_cmnd *srb, struct us_data *us)
 		page |= short_pack(srb->cmnd[5], srb->cmnd[4]);
 		pages = short_pack(srb->cmnd[8], srb->cmnd[7]);
 
-		US_DEBUGP("alauda_transport: READ_10: page %d pagect %d\n",
-			  page, pages);
+		usb_stor_dbg(us, "READ_10: page %d pagect %d\n", page, pages);
 
 		return alauda_read_data(us, page, pages);
 	}
@@ -1211,14 +1201,13 @@ static int alauda_transport(struct scsi_cmnd *srb, struct us_data *us)
 		page |= short_pack(srb->cmnd[5], srb->cmnd[4]);
 		pages = short_pack(srb->cmnd[8], srb->cmnd[7]);
 
-		US_DEBUGP("alauda_transport: WRITE_10: page %d pagect %d\n",
-			  page, pages);
+		usb_stor_dbg(us, "WRITE_10: page %d pagect %d\n", page, pages);
 
 		return alauda_write_data(us, page, pages);
 	}
 
 	if (srb->cmnd[0] == REQUEST_SENSE) {
-		US_DEBUGP("alauda_transport: REQUEST_SENSE.\n");
+		usb_stor_dbg(us, "REQUEST_SENSE\n");
 
 		memset(ptr, 0, 18);
 		ptr[0] = 0xF0;
@@ -1237,8 +1226,8 @@ static int alauda_transport(struct scsi_cmnd *srb, struct us_data *us)
 		return USB_STOR_TRANSPORT_GOOD;
 	}
 
-	US_DEBUGP("alauda_transport: Gah! Unknown command: %d (0x%x)\n",
-		srb->cmnd[0], srb->cmnd[0]);
+	usb_stor_dbg(us, "Gah! Unknown command: %d (0x%x)\n",
+		     srb->cmnd[0], srb->cmnd[0]);
 	info->sense_key = 0x05;
 	info->sense_asc = 0x20;
 	info->sense_ascq = 0x00;
diff --git a/drivers/usb/storage/cypress_atacb.c b/drivers/usb/storage/cypress_atacb.c
index 070b5c0..e4efc7b 100644
--- a/drivers/usb/storage/cypress_atacb.c
+++ b/drivers/usb/storage/cypress_atacb.c
@@ -159,7 +159,7 @@ static void cypress_atacb_passthrough(struct scsi_cmnd *srb, struct us_data *us)
 	if (srb->result == SAM_STAT_CHECK_CONDITION &&
 			memcmp(srb->sense_buffer, usb_stor_sense_invalidCDB,
 				sizeof(usb_stor_sense_invalidCDB)) == 0) {
-		US_DEBUGP("cypress atacb not supported ???\n");
+		usb_stor_dbg(us, "cypress atacb not supported ???\n");
 		goto end;
 	}
 
diff --git a/drivers/usb/storage/datafab.c b/drivers/usb/storage/datafab.c
index 494fee5..7b17c21 100644
--- a/drivers/usb/storage/datafab.c
+++ b/drivers/usb/storage/datafab.c
@@ -123,7 +123,7 @@ datafab_bulk_read(struct us_data *us, unsigned char *data, unsigned int len) {
 	if (len == 0)
 		return USB_STOR_XFER_GOOD;
 
-	US_DEBUGP("datafab_bulk_read:  len = %d\n", len);
+	usb_stor_dbg(us, "len = %d\n", len);
 	return usb_stor_bulk_transfer_buf(us, us->recv_bulk_pipe,
 			data, len, NULL);
 }
@@ -134,7 +134,7 @@ datafab_bulk_write(struct us_data *us, unsigned char *data, unsigned int len) {
 	if (len == 0)
 		return USB_STOR_XFER_GOOD;
 
-	US_DEBUGP("datafab_bulk_write:  len = %d\n", len);
+	usb_stor_dbg(us, "len = %d\n", len);
 	return usb_stor_bulk_transfer_buf(us, us->send_bulk_pipe,
 			data, len, NULL);
 }
@@ -300,9 +300,8 @@ static int datafab_write_data(struct us_data *us,
 			goto leave;
 
 		if (reply[0] != 0x50 && reply[1] != 0) {
-			US_DEBUGP("datafab_write_data:  Gah! "
-				  "write return code: %02x %02x\n",
-				  reply[0], reply[1]);
+			usb_stor_dbg(us, "Gah! write return code: %02x %02x\n",
+				     reply[0], reply[1]);
 			result = USB_STOR_TRANSPORT_ERROR;
 			goto leave;
 		}
@@ -342,7 +341,7 @@ static int datafab_determine_lun(struct us_data *us,
 	if (!buf)
 		return USB_STOR_TRANSPORT_ERROR;
 
-	US_DEBUGP("datafab_determine_lun:  locating...\n");
+	usb_stor_dbg(us, "locating...\n");
 
 	// we'll try 3 times before giving up...
 	//
@@ -474,16 +473,16 @@ static int datafab_handle_mode_sense(struct us_data *us,
 
 	switch (pc) {
 	   case 0x0:
-		US_DEBUGP("datafab_handle_mode_sense:  Current values\n");
+		   usb_stor_dbg(us, "Current values\n");
 		break;
 	   case 0x1:
-		US_DEBUGP("datafab_handle_mode_sense:  Changeable values\n");
+		   usb_stor_dbg(us, "Changeable values\n");
 		break;
 	   case 0x2:
-		US_DEBUGP("datafab_handle_mode_sense:  Default values\n");
+		   usb_stor_dbg(us, "Default values\n");
 		break;
 	   case 0x3:
-		US_DEBUGP("datafab_handle_mode_sense:  Saves values\n");
+		   usb_stor_dbg(us, "Saves values\n");
 		break;
 	}
 
@@ -566,11 +565,9 @@ static int datafab_transport(struct scsi_cmnd *srb, struct us_data *us)
 
 	if (!us->extra) {
 		us->extra = kzalloc(sizeof(struct datafab_info), GFP_NOIO);
-		if (!us->extra) {
-			US_DEBUGP("datafab_transport:  Gah! "
-				  "Can't allocate storage for Datafab info struct!\n");
+		if (!us->extra)
 			return USB_STOR_TRANSPORT_ERROR;
-		}
+
 		us->extra_destructor = datafab_info_destructor;
   		((struct datafab_info *)us->extra)->lun = -1;
 	}
@@ -578,7 +575,7 @@ static int datafab_transport(struct scsi_cmnd *srb, struct us_data *us)
 	info = (struct datafab_info *) (us->extra);
 
 	if (srb->cmnd[0] == INQUIRY) {
-		US_DEBUGP("datafab_transport:  INQUIRY.  Returning bogus response");
+		usb_stor_dbg(us, "INQUIRY - Returning bogus response\n");
 		memcpy(ptr, inquiry_reply, sizeof(inquiry_reply));
 		fill_inquiry_response(us, ptr, 36);
 		return USB_STOR_TRANSPORT_GOOD;
@@ -590,8 +587,8 @@ static int datafab_transport(struct scsi_cmnd *srb, struct us_data *us)
 		if (rc != USB_STOR_TRANSPORT_GOOD)
 			return rc;
 
-		US_DEBUGP("datafab_transport:  READ_CAPACITY:  %ld sectors, %ld bytes per sector\n",
-			  info->sectors, info->ssize);
+		usb_stor_dbg(us, "READ_CAPACITY:  %ld sectors, %ld bytes per sector\n",
+			     info->sectors, info->ssize);
 
 		// build the reply
 		// we need the last sector, not the number of sectors
@@ -603,7 +600,7 @@ static int datafab_transport(struct scsi_cmnd *srb, struct us_data *us)
 	}
 
 	if (srb->cmnd[0] == MODE_SELECT_10) {
-		US_DEBUGP("datafab_transport:  Gah! MODE_SELECT_10.\n");
+		usb_stor_dbg(us, "Gah! MODE_SELECT_10\n");
 		return USB_STOR_TRANSPORT_ERROR;
 	}
 
@@ -615,7 +612,8 @@ static int datafab_transport(struct scsi_cmnd *srb, struct us_data *us)
 
 		blocks = ((u32)(srb->cmnd[7]) << 8) | ((u32)(srb->cmnd[8]));
 
-		US_DEBUGP("datafab_transport:  READ_10: read block 0x%04lx  count %ld\n", block, blocks);
+		usb_stor_dbg(us, "READ_10: read block 0x%04lx  count %ld\n",
+			     block, blocks);
 		return datafab_read_data(us, info, block, blocks);
 	}
 
@@ -628,7 +626,8 @@ static int datafab_transport(struct scsi_cmnd *srb, struct us_data *us)
 		blocks = ((u32)(srb->cmnd[6]) << 24) | ((u32)(srb->cmnd[7]) << 16) |
 			 ((u32)(srb->cmnd[8]) <<  8) | ((u32)(srb->cmnd[9]));
 
-		US_DEBUGP("datafab_transport:  READ_12: read block 0x%04lx  count %ld\n", block, blocks);
+		usb_stor_dbg(us, "READ_12: read block 0x%04lx  count %ld\n",
+			     block, blocks);
 		return datafab_read_data(us, info, block, blocks);
 	}
 
@@ -638,7 +637,8 @@ static int datafab_transport(struct scsi_cmnd *srb, struct us_data *us)
 
 		blocks = ((u32)(srb->cmnd[7]) << 8) | ((u32)(srb->cmnd[8]));
 
-		US_DEBUGP("datafab_transport:  WRITE_10: write block 0x%04lx  count %ld\n", block, blocks);
+		usb_stor_dbg(us, "WRITE_10: write block 0x%04lx count %ld\n",
+			     block, blocks);
 		return datafab_write_data(us, info, block, blocks);
 	}
 
@@ -651,17 +651,18 @@ static int datafab_transport(struct scsi_cmnd *srb, struct us_data *us)
 		blocks = ((u32)(srb->cmnd[6]) << 24) | ((u32)(srb->cmnd[7]) << 16) |
 			 ((u32)(srb->cmnd[8]) <<  8) | ((u32)(srb->cmnd[9]));
 
-		US_DEBUGP("datafab_transport:  WRITE_12: write block 0x%04lx  count %ld\n", block, blocks);
+		usb_stor_dbg(us, "WRITE_12: write block 0x%04lx count %ld\n",
+			     block, blocks);
 		return datafab_write_data(us, info, block, blocks);
 	}
 
 	if (srb->cmnd[0] == TEST_UNIT_READY) {
-		US_DEBUGP("datafab_transport:  TEST_UNIT_READY.\n");
+		usb_stor_dbg(us, "TEST_UNIT_READY\n");
 		return datafab_id_device(us, info);
 	}
 
 	if (srb->cmnd[0] == REQUEST_SENSE) {
-		US_DEBUGP("datafab_transport:  REQUEST_SENSE.  Returning faked response\n");
+		usb_stor_dbg(us, "REQUEST_SENSE - Returning faked response\n");
 
 		// this response is pretty bogus right now.  eventually if necessary
 		// we can set the correct sense data.  so far though it hasn't been
@@ -679,12 +680,12 @@ static int datafab_transport(struct scsi_cmnd *srb, struct us_data *us)
 	}
 
 	if (srb->cmnd[0] == MODE_SENSE) {
-		US_DEBUGP("datafab_transport:  MODE_SENSE_6 detected\n");
+		usb_stor_dbg(us, "MODE_SENSE_6 detected\n");
 		return datafab_handle_mode_sense(us, srb, 1);
 	}
 
 	if (srb->cmnd[0] == MODE_SENSE_10) {
-		US_DEBUGP("datafab_transport:  MODE_SENSE_10 detected\n");
+		usb_stor_dbg(us, "MODE_SENSE_10 detected\n");
 		return datafab_handle_mode_sense(us, srb, 0);
 	}
 
@@ -698,7 +699,7 @@ static int datafab_transport(struct scsi_cmnd *srb, struct us_data *us)
 	if (srb->cmnd[0] == START_STOP) {
 		/* this is used by sd.c'check_scsidisk_media_change to detect
 		   media change */
-		US_DEBUGP("datafab_transport:  START_STOP.\n");
+		usb_stor_dbg(us, "START_STOP\n");
 		/* the first datafab_id_device after a media change returns
 		   an error (determined experimentally) */
 		rc = datafab_id_device(us, info);
@@ -712,8 +713,8 @@ static int datafab_transport(struct scsi_cmnd *srb, struct us_data *us)
 		return rc;
 	}
 
-	US_DEBUGP("datafab_transport:  Gah! Unknown command: %d (0x%x)\n",
-		  srb->cmnd[0], srb->cmnd[0]);
+	usb_stor_dbg(us, "Gah! Unknown command: %d (0x%x)\n",
+		     srb->cmnd[0], srb->cmnd[0]);
 	info->sense_key = 0x05;
 	info->sense_asc = 0x20;
 	info->sense_ascq = 0x00;
diff --git a/drivers/usb/storage/debug.c b/drivers/usb/storage/debug.c
index b428129..ef18637 100644
--- a/drivers/usb/storage/debug.c
+++ b/drivers/usb/storage/debug.c
@@ -42,16 +42,18 @@
  * 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+#include <linux/device.h>
 #include <linux/cdrom.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_dbg.h>
 
+#include "usb.h"
 #include "debug.h"
 #include "scsi.h"
 
 
-void usb_stor_show_command(struct scsi_cmnd *srb)
+void usb_stor_show_command(const struct us_data *us, struct scsi_cmnd *srb)
 {
 	char *what = NULL;
 	int i;
@@ -149,18 +151,18 @@ void usb_stor_show_command(struct scsi_cmnd *srb)
 	case WRITE_LONG_2: what = "WRITE_LONG_2"; break;
 	default: what = "(unknown command)"; break;
 	}
-	US_DEBUGP("Command %s (%d bytes)\n", what, srb->cmd_len);
-	US_DEBUGP("bytes: ");
+	usb_stor_dbg(us, "Command %s (%d bytes)\n", what, srb->cmd_len);
+	usb_stor_dbg(us, "bytes: ");
 	for (i = 0; i < srb->cmd_len && i < 16; i++)
 		US_DEBUGPX(" %02x", srb->cmnd[i]);
 	US_DEBUGPX("\n");
 }
 
-void usb_stor_show_sense(
-		unsigned char key,
-		unsigned char asc,
-		unsigned char ascq) {
-
+void usb_stor_show_sense(const struct us_data *us,
+			 unsigned char key,
+			 unsigned char asc,
+			 unsigned char ascq)
+{
 	const char *what, *keystr;
 
 	keystr = scsi_sense_key_string(key);
@@ -171,23 +173,19 @@ void usb_stor_show_sense(
 	if (what == NULL)
 		what = "(unknown ASC/ASCQ)";
 
-	US_DEBUGP("%s: ", keystr);
+	usb_stor_dbg(us, "%s: ", keystr);
 	US_DEBUGPX(what, ascq);
 	US_DEBUGPX("\n");
 }
 
-int usb_stor_dbg(const char *fmt, ...)
+int usb_stor_dbg(const struct us_data *us, const char *fmt, ...)
 {
-	struct va_format vaf;
 	va_list args;
 	int r;
 
 	va_start(args, fmt);
 
-	vaf.fmt = fmt;
-	vaf.va = &args;
-
-	r = printk(KERN_DEBUG USB_STORAGE "%pV", &vaf);
+	r = dev_vprintk_emit(7, &us->pusb_dev->dev, fmt, args);
 
 	va_end(args);
 
diff --git a/drivers/usb/storage/debug.h b/drivers/usb/storage/debug.h
index d4280e1..b1273f0 100644
--- a/drivers/usb/storage/debug.h
+++ b/drivers/usb/storage/debug.h
@@ -47,17 +47,20 @@
 #define USB_STORAGE "usb-storage: "
 
 #ifdef CONFIG_USB_STORAGE_DEBUG
-void usb_stor_show_command(struct scsi_cmnd *srb);
-void usb_stor_show_sense( unsigned char key,
-		unsigned char asc, unsigned char ascq );
-__printf(1, 2) int usb_stor_dbg(const char *fmt, ...);
+void usb_stor_show_command(const struct us_data *us, struct scsi_cmnd *srb);
+void usb_stor_show_sense(const struct us_data *us, unsigned char key,
+			 unsigned char asc, unsigned char ascq);
+__printf(2, 3) int usb_stor_dbg(const struct us_data *us,
+				const char *fmt, ...);
 
-#define US_DEBUGP(fmt, ...)	usb_stor_dbg(fmt, ##__VA_ARGS__)
 #define US_DEBUGPX(fmt, ...)	printk(fmt, ##__VA_ARGS__)
 #define US_DEBUG(x)		x
 #else
-#define US_DEBUGP(fmt, ...)					\
-	do { if (0) printk(fmt, ##__VA_ARGS__); } while (0)
+__printf(2, 3)
+static inline int _usb_stor_dbg(const struct us_data *us,
+				const char *fmt, ...) {return 1;}
+#define usb_stor_dbg(us, fmt, ...)				\
+	do { if (0) _usb_stor_dbg(us, fmt, ##__VA_ARGS__); } while (0)
 #define US_DEBUGPX(fmt, ...)					\
 	do { if (0) printk(fmt, ##__VA_ARGS__); } while (0)
 #define US_DEBUG(x)
diff --git a/drivers/usb/storage/ene_ub6250.c b/drivers/usb/storage/ene_ub6250.c
index 118b134..1bfc9a6 100644
--- a/drivers/usb/storage/ene_ub6250.c
+++ b/drivers/usb/storage/ene_ub6250.c
@@ -504,12 +504,12 @@ static int ene_send_scsi_cmd(struct us_data *us, u8 fDir, void *buf, int use_sg)
 	unsigned int cswlen = 0, partial = 0;
 	unsigned int transfer_length = bcb->DataTransferLength;
 
-	/* US_DEBUGP("transport --- ene_send_scsi_cmd\n"); */
+	/* usb_stor_dbg(us, "transport --- ene_send_scsi_cmd\n"); */
 	/* send cmd to out endpoint */
 	result = usb_stor_bulk_transfer_buf(us, us->send_bulk_pipe,
 					    bcb, US_BULK_CB_WRAP_LEN, NULL);
 	if (result != USB_STOR_XFER_GOOD) {
-		US_DEBUGP("send cmd to out endpoint fail ---\n");
+		usb_stor_dbg(us, "send cmd to out endpoint fail ---\n");
 		return USB_STOR_TRANSPORT_ERROR;
 	}
 
@@ -529,7 +529,7 @@ static int ene_send_scsi_cmd(struct us_data *us, u8 fDir, void *buf, int use_sg)
 						transfer_length, 0, &partial);
 		}
 		if (result != USB_STOR_XFER_GOOD) {
-			US_DEBUGP("data transfer fail ---\n");
+			usb_stor_dbg(us, "data transfer fail ---\n");
 			return USB_STOR_TRANSPORT_ERROR;
 		}
 	}
@@ -539,14 +539,14 @@ static int ene_send_scsi_cmd(struct us_data *us, u8 fDir, void *buf, int use_sg)
 					    US_BULK_CS_WRAP_LEN, &cswlen);
 
 	if (result == USB_STOR_XFER_SHORT && cswlen == 0) {
-		US_DEBUGP("Received 0-length CSW; retrying...\n");
+		usb_stor_dbg(us, "Received 0-length CSW; retrying...\n");
 		result = usb_stor_bulk_transfer_buf(us, us->recv_bulk_pipe,
 					    bcs, US_BULK_CS_WRAP_LEN, &cswlen);
 	}
 
 	if (result == USB_STOR_XFER_STALLED) {
 		/* get the status again */
-		US_DEBUGP("Attempting to get CSW (2nd try)...\n");
+		usb_stor_dbg(us, "Attempting to get CSW (2nd try)...\n");
 		result = usb_stor_bulk_transfer_buf(us, us->recv_bulk_pipe,
 						bcs, US_BULK_CS_WRAP_LEN, NULL);
 	}
@@ -626,7 +626,7 @@ static int sd_scsi_read_capacity(struct us_data *us, struct scsi_cmnd *srb)
 	struct scatterlist *sg = NULL;
 	struct ene_ub6250_info *info = (struct ene_ub6250_info *) us->extra;
 
-	US_DEBUGP("sd_scsi_read_capacity\n");
+	usb_stor_dbg(us, "sd_scsi_read_capacity\n");
 	if (info->SD_Status.HiCapacity) {
 		bl_len = 0x200;
 		if (info->SD_Status.IsMMC)
@@ -639,8 +639,8 @@ static int sd_scsi_read_capacity(struct us_data *us, struct scsi_cmnd *srb)
 				* (1 << (info->SD_C_SIZE_MULT + 2)) - 1;
 	}
 	info->bl_num = bl_num;
-	US_DEBUGP("bl_len = %x\n", bl_len);
-	US_DEBUGP("bl_num = %x\n", bl_num);
+	usb_stor_dbg(us, "bl_len = %x\n", bl_len);
+	usb_stor_dbg(us, "bl_num = %x\n", bl_num);
 
 	/*srb->request_bufflen = 8; */
 	buf[0] = (bl_num >> 24) & 0xff;
@@ -675,7 +675,7 @@ static int sd_scsi_read(struct us_data *us, struct scsi_cmnd *srb)
 
 	result = ene_load_bincode(us, SD_RW_PATTERN);
 	if (result != USB_STOR_XFER_GOOD) {
-		US_DEBUGP("Load SD RW pattern Fail !!\n");
+		usb_stor_dbg(us, "Load SD RW pattern Fail !!\n");
 		return USB_STOR_TRANSPORT_ERROR;
 	}
 
@@ -715,7 +715,7 @@ static int sd_scsi_write(struct us_data *us, struct scsi_cmnd *srb)
 
 	result = ene_load_bincode(us, SD_RW_PATTERN);
 	if (result != USB_STOR_XFER_GOOD) {
-		US_DEBUGP("Load SD RW pattern Fail !!\n");
+		usb_stor_dbg(us, "Load SD RW pattern Fail !!\n");
 		return USB_STOR_TRANSPORT_ERROR;
 	}
 
@@ -1493,7 +1493,7 @@ static int ms_scsi_read_capacity(struct us_data *us, struct scsi_cmnd *srb)
 	struct scatterlist *sg = NULL;
 	struct ene_ub6250_info *info = (struct ene_ub6250_info *) us->extra;
 
-	US_DEBUGP("ms_scsi_read_capacity\n");
+	usb_stor_dbg(us, "ms_scsi_read_capacity\n");
 	bl_len = 0x200;
 	if (info->MS_Status.IsMSPro)
 		bl_num = info->MSP_TotalBlock - 1;
@@ -1501,8 +1501,8 @@ static int ms_scsi_read_capacity(struct us_data *us, struct scsi_cmnd *srb)
 		bl_num = info->MS_Lib.NumberOfLogBlock * info->MS_Lib.blockSize * 2 - 1;
 
 	info->bl_num = bl_num;
-	US_DEBUGP("bl_len = %x\n", bl_len);
-	US_DEBUGP("bl_num = %x\n", bl_num);
+	usb_stor_dbg(us, "bl_len = %x\n", bl_len);
+	usb_stor_dbg(us, "bl_num = %x\n", bl_num);
 
 	/*srb->request_bufflen = 8; */
 	buf[0] = (bl_num >> 24) & 0xff;
@@ -1654,7 +1654,7 @@ static int ms_scsi_read(struct us_data *us, struct scsi_cmnd *srb)
 	if (info->MS_Status.IsMSPro) {
 		result = ene_load_bincode(us, MSP_RW_PATTERN);
 		if (result != USB_STOR_XFER_GOOD) {
-			US_DEBUGP("Load MPS RW pattern Fail !!\n");
+			usb_stor_dbg(us, "Load MPS RW pattern Fail !!\n");
 			return USB_STOR_TRANSPORT_ERROR;
 		}
 
@@ -1854,7 +1854,7 @@ static int ene_get_card_status(struct us_data *us, u8 *buf)
 	u32 reg4b;
 	struct ene_ub6250_info *info = (struct ene_ub6250_info *) us->extra;
 
-	/*US_DEBUGP("transport --- ENE_ReadSDReg\n");*/
+	/*usb_stor_dbg(us, "transport --- ENE_ReadSDReg\n");*/
 	reg4b = *(u32 *)&buf[0x18];
 	info->SD_READ_BL_LEN = (u8)((reg4b >> 8) & 0x0f);
 
@@ -1894,45 +1894,44 @@ static int ene_load_bincode(struct us_data *us, unsigned char flag)
 	switch (flag) {
 	/* For SD */
 	case SD_INIT1_PATTERN:
-		US_DEBUGP("SD_INIT1_PATTERN\n");
+		usb_stor_dbg(us, "SD_INIT1_PATTERN\n");
 		fw_name = SD_INIT1_FIRMWARE;
 		break;
 	case SD_INIT2_PATTERN:
-		US_DEBUGP("SD_INIT2_PATTERN\n");
+		usb_stor_dbg(us, "SD_INIT2_PATTERN\n");
 		fw_name = SD_INIT2_FIRMWARE;
 		break;
 	case SD_RW_PATTERN:
-		US_DEBUGP("SD_RW_PATTERN\n");
+		usb_stor_dbg(us, "SD_RW_PATTERN\n");
 		fw_name = SD_RW_FIRMWARE;
 		break;
 	/* For MS */
 	case MS_INIT_PATTERN:
-		US_DEBUGP("MS_INIT_PATTERN\n");
+		usb_stor_dbg(us, "MS_INIT_PATTERN\n");
 		fw_name = MS_INIT_FIRMWARE;
 		break;
 	case MSP_RW_PATTERN:
-		US_DEBUGP("MSP_RW_PATTERN\n");
+		usb_stor_dbg(us, "MSP_RW_PATTERN\n");
 		fw_name = MSP_RW_FIRMWARE;
 		break;
 	case MS_RW_PATTERN:
-		US_DEBUGP("MS_RW_PATTERN\n");
+		usb_stor_dbg(us, "MS_RW_PATTERN\n");
 		fw_name = MS_RW_FIRMWARE;
 		break;
 	default:
-		US_DEBUGP("----------- Unknown PATTERN ----------\n");
+		usb_stor_dbg(us, "----------- Unknown PATTERN ----------\n");
 		goto nofw;
 	}
 
 	err = request_firmware(&sd_fw, fw_name, &us->pusb_dev->dev);
 	if (err) {
-		US_DEBUGP("load firmware %s failed\n", fw_name);
+		usb_stor_dbg(us, "load firmware %s failed\n", fw_name);
 		goto nofw;
 	}
 	buf = kmalloc(sd_fw->size, GFP_KERNEL);
-	if (buf == NULL) {
-		US_DEBUGP("Malloc memory for fireware failed!\n");
+	if (buf == NULL)
 		goto nofw;
-	}
+
 	memcpy(buf, sd_fw->data, sd_fw->size);
 	memset(bcb, 0, sizeof(struct bulk_cb_wrap));
 	bcb->Signature = cpu_to_le32(US_BULK_CB_SIGN);
@@ -2116,9 +2115,9 @@ static int ene_ms_init(struct us_data *us)
 		} else {
 			ms_card_init(us); /* Card is MS (to ms.c)*/
 		}
-		US_DEBUGP("MS Init Code OK !!\n");
+		usb_stor_dbg(us, "MS Init Code OK !!\n");
 	} else {
-		US_DEBUGP("MS Card Not Ready --- %x\n", buf[0]);
+		usb_stor_dbg(us, "MS Card Not Ready --- %x\n", buf[0]);
 		return USB_STOR_TRANSPORT_ERROR;
 	}
 
@@ -2132,11 +2131,11 @@ static int ene_sd_init(struct us_data *us)
 	struct bulk_cb_wrap *bcb = (struct bulk_cb_wrap *) us->iobuf;
 	struct ene_ub6250_info *info = (struct ene_ub6250_info *) us->extra;
 
-	US_DEBUGP("transport --- ENE_SDInit\n");
+	usb_stor_dbg(us, "transport --- ENE_SDInit\n");
 	/* SD Init Part-1 */
 	result = ene_load_bincode(us, SD_INIT1_PATTERN);
 	if (result != USB_STOR_XFER_GOOD) {
-		US_DEBUGP("Load SD Init Code Part-1 Fail !!\n");
+		usb_stor_dbg(us, "Load SD Init Code Part-1 Fail !!\n");
 		return USB_STOR_TRANSPORT_ERROR;
 	}
 
@@ -2147,14 +2146,14 @@ static int ene_sd_init(struct us_data *us)
 
 	result = ene_send_scsi_cmd(us, FDIR_READ, NULL, 0);
 	if (result != USB_STOR_XFER_GOOD) {
-		US_DEBUGP("Execution SD Init Code Fail !!\n");
+		usb_stor_dbg(us, "Execution SD Init Code Fail !!\n");
 		return USB_STOR_TRANSPORT_ERROR;
 	}
 
 	/* SD Init Part-2 */
 	result = ene_load_bincode(us, SD_INIT2_PATTERN);
 	if (result != USB_STOR_XFER_GOOD) {
-		US_DEBUGP("Load SD Init Code Part-2 Fail !!\n");
+		usb_stor_dbg(us, "Load SD Init Code Part-2 Fail !!\n");
 		return USB_STOR_TRANSPORT_ERROR;
 	}
 
@@ -2166,21 +2165,23 @@ static int ene_sd_init(struct us_data *us)
 
 	result = ene_send_scsi_cmd(us, FDIR_READ, &buf, 0);
 	if (result != USB_STOR_XFER_GOOD) {
-		US_DEBUGP("Execution SD Init Code Fail !!\n");
+		usb_stor_dbg(us, "Execution SD Init Code Fail !!\n");
 		return USB_STOR_TRANSPORT_ERROR;
 	}
 
 	info->SD_Status =  *(struct SD_STATUS *)&buf[0];
 	if (info->SD_Status.Insert && info->SD_Status.Ready) {
+		struct SD_STATUS *s = &info->SD_Status;
+
 		ene_get_card_status(us, (unsigned char *)&buf);
-		US_DEBUGP("Insert     = %x\n", info->SD_Status.Insert);
-		US_DEBUGP("Ready      = %x\n", info->SD_Status.Ready);
-		US_DEBUGP("IsMMC      = %x\n", info->SD_Status.IsMMC);
-		US_DEBUGP("HiCapacity = %x\n", info->SD_Status.HiCapacity);
-		US_DEBUGP("HiSpeed    = %x\n", info->SD_Status.HiSpeed);
-		US_DEBUGP("WtP        = %x\n", info->SD_Status.WtP);
+		usb_stor_dbg(us, "Insert     = %x\n", s->Insert);
+		usb_stor_dbg(us, "Ready      = %x\n", s->Ready);
+		usb_stor_dbg(us, "IsMMC      = %x\n", s->IsMMC);
+		usb_stor_dbg(us, "HiCapacity = %x\n", s->HiCapacity);
+		usb_stor_dbg(us, "HiSpeed    = %x\n", s->HiSpeed);
+		usb_stor_dbg(us, "WtP        = %x\n", s->WtP);
 	} else {
-		US_DEBUGP("SD Card Not Ready --- %x\n", buf[0]);
+		usb_stor_dbg(us, "SD Card Not Ready --- %x\n", buf[0]);
 		return USB_STOR_TRANSPORT_ERROR;
 	}
 	return USB_STOR_TRANSPORT_GOOD;
@@ -2293,7 +2294,7 @@ static int ene_transport(struct scsi_cmnd *srb, struct us_data *us)
 	int result = 0;
 	struct ene_ub6250_info *info = (struct ene_ub6250_info *)(us->extra);
 
-	/*US_DEBUG(usb_stor_show_command(srb)); */
+	/*US_DEBUG(usb_stor_show_command(us, srb)); */
 	scsi_set_resid(srb, 0);
 	if (unlikely(!(info->SD_Status.Ready || info->MS_Status.Ready))) {
 		result = ene_init(us);
@@ -2362,7 +2363,6 @@ static int ene_ub6250_resume(struct usb_interface *iface)
 
 	mutex_lock(&us->dev_mutex);
 
-	US_DEBUGP("%s\n", __func__);
 	if (us->suspend_resume_hook)
 		(us->suspend_resume_hook)(us, US_RESUME);
 
@@ -2382,7 +2382,7 @@ static int ene_ub6250_reset_resume(struct usb_interface *iface)
 	u8 tmp = 0;
 	struct us_data *us = usb_get_intfdata(iface);
 	struct ene_ub6250_info *info = (struct ene_ub6250_info *)(us->extra);
-	US_DEBUGP("%s\n", __func__);
+
 	/* Report the reset to the SCSI core */
 	usb_stor_reset_resume(iface);
 
diff --git a/drivers/usb/storage/freecom.c b/drivers/usb/storage/freecom.c
index e6df087..ef16068 100644
--- a/drivers/usb/storage/freecom.c
+++ b/drivers/usb/storage/freecom.c
@@ -40,7 +40,7 @@ MODULE_AUTHOR("David Brown <usb-storage@davidb.org>");
 MODULE_LICENSE("GPL");
 
 #ifdef CONFIG_USB_STORAGE_DEBUG
-static void pdump (void *, int);
+static void pdump(struct us_data *us, void *ibuffer, int length);
 #endif
 
 /* Bits of HD_STATUS */
@@ -161,20 +161,20 @@ freecom_readdata (struct scsi_cmnd *srb, struct us_data *us,
 	fxfr->Count = cpu_to_le32 (count);
 	memset (fxfr->Pad, 0, sizeof (fxfr->Pad));
 
-	US_DEBUGP("Read data Freecom! (c=%d)\n", count);
+	usb_stor_dbg(us, "Read data Freecom! (c=%d)\n", count);
 
 	/* Issue the transfer command. */
 	result = usb_stor_bulk_transfer_buf (us, opipe, fxfr,
 			FCM_PACKET_LENGTH, NULL);
 	if (result != USB_STOR_XFER_GOOD) {
-		US_DEBUGP ("Freecom readdata transport error\n");
+		usb_stor_dbg(us, "Freecom readdata transport error\n");
 		return USB_STOR_TRANSPORT_ERROR;
 	}
 
 	/* Now transfer all of our blocks. */
-	US_DEBUGP("Start of read\n");
+	usb_stor_dbg(us, "Start of read\n");
 	result = usb_stor_bulk_srb(us, ipipe, srb);
-	US_DEBUGP("freecom_readdata done!\n");
+	usb_stor_dbg(us, "freecom_readdata done!\n");
 
 	if (result > USB_STOR_XFER_SHORT)
 		return USB_STOR_TRANSPORT_ERROR;
@@ -194,21 +194,21 @@ freecom_writedata (struct scsi_cmnd *srb, struct us_data *us,
 	fxfr->Count = cpu_to_le32 (count);
 	memset (fxfr->Pad, 0, sizeof (fxfr->Pad));
 
-	US_DEBUGP("Write data Freecom! (c=%d)\n", count);
+	usb_stor_dbg(us, "Write data Freecom! (c=%d)\n", count);
 
 	/* Issue the transfer command. */
 	result = usb_stor_bulk_transfer_buf (us, opipe, fxfr,
 			FCM_PACKET_LENGTH, NULL);
 	if (result != USB_STOR_XFER_GOOD) {
-		US_DEBUGP ("Freecom writedata transport error\n");
+		usb_stor_dbg(us, "Freecom writedata transport error\n");
 		return USB_STOR_TRANSPORT_ERROR;
 	}
 
 	/* Now transfer all of our blocks. */
-	US_DEBUGP("Start of write\n");
+	usb_stor_dbg(us, "Start of write\n");
 	result = usb_stor_bulk_srb(us, opipe, srb);
 
-	US_DEBUGP("freecom_writedata done!\n");
+	usb_stor_dbg(us, "freecom_writedata done!\n");
 	if (result > USB_STOR_XFER_SHORT)
 		return USB_STOR_TRANSPORT_ERROR;
 	return USB_STOR_TRANSPORT_GOOD;
@@ -230,7 +230,7 @@ static int freecom_transport(struct scsi_cmnd *srb, struct us_data *us)
 	fcb = (struct freecom_cb_wrap *) us->iobuf;
 	fst = (struct freecom_status *) us->iobuf;
 
-	US_DEBUGP("Freecom TRANSPORT STARTED\n");
+	usb_stor_dbg(us, "Freecom TRANSPORT STARTED\n");
 
 	/* Get handles for both transports. */
 	opipe = us->send_bulk_pipe;
@@ -242,7 +242,7 @@ static int freecom_transport(struct scsi_cmnd *srb, struct us_data *us)
 	memcpy (fcb->Atapi, srb->cmnd, 12);
 	memset (fcb->Filler, 0, sizeof (fcb->Filler));
 
-	US_DEBUG(pdump (srb->cmnd, 12));
+	US_DEBUG(pdump(us, srb->cmnd, 12));
 
 	/* Send it out. */
 	result = usb_stor_bulk_transfer_buf (us, opipe, fcb,
@@ -252,7 +252,7 @@ static int freecom_transport(struct scsi_cmnd *srb, struct us_data *us)
 	 * USB land.  It returns the status in its own registers, which
 	 * come back in the bulk pipe. */
 	if (result != USB_STOR_XFER_GOOD) {
-		US_DEBUGP ("freecom transport error\n");
+		usb_stor_dbg(us, "freecom transport error\n");
 		return USB_STOR_TRANSPORT_ERROR;
 	}
 
@@ -260,11 +260,11 @@ static int freecom_transport(struct scsi_cmnd *srb, struct us_data *us)
 	 * doesn't hurt us to always do it now. */
 	result = usb_stor_bulk_transfer_buf (us, ipipe, fst,
 			FCM_STATUS_PACKET_LENGTH, &partial);
-	US_DEBUGP("foo Status result %d %u\n", result, partial);
+	usb_stor_dbg(us, "foo Status result %d %u\n", result, partial);
 	if (result != USB_STOR_XFER_GOOD)
 		return USB_STOR_TRANSPORT_ERROR;
 
-	US_DEBUG(pdump ((void *) fst, partial));
+	US_DEBUG(pdump(us, (void *)fst, partial));
 
 	/* The firmware will time-out commands after 20 seconds. Some commands
 	 * can legitimately take longer than this, so we use a different
@@ -275,8 +275,8 @@ static int freecom_transport(struct scsi_cmnd *srb, struct us_data *us)
 	 * may not work, but that is a condition that should never happen.
 	 */
 	while (fst->Status & FCM_STATUS_BUSY) {
-		US_DEBUGP("20 second USB/ATAPI bridge TIMEOUT occurred!\n");
-		US_DEBUGP("fst->Status is %x\n", fst->Status);
+		usb_stor_dbg(us, "20 second USB/ATAPI bridge TIMEOUT occurred!\n");
+		usb_stor_dbg(us, "fst->Status is %x\n", fst->Status);
 
 		/* Get the status again */
 		fcb->Type = FCM_PACKET_STATUS;
@@ -293,7 +293,7 @@ static int freecom_transport(struct scsi_cmnd *srb, struct us_data *us)
 		 * registers, which come back in the bulk pipe.
 		 */
 		if (result != USB_STOR_XFER_GOOD) {
-			US_DEBUGP ("freecom transport error\n");
+			usb_stor_dbg(us, "freecom transport error\n");
 			return USB_STOR_TRANSPORT_ERROR;
 		}
 
@@ -301,26 +301,26 @@ static int freecom_transport(struct scsi_cmnd *srb, struct us_data *us)
 		result = usb_stor_bulk_transfer_buf (us, ipipe, fst,
 				FCM_STATUS_PACKET_LENGTH, &partial);
 
-		US_DEBUGP("bar Status result %d %u\n", result, partial);
+		usb_stor_dbg(us, "bar Status result %d %u\n", result, partial);
 		if (result != USB_STOR_XFER_GOOD)
 			return USB_STOR_TRANSPORT_ERROR;
 
-		US_DEBUG(pdump ((void *) fst, partial));
+		US_DEBUG(pdump(us, (void *)fst, partial));
 	}
 
 	if (partial != 4)
 		return USB_STOR_TRANSPORT_ERROR;
 	if ((fst->Status & 1) != 0) {
-		US_DEBUGP("operation failed\n");
+		usb_stor_dbg(us, "operation failed\n");
 		return USB_STOR_TRANSPORT_FAILED;
 	}
 
 	/* The device might not have as much data available as we
 	 * requested.  If you ask for more than the device has, this reads
 	 * and such will hang. */
-	US_DEBUGP("Device indicates that it has %d bytes available\n",
-			le16_to_cpu (fst->Count));
-	US_DEBUGP("SCSI requested %d\n", scsi_bufflen(srb));
+	usb_stor_dbg(us, "Device indicates that it has %d bytes available\n",
+		     le16_to_cpu(fst->Count));
+	usb_stor_dbg(us, "SCSI requested %d\n", scsi_bufflen(srb));
 
 	/* Find the length we desire to read. */
 	switch (srb->cmnd[0]) {
@@ -337,7 +337,8 @@ static int freecom_transport(struct scsi_cmnd *srb, struct us_data *us)
 	/* verify that this amount is legal */
 	if (length > scsi_bufflen(srb)) {
 		length = scsi_bufflen(srb);
-		US_DEBUGP("Truncating request to match buffer length: %d\n", length);
+		usb_stor_dbg(us, "Truncating request to match buffer length: %d\n",
+			     length);
 	}
 
 	/* What we do now depends on what direction the data is supposed to
@@ -351,29 +352,29 @@ static int freecom_transport(struct scsi_cmnd *srb, struct us_data *us)
 		/* Make sure that the status indicates that the device
 		 * wants data as well. */
 		if ((fst->Status & DRQ_STAT) == 0 || (fst->Reason & 3) != 2) {
-			US_DEBUGP("SCSI wants data, drive doesn't have any\n");
+			usb_stor_dbg(us, "SCSI wants data, drive doesn't have any\n");
 			return USB_STOR_TRANSPORT_FAILED;
 		}
 		result = freecom_readdata (srb, us, ipipe, opipe, length);
 		if (result != USB_STOR_TRANSPORT_GOOD)
 			return result;
 
-		US_DEBUGP("FCM: Waiting for status\n");
+		usb_stor_dbg(us, "Waiting for status\n");
 		result = usb_stor_bulk_transfer_buf (us, ipipe, fst,
 				FCM_PACKET_LENGTH, &partial);
-		US_DEBUG(pdump ((void *) fst, partial));
+		US_DEBUG(pdump(us, (void *)fst, partial));
 
 		if (partial != 4 || result > USB_STOR_XFER_SHORT)
 			return USB_STOR_TRANSPORT_ERROR;
 		if ((fst->Status & ERR_STAT) != 0) {
-			US_DEBUGP("operation failed\n");
+			usb_stor_dbg(us, "operation failed\n");
 			return USB_STOR_TRANSPORT_FAILED;
 		}
 		if ((fst->Reason & 3) != 3) {
-			US_DEBUGP("Drive seems still hungry\n");
+			usb_stor_dbg(us, "Drive seems still hungry\n");
 			return USB_STOR_TRANSPORT_FAILED;
 		}
-		US_DEBUGP("Transfer happy\n");
+		usb_stor_dbg(us, "Transfer happy\n");
 		break;
 
 	case DMA_TO_DEVICE:
@@ -387,22 +388,22 @@ static int freecom_transport(struct scsi_cmnd *srb, struct us_data *us)
 		if (result != USB_STOR_TRANSPORT_GOOD)
 			return result;
 
-		US_DEBUGP("FCM: Waiting for status\n");
+		usb_stor_dbg(us, "Waiting for status\n");
 		result = usb_stor_bulk_transfer_buf (us, ipipe, fst,
 				FCM_PACKET_LENGTH, &partial);
 
 		if (partial != 4 || result > USB_STOR_XFER_SHORT)
 			return USB_STOR_TRANSPORT_ERROR;
 		if ((fst->Status & ERR_STAT) != 0) {
-			US_DEBUGP("operation failed\n");
+			usb_stor_dbg(us, "operation failed\n");
 			return USB_STOR_TRANSPORT_FAILED;
 		}
 		if ((fst->Reason & 3) != 3) {
-			US_DEBUGP("Drive seems still hungry\n");
+			usb_stor_dbg(us, "Drive seems still hungry\n");
 			return USB_STOR_TRANSPORT_FAILED;
 		}
 
-		US_DEBUGP("Transfer happy\n");
+		usb_stor_dbg(us, "Transfer happy\n");
 		break;
 
 
@@ -412,8 +413,8 @@ static int freecom_transport(struct scsi_cmnd *srb, struct us_data *us)
 
 	default:
 		/* should never hit here -- filtered in usb.c */
-		US_DEBUGP ("freecom unimplemented direction: %d\n",
-				us->srb->sc_data_direction);
+		usb_stor_dbg(us, "freecom unimplemented direction: %d\n",
+			     us->srb->sc_data_direction);
 		/* Return fail, SCSI seems to handle this better. */
 		return USB_STOR_TRANSPORT_FAILED;
 		break;
@@ -434,7 +435,7 @@ static int init_freecom(struct us_data *us)
 	result = usb_stor_control_msg(us, us->recv_ctrl_pipe,
 			0x4c, 0xc0, 0x4346, 0x0, buffer, 0x20, 3*HZ);
 	buffer[32] = '\0';
-	US_DEBUGP("String returned from FC init is: %s\n", buffer);
+	usb_stor_dbg(us, "String returned from FC init is: %s\n", buffer);
 
 	/* Special thanks to the people at Freecom for providing me with
 	 * this "magic sequence", which they use in their Windows and MacOS
@@ -445,7 +446,7 @@ static int init_freecom(struct us_data *us)
 	/* send reset */
 	result = usb_stor_control_msg(us, us->send_ctrl_pipe,
 			0x4d, 0x40, 0x24d8, 0x0, NULL, 0x0, 3*HZ);
-	US_DEBUGP("result from activate reset is %d\n", result);
+	usb_stor_dbg(us, "result from activate reset is %d\n", result);
 
 	/* wait 250ms */
 	mdelay(250);
@@ -453,7 +454,7 @@ static int init_freecom(struct us_data *us)
 	/* clear reset */
 	result = usb_stor_control_msg(us, us->send_ctrl_pipe,
 			0x4d, 0x40, 0x24f8, 0x0, NULL, 0x0, 3*HZ);
-	US_DEBUGP("result from clear reset is %d\n", result);
+	usb_stor_dbg(us, "result from clear reset is %d\n", result);
 
 	/* wait 3 seconds */
 	mdelay(3 * 1000);
@@ -470,7 +471,7 @@ static int usb_stor_freecom_reset(struct us_data *us)
 }
 
 #ifdef CONFIG_USB_STORAGE_DEBUG
-static void pdump (void *ibuffer, int length)
+static void pdump(struct us_data *us, void *ibuffer, int length)
 {
 	static char line[80];
 	int offset = 0;
@@ -490,7 +491,7 @@ static void pdump (void *ibuffer, int length)
 						line[offset++] = '.';
 				}
 				line[offset] = 0;
-				US_DEBUGP("%s\n", line);
+				usb_stor_dbg(us, "%s\n", line);
 				offset = 0;
 			}
 			offset += sprintf (line+offset, "%08x:", i);
@@ -517,7 +518,7 @@ static void pdump (void *ibuffer, int length)
 			line[offset++] = '.';
 	}
 	line[offset] = 0;
-	US_DEBUGP("%s\n", line);
+	usb_stor_dbg(us, "%s\n", line);
 	offset = 0;
 }
 #endif
diff --git a/drivers/usb/storage/initializers.c b/drivers/usb/storage/initializers.c
index 105d900..5a8b5ff 100644
--- a/drivers/usb/storage/initializers.c
+++ b/drivers/usb/storage/initializers.c
@@ -48,12 +48,12 @@ int usb_stor_euscsi_init(struct us_data *us)
 {
 	int result;
 
-	US_DEBUGP("Attempting to init eUSCSI bridge...\n");
+	usb_stor_dbg(us, "Attempting to init eUSCSI bridge...\n");
 	us->iobuf[0] = 0x1;
 	result = usb_stor_control_msg(us, us->send_ctrl_pipe,
 			0x0C, USB_RECIP_INTERFACE | USB_TYPE_VENDOR,
 			0x01, 0x0, us->iobuf, 0x1, 5000);
-	US_DEBUGP("-- result is %d\n", result);
+	usb_stor_dbg(us, "-- result is %d\n", result);
 
 	return 0;
 }
@@ -68,7 +68,7 @@ int usb_stor_ucr61s2b_init(struct us_data *us)
 	unsigned int partial;
 	static char init_string[] = "\xec\x0a\x06\x00$PCCHIPS";
 
-	US_DEBUGP("Sending UCR-61S2B initialization packet...\n");
+	usb_stor_dbg(us, "Sending UCR-61S2B initialization packet...\n");
 
 	bcb->Signature = cpu_to_le32(US_BULK_CB_SIGN);
 	bcb->Tag = 0;
@@ -83,7 +83,7 @@ int usb_stor_ucr61s2b_init(struct us_data *us)
 	if (res)
 		return -EIO;
 
-	US_DEBUGP("Getting status packet...\n");
+	usb_stor_dbg(us, "Getting status packet...\n");
 	res = usb_stor_bulk_transfer_buf(us, us->recv_bulk_pipe, bcs,
 			US_BULK_CS_WRAP_LEN, &partial);
 	if (res)
@@ -101,6 +101,6 @@ int usb_stor_huawei_e220_init(struct us_data *us)
 				      USB_REQ_SET_FEATURE,
 				      USB_TYPE_STANDARD | USB_RECIP_DEVICE,
 				      0x01, 0x0, NULL, 0x0, 1000);
-	US_DEBUGP("Huawei mode set result is %d\n", result);
+	usb_stor_dbg(us, "Huawei mode set result is %d\n", result);
 	return 0;
 }
diff --git a/drivers/usb/storage/isd200.c b/drivers/usb/storage/isd200.c
index 55571ae..599d8bf 100644
--- a/drivers/usb/storage/isd200.c
+++ b/drivers/usb/storage/isd200.c
@@ -503,7 +503,7 @@ static int isd200_action( struct us_data *us, int action,
 
 	switch ( action ) {
 	case ACTION_READ_STATUS:
-		US_DEBUGP("   isd200_action(READ_STATUS)\n");
+		usb_stor_dbg(us, "   isd200_action(READ_STATUS)\n");
 		ata.generic.ActionSelect = ACTION_SELECT_0|ACTION_SELECT_2;
 		ata.generic.RegisterSelect =
 		  REG_CYLINDER_LOW | REG_CYLINDER_HIGH |
@@ -512,7 +512,7 @@ static int isd200_action( struct us_data *us, int action,
 		break;
 
 	case ACTION_ENUM:
-		US_DEBUGP("   isd200_action(ENUM,0x%02x)\n",value);
+		usb_stor_dbg(us, "   isd200_action(ENUM,0x%02x)\n", value);
 		ata.generic.ActionSelect = ACTION_SELECT_1|ACTION_SELECT_2|
 					   ACTION_SELECT_3|ACTION_SELECT_4|
 					   ACTION_SELECT_5;
@@ -522,7 +522,7 @@ static int isd200_action( struct us_data *us, int action,
 		break;
 
 	case ACTION_RESET:
-		US_DEBUGP("   isd200_action(RESET)\n");
+		usb_stor_dbg(us, "   isd200_action(RESET)\n");
 		ata.generic.ActionSelect = ACTION_SELECT_1|ACTION_SELECT_2|
 					   ACTION_SELECT_3|ACTION_SELECT_4;
 		ata.generic.RegisterSelect = REG_DEVICE_CONTROL;
@@ -531,7 +531,7 @@ static int isd200_action( struct us_data *us, int action,
 		break;
 
 	case ACTION_REENABLE:
-		US_DEBUGP("   isd200_action(REENABLE)\n");
+		usb_stor_dbg(us, "   isd200_action(REENABLE)\n");
 		ata.generic.ActionSelect = ACTION_SELECT_1|ACTION_SELECT_2|
 					   ACTION_SELECT_3|ACTION_SELECT_4;
 		ata.generic.RegisterSelect = REG_DEVICE_CONTROL;
@@ -540,7 +540,7 @@ static int isd200_action( struct us_data *us, int action,
 		break;
 
 	case ACTION_SOFT_RESET:
-		US_DEBUGP("   isd200_action(SOFT_RESET)\n");
+		usb_stor_dbg(us, "   isd200_action(SOFT_RESET)\n");
 		ata.generic.ActionSelect = ACTION_SELECT_1|ACTION_SELECT_5;
 		ata.generic.RegisterSelect = REG_DEVICE_HEAD | REG_COMMAND;
 		ata.write.DeviceHeadByte = info->DeviceHead;
@@ -549,7 +549,7 @@ static int isd200_action( struct us_data *us, int action,
 		break;
 
 	case ACTION_IDENTIFY:
-		US_DEBUGP("   isd200_action(IDENTIFY)\n");
+		usb_stor_dbg(us, "   isd200_action(IDENTIFY)\n");
 		ata.generic.RegisterSelect = REG_COMMAND;
 		ata.write.CommandByte = ATA_CMD_ID_ATA;
 		isd200_set_srb(info, DMA_FROM_DEVICE, info->id,
@@ -557,7 +557,7 @@ static int isd200_action( struct us_data *us, int action,
 		break;
 
 	default:
-		US_DEBUGP("Error: Undefined action %d\n",action);
+		usb_stor_dbg(us, "Error: Undefined action %d\n", action);
 		return ISD200_ERROR;
 	}
 
@@ -567,7 +567,8 @@ static int isd200_action( struct us_data *us, int action,
 	if (status == USB_STOR_TRANSPORT_GOOD)
 		status = ISD200_GOOD;
 	else {
-		US_DEBUGP("   isd200_action(0x%02x) error: %d\n",action,status);
+		usb_stor_dbg(us, "   isd200_action(0x%02x) error: %d\n",
+			     action, status);
 		status = ISD200_ERROR;
 		/* need to reset device here */
 	}
@@ -589,17 +590,17 @@ static int isd200_read_regs( struct us_data *us )
 	int retStatus = ISD200_GOOD;
 	int transferStatus;
 
-	US_DEBUGP("Entering isd200_IssueATAReadRegs\n");
+	usb_stor_dbg(us, "Entering isd200_IssueATAReadRegs\n");
 
 	transferStatus = isd200_action( us, ACTION_READ_STATUS,
 				    info->RegsBuf, sizeof(info->ATARegs) );
 	if (transferStatus != ISD200_TRANSPORT_GOOD) {
-		US_DEBUGP("   Error reading ATA registers\n");
+		usb_stor_dbg(us, "   Error reading ATA registers\n");
 		retStatus = ISD200_ERROR;
 	} else {
 		memcpy(info->ATARegs, info->RegsBuf, sizeof(info->ATARegs));
-		US_DEBUGP("   Got ATA Register[ATA_REG_ERROR_OFFSET] = 0x%x\n",
-			  info->ATARegs[ATA_REG_ERROR_OFFSET]);
+		usb_stor_dbg(us, "   Got ATA Register[ATA_REG_ERROR_OFFSET] = 0x%x\n",
+			     info->ATARegs[ATA_REG_ERROR_OFFSET]);
 	}
 
 	return retStatus;
@@ -629,7 +630,7 @@ static void isd200_invoke_transport( struct us_data *us,
 	 * short-circuit all other processing
 	 */
 	if (test_bit(US_FLIDX_TIMED_OUT, &us->dflags)) {
-		US_DEBUGP("-- command was aborted\n");
+		usb_stor_dbg(us, "-- command was aborted\n");
 		goto Handle_Abort;
 	}
 
@@ -641,23 +642,23 @@ static void isd200_invoke_transport( struct us_data *us,
 		break;
 
 	case USB_STOR_TRANSPORT_NO_SENSE:
-		US_DEBUGP("-- transport indicates protocol failure\n");
+		usb_stor_dbg(us, "-- transport indicates protocol failure\n");
 		srb->result = SAM_STAT_CHECK_CONDITION;
 		return;
 
 	case USB_STOR_TRANSPORT_FAILED:
-		US_DEBUGP("-- transport indicates command failure\n");
+		usb_stor_dbg(us, "-- transport indicates command failure\n");
 		need_auto_sense = 1;
 		break;
 
 	case USB_STOR_TRANSPORT_ERROR:
-		US_DEBUGP("-- transport indicates transport error\n");
+		usb_stor_dbg(us, "-- transport indicates transport error\n");
 		srb->result = DID_ERROR << 16;
 		/* Need reset here */
 		return;
     
 	default:
-		US_DEBUGP("-- transport indicates unknown error\n");   
+		usb_stor_dbg(us, "-- transport indicates unknown error\n");
 		srb->result = DID_ERROR << 16;
 		/* Need reset here */
 		return;
@@ -669,14 +670,14 @@ static void isd200_invoke_transport( struct us_data *us,
 	      (srb->cmnd[0] == MODE_SENSE) ||
 	      (srb->cmnd[0] == LOG_SENSE) ||
 	      (srb->cmnd[0] == MODE_SENSE_10))) {
-		US_DEBUGP("-- unexpectedly short transfer\n");
+		usb_stor_dbg(us, "-- unexpectedly short transfer\n");
 		need_auto_sense = 1;
 	}
 
 	if (need_auto_sense) {
 		result = isd200_read_regs(us);
 		if (test_bit(US_FLIDX_TIMED_OUT, &us->dflags)) {
-			US_DEBUGP("-- auto-sense aborted\n");
+			usb_stor_dbg(us, "-- auto-sense aborted\n");
 			goto Handle_Abort;
 		}
 		if (result == ISD200_GOOD) {
@@ -710,40 +711,40 @@ static void isd200_invoke_transport( struct us_data *us,
 }
 
 #ifdef CONFIG_USB_STORAGE_DEBUG
-static void isd200_log_config( struct isd200_info* info )
+static void isd200_log_config(struct us_data *us, struct isd200_info *info)
 {
-	US_DEBUGP("      Event Notification: 0x%x\n", 
-		  info->ConfigData.EventNotification);
-	US_DEBUGP("      External Clock: 0x%x\n", 
-		  info->ConfigData.ExternalClock);
-	US_DEBUGP("      ATA Init Timeout: 0x%x\n", 
-		  info->ConfigData.ATAInitTimeout);
-	US_DEBUGP("      ATAPI Command Block Size: 0x%x\n", 
-		  (info->ConfigData.ATAConfig & ATACFG_BLOCKSIZE) >> 6);
-	US_DEBUGP("      Master/Slave Selection: 0x%x\n", 
-		  info->ConfigData.ATAConfig & ATACFG_MASTER);
-	US_DEBUGP("      ATAPI Reset: 0x%x\n",
-		  info->ConfigData.ATAConfig & ATACFG_ATAPI_RESET);
-	US_DEBUGP("      ATA Timing: 0x%x\n",
-		  info->ConfigData.ATAConfig & ATACFG_TIMING);
-	US_DEBUGP("      ATA Major Command: 0x%x\n", 
-		  info->ConfigData.ATAMajorCommand);
-	US_DEBUGP("      ATA Minor Command: 0x%x\n", 
-		  info->ConfigData.ATAMinorCommand);
-	US_DEBUGP("      Init Status: 0x%x\n", 
-		  info->ConfigData.ATAExtraConfig & ATACFGE_INIT_STATUS);
-	US_DEBUGP("      Config Descriptor 2: 0x%x\n", 
-		  info->ConfigData.ATAExtraConfig & ATACFGE_CONF_DESC2);
-	US_DEBUGP("      Skip Device Boot: 0x%x\n",
-		  info->ConfigData.ATAExtraConfig & ATACFGE_SKIP_BOOT);
-	US_DEBUGP("      ATA 3 State Supsend: 0x%x\n",
-		  info->ConfigData.ATAExtraConfig & ATACFGE_STATE_SUSPEND);
-	US_DEBUGP("      Descriptor Override: 0x%x\n", 
-		  info->ConfigData.ATAExtraConfig & ATACFGE_DESC_OVERRIDE);
-	US_DEBUGP("      Last LUN Identifier: 0x%x\n",
-		  info->ConfigData.ATAExtraConfig & ATACFGE_LAST_LUN);
-	US_DEBUGP("      SRST Enable: 0x%x\n", 
-		  info->ConfigData.ATAExtraConfig & CFG_CAPABILITY_SRST);
+	usb_stor_dbg(us, "      Event Notification: 0x%x\n",
+		     info->ConfigData.EventNotification);
+	usb_stor_dbg(us, "      External Clock: 0x%x\n",
+		     info->ConfigData.ExternalClock);
+	usb_stor_dbg(us, "      ATA Init Timeout: 0x%x\n",
+		     info->ConfigData.ATAInitTimeout);
+	usb_stor_dbg(us, "      ATAPI Command Block Size: 0x%x\n",
+		     (info->ConfigData.ATAConfig & ATACFG_BLOCKSIZE) >> 6);
+	usb_stor_dbg(us, "      Master/Slave Selection: 0x%x\n",
+		     info->ConfigData.ATAConfig & ATACFG_MASTER);
+	usb_stor_dbg(us, "      ATAPI Reset: 0x%x\n",
+		     info->ConfigData.ATAConfig & ATACFG_ATAPI_RESET);
+	usb_stor_dbg(us, "      ATA Timing: 0x%x\n",
+		     info->ConfigData.ATAConfig & ATACFG_TIMING);
+	usb_stor_dbg(us, "      ATA Major Command: 0x%x\n",
+		     info->ConfigData.ATAMajorCommand);
+	usb_stor_dbg(us, "      ATA Minor Command: 0x%x\n",
+		     info->ConfigData.ATAMinorCommand);
+	usb_stor_dbg(us, "      Init Status: 0x%x\n",
+		     info->ConfigData.ATAExtraConfig & ATACFGE_INIT_STATUS);
+	usb_stor_dbg(us, "      Config Descriptor 2: 0x%x\n",
+		     info->ConfigData.ATAExtraConfig & ATACFGE_CONF_DESC2);
+	usb_stor_dbg(us, "      Skip Device Boot: 0x%x\n",
+		     info->ConfigData.ATAExtraConfig & ATACFGE_SKIP_BOOT);
+	usb_stor_dbg(us, "      ATA 3 State Supsend: 0x%x\n",
+		     info->ConfigData.ATAExtraConfig & ATACFGE_STATE_SUSPEND);
+	usb_stor_dbg(us, "      Descriptor Override: 0x%x\n",
+		     info->ConfigData.ATAExtraConfig & ATACFGE_DESC_OVERRIDE);
+	usb_stor_dbg(us, "      Last LUN Identifier: 0x%x\n",
+		     info->ConfigData.ATAExtraConfig & ATACFGE_LAST_LUN);
+	usb_stor_dbg(us, "      SRST Enable: 0x%x\n",
+		     info->ConfigData.ATAExtraConfig & CFG_CAPABILITY_SRST);
 }
 #endif
 
@@ -762,9 +763,9 @@ static int isd200_write_config( struct us_data *us )
 	int result;
 
 #ifdef CONFIG_USB_STORAGE_DEBUG
-	US_DEBUGP("Entering isd200_write_config\n");
-	US_DEBUGP("   Writing the following ISD200 Config Data:\n");
-	isd200_log_config(info);
+	usb_stor_dbg(us, "Entering isd200_write_config\n");
+	usb_stor_dbg(us, "   Writing the following ISD200 Config Data:\n");
+	isd200_log_config(us, info);
 #endif
 
 	/* let's send the command via the control pipe */
@@ -779,13 +780,13 @@ static int isd200_write_config( struct us_data *us )
 		sizeof(info->ConfigData));
 
 	if (result >= 0) {
-		US_DEBUGP("   ISD200 Config Data was written successfully\n");
+		usb_stor_dbg(us, "   ISD200 Config Data was written successfully\n");
 	} else {
-		US_DEBUGP("   Request to write ISD200 Config Data failed!\n");
+		usb_stor_dbg(us, "   Request to write ISD200 Config Data failed!\n");
 		retStatus = ISD200_ERROR;
 	}
 
-	US_DEBUGP("Leaving isd200_write_config %08X\n", retStatus);
+	usb_stor_dbg(us, "Leaving isd200_write_config %08X\n", retStatus);
 	return retStatus;
 }
 
@@ -804,7 +805,7 @@ static int isd200_read_config( struct us_data *us )
 	int retStatus = ISD200_GOOD;
 	int result;
 
-	US_DEBUGP("Entering isd200_read_config\n");
+	usb_stor_dbg(us, "Entering isd200_read_config\n");
 
 	/* read the configuration information from ISD200.  Use this to */
 	/* determine what the special ATA CDB bytes are.		*/
@@ -821,16 +822,16 @@ static int isd200_read_config( struct us_data *us )
 
 
 	if (result >= 0) {
-		US_DEBUGP("   Retrieved the following ISD200 Config Data:\n");
+		usb_stor_dbg(us, "   Retrieved the following ISD200 Config Data:\n");
 #ifdef CONFIG_USB_STORAGE_DEBUG
-		isd200_log_config(info);
+		isd200_log_config(us, info);
 #endif
 	} else {
-		US_DEBUGP("   Request to get ISD200 Config Data failed!\n");
+		usb_stor_dbg(us, "   Request to get ISD200 Config Data failed!\n");
 		retStatus = ISD200_ERROR;
 	}
 
-	US_DEBUGP("Leaving isd200_read_config %08X\n", retStatus);
+	usb_stor_dbg(us, "Leaving isd200_read_config %08X\n", retStatus);
 	return retStatus;
 }
 
@@ -848,15 +849,15 @@ static int isd200_atapi_soft_reset( struct us_data *us )
 	int retStatus = ISD200_GOOD;
 	int transferStatus;
 
-	US_DEBUGP("Entering isd200_atapi_soft_reset\n");
+	usb_stor_dbg(us, "Entering isd200_atapi_soft_reset\n");
 
 	transferStatus = isd200_action( us, ACTION_SOFT_RESET, NULL, 0 );
 	if (transferStatus != ISD200_TRANSPORT_GOOD) {
-		US_DEBUGP("   Error issuing Atapi Soft Reset\n");
+		usb_stor_dbg(us, "   Error issuing Atapi Soft Reset\n");
 		retStatus = ISD200_ERROR;
 	}
 
-	US_DEBUGP("Leaving isd200_atapi_soft_reset %08X\n", retStatus);
+	usb_stor_dbg(us, "Leaving isd200_atapi_soft_reset %08X\n", retStatus);
 	return retStatus;
 }
 
@@ -874,13 +875,13 @@ static int isd200_srst( struct us_data *us )
 	int retStatus = ISD200_GOOD;
 	int transferStatus;
 
-	US_DEBUGP("Entering isd200_SRST\n");
+	usb_stor_dbg(us, "Entering isd200_SRST\n");
 
 	transferStatus = isd200_action( us, ACTION_RESET, NULL, 0 );
 
 	/* check to see if this request failed */
 	if (transferStatus != ISD200_TRANSPORT_GOOD) {
-		US_DEBUGP("   Error issuing SRST\n");
+		usb_stor_dbg(us, "   Error issuing SRST\n");
 		retStatus = ISD200_ERROR;
 	} else {
 		/* delay 10ms to give the drive a chance to see it */
@@ -888,7 +889,7 @@ static int isd200_srst( struct us_data *us )
 
 		transferStatus = isd200_action( us, ACTION_REENABLE, NULL, 0 );
 		if (transferStatus != ISD200_TRANSPORT_GOOD) {
-			US_DEBUGP("   Error taking drive out of reset\n");
+			usb_stor_dbg(us, "   Error taking drive out of reset\n");
 			retStatus = ISD200_ERROR;
 		} else {
 			/* delay 50ms to give the drive a chance to recover after SRST */
@@ -896,7 +897,7 @@ static int isd200_srst( struct us_data *us )
 		}
 	}
 
-	US_DEBUGP("Leaving isd200_srst %08X\n", retStatus);
+	usb_stor_dbg(us, "Leaving isd200_srst %08X\n", retStatus);
 	return retStatus;
 }
 
@@ -938,13 +939,13 @@ static int isd200_try_enum(struct us_data *us, unsigned char master_slave,
 
 		if (!detect) {
 			if (regs[ATA_REG_STATUS_OFFSET] & ATA_BUSY) {
-				US_DEBUGP("   %s status is still BSY, try again...\n",
-					  master_slave == ATA_ADDRESS_DEVHEAD_STD ?
-					  "Master" : "Slave");
+				usb_stor_dbg(us, "   %s status is still BSY, try again...\n",
+					     master_slave == ATA_ADDRESS_DEVHEAD_STD ?
+					     "Master" : "Slave");
 			} else {
-				US_DEBUGP("   %s status !BSY, continue with next operation\n",
-					  master_slave == ATA_ADDRESS_DEVHEAD_STD ?
-					  "Master" : "Slave");
+				usb_stor_dbg(us, "   %s status !BSY, continue with next operation\n",
+					     master_slave == ATA_ADDRESS_DEVHEAD_STD ?
+					     "Master" : "Slave");
 				break;
 			}
 		}
@@ -953,11 +954,11 @@ static int isd200_try_enum(struct us_data *us, unsigned char master_slave,
 		/* ATA_ERR (workaround for Archos CD-ROM) */
 		else if (regs[ATA_REG_STATUS_OFFSET] &
 			 (ATA_BUSY | ATA_DF | ATA_ERR)) {
-			US_DEBUGP("   Status indicates it is not ready, try again...\n");
+			usb_stor_dbg(us, "   Status indicates it is not ready, try again...\n");
 		}
 		/* check for DRDY, ATA devices set DRDY after SRST */
 		else if (regs[ATA_REG_STATUS_OFFSET] & ATA_DRDY) {
-			US_DEBUGP("   Identified ATA device\n");
+			usb_stor_dbg(us, "   Identified ATA device\n");
 			info->DeviceFlags |= DF_ATA_DEVICE;
 			info->DeviceHead = master_slave;
 			break;
@@ -978,27 +979,27 @@ static int isd200_try_enum(struct us_data *us, unsigned char master_slave,
 			*/
 			if ((master_slave & ATA_ADDRESS_DEVHEAD_SLAVE) &&
 			    !recheckAsMaster) {
-				US_DEBUGP("   Identified ATAPI device as slave.  Rechecking again as master\n");
+				usb_stor_dbg(us, "   Identified ATAPI device as slave.  Rechecking again as master\n");
 				recheckAsMaster = 1;
 				master_slave = ATA_ADDRESS_DEVHEAD_STD;
 			} else {
-				US_DEBUGP("   Identified ATAPI device\n");
+				usb_stor_dbg(us, "   Identified ATAPI device\n");
 				info->DeviceHead = master_slave;
 			      
 				status = isd200_atapi_soft_reset(us);
 				break;
 			}
 		} else {
- 			US_DEBUGP("   Not ATA, not ATAPI. Weird.\n");
+			usb_stor_dbg(us, "   Not ATA, not ATAPI - Weird\n");
 			break;
 		}
 
 		/* check for timeout on this request */
 		if (time_after_eq(jiffies, endTime)) {
 			if (!detect)
-				US_DEBUGP("   BSY check timeout, just continue with next operation...\n");
+				usb_stor_dbg(us, "   BSY check timeout, just continue with next operation...\n");
 			else
-				US_DEBUGP("   Device detect timeout!\n");
+				usb_stor_dbg(us, "   Device detect timeout!\n");
 			break;
 		}
 	}
@@ -1020,7 +1021,7 @@ static int isd200_manual_enum(struct us_data *us)
 	struct isd200_info *info = (struct isd200_info *)us->extra;
 	int retStatus = ISD200_GOOD;
 
-	US_DEBUGP("Entering isd200_manual_enum\n");
+	usb_stor_dbg(us, "Entering isd200_manual_enum\n");
 
 	retStatus = isd200_read_config(us);
 	if (retStatus == ISD200_GOOD) {
@@ -1039,14 +1040,15 @@ static int isd200_manual_enum(struct us_data *us)
 
 		isslave = (info->DeviceHead & ATA_ADDRESS_DEVHEAD_SLAVE) ? 1 : 0;
 		if (!(info->ConfigData.ATAConfig & ATACFG_MASTER)) {
-			US_DEBUGP("   Setting Master/Slave selection to %d\n", isslave);
+			usb_stor_dbg(us, "   Setting Master/Slave selection to %d\n",
+				     isslave);
 			info->ConfigData.ATAConfig &= 0x3f;
 			info->ConfigData.ATAConfig |= (isslave<<6);
 			retStatus = isd200_write_config(us);
 		}
 	}
 
-	US_DEBUGP("Leaving isd200_manual_enum %08X\n", retStatus);
+	usb_stor_dbg(us, "Leaving isd200_manual_enum %08X\n", retStatus);
 	return(retStatus);
 }
 
@@ -1064,35 +1066,35 @@ static void isd200_fix_driveid(u16 *id)
 #endif
 }
 
-static void isd200_dump_driveid(u16 *id)
+static void isd200_dump_driveid(struct us_data *us, u16 *id)
 {
-	US_DEBUGP("   Identify Data Structure:\n");
-	US_DEBUGP("      config = 0x%x\n",	  id[ATA_ID_CONFIG]);
-	US_DEBUGP("      cyls = 0x%x\n",	  id[ATA_ID_CYLS]);
-	US_DEBUGP("      heads = 0x%x\n",	  id[ATA_ID_HEADS]);
-	US_DEBUGP("      track_bytes = 0x%x\n",	  id[4]);
-	US_DEBUGP("      sector_bytes = 0x%x\n",  id[5]);
-	US_DEBUGP("      sectors = 0x%x\n",	  id[ATA_ID_SECTORS]);
-	US_DEBUGP("      serial_no[0] = 0x%x\n",  *(char *)&id[ATA_ID_SERNO]);
-	US_DEBUGP("      buf_type = 0x%x\n",	  id[20]);
-	US_DEBUGP("      buf_size = 0x%x\n",	  id[ATA_ID_BUF_SIZE]);
-	US_DEBUGP("      ecc_bytes = 0x%x\n",	  id[22]);
-	US_DEBUGP("      fw_rev[0] = 0x%x\n",	  *(char *)&id[ATA_ID_FW_REV]);
-	US_DEBUGP("      model[0] = 0x%x\n",	  *(char *)&id[ATA_ID_PROD]);
-	US_DEBUGP("      max_multsect = 0x%x\n",  id[ATA_ID_MAX_MULTSECT] & 0xff);
-	US_DEBUGP("      dword_io = 0x%x\n",	  id[ATA_ID_DWORD_IO]);
-	US_DEBUGP("      capability = 0x%x\n",	  id[ATA_ID_CAPABILITY] >> 8);
-	US_DEBUGP("      tPIO = 0x%x\n",	  id[ATA_ID_OLD_PIO_MODES] >> 8);
-	US_DEBUGP("      tDMA = 0x%x\n",	  id[ATA_ID_OLD_DMA_MODES] >> 8);
-	US_DEBUGP("      field_valid = 0x%x\n",	  id[ATA_ID_FIELD_VALID]);
-	US_DEBUGP("      cur_cyls = 0x%x\n",	  id[ATA_ID_CUR_CYLS]);
-	US_DEBUGP("      cur_heads = 0x%x\n",	  id[ATA_ID_CUR_HEADS]);
-	US_DEBUGP("      cur_sectors = 0x%x\n",	  id[ATA_ID_CUR_SECTORS]);
-	US_DEBUGP("      cur_capacity = 0x%x\n",  ata_id_u32(id, 57));
-	US_DEBUGP("      multsect = 0x%x\n",	  id[ATA_ID_MULTSECT] & 0xff);
-	US_DEBUGP("      lba_capacity = 0x%x\n",  ata_id_u32(id, ATA_ID_LBA_CAPACITY));
-	US_DEBUGP("      command_set_1 = 0x%x\n", id[ATA_ID_COMMAND_SET_1]);
-	US_DEBUGP("      command_set_2 = 0x%x\n", id[ATA_ID_COMMAND_SET_2]);
+	usb_stor_dbg(us, "   Identify Data Structure:\n");
+	usb_stor_dbg(us, "      config = 0x%x\n",	id[ATA_ID_CONFIG]);
+	usb_stor_dbg(us, "      cyls = 0x%x\n",		id[ATA_ID_CYLS]);
+	usb_stor_dbg(us, "      heads = 0x%x\n",	id[ATA_ID_HEADS]);
+	usb_stor_dbg(us, "      track_bytes = 0x%x\n",	id[4]);
+	usb_stor_dbg(us, "      sector_bytes = 0x%x\n", id[5]);
+	usb_stor_dbg(us, "      sectors = 0x%x\n",	id[ATA_ID_SECTORS]);
+	usb_stor_dbg(us, "      serial_no[0] = 0x%x\n", *(char *)&id[ATA_ID_SERNO]);
+	usb_stor_dbg(us, "      buf_type = 0x%x\n",	id[20]);
+	usb_stor_dbg(us, "      buf_size = 0x%x\n",	id[ATA_ID_BUF_SIZE]);
+	usb_stor_dbg(us, "      ecc_bytes = 0x%x\n",	id[22]);
+	usb_stor_dbg(us, "      fw_rev[0] = 0x%x\n",	*(char *)&id[ATA_ID_FW_REV]);
+	usb_stor_dbg(us, "      model[0] = 0x%x\n",	*(char *)&id[ATA_ID_PROD]);
+	usb_stor_dbg(us, "      max_multsect = 0x%x\n", id[ATA_ID_MAX_MULTSECT] & 0xff);
+	usb_stor_dbg(us, "      dword_io = 0x%x\n",	id[ATA_ID_DWORD_IO]);
+	usb_stor_dbg(us, "      capability = 0x%x\n",	id[ATA_ID_CAPABILITY] >> 8);
+	usb_stor_dbg(us, "      tPIO = 0x%x\n",	  id[ATA_ID_OLD_PIO_MODES] >> 8);
+	usb_stor_dbg(us, "      tDMA = 0x%x\n",	  id[ATA_ID_OLD_DMA_MODES] >> 8);
+	usb_stor_dbg(us, "      field_valid = 0x%x\n",	id[ATA_ID_FIELD_VALID]);
+	usb_stor_dbg(us, "      cur_cyls = 0x%x\n",	id[ATA_ID_CUR_CYLS]);
+	usb_stor_dbg(us, "      cur_heads = 0x%x\n",	id[ATA_ID_CUR_HEADS]);
+	usb_stor_dbg(us, "      cur_sectors = 0x%x\n",	id[ATA_ID_CUR_SECTORS]);
+	usb_stor_dbg(us, "      cur_capacity = 0x%x\n", ata_id_u32(id, 57));
+	usb_stor_dbg(us, "      multsect = 0x%x\n",	id[ATA_ID_MULTSECT] & 0xff);
+	usb_stor_dbg(us, "      lba_capacity = 0x%x\n", ata_id_u32(id, ATA_ID_LBA_CAPACITY));
+	usb_stor_dbg(us, "      command_set_1 = 0x%x\n", id[ATA_ID_COMMAND_SET_1]);
+	usb_stor_dbg(us, "      command_set_2 = 0x%x\n", id[ATA_ID_COMMAND_SET_2]);
 }
 
 /**************************************************************************
@@ -1109,7 +1111,7 @@ static int isd200_get_inquiry_data( struct us_data *us )
 	int retStatus = ISD200_GOOD;
 	u16 *id = info->id;
 
-	US_DEBUGP("Entering isd200_get_inquiry_data\n");
+	usb_stor_dbg(us, "Entering isd200_get_inquiry_data\n");
 
 	/* set default to Master */
 	info->DeviceHead = ATA_ADDRESS_DEVHEAD_STD;
@@ -1127,7 +1129,7 @@ static int isd200_get_inquiry_data( struct us_data *us )
 							id, ATA_ID_WORDS * 2);
 			if (transferStatus != ISD200_TRANSPORT_GOOD) {
 				/* Error issuing ATA Command Identify */
-				US_DEBUGP("   Error issuing ATA Command Identify\n");
+				usb_stor_dbg(us, "   Error issuing ATA Command Identify\n");
 				retStatus = ISD200_ERROR;
 			} else {
 				/* ATA Command Identify successful */
@@ -1136,7 +1138,7 @@ static int isd200_get_inquiry_data( struct us_data *us )
 				__u16 *dest;
 
 				isd200_fix_driveid(id);
-				isd200_dump_driveid(id);
+				isd200_dump_driveid(us, id);
 
 				memset(&info->InquiryData, 0, sizeof(info->InquiryData));
 
@@ -1170,7 +1172,7 @@ static int isd200_get_inquiry_data( struct us_data *us )
 
 				/* determine if it supports Media Status Notification */
 				if (id[ATA_ID_COMMAND_SET_2] & COMMANDSET_MEDIA_STATUS) {
-					US_DEBUGP("   Device supports Media Status Notification\n");
+					usb_stor_dbg(us, "   Device supports Media Status Notification\n");
 
 					/* Indicate that it is enabled, even though it is not
 					 * This allows the lock/unlock of the media to work
@@ -1190,7 +1192,8 @@ static int isd200_get_inquiry_data( struct us_data *us )
 			us->protocol_name = "Transparent SCSI";
 			us->proto_handler = usb_stor_transparent_scsi_command;
 
-			US_DEBUGP("Protocol changed to: %s\n", us->protocol_name);
+			usb_stor_dbg(us, "Protocol changed to: %s\n",
+				     us->protocol_name);
 	    
 			/* Free driver structure */	    
 			us->extra_destructor(info);
@@ -1200,7 +1203,7 @@ static int isd200_get_inquiry_data( struct us_data *us )
 		}
 	}
 
-	US_DEBUGP("Leaving isd200_get_inquiry_data %08X\n", retStatus);
+	usb_stor_dbg(us, "Leaving isd200_get_inquiry_data %08X\n", retStatus);
 
 	return(retStatus);
 }
@@ -1231,7 +1234,7 @@ static int isd200_scsi_to_ata(struct scsi_cmnd *srb, struct us_data *us,
 	/* SCSI Command */
 	switch (srb->cmnd[0]) {
 	case INQUIRY:
-		US_DEBUGP("   ATA OUT - INQUIRY\n");
+		usb_stor_dbg(us, "   ATA OUT - INQUIRY\n");
 
 		/* copy InquiryData */
 		usb_stor_set_xfer_buf((unsigned char *) &info->InquiryData,
@@ -1241,7 +1244,7 @@ static int isd200_scsi_to_ata(struct scsi_cmnd *srb, struct us_data *us,
 		break;
 
 	case MODE_SENSE:
-		US_DEBUGP("   ATA OUT - SCSIOP_MODE_SENSE\n");
+		usb_stor_dbg(us, "   ATA OUT - SCSIOP_MODE_SENSE\n");
 
 		/* Initialize the return buffer */
 		usb_stor_set_xfer_buf(senseData, sizeof(senseData), srb);
@@ -1255,14 +1258,14 @@ static int isd200_scsi_to_ata(struct scsi_cmnd *srb, struct us_data *us,
 			ataCdb->write.CommandByte = ATA_COMMAND_GET_MEDIA_STATUS;
 			isd200_srb_set_bufflen(srb, 0);
 		} else {
-			US_DEBUGP("   Media Status not supported, just report okay\n");
+			usb_stor_dbg(us, "   Media Status not supported, just report okay\n");
 			srb->result = SAM_STAT_GOOD;
 			sendToTransport = 0;
 		}
 		break;
 
 	case TEST_UNIT_READY:
-		US_DEBUGP("   ATA OUT - SCSIOP_TEST_UNIT_READY\n");
+		usb_stor_dbg(us, "   ATA OUT - SCSIOP_TEST_UNIT_READY\n");
 
 		if (info->DeviceFlags & DF_MEDIA_STATUS_ENABLED)
 		{
@@ -1273,7 +1276,7 @@ static int isd200_scsi_to_ata(struct scsi_cmnd *srb, struct us_data *us,
 			ataCdb->write.CommandByte = ATA_COMMAND_GET_MEDIA_STATUS;
 			isd200_srb_set_bufflen(srb, 0);
 		} else {
-			US_DEBUGP("   Media Status not supported, just report okay\n");
+			usb_stor_dbg(us, "   Media Status not supported, just report okay\n");
 			srb->result = SAM_STAT_GOOD;
 			sendToTransport = 0;
 		}
@@ -1284,7 +1287,7 @@ static int isd200_scsi_to_ata(struct scsi_cmnd *srb, struct us_data *us,
 		unsigned long capacity;
 		struct read_capacity_data readCapacityData;
 
-		US_DEBUGP("   ATA OUT - SCSIOP_READ_CAPACITY\n");
+		usb_stor_dbg(us, "   ATA OUT - SCSIOP_READ_CAPACITY\n");
 
 		if (ata_id_has_lba(id))
 			capacity = ata_id_u32(id, ATA_ID_LBA_CAPACITY) - 1;
@@ -1303,7 +1306,7 @@ static int isd200_scsi_to_ata(struct scsi_cmnd *srb, struct us_data *us,
 	break;
 
 	case READ_10:
-		US_DEBUGP("   ATA OUT - SCSIOP_READ\n");
+		usb_stor_dbg(us, "   ATA OUT - SCSIOP_READ\n");
 
 		lba = be32_to_cpu(*(__be32 *)&srb->cmnd[2]);
 		blockCount = (unsigned long)srb->cmnd[7]<<8 | (unsigned long)srb->cmnd[8];
@@ -1335,7 +1338,7 @@ static int isd200_scsi_to_ata(struct scsi_cmnd *srb, struct us_data *us,
 		break;
 
 	case WRITE_10:
-		US_DEBUGP("   ATA OUT - SCSIOP_WRITE\n");
+		usb_stor_dbg(us, "   ATA OUT - SCSIOP_WRITE\n");
 
 		lba = be32_to_cpu(*(__be32 *)&srb->cmnd[2]);
 		blockCount = (unsigned long)srb->cmnd[7]<<8 | (unsigned long)srb->cmnd[8];
@@ -1367,10 +1370,11 @@ static int isd200_scsi_to_ata(struct scsi_cmnd *srb, struct us_data *us,
 		break;
 
 	case ALLOW_MEDIUM_REMOVAL:
-		US_DEBUGP("   ATA OUT - SCSIOP_MEDIUM_REMOVAL\n");
+		usb_stor_dbg(us, "   ATA OUT - SCSIOP_MEDIUM_REMOVAL\n");
 
 		if (info->DeviceFlags & DF_REMOVABLE_MEDIA) {
-			US_DEBUGP("   srb->cmnd[4] = 0x%X\n", srb->cmnd[4]);
+			usb_stor_dbg(us, "   srb->cmnd[4] = 0x%X\n",
+				     srb->cmnd[4]);
 	    
 			ataCdb->generic.SignatureByte0 = info->ConfigData.ATAMajorCommand;
 			ataCdb->generic.SignatureByte1 = info->ConfigData.ATAMinorCommand;
@@ -1380,25 +1384,25 @@ static int isd200_scsi_to_ata(struct scsi_cmnd *srb, struct us_data *us,
 				ATA_CMD_MEDIA_LOCK : ATA_CMD_MEDIA_UNLOCK;
 			isd200_srb_set_bufflen(srb, 0);
 		} else {
-			US_DEBUGP("   Not removeable media, just report okay\n");
+			usb_stor_dbg(us, "   Not removeable media, just report okay\n");
 			srb->result = SAM_STAT_GOOD;
 			sendToTransport = 0;
 		}
 		break;
 
 	case START_STOP:    
-		US_DEBUGP("   ATA OUT - SCSIOP_START_STOP_UNIT\n");
-		US_DEBUGP("   srb->cmnd[4] = 0x%X\n", srb->cmnd[4]);
+		usb_stor_dbg(us, "   ATA OUT - SCSIOP_START_STOP_UNIT\n");
+		usb_stor_dbg(us, "   srb->cmnd[4] = 0x%X\n", srb->cmnd[4]);
 
 		if ((srb->cmnd[4] & 0x3) == 0x2) {
-			US_DEBUGP("   Media Eject\n");
+			usb_stor_dbg(us, "   Media Eject\n");
 			ataCdb->generic.SignatureByte0 = info->ConfigData.ATAMajorCommand;
 			ataCdb->generic.SignatureByte1 = info->ConfigData.ATAMinorCommand;
 			ataCdb->generic.TransferBlockSize = 0;
 			ataCdb->generic.RegisterSelect = REG_COMMAND;
 			ataCdb->write.CommandByte = ATA_COMMAND_MEDIA_EJECT;
 		} else if ((srb->cmnd[4] & 0x3) == 0x1) {
-			US_DEBUGP("   Get Media Status\n");
+			usb_stor_dbg(us, "   Get Media Status\n");
 			ataCdb->generic.SignatureByte0 = info->ConfigData.ATAMajorCommand;
 			ataCdb->generic.SignatureByte1 = info->ConfigData.ATAMinorCommand;
 			ataCdb->generic.TransferBlockSize = 1;
@@ -1406,14 +1410,15 @@ static int isd200_scsi_to_ata(struct scsi_cmnd *srb, struct us_data *us,
 			ataCdb->write.CommandByte = ATA_COMMAND_GET_MEDIA_STATUS;
 			isd200_srb_set_bufflen(srb, 0);
 		} else {
-			US_DEBUGP("   Nothing to do, just report okay\n");
+			usb_stor_dbg(us, "   Nothing to do, just report okay\n");
 			srb->result = SAM_STAT_GOOD;
 			sendToTransport = 0;
 		}
 		break;
 
 	default:
-		US_DEBUGP("Unsupported SCSI command - 0x%X\n", srb->cmnd[0]);
+		usb_stor_dbg(us, "Unsupported SCSI command - 0x%X\n",
+			     srb->cmnd[0]);
 		srb->result = DID_ERROR << 16;
 		sendToTransport = 0;
 		break;
@@ -1470,8 +1475,7 @@ static int isd200_init_info(struct us_data *us)
 	if (retStatus == ISD200_GOOD) {
 		us->extra = info;
 		us->extra_destructor = isd200_free_info_ptrs;
-	} else
-		US_DEBUGP("ERROR - kmalloc failure\n");
+	}
 
 	return retStatus;
 }
@@ -1482,19 +1486,19 @@ static int isd200_init_info(struct us_data *us)
 
 static int isd200_Initialization(struct us_data *us)
 {
-	US_DEBUGP("ISD200 Initialization...\n");
+	usb_stor_dbg(us, "ISD200 Initialization...\n");
 
 	/* Initialize ISD200 info struct */
 
 	if (isd200_init_info(us) == ISD200_ERROR) {
-		US_DEBUGP("ERROR Initializing ISD200 Info struct\n");
+		usb_stor_dbg(us, "ERROR Initializing ISD200 Info struct\n");
 	} else {
 		/* Get device specific data */
 
 		if (isd200_get_inquiry_data(us) != ISD200_GOOD)
-			US_DEBUGP("ISD200 Initialization Failure\n");
+			usb_stor_dbg(us, "ISD200 Initialization Failure\n");
 		else
-			US_DEBUGP("ISD200 Initialization complete\n");
+			usb_stor_dbg(us, "ISD200 Initialization complete\n");
 	}
 
 	return 0;
@@ -1519,7 +1523,7 @@ static void isd200_ata_command(struct scsi_cmnd *srb, struct us_data *us)
 	/* Make sure driver was initialized */
 
 	if (us->extra == NULL)
-		US_DEBUGP("ERROR Driver not initialized\n");
+		usb_stor_dbg(us, "ERROR Driver not initialized\n");
 
 	scsi_set_resid(srb, 0);
 	/* scsi_bufflen might change in protocol translation to ata */
diff --git a/drivers/usb/storage/jumpshot.c b/drivers/usb/storage/jumpshot.c
index ddc7878..563078b 100644
--- a/drivers/usb/storage/jumpshot.c
+++ b/drivers/usb/storage/jumpshot.c
@@ -118,7 +118,7 @@ static inline int jumpshot_bulk_read(struct us_data *us,
 	if (len == 0)
 		return USB_STOR_XFER_GOOD;
 
-	US_DEBUGP("jumpshot_bulk_read:  len = %d\n", len);
+	usb_stor_dbg(us, "len = %d\n", len);
 	return usb_stor_bulk_transfer_buf(us, us->recv_bulk_pipe,
 			data, len, NULL);
 }
@@ -131,7 +131,7 @@ static inline int jumpshot_bulk_write(struct us_data *us,
 	if (len == 0)
 		return USB_STOR_XFER_GOOD;
 
-	US_DEBUGP("jumpshot_bulk_write:  len = %d\n", len);
+	usb_stor_dbg(us, "len = %d\n", len);
 	return usb_stor_bulk_transfer_buf(us, us->send_bulk_pipe,
 			data, len, NULL);
 }
@@ -152,8 +152,7 @@ static int jumpshot_get_status(struct us_data  *us)
 		return USB_STOR_TRANSPORT_ERROR;
 
 	if (us->iobuf[0] != 0x50) {
-		US_DEBUGP("jumpshot_get_status:  0x%2x\n",
-			  us->iobuf[0]);
+		usb_stor_dbg(us, "0x%2x\n", us->iobuf[0]);
 		return USB_STOR_TRANSPORT_ERROR;
 	}
 
@@ -218,7 +217,7 @@ static int jumpshot_read_data(struct us_data *us,
 		if (result != USB_STOR_XFER_GOOD)
 			goto leave;
 
-		US_DEBUGP("jumpshot_read_data:  %d bytes\n", len);
+		usb_stor_dbg(us, "%d bytes\n", len);
 
 		// Store the data in the transfer buffer
 		usb_stor_access_xfer_buf(buffer, len, us->srb,
@@ -314,7 +313,7 @@ static int jumpshot_write_data(struct us_data *us,
 		} while ((result != USB_STOR_TRANSPORT_GOOD) && (waitcount < 10));
 
 		if (result != USB_STOR_TRANSPORT_GOOD)
-			US_DEBUGP("jumpshot_write_data:  Gah!  Waitcount = 10.  Bad write!?\n");
+			usb_stor_dbg(us, "Gah!  Waitcount = 10.  Bad write!?\n");
 
 		sector += thistime;
 		totallen -= len;
@@ -349,8 +348,7 @@ static int jumpshot_id_device(struct us_data *us,
 				   0, 0x20, 0, 6, command, 2);
 
 	if (rc != USB_STOR_XFER_GOOD) {
-		US_DEBUGP("jumpshot_id_device:  Gah! "
-			  "send_control for read_capacity failed\n");
+		usb_stor_dbg(us, "Gah! send_control for read_capacity failed\n");
 		rc = USB_STOR_TRANSPORT_ERROR;
 		goto leave;
 	}
@@ -400,17 +398,17 @@ static int jumpshot_handle_mode_sense(struct us_data *us,
 
 	switch (pc) {
 	   case 0x0:
-		US_DEBUGP("jumpshot_handle_mode_sense:  Current values\n");
-		break;
+		   usb_stor_dbg(us, "Current values\n");
+		   break;
 	   case 0x1:
-		US_DEBUGP("jumpshot_handle_mode_sense:  Changeable values\n");
-		break;
+		   usb_stor_dbg(us, "Changeable values\n");
+		   break;
 	   case 0x2:
-		US_DEBUGP("jumpshot_handle_mode_sense:  Default values\n");
-		break;
+		   usb_stor_dbg(us, "Default values\n");
+		   break;
 	   case 0x3:
-		US_DEBUGP("jumpshot_handle_mode_sense:  Saves values\n");
-		break;
+		   usb_stor_dbg(us, "Saves values\n");
+		   break;
 	}
 
 	memset(ptr, 0, 8);
@@ -494,17 +492,16 @@ static int jumpshot_transport(struct scsi_cmnd *srb, struct us_data *us)
 
 	if (!us->extra) {
 		us->extra = kzalloc(sizeof(struct jumpshot_info), GFP_NOIO);
-		if (!us->extra) {
-			US_DEBUGP("jumpshot_transport:  Gah! Can't allocate storage for jumpshot info struct!\n");
+		if (!us->extra)
 			return USB_STOR_TRANSPORT_ERROR;
-		}
+
 		us->extra_destructor = jumpshot_info_destructor;
 	}
 
 	info = (struct jumpshot_info *) (us->extra);
 
 	if (srb->cmnd[0] == INQUIRY) {
-		US_DEBUGP("jumpshot_transport:  INQUIRY.  Returning bogus response.\n");
+		usb_stor_dbg(us, "INQUIRY - Returning bogus response\n");
 		memcpy(ptr, inquiry_response, sizeof(inquiry_response));
 		fill_inquiry_response(us, ptr, 36);
 		return USB_STOR_TRANSPORT_GOOD;
@@ -521,8 +518,8 @@ static int jumpshot_transport(struct scsi_cmnd *srb, struct us_data *us)
 		if (rc != USB_STOR_TRANSPORT_GOOD)
 			return rc;
 
-		US_DEBUGP("jumpshot_transport:  READ_CAPACITY:  %ld sectors, %ld bytes per sector\n",
-			  info->sectors, info->ssize);
+		usb_stor_dbg(us, "READ_CAPACITY:  %ld sectors, %ld bytes per sector\n",
+			     info->sectors, info->ssize);
 
 		// build the reply
 		//
@@ -534,7 +531,7 @@ static int jumpshot_transport(struct scsi_cmnd *srb, struct us_data *us)
 	}
 
 	if (srb->cmnd[0] == MODE_SELECT_10) {
-		US_DEBUGP("jumpshot_transport:  Gah! MODE_SELECT_10.\n");
+		usb_stor_dbg(us, "Gah! MODE_SELECT_10\n");
 		return USB_STOR_TRANSPORT_ERROR;
 	}
 
@@ -544,7 +541,8 @@ static int jumpshot_transport(struct scsi_cmnd *srb, struct us_data *us)
 
 		blocks = ((u32)(srb->cmnd[7]) << 8) | ((u32)(srb->cmnd[8]));
 
-		US_DEBUGP("jumpshot_transport:  READ_10: read block 0x%04lx  count %ld\n", block, blocks);
+		usb_stor_dbg(us, "READ_10: read block 0x%04lx  count %ld\n",
+			     block, blocks);
 		return jumpshot_read_data(us, info, block, blocks);
 	}
 
@@ -557,7 +555,8 @@ static int jumpshot_transport(struct scsi_cmnd *srb, struct us_data *us)
 		blocks = ((u32)(srb->cmnd[6]) << 24) | ((u32)(srb->cmnd[7]) << 16) |
 			 ((u32)(srb->cmnd[8]) <<  8) | ((u32)(srb->cmnd[9]));
 
-		US_DEBUGP("jumpshot_transport:  READ_12: read block 0x%04lx  count %ld\n", block, blocks);
+		usb_stor_dbg(us, "READ_12: read block 0x%04lx  count %ld\n",
+			     block, blocks);
 		return jumpshot_read_data(us, info, block, blocks);
 	}
 
@@ -567,7 +566,8 @@ static int jumpshot_transport(struct scsi_cmnd *srb, struct us_data *us)
 
 		blocks = ((u32)(srb->cmnd[7]) << 8) | ((u32)(srb->cmnd[8]));
 
-		US_DEBUGP("jumpshot_transport:  WRITE_10: write block 0x%04lx  count %ld\n", block, blocks);
+		usb_stor_dbg(us, "WRITE_10: write block 0x%04lx  count %ld\n",
+			     block, blocks);
 		return jumpshot_write_data(us, info, block, blocks);
 	}
 
@@ -580,18 +580,19 @@ static int jumpshot_transport(struct scsi_cmnd *srb, struct us_data *us)
 		blocks = ((u32)(srb->cmnd[6]) << 24) | ((u32)(srb->cmnd[7]) << 16) |
 			 ((u32)(srb->cmnd[8]) <<  8) | ((u32)(srb->cmnd[9]));
 
-		US_DEBUGP("jumpshot_transport:  WRITE_12: write block 0x%04lx  count %ld\n", block, blocks);
+		usb_stor_dbg(us, "WRITE_12: write block 0x%04lx  count %ld\n",
+			     block, blocks);
 		return jumpshot_write_data(us, info, block, blocks);
 	}
 
 
 	if (srb->cmnd[0] == TEST_UNIT_READY) {
-		US_DEBUGP("jumpshot_transport:  TEST_UNIT_READY.\n");
+		usb_stor_dbg(us, "TEST_UNIT_READY\n");
 		return jumpshot_get_status(us);
 	}
 
 	if (srb->cmnd[0] == REQUEST_SENSE) {
-		US_DEBUGP("jumpshot_transport:  REQUEST_SENSE.\n");
+		usb_stor_dbg(us, "REQUEST_SENSE\n");
 
 		memset(ptr, 0, 18);
 		ptr[0] = 0xF0;
@@ -605,12 +606,12 @@ static int jumpshot_transport(struct scsi_cmnd *srb, struct us_data *us)
 	}
 
 	if (srb->cmnd[0] == MODE_SENSE) {
-		US_DEBUGP("jumpshot_transport:  MODE_SENSE_6 detected\n");
+		usb_stor_dbg(us, "MODE_SENSE_6 detected\n");
 		return jumpshot_handle_mode_sense(us, srb, 1);
 	}
 
 	if (srb->cmnd[0] == MODE_SENSE_10) {
-		US_DEBUGP("jumpshot_transport:  MODE_SENSE_10 detected\n");
+		usb_stor_dbg(us, "MODE_SENSE_10 detected\n");
 		return jumpshot_handle_mode_sense(us, srb, 0);
 	}
 
@@ -624,7 +625,7 @@ static int jumpshot_transport(struct scsi_cmnd *srb, struct us_data *us)
 	if (srb->cmnd[0] == START_STOP) {
 		/* this is used by sd.c'check_scsidisk_media_change to detect
 		   media change */
-		US_DEBUGP("jumpshot_transport:  START_STOP.\n");
+		usb_stor_dbg(us, "START_STOP\n");
 		/* the first jumpshot_id_device after a media change returns
 		   an error (determined experimentally) */
 		rc = jumpshot_id_device(us, info);
@@ -638,8 +639,8 @@ static int jumpshot_transport(struct scsi_cmnd *srb, struct us_data *us)
 		return rc;
 	}
 
-	US_DEBUGP("jumpshot_transport:  Gah! Unknown command: %d (0x%x)\n",
-		  srb->cmnd[0], srb->cmnd[0]);
+	usb_stor_dbg(us, "Gah! Unknown command: %d (0x%x)\n",
+		     srb->cmnd[0], srb->cmnd[0]);
 	info->sense_key = 0x05;
 	info->sense_asc = 0x20;
 	info->sense_ascq = 0x00;
diff --git a/drivers/usb/storage/karma.c b/drivers/usb/storage/karma.c
index f085ffb..94d16ee 100644
--- a/drivers/usb/storage/karma.c
+++ b/drivers/usb/storage/karma.c
@@ -106,7 +106,7 @@ static int rio_karma_send_command(char cmd, struct us_data *us)
 	static unsigned char seq = 1;
 	struct karma_data *data = (struct karma_data *) us->extra;
 
-	US_DEBUGP("karma: sending command %04x\n", cmd);
+	usb_stor_dbg(us, "sending command %04x\n", cmd);
 	memset(us->iobuf, 0, RIO_SEND_LEN);
 	memcpy(us->iobuf, RIO_PREFIX, RIO_PREFIX_LEN);
 	us->iobuf[5] = cmd;
@@ -139,10 +139,10 @@ static int rio_karma_send_command(char cmd, struct us_data *us)
 	if (seq == 0)
 		seq = 1;
 
-	US_DEBUGP("karma: sent command %04x\n", cmd);
+	usb_stor_dbg(us, "sent command %04x\n", cmd);
 	return 0;
 err:
-	US_DEBUGP("karma: command %04x failed\n", cmd);
+	usb_stor_dbg(us, "command %04x failed\n", cmd);
 	return USB_STOR_TRANSPORT_FAILED;
 }
 
diff --git a/drivers/usb/storage/option_ms.c b/drivers/usb/storage/option_ms.c
index e0f76bb..b2b35b1 100644
--- a/drivers/usb/storage/option_ms.c
+++ b/drivers/usb/storage/option_ms.c
@@ -50,7 +50,7 @@ static int option_rezero(struct us_data *us)
 	char *buffer;
 	int result;
 
-	US_DEBUGP("Option MS: %s", "DEVICE MODE SWITCH\n");
+	usb_stor_dbg(us, "Option MS: %s\n", "DEVICE MODE SWITCH");
 
 	buffer = kzalloc(RESPONSE_LEN, GFP_KERNEL);
 	if (buffer == NULL)
@@ -95,7 +95,7 @@ static int option_inquiry(struct us_data *us)
 	char *buffer;
 	int result;
 
-	US_DEBUGP("Option MS: %s", "device inquiry for vendor name\n");
+	usb_stor_dbg(us, "Option MS: %s\n", "device inquiry for vendor name");
 
 	buffer = kzalloc(0x24, GFP_KERNEL);
 	if (buffer == NULL)
@@ -138,31 +138,32 @@ int option_ms_init(struct us_data *us)
 {
 	int result;
 
-	US_DEBUGP("Option MS: option_ms_init called\n");
+	usb_stor_dbg(us, "Option MS: %s\n", "option_ms_init called");
 
 	/* Additional test for vendor information via INQUIRY,
 	 * because some vendor/product IDs are ambiguous
 	 */
 	result = option_inquiry(us);
 	if (result != 0) {
-		US_DEBUGP("Option MS: vendor is not Option or not determinable,"
-			  " no action taken\n");
+		usb_stor_dbg(us, "Option MS: %s\n",
+			     "vendor is not Option or not determinable, no action taken");
 		return 0;
 	} else
-		US_DEBUGP("Option MS: this is a genuine Option device,"
-			  " proceeding\n");
+		usb_stor_dbg(us, "Option MS: %s\n",
+			     "this is a genuine Option device, proceeding");
 
 	/* Force Modem mode */
 	if (option_zero_cd == ZCD_FORCE_MODEM) {
-		US_DEBUGP("Option MS: %s", "Forcing Modem Mode\n");
+		usb_stor_dbg(us, "Option MS: %s\n", "Forcing Modem Mode");
 		result = option_rezero(us);
 		if (result != USB_STOR_XFER_GOOD)
-			US_DEBUGP("Option MS: Failed to switch to modem mode.\n");
+			usb_stor_dbg(us, "Option MS: %s\n",
+				     "Failed to switch to modem mode");
 		return -EIO;
 	} else if (option_zero_cd == ZCD_ALLOW_MS) {
 		/* Allow Mass Storage mode (keep CD-Rom) */
-		US_DEBUGP("Option MS: %s", "Allowing Mass Storage Mode if device"
-		          " requests it\n");
+		usb_stor_dbg(us, "Option MS: %s\n",
+			     "Allowing Mass Storage Mode if device requests it");
 	}
 
 	return 0;
diff --git a/drivers/usb/storage/realtek_cr.c b/drivers/usb/storage/realtek_cr.c
index 6c3586a..4797228 100644
--- a/drivers/usb/storage/realtek_cr.c
+++ b/drivers/usb/storage/realtek_cr.c
@@ -254,8 +254,8 @@ static int rts51x_bulk_transport(struct us_data *us, u8 lun,
 
 	/* check bulk status */
 	if (bcs->Signature != cpu_to_le32(US_BULK_CS_SIGN)) {
-		US_DEBUGP("Signature mismatch: got %08X, expecting %08X\n",
-			  le32_to_cpu(bcs->Signature), US_BULK_CS_SIGN);
+		usb_stor_dbg(us, "Signature mismatch: got %08X, expecting %08X\n",
+			     le32_to_cpu(bcs->Signature), US_BULK_CS_SIGN);
 		return USB_STOR_TRANSPORT_ERROR;
 	}
 
@@ -351,8 +351,8 @@ static int rts51x_get_max_lun(struct us_data *us)
 				      USB_RECIP_INTERFACE,
 				      0, us->ifnum, us->iobuf, 1, 10 * HZ);
 
-	US_DEBUGP("GetMaxLUN command result is %d, data is %d\n",
-		  result, us->iobuf[0]);
+	usb_stor_dbg(us, "GetMaxLUN command result is %d, data is %d\n",
+		     result, us->iobuf[0]);
 
 	/* if we have a successful request, return the result */
 	if (result > 0)
@@ -371,7 +371,7 @@ static int rts51x_read_mem(struct us_data *us, u16 addr, u8 *data, u16 len)
 	if (buf == NULL)
 		return USB_STOR_TRANSPORT_ERROR;
 
-	US_DEBUGP("%s, addr = 0x%x, len = %d\n", __func__, addr, len);
+	usb_stor_dbg(us, "addr = 0x%x, len = %d\n", addr, len);
 
 	cmnd[0] = 0xF0;
 	cmnd[1] = 0x0D;
@@ -402,7 +402,7 @@ static int rts51x_write_mem(struct us_data *us, u16 addr, u8 *data, u16 len)
 	if (buf == NULL)
 		return USB_STOR_TRANSPORT_ERROR;
 
-	US_DEBUGP("%s, addr = 0x%x, len = %d\n", __func__, addr, len);
+	usb_stor_dbg(us, "addr = 0x%x, len = %d\n", addr, len);
 
 	cmnd[0] = 0xF0;
 	cmnd[1] = 0x0E;
@@ -431,7 +431,7 @@ static int rts51x_read_status(struct us_data *us,
 	if (buf == NULL)
 		return USB_STOR_TRANSPORT_ERROR;
 
-	US_DEBUGP("%s, lun = %d\n", __func__, lun);
+	usb_stor_dbg(us, "lun = %d\n", lun);
 
 	cmnd[0] = 0xF0;
 	cmnd[1] = 0x09;
@@ -458,7 +458,7 @@ static int rts51x_check_status(struct us_data *us, u8 lun)
 	if (retval != STATUS_SUCCESS)
 		return -EIO;
 
-	US_DEBUGP("chip->status_len = %d\n", chip->status_len);
+	usb_stor_dbg(us, "chip->status_len = %d\n", chip->status_len);
 
 	chip->status[lun].vid = ((u16) buf[0] << 8) | buf[1];
 	chip->status[lun].pid = ((u16) buf[2] << 8) | buf[3];
@@ -509,7 +509,7 @@ static int __do_config_autodelink(struct us_data *us, u8 *data, u16 len)
 	u8 cmnd[12] = {0};
 	u8 *buf;
 
-	US_DEBUGP("%s, addr = 0xfe47, len = %d\n", __FUNCTION__, len);
+	usb_stor_dbg(us, "addr = 0xfe47, len = %d\n", len);
 
 	buf = kmemdup(data, len, GFP_NOIO);
 	if (!buf)
@@ -549,7 +549,7 @@ static int do_config_autodelink(struct us_data *us, int enable, int force)
 		value &= ~0x03;
 	}
 
-	US_DEBUGP("In %s,set 0xfe47 to 0x%x\n", __func__, value);
+	usb_stor_dbg(us, "set 0xfe47 to 0x%x\n", value);
 
 	/* retval = rts51x_write_mem(us, 0xFE47, &value, 1); */
 	retval = __do_config_autodelink(us, &value, 1);
@@ -565,8 +565,6 @@ static int config_autodelink_after_power_on(struct us_data *us)
 	int retval;
 	u8 value;
 
-	US_DEBUGP("%s: <---\n", __func__);
-
 	if (!CHK_AUTO_DELINK(chip))
 		return 0;
 
@@ -624,8 +622,6 @@ static int config_autodelink_after_power_on(struct us_data *us)
 		}
 	}
 
-	US_DEBUGP("%s: --->\n", __func__);
-
 	return 0;
 }
 
@@ -635,8 +631,6 @@ static int config_autodelink_before_power_down(struct us_data *us)
 	int retval;
 	u8 value;
 
-	US_DEBUGP("%s: <---\n", __func__);
-
 	if (!CHK_AUTO_DELINK(chip))
 		return 0;
 
@@ -698,8 +692,6 @@ static int config_autodelink_before_power_down(struct us_data *us)
 		}
 	}
 
-	US_DEBUGP("%s: --->\n", __func__);
-
 	return 0;
 }
 
@@ -709,23 +701,19 @@ static void fw5895_init(struct us_data *us)
 	int retval;
 	u8 val;
 
-	US_DEBUGP("%s: <---\n", __func__);
-
 	if ((PRODUCT_ID(chip) != 0x0158) || (FW_VERSION(chip) != 0x5895)) {
-		US_DEBUGP("Not the specified device, return immediately!\n");
+		usb_stor_dbg(us, "Not the specified device, return immediately!\n");
 	} else {
 		retval = rts51x_read_mem(us, 0xFD6F, &val, 1);
 		if (retval == STATUS_SUCCESS && (val & 0x1F) == 0) {
 			val = 0x1F;
 			retval = rts51x_write_mem(us, 0xFD70, &val, 1);
 			if (retval != STATUS_SUCCESS)
-				US_DEBUGP("Write memory fail\n");
+				usb_stor_dbg(us, "Write memory fail\n");
 		} else {
-			US_DEBUGP("Read memory fail, OR (val & 0x1F) != 0\n");
+			usb_stor_dbg(us, "Read memory fail, OR (val & 0x1F) != 0\n");
 		}
 	}
-
-	US_DEBUGP("%s: --->\n", __func__);
 }
 
 #ifdef CONFIG_REALTEK_AUTOPM
@@ -735,10 +723,8 @@ static void fw5895_set_mmc_wp(struct us_data *us)
 	int retval;
 	u8 buf[13];
 
-	US_DEBUGP("%s: <---\n", __func__);
-
 	if ((PRODUCT_ID(chip) != 0x0158) || (FW_VERSION(chip) != 0x5895)) {
-		US_DEBUGP("Not the specified device, return immediately!\n");
+		usb_stor_dbg(us, "Not the specified device, return immediately!\n");
 	} else {
 		retval = rts51x_read_mem(us, 0xFD6F, buf, 1);
 		if (retval == STATUS_SUCCESS && (buf[0] & 0x24) == 0x24) {
@@ -748,26 +734,24 @@ static void fw5895_set_mmc_wp(struct us_data *us)
 				buf[0] |= 0x04;
 				retval = rts51x_write_mem(us, 0xFD70, buf, 1);
 				if (retval != STATUS_SUCCESS)
-					US_DEBUGP("Write memory fail\n");
+					usb_stor_dbg(us, "Write memory fail\n");
 			} else {
-				US_DEBUGP("Read memory fail\n");
+				usb_stor_dbg(us, "Read memory fail\n");
 			}
 		} else {
-			US_DEBUGP("Read memory fail, OR (buf[0]&0x24)!=0x24\n");
+			usb_stor_dbg(us, "Read memory fail, OR (buf[0]&0x24)!=0x24\n");
 		}
 	}
-
-	US_DEBUGP("%s: --->\n", __func__);
 }
 
 static void rts51x_modi_suspend_timer(struct rts51x_chip *chip)
 {
-	US_DEBUGP("%s: <---, state:%d\n", __func__, rts51x_get_stat(chip));
+	struct us_data *us = chip->us;
+
+	usb_stor_dbg(us, "state:%d\n", rts51x_get_stat(chip));
 
 	chip->timer_expires = jiffies + msecs_to_jiffies(1000*ss_delay);
 	mod_timer(&chip->rts51x_suspend_timer, chip->timer_expires);
-
-	US_DEBUGP("%s: --->\n", __func__);
 }
 
 static void rts51x_suspend_timer_fn(unsigned long data)
@@ -775,8 +759,6 @@ static void rts51x_suspend_timer_fn(unsigned long data)
 	struct rts51x_chip *chip = (struct rts51x_chip *)data;
 	struct us_data *us = chip->us;
 
-	US_DEBUGP("%s: <---\n", __func__);
-
 	switch (rts51x_get_stat(chip)) {
 	case RTS51X_STAT_INIT:
 	case RTS51X_STAT_RUN:
@@ -784,32 +766,25 @@ static void rts51x_suspend_timer_fn(unsigned long data)
 		break;
 	case RTS51X_STAT_IDLE:
 	case RTS51X_STAT_SS:
-		US_DEBUGP("%s: RTS51X_STAT_SS, intf->pm_usage_cnt:%d,"
-			"power.usage:%d\n", __func__,
-			atomic_read(&us->pusb_intf->pm_usage_cnt),
-			atomic_read(&us->pusb_intf->dev.power.usage_count));
+		usb_stor_dbg(us, "RTS51X_STAT_SS, intf->pm_usage_cnt:%d, power.usage:%d\n",
+			     atomic_read(&us->pusb_intf->pm_usage_cnt),
+			     atomic_read(&us->pusb_intf->dev.power.usage_count));
 
 		if (atomic_read(&us->pusb_intf->pm_usage_cnt) > 0) {
-			US_DEBUGP("%s: Ready to enter SS state.\n",
-				  __func__);
+			usb_stor_dbg(us, "Ready to enter SS state\n");
 			rts51x_set_stat(chip, RTS51X_STAT_SS);
 			/* ignore mass storage interface's children */
 			pm_suspend_ignore_children(&us->pusb_intf->dev, true);
 			usb_autopm_put_interface_async(us->pusb_intf);
-			US_DEBUGP("%s: RTS51X_STAT_SS 01,"
-				"intf->pm_usage_cnt:%d, power.usage:%d\n",
-				__func__,
-				atomic_read(&us->pusb_intf->pm_usage_cnt),
-				atomic_read(
-					&us->pusb_intf->dev.power.usage_count));
+			usb_stor_dbg(us, "RTS51X_STAT_SS 01, intf->pm_usage_cnt:%d, power.usage:%d\n",
+				     atomic_read(&us->pusb_intf->pm_usage_cnt),
+				     atomic_read(&us->pusb_intf->dev.power.usage_count));
 		}
 		break;
 	default:
-		US_DEBUGP("%s: Unknonwn state !!!\n", __func__);
+		usb_stor_dbg(us, "Unknown state !!!\n");
 		break;
 	}
-
-	US_DEBUGP("%s: --->\n", __func__);
 }
 
 static inline int working_scsi(struct scsi_cmnd *srb)
@@ -834,24 +809,21 @@ static void rts51x_invoke_transport(struct scsi_cmnd *srb, struct us_data *us)
 	};
 	int ret;
 
-	US_DEBUGP("%s: <---\n", __func__);
-
 	if (working_scsi(srb)) {
-		US_DEBUGP("%s: working scsi, intf->pm_usage_cnt:%d,"
-			"power.usage:%d\n", __func__,
-			atomic_read(&us->pusb_intf->pm_usage_cnt),
-			atomic_read(&us->pusb_intf->dev.power.usage_count));
+		usb_stor_dbg(us, "working scsi, intf->pm_usage_cnt:%d, power.usage:%d\n",
+			     atomic_read(&us->pusb_intf->pm_usage_cnt),
+			     atomic_read(&us->pusb_intf->dev.power.usage_count));
 
 		if (atomic_read(&us->pusb_intf->pm_usage_cnt) <= 0) {
 			ret = usb_autopm_get_interface(us->pusb_intf);
-			US_DEBUGP("%s: working scsi, ret=%d\n", __func__, ret);
+			usb_stor_dbg(us, "working scsi, ret=%d\n", ret);
 		}
 		if (rts51x_get_stat(chip) != RTS51X_STAT_RUN)
 			rts51x_set_stat(chip, RTS51X_STAT_RUN);
 		chip->proto_handler_backup(srb, us);
 	} else {
 		if (rts51x_get_stat(chip) == RTS51X_STAT_SS) {
-			US_DEBUGP("%s: NOT working scsi\n", __func__);
+			usb_stor_dbg(us, "NOT working scsi\n");
 			if ((srb->cmnd[0] == TEST_UNIT_READY) &&
 			    (chip->pwr_state == US_SUSPEND)) {
 				if (TST_LUN_READY(chip, srb->device->lun)) {
@@ -862,8 +834,7 @@ static void rts51x_invoke_transport(struct scsi_cmnd *srb, struct us_data *us)
 					       media_not_present,
 					       US_SENSE_SIZE);
 				}
-				US_DEBUGP("%s: TEST_UNIT_READY--->\n",
-					  __func__);
+				usb_stor_dbg(us, "TEST_UNIT_READY\n");
 				goto out;
 			}
 			if (srb->cmnd[0] == ALLOW_MEDIUM_REMOVAL) {
@@ -876,12 +847,11 @@ static void rts51x_invoke_transport(struct scsi_cmnd *srb, struct us_data *us)
 				} else {
 					srb->result = SAM_STAT_GOOD;
 				}
-				US_DEBUGP("%s: ALLOW_MEDIUM_REMOVAL--->\n",
-					  __func__);
+				usb_stor_dbg(us, "ALLOW_MEDIUM_REMOVAL\n");
 				goto out;
 			}
 		} else {
-			US_DEBUGP("%s: NOT working scsi, not SS\n", __func__);
+			usb_stor_dbg(us, "NOT working scsi, not SS\n");
 			chip->proto_handler_backup(srb, us);
 			/* Check whether card is plugged in */
 			if (srb->cmnd[0] == TEST_UNIT_READY) {
@@ -901,11 +871,9 @@ static void rts51x_invoke_transport(struct scsi_cmnd *srb, struct us_data *us)
 		}
 	}
 out:
-	US_DEBUGP("%s: state:%d\n", __func__, rts51x_get_stat(chip));
+	usb_stor_dbg(us, "state:%d\n", rts51x_get_stat(chip));
 	if (rts51x_get_stat(chip) == RTS51X_STAT_RUN)
 		rts51x_modi_suspend_timer(chip);
-
-	US_DEBUGP("%s: --->\n", __func__);
 }
 
 static int realtek_cr_autosuspend_setup(struct us_data *us)
@@ -923,7 +891,7 @@ static int realtek_cr_autosuspend_setup(struct us_data *us)
 
 	retval = rts51x_read_status(us, 0, buf, 16, &(chip->status_len));
 	if (retval != STATUS_SUCCESS) {
-		US_DEBUGP("Read status fail\n");
+		usb_stor_dbg(us, "Read status fail\n");
 		return -EIO;
 	}
 	status = chip->status;
@@ -966,11 +934,13 @@ static int realtek_cr_autosuspend_setup(struct us_data *us)
 static void realtek_cr_destructor(void *extra)
 {
 	struct rts51x_chip *chip = (struct rts51x_chip *)extra;
-
-	US_DEBUGP("%s: <---\n", __func__);
+	struct us_data *us;
 
 	if (!chip)
 		return;
+
+	us = chip->us;
+
 #ifdef CONFIG_REALTEK_AUTOPM
 	if (ss_en) {
 		del_timer(&chip->rts51x_suspend_timer);
@@ -985,8 +955,6 @@ static int realtek_cr_suspend(struct usb_interface *iface, pm_message_t message)
 {
 	struct us_data *us = usb_get_intfdata(iface);
 
-	US_DEBUGP("%s: <---\n", __func__);
-
 	/* wait until no command is running */
 	mutex_lock(&us->dev_mutex);
 
@@ -994,8 +962,6 @@ static int realtek_cr_suspend(struct usb_interface *iface, pm_message_t message)
 
 	mutex_unlock(&us->dev_mutex);
 
-	US_DEBUGP("%s: --->\n", __func__);
-
 	return 0;
 }
 
@@ -1003,13 +969,9 @@ static int realtek_cr_resume(struct usb_interface *iface)
 {
 	struct us_data *us = usb_get_intfdata(iface);
 
-	US_DEBUGP("%s: <---\n", __func__);
-
 	fw5895_init(us);
 	config_autodelink_after_power_on(us);
 
-	US_DEBUGP("%s: --->\n", __func__);
-
 	return 0;
 }
 #else
@@ -1030,7 +992,7 @@ static int init_realtek_cr(struct us_data *us)
 	us->extra_destructor = realtek_cr_destructor;
 	us->max_lun = chip->max_lun = rts51x_get_max_lun(us);
 
-	US_DEBUGP("chip->max_lun = %d\n", chip->max_lun);
+	usb_stor_dbg(us, "chip->max_lun = %d\n", chip->max_lun);
 
 	size = (chip->max_lun + 1) * sizeof(struct rts51x_status);
 	chip->status = kzalloc(size, GFP_KERNEL);
@@ -1057,7 +1019,7 @@ static int init_realtek_cr(struct us_data *us)
 	}
 #endif
 
-	US_DEBUGP("chip->flag = 0x%x\n", chip->flag);
+	usb_stor_dbg(us, "chip->flag = 0x%x\n", chip->flag);
 
 	(void)config_autodelink_after_power_on(us);
 
@@ -1079,7 +1041,7 @@ static int realtek_cr_probe(struct usb_interface *intf,
 	struct us_data *us;
 	int result;
 
-	US_DEBUGP("Probe Realtek Card Reader!\n");
+	dev_dbg(&intf->dev, "Probe Realtek Card Reader!\n");
 
 	result = usb_stor_probe1(&us, intf, id,
 				 (id - realtek_cr_ids) +
diff --git a/drivers/usb/storage/scsiglue.c b/drivers/usb/storage/scsiglue.c
index 92f35ab..4faa982 100644
--- a/drivers/usb/storage/scsiglue.c
+++ b/drivers/usb/storage/scsiglue.c
@@ -313,8 +313,6 @@ static int queuecommand_lck(struct scsi_cmnd *srb,
 {
 	struct us_data *us = host_to_us(srb->device->host);
 
-	US_DEBUGP("%s called\n", __func__);
-
 	/* check for state-transition errors */
 	if (us->srb != NULL) {
 		printk(KERN_ERR USB_STORAGE "Error in %s: us->srb = %p\n",
@@ -324,7 +322,7 @@ static int queuecommand_lck(struct scsi_cmnd *srb,
 
 	/* fail the command if we are disconnecting */
 	if (test_bit(US_FLIDX_DISCONNECTING, &us->dflags)) {
-		US_DEBUGP("Fail command during disconnect\n");
+		usb_stor_dbg(us, "Fail command during disconnect\n");
 		srb->result = DID_NO_CONNECT << 16;
 		done(srb);
 		return 0;
@@ -349,7 +347,7 @@ static int command_abort(struct scsi_cmnd *srb)
 {
 	struct us_data *us = host_to_us(srb->device->host);
 
-	US_DEBUGP("%s called\n", __func__);
+	usb_stor_dbg(us, "%s called\n", __func__);
 
 	/* us->srb together with the TIMED_OUT, RESETTING, and ABORTING
 	 * bits are protected by the host lock. */
@@ -358,7 +356,7 @@ static int command_abort(struct scsi_cmnd *srb)
 	/* Is this command still active? */
 	if (us->srb != srb) {
 		scsi_unlock(us_to_host(us));
-		US_DEBUGP ("-- nothing to abort\n");
+		usb_stor_dbg(us, "-- nothing to abort\n");
 		return FAILED;
 	}
 
@@ -386,7 +384,7 @@ static int device_reset(struct scsi_cmnd *srb)
 	struct us_data *us = host_to_us(srb->device->host);
 	int result;
 
-	US_DEBUGP("%s called\n", __func__);
+	usb_stor_dbg(us, "%s called\n", __func__);
 
 	/* lock the device pointers and do the reset */
 	mutex_lock(&(us->dev_mutex));
@@ -402,7 +400,8 @@ static int bus_reset(struct scsi_cmnd *srb)
 	struct us_data *us = host_to_us(srb->device->host);
 	int result;
 
-	US_DEBUGP("%s called\n", __func__);
+	usb_stor_dbg(us, "%s called\n", __func__);
+
 	result = usb_stor_port_reset(us);
 	return result < 0 ? FAILED : SUCCESS;
 }
diff --git a/drivers/usb/storage/sddr09.c b/drivers/usb/storage/sddr09.c
index 7bd54e0..732027f 100644
--- a/drivers/usb/storage/sddr09.c
+++ b/drivers/usb/storage/sddr09.c
@@ -105,8 +105,6 @@ static struct us_unusual_dev sddr09_unusual_dev_list[] = {
 #define LSB_of(s) ((s)&0xFF)
 #define MSB_of(s) ((s)>>8)
 
-/* #define US_DEBUGP printk */
-
 /*
  * First some stuff that does not belong here:
  * data on SmartMedia and other cards, completely
@@ -347,7 +345,7 @@ sddr09_test_unit_ready(struct us_data *us) {
 
 	result = sddr09_send_scsi_command(us, command, 6);
 
-	US_DEBUGP("sddr09_test_unit_ready returns %d\n", result);
+	usb_stor_dbg(us, "sddr09_test_unit_ready returns %d\n", result);
 
 	return result;
 }
@@ -423,8 +421,8 @@ sddr09_readX(struct us_data *us, int x, unsigned long fromaddress,
 	result = sddr09_send_scsi_command(us, command, 12);
 
 	if (result) {
-		US_DEBUGP("Result for send_control in sddr09_read2%d %d\n",
-			  x, result);
+		usb_stor_dbg(us, "Result for send_control in sddr09_read2%d %d\n",
+			     x, result);
 		return result;
 	}
 
@@ -432,8 +430,8 @@ sddr09_readX(struct us_data *us, int x, unsigned long fromaddress,
 				       buf, bulklen, use_sg, NULL);
 
 	if (result != USB_STOR_XFER_GOOD) {
-		US_DEBUGP("Result for bulk_transfer in sddr09_read2%d %d\n",
-			  x, result);
+		usb_stor_dbg(us, "Result for bulk_transfer in sddr09_read2%d %d\n",
+			     x, result);
 		return -EIO;
 	}
 	return 0;
@@ -494,8 +492,7 @@ sddr09_read22(struct us_data *us, unsigned long fromaddress,
 	      int nr_of_pages, int pageshift, unsigned char *buf, int use_sg) {
 
 	int bulklen = (nr_of_pages << pageshift) + (nr_of_pages << CONTROL_SHIFT);
-	US_DEBUGP("sddr09_read22: reading %d pages, %d bytes\n",
-		  nr_of_pages, bulklen);
+	usb_stor_dbg(us, "reading %d pages, %d bytes\n", nr_of_pages, bulklen);
 	return sddr09_readX(us, 2, fromaddress, nr_of_pages, bulklen,
 			    buf, use_sg);
 }
@@ -538,7 +535,7 @@ sddr09_erase(struct us_data *us, unsigned long Eaddress) {
 	unsigned char *command = us->iobuf;
 	int result;
 
-	US_DEBUGP("sddr09_erase: erase address %lu\n", Eaddress);
+	usb_stor_dbg(us, "erase address %lu\n", Eaddress);
 
 	memset(command, 0, 12);
 	command[0] = 0xEA;
@@ -551,8 +548,8 @@ sddr09_erase(struct us_data *us, unsigned long Eaddress) {
 	result = sddr09_send_scsi_command(us, command, 12);
 
 	if (result)
-		US_DEBUGP("Result for send_control in sddr09_erase %d\n",
-			  result);
+		usb_stor_dbg(us, "Result for send_control in sddr09_erase %d\n",
+			     result);
 
 	return result;
 }
@@ -609,8 +606,8 @@ sddr09_writeX(struct us_data *us,
 	result = sddr09_send_scsi_command(us, command, 12);
 
 	if (result) {
-		US_DEBUGP("Result for send_control in sddr09_writeX %d\n",
-			  result);
+		usb_stor_dbg(us, "Result for send_control in sddr09_writeX %d\n",
+			     result);
 		return result;
 	}
 
@@ -618,8 +615,8 @@ sddr09_writeX(struct us_data *us,
 				       buf, bulklen, use_sg, NULL);
 
 	if (result != USB_STOR_XFER_GOOD) {
-		US_DEBUGP("Result for bulk_transfer in sddr09_writeX %d\n",
-			  result);
+		usb_stor_dbg(us, "Result for bulk_transfer in sddr09_writeX %d\n",
+			     result);
 		return -EIO;
 	}
 	return 0;
@@ -687,8 +684,8 @@ sddr09_read_sg_test_only(struct us_data *us) {
 	result = sddr09_send_scsi_command(us, command, 4*nsg+3);
 
 	if (result) {
-		US_DEBUGP("Result for send_control in sddr09_read_sg %d\n",
-			  result);
+		usb_stor_dbg(us, "Result for send_control in sddr09_read_sg %d\n",
+			     result);
 		return result;
 	}
 
@@ -700,8 +697,8 @@ sddr09_read_sg_test_only(struct us_data *us) {
 				       buf, bulklen, NULL);
 	kfree(buf);
 	if (result != USB_STOR_XFER_GOOD) {
-		US_DEBUGP("Result for bulk_transfer in sddr09_read_sg %d\n",
-			  result);
+		usb_stor_dbg(us, "Result for bulk_transfer in sddr09_read_sg %d\n",
+			     result);
 		return -EIO;
 	}
 
@@ -727,7 +724,7 @@ sddr09_read_status(struct us_data *us, unsigned char *status) {
 	unsigned char *data = us->iobuf;
 	int result;
 
-	US_DEBUGP("Reading status...\n");
+	usb_stor_dbg(us, "Reading status...\n");
 
 	memset(command, 0, 12);
 	command[0] = 0xEC;
@@ -789,8 +786,8 @@ sddr09_read_data(struct us_data *us,
 
 		/* Not overflowing capacity? */
 		if (lba >= maxlba) {
-			US_DEBUGP("Error: Requested lba %u exceeds "
-				  "maximum %u\n", lba, maxlba);
+			usb_stor_dbg(us, "Error: Requested lba %u exceeds maximum %u\n",
+				     lba, maxlba);
 			result = -EIO;
 			break;
 		}
@@ -800,8 +797,8 @@ sddr09_read_data(struct us_data *us,
 
 		if (pba == UNDEF) {	/* this lba was never written */
 
-			US_DEBUGP("Read %d zero pages (LBA %d) page %d\n",
-				  pages, lba, page);
+			usb_stor_dbg(us, "Read %d zero pages (LBA %d) page %d\n",
+				     pages, lba, page);
 
 			/* This is not really an error. It just means
 			   that the block has never been written.
@@ -811,9 +808,8 @@ sddr09_read_data(struct us_data *us,
 			memset(buffer, 0, len);
 
 		} else {
-			US_DEBUGP("Read %d pages, from PBA %d"
-				  " (LBA %d) page %d\n",
-				  pages, pba, lba, page);
+			usb_stor_dbg(us, "Read %d pages, from PBA %d (LBA %d) page %d\n",
+				     pages, pba, lba, page);
 
 			address = ((pba << info->blockshift) + page) << 
 				info->pageshift;
@@ -916,14 +912,14 @@ sddr09_write_lba(struct us_data *us, unsigned int lba,
 		cptr = bptr + info->pagesize;
 		nand_compute_ecc(bptr, ecc);
 		if (!nand_compare_ecc(cptr+13, ecc)) {
-			US_DEBUGP("Warning: bad ecc in page %d- of pba %d\n",
-				  i, pba);
+			usb_stor_dbg(us, "Warning: bad ecc in page %d- of pba %d\n",
+				     i, pba);
 			nand_store_ecc(cptr+13, ecc);
 		}
 		nand_compute_ecc(bptr+(info->pagesize / 2), ecc);
 		if (!nand_compare_ecc(cptr+8, ecc)) {
-			US_DEBUGP("Warning: bad ecc in page %d+ of pba %d\n",
-				  i, pba);
+			usb_stor_dbg(us, "Warning: bad ecc in page %d+ of pba %d\n",
+				     i, pba);
 			nand_store_ecc(cptr+8, ecc);
 		}
 		cptr[6] = cptr[11] = MSB_of(lbap);
@@ -943,22 +939,21 @@ sddr09_write_lba(struct us_data *us, unsigned int lba,
 		nand_store_ecc(cptr+8, ecc);
 	}
 
-	US_DEBUGP("Rewrite PBA %d (LBA %d)\n", pba, lba);
+	usb_stor_dbg(us, "Rewrite PBA %d (LBA %d)\n", pba, lba);
 
 	result = sddr09_write_inplace(us, address>>1, info->blocksize,
 				      info->pageshift, blockbuffer, 0);
 
-	US_DEBUGP("sddr09_write_inplace returns %d\n", result);
+	usb_stor_dbg(us, "sddr09_write_inplace returns %d\n", result);
 
 #if 0
 	{
 		unsigned char status = 0;
 		int result2 = sddr09_read_status(us, &status);
 		if (result2)
-			US_DEBUGP("sddr09_write_inplace: cannot read status\n");
+			usb_stor_dbg(us, "cannot read status\n");
 		else if (status != 0xc0)
-			US_DEBUGP("sddr09_write_inplace: status after write: 0x%x\n",
-				  status);
+			usb_stor_dbg(us, "status after write: 0x%x\n", status);
 	}
 #endif
 
@@ -1031,8 +1026,8 @@ sddr09_write_data(struct us_data *us,
 
 		/* Not overflowing capacity? */
 		if (lba >= maxlba) {
-			US_DEBUGP("Error: Requested lba %u exceeds "
-				  "maximum %u\n", lba, maxlba);
+			usb_stor_dbg(us, "Error: Requested lba %u exceeds maximum %u\n",
+				     lba, maxlba);
 			result = -EIO;
 			break;
 		}
@@ -1064,8 +1059,8 @@ sddr09_read_control(struct us_data *us,
 		unsigned char *content,
 		int use_sg) {
 
-	US_DEBUGP("Read control address %lu, blocks %d\n",
-		address, blocks);
+	usb_stor_dbg(us, "Read control address %lu, blocks %d\n",
+		     address, blocks);
 
 	return sddr09_read21(us, address, blocks,
 			     CONTROL_SHIFT, content, use_sg);
@@ -1111,21 +1106,21 @@ sddr09_get_wp(struct us_data *us, struct sddr09_card_info *info) {
 
 	result = sddr09_read_status(us, &status);
 	if (result) {
-		US_DEBUGP("sddr09_get_wp: read_status fails\n");
+		usb_stor_dbg(us, "read_status fails\n");
 		return result;
 	}
-	US_DEBUGP("sddr09_get_wp: status 0x%02X", status);
+	usb_stor_dbg(us, "status 0x%02X", status);
 	if ((status & 0x80) == 0) {
 		info->flags |= SDDR09_WP;	/* write protected */
-		US_DEBUGP(" WP");
+		US_DEBUGPX(" WP");
 	}
 	if (status & 0x40)
-		US_DEBUGP(" Ready");
+		US_DEBUGPX(" Ready");
 	if (status & LUNBITS)
-		US_DEBUGP(" Suspended");
+		US_DEBUGPX(" Suspended");
 	if (status & 0x1)
-		US_DEBUGP(" Error");
-	US_DEBUGP("\n");
+		US_DEBUGPX(" Error");
+	US_DEBUGPX("\n");
 	return 0;
 }
 
@@ -1154,12 +1149,12 @@ sddr09_get_cardinfo(struct us_data *us, unsigned char flags) {
 	char blurbtxt[256];
 	int result;
 
-	US_DEBUGP("Reading capacity...\n");
+	usb_stor_dbg(us, "Reading capacity...\n");
 
 	result = sddr09_read_deviceID(us, deviceID);
 
 	if (result) {
-		US_DEBUGP("Result of read_deviceID is %d\n", result);
+		usb_stor_dbg(us, "Result of read_deviceID is %d\n", result);
 		printk(KERN_WARNING "sddr09: could not read card info\n");
 		return NULL;
 	}
@@ -1392,7 +1387,7 @@ sddr09_read_map(struct us_data *us) {
 		lbact += ct;
 	}
 	info->lbact = lbact;
-	US_DEBUGP("Found %d LBA's\n", lbact);
+	usb_stor_dbg(us, "Found %d LBA's\n", lbact);
 	result = 0;
 
  done:
@@ -1423,18 +1418,18 @@ sddr09_common_init(struct us_data *us) {
 
 	/* set the configuration -- STALL is an acceptable response here */
 	if (us->pusb_dev->actconfig->desc.bConfigurationValue != 1) {
-		US_DEBUGP("active config #%d != 1 ??\n", us->pusb_dev
-				->actconfig->desc.bConfigurationValue);
+		usb_stor_dbg(us, "active config #%d != 1 ??\n",
+			     us->pusb_dev->actconfig->desc.bConfigurationValue);
 		return -EINVAL;
 	}
 
 	result = usb_reset_configuration(us->pusb_dev);
-	US_DEBUGP("Result of usb_reset_configuration is %d\n", result);
+	usb_stor_dbg(us, "Result of usb_reset_configuration is %d\n", result);
 	if (result == -EPIPE) {
-		US_DEBUGP("-- stall on control interface\n");
+		usb_stor_dbg(us, "-- stall on control interface\n");
 	} else if (result != 0) {
 		/* it's not a stall, but another error -- time to bail */
-		US_DEBUGP("-- Unknown error.  Rejecting device\n");
+		usb_stor_dbg(us, "-- Unknown error.  Rejecting device\n");
 		return -EINVAL;
 	}
 
@@ -1464,20 +1459,20 @@ usb_stor_sddr09_dpcm_init(struct us_data *us) {
 
 	result = sddr09_send_command(us, 0x01, USB_DIR_IN, data, 2);
 	if (result) {
-		US_DEBUGP("sddr09_init: send_command fails\n");
+		usb_stor_dbg(us, "send_command fails\n");
 		return result;
 	}
 
-	US_DEBUGP("SDDR09init: %02X %02X\n", data[0], data[1]);
+	usb_stor_dbg(us, "%02X %02X\n", data[0], data[1]);
 	// get 07 02
 
 	result = sddr09_send_command(us, 0x08, USB_DIR_IN, data, 2);
 	if (result) {
-		US_DEBUGP("sddr09_init: 2nd send_command fails\n");
+		usb_stor_dbg(us, "2nd send_command fails\n");
 		return result;
 	}
 
-	US_DEBUGP("SDDR09init: %02X %02X\n", data[0], data[1]);
+	usb_stor_dbg(us, "%02X %02X\n", data[0], data[1]);
 	// get 07 00
 
 	result = sddr09_request_sense(us, data, 18);
@@ -1507,7 +1502,7 @@ static int dpcm_transport(struct scsi_cmnd *srb, struct us_data *us)
 {
 	int ret;
 
-	US_DEBUGP("dpcm_transport: LUN=%d\n", srb->device->lun);
+	usb_stor_dbg(us, "LUN=%d\n", srb->device->lun);
 
 	switch (srb->device->lun) {
 	case 0:
@@ -1533,8 +1528,7 @@ static int dpcm_transport(struct scsi_cmnd *srb, struct us_data *us)
 		break;
 
 	default:
-		US_DEBUGP("dpcm_transport: Invalid LUN %d\n",
-				srb->device->lun);
+		usb_stor_dbg(us, "Invalid LUN %d\n", srb->device->lun);
 		ret = USB_STOR_TRANSPORT_ERROR;
 		break;
 	}
@@ -1640,8 +1634,8 @@ static int sddr09_transport(struct scsi_cmnd *srb, struct us_data *us)
 		   or for all pages. */
 		/* %% We should check DBD %% */
 		if (modepage == 0x01 || modepage == 0x3F) {
-			US_DEBUGP("SDDR09: Dummy up request for "
-				  "mode page 0x%x\n", modepage);
+			usb_stor_dbg(us, "Dummy up request for mode page 0x%x\n",
+				     modepage);
 
 			memcpy(ptr, mode_page_01, sizeof(mode_page_01));
 			((__be16*)ptr)[0] = cpu_to_be16(sizeof(mode_page_01) - 2);
@@ -1667,8 +1661,8 @@ static int sddr09_transport(struct scsi_cmnd *srb, struct us_data *us)
 		page |= short_pack(srb->cmnd[5], srb->cmnd[4]);
 		pages = short_pack(srb->cmnd[8], srb->cmnd[7]);
 
-		US_DEBUGP("READ_10: read page %d pagect %d\n",
-			  page, pages);
+		usb_stor_dbg(us, "READ_10: read page %d pagect %d\n",
+			     page, pages);
 
 		result = sddr09_read_data(us, page, pages);
 		return (result == 0 ? USB_STOR_TRANSPORT_GOOD :
@@ -1682,8 +1676,8 @@ static int sddr09_transport(struct scsi_cmnd *srb, struct us_data *us)
 		page |= short_pack(srb->cmnd[5], srb->cmnd[4]);
 		pages = short_pack(srb->cmnd[8], srb->cmnd[7]);
 
-		US_DEBUGP("WRITE_10: write page %d pagect %d\n",
-			  page, pages);
+		usb_stor_dbg(us, "WRITE_10: write page %d pagect %d\n",
+			     page, pages);
 
 		result = sddr09_write_data(us, page, pages);
 		return (result == 0 ? USB_STOR_TRANSPORT_GOOD :
@@ -1710,12 +1704,12 @@ static int sddr09_transport(struct scsi_cmnd *srb, struct us_data *us)
 	for (i=0; i<12; i++)
 		sprintf(ptr+strlen(ptr), "%02X ", srb->cmnd[i]);
 
-	US_DEBUGP("SDDR09: Send control for command %s\n", ptr);
+	usb_stor_dbg(us, "Send control for command %s\n", ptr);
 
 	result = sddr09_send_scsi_command(us, srb->cmnd, 12);
 	if (result) {
-		US_DEBUGP("sddr09_transport: sddr09_send_scsi_command "
-			  "returns %d\n", result);
+		usb_stor_dbg(us, "sddr09_send_scsi_command returns %d\n",
+			     result);
 		return USB_STOR_TRANSPORT_ERROR;
 	}
 
@@ -1727,10 +1721,10 @@ static int sddr09_transport(struct scsi_cmnd *srb, struct us_data *us)
 		unsigned int pipe = (srb->sc_data_direction == DMA_TO_DEVICE)
 				? us->send_bulk_pipe : us->recv_bulk_pipe;
 
-		US_DEBUGP("SDDR09: %s %d bytes\n",
-			  (srb->sc_data_direction == DMA_TO_DEVICE) ?
-			  "sending" : "receiving",
-			  scsi_bufflen(srb));
+		usb_stor_dbg(us, "%s %d bytes\n",
+			     (srb->sc_data_direction == DMA_TO_DEVICE) ?
+			     "sending" : "receiving",
+			     scsi_bufflen(srb));
 
 		result = usb_stor_bulk_srb(us, pipe, srb);
 
diff --git a/drivers/usb/storage/sddr55.c b/drivers/usb/storage/sddr55.c
index d278c5a..aacedef 100644
--- a/drivers/usb/storage/sddr55.c
+++ b/drivers/usb/storage/sddr55.c
@@ -145,8 +145,7 @@ static int sddr55_status(struct us_data *us)
 	result = sddr55_bulk_transport(us,
 		DMA_TO_DEVICE, command, 8);
 
-	US_DEBUGP("Result for send_command in status %d\n",
-		result);
+	usb_stor_dbg(us, "Result for send_command in status %d\n", result);
 
 	if (result != USB_STOR_XFER_GOOD) {
 		set_sense_info (4, 0, 0);	/* hardware error */
@@ -236,9 +235,8 @@ static int sddr55_read_data(struct us_data *us,
 				info->blocksize - page);
 		len = pages << info->pageshift;
 
-		US_DEBUGP("Read %02X pages, from PBA %04X"
-			" (LBA %04X) page %02X\n",
-			pages, pba, lba, page);
+		usb_stor_dbg(us, "Read %02X pages, from PBA %04X (LBA %04X) page %02X\n",
+			     pages, pba, lba, page);
 
 		if (pba == NOT_ALLOCATED) {
 			/* no pba for this lba, fill with zeroes */
@@ -261,8 +259,8 @@ static int sddr55_read_data(struct us_data *us,
 			result = sddr55_bulk_transport(us,
 				DMA_TO_DEVICE, command, 8);
 
-			US_DEBUGP("Result for send_command in read_data %d\n",
-				result);
+			usb_stor_dbg(us, "Result for send_command in read_data %d\n",
+				     result);
 
 			if (result != USB_STOR_XFER_GOOD) {
 				result = USB_STOR_TRANSPORT_ERROR;
@@ -368,9 +366,8 @@ static int sddr55_write_data(struct us_data *us,
 		usb_stor_access_xfer_buf(buffer, len, us->srb,
 				&sg, &offset, FROM_XFER_BUF);
 
-		US_DEBUGP("Write %02X pages, to PBA %04X"
-			" (LBA %04X) page %02X\n",
-			pages, pba, lba, page);
+		usb_stor_dbg(us, "Write %02X pages, to PBA %04X (LBA %04X) page %02X\n",
+			     pages, pba, lba, page);
 			
 		command[4] = 0;
 
@@ -384,7 +381,7 @@ static int sddr55_write_data(struct us_data *us,
 			/* set pba to first block in zone lba is in */
 			pba = (lba / 1000) * 1024;
 
-			US_DEBUGP("No PBA for LBA %04X\n",lba);
+			usb_stor_dbg(us, "No PBA for LBA %04X\n", lba);
 
 			if (max_pba > 1024)
 				max_pba = 1024;
@@ -407,14 +404,15 @@ static int sddr55_write_data(struct us_data *us,
 
 			if (pba == -1) {
 				/* oh dear */
-				US_DEBUGP("Couldn't find unallocated block\n");
+				usb_stor_dbg(us, "Couldn't find unallocated block\n");
 
 				set_sense_info (3, 0x31, 0);	/* medium error */
 				result = USB_STOR_TRANSPORT_FAILED;
 				goto leave;
 			}
 
-			US_DEBUGP("Allocating PBA %04X for LBA %04X\n", pba, lba);
+			usb_stor_dbg(us, "Allocating PBA %04X for LBA %04X\n",
+				     pba, lba);
 
 			/* set writing to unallocated block flag */
 			command[4] = 0x40;
@@ -439,8 +437,8 @@ static int sddr55_write_data(struct us_data *us,
 			DMA_TO_DEVICE, command, 8);
 
 		if (result != USB_STOR_XFER_GOOD) {
-			US_DEBUGP("Result for send_command in write_data %d\n",
-			result);
+			usb_stor_dbg(us, "Result for send_command in write_data %d\n",
+				     result);
 
 			/* set_sense_info is superfluous here? */
 			set_sense_info (3, 0x3, 0);/* peripheral write error */
@@ -453,8 +451,8 @@ static int sddr55_write_data(struct us_data *us,
 			DMA_TO_DEVICE, buffer, len);
 
 		if (result != USB_STOR_XFER_GOOD) {
-			US_DEBUGP("Result for send_data in write_data %d\n",
-				  result);
+			usb_stor_dbg(us, "Result for send_data in write_data %d\n",
+				     result);
 
 			/* set_sense_info is superfluous here? */
 			set_sense_info (3, 0x3, 0);/* peripheral write error */
@@ -466,8 +464,8 @@ static int sddr55_write_data(struct us_data *us,
 		result = sddr55_bulk_transport(us, DMA_FROM_DEVICE, status, 6);
 
 		if (result != USB_STOR_XFER_GOOD) {
-			US_DEBUGP("Result for get_status in write_data %d\n",
-				  result);
+			usb_stor_dbg(us, "Result for get_status in write_data %d\n",
+				     result);
 
 			/* set_sense_info is superfluous here? */
 			set_sense_info (3, 0x3, 0);/* peripheral write error */
@@ -487,8 +485,8 @@ static int sddr55_write_data(struct us_data *us,
 			goto leave;
 		}
 
-		US_DEBUGP("Updating maps for LBA %04X: old PBA %04X, new PBA %04X\n",
-			lba, pba, new_pba);
+		usb_stor_dbg(us, "Updating maps for LBA %04X: old PBA %04X, new PBA %04X\n",
+			     lba, pba, new_pba);
 
 		/* update the lba<->pba maps, note new_pba might be the same as pba */
 		info->lba_to_pba[lba] = new_pba;
@@ -531,8 +529,8 @@ static int sddr55_read_deviceID(struct us_data *us,
 	command[7] = 0x84;
 	result = sddr55_bulk_transport(us, DMA_TO_DEVICE, command, 8);
 
-	US_DEBUGP("Result of send_control for device ID is %d\n",
-		result);
+	usb_stor_dbg(us, "Result of send_control for device ID is %d\n",
+		     result);
 
 	if (result != USB_STOR_XFER_GOOD)
 		return USB_STOR_TRANSPORT_ERROR;
@@ -568,20 +566,19 @@ static unsigned long sddr55_get_capacity(struct us_data *us) {
 	int result;
 	struct sddr55_card_info *info = (struct sddr55_card_info *)us->extra;
 
-	US_DEBUGP("Reading capacity...\n");
+	usb_stor_dbg(us, "Reading capacity...\n");
 
 	result = sddr55_read_deviceID(us,
 		&manufacturerID,
 		&deviceID);
 
-	US_DEBUGP("Result of read_deviceID is %d\n",
-		result);
+	usb_stor_dbg(us, "Result of read_deviceID is %d\n", result);
 
 	if (result != USB_STOR_XFER_GOOD)
 		return 0;
 
-	US_DEBUGP("Device ID = %02X\n", deviceID);
-	US_DEBUGP("Manuf  ID = %02X\n", manufacturerID);
+	usb_stor_dbg(us, "Device ID = %02X\n", deviceID);
+	usb_stor_dbg(us, "Manuf  ID = %02X\n", manufacturerID);
 
 	info->pageshift = 9;
 	info->smallpageshift = 0;
@@ -753,7 +750,7 @@ static int sddr55_read_map(struct us_data *us) {
 		}
 
 		if (lba<0x10 || (lba>=0x3E0 && lba<0x3EF))
-			US_DEBUGP("LBA %04X <-> PBA %04X\n", lba, i);
+			usb_stor_dbg(us, "LBA %04X <-> PBA %04X\n", lba, i);
 
 		info->lba_to_pba[lba + zone * 1000] = i;
 	}
@@ -808,7 +805,10 @@ static int sddr55_transport(struct scsi_cmnd *srb, struct us_data *us)
 	info = (struct sddr55_card_info *)(us->extra);
 
 	if (srb->cmnd[0] == REQUEST_SENSE) {
-		US_DEBUGP("SDDR55: request sense %02x/%02x/%02x\n", info->sense_data[2], info->sense_data[12], info->sense_data[13]);
+		usb_stor_dbg(us, "request sense %02x/%02x/%02x\n",
+			     info->sense_data[2],
+			     info->sense_data[12],
+			     info->sense_data[13]);
 
 		memcpy (ptr, info->sense_data, sizeof info->sense_data);
 		ptr[0] = 0x70;
@@ -892,13 +892,11 @@ static int sddr55_transport(struct scsi_cmnd *srb, struct us_data *us)
 		usb_stor_set_xfer_buf(ptr, sizeof(mode_page_01), srb);
 
 		if ( (srb->cmnd[2] & 0x3F) == 0x01 ) {
-			US_DEBUGP(
-			  "SDDR55: Dummy up request for mode page 1\n");
+			usb_stor_dbg(us, "Dummy up request for mode page 1\n");
 			return USB_STOR_TRANSPORT_GOOD;
 
 		} else if ( (srb->cmnd[2] & 0x3F) == 0x3F ) {
-			US_DEBUGP(
-			  "SDDR55: Dummy up request for all mode pages\n");
+			usb_stor_dbg(us, "Dummy up request for all mode pages\n");
 			return USB_STOR_TRANSPORT_GOOD;
 		}
 
@@ -908,10 +906,8 @@ static int sddr55_transport(struct scsi_cmnd *srb, struct us_data *us)
 
 	if (srb->cmnd[0] == ALLOW_MEDIUM_REMOVAL) {
 
-		US_DEBUGP(
-		  "SDDR55: %s medium removal. Not that I can do"
-		  " anything about it...\n",
-		  (srb->cmnd[4]&0x03) ? "Prevent" : "Allow");
+		usb_stor_dbg(us, "%s medium removal. Not that I can do anything about it...\n",
+			     (srb->cmnd[4]&0x03) ? "Prevent" : "Allow");
 
 		return USB_STOR_TRANSPORT_GOOD;
 
@@ -935,8 +931,8 @@ static int sddr55_transport(struct scsi_cmnd *srb, struct us_data *us)
 
 		if (lba >= info->max_log_blks) {
 
-			US_DEBUGP("Error: Requested LBA %04X exceeds maximum "
-			  "block %04X\n", lba, info->max_log_blks-1);
+			usb_stor_dbg(us, "Error: Requested LBA %04X exceeds maximum block %04X\n",
+				     lba, info->max_log_blks - 1);
 
 			set_sense_info (5, 0x24, 0);	/* invalid field in command */
 
@@ -946,15 +942,13 @@ static int sddr55_transport(struct scsi_cmnd *srb, struct us_data *us)
 		pba = info->lba_to_pba[lba];
 
 		if (srb->cmnd[0] == WRITE_10) {
-			US_DEBUGP("WRITE_10: write block %04X (LBA %04X) page %01X"
-				" pages %d\n",
-				pba, lba, page, pages);
+			usb_stor_dbg(us, "WRITE_10: write block %04X (LBA %04X) page %01X pages %d\n",
+				     pba, lba, page, pages);
 
 			return sddr55_write_data(us, lba, page, pages);
 		} else {
-			US_DEBUGP("READ_10: read block %04X (LBA %04X) page %01X"
-				" pages %d\n",
-				pba, lba, page, pages);
+			usb_stor_dbg(us, "READ_10: read block %04X (LBA %04X) page %01X pages %d\n",
+				     pba, lba, page, pages);
 
 			return sddr55_read_data(us, lba, page, pages);
 		}
diff --git a/drivers/usb/storage/shuttle_usbat.c b/drivers/usb/storage/shuttle_usbat.c
index daf2fc5..4ef2a80 100644
--- a/drivers/usb/storage/shuttle_usbat.c
+++ b/drivers/usb/storage/shuttle_usbat.c
@@ -271,7 +271,7 @@ static int usbat_bulk_read(struct us_data *us,
 	if (len == 0)
 		return USB_STOR_XFER_GOOD;
 
-	US_DEBUGP("usbat_bulk_read: len = %d\n", len);
+	usb_stor_dbg(us, "len = %d\n", len);
 	return usb_stor_bulk_transfer_sg(us, us->recv_bulk_pipe, buf, len, use_sg, NULL);
 }
 
@@ -286,7 +286,7 @@ static int usbat_bulk_write(struct us_data *us,
 	if (len == 0)
 		return USB_STOR_XFER_GOOD;
 
-	US_DEBUGP("usbat_bulk_write:  len = %d\n", len);
+	usb_stor_dbg(us, "len = %d\n", len);
 	return usb_stor_bulk_transfer_sg(us, us->send_bulk_pipe, buf, len, use_sg, NULL);
 }
 
@@ -312,7 +312,7 @@ static int usbat_get_status(struct us_data *us, unsigned char *status)
 	int rc;
 	rc = usbat_read(us, USBAT_ATA, USBAT_ATA_STATUS, status);
 
-	US_DEBUGP("usbat_get_status: 0x%02X\n", (unsigned short) (*status));
+	usb_stor_dbg(us, "0x%02X\n", *status);
 	return rc;
 }
 
@@ -425,7 +425,7 @@ static int usbat_wait_not_busy(struct us_data *us, int minutes)
 			return USB_STOR_TRANSPORT_FAILED;
 
 		if ((*status & 0x80)==0x00) { /* not busy */
-			US_DEBUGP("Waited not busy for %d steps\n", i);
+			usb_stor_dbg(us, "Waited not busy for %d steps\n", i);
 			return USB_STOR_TRANSPORT_GOOD;
 		}
 
@@ -439,8 +439,8 @@ static int usbat_wait_not_busy(struct us_data *us, int minutes)
 			msleep(1000); /* X minutes */
 	}
 
-	US_DEBUGP("Waited not busy for %d minutes, timing out.\n",
-		minutes);
+	usb_stor_dbg(us, "Waited not busy for %d minutes, timing out\n",
+		     minutes);
 	return USB_STOR_TRANSPORT_FAILED;
 }
 
@@ -657,8 +657,9 @@ static int usbat_hp8200e_rw_block_test(struct us_data *us,
 			if (*status & 0x20) /* device fault */
 				return USB_STOR_TRANSPORT_FAILED;
 
-			US_DEBUGP("Redoing %s\n",
-			  direction==DMA_TO_DEVICE ? "write" : "read");
+			usb_stor_dbg(us, "Redoing %s\n",
+				     direction == DMA_TO_DEVICE
+				     ? "write" : "read");
 
 		} else if (result != USB_STOR_XFER_GOOD)
 			return USB_STOR_TRANSPORT_ERROR;
@@ -667,8 +668,8 @@ static int usbat_hp8200e_rw_block_test(struct us_data *us,
 
 	}
 
-	US_DEBUGP("Bummer! %s bulk data 20 times failed.\n",
-		direction==DMA_TO_DEVICE ? "Writing" : "Reading");
+	usb_stor_dbg(us, "Bummer! %s bulk data 20 times failed\n",
+		     direction == DMA_TO_DEVICE ? "Writing" : "Reading");
 
 	return USB_STOR_TRANSPORT_FAILED;
 }
@@ -827,7 +828,7 @@ static int usbat_read_user_io(struct us_data *us, unsigned char *data_flags)
 		data_flags,
 		USBAT_UIO_READ);
 
-	US_DEBUGP("usbat_read_user_io: UIO register reads %02X\n", (unsigned short) (*data_flags));
+	usb_stor_dbg(us, "UIO register reads %02X\n", *data_flags);
 
 	return result;
 }
@@ -900,10 +901,11 @@ static int usbat_device_enable_cdt(struct us_data *us)
 /*
  * Determine if media is present.
  */
-static int usbat_flash_check_media_present(unsigned char *uio)
+static int usbat_flash_check_media_present(struct us_data *us,
+					   unsigned char *uio)
 {
 	if (*uio & USBAT_UIO_UI0) {
-		US_DEBUGP("usbat_flash_check_media_present: no media detected\n");
+		usb_stor_dbg(us, "no media detected\n");
 		return USBAT_FLASH_MEDIA_NONE;
 	}
 
@@ -913,10 +915,11 @@ static int usbat_flash_check_media_present(unsigned char *uio)
 /*
  * Determine if media has changed since last operation
  */
-static int usbat_flash_check_media_changed(unsigned char *uio)
+static int usbat_flash_check_media_changed(struct us_data *us,
+					   unsigned char *uio)
 {
 	if (*uio & USBAT_UIO_0) {
-		US_DEBUGP("usbat_flash_check_media_changed: media change detected\n");
+		usb_stor_dbg(us, "media change detected\n");
 		return USBAT_FLASH_MEDIA_CHANGED;
 	}
 
@@ -937,7 +940,7 @@ static int usbat_flash_check_media(struct us_data *us,
 		return USB_STOR_TRANSPORT_ERROR;
 
 	/* Check for media existence */
-	rc = usbat_flash_check_media_present(uio);
+	rc = usbat_flash_check_media_present(us, uio);
 	if (rc == USBAT_FLASH_MEDIA_NONE) {
 		info->sense_key = 0x02;
 		info->sense_asc = 0x3A;
@@ -946,7 +949,7 @@ static int usbat_flash_check_media(struct us_data *us,
 	}
 
 	/* Check for media change */
-	rc = usbat_flash_check_media_changed(uio);
+	rc = usbat_flash_check_media_changed(us, uio);
 	if (rc == USBAT_FLASH_MEDIA_CHANGED) {
 
 		/* Reset and re-enable card detect */
@@ -1008,11 +1011,11 @@ static int usbat_identify_device(struct us_data *us,
 	/* Check for error bit, or if the command 'fell through' */
 	if (status == 0xA1 || !(status & 0x01)) {
 		/* Device is HP 8200 */
-		US_DEBUGP("usbat_identify_device: Detected HP8200 CDRW\n");
+		usb_stor_dbg(us, "Detected HP8200 CDRW\n");
 		info->devicetype = USBAT_DEV_HP8200;
 	} else {
 		/* Device is a CompactFlash reader/writer */
-		US_DEBUGP("usbat_identify_device: Detected Flash reader/writer\n");
+		usb_stor_dbg(us, "Detected Flash reader/writer\n");
 		info->devicetype = USBAT_DEV_FLASH;
 	}
 
@@ -1075,7 +1078,7 @@ static int usbat_flash_get_sector_count(struct us_data *us,
 	/* ATA command : IDENTIFY DEVICE */
 	rc = usbat_multiple_write(us, registers, command, 3);
 	if (rc != USB_STOR_XFER_GOOD) {
-		US_DEBUGP("usbat_flash_get_sector_count: Gah! identify_device failed\n");
+		usb_stor_dbg(us, "Gah! identify_device failed\n");
 		rc = USB_STOR_TRANSPORT_ERROR;
 		goto leave;
 	}
@@ -1178,7 +1181,7 @@ static int usbat_flash_read_data(struct us_data *us,
 		if (result != USB_STOR_TRANSPORT_GOOD)
 			goto leave;
   	 
-		US_DEBUGP("usbat_flash_read_data:  %d bytes\n", len);
+		usb_stor_dbg(us, "%d bytes\n", len);
 	
 		/* Store the data in the transfer buffer */
 		usb_stor_access_xfer_buf(buffer, len, us->srb,
@@ -1301,8 +1304,7 @@ static int usbat_hp8200e_handle_read10(struct us_data *us,
 	unsigned int sg_offset = 0;
 	struct scatterlist *sg = NULL;
 
-	US_DEBUGP("handle_read10: transfersize %d\n",
-		srb->transfersize);
+	usb_stor_dbg(us, "transfersize %d\n", srb->transfersize);
 
 	if (scsi_bufflen(srb) < 0x10000) {
 
@@ -1329,14 +1331,14 @@ static int usbat_hp8200e_handle_read10(struct us_data *us,
 		len = short_pack(data[7+9], data[7+8]);
 		len <<= 16;
 		len |= data[7+7];
-		US_DEBUGP("handle_read10: GPCMD_READ_CD: len %d\n", len);
+		usb_stor_dbg(us, "GPCMD_READ_CD: len %d\n", len);
 		srb->transfersize = scsi_bufflen(srb)/len;
 	}
 
 	if (!srb->transfersize)  {
 		srb->transfersize = 2048; /* A guess */
-		US_DEBUGP("handle_read10: transfersize 0, forcing %d\n",
-			srb->transfersize);
+		usb_stor_dbg(us, "transfersize 0, forcing %d\n",
+			     srb->transfersize);
 	}
 
 	/*
@@ -1346,7 +1348,7 @@ static int usbat_hp8200e_handle_read10(struct us_data *us,
 	 */
 
 	len = (65535/srb->transfersize) * srb->transfersize;
-	US_DEBUGP("Max read is %d bytes\n", len);
+	usb_stor_dbg(us, "Max read is %d bytes\n", len);
 	len = min(len, scsi_bufflen(srb));
 	buffer = kmalloc(len, GFP_NOIO);
 	if (buffer == NULL) /* bloody hell! */
@@ -1460,10 +1462,9 @@ static int init_usbat(struct us_data *us, int devicetype)
 	unsigned char *status = us->iobuf;
 
 	us->extra = kzalloc(sizeof(struct usbat_info), GFP_NOIO);
-	if (!us->extra) {
-		US_DEBUGP("init_usbat: Gah! Can't allocate storage for usbat info struct!\n");
+	if (!us->extra)
 		return 1;
-	}
+
 	info = (struct usbat_info *) (us->extra);
 
 	/* Enable peripheral control signals */
@@ -1473,7 +1474,7 @@ static int init_usbat(struct us_data *us, int devicetype)
 	if (rc != USB_STOR_XFER_GOOD)
 		return USB_STOR_TRANSPORT_ERROR;
 
-	US_DEBUGP("INIT 1\n");
+	usb_stor_dbg(us, "INIT 1\n");
 
 	msleep(2000);
 
@@ -1481,7 +1482,7 @@ static int init_usbat(struct us_data *us, int devicetype)
 	if (rc != USB_STOR_TRANSPORT_GOOD)
 		return rc;
 
-	US_DEBUGP("INIT 2\n");
+	usb_stor_dbg(us, "INIT 2\n");
 
 	rc = usbat_read_user_io(us, status);
 	if (rc != USB_STOR_XFER_GOOD)
@@ -1491,32 +1492,32 @@ static int init_usbat(struct us_data *us, int devicetype)
 	if (rc != USB_STOR_XFER_GOOD)
 		return USB_STOR_TRANSPORT_ERROR;
 
-	US_DEBUGP("INIT 3\n");
+	usb_stor_dbg(us, "INIT 3\n");
 
 	rc = usbat_select_and_test_registers(us);
 	if (rc != USB_STOR_TRANSPORT_GOOD)
 		return rc;
 
-	US_DEBUGP("INIT 4\n");
+	usb_stor_dbg(us, "INIT 4\n");
 
 	rc = usbat_read_user_io(us, status);
 	if (rc != USB_STOR_XFER_GOOD)
 		return USB_STOR_TRANSPORT_ERROR;
 
-	US_DEBUGP("INIT 5\n");
+	usb_stor_dbg(us, "INIT 5\n");
 
 	/* Enable peripheral control signals and card detect */
 	rc = usbat_device_enable_cdt(us);
 	if (rc != USB_STOR_TRANSPORT_GOOD)
 		return rc;
 
-	US_DEBUGP("INIT 6\n");
+	usb_stor_dbg(us, "INIT 6\n");
 
 	rc = usbat_read_user_io(us, status);
 	if (rc != USB_STOR_XFER_GOOD)
 		return USB_STOR_TRANSPORT_ERROR;
 
-	US_DEBUGP("INIT 7\n");
+	usb_stor_dbg(us, "INIT 7\n");
 
 	msleep(1400);
 
@@ -1524,19 +1525,19 @@ static int init_usbat(struct us_data *us, int devicetype)
 	if (rc != USB_STOR_XFER_GOOD)
 		return USB_STOR_TRANSPORT_ERROR;
 
-	US_DEBUGP("INIT 8\n");
+	usb_stor_dbg(us, "INIT 8\n");
 
 	rc = usbat_select_and_test_registers(us);
 	if (rc != USB_STOR_TRANSPORT_GOOD)
 		return rc;
 
-	US_DEBUGP("INIT 9\n");
+	usb_stor_dbg(us, "INIT 9\n");
 
 	/* At this point, we need to detect which device we are using */
 	if (usbat_set_transport(us, info, devicetype))
 		return USB_STOR_TRANSPORT_ERROR;
 
-	US_DEBUGP("INIT 10\n");
+	usb_stor_dbg(us, "INIT 10\n");
 
 	if (usbat_get_device_type(us) == USBAT_DEV_FLASH) { 
 		subcountH = 0x02;
@@ -1547,7 +1548,7 @@ static int init_usbat(struct us_data *us, int devicetype)
 	if (rc != USB_STOR_XFER_GOOD)
 		return USB_STOR_TRANSPORT_ERROR;
 
-	US_DEBUGP("INIT 11\n");
+	usb_stor_dbg(us, "INIT 11\n");
 
 	return USB_STOR_TRANSPORT_GOOD;
 }
@@ -1592,7 +1593,7 @@ static int usbat_hp8200e_transport(struct scsi_cmnd *srb, struct us_data *us)
 	}
 
 	result = usbat_get_status(us, status);
-	US_DEBUGP("Status = %02X\n", *status);
+	usb_stor_dbg(us, "Status = %02X\n", *status);
 	if (result != USB_STOR_XFER_GOOD)
 		return USB_STOR_TRANSPORT_ERROR;
 	if (srb->cmnd[0] == TEST_UNIT_READY)
@@ -1610,7 +1611,7 @@ static int usbat_hp8200e_transport(struct scsi_cmnd *srb, struct us_data *us)
 
 		if (result == USB_STOR_TRANSPORT_GOOD) {
 			transferred += len;
-			US_DEBUGP("Wrote %08X bytes\n", transferred);
+			usb_stor_dbg(us, "Wrote %08X bytes\n", transferred);
 		}
 
 		return result;
@@ -1623,8 +1624,8 @@ static int usbat_hp8200e_transport(struct scsi_cmnd *srb, struct us_data *us)
 	}
 
 	if (len > 0xFFFF) {
-		US_DEBUGP("Error: len = %08X... what do I do now?\n",
-			len);
+		usb_stor_dbg(us, "Error: len = %08X... what do I do now?\n",
+			     len);
 		return USB_STOR_TRANSPORT_ERROR;
 	}
 
@@ -1693,7 +1694,7 @@ static int usbat_flash_transport(struct scsi_cmnd * srb, struct us_data *us)
 	};
 
 	if (srb->cmnd[0] == INQUIRY) {
-		US_DEBUGP("usbat_flash_transport: INQUIRY. Returning bogus response.\n");
+		usb_stor_dbg(us, "INQUIRY - Returning bogus response\n");
 		memcpy(ptr, inquiry_response, sizeof(inquiry_response));
 		fill_inquiry_response(us, ptr, 36);
 		return USB_STOR_TRANSPORT_GOOD;
@@ -1710,8 +1711,8 @@ static int usbat_flash_transport(struct scsi_cmnd * srb, struct us_data *us)
 
 		/* hard coded 512 byte sectors as per ATA spec */
 		info->ssize = 0x200;
-		US_DEBUGP("usbat_flash_transport: READ_CAPACITY: %ld sectors, %ld bytes per sector\n",
-			  info->sectors, info->ssize);
+		usb_stor_dbg(us, "READ_CAPACITY: %ld sectors, %ld bytes per sector\n",
+			     info->sectors, info->ssize);
 
 		/*
 		 * build the reply
@@ -1726,7 +1727,7 @@ static int usbat_flash_transport(struct scsi_cmnd * srb, struct us_data *us)
 	}
 
 	if (srb->cmnd[0] == MODE_SELECT_10) {
-		US_DEBUGP("usbat_flash_transport:  Gah! MODE_SELECT_10.\n");
+		usb_stor_dbg(us, "Gah! MODE_SELECT_10\n");
 		return USB_STOR_TRANSPORT_ERROR;
 	}
 
@@ -1736,7 +1737,8 @@ static int usbat_flash_transport(struct scsi_cmnd * srb, struct us_data *us)
 
 		blocks = ((u32)(srb->cmnd[7]) << 8) | ((u32)(srb->cmnd[8]));
 
-		US_DEBUGP("usbat_flash_transport:  READ_10: read block 0x%04lx  count %ld\n", block, blocks);
+		usb_stor_dbg(us, "READ_10: read block 0x%04lx  count %ld\n",
+			     block, blocks);
 		return usbat_flash_read_data(us, info, block, blocks);
 	}
 
@@ -1750,7 +1752,8 @@ static int usbat_flash_transport(struct scsi_cmnd * srb, struct us_data *us)
 		blocks = ((u32)(srb->cmnd[6]) << 24) | ((u32)(srb->cmnd[7]) << 16) |
 		         ((u32)(srb->cmnd[8]) <<  8) | ((u32)(srb->cmnd[9]));
 
-		US_DEBUGP("usbat_flash_transport: READ_12: read block 0x%04lx  count %ld\n", block, blocks);
+		usb_stor_dbg(us, "READ_12: read block 0x%04lx  count %ld\n",
+			     block, blocks);
 		return usbat_flash_read_data(us, info, block, blocks);
 	}
 
@@ -1760,7 +1763,8 @@ static int usbat_flash_transport(struct scsi_cmnd * srb, struct us_data *us)
 
 		blocks = ((u32)(srb->cmnd[7]) << 8) | ((u32)(srb->cmnd[8]));
 
-		US_DEBUGP("usbat_flash_transport: WRITE_10: write block 0x%04lx  count %ld\n", block, blocks);
+		usb_stor_dbg(us, "WRITE_10: write block 0x%04lx  count %ld\n",
+			     block, blocks);
 		return usbat_flash_write_data(us, info, block, blocks);
 	}
 
@@ -1774,13 +1778,14 @@ static int usbat_flash_transport(struct scsi_cmnd * srb, struct us_data *us)
 		blocks = ((u32)(srb->cmnd[6]) << 24) | ((u32)(srb->cmnd[7]) << 16) |
 		         ((u32)(srb->cmnd[8]) <<  8) | ((u32)(srb->cmnd[9]));
 
-		US_DEBUGP("usbat_flash_transport: WRITE_12: write block 0x%04lx  count %ld\n", block, blocks);
+		usb_stor_dbg(us, "WRITE_12: write block 0x%04lx  count %ld\n",
+			     block, blocks);
 		return usbat_flash_write_data(us, info, block, blocks);
 	}
 
 
 	if (srb->cmnd[0] == TEST_UNIT_READY) {
-		US_DEBUGP("usbat_flash_transport: TEST_UNIT_READY.\n");
+		usb_stor_dbg(us, "TEST_UNIT_READY\n");
 
 		rc = usbat_flash_check_media(us, info);
 		if (rc != USB_STOR_TRANSPORT_GOOD)
@@ -1790,7 +1795,7 @@ static int usbat_flash_transport(struct scsi_cmnd * srb, struct us_data *us)
 	}
 
 	if (srb->cmnd[0] == REQUEST_SENSE) {
-		US_DEBUGP("usbat_flash_transport: REQUEST_SENSE.\n");
+		usb_stor_dbg(us, "REQUEST_SENSE\n");
 
 		memset(ptr, 0, 18);
 		ptr[0] = 0xF0;
@@ -1811,8 +1816,8 @@ static int usbat_flash_transport(struct scsi_cmnd * srb, struct us_data *us)
 		return USB_STOR_TRANSPORT_GOOD;
 	}
 
-	US_DEBUGP("usbat_flash_transport: Gah! Unknown command: %d (0x%x)\n",
-			  srb->cmnd[0], srb->cmnd[0]);
+	usb_stor_dbg(us, "Gah! Unknown command: %d (0x%x)\n",
+		     srb->cmnd[0], srb->cmnd[0]);
 	info->sense_key = 0x05;
 	info->sense_asc = 0x20;
 	info->sense_ascq = 0x00;
diff --git a/drivers/usb/storage/sierra_ms.c b/drivers/usb/storage/sierra_ms.c
index 17e3695..2ea657b 100644
--- a/drivers/usb/storage/sierra_ms.c
+++ b/drivers/usb/storage/sierra_ms.c
@@ -47,7 +47,7 @@ static bool containsFullLinuxPackage(struct swoc_info *swocInfo)
 static int sierra_set_ms_mode(struct usb_device *udev, __u16 eSWocMode)
 {
 	int result;
-	US_DEBUGP("SWIMS: %s", "DEVICE MODE SWITCH\n");
+	dev_dbg(&udev->dev, "SWIMS: %s", "DEVICE MODE SWITCH\n");
 	result = usb_control_msg(udev, usb_sndctrlpipe(udev, 0),
 			SWIMS_USB_REQUEST_SetSwocMode,	/* __u8 request      */
 			USB_TYPE_VENDOR | USB_DIR_OUT,	/* __u8 request type */
@@ -65,7 +65,7 @@ static int sierra_get_swoc_info(struct usb_device *udev,
 {
 	int result;
 
-	US_DEBUGP("SWIMS: Attempting to get TRU-Install info.\n");
+	dev_dbg(&udev->dev, "SWIMS: Attempting to get TRU-Install info\n");
 
 	result = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0),
 			SWIMS_USB_REQUEST_GetSwocInfo,	/* __u8 request      */
@@ -81,11 +81,11 @@ static int sierra_get_swoc_info(struct usb_device *udev,
 	return result;
 }
 
-static void debug_swoc(struct swoc_info *swocInfo)
+static void debug_swoc(const struct device *dev, struct swoc_info *swocInfo)
 {
-	US_DEBUGP("SWIMS: SWoC Rev: %02d \n", swocInfo->rev);
-	US_DEBUGP("SWIMS: Linux SKU: %04X \n", swocInfo->LinuxSKU);
-	US_DEBUGP("SWIMS: Linux Version: %04X \n", swocInfo->LinuxVer);
+	dev_dbg(dev, "SWIMS: SWoC Rev: %02d\n", swocInfo->rev);
+	dev_dbg(dev, "SWIMS: Linux SKU: %04X\n", swocInfo->LinuxSKU);
+	dev_dbg(dev, "SWIMS: Linux Version: %04X\n", swocInfo->LinuxVer);
 }
 
 
@@ -101,18 +101,17 @@ static ssize_t show_truinst(struct device *dev, struct device_attribute *attr,
 	} else {
 		swocInfo = kmalloc(sizeof(struct swoc_info), GFP_KERNEL);
 		if (!swocInfo) {
-			US_DEBUGP("SWIMS: Allocation failure\n");
 			snprintf(buf, PAGE_SIZE, "Error\n");
 			return -ENOMEM;
 		}
 		result = sierra_get_swoc_info(udev, swocInfo);
 		if (result < 0) {
-			US_DEBUGP("SWIMS: failed SWoC query\n");
+			dev_dbg(dev, "SWIMS: failed SWoC query\n");
 			kfree(swocInfo);
 			snprintf(buf, PAGE_SIZE, "Error\n");
 			return -EIO;
 		}
-		debug_swoc(swocInfo);
+		debug_swoc(dev, swocInfo);
 		result = snprintf(buf, PAGE_SIZE,
 			"REV=%02d SKU=%04X VER=%04X\n",
 			swocInfo->rev,
@@ -138,61 +137,55 @@ int sierra_ms_init(struct us_data *us)
 	sh = us_to_host(us);
 	scsi_get_host_dev(sh);
 
-	US_DEBUGP("SWIMS: sierra_ms_init called\n");
-
 	/* Force Modem mode */
 	if (swi_tru_install == TRU_FORCE_MODEM) {
-		US_DEBUGP("SWIMS: %s", "Forcing Modem Mode\n");
+		usb_stor_dbg(us, "SWIMS: Forcing Modem Mode\n");
 		result = sierra_set_ms_mode(udev, SWIMS_SET_MODE_Modem);
 		if (result < 0)
-			US_DEBUGP("SWIMS: Failed to switch to modem mode.\n");
+			usb_stor_dbg(us, "SWIMS: Failed to switch to modem mode\n");
 		return -EIO;
 	}
 	/* Force Mass Storage mode (keep CD-Rom) */
 	else if (swi_tru_install == TRU_FORCE_MS) {
-		US_DEBUGP("SWIMS: %s", "Forcing Mass Storage Mode\n");
+		usb_stor_dbg(us, "SWIMS: Forcing Mass Storage Mode\n");
 		goto complete;
 	}
 	/* Normal TRU-Install Logic */
 	else {
-		US_DEBUGP("SWIMS: %s", "Normal SWoC Logic\n");
+		usb_stor_dbg(us, "SWIMS: Normal SWoC Logic\n");
 
 		swocInfo = kmalloc(sizeof(struct swoc_info),
 				GFP_KERNEL);
-		if (!swocInfo) {
-			US_DEBUGP("SWIMS: %s", "Allocation failure\n");
+		if (!swocInfo)
 			return -ENOMEM;
-		}
 
 		retries = 3;
 		do {
 			retries--;
 			result = sierra_get_swoc_info(udev, swocInfo);
 			if (result < 0) {
-				US_DEBUGP("SWIMS: %s", "Failed SWoC query\n");
+				usb_stor_dbg(us, "SWIMS: Failed SWoC query\n");
 				schedule_timeout_uninterruptible(2*HZ);
 			}
 		} while (retries && result < 0);
 
 		if (result < 0) {
-			US_DEBUGP("SWIMS: %s",
-				  "Completely failed SWoC query\n");
+			usb_stor_dbg(us, "SWIMS: Completely failed SWoC query\n");
 			kfree(swocInfo);
 			return -EIO;
 		}
 
-		debug_swoc(swocInfo);
+		debug_swoc(&us->pusb_dev->dev, swocInfo);
 
 		/* If there is not Linux software on the TRU-Install device
 		 * then switch to modem mode
 		 */
 		if (!containsFullLinuxPackage(swocInfo)) {
-			US_DEBUGP("SWIMS: %s",
-				"Switching to Modem Mode\n");
+			usb_stor_dbg(us, "SWIMS: Switching to Modem Mode\n");
 			result = sierra_set_ms_mode(udev,
 				SWIMS_SET_MODE_Modem);
 			if (result < 0)
-				US_DEBUGP("SWIMS: Failed to switch modem\n");
+				usb_stor_dbg(us, "SWIMS: Failed to switch modem\n");
 			kfree(swocInfo);
 			return -EIO;
 		}
diff --git a/drivers/usb/storage/transport.c b/drivers/usb/storage/transport.c
index c0543c8..22c7d43 100644
--- a/drivers/usb/storage/transport.c
+++ b/drivers/usb/storage/transport.c
@@ -166,7 +166,7 @@ static int usb_stor_msg_common(struct us_data *us, int timeout)
 
 		/* cancel the URB, if it hasn't been cancelled already */
 		if (test_and_clear_bit(US_FLIDX_URB_ACTIVE, &us->dflags)) {
-			US_DEBUGP("-- cancelling URB\n");
+			usb_stor_dbg(us, "-- cancelling URB\n");
 			usb_unlink_urb(us->current_urb);
 		}
 	}
@@ -178,8 +178,8 @@ static int usb_stor_msg_common(struct us_data *us, int timeout)
 	clear_bit(US_FLIDX_URB_ACTIVE, &us->dflags);
 
 	if (timeleft <= 0) {
-		US_DEBUGP("%s -- cancelling URB\n",
-			  timeleft == 0 ? "Timeout" : "Signal");
+		usb_stor_dbg(us, "%s -- cancelling URB\n",
+			     timeleft == 0 ? "Timeout" : "Signal");
 		usb_kill_urb(us->current_urb);
 	}
 
@@ -197,9 +197,8 @@ int usb_stor_control_msg(struct us_data *us, unsigned int pipe,
 {
 	int status;
 
-	US_DEBUGP("%s: rq=%02x rqtype=%02x value=%04x index=%02x len=%u\n",
-			__func__, request, requesttype,
-			value, index, size);
+	usb_stor_dbg(us, "rq=%02x rqtype=%02x value=%04x index=%02x len=%u\n",
+		     request, requesttype, value, index, size);
 
 	/* fill in the devrequest structure */
 	us->cr->bRequestType = requesttype;
@@ -249,7 +248,7 @@ int usb_stor_clear_halt(struct us_data *us, unsigned int pipe)
 	if (result >= 0)
 		usb_reset_endpoint(us->pusb_dev, endp);
 
-	US_DEBUGP("%s: result = %d\n", __func__, result);
+	usb_stor_dbg(us, "result = %d\n", result);
 	return result;
 }
 EXPORT_SYMBOL_GPL(usb_stor_clear_halt);
@@ -265,18 +264,18 @@ EXPORT_SYMBOL_GPL(usb_stor_clear_halt);
 static int interpret_urb_result(struct us_data *us, unsigned int pipe,
 		unsigned int length, int result, unsigned int partial)
 {
-	US_DEBUGP("Status code %d; transferred %u/%u\n",
-			result, partial, length);
+	usb_stor_dbg(us, "Status code %d; transferred %u/%u\n",
+		     result, partial, length);
 	switch (result) {
 
 	/* no error code; did we send all the data? */
 	case 0:
 		if (partial != length) {
-			US_DEBUGP("-- short transfer\n");
+			usb_stor_dbg(us, "-- short transfer\n");
 			return USB_STOR_XFER_SHORT;
 		}
 
-		US_DEBUGP("-- transfer complete\n");
+		usb_stor_dbg(us, "-- transfer complete\n");
 		return USB_STOR_XFER_GOOD;
 
 	/* stalled */
@@ -284,39 +283,40 @@ static int interpret_urb_result(struct us_data *us, unsigned int pipe,
 		/* for control endpoints, (used by CB[I]) a stall indicates
 		 * a failed command */
 		if (usb_pipecontrol(pipe)) {
-			US_DEBUGP("-- stall on control pipe\n");
+			usb_stor_dbg(us, "-- stall on control pipe\n");
 			return USB_STOR_XFER_STALLED;
 		}
 
 		/* for other sorts of endpoint, clear the stall */
-		US_DEBUGP("clearing endpoint halt for pipe 0x%x\n", pipe);
+		usb_stor_dbg(us, "clearing endpoint halt for pipe 0x%x\n",
+			     pipe);
 		if (usb_stor_clear_halt(us, pipe) < 0)
 			return USB_STOR_XFER_ERROR;
 		return USB_STOR_XFER_STALLED;
 
 	/* babble - the device tried to send more than we wanted to read */
 	case -EOVERFLOW:
-		US_DEBUGP("-- babble\n");
+		usb_stor_dbg(us, "-- babble\n");
 		return USB_STOR_XFER_LONG;
 
 	/* the transfer was cancelled by abort, disconnect, or timeout */
 	case -ECONNRESET:
-		US_DEBUGP("-- transfer cancelled\n");
+		usb_stor_dbg(us, "-- transfer cancelled\n");
 		return USB_STOR_XFER_ERROR;
 
 	/* short scatter-gather read transfer */
 	case -EREMOTEIO:
-		US_DEBUGP("-- short read transfer\n");
+		usb_stor_dbg(us, "-- short read transfer\n");
 		return USB_STOR_XFER_SHORT;
 
 	/* abort or disconnect in progress */
 	case -EIO:
-		US_DEBUGP("-- abort or disconnect in progress\n");
+		usb_stor_dbg(us, "-- abort or disconnect in progress\n");
 		return USB_STOR_XFER_ERROR;
 
 	/* the catch-all error case */
 	default:
-		US_DEBUGP("-- unknown error\n");
+		usb_stor_dbg(us, "-- unknown error\n");
 		return USB_STOR_XFER_ERROR;
 	}
 }
@@ -331,9 +331,8 @@ int usb_stor_ctrl_transfer(struct us_data *us, unsigned int pipe,
 {
 	int result;
 
-	US_DEBUGP("%s: rq=%02x rqtype=%02x value=%04x index=%02x len=%u\n",
-			__func__, request, requesttype,
-			value, index, size);
+	usb_stor_dbg(us, "rq=%02x rqtype=%02x value=%04x index=%02x len=%u\n",
+		     request, requesttype, value, index, size);
 
 	/* fill in the devrequest structure */
 	us->cr->bRequestType = requesttype;
@@ -367,7 +366,7 @@ static int usb_stor_intr_transfer(struct us_data *us, void *buf,
 	unsigned int pipe = us->recv_intr_pipe;
 	unsigned int maxp;
 
-	US_DEBUGP("%s: xfer %u bytes\n", __func__, length);
+	usb_stor_dbg(us, "xfer %u bytes\n", length);
 
 	/* calculate the max packet size */
 	maxp = usb_maxpacket(us->pusb_dev, pipe, usb_pipeout(pipe));
@@ -394,7 +393,7 @@ int usb_stor_bulk_transfer_buf(struct us_data *us, unsigned int pipe,
 {
 	int result;
 
-	US_DEBUGP("%s: xfer %u bytes\n", __func__, length);
+	usb_stor_dbg(us, "xfer %u bytes\n", length);
 
 	/* fill and submit the URB */
 	usb_fill_bulk_urb(us->current_urb, us->pusb_dev, pipe, buf, length,
@@ -426,12 +425,11 @@ static int usb_stor_bulk_transfer_sglist(struct us_data *us, unsigned int pipe,
 		return USB_STOR_XFER_ERROR;
 
 	/* initialize the scatter-gather request block */
-	US_DEBUGP("%s: xfer %u bytes, %d entries\n", __func__,
-			length, num_sg);
+	usb_stor_dbg(us, "xfer %u bytes, %d entries\n", length, num_sg);
 	result = usb_sg_init(&us->current_sg, us->pusb_dev, pipe, 0,
 			sg, num_sg, length, GFP_NOIO);
 	if (result) {
-		US_DEBUGP("usb_sg_init returned %d\n", result);
+		usb_stor_dbg(us, "usb_sg_init returned %d\n", result);
 		return USB_STOR_XFER_ERROR;
 	}
 
@@ -444,7 +442,7 @@ static int usb_stor_bulk_transfer_sglist(struct us_data *us, unsigned int pipe,
 
 		/* cancel the request, if it hasn't been cancelled already */
 		if (test_and_clear_bit(US_FLIDX_SG_ACTIVE, &us->dflags)) {
-			US_DEBUGP("-- cancelling sg request\n");
+			usb_stor_dbg(us, "-- cancelling sg request\n");
 			usb_sg_cancel(&us->current_sg);
 		}
 	}
@@ -609,14 +607,14 @@ void usb_stor_invoke_transport(struct scsi_cmnd *srb, struct us_data *us)
 	 * short-circuit all other processing
 	 */
 	if (test_bit(US_FLIDX_TIMED_OUT, &us->dflags)) {
-		US_DEBUGP("-- command was aborted\n");
+		usb_stor_dbg(us, "-- command was aborted\n");
 		srb->result = DID_ABORT << 16;
 		goto Handle_Errors;
 	}
 
 	/* if there is a transport error, reset and don't auto-sense */
 	if (result == USB_STOR_TRANSPORT_ERROR) {
-		US_DEBUGP("-- transport indicates error, resetting\n");
+		usb_stor_dbg(us, "-- transport indicates error, resetting\n");
 		srb->result = DID_ERROR << 16;
 		goto Handle_Errors;
 	}
@@ -645,7 +643,7 @@ void usb_stor_invoke_transport(struct scsi_cmnd *srb, struct us_data *us)
 	 */
 	if ((us->protocol == USB_PR_CB || us->protocol == USB_PR_DPCM_USB) &&
 			srb->sc_data_direction != DMA_FROM_DEVICE) {
-		US_DEBUGP("-- CB transport device requiring auto-sense\n");
+		usb_stor_dbg(us, "-- CB transport device requiring auto-sense\n");
 		need_auto_sense = 1;
 	}
 
@@ -655,7 +653,7 @@ void usb_stor_invoke_transport(struct scsi_cmnd *srb, struct us_data *us)
 	 * "failure" and an "error" in the transport mechanism.
 	 */
 	if (result == USB_STOR_TRANSPORT_FAILED) {
-		US_DEBUGP("-- transport indicates command failure\n");
+		usb_stor_dbg(us, "-- transport indicates command failure\n");
 		need_auto_sense = 1;
 	}
 
@@ -670,7 +668,7 @@ void usb_stor_invoke_transport(struct scsi_cmnd *srb, struct us_data *us)
 	    !(us->fflags & US_FL_SANE_SENSE) &&
 	    !(us->fflags & US_FL_BAD_SENSE) &&
 	    !(srb->cmnd[2] & 0x20))) {
-		US_DEBUGP("-- SAT supported, increasing auto-sense\n");
+		usb_stor_dbg(us, "-- SAT supported, increasing auto-sense\n");
 		us->fflags |= US_FL_SANE_SENSE;
 	}
 
@@ -684,7 +682,7 @@ void usb_stor_invoke_transport(struct scsi_cmnd *srb, struct us_data *us)
 	      (srb->cmnd[0] == MODE_SENSE) ||
 	      (srb->cmnd[0] == LOG_SENSE) ||
 	      (srb->cmnd[0] == MODE_SENSE_10))) {
-		US_DEBUGP("-- unexpectedly short transfer\n");
+		usb_stor_dbg(us, "-- unexpectedly short transfer\n");
 	}
 
 	/* Now, if we need to do the auto-sense, let's do it */
@@ -700,7 +698,7 @@ void usb_stor_invoke_transport(struct scsi_cmnd *srb, struct us_data *us)
 		if (us->fflags & US_FL_SANE_SENSE)
 			sense_size = ~0;
 Retry_Sense:
-		US_DEBUGP("Issuing auto-REQUEST_SENSE\n");
+		usb_stor_dbg(us, "Issuing auto-REQUEST_SENSE\n");
 
 		scsi_eh_prep_cmnd(srb, &ses, NULL, 0, sense_size);
 
@@ -719,7 +717,7 @@ Retry_Sense:
 		scsi_eh_restore_cmnd(srb, &ses);
 
 		if (test_bit(US_FLIDX_TIMED_OUT, &us->dflags)) {
-			US_DEBUGP("-- auto-sense aborted\n");
+			usb_stor_dbg(us, "-- auto-sense aborted\n");
 			srb->result = DID_ABORT << 16;
 
 			/* If SANE_SENSE caused this problem, disable it */
@@ -737,7 +735,7 @@ Retry_Sense:
 		 */
 		if (temp_result == USB_STOR_TRANSPORT_FAILED &&
 				sense_size != US_SENSE_SIZE) {
-			US_DEBUGP("-- auto-sense failure, retry small sense\n");
+			usb_stor_dbg(us, "-- auto-sense failure, retry small sense\n");
 			sense_size = US_SENSE_SIZE;
 			us->fflags &= ~US_FL_SANE_SENSE;
 			us->fflags |= US_FL_BAD_SENSE;
@@ -746,7 +744,7 @@ Retry_Sense:
 
 		/* Other failures */
 		if (temp_result != USB_STOR_TRANSPORT_GOOD) {
-			US_DEBUGP("-- auto-sense failure\n");
+			usb_stor_dbg(us, "-- auto-sense failure\n");
 
 			/* we skip the reset if this happens to be a
 			 * multi-target device, since failure of an
@@ -766,27 +764,28 @@ Retry_Sense:
 		    !(us->fflags & US_FL_SANE_SENSE) &&
 		    !(us->fflags & US_FL_BAD_SENSE) &&
 		    (srb->sense_buffer[0] & 0x7C) == 0x70) {
-			US_DEBUGP("-- SANE_SENSE support enabled\n");
+			usb_stor_dbg(us, "-- SANE_SENSE support enabled\n");
 			us->fflags |= US_FL_SANE_SENSE;
 
 			/* Indicate to the user that we truncated their sense
 			 * because we didn't know it supported larger sense.
 			 */
-			US_DEBUGP("-- Sense data truncated to %i from %i\n",
-			          US_SENSE_SIZE,
-			          srb->sense_buffer[7] + 8);
+			usb_stor_dbg(us, "-- Sense data truncated to %i from %i\n",
+				     US_SENSE_SIZE,
+				     srb->sense_buffer[7] + 8);
 			srb->sense_buffer[7] = (US_SENSE_SIZE - 8);
 		}
 
 		scsi_normalize_sense(srb->sense_buffer, SCSI_SENSE_BUFFERSIZE,
 				     &sshdr);
 
-		US_DEBUGP("-- Result from auto-sense is %d\n", temp_result);
-		US_DEBUGP("-- code: 0x%x, key: 0x%x, ASC: 0x%x, ASCQ: 0x%x\n",
-			  sshdr.response_code, sshdr.sense_key,
-			  sshdr.asc, sshdr.ascq);
+		usb_stor_dbg(us, "-- Result from auto-sense is %d\n",
+			     temp_result);
+		usb_stor_dbg(us, "-- code: 0x%x, key: 0x%x, ASC: 0x%x, ASCQ: 0x%x\n",
+			     sshdr.response_code, sshdr.sense_key,
+			     sshdr.asc, sshdr.ascq);
 #ifdef CONFIG_USB_STORAGE_DEBUG
-		usb_stor_show_sense(sshdr.sense_key, sshdr.asc, sshdr.ascq);
+		usb_stor_show_sense(us, sshdr.sense_key, sshdr.asc, sshdr.ascq);
 #endif
 
 		/* set the result so the higher layers expect this data */
@@ -892,20 +891,18 @@ Retry_Sense:
 /* Stop the current URB transfer */
 void usb_stor_stop_transport(struct us_data *us)
 {
-	US_DEBUGP("%s called\n", __func__);
-
 	/* If the state machine is blocked waiting for an URB,
 	 * let's wake it up.  The test_and_clear_bit() call
 	 * guarantees that if a URB has just been submitted,
 	 * it won't be cancelled more than once. */
 	if (test_and_clear_bit(US_FLIDX_URB_ACTIVE, &us->dflags)) {
-		US_DEBUGP("-- cancelling URB\n");
+		usb_stor_dbg(us, "-- cancelling URB\n");
 		usb_unlink_urb(us->current_urb);
 	}
 
 	/* If we are waiting for a scatter-gather operation, cancel it. */
 	if (test_and_clear_bit(US_FLIDX_SG_ACTIVE, &us->dflags)) {
-		US_DEBUGP("-- cancelling sg request\n");
+		usb_stor_dbg(us, "-- cancelling sg request\n");
 		usb_sg_cancel(&us->current_sg);
 	}
 }
@@ -928,7 +925,8 @@ int usb_stor_CB_transport(struct scsi_cmnd *srb, struct us_data *us)
 				      us->ifnum, srb->cmnd, srb->cmd_len);
 
 	/* check the return code for the command */
-	US_DEBUGP("Call to usb_stor_ctrl_transfer() returned %d\n", result);
+	usb_stor_dbg(us, "Call to usb_stor_ctrl_transfer() returned %d\n",
+		     result);
 
 	/* if we stalled the command, it means command failed */
 	if (result == USB_STOR_XFER_STALLED) {
@@ -946,7 +944,7 @@ int usb_stor_CB_transport(struct scsi_cmnd *srb, struct us_data *us)
 		pipe = srb->sc_data_direction == DMA_FROM_DEVICE ? 
 				us->recv_bulk_pipe : us->send_bulk_pipe;
 		result = usb_stor_bulk_srb(us, pipe, srb);
-		US_DEBUGP("CBI data stage result is 0x%x\n", result);
+		usb_stor_dbg(us, "CBI data stage result is 0x%x\n", result);
 
 		/* if we stalled the data transfer it means command failed */
 		if (result == USB_STOR_XFER_STALLED)
@@ -964,8 +962,8 @@ int usb_stor_CB_transport(struct scsi_cmnd *srb, struct us_data *us)
 		return USB_STOR_TRANSPORT_GOOD;
 
 	result = usb_stor_intr_transfer(us, us->iobuf, 2);
-	US_DEBUGP("Got interrupt data (0x%x, 0x%x)\n", 
-			us->iobuf[0], us->iobuf[1]);
+	usb_stor_dbg(us, "Got interrupt data (0x%x, 0x%x)\n",
+		     us->iobuf[0], us->iobuf[1]);
 	if (result != USB_STOR_XFER_GOOD)
 		return USB_STOR_TRANSPORT_ERROR;
 
@@ -992,8 +990,8 @@ int usb_stor_CB_transport(struct scsi_cmnd *srb, struct us_data *us)
 	 * into the first byte -- so if it's non-zero, call it a failure.
 	 */
 	if (us->iobuf[0]) {
-		US_DEBUGP("CBI IRQ data showed reserved bType 0x%x\n",
-				us->iobuf[0]);
+		usb_stor_dbg(us, "CBI IRQ data showed reserved bType 0x%x\n",
+			     us->iobuf[0]);
 		goto Failed;
 
 	}
@@ -1034,8 +1032,8 @@ int usb_stor_Bulk_max_lun(struct us_data *us)
 				 USB_RECIP_INTERFACE,
 				 0, us->ifnum, us->iobuf, 1, 10*HZ);
 
-	US_DEBUGP("GetMaxLUN command result is %d, data is %d\n", 
-		  result, us->iobuf[0]);
+	usb_stor_dbg(us, "GetMaxLUN command result is %d, data is %d\n",
+		     result, us->iobuf[0]);
 
 	/* if we have a successful request, return the result */
 	if (result > 0)
@@ -1084,14 +1082,14 @@ int usb_stor_Bulk_transport(struct scsi_cmnd *srb, struct us_data *us)
 	memcpy(bcb->CDB, srb->cmnd, bcb->Length);
 
 	/* send it to out endpoint */
-	US_DEBUGP("Bulk Command S 0x%x T 0x%x L %d F %d Trg %d LUN %d CL %d\n",
-			le32_to_cpu(bcb->Signature), bcb->Tag,
-			le32_to_cpu(bcb->DataTransferLength), bcb->Flags,
-			(bcb->Lun >> 4), (bcb->Lun & 0x0F), 
-			bcb->Length);
+	usb_stor_dbg(us, "Bulk Command S 0x%x T 0x%x L %d F %d Trg %d LUN %d CL %d\n",
+		     le32_to_cpu(bcb->Signature), bcb->Tag,
+		     le32_to_cpu(bcb->DataTransferLength), bcb->Flags,
+		     (bcb->Lun >> 4), (bcb->Lun & 0x0F),
+		     bcb->Length);
 	result = usb_stor_bulk_transfer_buf(us, us->send_bulk_pipe,
 				bcb, cbwlen, NULL);
-	US_DEBUGP("Bulk command transfer result=%d\n", result);
+	usb_stor_dbg(us, "Bulk command transfer result=%d\n", result);
 	if (result != USB_STOR_XFER_GOOD)
 		return USB_STOR_TRANSPORT_ERROR;
 
@@ -1108,7 +1106,7 @@ int usb_stor_Bulk_transport(struct scsi_cmnd *srb, struct us_data *us)
 		unsigned int pipe = srb->sc_data_direction == DMA_FROM_DEVICE ? 
 				us->recv_bulk_pipe : us->send_bulk_pipe;
 		result = usb_stor_bulk_srb(us, pipe, srb);
-		US_DEBUGP("Bulk data transfer result 0x%x\n", result);
+		usb_stor_dbg(us, "Bulk data transfer result 0x%x\n", result);
 		if (result == USB_STOR_XFER_ERROR)
 			return USB_STOR_TRANSPORT_ERROR;
 
@@ -1127,7 +1125,7 @@ int usb_stor_Bulk_transport(struct scsi_cmnd *srb, struct us_data *us)
 	 */
 
 	/* get CSW for device status */
-	US_DEBUGP("Attempting to get CSW...\n");
+	usb_stor_dbg(us, "Attempting to get CSW...\n");
 	result = usb_stor_bulk_transfer_buf(us, us->recv_bulk_pipe,
 				bcs, US_BULK_CS_WRAP_LEN, &cswlen);
 
@@ -1136,7 +1134,7 @@ int usb_stor_Bulk_transport(struct scsi_cmnd *srb, struct us_data *us)
 	 * CSWs.  If we encounter such a thing, try to read the CSW again.
 	 */
 	if (result == USB_STOR_XFER_SHORT && cswlen == 0) {
-		US_DEBUGP("Received 0-length CSW; retrying...\n");
+		usb_stor_dbg(us, "Received 0-length CSW; retrying...\n");
 		result = usb_stor_bulk_transfer_buf(us, us->recv_bulk_pipe,
 				bcs, US_BULK_CS_WRAP_LEN, &cswlen);
 	}
@@ -1145,24 +1143,24 @@ int usb_stor_Bulk_transport(struct scsi_cmnd *srb, struct us_data *us)
 	if (result == USB_STOR_XFER_STALLED) {
 
 		/* get the status again */
-		US_DEBUGP("Attempting to get CSW (2nd try)...\n");
+		usb_stor_dbg(us, "Attempting to get CSW (2nd try)...\n");
 		result = usb_stor_bulk_transfer_buf(us, us->recv_bulk_pipe,
 				bcs, US_BULK_CS_WRAP_LEN, NULL);
 	}
 
 	/* if we still have a failure at this point, we're in trouble */
-	US_DEBUGP("Bulk status result = %d\n", result);
+	usb_stor_dbg(us, "Bulk status result = %d\n", result);
 	if (result != USB_STOR_XFER_GOOD)
 		return USB_STOR_TRANSPORT_ERROR;
 
 	/* check bulk status */
 	residue = le32_to_cpu(bcs->Residue);
-	US_DEBUGP("Bulk Status S 0x%x T 0x%x R %u Stat 0x%x\n",
-			le32_to_cpu(bcs->Signature), bcs->Tag, 
-			residue, bcs->Status);
+	usb_stor_dbg(us, "Bulk Status S 0x%x T 0x%x R %u Stat 0x%x\n",
+		     le32_to_cpu(bcs->Signature), bcs->Tag,
+		     residue, bcs->Status);
 	if (!(bcs->Tag == us->tag || (us->fflags & US_FL_BULK_IGNORE_TAG)) ||
 		bcs->Status > US_BULK_STAT_PHASE) {
-		US_DEBUGP("Bulk logical error\n");
+		usb_stor_dbg(us, "Bulk logical error\n");
 		return USB_STOR_TRANSPORT_ERROR;
 	}
 
@@ -1173,12 +1171,12 @@ int usb_stor_Bulk_transport(struct scsi_cmnd *srb, struct us_data *us)
 	if (!us->bcs_signature) {
 		us->bcs_signature = bcs->Signature;
 		if (us->bcs_signature != cpu_to_le32(US_BULK_CS_SIGN))
-			US_DEBUGP("Learnt BCS signature 0x%08X\n",
-					le32_to_cpu(us->bcs_signature));
+			usb_stor_dbg(us, "Learnt BCS signature 0x%08X\n",
+				     le32_to_cpu(us->bcs_signature));
 	} else if (bcs->Signature != us->bcs_signature) {
-		US_DEBUGP("Signature mismatch: got %08X, expecting %08X\n",
-			  le32_to_cpu(bcs->Signature),
-			  le32_to_cpu(us->bcs_signature));
+		usb_stor_dbg(us, "Signature mismatch: got %08X, expecting %08X\n",
+			     le32_to_cpu(bcs->Signature),
+			     le32_to_cpu(us->bcs_signature));
 		return USB_STOR_TRANSPORT_ERROR;
 	}
 
@@ -1255,7 +1253,7 @@ static int usb_stor_reset_common(struct us_data *us,
 	int result2;
 
 	if (test_bit(US_FLIDX_DISCONNECTING, &us->dflags)) {
-		US_DEBUGP("No reset during disconnect\n");
+		usb_stor_dbg(us, "No reset during disconnect\n");
 		return -EIO;
 	}
 
@@ -1263,7 +1261,7 @@ static int usb_stor_reset_common(struct us_data *us,
 			request, requesttype, value, index, data, size,
 			5*HZ);
 	if (result < 0) {
-		US_DEBUGP("Soft reset failed: %d\n", result);
+		usb_stor_dbg(us, "Soft reset failed: %d\n", result);
 		return result;
 	}
 
@@ -1273,23 +1271,23 @@ static int usb_stor_reset_common(struct us_data *us,
 			test_bit(US_FLIDX_DISCONNECTING, &us->dflags),
 			HZ*6);
 	if (test_bit(US_FLIDX_DISCONNECTING, &us->dflags)) {
-		US_DEBUGP("Reset interrupted by disconnect\n");
+		usb_stor_dbg(us, "Reset interrupted by disconnect\n");
 		return -EIO;
 	}
 
-	US_DEBUGP("Soft reset: clearing bulk-in endpoint halt\n");
+	usb_stor_dbg(us, "Soft reset: clearing bulk-in endpoint halt\n");
 	result = usb_stor_clear_halt(us, us->recv_bulk_pipe);
 
-	US_DEBUGP("Soft reset: clearing bulk-out endpoint halt\n");
+	usb_stor_dbg(us, "Soft reset: clearing bulk-out endpoint halt\n");
 	result2 = usb_stor_clear_halt(us, us->send_bulk_pipe);
 
 	/* return a result code based on the result of the clear-halts */
 	if (result >= 0)
 		result = result2;
 	if (result < 0)
-		US_DEBUGP("Soft reset failed\n");
+		usb_stor_dbg(us, "Soft reset failed\n");
 	else
-		US_DEBUGP("Soft reset done\n");
+		usb_stor_dbg(us, "Soft reset done\n");
 	return result;
 }
 
@@ -1299,8 +1297,6 @@ static int usb_stor_reset_common(struct us_data *us,
 
 int usb_stor_CB_reset(struct us_data *us)
 {
-	US_DEBUGP("%s called\n", __func__);
-
 	memset(us->iobuf, 0xFF, CB_RESET_CMD_SIZE);
 	us->iobuf[0] = SEND_DIAGNOSTIC;
 	us->iobuf[1] = 4;
@@ -1315,8 +1311,6 @@ EXPORT_SYMBOL_GPL(usb_stor_CB_reset);
  */
 int usb_stor_Bulk_reset(struct us_data *us)
 {
-	US_DEBUGP("%s called\n", __func__);
-
 	return usb_stor_reset_common(us, US_BULK_RESET_REQUEST, 
 				 USB_TYPE_CLASS | USB_RECIP_INTERFACE,
 				 0, us->ifnum, NULL, 0);
@@ -1336,16 +1330,17 @@ int usb_stor_port_reset(struct us_data *us)
 
 	result = usb_lock_device_for_reset(us->pusb_dev, us->pusb_intf);
 	if (result < 0)
-		US_DEBUGP("unable to lock device for reset: %d\n", result);
+		usb_stor_dbg(us, "unable to lock device for reset: %d\n",
+			     result);
 	else {
 		/* Were we disconnected while waiting for the lock? */
 		if (test_bit(US_FLIDX_DISCONNECTING, &us->dflags)) {
 			result = -EIO;
-			US_DEBUGP("No reset during disconnect\n");
+			usb_stor_dbg(us, "No reset during disconnect\n");
 		} else {
 			result = usb_reset_device(us->pusb_dev);
-			US_DEBUGP("usb_reset_device returns %d\n",
-					result);
+			usb_stor_dbg(us, "usb_reset_device returns %d\n",
+				     result);
 		}
 		usb_unlock_device(us->pusb_dev);
 	}
diff --git a/drivers/usb/storage/usb.c b/drivers/usb/storage/usb.c
index d6bee40..b4c63fc 100644
--- a/drivers/usb/storage/usb.c
+++ b/drivers/usb/storage/usb.c
@@ -183,7 +183,6 @@ int usb_stor_suspend(struct usb_interface *iface, pm_message_t message)
 	/* Wait until no command is running */
 	mutex_lock(&us->dev_mutex);
 
-	US_DEBUGP("%s\n", __func__);
 	if (us->suspend_resume_hook)
 		(us->suspend_resume_hook)(us, US_SUSPEND);
 
@@ -201,7 +200,6 @@ int usb_stor_resume(struct usb_interface *iface)
 
 	mutex_lock(&us->dev_mutex);
 
-	US_DEBUGP("%s\n", __func__);
 	if (us->suspend_resume_hook)
 		(us->suspend_resume_hook)(us, US_RESUME);
 
@@ -214,8 +212,6 @@ int usb_stor_reset_resume(struct usb_interface *iface)
 {
 	struct us_data *us = usb_get_intfdata(iface);
 
-	US_DEBUGP("%s\n", __func__);
-
 	/* Report the reset to the SCSI core */
 	usb_stor_report_bus_reset(us);
 
@@ -236,8 +232,6 @@ int usb_stor_pre_reset(struct usb_interface *iface)
 {
 	struct us_data *us = usb_get_intfdata(iface);
 
-	US_DEBUGP("%s\n", __func__);
-
 	/* Make sure no command runs during the reset */
 	mutex_lock(&us->dev_mutex);
 	return 0;
@@ -248,8 +242,6 @@ int usb_stor_post_reset(struct usb_interface *iface)
 {
 	struct us_data *us = usb_get_intfdata(iface);
 
-	US_DEBUGP("%s\n", __func__);
-
 	/* Report the reset to the SCSI core */
 	usb_stor_report_bus_reset(us);
 
@@ -311,11 +303,11 @@ static int usb_stor_control_thread(void * __us)
 	struct Scsi_Host *host = us_to_host(us);
 
 	for (;;) {
-		US_DEBUGP("*** thread sleeping.\n");
+		usb_stor_dbg(us, "*** thread sleeping\n");
 		if (wait_for_completion_interruptible(&us->cmnd_ready))
 			break;
 
-		US_DEBUGP("*** thread awakened.\n");
+		usb_stor_dbg(us, "*** thread awakened\n");
 
 		/* lock the device pointers */
 		mutex_lock(&(us->dev_mutex));
@@ -327,7 +319,7 @@ static int usb_stor_control_thread(void * __us)
 		if (us->srb == NULL) {
 			scsi_unlock(host);
 			mutex_unlock(&us->dev_mutex);
-			US_DEBUGP("-- exiting\n");
+			usb_stor_dbg(us, "-- exiting\n");
 			break;
 		}
 
@@ -343,7 +335,7 @@ static int usb_stor_control_thread(void * __us)
 		 * is UNKNOWN
 		 */
 		if (us->srb->sc_data_direction == DMA_BIDIRECTIONAL) {
-			US_DEBUGP("UNKNOWN data direction\n");
+			usb_stor_dbg(us, "UNKNOWN data direction\n");
 			us->srb->result = DID_ERROR << 16;
 		}
 
@@ -352,14 +344,14 @@ static int usb_stor_control_thread(void * __us)
 		 */
 		else if (us->srb->device->id &&
 				!(us->fflags & US_FL_SCM_MULT_TARG)) {
-			US_DEBUGP("Bad target number (%d:%d)\n",
-				  us->srb->device->id, us->srb->device->lun);
+			usb_stor_dbg(us, "Bad target number (%d:%d)\n",
+				     us->srb->device->id, us->srb->device->lun);
 			us->srb->result = DID_BAD_TARGET << 16;
 		}
 
 		else if (us->srb->device->lun > us->max_lun) {
-			US_DEBUGP("Bad LUN (%d:%d)\n",
-				  us->srb->device->id, us->srb->device->lun);
+			usb_stor_dbg(us, "Bad LUN (%d:%d)\n",
+				     us->srb->device->id, us->srb->device->lun);
 			us->srb->result = DID_BAD_TARGET << 16;
 		}
 
@@ -371,14 +363,14 @@ static int usb_stor_control_thread(void * __us)
 			    0x00, 0x80, 0x02, 0x02,
 			    0x1F, 0x00, 0x00, 0x00};
 
-			US_DEBUGP("Faking INQUIRY command\n");
+			usb_stor_dbg(us, "Faking INQUIRY command\n");
 			fill_inquiry_response(us, data_ptr, 36);
 			us->srb->result = SAM_STAT_GOOD;
 		}
 
 		/* we've got a command, let's do it! */
 		else {
-			US_DEBUG(usb_stor_show_command(us->srb));
+			US_DEBUG(usb_stor_show_command(us, us->srb));
 			us->proto_handler(us->srb, us);
 			usb_mark_last_busy(us->pusb_dev);
 		}
@@ -388,12 +380,12 @@ static int usb_stor_control_thread(void * __us)
 
 		/* indicate that the command is done */
 		if (us->srb->result != DID_ABORT << 16) {
-			US_DEBUGP("scsi cmd done, result=0x%x\n",
-				   us->srb->result);
+			usb_stor_dbg(us, "scsi cmd done, result=0x%x\n",
+				     us->srb->result);
 			us->srb->scsi_done(us->srb);
 		} else {
 SkipForAbort:
-			US_DEBUGP("scsi command aborted\n");
+			usb_stor_dbg(us, "scsi command aborted\n");
 		}
 
 		/* If an abort request was received we need to signal that
@@ -435,34 +427,30 @@ SkipForAbort:
 /* Associate our private data with the USB device */
 static int associate_dev(struct us_data *us, struct usb_interface *intf)
 {
-	US_DEBUGP("-- %s\n", __func__);
-
 	/* Fill in the device-related fields */
 	us->pusb_dev = interface_to_usbdev(intf);
 	us->pusb_intf = intf;
 	us->ifnum = intf->cur_altsetting->desc.bInterfaceNumber;
-	US_DEBUGP("Vendor: 0x%04x, Product: 0x%04x, Revision: 0x%04x\n",
-			le16_to_cpu(us->pusb_dev->descriptor.idVendor),
-			le16_to_cpu(us->pusb_dev->descriptor.idProduct),
-			le16_to_cpu(us->pusb_dev->descriptor.bcdDevice));
-	US_DEBUGP("Interface Subclass: 0x%02x, Protocol: 0x%02x\n",
-			intf->cur_altsetting->desc.bInterfaceSubClass,
-			intf->cur_altsetting->desc.bInterfaceProtocol);
+	usb_stor_dbg(us, "Vendor: 0x%04x, Product: 0x%04x, Revision: 0x%04x\n",
+		     le16_to_cpu(us->pusb_dev->descriptor.idVendor),
+		     le16_to_cpu(us->pusb_dev->descriptor.idProduct),
+		     le16_to_cpu(us->pusb_dev->descriptor.bcdDevice));
+	usb_stor_dbg(us, "Interface Subclass: 0x%02x, Protocol: 0x%02x\n",
+		     intf->cur_altsetting->desc.bInterfaceSubClass,
+		     intf->cur_altsetting->desc.bInterfaceProtocol);
 
 	/* Store our private data in the interface */
 	usb_set_intfdata(intf, us);
 
 	/* Allocate the control/setup and DMA-mapped buffers */
 	us->cr = kmalloc(sizeof(*us->cr), GFP_KERNEL);
-	if (!us->cr) {
-		US_DEBUGP("usb_ctrlrequest allocation failed\n");
+	if (!us->cr)
 		return -ENOMEM;
-	}
 
 	us->iobuf = usb_alloc_coherent(us->pusb_dev, US_IOBUF_SIZE,
 			GFP_KERNEL, &us->iobuf_dma);
 	if (!us->iobuf) {
-		US_DEBUGP("I/O buffer allocation failed\n");
+		usb_stor_dbg(us, "I/O buffer allocation failed\n");
 		return -ENOMEM;
 	}
 	return 0;
@@ -738,7 +726,7 @@ static int get_pipes(struct us_data *us)
 	}
 
 	if (!ep_in || !ep_out || (us->protocol == USB_PR_CBI && !ep_int)) {
-		US_DEBUGP("Endpoint sanity check failed! Rejecting dev.\n");
+		usb_stor_dbg(us, "Endpoint sanity check failed! Rejecting dev.\n");
 		return -EIO;
 	}
 
@@ -765,7 +753,7 @@ static int usb_stor_acquire_resources(struct us_data *us)
 
 	us->current_urb = usb_alloc_urb(0, GFP_KERNEL);
 	if (!us->current_urb) {
-		US_DEBUGP("URB allocation failed\n");
+		usb_stor_dbg(us, "URB allocation failed\n");
 		return -ENOMEM;
 	}
 
@@ -792,20 +780,18 @@ static int usb_stor_acquire_resources(struct us_data *us)
 /* Release all our dynamic resources */
 static void usb_stor_release_resources(struct us_data *us)
 {
-	US_DEBUGP("-- %s\n", __func__);
-
 	/* Tell the control thread to exit.  The SCSI host must
 	 * already have been removed and the DISCONNECTING flag set
 	 * so that we won't accept any more commands.
 	 */
-	US_DEBUGP("-- sending exit command to thread\n");
+	usb_stor_dbg(us, "-- sending exit command to thread\n");
 	complete(&us->cmnd_ready);
 	if (us->ctl_thread)
 		kthread_stop(us->ctl_thread);
 
 	/* Call the destructor routine, if it exists */
 	if (us->extra_destructor) {
-		US_DEBUGP("-- calling extra_destructor()\n");
+		usb_stor_dbg(us, "-- calling extra_destructor()\n");
 		us->extra_destructor(us->extra);
 	}
 
@@ -817,8 +803,6 @@ static void usb_stor_release_resources(struct us_data *us)
 /* Dissociate from the USB device */
 static void dissociate_dev(struct us_data *us)
 {
-	US_DEBUGP("-- %s\n", __func__);
-
 	/* Free the buffers */
 	kfree(us->cr);
 	usb_free_coherent(us->pusb_dev, US_IOBUF_SIZE, us->iobuf, us->iobuf_dma);
@@ -918,7 +902,7 @@ int usb_stor_probe1(struct us_data **pus,
 	struct us_data *us;
 	int result;
 
-	US_DEBUGP("USB Mass Storage device detected\n");
+	dev_info(&intf->dev, "USB Mass Storage device detected\n");
 
 	/*
 	 * Ask the SCSI layer to allocate a host structure, with extra
@@ -926,8 +910,7 @@ int usb_stor_probe1(struct us_data **pus,
 	 */
 	host = scsi_host_alloc(&usb_stor_host_template, sizeof(*us));
 	if (!host) {
-		dev_warn(&intf->dev,
-				"Unable to allocate the scsi host\n");
+		dev_warn(&intf->dev, "Unable to allocate the scsi host\n");
 		return -ENOMEM;
 	}
 
@@ -964,7 +947,7 @@ int usb_stor_probe1(struct us_data **pus,
 	return 0;
 
 BadDevice:
-	US_DEBUGP("storage_probe() failed\n");
+	usb_stor_dbg(us, "storage_probe() failed\n");
 	release_everything(us);
 	return result;
 }
@@ -981,8 +964,8 @@ int usb_stor_probe2(struct us_data *us)
 		result = -ENXIO;
 		goto BadDevice;
 	}
-	US_DEBUGP("Transport: %s\n", us->transport_name);
-	US_DEBUGP("Protocol: %s\n", us->protocol_name);
+	usb_stor_dbg(us, "Transport: %s\n", us->transport_name);
+	usb_stor_dbg(us, "Protocol: %s\n", us->protocol_name);
 
 	/* fix for single-lun devices */
 	if (us->fflags & US_FL_SINGLE_LUN)
@@ -1028,7 +1011,7 @@ int usb_stor_probe2(struct us_data *us)
 
 	/* We come here if there are any problems */
 BadDevice:
-	US_DEBUGP("storage_probe() failed\n");
+	usb_stor_dbg(us, "storage_probe() failed\n");
 	release_everything(us);
 	return result;
 }
@@ -1039,7 +1022,6 @@ void usb_stor_disconnect(struct usb_interface *intf)
 {
 	struct us_data *us = usb_get_intfdata(intf);
 
-	US_DEBUGP("storage_disconnect() called\n");
 	quiesce_and_remove_host(us);
 	release_everything(us);
 }
@@ -1075,8 +1057,7 @@ static int storage_probe(struct usb_interface *intf,
 	} else {
 		unusual_dev = &for_dynamic_ids;
 
-		US_DEBUGP("%s %s 0x%04x 0x%04x\n", "Use Bulk-Only transport",
-			"with the Transparent SCSI protocol for dynamic id:",
+		dev_dbg(&intf->dev, "Use Bulk-Only transport with the Transparent SCSI protocol for dynamic id: 0x%04x 0x%04x\n",
 			id->idVendor, id->idProduct);
 	}
 
@@ -1117,20 +1098,18 @@ static int __init usb_stor_init(void)
 	/* register the driver, return usb_register return code if error */
 	retval = usb_register(&usb_storage_driver);
 	if (retval == 0)
-		pr_info("USB Mass Storage support registered.\n");
+		pr_info("USB Mass Storage support registered\n");
 	return retval;
 }
 
 static void __exit usb_stor_exit(void)
 {
-	US_DEBUGP("usb_stor_exit() called\n");
-
 	/* Deregister the driver
 	 * This will cause disconnect() to be called for each
 	 * attached unit
 	 */
-	US_DEBUGP("-- calling usb_deregister()\n");
-	usb_deregister(&usb_storage_driver) ;
+	pr_info("Deregistering USB Mass Storage driver...\n");
+	usb_deregister(&usb_storage_driver);
 }
 
 module_init(usb_stor_init);
-- 
1.8.1.2.459.gbcd45b4.dirty



