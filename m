Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933245Ab3FRQRz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 12:17:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49473 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933229Ab3FRQRw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 12:17:52 -0400
From: Greg Kroah-Hartman <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Stephen M. Cameron" <scameron@beardog.cce.hp.com>,
        Jens Axboe <axboe@kernel.dk>, Mike Miller <mike.miller@hp.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 20/48] cciss: fix broken mutex usage in ioctl
Date: Tue, 18 Jun 2013 09:17:46 -0700
Message-Id: <20130618161728.808376750@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.254.g5578ad7
In-Reply-To: <20130618161725.912524266@linuxfoundation.org>
References: <20130618161725.912524266@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>

commit 03f47e888daf56c8e9046c674719a0bcc644eed5 upstream.

If a new logical drive is added and the CCISS_REGNEWD ioctl is invoked
(as is normal with the Array Configuration Utility) the process will
hang as below.  It attempts to acquire the same mutex twice, once in
do_ioctl() and once in cciss_unlocked_open().  The BKL was recursive,
the mutex isn't.

  Linux version 3.10.0-rc2 (scameron@localhost.localdomain) (gcc version 4.4.7 20120313 (Red Hat 4.4.7-3) (GCC) ) #1 SMP Fri May 24 14:32:12 CDT 2013
  [...]
  acu             D 0000000000000001     0  3246   3191 0x00000080
  Call Trace:
    schedule+0x29/0x70
    schedule_preempt_disabled+0xe/0x10
    __mutex_lock_slowpath+0x17b/0x220
    mutex_lock+0x2b/0x50
    cciss_unlocked_open+0x2f/0x110 [cciss]
    __blkdev_get+0xd3/0x470
    blkdev_get+0x5c/0x1e0
    register_disk+0x182/0x1a0
    add_disk+0x17c/0x310
    cciss_add_disk+0x13a/0x170 [cciss]
    cciss_update_drive_info+0x39b/0x480 [cciss]
    rebuild_lun_table+0x258/0x370 [cciss]
    cciss_ioctl+0x34f/0x470 [cciss]
    do_ioctl+0x49/0x70 [cciss]
    __blkdev_driver_ioctl+0x28/0x30
    blkdev_ioctl+0x200/0x7b0
    block_ioctl+0x3c/0x40
    do_vfs_ioctl+0x89/0x350
    SyS_ioctl+0xa1/0xb0
    system_call_fastpath+0x16/0x1b

