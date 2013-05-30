Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758632Ab3E3U6X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 16:58:23 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:39463 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758272Ab3E3U6K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 16:58:10 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] pktcdvd: Convert printk to pr_<level>
Date: Thu, 30 May 2013 13:57:50 -0700
Message-Id: <be5d8d48c70deec2d883e122732522ced3bd6246.1369947186.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1369947186.git.joe@perches.com>
References: <alpine.LNX.2.00.1305291537120.30576@pobox.suse.cz> <cover.1369947186.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use a more current logging style and add messages levels
to the logging messages.

Convert bare printks to pr_cont where appropriate and
add a simple function to emit the sense string.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/block/pktcdvd.c | 123 +++++++++++++++++++++++++-----------------------
 1 file changed, 64 insertions(+), 59 deletions(-)

diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index 635f6cb..ff08de1 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -44,6 +44,8 @@
  *
  *************************************************************************/
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/pktcdvd.h>
 #include <linux/module.h>
 #include <linux/types.h>
@@ -60,7 +62,7 @@
 #include <linux/mutex.h>
 #include <linux/slab.h>
 #include <scsi/scsi_cmnd.h>
-l#include <scsi/scsi_ioctl.h>
+#include <scsi/scsi_ioctl.h>
 #include <scsi/scsi.h>
 #include <linux/debugfs.h>
 #include <linux/device.h>
@@ -424,7 +426,7 @@ static int pkt_sysfs_init(void)
 	if (ret) {
 		kfree(class_pktcdvd);
 		class_pktcdvd = NULL;
-		printk(DRIVER_NAME": failed to create class pktcdvd\n");
+		pr_err("failed to create class pktcdvd\n");
 		return ret;
 	}
 	return 0;
@@ -734,36 +736,37 @@ out:
 	return ret;
 }
 
+static const char *sense_key_string(__u8 index)
+{
+	static const char *info[9] = {
+		"No sense", "Recovered error", "Not ready",
+		"Medium error", "Hardware error", "Illegal request",
+		"Unit attention", "Data protect", "Blank check"
+	};
+	if (index < 8)
+		return info[index];
+	return "INVALID";
+}
+
 /*
  * A generic sense dump / resolve mechanism should be implemented across
  * all ATAPI + SCSI devices.
  */
 static void pkt_dump_sense(struct packet_command *cgc)
 {
-	static char *info[9] = { "No sense", "Recovered error", "Not ready",
-				 "Medium error", "Hardware error", "Illegal request",
-				 "Unit attention", "Data protect", "Blank check" };
 	int i;
 	struct request_sense *sense = cgc->sense;
 
-	printk(DRIVER_NAME":");
+	pr_err("");
 	for (i = 0; i < CDROM_PACKET_SIZE; i++)
-		printk(" %02x", cgc->cmd[i]);
-	printk(" - ");
+		pr_cont(" %02x", cgc->cmd[i]);
 
-	if (sense == NULL) {
-		printk("no sense\n");
-		return;
-	}
-
-	printk("sense %02x.%02x.%02x", sense->sense_key, sense->asc, sense->ascq);
-
-	if (sense->sense_key > 8) {
-		printk(" (INVALID)\n");
-		return;
-	}
-
-	printk(" (%s)\n", info[sense->sense_key]);
+	if (sense)
+		pr_cont(" - sense %02x.%02x.%02x (%s)\n",
+			sense->sense_key, sense->asc, sense->ascq,
+			sense_key_string(sense->sense_key));
+	else
+		pr_cont(" - no sense\n");
 }
 
 /*
@@ -943,7 +946,7 @@ static int pkt_set_segment_merging(struct pktcdvd_device *pd, struct request_que
 		set_bit(PACKET_MERGE_SEGS, &pd->flags);
 		return 0;
 	} else {
-		printk(DRIVER_NAME": cdrom max_phys_segments too small\n");
+		pr_err("cdrom max_phys_segments too small\n");
 		return -EIO;
 	}
 }
@@ -1565,9 +1568,10 @@ work_to_do:
 
 static void pkt_print_settings(struct pktcdvd_device *pd)
 {
-	printk(DRIVER_NAME": %s packets, ", pd->settings.fp ? "Fixed" : "Variable");
-	printk("%u blocks, ", pd->settings.size >> 2);
-	printk("Mode-%c disc\n", pd->settings.block_mode == 8 ? '1' : '2');
+	pr_info("%s packets, %u blocks, Mode-%c disc\n",
+		pd->settings.fp ? "Fixed" : "Variable",
+		pd->settings.size >> 2,
+		pd->settings.block_mode == 8 ? '1' : '2');
 }
 
 static int pkt_mode_sense(struct pktcdvd_device *pd, struct packet_command *cgc, int page_code, int page_control)
@@ -1751,7 +1755,7 @@ static noinline_for_stack int pkt_set_write_settings(struct pktcdvd_device *pd)
 		/*
 		 * paranoia
 		 */
