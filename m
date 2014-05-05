Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754231AbaEEAGm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 20:06:42 -0400
Received: from smtprelay0025.hostedemail.com ([216.40.44.25]:45312 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753971AbaEEAF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 20:05:29 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::,RULES_HIT:41:69:355:379:541:800:960:973:988:989:1260:1345:1359:1437:1534:1544:1711:1730:1747:1777:1792:2194:2198:2199:2200:2393:2559:2562:3138:3139:3140:3141:3142:3353:3865:3867:3871:3872:4321:4605:5007:6119:6261:7903:9592:10004:10026:10848:11026:11232:11473:11658:11914:12043:12114:12291:12296:12438:12517:12519:12555:12683:13138:13231:13972:14110,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: page48_2fbdd1af99221
X-Filterd-Recvd-Size: 4861
From: Joe Perches <joe@perches.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 09/12] cdrom: Remove cdrom_get_next_writeable prototype
Date: Sun,  4 May 2014 17:05:10 -0700
Message-Id: <d29506b0faa6ce0a29251fe1a2251eefcac29b4b.1399247745.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <51EDAD79.3050707@kernel.dk>
References: <51EDAD79.3050707@kernel.dk>
In-Reply-To: <cover.1399247745.git.joe@perches.com>
References: <cover.1399247745.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the function to the right spot instead.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/cdrom/cdrom.c | 101 +++++++++++++++++++++++++-------------------------
 1 file changed, 51 insertions(+), 50 deletions(-)

diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
index fac603a..8888ed3 100644
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

