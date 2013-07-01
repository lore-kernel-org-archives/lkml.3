Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752538Ab3GABNS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jun 2013 21:13:18 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:33694 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752151Ab3GABNP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jun 2013 21:13:15 -0400
From: Joe Perches <joe@perches.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 08/12] cdrom: Remove cdrom_get_last_written prototype
Date: Sun, 30 Jun 2013 18:12:03 -0700
Message-Id: <dd2357dad9e1b0ee9ae73bb8dffd866e0d45ed2a.1372640818.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1372640818.git.joe@perches.com>
References: <cover.1372640818.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the function instead.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/cdrom/cdrom.c | 193 +++++++++++++++++++++++++-------------------------
 1 file changed, 97 insertions(+), 96 deletions(-)

diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
index 5148547..4fb9ad5 100644
--- a/drivers/cdrom/cdrom.c
+++ b/drivers/cdrom/cdrom.c
@@ -338,7 +338,6 @@ do {							\
 
 /* Not-exported routines. */
 
-int cdrom_get_last_written(struct cdrom_device_info *, long *);
 static int cdrom_get_next_writable(struct cdrom_device_info *, long *);
 static void cdrom_count_tracks(struct cdrom_device_info *, tracktype*);
 
@@ -2740,6 +2739,103 @@ static int cdrom_switch_blocksize(struct cdrom_device_info *cdi, int size)
 	return cdo->generic_packet(cdi, &cgc);
 }
 
