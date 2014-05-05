Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010AbaEEAFW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 20:05:22 -0400
Received: from smtprelay0207.hostedemail.com ([216.40.44.207]:52554 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751695AbaEEAFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 20:05:18 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::,RULES_HIT:69:327:355:379:541:960:966:973:988:989:1260:1345:1359:1437:1605:1730:1747:1777:1792:1981:2194:2196:2198:2199:2200:2201:2393:2559:2562:2693:2910:3138:3139:3140:3141:3142:3865:3866:3867:3870:3871:3872:3874:4250:4321:4385:4605:5007:6261:7874:7903:8603:9010:9121:10004:10026:10848:11026:11035:11914:12043:12291:12294:12296:12438:12517:12519:12555:12683:13972:14110,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: love17_2def5f159890c
X-Filterd-Recvd-Size: 34238
From: Joe Perches <joe@perches.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 01/12] cdrom: convert cdinfo to cd_dbg
Date: Sun,  4 May 2014 17:05:02 -0700
Message-Id: <ca525e52deb038a2be7ad8a42f47f65bfb0b435d.1399247745.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <51EDAD79.3050707@kernel.dk>
References: <51EDAD79.3050707@kernel.dk>
In-Reply-To: <cover.1399247745.git.joe@perches.com>
References: <cover.1399247745.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's a debugging message, mark it so.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/cdrom/cdrom.c | 241 +++++++++++++++++++++++++-------------------------
 1 file changed, 121 insertions(+), 120 deletions(-)

diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
index 8a3aff7..3828c92 100644
--- a/drivers/cdrom/cdrom.c
+++ b/drivers/cdrom/cdrom.c
@@ -312,17 +312,17 @@ static const char *mrw_format_status[] = {
 
 static const char *mrw_address_space[] = { "DMA", "GAA" };
 
-#if (ERRLOGMASK!=CD_NOTHING)
-#define cdinfo(type, fmt, args...)			\
+#if (ERRLOGMASK != CD_NOTHING)
+#define cd_dbg(type, fmt, ...)				\
 do {							\
 	if ((ERRLOGMASK & type) || debug == 1)		\
-		pr_info(fmt, ##args);			\
+		pr_debug(fmt, ##__VA_ARGS__);		\
 } while (0)
 #else
-#define cdinfo(type, fmt, args...)			\
+#define cd_dbg(type, fmt, ...)				\
 do {							\
 	if (0 && (ERRLOGMASK & type) || debug == 1)	\
-		pr_info(fmt, ##args);			\
+		pr_debug(fmt, ##__VA_ARGS__);		\
 } while (0)
 #endif
 
@@ -395,7 +395,7 @@ int register_cdrom(struct cdrom_device_info *cdi)
         struct cdrom_device_ops *cdo = cdi->ops;
         int *change_capability = (int *)&cdo->capability; /* hack */
 
-	cdinfo(CD_OPEN, "entering register_cdrom\n"); 
+	cd_dbg(CD_OPEN, "entering register_cdrom\n");
 
 	if (cdo->open == NULL || cdo->release == NULL)
 		return -EINVAL;
@@ -439,7 +439,7 @@ int register_cdrom(struct cdrom_device_info *cdi)
 	if (!cdo->generic_packet)
 		cdo->generic_packet = cdrom_dummy_generic_packet;
 
-	cdinfo(CD_REG_UNREG, "drive \"/dev/%s\" registered\n", cdi->name);
+	cd_dbg(CD_REG_UNREG, "drive \"/dev/%s\" registered\n", cdi->name);
 	mutex_lock(&cdrom_mutex);
 	list_add(&cdi->list, &cdrom_list);
 	mutex_unlock(&cdrom_mutex);
@@ -449,7 +449,7 @@ int register_cdrom(struct cdrom_device_info *cdi)
 
 void unregister_cdrom(struct cdrom_device_info *cdi)
 {
-	cdinfo(CD_OPEN, "entering unregister_cdrom\n"); 
+	cd_dbg(CD_OPEN, "entering unregister_cdrom\n");
 
 	mutex_lock(&cdrom_mutex);
 	list_del(&cdi->list);
@@ -459,7 +459,7 @@ void unregister_cdrom(struct cdrom_device_info *cdi)
 		cdi->exit(cdi);
 
 	cdi->ops->n_minors--;
-	cdinfo(CD_REG_UNREG, "drive \"/dev/%s\" unregistered\n", cdi->name);
+	cd_dbg(CD_REG_UNREG, "drive \"/dev/%s\" unregistered\n", cdi->name);
 }
 
 int cdrom_get_media_event(struct cdrom_device_info *cdi,
@@ -839,7 +839,7 @@ static int cdrom_ram_open_write(struct cdrom_device_info *cdi)
 	else if (CDF_RWRT == be16_to_cpu(rfd.feature_code))
 		ret = !rfd.curr;
 
-	cdinfo(CD_OPEN, "can open for random write\n");
+	cd_dbg(CD_OPEN, "can open for random write\n");
 	return ret;
 }
 
@@ -928,12 +928,12 @@ static void cdrom_dvd_rw_close_write(struct cdrom_device_info *cdi)
 	struct packet_command cgc;
 
 	if (cdi->mmc3_profile != 0x1a) {
-		cdinfo(CD_CLOSE, "%s: No DVD+RW\n", cdi->name);
+		cd_dbg(CD_CLOSE, "%s: No DVD+RW\n", cdi->name);
 		return;
 	}
 
 	if (!cdi->media_written) {
-		cdinfo(CD_CLOSE, "%s: DVD+RW media clean\n", cdi->name);
+		cd_dbg(CD_CLOSE, "%s: DVD+RW media clean\n", cdi->name);
 		return;
 	}
 
@@ -981,7 +981,7 @@ int cdrom_open(struct cdrom_device_info *cdi, struct block_device *bdev, fmode_t
 {
 	int ret;
 
-	cdinfo(CD_OPEN, "entering cdrom_open\n"); 
+	cd_dbg(CD_OPEN, "entering cdrom_open\n");
 
 	/* open is event synchronization point, check events first */
 	check_disk_change(bdev);
@@ -1010,13 +1010,13 @@ int cdrom_open(struct cdrom_device_info *cdi, struct block_device *bdev, fmode_t
 	if (ret)
 		goto err;
 
-	cdinfo(CD_OPEN, "Use count for \"/dev/%s\" now %d\n",
-			cdi->name, cdi->use_count);
+	cd_dbg(CD_OPEN, "Use count for \"/dev/%s\" now %d\n",
+	       cdi->name, cdi->use_count);
 	return 0;
 err_release:
 	if (CDROM_CAN(CDC_LOCK) && cdi->options & CDO_LOCK) {
 		cdi->ops->lock_door(cdi, 0);
-		cdinfo(CD_OPEN, "door unlocked.\n");
+		cd_dbg(CD_OPEN, "door unlocked\n");
 	}
 	cdi->ops->release(cdi);
 err:
@@ -1030,21 +1030,21 @@ int open_for_data(struct cdrom_device_info * cdi)
 	int ret;
 	struct cdrom_device_ops *cdo = cdi->ops;
 	tracktype tracks;
-	cdinfo(CD_OPEN, "entering open_for_data\n");
+	cd_dbg(CD_OPEN, "entering open_for_data\n");
 	/* Check if the driver can report drive status.  If it can, we
 	   can do clever things.  If it can't, well, we at least tried! */
 	if (cdo->drive_status != NULL) {
 		ret = cdo->drive_status(cdi, CDSL_CURRENT);
-		cdinfo(CD_OPEN, "drive_status=%d\n", ret); 
+		cd_dbg(CD_OPEN, "drive_status=%d\n", ret);
 		if (ret == CDS_TRAY_OPEN) {
-			cdinfo(CD_OPEN, "the tray is open...\n"); 
+			cd_dbg(CD_OPEN, "the tray is open...\n");
 			/* can/may i close it? */
 			if (CDROM_CAN(CDC_CLOSE_TRAY) &&
 			    cdi->options & CDO_AUTO_CLOSE) {
-				cdinfo(CD_OPEN, "trying to close the tray.\n"); 
+				cd_dbg(CD_OPEN, "trying to close the tray\n");
 				ret=cdo->tray_move(cdi,0);
 				if (ret) {
-					cdinfo(CD_OPEN, "bummer. tried to close the tray but failed.\n"); 
+					cd_dbg(CD_OPEN, "bummer. tried to close the tray but failed.\n");
 					/* Ignore the error from the low
 					level driver.  We don't care why it
 					couldn't close the tray.  We only care 
@@ -1054,19 +1054,19 @@ int open_for_data(struct cdrom_device_info * cdi)
 					goto clean_up_and_return;
 				}
 			} else {
-				cdinfo(CD_OPEN, "bummer. this drive can't close the tray.\n"); 
+				cd_dbg(CD_OPEN, "bummer. this drive can't close the tray.\n");
 				ret=-ENOMEDIUM;
 				goto clean_up_and_return;
 			}
 			/* Ok, the door should be closed now.. Check again */
 			ret = cdo->drive_status(cdi, CDSL_CURRENT);
 			if ((ret == CDS_NO_DISC) || (ret==CDS_TRAY_OPEN)) {
-				cdinfo(CD_OPEN, "bummer. the tray is still not closed.\n"); 
-				cdinfo(CD_OPEN, "tray might not contain a medium.\n");
+				cd_dbg(CD_OPEN, "bummer. the tray is still not closed.\n");
+				cd_dbg(CD_OPEN, "tray might not contain a medium\n");
 				ret=-ENOMEDIUM;
 				goto clean_up_and_return;
 			}
-			cdinfo(CD_OPEN, "the tray is now closed.\n"); 
+			cd_dbg(CD_OPEN, "the tray is now closed\n");
 		}
 		/* the door should be closed now, check for the disc */
 		ret = cdo->drive_status(cdi, CDSL_CURRENT);
@@ -1077,7 +1077,7 @@ int open_for_data(struct cdrom_device_info * cdi)
 	}
 	cdrom_count_tracks(cdi, &tracks);
 	if (tracks.error == CDS_NO_DISC) {
-		cdinfo(CD_OPEN, "bummer. no disc.\n");
+		cd_dbg(CD_OPEN, "bummer. no disc.\n");
 		ret=-ENOMEDIUM;
 		goto clean_up_and_return;
 	}
@@ -1087,34 +1087,34 @@ int open_for_data(struct cdrom_device_info * cdi)
 		if (cdi->options & CDO_CHECK_TYPE) {
 		    /* give people a warning shot, now that CDO_CHECK_TYPE
 		       is the default case! */
-		    cdinfo(CD_OPEN, "bummer. wrong media type.\n"); 
-		    cdinfo(CD_WARNING, "pid %d must open device O_NONBLOCK!\n",
-					(unsigned int)task_pid_nr(current));
+		    cd_dbg(CD_OPEN, "bummer. wrong media type.\n");
+		    cd_dbg(CD_WARNING, "pid %d must open device O_NONBLOCK!\n",
+			   (unsigned int)task_pid_nr(current));
 		    ret=-EMEDIUMTYPE;
 		    goto clean_up_and_return;
 		}
 		else {
-		    cdinfo(CD_OPEN, "wrong media type, but CDO_CHECK_TYPE not set.\n");
+		    cd_dbg(CD_OPEN, "wrong media type, but CDO_CHECK_TYPE not set\n");
 		}
 	}
 
-	cdinfo(CD_OPEN, "all seems well, opening the device.\n"); 
+	cd_dbg(CD_OPEN, "all seems well, opening the devicen");
 
 	/* all seems well, we can open the device */
 	ret = cdo->open(cdi, 0); /* open for data */
-	cdinfo(CD_OPEN, "opening the device gave me %d.\n", ret); 
+	cd_dbg(CD_OPEN, "opening the device gave me %d\n", ret);
 	/* After all this careful checking, we shouldn't have problems
 	   opening the device, but we don't want the device locked if 
 	   this somehow fails... */
 	if (ret) {
-		cdinfo(CD_OPEN, "open device failed.\n"); 
+		cd_dbg(CD_OPEN, "open device failed\n");
 		goto clean_up_and_return;
 	}
 	if (CDROM_CAN(CDC_LOCK) && (cdi->options & CDO_LOCK)) {
 			cdo->lock_door(cdi, 1);
-			cdinfo(CD_OPEN, "door locked.\n");
+			cd_dbg(CD_OPEN, "door locked\n");
 	}
-	cdinfo(CD_OPEN, "device opened successfully.\n"); 
+	cd_dbg(CD_OPEN, "device opened successfully\n");
 	return ret;
 
 	/* Something failed.  Try to unlock the drive, because some drivers
@@ -1123,10 +1123,10 @@ int open_for_data(struct cdrom_device_info * cdi)
 	This ensures that the drive gets unlocked after a mount fails.  This 
 	is a goto to avoid bloating the driver with redundant code. */ 
 clean_up_and_return:
-	cdinfo(CD_OPEN, "open failed.\n"); 
+	cd_dbg(CD_OPEN, "open failed\n");
 	if (CDROM_CAN(CDC_LOCK) && cdi->options & CDO_LOCK) {
 			cdo->lock_door(cdi, 0);
-			cdinfo(CD_OPEN, "door unlocked.\n");
+			cd_dbg(CD_OPEN, "door unlocked\n");
 	}
 	return ret;
 }
@@ -1139,21 +1139,21 @@ static int check_for_audio_disc(struct cdrom_device_info * cdi,
 {
         int ret;
 	tracktype tracks;
-	cdinfo(CD_OPEN, "entering check_for_audio_disc\n");
+	cd_dbg(CD_OPEN, "entering check_for_audio_disc\n");
 	if (!(cdi->options & CDO_CHECK_TYPE))
 		return 0;
 	if (cdo->drive_status != NULL) {
 		ret = cdo->drive_status(cdi, CDSL_CURRENT);
-		cdinfo(CD_OPEN, "drive_status=%d\n", ret); 
+		cd_dbg(CD_OPEN, "drive_status=%d\n", ret);
 		if (ret == CDS_TRAY_OPEN) {
-			cdinfo(CD_OPEN, "the tray is open...\n"); 
+			cd_dbg(CD_OPEN, "the tray is open...\n");
 			/* can/may i close it? */
 			if (CDROM_CAN(CDC_CLOSE_TRAY) &&
 			    cdi->options & CDO_AUTO_CLOSE) {
-				cdinfo(CD_OPEN, "trying to close the tray.\n"); 
+				cd_dbg(CD_OPEN, "trying to close the tray\n");
 				ret=cdo->tray_move(cdi,0);
 				if (ret) {
-					cdinfo(CD_OPEN, "bummer. tried to close tray but failed.\n"); 
+					cd_dbg(CD_OPEN, "bummer. tried to close tray but failed.\n");
 					/* Ignore the error from the low
 					level driver.  We don't care why it
 					couldn't close the tray.  We only care 
@@ -1162,20 +1162,20 @@ static int check_for_audio_disc(struct cdrom_device_info * cdi,
 					return -ENOMEDIUM;
 				}
 			} else {
-				cdinfo(CD_OPEN, "bummer. this driver can't close the tray.\n"); 
+				cd_dbg(CD_OPEN, "bummer. this driver can't close the tray.\n");
 				return -ENOMEDIUM;
 			}
 			/* Ok, the door should be closed now.. Check again */
 			ret = cdo->drive_status(cdi, CDSL_CURRENT);
 			if ((ret == CDS_NO_DISC) || (ret==CDS_TRAY_OPEN)) {
-				cdinfo(CD_OPEN, "bummer. the tray is still not closed.\n"); 
+				cd_dbg(CD_OPEN, "bummer. the tray is still not closed.\n");
 				return -ENOMEDIUM;
 			}	
 			if (ret!=CDS_DISC_OK) {
-				cdinfo(CD_OPEN, "bummer. disc isn't ready.\n"); 
+				cd_dbg(CD_OPEN, "bummer. disc isn't ready.\n");
 				return -EIO;
 			}	
-			cdinfo(CD_OPEN, "the tray is now closed.\n"); 
+			cd_dbg(CD_OPEN, "the tray is now closed\n");
 		}	
 	}
 	cdrom_count_tracks(cdi, &tracks);
@@ -1193,17 +1193,18 @@ void cdrom_release(struct cdrom_device_info *cdi, fmode_t mode)
 	struct cdrom_device_ops *cdo = cdi->ops;
 	int opened_for_data;
 
-	cdinfo(CD_CLOSE, "entering cdrom_release\n");
+	cd_dbg(CD_CLOSE, "entering cdrom_release\n");
 
 	if (cdi->use_count > 0)
 		cdi->use_count--;
 
 	if (cdi->use_count == 0) {
-		cdinfo(CD_CLOSE, "Use count for \"/dev/%s\" now zero\n", cdi->name);
+		cd_dbg(CD_CLOSE, "Use count for \"/dev/%s\" now zero\n",
+		       cdi->name);
 		cdrom_dvd_rw_close_write(cdi);
 
 		if ((cdo->capability & CDC_LOCK) && !cdi->keeplocked) {
-			cdinfo(CD_CLOSE, "Unlocking door!\n");
+			cd_dbg(CD_CLOSE, "Unlocking door!\n");
 			cdo->lock_door(cdi, 0);
 		}
 	}
@@ -1262,7 +1263,7 @@ static int cdrom_slot_status(struct cdrom_device_info *cdi, int slot)
 	struct cdrom_changer_info *info;
 	int ret;
 
-	cdinfo(CD_CHANGER, "entering cdrom_slot_status()\n"); 
+	cd_dbg(CD_CHANGER, "entering cdrom_slot_status()\n");
 	if (cdi->sanyo_slot)
 		return CDS_NO_INFO;
 	
@@ -1292,7 +1293,7 @@ int cdrom_number_of_slots(struct cdrom_device_info *cdi)
 	int nslots = 1;
 	struct cdrom_changer_info *info;
 
-	cdinfo(CD_CHANGER, "entering cdrom_number_of_slots()\n"); 
+	cd_dbg(CD_CHANGER, "entering cdrom_number_of_slots()\n");
 	/* cdrom_read_mech_status requires a valid value for capacity: */
 	cdi->capacity = 0; 
 
@@ -1313,7 +1314,7 @@ static int cdrom_load_unload(struct cdrom_device_info *cdi, int slot)
 {
 	struct packet_command cgc;
 
-	cdinfo(CD_CHANGER, "entering cdrom_load_unload()\n"); 
+	cd_dbg(CD_CHANGER, "entering cdrom_load_unload()\n");
 	if (cdi->sanyo_slot && slot < 0)
 		return 0;
 
@@ -1342,7 +1343,7 @@ static int cdrom_select_disc(struct cdrom_device_info *cdi, int slot)
 	int curslot;
 	int ret;
 
-	cdinfo(CD_CHANGER, "entering cdrom_select_disc()\n"); 
+	cd_dbg(CD_CHANGER, "entering cdrom_select_disc()\n");
 	if (!CDROM_CAN(CDC_SELECT_DISC))
 		return -EDRIVE_CANT_DO_THIS;
 
@@ -1487,7 +1488,7 @@ static void cdrom_count_tracks(struct cdrom_device_info *cdi, tracktype* tracks)
 	tracks->cdi=0;
 	tracks->xa=0;
 	tracks->error=0;
-	cdinfo(CD_COUNT_TRACKS, "entering cdrom_count_tracks\n"); 
+	cd_dbg(CD_COUNT_TRACKS, "entering cdrom_count_tracks\n");
 	/* Grab the TOC header so we can see how many tracks there are */
 	if ((ret = cdi->ops->audio_ioctl(cdi, CDROMREADTOCHDR, &header))) {
 		if (ret == -ENOMEDIUM)
@@ -1513,12 +1514,12 @@ static void cdrom_count_tracks(struct cdrom_device_info *cdi, tracktype* tracks)
 			tracks->data++;
 		} else
 		    tracks->audio++;
-		cdinfo(CD_COUNT_TRACKS, "track %d: format=%d, ctrl=%d\n",
+		cd_dbg(CD_COUNT_TRACKS, "track %d: format=%d, ctrl=%d\n",
 		       i, entry.cdte_format, entry.cdte_ctrl);
 	}	
-	cdinfo(CD_COUNT_TRACKS, "disc has %d tracks: %d=audio %d=data %d=Cd-I %d=XA\n", 
-		header.cdth_trk1, tracks->audio, tracks->data, 
-		tracks->cdi, tracks->xa);
+	cd_dbg(CD_COUNT_TRACKS, "disc has %d tracks: %d=audio %d=data %d=Cd-I %d=XA\n",
+	       header.cdth_trk1, tracks->audio, tracks->data,
+	       tracks->cdi, tracks->xa);
 }	
 
 /* Requests to the low-level drivers will /always/ be done in the
@@ -1632,7 +1633,7 @@ static int dvd_do_auth(struct cdrom_device_info *cdi, dvd_authinfo *ai)
 	switch (ai->type) {
 	/* LU data send */
 	case DVD_LU_SEND_AGID:
-		cdinfo(CD_DVD, "entering DVD_LU_SEND_AGID\n"); 
+		cd_dbg(CD_DVD, "entering DVD_LU_SEND_AGID\n");
 		cgc.quiet = 1;
 		setup_report_key(&cgc, ai->lsa.agid, 0);
 
@@ -1644,7 +1645,7 @@ static int dvd_do_auth(struct cdrom_device_info *cdi, dvd_authinfo *ai)
 		break;
 
 	case DVD_LU_SEND_KEY1:
-		cdinfo(CD_DVD, "entering DVD_LU_SEND_KEY1\n"); 
+		cd_dbg(CD_DVD, "entering DVD_LU_SEND_KEY1\n");
 		setup_report_key(&cgc, ai->lsk.agid, 2);
 
 		if ((ret = cdo->generic_packet(cdi, &cgc)))
@@ -1655,7 +1656,7 @@ static int dvd_do_auth(struct cdrom_device_info *cdi, dvd_authinfo *ai)
 		break;
 
 	case DVD_LU_SEND_CHALLENGE:
-		cdinfo(CD_DVD, "entering DVD_LU_SEND_CHALLENGE\n"); 
+		cd_dbg(CD_DVD, "entering DVD_LU_SEND_CHALLENGE\n");
 		setup_report_key(&cgc, ai->lsc.agid, 1);
 
 		if ((ret = cdo->generic_packet(cdi, &cgc)))
@@ -1667,7 +1668,7 @@ static int dvd_do_auth(struct cdrom_device_info *cdi, dvd_authinfo *ai)
 
 	/* Post-auth key */
 	case DVD_LU_SEND_TITLE_KEY:
-		cdinfo(CD_DVD, "entering DVD_LU_SEND_TITLE_KEY\n"); 
+		cd_dbg(CD_DVD, "entering DVD_LU_SEND_TITLE_KEY\n");
 		cgc.quiet = 1;
 		setup_report_key(&cgc, ai->lstk.agid, 4);
 		cgc.cmd[5] = ai->lstk.lba;
@@ -1686,7 +1687,7 @@ static int dvd_do_auth(struct cdrom_device_info *cdi, dvd_authinfo *ai)
 		break;
 
 	case DVD_LU_SEND_ASF:
-		cdinfo(CD_DVD, "entering DVD_LU_SEND_ASF\n"); 
+		cd_dbg(CD_DVD, "entering DVD_LU_SEND_ASF\n");
 		setup_report_key(&cgc, ai->lsasf.agid, 5);
 		
 		if ((ret = cdo->generic_packet(cdi, &cgc)))
@@ -1697,7 +1698,7 @@ static int dvd_do_auth(struct cdrom_device_info *cdi, dvd_authinfo *ai)
 
 	/* LU data receive (LU changes state) */
 	case DVD_HOST_SEND_CHALLENGE:
-		cdinfo(CD_DVD, "entering DVD_HOST_SEND_CHALLENGE\n"); 
+		cd_dbg(CD_DVD, "entering DVD_HOST_SEND_CHALLENGE\n");
 		setup_send_key(&cgc, ai->hsc.agid, 1);
 		buf[1] = 0xe;
 		copy_chal(&buf[4], ai->hsc.chal);
@@ -1709,7 +1710,7 @@ static int dvd_do_auth(struct cdrom_device_info *cdi, dvd_authinfo *ai)
 		break;
 
 	case DVD_HOST_SEND_KEY2:
-		cdinfo(CD_DVD, "entering DVD_HOST_SEND_KEY2\n"); 
+		cd_dbg(CD_DVD, "entering DVD_HOST_SEND_KEY2\n");
 		setup_send_key(&cgc, ai->hsk.agid, 3);
 		buf[1] = 0xa;
 		copy_key(&buf[4], ai->hsk.key);
@@ -1724,7 +1725,7 @@ static int dvd_do_auth(struct cdrom_device_info *cdi, dvd_authinfo *ai)
 	/* Misc */
 	case DVD_INVALIDATE_AGID:
 		cgc.quiet = 1;
-		cdinfo(CD_DVD, "entering DVD_INVALIDATE_AGID\n"); 
+		cd_dbg(CD_DVD, "entering DVD_INVALIDATE_AGID\n");
 		setup_report_key(&cgc, ai->lsa.agid, 0x3f);
 		if ((ret = cdo->generic_packet(cdi, &cgc)))
 			return ret;
@@ -1732,7 +1733,7 @@ static int dvd_do_auth(struct cdrom_device_info *cdi, dvd_authinfo *ai)
 
 	/* Get region settings */
 	case DVD_LU_SEND_RPC_STATE:
-		cdinfo(CD_DVD, "entering DVD_LU_SEND_RPC_STATE\n");
+		cd_dbg(CD_DVD, "entering DVD_LU_SEND_RPC_STATE\n");
 		setup_report_key(&cgc, 0, 8);
 		memset(&rpc_state, 0, sizeof(rpc_state_t));
 		cgc.buffer = (char *) &rpc_state;
@@ -1749,7 +1750,7 @@ static int dvd_do_auth(struct cdrom_device_info *cdi, dvd_authinfo *ai)
 
 	/* Set region settings */
 	case DVD_HOST_SEND_RPC_STATE:
-		cdinfo(CD_DVD, "entering DVD_HOST_SEND_RPC_STATE\n");
+		cd_dbg(CD_DVD, "entering DVD_HOST_SEND_RPC_STATE\n");
 		setup_send_key(&cgc, 0, 6);
 		buf[1] = 6;
 		buf[4] = ai->hrpcs.pdrc;
@@ -1759,7 +1760,7 @@ static int dvd_do_auth(struct cdrom_device_info *cdi, dvd_authinfo *ai)
 		break;
 
 	default:
-		cdinfo(CD_WARNING, "Invalid DVD key ioctl (%d)\n", ai->type);
+		cd_dbg(CD_WARNING, "Invalid DVD key ioctl (%d)\n", ai->type);
 		return -ENOTTY;
 	}
 
@@ -1891,7 +1892,8 @@ static int dvd_read_bca(struct cdrom_device_info *cdi, dvd_struct *s,
 
 	s->bca.len = buf[0] << 8 | buf[1];
 	if (s->bca.len < 12 || s->bca.len > 188) {
-		cdinfo(CD_WARNING, "Received invalid BCA length (%d)\n", s->bca.len);
+		cd_dbg(CD_WARNING, "Received invalid BCA length (%d)\n",
+		       s->bca.len);
 		ret = -EIO;
 		goto out;
 	}
@@ -1927,14 +1929,13 @@ static int dvd_read_manufact(struct cdrom_device_info *cdi, dvd_struct *s,
 
 	s->manufact.len = buf[0] << 8 | buf[1];
 	if (s->manufact.len < 0) {
-		cdinfo(CD_WARNING, "Received invalid manufacture info length"
-				   " (%d)\n", s->manufact.len);
+		cd_dbg(CD_WARNING, "Received invalid manufacture info length (%d)\n",
+		       s->manufact.len);
 		ret = -EIO;
 	} else {
 		if (s->manufact.len > 2048) {
-			cdinfo(CD_WARNING, "Received invalid manufacture info "
-					"length (%d): truncating to 2048\n",
-					s->manufact.len);
+			cd_dbg(CD_WARNING, "Received invalid manufacture info length (%d): truncating to 2048\n",
+			       s->manufact.len);
 			s->manufact.len = 2048;
 		}
 		memcpy(s->manufact.value, &buf[4], s->manufact.len);
@@ -1965,8 +1966,8 @@ static int dvd_read_struct(struct cdrom_device_info *cdi, dvd_struct *s,
 		return dvd_read_manufact(cdi, s, cgc);
 		
 	default:
-		cdinfo(CD_WARNING, ": Invalid DVD structure read requested (%d)\n",
-					s->type);
+		cd_dbg(CD_WARNING, ": Invalid DVD structure read requested (%d)\n",
+		       s->type);
 		return -EINVAL;
 	}
 }
@@ -2255,7 +2256,7 @@ static int cdrom_ioctl_multisession(struct cdrom_device_info *cdi,
 	u8 requested_format;
 	int ret;
 
-	cdinfo(CD_DO_IOCTL, "entering CDROMMULTISESSION\n");
+	cd_dbg(CD_DO_IOCTL, "entering CDROMMULTISESSION\n");
 
 	if (!(cdi->ops->capability & CDC_MULTI_SESSION))
 		return -ENOSYS;
@@ -2277,13 +2278,13 @@ static int cdrom_ioctl_multisession(struct cdrom_device_info *cdi,
 	if (copy_to_user(argp, &ms_info, sizeof(ms_info)))
 		return -EFAULT;
 
-	cdinfo(CD_DO_IOCTL, "CDROMMULTISESSION successful\n");
+	cd_dbg(CD_DO_IOCTL, "CDROMMULTISESSION successful\n");
 	return 0;
 }
 
 static int cdrom_ioctl_eject(struct cdrom_device_info *cdi)
 {
-	cdinfo(CD_DO_IOCTL, "entering CDROMEJECT\n");
+	cd_dbg(CD_DO_IOCTL, "entering CDROMEJECT\n");
 
 	if (!CDROM_CAN(CDC_OPEN_TRAY))
 		return -ENOSYS;
@@ -2300,7 +2301,7 @@ static int cdrom_ioctl_eject(struct cdrom_device_info *cdi)
 
 static int cdrom_ioctl_closetray(struct cdrom_device_info *cdi)
 {
-	cdinfo(CD_DO_IOCTL, "entering CDROMCLOSETRAY\n");
+	cd_dbg(CD_DO_IOCTL, "entering CDROMCLOSETRAY\n");
 
 	if (!CDROM_CAN(CDC_CLOSE_TRAY))
 		return -ENOSYS;
@@ -2310,7 +2311,7 @@ static int cdrom_ioctl_closetray(struct cdrom_device_info *cdi)
 static int cdrom_ioctl_eject_sw(struct cdrom_device_info *cdi,
 		unsigned long arg)
 {
-	cdinfo(CD_DO_IOCTL, "entering CDROMEJECT_SW\n");
+	cd_dbg(CD_DO_IOCTL, "entering CDROMEJECT_SW\n");
 
 	if (!CDROM_CAN(CDC_OPEN_TRAY))
 		return -ENOSYS;
@@ -2329,7 +2330,7 @@ static int cdrom_ioctl_media_changed(struct cdrom_device_info *cdi,
 	struct cdrom_changer_info *info;
 	int ret;
 
-	cdinfo(CD_DO_IOCTL, "entering CDROM_MEDIA_CHANGED\n");
+	cd_dbg(CD_DO_IOCTL, "entering CDROM_MEDIA_CHANGED\n");
 
 	if (!CDROM_CAN(CDC_MEDIA_CHANGED))
 		return -ENOSYS;
@@ -2355,7 +2356,7 @@ static int cdrom_ioctl_media_changed(struct cdrom_device_info *cdi,
 static int cdrom_ioctl_set_options(struct cdrom_device_info *cdi,
 		unsigned long arg)
 {
-	cdinfo(CD_DO_IOCTL, "entering CDROM_SET_OPTIONS\n");
+	cd_dbg(CD_DO_IOCTL, "entering CDROM_SET_OPTIONS\n");
 
 	/*
 	 * Options need to be in sync with capability.
@@ -2383,7 +2384,7 @@ static int cdrom_ioctl_set_options(struct cdrom_device_info *cdi,
 static int cdrom_ioctl_clear_options(struct cdrom_device_info *cdi,
 		unsigned long arg)
 {
-	cdinfo(CD_DO_IOCTL, "entering CDROM_CLEAR_OPTIONS\n");
+	cd_dbg(CD_DO_IOCTL, "entering CDROM_CLEAR_OPTIONS\n");
 
 	cdi->options &= ~(int) arg;
 	return cdi->options;
@@ -2392,7 +2393,7 @@ static int cdrom_ioctl_clear_options(struct cdrom_device_info *cdi,
 static int cdrom_ioctl_select_speed(struct cdrom_device_info *cdi,
 		unsigned long arg)
 {
-	cdinfo(CD_DO_IOCTL, "entering CDROM_SELECT_SPEED\n");
+	cd_dbg(CD_DO_IOCTL, "entering CDROM_SELECT_SPEED\n");
 
 	if (!CDROM_CAN(CDC_SELECT_SPEED))
 		return -ENOSYS;
@@ -2402,7 +2403,7 @@ static int cdrom_ioctl_select_speed(struct cdrom_device_info *cdi,
 static int cdrom_ioctl_select_disc(struct cdrom_device_info *cdi,
 		unsigned long arg)
 {
-	cdinfo(CD_DO_IOCTL, "entering CDROM_SELECT_DISC\n");
+	cd_dbg(CD_DO_IOCTL, "entering CDROM_SELECT_DISC\n");
 
 	if (!CDROM_CAN(CDC_SELECT_DISC))
 		return -ENOSYS;
@@ -2420,14 +2421,14 @@ static int cdrom_ioctl_select_disc(struct cdrom_device_info *cdi,
 	if (cdi->ops->select_disc)
 		return cdi->ops->select_disc(cdi, arg);
 
-	cdinfo(CD_CHANGER, "Using generic cdrom_select_disc()\n");
+	cd_dbg(CD_CHANGER, "Using generic cdrom_select_disc()\n");
 	return cdrom_select_disc(cdi, arg);
 }
 
 static int cdrom_ioctl_reset(struct cdrom_device_info *cdi,
 		struct block_device *bdev)
 {
-	cdinfo(CD_DO_IOCTL, "entering CDROM_RESET\n");
+	cd_dbg(CD_DO_IOCTL, "entering CDROM_RESET\n");
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
@@ -2440,7 +2441,7 @@ static int cdrom_ioctl_reset(struct cdrom_device_info *cdi,
 static int cdrom_ioctl_lock_door(struct cdrom_device_info *cdi,
 		unsigned long arg)
 {
-	cdinfo(CD_DO_IOCTL, "%socking door.\n", arg ? "L" : "Unl");
+	cd_dbg(CD_DO_IOCTL, "%socking door\n", arg ? "L" : "Unl");
 
 	if (!CDROM_CAN(CDC_LOCK))
 		return -EDRIVE_CANT_DO_THIS;
@@ -2459,7 +2460,7 @@ static int cdrom_ioctl_lock_door(struct cdrom_device_info *cdi,
 static int cdrom_ioctl_debug(struct cdrom_device_info *cdi,
 		unsigned long arg)
 {
-	cdinfo(CD_DO_IOCTL, "%sabling debug.\n", arg ? "En" : "Dis");
+	cd_dbg(CD_DO_IOCTL, "%sabling debug\n", arg ? "En" : "Dis");
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
@@ -2469,7 +2470,7 @@ static int cdrom_ioctl_debug(struct cdrom_device_info *cdi,
 
 static int cdrom_ioctl_get_capability(struct cdrom_device_info *cdi)
 {
-	cdinfo(CD_DO_IOCTL, "entering CDROM_GET_CAPABILITY\n");
+	cd_dbg(CD_DO_IOCTL, "entering CDROM_GET_CAPABILITY\n");
 	return (cdi->ops->capability & ~cdi->mask);
 }
 
@@ -2485,7 +2486,7 @@ static int cdrom_ioctl_get_mcn(struct cdrom_device_info *cdi,
 	struct cdrom_mcn mcn;
 	int ret;
 
-	cdinfo(CD_DO_IOCTL, "entering CDROM_GET_MCN\n");
+	cd_dbg(CD_DO_IOCTL, "entering CDROM_GET_MCN\n");
 
 	if (!(cdi->ops->capability & CDC_MCN))
 		return -ENOSYS;
@@ -2495,14 +2496,14 @@ static int cdrom_ioctl_get_mcn(struct cdrom_device_info *cdi,
 
 	if (copy_to_user(argp, &mcn, sizeof(mcn)))
 		return -EFAULT;
-	cdinfo(CD_DO_IOCTL, "CDROM_GET_MCN successful\n");
+	cd_dbg(CD_DO_IOCTL, "CDROM_GET_MCN successful\n");
 	return 0;
 }
 
 static int cdrom_ioctl_drive_status(struct cdrom_device_info *cdi,
 		unsigned long arg)
 {
-	cdinfo(CD_DO_IOCTL, "entering CDROM_DRIVE_STATUS\n");
+	cd_dbg(CD_DO_IOCTL, "entering CDROM_DRIVE_STATUS\n");
 
 	if (!(cdi->ops->capability & CDC_DRIVE_STATUS))
 		return -ENOSYS;
@@ -2535,7 +2536,7 @@ static int cdrom_ioctl_disc_status(struct cdrom_device_info *cdi)
 {
 	tracktype tracks;
 
-	cdinfo(CD_DO_IOCTL, "entering CDROM_DISC_STATUS\n");
+	cd_dbg(CD_DO_IOCTL, "entering CDROM_DISC_STATUS\n");
 
 	cdrom_count_tracks(cdi, &tracks);
 	if (tracks.error)
@@ -2557,13 +2558,13 @@ static int cdrom_ioctl_disc_status(struct cdrom_device_info *cdi)
 		return CDS_DATA_1;
 	/* Policy mode off */
 
-	cdinfo(CD_WARNING,"This disc doesn't have any tracks I recognize!\n");
+	cd_dbg(CD_WARNING, "This disc doesn't have any tracks I recognize!\n");
 	return CDS_NO_INFO;
 }
 
 static int cdrom_ioctl_changer_nslots(struct cdrom_device_info *cdi)
 {
-	cdinfo(CD_DO_IOCTL, "entering CDROM_CHANGER_NSLOTS\n");
+	cd_dbg(CD_DO_IOCTL, "entering CDROM_CHANGER_NSLOTS\n");
 	return cdi->capacity;
 }
 
@@ -2574,7 +2575,7 @@ static int cdrom_ioctl_get_subchnl(struct cdrom_device_info *cdi,
 	u8 requested, back;
 	int ret;
 
-	/* cdinfo(CD_DO_IOCTL,"entering CDROMSUBCHNL\n");*/
+	/* cd_dbg(CD_DO_IOCTL,"entering CDROMSUBCHNL\n");*/
 
 	if (copy_from_user(&q, argp, sizeof(q)))
 		return -EFAULT;
@@ -2594,7 +2595,7 @@ static int cdrom_ioctl_get_subchnl(struct cdrom_device_info *cdi,
 
 	if (copy_to_user(argp, &q, sizeof(q)))
 		return -EFAULT;
-	/* cdinfo(CD_DO_IOCTL, "CDROMSUBCHNL successful\n"); */
+	/* cd_dbg(CD_DO_IOCTL, "CDROMSUBCHNL successful\n"); */
 	return 0;
 }
 
@@ -2604,7 +2605,7 @@ static int cdrom_ioctl_read_tochdr(struct cdrom_device_info *cdi,
 	struct cdrom_tochdr header;
 	int ret;
 
-	/* cdinfo(CD_DO_IOCTL, "entering CDROMREADTOCHDR\n"); */
+	/* cd_dbg(CD_DO_IOCTL, "entering CDROMREADTOCHDR\n"); */
 
 	if (copy_from_user(&header, argp, sizeof(header)))
 		return -EFAULT;
@@ -2615,7 +2616,7 @@ static int cdrom_ioctl_read_tochdr(struct cdrom_device_info *cdi,
 
 	if (copy_to_user(argp, &header, sizeof(header)))
 		return -EFAULT;
-	/* cdinfo(CD_DO_IOCTL, "CDROMREADTOCHDR successful\n"); */
+	/* cd_dbg(CD_DO_IOCTL, "CDROMREADTOCHDR successful\n"); */
 	return 0;
 }
 
@@ -2626,7 +2627,7 @@ static int cdrom_ioctl_read_tocentry(struct cdrom_device_info *cdi,
 	u8 requested_format;
 	int ret;
 
-	/* cdinfo(CD_DO_IOCTL, "entering CDROMREADTOCENTRY\n"); */
+	/* cd_dbg(CD_DO_IOCTL, "entering CDROMREADTOCENTRY\n"); */
 
 	if (copy_from_user(&entry, argp, sizeof(entry)))
 		return -EFAULT;
@@ -2643,7 +2644,7 @@ static int cdrom_ioctl_read_tocentry(struct cdrom_device_info *cdi,
 
 	if (copy_to_user(argp, &entry, sizeof(entry)))
 		return -EFAULT;
-	/* cdinfo(CD_DO_IOCTL, "CDROMREADTOCENTRY successful\n"); */
+	/* cd_dbg(CD_DO_IOCTL, "CDROMREADTOCENTRY successful\n"); */
 	return 0;
 }
 
@@ -2652,7 +2653,7 @@ static int cdrom_ioctl_play_msf(struct cdrom_device_info *cdi,
 {
 	struct cdrom_msf msf;
 
-	cdinfo(CD_DO_IOCTL, "entering CDROMPLAYMSF\n");
+	cd_dbg(CD_DO_IOCTL, "entering CDROMPLAYMSF\n");
 
 	if (!CDROM_CAN(CDC_PLAY_AUDIO))
 		return -ENOSYS;
@@ -2667,7 +2668,7 @@ static int cdrom_ioctl_play_trkind(struct cdrom_device_info *cdi,
 	struct cdrom_ti ti;
 	int ret;
 
-	cdinfo(CD_DO_IOCTL, "entering CDROMPLAYTRKIND\n");
+	cd_dbg(CD_DO_IOCTL, "entering CDROMPLAYTRKIND\n");
 
 	if (!CDROM_CAN(CDC_PLAY_AUDIO))
 		return -ENOSYS;
@@ -2684,7 +2685,7 @@ static int cdrom_ioctl_volctrl(struct cdrom_device_info *cdi,
 {
 	struct cdrom_volctrl volume;
 
-	cdinfo(CD_DO_IOCTL, "entering CDROMVOLCTRL\n");
+	cd_dbg(CD_DO_IOCTL, "entering CDROMVOLCTRL\n");
 
 	if (!CDROM_CAN(CDC_PLAY_AUDIO))
 		return -ENOSYS;
@@ -2699,7 +2700,7 @@ static int cdrom_ioctl_volread(struct cdrom_device_info *cdi,
 	struct cdrom_volctrl volume;
 	int ret;
 
-	cdinfo(CD_DO_IOCTL, "entering CDROMVOLREAD\n");
+	cd_dbg(CD_DO_IOCTL, "entering CDROMVOLREAD\n");
 
 	if (!CDROM_CAN(CDC_PLAY_AUDIO))
 		return -ENOSYS;
@@ -2718,7 +2719,7 @@ static int cdrom_ioctl_audioctl(struct cdrom_device_info *cdi,
 {
 	int ret;
 
-	cdinfo(CD_DO_IOCTL, "doing audio ioctl (start/stop/pause/resume)\n");
+	cd_dbg(CD_DO_IOCTL, "doing audio ioctl (start/stop/pause/resume)\n");
 
 	if (!CDROM_CAN(CDC_PLAY_AUDIO))
 		return -ENOSYS;
@@ -2796,7 +2797,7 @@ int cdrom_ioctl(struct cdrom_device_info *cdi, struct block_device *bdev,
 	}
 
 	/*
-	 * Note: most of the cdinfo() calls are commented out here,
+	 * Note: most of the cd_dbg() calls are commented out here,
 	 * because they fill up the sys log when CD players poll
 	 * the drive.
 	 */
@@ -2955,7 +2956,7 @@ static noinline int mmc_ioctl_cdrom_subchannel(struct cdrom_device_info *cdi,
 	sanitize_format(&q.cdsc_absaddr, &back, requested);
 	sanitize_format(&q.cdsc_reladdr, &q.cdsc_format, requested);
 	IOCTL_OUT(arg, struct cdrom_subchnl, q);
-	/* cdinfo(CD_DO_IOCTL, "CDROMSUBCHNL successful\n"); */
+	/* cd_dbg(CD_DO_IOCTL, "CDROMSUBCHNL successful\n"); */
 	return 0;
 }
 
@@ -2965,7 +2966,7 @@ static noinline int mmc_ioctl_cdrom_play_msf(struct cdrom_device_info *cdi,
 {
 	struct cdrom_device_ops *cdo = cdi->ops;
 	struct cdrom_msf msf;
-	cdinfo(CD_DO_IOCTL, "entering CDROMPLAYMSF\n");
+	cd_dbg(CD_DO_IOCTL, "entering CDROMPLAYMSF\n");
 	IOCTL_IN(arg, struct cdrom_msf, msf);
 	cgc->cmd[0] = GPCMD_PLAY_AUDIO_MSF;
 	cgc->cmd[3] = msf.cdmsf_min0;
@@ -2984,7 +2985,7 @@ static noinline int mmc_ioctl_cdrom_play_blk(struct cdrom_device_info *cdi,
 {
 	struct cdrom_device_ops *cdo = cdi->ops;
 	struct cdrom_blk blk;
-	cdinfo(CD_DO_IOCTL, "entering CDROMPLAYBLK\n");
+	cd_dbg(CD_DO_IOCTL, "entering CDROMPLAYBLK\n");
 	IOCTL_IN(arg, struct cdrom_blk, blk);
 	cgc->cmd[0] = GPCMD_PLAY_AUDIO_10;
 	cgc->cmd[2] = (blk.from >> 24) & 0xff;
@@ -3008,7 +3009,7 @@ static noinline int mmc_ioctl_cdrom_volume(struct cdrom_device_info *cdi,
 	unsigned short offset;
 	int ret;
 
-	cdinfo(CD_DO_IOCTL, "entering CDROMVOLUME\n");
+	cd_dbg(CD_DO_IOCTL, "entering CDROMVOLUME\n");
 
 	IOCTL_IN(arg, struct cdrom_volctrl, volctrl);
 
@@ -3073,7 +3074,7 @@ static noinline int mmc_ioctl_cdrom_start_stop(struct cdrom_device_info *cdi,
 					int cmd)
 {
 	struct cdrom_device_ops *cdo = cdi->ops;
-	cdinfo(CD_DO_IOCTL, "entering CDROMSTART/CDROMSTOP\n");
+	cd_dbg(CD_DO_IOCTL, "entering CDROMSTART/CDROMSTOP\n");
 	cgc->cmd[0] = GPCMD_START_STOP_UNIT;
 	cgc->cmd[1] = 1;
 	cgc->cmd[4] = (cmd == CDROMSTART) ? 1 : 0;
@@ -3086,7 +3087,7 @@ static noinline int mmc_ioctl_cdrom_pause_resume(struct cdrom_device_info *cdi,
 					int cmd)
 {
 	struct cdrom_device_ops *cdo = cdi->ops;
-	cdinfo(CD_DO_IOCTL, "entering CDROMPAUSE/CDROMRESUME\n");
+	cd_dbg(CD_DO_IOCTL, "entering CDROMPAUSE/CDROMRESUME\n");
 	cgc->cmd[0] = GPCMD_PAUSE_RESUME;
 	cgc->cmd[8] = (cmd == CDROMRESUME) ? 1 : 0;
 	cgc->data_direction = CGC_DATA_NONE;
@@ -3108,7 +3109,7 @@ static noinline int mmc_ioctl_dvd_read_struct(struct cdrom_device_info *cdi,
 	if (!s)
 		return -ENOMEM;
 
-	cdinfo(CD_DO_IOCTL, "entering DVD_READ_STRUCT\n");
+	cd_dbg(CD_DO_IOCTL, "entering DVD_READ_STRUCT\n");
 	if (copy_from_user(s, arg, size)) {
 		kfree(s);
 		return -EFAULT;
@@ -3132,7 +3133,7 @@ static noinline int mmc_ioctl_dvd_auth(struct cdrom_device_info *cdi,
 	dvd_authinfo ai;
 	if (!CDROM_CAN(CDC_DVD))
 		return -ENOSYS;
-	cdinfo(CD_DO_IOCTL, "entering DVD_AUTH\n");
+	cd_dbg(CD_DO_IOCTL, "entering DVD_AUTH\n");
 	IOCTL_IN(arg, dvd_authinfo, ai);
 	ret = dvd_do_auth(cdi, &ai);
 	if (ret)
@@ -3146,7 +3147,7 @@ static noinline int mmc_ioctl_cdrom_next_writable(struct cdrom_device_info *cdi,
 {
 	int ret;
 	long next = 0;
-	cdinfo(CD_DO_IOCTL, "entering CDROM_NEXT_WRITABLE\n");
+	cd_dbg(CD_DO_IOCTL, "entering CDROM_NEXT_WRITABLE\n");
 	ret = cdrom_get_next_writable(cdi, &next);
 	if (ret)
 		return ret;
@@ -3159,7 +3160,7 @@ static noinline int mmc_ioctl_cdrom_last_written(struct cdrom_device_info *cdi,
 {
 	int ret;
 	long last = 0;
-	cdinfo(CD_DO_IOCTL, "entering CDROM_LAST_WRITTEN\n");
+	cd_dbg(CD_DO_IOCTL, "entering CDROM_LAST_WRITTEN\n");
 	ret = cdrom_get_last_written(cdi, &last);
 	if (ret)
 		return ret;
-- 
1.8.1.2.459.gbcd45b4.dirty

