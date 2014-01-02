Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752064AbaABPLK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 10:11:10 -0500
Received: from mga02.intel.com ([134.134.136.20]:34820 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751136AbaABPLI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 10:11:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,591,1384329600"; 
   d="scan'208,223";a="460735395"
Message-ID: <1388675460.25123.90.camel@sauron.fi.intel.com>
Subject: Re: [PATCH 1/1]  MTD: UBI:  avoid program operation on  NOR flash
 after erasure interrupted
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Qi Wang =?UTF-8?Q?=E7=8E=8B=E8=B5=B7?= "(qiwang)" 
	<qiwang@micron.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>
Date: Thu, 02 Jan 2014 17:11:00 +0200
In-Reply-To: <71CF8D7F32C5C24C9CD1D0E02D52498A770BA389@NTXXIAMBX02.xacn.micron.com>
References: <71CF8D7F32C5C24C9CD1D0E02D52498A770B54B1@NTXXIAMBX02.xacn.micron.com>
	 <71CF8D7F32C5C24C9CD1D0E02D52498A770B68A8@NTXXIAMBX02.xacn.micron.com>
	 <71CF8D7F32C5C24C9CD1D0E02D52498A770B6F77@NTXXIAMBX02.xacn.micron.com>
	 <71CF8D7F32C5C24C9CD1D0E02D52498A770B79C8@NTXXIAMBX02.xacn.micron.com>
	 <71CF8D7F32C5C24C9CD1D0E02D52498A770B8611@NTXXIAMBX02.xacn.micron.com>
	  <71CF8D7F32C5C24C9CD1D0E02D52498A770BA389@NTXXIAMBX02.xacn.micron.com>
Content-Type: multipart/mixed; boundary="=-NTpQnfZz3sOJQqZP5qVc"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-NTpQnfZz3sOJQqZP5qVc
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit

On Wed, 2014-01-01 at 13:06 +0000, Qi Wang 王起 (qiwang) wrote:
> Hi Artem:
> As we talked in mail before, please check my patch as below:

Note, because you wrote the above

> From: Qi Wang <qiwang@micron.com>

"git am" will put all the above to the commit message. If you want to
change your "From:", it should be in the first line.

Few other things.

1. If I save your e-mail as "qi.mbox" and then use "git am", I get this:

$ git am ~/tmp/qi.mbox
Applying: MTD: UBI: avoid program operation on NOR flash after erasure interrupted
/home/dedekind/git/linux-ubifs/.git/rebase-apply/patch:18: trailing whitespace.
         * If VID or EC is valid, need to corrupt it before erase operation.  
/home/dedekind/git/linux-ubifs/.git/rebase-apply/patch:63: space before tab in indent.
                addr += ubi->vid_hdr_aloffset;
/home/dedekind/git/linux-ubifs/.git/rebase-apply/patch:66: trailing whitespace.
                        goto error;
warning: 3 lines add whitespace errors.

Note, I have this in my ~/.gitconfig to notice things like that:

[core]
        whitespace = trailing-space,space-before-tab


> diff --git a/drivers/mtd/ubi/io.c b/drivers/mtd/ubi/io.c

...

> -	 * The PEB contains a valid VID header, but we cannot invalidate it.
> +	 * The PEB contains a valid VID or EC header, but we cannot invalidate it.

82 characters :-)