+static int cdrom_get_track_info(struct cdrom_device_info *cdi,
+				__u16 track, __u8 type, track_information *ti)
+{
+	struct cdrom_device_ops *cdo = cdi->ops;
+	struct packet_command cgc;
+	int ret, buflen;
+
+	init_cdrom_command(&cgc, ti, 8, CGC_DATA_READ);
+	cgc.cmd[0] = GPCMD_READ_TRACK_RZONE_INFO;
+	cgc.cmd[1] = type & 3;
+	cgc.cmd[4] = (track & 0xff00) >> 8;
+	cgc.cmd[5] = track & 0xff;
+	cgc.cmd[8] = 8;
+	cgc.quiet = 1;
+
+	ret = cdo->generic_packet(cdi, &cgc);
+	if (ret)
+		return ret;
+
+	buflen = be16_to_cpu(ti->track_information_length) +
+		sizeof(ti->track_information_length);
+
+	if (buflen > sizeof(track_information))
+		buflen = sizeof(track_information);
+
+	cgc.cmd[8] = cgc.buflen = buflen;
+	ret = cdo->generic_packet(cdi, &cgc);
+	if (ret)
+		return ret;
+
+	/* return actual fill size */
+	return buflen;
+}
+
+/* return the last written block on the CD-R media. this is for the udf
+   file system. */
+int cdrom_get_last_written(struct cdrom_device_info *cdi, long *last_written)
+{
+	struct cdrom_tocentry toc;
+	disc_information di;
+	track_information ti;
+	__u32 last_track;
+	int ret = -1, ti_size;
+
+	if (!CDROM_CAN(CDC_GENERIC_PACKET))
+		goto use_toc;
+
+	ret = cdrom_get_disc_info(cdi, &di);
+	if (ret < (int)(offsetof(typeof(di), last_track_lsb)
+			+ sizeof(di.last_track_lsb)))
+		goto use_toc;
+
+	/* if unit didn't return msb, it's zeroed by cdrom_get_disc_info */
+	last_track = (di.last_track_msb << 8) | di.last_track_lsb;
+	ti_size = cdrom_get_track_info(cdi, last_track, 1, &ti);
+	if (ti_size < (int)offsetof(typeof(ti), track_start))
+		goto use_toc;
+
+	/* if this track is blank, try the previous. */
+	if (ti.blank) {
+		if (last_track == 1)
+			goto use_toc;
+		last_track--;
+		ti_size = cdrom_get_track_info(cdi, last_track, 1, &ti);
+	}
+
+	if (ti_size < (int)(offsetof(typeof(ti), track_size)
+				+ sizeof(ti.track_size)))
+		goto use_toc;
+
+	/* if last recorded field is valid, return it. */
+	if (ti.lra_v && ti_size >= (int)(offsetof(typeof(ti), last_rec_address)
+				+ sizeof(ti.last_rec_address))) {
+		*last_written = be32_to_cpu(ti.last_rec_address);
+	} else {
+		/* make it up instead */
+		*last_written = be32_to_cpu(ti.track_start) +
+				be32_to_cpu(ti.track_size);
+		if (ti.free_blocks)
+			*last_written -= (be32_to_cpu(ti.free_blocks) + 7);
+	}
+	return 0;
+
+	/* this is where we end up if the drive either can't do a
+	   GPCMD_READ_DISC_INFO or GPCMD_READ_TRACK_RZONE_INFO or if
+	   it doesn't give enough information or fails. then we return
+	   the toc contents. */
+use_toc:
+	toc.cdte_format = CDROM_MSF;
+	toc.cdte_track = CDROM_LEADOUT;
+	if ((ret = cdi->ops->audio_ioctl(cdi, CDROMREADTOCENTRY, &toc)))
+		return ret;
+	sanitize_format(&toc.cdte_addr, &toc.cdte_format, CDROM_LBA);
+	*last_written = toc.cdte_addr.lba;
+	return 0;
+}
+
 static noinline int mmc_ioctl_cdrom_read_data(struct cdrom_device_info *cdi,
 					      void __user *arg,
 					      struct packet_command *cgc,
@@ -3210,38 +3306,6 @@ int cdrom_ioctl(struct cdrom_device_info *cdi, struct block_device *bdev,
 	return -ENOSYS;
 }
 
-static int cdrom_get_track_info(struct cdrom_device_info *cdi, __u16 track, __u8 type,
-			 track_information *ti)
-{
-	struct cdrom_device_ops *cdo = cdi->ops;
-	struct packet_command cgc;
-	int ret, buflen;
-
-	init_cdrom_command(&cgc, ti, 8, CGC_DATA_READ);
-	cgc.cmd[0] = GPCMD_READ_TRACK_RZONE_INFO;
-	cgc.cmd[1] = type & 3;
-	cgc.cmd[4] = (track & 0xff00) >> 8;
-	cgc.cmd[5] = track & 0xff;
-	cgc.cmd[8] = 8;
-	cgc.quiet = 1;
-
-	if ((ret = cdo->generic_packet(cdi, &cgc)))
-		return ret;
-	
-	buflen = be16_to_cpu(ti->track_information_length) +
-		     sizeof(ti->track_information_length);
-
-	if (buflen > sizeof(track_information))
-		buflen = sizeof(track_information);
-
-	cgc.cmd[8] = cgc.buflen = buflen;
-	if ((ret = cdo->generic_packet(cdi, &cgc)))
-		return ret;
-
-	/* return actual fill size */
-	return buflen;
-}
-
 /* requires CD R/RW */
 static int cdrom_get_disc_info(struct cdrom_device_info *cdi, disc_information *di)
 {
@@ -3275,69 +3339,6 @@ static int cdrom_get_disc_info(struct cdrom_device_info *cdi, disc_information *
 	return buflen;
 }
 
-/* return the last written block on the CD-R media. this is for the udf
-   file system. */
-int cdrom_get_last_written(struct cdrom_device_info *cdi, long *last_written)
-{
-	struct cdrom_tocentry toc;
-	disc_information di;
-	track_information ti;
-	__u32 last_track;
-	int ret = -1, ti_size;
-
-	if (!CDROM_CAN(CDC_GENERIC_PACKET))
-		goto use_toc;
-
-	ret = cdrom_get_disc_info(cdi, &di);
-	if (ret < (int)(offsetof(typeof(di), last_track_lsb)
-			+ sizeof(di.last_track_lsb)))
-		goto use_toc;
-
-	/* if unit didn't return msb, it's zeroed by cdrom_get_disc_info */
-	last_track = (di.last_track_msb << 8) | di.last_track_lsb;
-	ti_size = cdrom_get_track_info(cdi, last_track, 1, &ti);
-	if (ti_size < (int)offsetof(typeof(ti), track_start))
-		goto use_toc;
-
-	/* if this track is blank, try the previous. */
-	if (ti.blank) {
-		if (last_track==1)
-			goto use_toc;
-		last_track--;
-		ti_size = cdrom_get_track_info(cdi, last_track, 1, &ti);
-	}
-
-	if (ti_size < (int)(offsetof(typeof(ti), track_size)
-				+ sizeof(ti.track_size)))
-		goto use_toc;
-
-	/* if last recorded field is valid, return it. */
-	if (ti.lra_v && ti_size >= (int)(offsetof(typeof(ti), last_rec_address)
-				+ sizeof(ti.last_rec_address))) {
-		*last_written = be32_to_cpu(ti.last_rec_address);
-	} else {
-		/* make it up instead */
-		*last_written = be32_to_cpu(ti.track_start) +
-				be32_to_cpu(ti.track_size);
-		if (ti.free_blocks)
-			*last_written -= (be32_to_cpu(ti.free_blocks) + 7);
-	}
-	return 0;
-
-	/* this is where we end up if the drive either can't do a
-	   GPCMD_READ_DISC_INFO or GPCMD_READ_TRACK_RZONE_INFO or if
-	   it doesn't give enough information or fails. then we return
-	   the toc contents. */
-use_toc:
-	toc.cdte_format = CDROM_MSF;
-	toc.cdte_track = CDROM_LEADOUT;
-	if ((ret = cdi->ops->audio_ioctl(cdi, CDROMREADTOCENTRY, &toc)))
-		return ret;
-	sanitize_format(&toc.cdte_addr, &toc.cdte_format, CDROM_LBA);
-	*last_written = toc.cdte_addr.lba;
-	return 0;
-}
-
 /* return the next writable block. also for udf file system. */
 static int cdrom_get_next_writable(struct cdrom_device_info *cdi, long *next_writable)
 {
-- 
1.8.1.2.459.gbcd45b4.dirty

