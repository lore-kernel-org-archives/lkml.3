Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932470AbaEEMpZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 08:45:25 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:41083 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932341AbaEEMng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 08:43:36 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Josef Bacik <jbacik@fb.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 37/50] Btrfs: skip submitting barrier for missing device
Date: Mon,  5 May 2014 14:43:19 +0200
Message-Id: <d1dc14b5691178bf28297621dc0add0ba5d6b407.1399292849.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <7d4f4737432af6216e86975e587331b9d8b08063.1399292849.git.jslaby@suse.cz>
References: <7d4f4737432af6216e86975e587331b9d8b08063.1399292849.git.jslaby@suse.cz>
In-Reply-To: <cover.1399292849.git.jslaby@suse.cz>
References: <cover.1399292849.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/btrfs/disk-io.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 62176ad89846..84d590a9e4ad 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3246,6 +3246,8 @@ static int barrier_all_devices(struct btrfs_fs_info *info)
 	/* send down all the barriers */
 	head = &info->fs_devices->devices;
 	list_for_each_entry_rcu(dev, head, dev_list) {
+		if (dev->missing)
+			continue;
 		if (!dev->bdev) {
 			errors_send++;
 			continue;
@@ -3260,6 +3262,8 @@ static int barrier_all_devices(struct btrfs_fs_info *info)
 
 	/* wait for all the barriers */
 	list_for_each_entry_rcu(dev, head, dev_list) {
+		if (dev->missing)
+			continue;
 		if (!dev->bdev) {
 			errors_wait++;
 			continue;
-- 
1.9.2