> -	ubi_err("cannot invalidate PEB %d, write returned %d read returned %d",
> +	ubi_err("cannot invalidate PEB %d, read returned %d write returned %d",

Why? The error actually happened in mtd_write. No read errors lead to
this path.

>  		pnum, err, err1);

I guess it is better to kill the err1 variable and use just 'err'
everywhere.

Anyway, I did not respond for long time, so I decided to do all these
modifications myself. Could you please review and test the below patch,
which is also attached. I did not compile it even. If there are issues,
just fix-it up and send the the fix or the fixed version. If it is OK,
give me your "Tested-by:" please. Thanks!


From: =?UTF-8?q?Qi=20Wang=20=E7=8E=8B=E8=B5=B7=20=28qiwang=29?=
 <qiwang@micron.com>
Date: Wed, 1 Jan 2014 13:06:11 +0000
Subject: [PATCH] MTD: UBI: avoid program operation on NOR flash after erasure
 interrupted
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

nor_erase_prepare() will be called before erase a NOR flash, it will program '0'
into a block to mark this block. But program data into a erasure interrupted block
can cause program timtout(several minutes at most) error, could impact other
operation on NOR flash. So UBIFS can read this block first to avoid unneeded
program operation.

This patch try to put read operation at head of write operation in
nor_erase_prepare(), read out the data.
If the data is already corrupt, then no need to program any data into this block,
just go to erase this block.

This patch is validated on Micron NOR flash, part number is：JS28F512M29EWHA

Signed-off-by: Qi Wang <qiwang@micron.com>
---
 drivers/mtd/ubi/io.c | 55 ++++++++++++++++++++++------------------------------
 1 file changed, 23 insertions(+), 32 deletions(-)

diff --git a/drivers/mtd/ubi/io.c b/drivers/mtd/ubi/io.c
index bf79def..ae9e5ca 100644
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
@@ -509,50 +511,39 @@ static int nor_erase_prepare(struct ubi_device *ubi, int pnum)
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
+	ubi_err("cannot invalidate PEB %d, write returned %d write returned %d",
+		pnum, err, err);
 	ubi_dump_flash(ubi, pnum, 0, ubi->peb_size);
 	return -EIO;
 }
-- 
1.8.5.2

-- 
Best Regards,
Artem Bityutskiy

--=-NTpQnfZz3sOJQqZP5qVc
Content-Disposition: attachment;
	filename*0=0001-MTD-UBI-avoid-program-operation-on-NOR-flash-after-e.pat;
	filename*1=ch
Content-Type: text/x-patch;
	name="0001-MTD-UBI-avoid-program-operation-on-NOR-flash-after-e.patch";
	charset="UTF-8"
Content-Transfer-Encoding: 8bit

>From 56b63ee94a82f0d813a0997fa7545b4e9ce94456 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Qi=20Wang=20=E7=8E=8B=E8=B5=B7=20=28qiwang=29?=
 <qiwang@micron.com>
Date: Wed, 1 Jan 2014 13:06:11 +0000
Subject: [PATCH] MTD: UBI: avoid program operation on NOR flash after erasure
 interrupted
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

nor_erase_prepare() will be called before erase a NOR flash, it will program '0'
into a block to mark this block. But program data into a erasure interrupted block
can cause program timtout(several minutes at most) error, could impact other
operation on NOR flash. So UBIFS can read this block first to avoid unneeded
program operation.

This patch try to put read operation at head of write operation in
nor_erase_prepare(), read out the data.
If the data is already corrupt, then no need to program any data into this block,
just go to erase this block.

This patch is validated on Micron NOR flash, part number is：JS28F512M29EWHA

Signed-off-by: Qi Wang <qiwang@micron.com>
---
 drivers/mtd/ubi/io.c | 55 ++++++++++++++++++++++------------------------------
 1 file changed, 23 insertions(+), 32 deletions(-)

diff --git a/drivers/mtd/ubi/io.c b/drivers/mtd/ubi/io.c
index bf79def..ae9e5ca 100644
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
@@ -509,50 +511,39 @@ static int nor_erase_prepare(struct ubi_device *ubi, int pnum)
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
+	ubi_err("cannot invalidate PEB %d, write returned %d write returned %d",
+		pnum, err, err);
 	ubi_dump_flash(ubi, pnum, 0, ubi->peb_size);
 	return -EIO;
 }
-- 
1.8.5.2


--=-NTpQnfZz3sOJQqZP5qVc--

