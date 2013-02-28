Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760126Ab3B1PIE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 10:08:04 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42243 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758493Ab3B1Osv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 09:48:51 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: MITSUNARI Shigeo <herumi@nifty.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Jeff Moyer <jmoyer@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 072/139] fs/block_dev.c: page cache wrongly left invalidated after revalidate_disk()
Date: Thu, 28 Feb 2013 14:43:42 +0000
Message-Id: <1362062689-2567-73-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
References: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: MITSUNARI Shigeo <herumi@nifty.com>

commit 7630b661da330b35dd57b6f5d6d62b386f2dd751 upstream.

We found that bdev->bd_invalidated was left set once revalidate_disk()
is called, which results in page cache flush every time that device is
open.

Specifically, we found this problem in MD block device.  Once we resize
a MD device, mdadm --monitor periodically flush all page cache for that
device every 60 or 1000 seconds when it opens the device.

This bug lies since at least 3.2.0 till the latest kernel(3.6.2).  Patch
is attached.

The following steps will reproduce the problem.

1. prepair a block device (eg /dev/sdb).

2. create two partitions:

   sudo parted /dev/sdb
   mklabel gpt
   mkpart primary 0% 50%
   mkpart primary 50% 100%

3. create a md device.

   sudo mdadm -C /dev/md/hoge -l 1 -n 2 -e 1.2 --assume-clean --auto=md --symlink=no /dev/sdb1 /dev/sdb2

4. create file system and mount it

   sudo mkfs.ext3 /dev/md/hoge
   sudo mkdir /mnt/test
   sudo mount /dev/md/hoge /mnt/test

5. try to resize the device

   sudo mdadm -G /dev/md/hoge --size=max

6. create a file to fill file cache.

  sudo dd if=/dev/urandom of=/mnt/test/data bs=1M count=10

and verify the current status of file by free command.

7. mdadm monitor will open the md device every 1000 seconds and you
   will find all file cache on the device are cleared.

The timing can be reduced by the following steps.

a) kill mdadm and restart it with --delay option

   /sbin/mdadm --monitor --delay=30 --pid-file /var/run/mdadm/monitor.pid --daemonise --scan --syslog

or open the md device directly.

   sudo dd if=/dev/md/hoge of=/dev/null bs=4096 count=1

Signed-off-by: MITSUNARI Shigeo <herumi@nifty.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/block_dev.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index c2bbe1f..db64e31 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1047,6 +1047,7 @@ int revalidate_disk(struct gendisk *disk)
 
 	mutex_lock(&bdev->bd_mutex);
 	check_disk_size_change(disk, bdev);
+	bdev->bd_invalidated = 0;
 	mutex_unlock(&bdev->bd_mutex);
 	bdput(bdev);
 	return ret;
-- 
1.8.1.2

