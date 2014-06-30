Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756638AbaF3Mv3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 08:51:29 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:53045 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751802AbaF3Ma3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 08:30:29 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Liu Bo <bo.li.liu@oracle.com>,
        Chris Murphy <lists@colorremedies.com>, Chris Mason <clm@fb.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 167/181] Btrfs: fix NULL pointer crash of deleting a seed device
Date: Mon, 30 Jun 2014 13:53:08 +0200
Message-Id: <9aabe7c428154829cd641be727da4523840990c2.1404128998.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
References: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
In-Reply-To: <cover.1404128997.git.jslaby@suse.cz>
References: <cover.1404128997.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Liu Bo <bo.li.liu@oracle.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 29cc83f69c8338ff8fd1383c9be263d4bdf52d73 upstream.

Same as normal devices, seed devices should be initialized with
fs_info->dev_root as well, otherwise we'll get a NULL pointer crash.

Cc: Chris Murphy <lists@colorremedies.com>
Reported-by: Chris Murphy <lists@colorremedies.com>
Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
Signed-off-by: Chris Mason <clm@fb.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/btrfs/volumes.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 258cd6ec3bd2..f0f50531c6c3 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -6051,10 +6051,14 @@ void btrfs_init_devices_late(struct btrfs_fs_info *fs_info)
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
2.0.0

