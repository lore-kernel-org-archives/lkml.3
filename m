Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535Ab3LCDFf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 22:05:35 -0500
Received: from mailout.micron.com ([137.201.242.129]:63693 "EHLO
	mailout.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751025Ab3LCDFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 22:05:34 -0500
From: =?gb2312?B?UWkgV2FuZyDN9cbwIChxaXdhbmcp?= <qiwang@micron.com>
To: "dedekind1@gmail.com" <dedekind1@gmail.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>
CC: Adrian Hunter <adrian.hunter@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?gb2312?B?UWkgV2FuZyDN9cbwIChxaXdhbmcp?= <qiwang@micron.com>
Subject: [PATCH 1/1]  MTD: UBI:  avoid program operation on  NOR flash after
 erasure interrupted
Thread-Topic: [PATCH 1/1]  MTD: UBI:  avoid program operation on  NOR flash
 after erasure interrupted
Thread-Index: Ac7bkfL3+Un6Pi2jSbO3yZA9UtDETwNhLovgAa9rO+A=
Date: Tue, 3 Dec 2013 03:05:04 +0000
Message-ID: <71CF8D7F32C5C24C9CD1D0E02D52498A770B68A8@NTXXIAMBX02.xacn.micron.com>
References: <71CF8D7F32C5C24C9CD1D0E02D52498A770B54B1@NTXXIAMBX02.xacn.micron.com>
In-Reply-To: <71CF8D7F32C5C24C9CD1D0E02D52498A770B54B1@NTXXIAMBX02.xacn.micron.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.167.84.5]
X-TM-AS-Product-Ver: SMEX-10.0.0.4152-7.000.1014-20334.004
X-TM-AS-Result: No--23.620100-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
x-mt-checkinternalsenderrule: True
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rB335f5E021243

Hi Artem:
As we talked in mail before, please check my patch as below:

From: Qi Wang <qiwang@micron.com>

nor_erase_prepare() will be called before erase a NOR flash, it will program '0'
into a block to mark this block. But program data into a erasure interrupted block
can cause program timtout(several minutes at most) error, could impact other 
operation on NOR flash. So UBIFS can read this block first to avoid unneeded 
program operation. 

This patch try to put read operation at head of write operation in 
nor_erase_prepare(), read out the data. 
If the data is already corrupt, then no need to program any data into this block, 
just go to erase this block.

Signed-off-by: Qi Wang <qiwang@qiwang@micron.com>
---
diff --git a/drivers/mtd/ubi/io.c b/drivers/mtd/ubi/io.c
index bf79def..0a6343d 100644
--- a/drivers/mtd/ubi/io.c
+++ b/drivers/mtd/ubi/io.c
@@ -499,6 +499,7 @@ static int nor_erase_prepare(struct ubi_device *ubi, int pnum)
 	size_t written;
 	loff_t addr;
 	uint32_t data = 0;
+	struct ubi_ec_hdr ec_hdr;
 	/*
 	 * Note, we cannot generally define VID header buffers on stack,
 	 * because of the way we deal with these buffers (see the header
@@ -509,49 +510,38 @@ static int nor_erase_prepare(struct ubi_device *ubi, int pnum)
 	struct ubi_vid_hdr vid_hdr;
 
 	/*
+	 * If VID or EC is valid, need to corrupt it before erase operation.  
 	 * It is important to first invalidate the EC header, and then the VID
 	 * header. Otherwise a power cut may lead to valid EC header and
 	 * invalid VID header, in which case UBI will treat this PEB as
 	 * corrupted and will try to preserve it, and print scary warnings.
 	 */
 	addr = (loff_t)pnum * ubi->peb_size;
-	err = mtd_write(ubi->mtd, addr, 4, &written, (void *)&data);
-	if (!err) {
-		addr += ubi->vid_hdr_aloffset;
-		err = mtd_write(ubi->mtd, addr, 4, &written, (void *)&data);
-		if (!err)
-			return 0;
+	err = ubi_io_read_ec_hdr(ubi, pnum, &ec_hdr, 0);
+	if (err != UBI_IO_BAD_HDR_EBADMSG && err != UBI_IO_BAD_HDR &&
+	    err != UBI_IO_FF){
+		err1 = mtd_write(ubi->mtd, addr, 4, &written, (void *)&data);
+		if(err1)
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
+	    	addr += ubi->vid_hdr_aloffset;
+		err1 = mtd_write(ubi->mtd, addr, 4, &written, (void *)&data);
+		if (err1)
+			goto error;	
 	}
+	return 0;
 
+error:
 	/*
-	 * The PEB contains a valid VID header, but we cannot invalidate it.
+	 * The PEB contains a valid VID or EC header, but we cannot invalidate it.
 	 * Supposedly the flash media or the driver is screwed up, so return an
 	 * error.
 	 */
-	ubi_err("cannot invalidate PEB %d, write returned %d read returned %d",
+	ubi_err("cannot invalidate PEB %d, read returned %d write returned %d",
 		pnum, err, err1);
 	ubi_dump_flash(ubi, pnum, 0, ubi->peb_size);
 	return -EIO;
---

I have tested this patch on Micron NOR flash, part number is£ºJS28F512M29EWHA.
If have any questions, please let me know. 
Thank you

Best Regards, 
Qi Wang ÍõÆğ
ESG APAC AE 
Tel: 86-021-38997158
Mobile: 86-15201958202
Email: qiwang@micron.com
Address: No 601 Fasai Rd, Pudong, Shanghai, China, 200131
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