This mutex usage was added into the ioctl path when the big kernel lock
was removed.  As it turns out, these paths are all thread safe anyway
(or can easily be made so) and we don't want ioctl() to be single
threaded in any case.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Mike Miller <mike.miller@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/block/cciss.c |   32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -162,8 +162,6 @@ static irqreturn_t do_cciss_msix_intr(in
 static int cciss_open(struct block_device *bdev, fmode_t mode);
 static int cciss_unlocked_open(struct block_device *bdev, fmode_t mode);
 static int cciss_release(struct gendisk *disk, fmode_t mode);
-static int do_ioctl(struct block_device *bdev, fmode_t mode,
-		    unsigned int cmd, unsigned long arg);
 static int cciss_ioctl(struct block_device *bdev, fmode_t mode,
 		       unsigned int cmd, unsigned long arg);
 static int cciss_getgeo(struct block_device *bdev, struct hd_geometry *geo);
@@ -229,7 +227,7 @@ static const struct block_device_operati
 	.owner = THIS_MODULE,
 	.open = cciss_unlocked_open,
 	.release = cciss_release,
-	.ioctl = do_ioctl,
+	.ioctl = cciss_ioctl,
 	.getgeo = cciss_getgeo,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl = cciss_compat_ioctl,
@@ -1138,16 +1136,6 @@ static int cciss_release(struct gendisk
 	return 0;
 }
 
-static int do_ioctl(struct block_device *bdev, fmode_t mode,
-		    unsigned cmd, unsigned long arg)
-{
-	int ret;
-	mutex_lock(&cciss_mutex);
-	ret = cciss_ioctl(bdev, mode, cmd, arg);
-	mutex_unlock(&cciss_mutex);
-	return ret;
-}
-
 #ifdef CONFIG_COMPAT
 
 static int cciss_ioctl32_passthru(struct block_device *bdev, fmode_t mode,
@@ -1174,7 +1162,7 @@ static int cciss_compat_ioctl(struct blo
 	case CCISS_REGNEWD:
 	case CCISS_RESCANDISK:
 	case CCISS_GETLUNINFO:
-		return do_ioctl(bdev, mode, cmd, arg);
+		return cciss_ioctl(bdev, mode, cmd, arg);
 
 	case CCISS_PASSTHRU32:
 		return cciss_ioctl32_passthru(bdev, mode, cmd, arg);
@@ -1214,7 +1202,7 @@ static int cciss_ioctl32_passthru(struct
 	if (err)
 		return -EFAULT;
 
-	err = do_ioctl(bdev, mode, CCISS_PASSTHRU, (unsigned long)p);
+	err = cciss_ioctl(bdev, mode, CCISS_PASSTHRU, (unsigned long)p);
 	if (err)
 		return err;
 	err |=
@@ -1256,7 +1244,7 @@ static int cciss_ioctl32_big_passthru(st
 	if (err)
 		return -EFAULT;
 
-	err = do_ioctl(bdev, mode, CCISS_BIG_PASSTHRU, (unsigned long)p);
+	err = cciss_ioctl(bdev, mode, CCISS_BIG_PASSTHRU, (unsigned long)p);
 	if (err)
 		return err;
 	err |=
@@ -1306,11 +1294,14 @@ static int cciss_getpciinfo(ctlr_info_t
 static int cciss_getintinfo(ctlr_info_t *h, void __user *argp)
 {
 	cciss_coalint_struct intinfo;
+	unsigned long flags;
 
 	if (!argp)
 		return -EINVAL;
+	spin_lock_irqsave(&h->lock, flags);
 	intinfo.delay = readl(&h->cfgtable->HostWrite.CoalIntDelay);
 	intinfo.count = readl(&h->cfgtable->HostWrite.CoalIntCount);
+	spin_unlock_irqrestore(&h->lock, flags);
 	if (copy_to_user
 	    (argp, &intinfo, sizeof(cciss_coalint_struct)))
 		return -EFAULT;
@@ -1351,12 +1342,15 @@ static int cciss_setintinfo(ctlr_info_t
 static int cciss_getnodename(ctlr_info_t *h, void __user *argp)
 {
 	NodeName_type NodeName;
+	unsigned long flags;
 	int i;
 
 	if (!argp)
 		return -EINVAL;
+	spin_lock_irqsave(&h->lock, flags);
 	for (i = 0; i < 16; i++)
 		NodeName[i] = readb(&h->cfgtable->ServerName[i]);
+	spin_unlock_irqrestore(&h->lock, flags);
 	if (copy_to_user(argp, NodeName, sizeof(NodeName_type)))
 		return -EFAULT;
 	return 0;
@@ -1393,10 +1387,13 @@ static int cciss_setnodename(ctlr_info_t
 static int cciss_getheartbeat(ctlr_info_t *h, void __user *argp)
 {
 	Heartbeat_type heartbeat;
+	unsigned long flags;
 
 	if (!argp)
 		return -EINVAL;
+	spin_lock_irqsave(&h->lock, flags);
 	heartbeat = readl(&h->cfgtable->HeartBeat);
+	spin_unlock_irqrestore(&h->lock, flags);
 	if (copy_to_user(argp, &heartbeat, sizeof(Heartbeat_type)))
 		return -EFAULT;
 	return 0;
@@ -1405,10 +1402,13 @@ static int cciss_getheartbeat(ctlr_info_
 static int cciss_getbustypes(ctlr_info_t *h, void __user *argp)
 {
 	BusTypes_type BusTypes;
+	unsigned long flags;
 
 	if (!argp)
 		return -EINVAL;
+	spin_lock_irqsave(&h->lock, flags);
 	BusTypes = readl(&h->cfgtable->BusTypes);
+	spin_unlock_irqrestore(&h->lock, flags);
 	if (copy_to_user(argp, &BusTypes, sizeof(BusTypes_type)))
 		return -EFAULT;
 	return 0;


