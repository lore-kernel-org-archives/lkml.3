Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756411AbaDXLk0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 07:40:26 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46402 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753602AbaDXIwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 04:52:50 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Josef Bacik <jbacik@fb.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 037/182] Btrfs: skip submitting barrier for missing device
Date: Thu, 24 Apr 2014 09:49:22 +0100
Message-Id: <1398329507-5911-38-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
References: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>

commit f88ba6a2a44ee98e8d59654463dc157bb6d13c43 upstream.

I got an error on v3.13:
 BTRFS error (device sdf1) in write_all_supers:3378: errno=-5 IO failure (errors while submitting device barriers.)

how to reproduce:
  > mkfs.btrfs -f -d raid1 /dev/sdf1 /dev/sdf2
  > wipefs -a /dev/sdf2
  > mount -o degraded /dev/sdf1 /mnt
  > btrfs balance start -f -sconvert=single -mconvert=single -dconvert=single /mnt

The reason of the error is that barrier_all_devices() failed to submit
barrier to the missing device.  However it is clear that we cannot do
anything on missing device, and also it is not necessary to care chunks
on the missing device.

This patch stops sending/waiting barrier if device is missing.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Signed-off-by: Josef Bacik <jbacik@fb.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/btrfs/disk-io.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 6b092a1..3ce4436 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3190,6 +3190,8 @@ static int barrier_all_devices(struct btrfs_fs_info *info)
 	/* send down all the barriers */
 	head = &info->fs_devices->devices;
 	list_for_each_entry_rcu(dev, head, dev_list) {
+		if (dev->missing)
+			continue;
 		if (!dev->bdev) {
 			errors_send++;
 			continue;
@@ -3204,6 +3206,8 @@ static int barrier_all_devices(struct btrfs_fs_info *info)
 
 	/* wait for all the barriers */
 	list_for_each_entry_rcu(dev, head, dev_list) {
+		if (dev->missing)
+			continue;
 		if (!dev->bdev) {
 			errors_wait++;
 			continue;
-- 
1.9.1

