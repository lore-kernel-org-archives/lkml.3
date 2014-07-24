Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759042AbaGXK1a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 06:27:30 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54606 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758232AbaGXJqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 05:46:43 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Chris Murphy <lists@colorremedies.com>, Liu Bo <bo.li.liu@oracle.com>,
        Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.cz>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 007/128] Btrfs: fix NULL pointer crash of deleting a seed device
Date: Thu, 24 Jul 2014 10:44:16 +0100
Message-Id: <1406195177-8656-8-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
References: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liu Bo <bo.li.liu@oracle.com>

commit 29cc83f69c8338ff8fd1383c9be263d4bdf52d73 upstream.

Same as normal devices, seed devices should be initialized with
fs_info->dev_root as well, otherwise we'll get a NULL pointer crash.

Cc: Chris Murphy <lists@colorremedies.com>
Reported-by: Chris Murphy <lists@colorremedies.com>
Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
Signed-off-by: Chris Mason <clm@fb.com>
Cc: David Sterba <dsterba@suse.cz>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/btrfs/volumes.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index cacdb3effa35..f79b027fa0f1 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -5730,10 +5730,14 @@ void btrfs_init_devices_late(struct btrfs_fs_info *fs_info)
 	struct btrfs_fs_devices *fs_devices = fs_info->fs_devices;
 	struct btrfs_device *device;
 
-	mutex_lock(&fs_devices->device_list_mutex);
-	list_for_each_entry(device, &fs_devices->devices, dev_list)
-		device->dev_root = fs_info->dev_root;
-	mutex_unlock(&fs_devices->device_list_mutex);
+	while (fs_devices) {
+		mutex_lock(&fs_devices->device_list_mutex);
+		list_for_each_entry(device, &fs_devices->devices, dev_list)
+			device->dev_root = fs_info->dev_root;
+		mutex_unlock(&fs_devices->device_list_mutex);
+
+		fs_devices = fs_devices->seed;
+	}
 }
 
 static void __btrfs_reset_dev_stats(struct btrfs_device *dev)
-- 
1.9.1

