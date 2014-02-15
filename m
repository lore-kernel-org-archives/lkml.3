Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753279AbaBONxZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 08:53:25 -0500
Received: from mout.gmx.net ([212.227.15.18]:53481 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753087AbaBONxY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 08:53:24 -0500
From: =?UTF-8?q?Reimar=20D=C3=B6ffinger?= <Reimar.Doeffinger@gmx.de>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] cdrom.c: Only read a cdrom_msf0 struct from userspace.
Date: Sat, 15 Feb 2014 14:53:11 +0100
Message-Id: <1392472391-22429-1-git-send-email-Reimar.Doeffinger@gmx.de>
X-Mailer: git-send-email 1.9.0.rc3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K0:PEo83BSz7fcWVCiPpiJD+FhLd7QPBBjsnleV8+LFXA2ToLJubuA
 4tYFWtEejqnbd7jT/YvGBBgfFXTnccRrX44haJ0FdVpMnHg1lLrqfzSDxuQUstbnGjmh8Zu
 7FPIfSJCLmV3+kUotLa8LQPn/6LTCfl/hagl/SOhLK43N0E3rdzxSOJCcLrCL3SXBs4fbbv
 7yHaarwWv7sv0Br2GOCvw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

That is all that is actually used, reading more just
makes the code confusing.
In addition also fix the header and separate documentation
to correctly indicate which struct is expected as input.

Maybe these inconsistencies were on purpose at some point
with the intention to improve the IOCTL interface, but
the code has now been unchanged for years and changing
it would break e.g. MPlayer which fills the second half
of the cdrom_msf struck with garbage, so I believe
that at this point it is best commit to current behaviour
and make the whole documentation less confusing.

Signed-off-by: Reimar Döffinger <Reimar.Doeffinger@gmx.de>
---
 Documentation/ioctl/cdrom.txt | 20 +++++++-------------
 drivers/cdrom/cdrom.c         |  6 +++---
 include/uapi/linux/cdrom.h    |  6 +++---
 3 files changed, 13 insertions(+), 19 deletions(-)

diff --git a/Documentation/ioctl/cdrom.txt b/Documentation/ioctl/cdrom.txt
index 59df81c..e2e8400 100644
--- a/Documentation/ioctl/cdrom.txt
+++ b/Documentation/ioctl/cdrom.txt
@@ -24,9 +24,9 @@ are as follows:
 	CDROMVOLCTRL		Control output volume (struct cdrom_volctrl)
 	CDROMSUBCHNL		Read subchannel data (struct cdrom_subchnl)
 	CDROMREADMODE2		Read CDROM mode 2 data (2336 Bytes)
-					   (struct cdrom_read)
+					   (struct cdrom_msf0)
 	CDROMREADMODE1		Read CDROM mode 1 data (2048 Bytes)
-					   (struct cdrom_read)
+					   (struct cdrom_msf0)
 	CDROMREADAUDIO		(struct cdrom_read_audio)
 	CDROMEJECT_SW		enable(1)/disable(0) auto-ejecting
 	CDROMMULTISESSION	Obtain the start-of-last-session
@@ -39,7 +39,7 @@ are as follows:
 	CDROMVOLREAD		Get the drive's volume setting
 					  (struct cdrom_volctrl)
 	CDROMREADRAW		read data in raw mode (2352 Bytes)
-					   (struct cdrom_read)
+					   (struct cdrom_msf0)
 	CDROMREADCOOKED		read data in cooked mode
 	CDROMSEEK		seek msf address
 	CDROMPLAYBLK		scsi-cd only, (struct cdrom_blk)
@@ -345,7 +345,7 @@ CDROMSUBCHNL			Read subchannel data (struct cdrom_subchnl)
 
 
 CDROMREADRAW			read data in raw mode (2352 Bytes)
-					   (struct cdrom_read)
+					   (struct cdrom_msf0)
 
 	usage:
 
@@ -356,8 +356,7 @@ CDROMREADRAW			read data in raw mode (2352 Bytes)
 	  ioctl(fd, CDROMREADRAW, &arg);
 
 	inputs:
