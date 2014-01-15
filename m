Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752256AbaAOP7J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 10:59:09 -0500
Received: from smtp2-g21.free.fr ([212.27.42.2]:59274 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751941AbaAOP7H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 10:59:07 -0500
From: Nicolas Schichan <nschichan@freebox.fr>
To: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Nicolas Schichan <nschichan@freebox.fr>
Subject: [PATCH] md: check command validity early in md_ioctl().
Date: Wed, 15 Jan 2014 16:58:52 +0100
Message-Id: <1389801532-25567-1-git-send-email-nschichan@freebox.fr>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <20140115125740.160e8998@notabene.brown>
References: <20140115125740.160e8998@notabene.brown>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Verify that the cmd parameter passed to md_ioctl() is valid before
doing anything.

This fixes mddev->hold_active being set to 0 when an invalid ioctl
command is passed to md_ioctl() before the array has been configured.

Clearing mddev->hold_active in that case can lead to a livelock
situation when an invalid ioctl number is given to md_ioctl() by a
process when the mddev is currently being opened by another process:

Process 1				Process 2
---------				---------

md_alloc()
  mddev_find()
  -> returns a new mddev with
     hold_active == UNTIL_IOCTL
  add_disk()
  -> sends KOBJ_ADD uevent

					(sees KOBJ_ADD uevent for device)
                    			md_open()
                    			md_ioctl(INVALID_IOCTL)
                    			-> returns ENODEV and clears
                       			   mddev->hold_active
                    			md_release()
                      			md_put()
                      			-> deletes the mddev as
                         		   hold_active is 0

md_open()
  mddev_find()
  -> returns a newly
    allocated mddev with
    mddev->gendisk == NULL
-> returns with ERESTARTSYS
   (kernel restarts the open syscall)

Signed-off-by: Nicolas Schichan <nschichan@freebox.fr>
---

A couple of notes:

This patch is based on linux 3.13-rc8.

The following  MD ioctl constants are  defined in md_u.h  but not used
anywhere else, so are not accepted as valid ioctl commands:

CLEAR_ARRAY
SET_DISK_INFO
WRITE_RAID_INFO
UNPROTECT_ARRAY
PROTECT_ARRAY


 drivers/md/md.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 21f4d7f..941ac65 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6328,6 +6328,32 @@ static int md_getgeo(struct block_device *bdev, struct hd_geometry *geo)
 	return 0;
 }
 
+static inline bool md_ioctl_valid(unsigned int cmd)
+{
+	switch (cmd) {
+	case ADD_NEW_DISK:
+	case BLKROSET:
+	case GET_ARRAY_INFO:
+	case GET_BITMAP_FILE:
+	case GET_DISK_INFO:
+	case HOT_ADD_DISK:
+	case HOT_REMOVE_DISK:
+	case PRINT_RAID_DEBUG:
+	case RAID_AUTORUN:
+	case RAID_VERSION:
+	case RESTART_ARRAY_RW:
+	case RUN_ARRAY:
+	case SET_ARRAY_INFO:
+	case SET_BITMAP_FILE:
+	case SET_DISK_FAULTY:
+	case STOP_ARRAY:
+	case STOP_ARRAY_RO:
+		return true;
+	default:
+		return false;
+	}
+}
+
 static int md_ioctl(struct block_device *bdev, fmode_t mode,
 			unsigned int cmd, unsigned long arg)
 {
@@ -6336,6 +6362,9 @@ static int md_ioctl(struct block_device *bdev, fmode_t mode,
 	struct mddev *mddev = NULL;
 	int ro;
 
+	if (!md_ioctl_valid(cmd))
+		return -ENOTTY;
+
 	switch (cmd) {
 	case RAID_VERSION:
 	case GET_ARRAY_INFO:
-- 
1.8.3.2

