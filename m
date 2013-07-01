Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752582Ab3GABNd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jun 2013 21:13:33 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:57770 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751880Ab3GABNc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jun 2013 21:13:32 -0400
From: Joe Perches <joe@perches.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 10/12] cdrom: Remove cdrom_count_tracks prototype
Date: Sun, 30 Jun 2013 18:12:05 -0700
Message-Id: <3dfd0917fb4a30141266f422dea40525c28eae47.1372640818.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1372640818.git.joe@perches.com>
References: <cover.1372640818.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move function to proper location instead.
Fix whitespace and embedded if too.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/cdrom/cdrom.c | 94 +++++++++++++++++++++++++--------------------------
 1 file changed, 47 insertions(+), 47 deletions(-)

diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
index 8af1307..87a74d4 100644
--- a/drivers/cdrom/cdrom.c
+++ b/drivers/cdrom/cdrom.c
@@ -338,8 +338,6 @@ do {							\
 
 /* Not-exported routines. */
 
-static void cdrom_count_tracks(struct cdrom_device_info *, tracktype*);
-
 static int cdrom_mrw_exit(struct cdrom_device_info *cdi);
 
 static int cdrom_get_disc_info(struct cdrom_device_info *cdi, disc_information *di);
@@ -948,6 +946,53 @@ static int cdrom_close_write(struct cdrom_device_info *cdi)
 #endif
 }
 
+/* badly broken, I know. Is due for a fixup anytime. */
+static void cdrom_count_tracks(struct cdrom_device_info *cdi, tracktype *tracks)
+{
+	struct cdrom_tochdr header;
+	struct cdrom_tocentry entry;
+	int ret, i;
+	tracks->data = 0;
+	tracks->audio = 0;
+	tracks->cdi = 0;
+	tracks->xa = 0;
+	tracks->error = 0;
+	cd_dbg(CD_COUNT_TRACKS, "entering cdrom_count_tracks\n");
+	/* Grab the TOC header so we can see how many tracks there are */
+	ret = cdi->ops->audio_ioctl(cdi, CDROMREADTOCHDR, &header);
+	if (ret) {
+		if (ret == -ENOMEDIUM)
+			tracks->error = CDS_NO_DISC;
+		else
+			tracks->error = CDS_NO_INFO;
+		return;
+	}
+	/* check what type of tracks are on this disc */
+	entry.cdte_format = CDROM_MSF;
+	for (i = header.cdth_trk0; i <= header.cdth_trk1; i++) {
+		entry.cdte_track = i;
+		if (cdi->ops->audio_ioctl(cdi, CDROMREADTOCENTRY, &entry)) {
+			tracks->error = CDS_NO_INFO;
+			return;
+		}
+		if (entry.cdte_ctrl & CDROM_DATA_TRACK) {
+			if (entry.cdte_format == 0x10)
+				tracks->cdi++;
+			else if (entry.cdte_format == 0x20)
+				tracks->xa++;
+			else
+				tracks->data++;
+		} else {
+			tracks->audio++;
+		}
+		cd_dbg(CD_COUNT_TRACKS, "track %d: format=%d, ctrl=%d\n",
+		       i, entry.cdte_format, entry.cdte_ctrl);
+	}
+	cd_dbg(CD_COUNT_TRACKS, "disc has %d tracks: %d=audio %d=data %d=Cd-I %d=XA\n",
+	       header.cdth_trk1, tracks->audio, tracks->data,
+	       tracks->cdi, tracks->xa);
+}
+
 static
 int open_for_data(struct cdrom_device_info *cdi)
 {
@@ -1457,51 +1502,6 @@ int cdrom_media_changed(struct cdrom_device_info *cdi)
 	return media_changed(cdi, 0);
 }
 
-/* badly broken, I know. Is due for a fixup anytime. */
-static void cdrom_count_tracks(struct cdrom_device_info *cdi, tracktype* tracks)
-{
-	struct cdrom_tochdr header;
-	struct cdrom_tocentry entry;
-	int ret, i;
-	tracks->data=0;
-	tracks->audio=0;
-	tracks->cdi=0;
-	tracks->xa=0;
-	tracks->error=0;
-	cd_dbg(CD_COUNT_TRACKS, "entering cdrom_count_tracks\n");
-	/* Grab the TOC header so we can see how many tracks there are */
-	if ((ret = cdi->ops->audio_ioctl(cdi, CDROMREADTOCHDR, &header))) {
-		if (ret == -ENOMEDIUM)
-			tracks->error = CDS_NO_DISC;
-		else
-			tracks->error = CDS_NO_INFO;
-		return;
-	}	
-	/* check what type of tracks are on this disc */
-	entry.cdte_format = CDROM_MSF;
-	for (i = header.cdth_trk0; i <= header.cdth_trk1; i++) {
-		entry.cdte_track  = i;
-		if (cdi->ops->audio_ioctl(cdi, CDROMREADTOCENTRY, &entry)) {
-			tracks->error=CDS_NO_INFO;
-			return;
-		}	
-		if (entry.cdte_ctrl & CDROM_DATA_TRACK) {
-		    if (entry.cdte_format == 0x10)
-			tracks->cdi++;
-		    else if (entry.cdte_format == 0x20) 
-			tracks->xa++;
-		    else
-			tracks->data++;
-		} else
-		    tracks->audio++;
-		cd_dbg(CD_COUNT_TRACKS, "track %d: format=%d, ctrl=%d\n",
-		       i, entry.cdte_format, entry.cdte_ctrl);
-	}	
-	cd_dbg(CD_COUNT_TRACKS, "disc has %d tracks: %d=audio %d=data %d=Cd-I %d=XA\n",
-	       header.cdth_trk1, tracks->audio, tracks->data,
-	       tracks->cdi, tracks->xa);
-}	
-
 /* Requests to the low-level drivers will /always/ be done in the
    following format convention:
 
-- 
1.8.1.2.459.gbcd45b4.dirty

