Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752560Ab3GABN1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jun 2013 21:13:27 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:51486 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752171Ab3GABNY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jun 2013 21:13:24 -0400
From: Joe Perches <joe@perches.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 09/12] cdrom: Remove cdrom_get_next_writeable prototype
Date: Sun, 30 Jun 2013 18:12:04 -0700
Message-Id: <459d6ca61f1bddbe3630ebe94ae1a4f6092479a9.1372640818.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1372640818.git.joe@perches.com>
References: <cover.1372640818.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the function to the right spot instead.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/cdrom/cdrom.c | 101 +++++++++++++++++++++++++-------------------------
 1 file changed, 51 insertions(+), 50 deletions(-)

diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
index 4fb9ad5..8af1307 100644
--- a/drivers/cdrom/cdrom.c
+++ b/drivers/cdrom/cdrom.c
@@ -338,7 +338,6 @@ do {							\
 
 /* Not-exported routines. */
 
-static int cdrom_get_next_writable(struct cdrom_device_info *, long *);
 static void cdrom_count_tracks(struct cdrom_device_info *, tracktype*);
 
 static int cdrom_mrw_exit(struct cdrom_device_info *cdi);
@@ -2836,6 +2835,57 @@ use_toc:
 	return 0;
 }
 
+/* return the next writable block. also for udf file system. */
+static int cdrom_get_next_writable(struct cdrom_device_info *cdi,
+				   long *next_writable)
+{
+	disc_information di;
+	track_information ti;
+	__u16 last_track;
+	int ret, ti_size;
+
+	if (!CDROM_CAN(CDC_GENERIC_PACKET))
+		goto use_last_written;
+
+	ret = cdrom_get_disc_info(cdi, &di);
+	if (ret < 0 || ret < offsetof(typeof(di), last_track_lsb)
+				+ sizeof(di.last_track_lsb))
+		goto use_last_written;
+
+	/* if unit didn't return msb, it's zeroed by cdrom_get_disc_info */
+	last_track = (di.last_track_msb << 8) | di.last_track_lsb;
+	ti_size = cdrom_get_track_info(cdi, last_track, 1, &ti);
+	if (ti_size < 0 || ti_size < offsetof(typeof(ti), track_start))
+		goto use_last_written;
+
+	/* if this track is blank, try the previous. */
+	if (ti.blank) {
+		if (last_track == 1)
+			goto use_last_written;
+		last_track--;
+		ti_size = cdrom_get_track_info(cdi, last_track, 1, &ti);
+		if (ti_size < 0)
+			goto use_last_written;
+	}
+
+	/* if next recordable address field is valid, use it. */
+	if (ti.nwa_v && ti_size >= offsetof(typeof(ti), next_writable)
+				+ sizeof(ti.next_writable)) {
+		*next_writable = be32_to_cpu(ti.next_writable);
+		return 0;
+	}
+
+use_last_written:
+	ret = cdrom_get_last_written(cdi, next_writable);
+	if (ret) {
+		*next_writable = 0;
+		return ret;
+	} else {
+		*next_writable += 7;
+		return 0;
+	}
+}
+
 static noinline int mmc_ioctl_cdrom_read_data(struct cdrom_device_info *cdi,
 					      void __user *arg,
 					      struct packet_command *cgc,
@@ -3339,55 +3389,6 @@ static int cdrom_get_disc_info(struct cdrom_device_info *cdi, disc_information *
 	return buflen;
 }
 
-/* return the next writable block. also for udf file system. */
-static int cdrom_get_next_writable(struct cdrom_device_info *cdi, long *next_writable)
-{
-	disc_information di;
-	track_information ti;
-	__u16 last_track;
-	int ret, ti_size;
-
-	if (!CDROM_CAN(CDC_GENERIC_PACKET))
-		goto use_last_written;
-
-	ret = cdrom_get_disc_info(cdi, &di);
-	if (ret < 0 || ret < offsetof(typeof(di), last_track_lsb)
-				+ sizeof(di.last_track_lsb))
-		goto use_last_written;
-
-	/* if unit didn't return msb, it's zeroed by cdrom_get_disc_info */
-	last_track = (di.last_track_msb << 8) | di.last_track_lsb;
-	ti_size = cdrom_get_track_info(cdi, last_track, 1, &ti);
-	if (ti_size < 0 || ti_size < offsetof(typeof(ti), track_start))
-		goto use_last_written;
-
-        /* if this track is blank, try the previous. */
-	if (ti.blank) {
-		if (last_track == 1)
-			goto use_last_written;
-		last_track--;
-		ti_size = cdrom_get_track_info(cdi, last_track, 1, &ti);
-		if (ti_size < 0)
-			goto use_last_written;
-	}
-
-	/* if next recordable address field is valid, use it. */
-	if (ti.nwa_v && ti_size >= offsetof(typeof(ti), next_writable)
-				+ sizeof(ti.next_writable)) {
-		*next_writable = be32_to_cpu(ti.next_writable);
-		return 0;
-	}
-
-use_last_written:
-	if ((ret = cdrom_get_last_written(cdi, next_writable))) {
-		*next_writable = 0;
-		return ret;
-	} else {
-		*next_writable += 7;
-		return 0;
-	}
-}
-
 EXPORT_SYMBOL(cdrom_get_last_written);
 EXPORT_SYMBOL(register_cdrom);
 EXPORT_SYMBOL(unregister_cdrom);
-- 
1.8.1.2.459.gbcd45b4.dirty

