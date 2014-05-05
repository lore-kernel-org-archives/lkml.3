Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754071AbaEEAF2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 20:05:28 -0400
Received: from smtprelay0082.hostedemail.com ([216.40.44.82]:52558 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753971AbaEEAFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 20:05:20 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::,RULES_HIT:2:41:69:355:379:541:800:960:973:988:989:1260:1345:1359:1437:1535:1606:1730:1747:1777:1792:2198:2199:2393:2559:2562:3138:3139:3140:3141:3142:3355:3865:3866:3867:3868:3870:4117:4605:5007:6261:9040:9592:10004:10026:10848:11026:11035:11232:11473:11658:11914:12043:12291:12296:12438:12517:12519:12555:12683:14110,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: sign67_2e705c1848611
X-Filterd-Recvd-Size: 6390
From: Joe Perches <joe@perches.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 03/12] cdrom: Remove obfuscating IOCTL_IN and IOCTL_OUT macros
Date: Sun,  4 May 2014 17:05:04 -0700
Message-Id: <7c5339d567463a85bc0519b944b14e631f7096d2.1399247745.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <51EDAD79.3050707@kernel.dk>
References: <51EDAD79.3050707@kernel.dk>
In-Reply-To: <cover.1399247745.git.joe@perches.com>
References: <cover.1399247745.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Macros with hidden control flow aren't nice.
Just use copy_to/from_user directly instead.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/cdrom/cdrom.c | 48 +++++++++++++++++++++++++++---------------------
 1 file changed, 27 insertions(+), 21 deletions(-)

diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
index 8eaba53..47dee5e 100644
--- a/drivers/cdrom/cdrom.c
+++ b/drivers/cdrom/cdrom.c
@@ -326,15 +326,6 @@ do {							\
 } while (0)
 #endif
 
-/* These are used to simplify getting data in from and back to user land */
-#define IOCTL_IN(arg, type, in)					\
-	if (copy_from_user(&(in), (type __user *) (arg), sizeof (in)))	\
-		return -EFAULT;
-
-#define IOCTL_OUT(arg, type, out) \
-	if (copy_to_user((type __user *) (arg), &(out), sizeof (out)))	\
-		return -EFAULT;
-
 /* The (cdo->capability & ~cdi->mask & CDC_XXX) construct was used in
    a lot of places. This macro makes the code more clear. */
 #define CDROM_CAN(type) (cdi->ops->capability & ~cdi->mask & (type))
@@ -2874,7 +2865,8 @@ static noinline int mmc_ioctl_cdrom_read_data(struct cdrom_device_info *cdi,
 		blocksize = CD_FRAMESIZE_RAW0;
 		break;
 	}
-	IOCTL_IN(arg, struct cdrom_msf, msf);
+	if (copy_from_user(&msf, (struct cdrom_msf __user *)arg, sizeof(msf)))
+		return -EFAULT;
 	lba = msf_to_lba(msf.cdmsf_min0, msf.cdmsf_sec0, msf.cdmsf_frame0);
 	/* FIXME: we need upper bound checking, too!! */
 	if (lba < 0)