-		printk(DRIVER_NAME": write mode wrong %d\n", wp->data_block_type);
+		pr_err("write mode wrong %d\n", wp->data_block_type);
 		return 1;
 	}
 	wp->packet_size = cpu_to_be32(pd->settings.size >> 2);
@@ -1795,7 +1799,7 @@ static int pkt_writable_track(struct pktcdvd_device *pd, track_information *ti)
 	if (ti->rt == 1 && ti->blank == 0)
 		return 1;
 
-	printk(DRIVER_NAME": bad state %d-%d-%d\n", ti->rt, ti->blank, ti->packet);
+	pr_err("bad state %d-%d-%d\n", ti->rt, ti->blank, ti->packet);
 	return 0;
 }
 
@@ -1822,22 +1826,22 @@ static int pkt_writable_disc(struct pktcdvd_device *pd, disc_information *di)
 	 * but i'm not sure, should we leave this to user apps? probably.
 	 */
 	if (di->disc_type == 0xff) {
-		printk(DRIVER_NAME": Unknown disc. No track?\n");
+		pr_notice("unknown disc - no track?\n");
 		return 0;
 	}
 
 	if (di->disc_type != 0x20 && di->disc_type != 0) {
-		printk(DRIVER_NAME": Wrong disc type (%x)\n", di->disc_type);
+		pr_err("wrong disc type (%x)\n", di->disc_type);
 		return 0;
 	}
 
 	if (di->erasable == 0) {
-		printk(DRIVER_NAME": Disc not erasable\n");
+		pr_notice("disc not erasable\n");
 		return 0;
 	}
 
 	if (di->border_status == PACKET_SESSION_RESERVED) {
-		printk(DRIVER_NAME": Can't write to last track (reserved)\n");
+		pr_err("can't write to last track (reserved)\n");
 		return 0;
 	}
 
@@ -1862,7 +1866,7 @@ static noinline_for_stack int pkt_probe_settings(struct pktcdvd_device *pd)
 	memset(&ti, 0, sizeof(track_information));
 
 	if ((ret = pkt_get_disc_info(pd, &di))) {
-		printk("failed get_disc\n");
+		pr_err("failed get_disc\n");
 		return ret;
 	}
 
@@ -1873,12 +1877,12 @@ static noinline_for_stack int pkt_probe_settings(struct pktcdvd_device *pd)
 
 	track = 1; /* (di.last_track_msb << 8) | di.last_track_lsb; */
 	if ((ret = pkt_get_track_info(pd, track, 1, &ti))) {
-		printk(DRIVER_NAME": failed get_track\n");
+		pr_err("failed get_track\n");
 		return ret;
 	}
 
 	if (!pkt_writable_track(pd, &ti)) {
-		printk(DRIVER_NAME": can't write to this track\n");
+		pr_err("can't write to this track\n");
 		return -EROFS;
 	}
 
@@ -1888,11 +1892,11 @@ static noinline_for_stack int pkt_probe_settings(struct pktcdvd_device *pd)
 	 */
 	pd->settings.size = be32_to_cpu(ti.fixed_packet_size) << 2;
 	if (pd->settings.size == 0) {
-		printk(DRIVER_NAME": detected zero packet size!\n");
+		pr_notice("detected zero packet size!\n");
 		return -ENXIO;
 	}
 	if (pd->settings.size > PACKET_MAX_SECTORS) {
-		printk(DRIVER_NAME": packet size is too big\n");
+		pr_err("packet size is too big\n");
 		return -EROFS;
 	}
 	pd->settings.fp = ti.fp;