-	  cdrom_msf structure indicating an address to read.
-	  Only the start values are significant.
+	  cdrom_msf0 structure indicating an address to read.
 
 	outputs:
 	  Data written to address provided by user.
@@ -367,11 +366,6 @@ CDROMREADRAW			read data in raw mode (2352 Bytes)
 	  ENOMEM	out of memory
 
 	notes:
-	  As of 2.6.8.1, comments in <linux/cdrom.h> indicate that this
-	  ioctl accepts a cdrom_read structure, but actual source code
-	  reads a cdrom_msf structure and writes a buffer of data to
-	  the same address.
-
 	  MSF values are converted to LBA values via this formula:
 
 	    lba = (((m * CD_SECS) + s) * CD_FRAMES + f) - CD_MSF_OFFSET;
@@ -380,7 +374,7 @@ CDROMREADRAW			read data in raw mode (2352 Bytes)
 
 
 CDROMREADMODE1			Read CDROM mode 1 data (2048 Bytes)
-					   (struct cdrom_read)
+					   (struct cdrom_msf0)
 
 	notes:
 	  Identical to CDROMREADRAW except that block size is
@@ -389,7 +383,7 @@ CDROMREADMODE1			Read CDROM mode 1 data (2048 Bytes)
 
 
 CDROMREADMODE2			Read CDROM mode 2 data (2336 Bytes)
-					   (struct cdrom_read)
+					   (struct cdrom_msf0)
 
 	notes:
 	  Identical to CDROMREADRAW except that block size is
diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
index 8a3aff7..dab0752 100644
--- a/drivers/cdrom/cdrom.c
+++ b/drivers/cdrom/cdrom.c
@@ -2860,7 +2860,7 @@ static noinline int mmc_ioctl_cdrom_read_data(struct cdrom_device_info *cdi,
 					int cmd)
 {
 	struct request_sense sense;
-	struct cdrom_msf msf;
+	struct cdrom_msf0 msf;
 	int blocksize = 0, format = 0, lba;
 	int ret;
 
@@ -2876,8 +2876,8 @@ static noinline int mmc_ioctl_cdrom_read_data(struct cdrom_device_info *cdi,
 		blocksize = CD_FRAMESIZE_RAW0;
 		break;
 	}
-	IOCTL_IN(arg, struct cdrom_msf, msf);
-	lba = msf_to_lba(msf.cdmsf_min0, msf.cdmsf_sec0, msf.cdmsf_frame0);
+	IOCTL_IN(arg, struct cdrom_msf0, msf);
+	lba = msf_to_lba(msf.minute, msf.second, msf.frame);
 	/* FIXME: we need upper bound checking, too!! */
 	if (lba < 0)
 		return -EINVAL;
diff --git a/include/uapi/linux/cdrom.h b/include/uapi/linux/cdrom.h
index bd17ad5..1795488 100644
--- a/include/uapi/linux/cdrom.h
+++ b/include/uapi/linux/cdrom.h
@@ -67,9 +67,9 @@
 #define CDROMSUBCHNL		0x530b /* Read subchannel data 
                                            (struct cdrom_subchnl) */
 #define CDROMREADMODE2		0x530c /* Read CDROM mode 2 data (2336 Bytes) 
-                                           (struct cdrom_read) */
+                                           (struct cdrom_msf0) */
 #define CDROMREADMODE1		0x530d /* Read CDROM mode 1 data (2048 Bytes)
-                                           (struct cdrom_read) */
+                                           (struct cdrom_msf0) */
 #define CDROMREADAUDIO		0x530e /* (struct cdrom_read_audio) */
 #define CDROMEJECT_SW		0x530f /* enable(1)/disable(0) auto-ejecting */
 #define CDROMMULTISESSION	0x5310 /* Obtain the start-of-last-session 
@@ -83,7 +83,7 @@
 #define CDROMVOLREAD		0x5313 /* Get the drive's volume setting 
                                           (struct cdrom_volctrl) */
 #define CDROMREADRAW		0x5314	/* read data in raw mode (2352 Bytes)
-                                           (struct cdrom_read) */
+                                           (struct cdrom_msf0) */
 /* 
  * These ioctls are used only used in aztcd.c and optcd.c
  */
-- 
1.9.0.rc3

