Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753505AbaENVf7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 17:35:59 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:54752 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753002AbaENVfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 17:35:25 -0400
From: Seth Forshee <seth.forshee@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>, Arnd Bergmann <arnd@arndb.de>,
        Eric Biederman <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        lxc-devel@lists.linuxcontainers.org,
        Seth Forshee <seth.forshee@canonical.com>
Subject: [RFC PATCH 10/11] loop: Assign devices to current_user_ns()
Date: Wed, 14 May 2014 16:34:58 -0500
Message-Id: <1400103299-144589-11-git-send-email-seth.forshee@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1400103299-144589-1-git-send-email-seth.forshee@canonical.com>
References: <1400103299-144589-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

loop-control is now global to user namespaces, meaning that any
namespace can use LOOP_CTL_GET_FREE to request a loop device. The
namespace won't necessarily be able to use the device, however.

Update loop to search only for devices matching current_user_ns()
when finding free devices, and to set the device's owning
namespace to current_user_ns() when a new device is added. This
will cause the devices to appear in that namespace's devtmpfs
super block, where it can be used.

This should generally be safe, since only the namespace used to
request the device should see it in devtmpfs, avoiding accidental
use by another namespace. Only a user priveleged enough to mknod
will be able to access the same device, and such access is
unlikely to be accidental.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 drivers/block/loop.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index f0e41a372c24..66bd938bcc1c 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -75,6 +75,8 @@
 #include <linux/sysfs.h>
 #include <linux/miscdevice.h>
 #include <linux/falloc.h>
+#include <linux/notifier.h>
+#include <linux/user_namespace.h>
 #include "loop.h"
 
 #include <asm/uaccess.h>
@@ -1674,6 +1676,7 @@ static int loop_add(struct loop_device **l, int i)
 	disk->private_data	= lo;
 	disk->queue		= lo->lo_queue;
 	sprintf(disk->disk_name, "loop%d", i);
+	dev_set_ns(disk_to_dev(disk), current_user_ns());
 	add_disk(disk);
 	*l = lo;
 	return lo->lo_number;
@@ -1690,6 +1693,7 @@ out:
 
 static void loop_remove(struct loop_device *lo)
 {
+	dev_set_ns(disk_to_dev(lo->lo_disk), &init_user_ns);
 	del_gendisk(lo->lo_disk);
 	blk_cleanup_queue(lo->lo_queue);
 	put_disk(lo->lo_disk);
@@ -1701,7 +1705,8 @@ static int find_free_cb(int id, void *ptr, void *data)
 	struct loop_device *lo = ptr;
 	struct loop_device **l = data;
 
-	if (lo->lo_state == Lo_unbound) {
+	if (lo->lo_state == Lo_unbound &&
+	    disk_to_dev(lo->lo_disk)->ns == current_user_ns()) {
 		*l = lo;
 		return 1;
 	}
-- 
1.9.1