@@ -2916,7 +2908,9 @@ static noinline int mmc_ioctl_cdrom_read_audio(struct cdrom_device_info *cdi,
 	struct cdrom_read_audio ra;
 	int lba;
 
-	IOCTL_IN(arg, struct cdrom_read_audio, ra);
+	if (copy_from_user(&ra, (struct cdrom_read_audio __user *)arg,
+			   sizeof(ra)))
+		return -EFAULT;
 
 	if (ra.addr_format == CDROM_MSF)
 		lba = msf_to_lba(ra.addr.msf.minute,
@@ -2940,7 +2934,8 @@ static noinline int mmc_ioctl_cdrom_subchannel(struct cdrom_device_info *cdi,
 	int ret;
 	struct cdrom_subchnl q;
 	u_char requested, back;
-	IOCTL_IN(arg, struct cdrom_subchnl, q);
+	if (copy_from_user(&q, (struct cdrom_subchnl __user *)arg, sizeof(q)))
+		return -EFAULT;
 	requested = q.cdsc_format;
 	if (!((requested == CDROM_MSF) ||
 	      (requested == CDROM_LBA)))
@@ -2952,7 +2947,8 @@ static noinline int mmc_ioctl_cdrom_subchannel(struct cdrom_device_info *cdi,
 	back = q.cdsc_format; /* local copy */
 	sanitize_format(&q.cdsc_absaddr, &back, requested);
 	sanitize_format(&q.cdsc_reladdr, &q.cdsc_format, requested);
-	IOCTL_OUT(arg, struct cdrom_subchnl, q);
+	if (copy_to_user((struct cdrom_subchnl __user *)arg, &q, sizeof(q)))
+		return -EFAULT;
 	/* cd_dbg(CD_DO_IOCTL, "CDROMSUBCHNL successful\n"); */
 	return 0;
 }
@@ -2964,7 +2960,8 @@ static noinline int mmc_ioctl_cdrom_play_msf(struct cdrom_device_info *cdi,
 	struct cdrom_device_ops *cdo = cdi->ops;
 	struct cdrom_msf msf;
 	cd_dbg(CD_DO_IOCTL, "entering CDROMPLAYMSF\n");
-	IOCTL_IN(arg, struct cdrom_msf, msf);
+	if (copy_from_user(&msf, (struct cdrom_msf __user *)arg, sizeof(msf)))
+		return -EFAULT;
 	cgc->cmd[0] = GPCMD_PLAY_AUDIO_MSF;
 	cgc->cmd[3] = msf.cdmsf_min0;
 	cgc->cmd[4] = msf.cdmsf_sec0;
@@ -2983,7 +2980,8 @@ static noinline int mmc_ioctl_cdrom_play_blk(struct cdrom_device_info *cdi,
 	struct cdrom_device_ops *cdo = cdi->ops;
 	struct cdrom_blk blk;
 	cd_dbg(CD_DO_IOCTL, "entering CDROMPLAYBLK\n");
-	IOCTL_IN(arg, struct cdrom_blk, blk);
+	if (copy_from_user(&blk, (struct cdrom_blk __user *)arg, sizeof(blk)))
+		return -EFAULT;
 	cgc->cmd[0] = GPCMD_PLAY_AUDIO_10;
 	cgc->cmd[2] = (blk.from >> 24) & 0xff;
 	cgc->cmd[3] = (blk.from >> 16) & 0xff;
@@ -3008,7 +3006,9 @@ static noinline int mmc_ioctl_cdrom_volume(struct cdrom_device_info *cdi,
 
 	cd_dbg(CD_DO_IOCTL, "entering CDROMVOLUME\n");
 
-	IOCTL_IN(arg, struct cdrom_volctrl, volctrl);
+	if (copy_from_user(&volctrl, (struct cdrom_volctrl __user *)arg,
+			   sizeof(volctrl)))
+		return -EFAULT;
 
 	cgc->buffer = buffer;
 	cgc->buflen = 24;
@@ -3045,7 +3045,9 @@ static noinline int mmc_ioctl_cdrom_volume(struct cdrom_device_info *cdi,
 		volctrl.channel1 = buffer[offset+11];
 		volctrl.channel2 = buffer[offset+13];
 		volctrl.channel3 = buffer[offset+15];
-		IOCTL_OUT(arg, struct cdrom_volctrl, volctrl);
+		if (copy_to_user((struct cdrom_volctrl __user *)arg, &volctrl,
+				 sizeof(volctrl)))
+			return -EFAULT;
 		return 0;
 	}
 		
@@ -3131,11 +3133,13 @@ static noinline int mmc_ioctl_dvd_auth(struct cdrom_device_info *cdi,
 	if (!CDROM_CAN(CDC_DVD))
 		return -ENOSYS;
 	cd_dbg(CD_DO_IOCTL, "entering DVD_AUTH\n");
-	IOCTL_IN(arg, dvd_authinfo, ai);
+	if (copy_from_user(&ai, (dvd_authinfo __user *)arg, sizeof(ai)))
+		return -EFAULT;
 	ret = dvd_do_auth(cdi, &ai);
 	if (ret)
 		return ret;
-	IOCTL_OUT(arg, dvd_authinfo, ai);
+	if (copy_to_user((dvd_authinfo __user *)arg, &ai, sizeof(ai)))
+		return -EFAULT;
 	return 0;
 }
 
@@ -3148,7 +3152,8 @@ static noinline int mmc_ioctl_cdrom_next_writable(struct cdrom_device_info *cdi,
 	ret = cdrom_get_next_writable(cdi, &next);
 	if (ret)
 		return ret;
-	IOCTL_OUT(arg, long, next);
+	if (copy_to_user((long __user *)arg, &next, sizeof(next)))
+		return -EFAULT;
 	return 0;
 }
 
@@ -3161,7 +3166,8 @@ static noinline int mmc_ioctl_cdrom_last_written(struct cdrom_device_info *cdi,
 	ret = cdrom_get_last_written(cdi, &last);
 	if (ret)
 		return ret;
-	IOCTL_OUT(arg, long, last);
+	if (copy_to_user((long __user *)arg, &last, sizeof(last)))
+		return -EFAULT;
 	return 0;
 }
 
-- 
1.8.1.2.459.gbcd45b4.dirty