@@ -1934,7 +1938,7 @@ static noinline_for_stack int pkt_probe_settings(struct pktcdvd_device *pd)
 			pd->settings.block_mode = PACKET_BLOCK_MODE2;
 			break;
 		default:
-			printk(DRIVER_NAME": unknown data mode\n");
+			pr_err("unknown data mode\n");
 			return -EROFS;
 	}
 	return 0;
@@ -1968,10 +1972,10 @@ static noinline_for_stack int pkt_write_caching(struct pktcdvd_device *pd,
 	cgc.buflen = cgc.cmd[8] = 2 + ((buf[0] << 8) | (buf[1] & 0xff));
 	ret = pkt_mode_select(pd, &cgc);
 	if (ret) {
-		printk(DRIVER_NAME": write caching control failed\n");
+		pr_err("write caching control failed\n");
 		pkt_dump_sense(&cgc);
 	} else if (!ret && set)
-		printk(DRIVER_NAME": enabled write caching on %s\n", pd->name);
+		pr_notice("enabled write caching on %s\n", pd->name);
 	return ret;
 }
 
@@ -2086,11 +2090,11 @@ static noinline_for_stack int pkt_media_speed(struct pktcdvd_device *pd,
 	}
 
 	if (!(buf[6] & 0x40)) {
-		printk(DRIVER_NAME": Disc type is not CD-RW\n");
+		pr_notice("disc type is not CD-RW\n");
 		return 1;
 	}
 	if (!(buf[6] & 0x4)) {
-		printk(DRIVER_NAME": A1 values on media are not valid, maybe not CDRW?\n");
+		pr_notice("A1 values on media are not valid, maybe not CDRW?\n");
 		return 1;
 	}
 
@@ -2110,14 +2114,14 @@ static noinline_for_stack int pkt_media_speed(struct pktcdvd_device *pd,
 			*speed = us_clv_to_speed[sp];
 			break;
 		default:
-			printk(DRIVER_NAME": Unknown disc sub-type %d\n",st);
+			pr_notice("unknown disc sub-type %d\n",st);
 			return 1;
 	}
 	if (*speed) {
-		printk(DRIVER_NAME": Max. media speed: %d\n",*speed);
+		pr_info("maximum media speed: %d\n", *speed);
 		return 0;
 	} else {
-		printk(DRIVER_NAME": Unknown speed %d for sub-type %d\n",sp,st);
+		pr_notice("unknown speed %d for sub-type %d\n", sp, st);
 		return 1;
 	}
 }
@@ -2207,7 +2211,7 @@ static int pkt_open_dev(struct pktcdvd_device *pd, fmode_t write)
 		goto out;
 
 	if ((ret = pkt_get_last_written(pd, &lba))) {
-		printk(DRIVER_NAME": pkt_get_last_written failed\n");
+		pr_err("pkt_get_last_written failed\n");
 		goto out_putdev;
 	}
 
@@ -2237,11 +2241,11 @@ static int pkt_open_dev(struct pktcdvd_device *pd, fmode_t write)
 
 	if (write) {
 		if (!pkt_grow_pktlist(pd, CONFIG_CDROM_PKTCDVD_BUFFERS)) {
-			printk(DRIVER_NAME": not enough memory for buffers\n");
+			pr_err("not enough memory for buffers\n");
 			ret = -ENOMEM;
 			goto out_putdev;
 		}
-		printk(DRIVER_NAME": %lukB available on disc\n", lba << 1);
+		pr_info("%lukB available on disc\n", lba << 1);
 	}
 
 	return 0;
@@ -2363,7 +2367,8 @@ static void pkt_make_request(struct request_queue *q, struct bio *bio)
 
 	pd = q->queuedata;
 	if (!pd) {
-		printk(DRIVER_NAME": %s incorrect request queue\n", bdevname(bio->bi_bdev, b));
+		pr_err("%s incorrect request queue\n",
+		       bdevname(bio->bi_bdev, b));
 		goto end_io;
 	}
 
