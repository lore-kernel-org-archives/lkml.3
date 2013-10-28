Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751912Ab3J1Etq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 00:49:46 -0400
Received: from mailout.micron.com ([137.201.242.129]:18749 "EHLO
	mailout.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215Ab3J1Eto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 00:49:44 -0400
From: =?utf-8?B?UWkgV2FuZyDnjovotbcgKHFpd2FuZyk=?= <qiwang@micron.com>
To: "dedekind1@gmail.com" <dedekind1@gmail.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>
CC: Adrian Hunter <adrian.hunter@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/1]  MTD: UBI:  try to avoid program data to NOR flash
 after erasure interrupted
Thread-Topic: [PATCH 1/1]  MTD: UBI:  try to avoid program data to NOR flash
 after erasure interrupted
Thread-Index: AQHO05kLWh2mNyOrgEeulMSy5KNfAA==
Date: Mon, 28 Oct 2013 04:49:11 +0000
Message-ID: <71CF8D7F32C5C24C9CD1D0E02D52498A770B1B87@NTXXIAMBX02.xacn.micron.com>
References: <71CF8D7F32C5C24C9CD1D0E02D52498A77082AC5@NTXXIAMBX02.xacn.micron.com>
	 <71CF8D7F32C5C24C9CD1D0E02D52498A77082DDB@NTXXIAMBX02.xacn.micron.com>
	 <71CF8D7F32C5C24C9CD1D0E02D52498A770AED11@NTXXIAMBX02.xacn.micron.com>
	 <71CF8D7F32C5C24C9CD1D0E02D52498A770AED44@NTXXIAMBX02.xacn.micron.com>
	 <71CF8D7F32C5C24C9CD1D0E02D52498A770AED67@NTXXIAMBX02.xacn.micron.com>
 <1382779164.5901.1.camel@karhu.quadriga.com>
In-Reply-To: <1382779164.5901.1.camel@karhu.quadriga.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.167.84.5]
X-TM-AS-Product-Ver: SMEX-10.0.0.4152-7.000.1014-20252.004
X-TM-AS-Result: No--18.237900-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
x-mt-checkinternalsenderrule: True
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r9S4oDiu002319

On Sa, 2013-10-26 at 05:19 +0000, Artem Bityutskiy wrote:
>On Thu, 2013-10-10 at 08:28 +0000, Qi Wang ç‹èµ· (qiwang) wrote:
>> But I want to say the potential risk is if low level driver program data to 
>> this block, it will get â€œtimeout errorâ€. And the timeout period could be very 
>> long(almost several minutes), during this period, any operation on NOR flash 
>> cannot be accept. so program data to a erasure interrupted block isnâ€™t a 
>> sensible action. in order to avoid program a erasure interrupted block, 
>> I suggest UBIFS can read this block before program data. the code changing as below:
>
>Yes, reading first sounds like a good idea. Would you please send a
>patch implementing it?

From: Qi Wang <qiwang@micron.com>

nor_erase_prepare() will be called before erase a NOR flash, it will program '0'
into a block to mark this block. But program data into a erasure interrupted block
can cause program timtout(several minutes at most) error, could impact other 
operation on NOR flash. So UBIFS can read this block first to avoid unneeded 
program operation. 

This patch try to put read operation at at head of write operation in 
nor_erase_prepare(), read out the data. 
If the data is already corrupt, then no need to program any data into this block, 
just go to erase this block.

Signed-off-by: Qi Wang <qiwang@qiwang@micron.com>
---
diff --git a/drivers/mtd/ubi/io.c b/drivers/mtd/ubi/io.c
index bf79def..be6ab56 100644
--- a/drivers/mtd/ubi/io.c
+++ b/drivers/mtd/ubi/io.c
@@ -509,26 +509,10 @@ static int nor_erase_prepare(struct ubi_device *ubi, int pnum)
 	struct ubi_vid_hdr vid_hdr;
 
 	/*
-	 * It is important to first invalidate the EC header, and then the VID
-	 * header. Otherwise a power cut may lead to valid EC header and
-	 * invalid VID header, in which case UBI will treat this PEB as
-	 * corrupted and will try to preserve it, and print scary warnings.
-	 */
-	addr = (loff_t)pnum * ubi->peb_size;
-	err = mtd_write(ubi->mtd, addr, 4, &written, (void *)&data);
-	if (!err) {
-		addr += ubi->vid_hdr_aloffset;
-		err = mtd_write(ubi->mtd, addr, 4, &written, (void *)&data);
-		if (!err)
-			return 0;
-	}
-
-	/*
-	 * We failed to write to the media. This was observed with Spansion
-	 * S29GL512N NOR flash. Most probably the previously eraseblock erasure
+	 * Most probably the previously eraseblock erasure
 	 * was interrupted at a very inappropriate moment, so it became
-	 * unwritable. In this case we probably anyway have garbage in this
-	 * PEB.
+	 * unwritable. In order to avoid program data into a unwritable block,
+	 * read this block first, and check if do need to program it.  
 	 */
 	err1 = ubi_io_read_vid_hdr(ubi, pnum, &vid_hdr, 0);
 	if (err1 == UBI_IO_BAD_HDR_EBADMSG || err1 == UBI_IO_BAD_HDR ||
@@ -547,6 +531,22 @@ static int nor_erase_prepare(struct ubi_device *ubi, int pnum)
 	}
 
 	/*
+	 * VID or EC is valid, need to corrupt these header before erase operation.  
+	 * It is important to first invalidate the EC header, and then the VID
+	 * header. Otherwise a power cut may lead to valid EC header and
+	 * invalid VID header, in which case UBI will treat this PEB as
+	 * corrupted and will try to preserve it, and print scary warnings.
+	 */
+	addr = (loff_t)pnum * ubi->peb_size;
+	err = mtd_write(ubi->mtd, addr, 4, &written, (void *)&data);
+	if (!err) {
+		addr += ubi->vid_hdr_aloffset;
+		err = mtd_write(ubi->mtd, addr, 4, &written, (void *)&data);
+		if (!err)
+			return 0;
+	}
+
+	/*
 	 * The PEB contains a valid VID header, but we cannot invalidate it.
 	 * Supposedly the flash media or the driver is screwed up, so return an
 	 * error.
---

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
