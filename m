Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751457AbaAFFR0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 00:17:26 -0500
Received: from mailout.micron.com ([137.201.242.129]:64269 "EHLO
	mailout.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857AbaAFFRZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 00:17:25 -0500
From: =?utf-8?B?UWkgV2FuZyDnjovotbcgKHFpd2FuZyk=?= <qiwang@micron.com>
To: "dedekind1@gmail.com" <dedekind1@gmail.com>
CC: Adrian Hunter <adrian.hunter@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>
Subject: RE: [PATCH 1/1]  MTD: UBI:  avoid program operation on  NOR flash
 after erasure interrupted
Thread-Topic: [PATCH 1/1]  MTD: UBI:  avoid program operation on  NOR flash
 after erasure interrupted
Thread-Index: AQHPBvI9R7Ql4kYjCUG7syxWj0KNGppxBa8AgAADUQCAAT0XoP//tW6AgAUyDaA=
Date: Mon, 6 Jan 2014 05:16:58 +0000
Message-ID: <71CF8D7F32C5C24C9CD1D0E02D52498A770C4C43@NTXXIAMBX02.xacn.micron.com>
References: <71CF8D7F32C5C24C9CD1D0E02D52498A770B54B1@NTXXIAMBX02.xacn.micron.com>
	 <71CF8D7F32C5C24C9CD1D0E02D52498A770B68A8@NTXXIAMBX02.xacn.micron.com>
	 <71CF8D7F32C5C24C9CD1D0E02D52498A770B6F77@NTXXIAMBX02.xacn.micron.com>
	 <71CF8D7F32C5C24C9CD1D0E02D52498A770B79C8@NTXXIAMBX02.xacn.micron.com>
	 <71CF8D7F32C5C24C9CD1D0E02D52498A770B8611@NTXXIAMBX02.xacn.micron.com>
	 <71CF8D7F32C5C24C9CD1D0E02D52498A770BA389@NTXXIAMBX02.xacn.micron.com>
	 <1388675460.25123.90.camel@sauron.fi.intel.com>
	 <1388676172.25123.93.camel@sauron.fi.intel.com>
	 <71CF8D7F32C5C24C9CD1D0E02D52498A770BA889@NTXXIAMBX02.xacn.micron.com>
 <1388728253.25123.98.camel@sauron.fi.intel.com>
In-Reply-To: <1388728253.25123.98.camel@sauron.fi.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.167.84.5]
X-TM-AS-Product-Ver: SMEX-10.0.0.4152-7.000.1014-20410.004
X-TM-AS-Result: No--15.826800-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
x-mt-checkinternalsenderrule: True
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s065HvRP030559

From: Qi Wang <qiwang@micron.com>

nor_erase_prepare() will be called before erase a NOR flash, it will program '0'
into a block to mark this block. But program data into a erasure interrupted block can cause program timtout(several minutes at most) error, could impact other operation on NOR flash. So UBIFS can read this block first to avoid unneeded program operation. 

This patch try to put read operation at head of write operation in nor_erase_prepare(), read out the data. 
If the data is already corrupt, then no need to program any data into this block, just go to erase this block.

This patch is validated on Micron NOR flash, part number isï¼šJS28F512M29EWHA

Signed-off-by: Qi Wang <qiwang@micron.com>
---
diff --git a/drivers/mtd/ubi/io.c b/drivers/mtd/ubi/io.c
index bf79def..d361349 100644
--- a/drivers/mtd/ubi/io.c
+++ b/drivers/mtd/ubi/io.c
@@ -495,10 +495,12 @@ out:
  */
 static int nor_erase_prepare(struct ubi_device *ubi, int pnum)
 {
-	int err, err1;
+	int err;
 	size_t written;
 	loff_t addr;
 	uint32_t data = 0;
+	struct ubi_ec_hdr ec_hdr;
+
 	/*
 	 * Note, we cannot generally define VID header buffers on stack,
 	 * because of the way we deal with these buffers (see the header
@@ -509,50 +511,38 @@ static int nor_erase_prepare(struct ubi_device *ubi, int pnum)
 	struct ubi_vid_hdr vid_hdr;
 
 	/*
+	 * If VID or EC is valid, we have to corrupt them before erasing.
 	 * It is important to first invalidate the EC header, and then the VID
 	 * header. Otherwise a power cut may lead to valid EC header and
 	 * invalid VID header, in which case UBI will treat this PEB as
 	 * corrupted and will try to preserve it, and print scary warnings.
 	 */
 	addr = (loff_t)pnum * ubi->peb_size;
-	err = mtd_write(ubi->mtd, addr, 4, &written, (void *)&data);
-	if (!err) {
-		addr += ubi->vid_hdr_aloffset;
+	err = ubi_io_read_ec_hdr(ubi, pnum, &ec_hdr, 0);
+	if (err != UBI_IO_BAD_HDR_EBADMSG && err != UBI_IO_BAD_HDR &&
+	    err != UBI_IO_FF){
 		err = mtd_write(ubi->mtd, addr, 4, &written, (void *)&data);
-		if (!err)
-			return 0;
+		if(err)
+			goto error;
 	}
 
-	/*
-	 * We failed to write to the media. This was observed with Spansion
-	 * S29GL512N NOR flash. Most probably the previously eraseblock erasure
-	 * was interrupted at a very inappropriate moment, so it became
-	 * unwritable. In this case we probably anyway have garbage in this
-	 * PEB.
-	 */
-	err1 = ubi_io_read_vid_hdr(ubi, pnum, &vid_hdr, 0);
-	if (err1 == UBI_IO_BAD_HDR_EBADMSG || err1 == UBI_IO_BAD_HDR ||
-	    err1 == UBI_IO_FF) {
-		struct ubi_ec_hdr ec_hdr;
-
-		err1 = ubi_io_read_ec_hdr(ubi, pnum, &ec_hdr, 0);
-		if (err1 == UBI_IO_BAD_HDR_EBADMSG || err1 == UBI_IO_BAD_HDR ||
-		    err1 == UBI_IO_FF)
-			/*
-			 * Both VID and EC headers are corrupted, so we can
-			 * safely erase this PEB and not afraid that it will be
-			 * treated as a valid PEB in case of an unclean reboot.
-			 */
-			return 0;
+	err = ubi_io_read_vid_hdr(ubi, pnum, &vid_hdr, 0);
+	if (err != UBI_IO_BAD_HDR_EBADMSG && err != UBI_IO_BAD_HDR &&
+	    err != UBI_IO_FF){
+		addr += ubi->vid_hdr_aloffset;
+		err = mtd_write(ubi->mtd, addr, 4, &written, (void *)&data);
+		if (err)
+			goto error;
 	}
+	return 0;
 
+error:
 	/*
-	 * The PEB contains a valid VID header, but we cannot invalidate it.
-	 * Supposedly the flash media or the driver is screwed up, so return an
-	 * error.
+	 * The PEB contains a valid VID or EC header, but we cannot invalidate
+	 * it. Supposedly the flash media or the driver is screwed up, so
+	 * return an error.
 	 */
-	ubi_err("cannot invalidate PEB %d, write returned %d read returned %d",
-		pnum, err, err1);
+	ubi_err("cannot invalidate PEB %d, write returned %d", pnum, err);
 	ubi_dump_flash(ubi, pnum, 0, ubi->peb_size);
 	return -EIO;
 }
---

Compare to your patch, the change is only below:
modify from  
+	ubi_err("cannot invalidate PEB %d, write returned %d write returned %d",
+		pnum, err, err);

to 

+	ubi_err("cannot invalidate PEB %d, write returned %d", pnum, err);
Thanks

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