@@ -2385,13 +2390,13 @@ static void pkt_make_request(struct request_queue *q, struct bio *bio)
 	}
 
 	if (!test_bit(PACKET_WRITABLE, &pd->flags)) {
-		printk(DRIVER_NAME": WRITE for ro device %s (%llu)\n",
-			pd->name, (unsigned long long)bio->bi_sector);
+		pr_notice("WRITE for ro device %s (%llu)\n",
+			  pd->name, (unsigned long long)bio->bi_sector);
 		goto end_io;
 	}
 
 	if (!bio->bi_size || (bio->bi_size % CD_FRAMESIZE)) {
-		printk(DRIVER_NAME": wrong bio size\n");
+		pr_err("wrong bio size\n");
 		goto end_io;
 	}
 
@@ -2612,7 +2617,7 @@ static int pkt_new_dev(struct pktcdvd_device *pd, dev_t dev)
 	struct block_device *bdev;
 
 	if (pd->pkt_dev == dev) {
-		printk(DRIVER_NAME": Recursive setup not allowed\n");
+		pr_err("recursive setup not allowed\n");
 		return -EBUSY;
 	}
 	for (i = 0; i < MAX_WRITERS; i++) {
@@ -2620,11 +2625,11 @@ static int pkt_new_dev(struct pktcdvd_device *pd, dev_t dev)
 		if (!pd2)
 			continue;
 		if (pd2->bdev->bd_dev == dev) {
-			printk(DRIVER_NAME": %s already setup\n", bdevname(pd2->bdev, b));
+			pr_err("%s already setup\n", bdevname(pd2->bdev, b));
 			return -EBUSY;
 		}
 		if (pd2->pkt_dev == dev) {
-			printk(DRIVER_NAME": Can't chain pktcdvd devices\n");
+			pr_err("can't chain pktcdvd devices\n");
 			return -EBUSY;
 		}
 	}
@@ -2647,7 +2652,7 @@ static int pkt_new_dev(struct pktcdvd_device *pd, dev_t dev)
 	atomic_set(&pd->cdrw.pending_bios, 0);
 	pd->cdrw.thread = kthread_run(kcdrwd, pd, "%s", pd->name);
 	if (IS_ERR(pd->cdrw.thread)) {
-		printk(DRIVER_NAME": can't start kernel thread\n");
+		pr_err("can't start kernel thread\n");
 		ret = -ENOMEM;
 		goto out_mem;
 	}
@@ -2746,7 +2751,7 @@ static int pkt_setup_dev(dev_t dev, dev_t* pkt_dev)
 		if (!pkt_devs[idx])
 			break;
 	if (idx == MAX_WRITERS) {
-		printk(DRIVER_NAME": max %d writers supported\n", MAX_WRITERS);
+		pr_err("max %d writers supported\n", MAX_WRITERS);
 		ret = -EBUSY;
 		goto out_mutex;
 	}
@@ -2821,7 +2826,7 @@ out_mem:
 	kfree(pd);
 out_mutex:
 	mutex_unlock(&ctl_mutex);
-	printk(DRIVER_NAME": setup of pktcdvd device failed\n");
+	pr_err("setup of pktcdvd device failed\n");
 	return ret;
 }
 
@@ -2972,7 +2977,7 @@ static int __init pkt_init(void)
 
 	ret = register_blkdev(pktdev_major, DRIVER_NAME);
 	if (ret < 0) {
-		printk(DRIVER_NAME": Unable to register block device\n");
+		pr_err("unable to register block device\n");
 		goto out2;
 	}
 	if (!pktdev_major)
@@ -2986,7 +2991,7 @@ static int __init pkt_init(void)
 
 	ret = misc_register(&pkt_misc);
 	if (ret) {
-		printk(DRIVER_NAME": Unable to register misc device\n");
+		pr_err("unable to register misc device\n");
 		goto out_misc;
 	}
 
-- 
1.8.1.2.459.gbcd45b4.dirty

