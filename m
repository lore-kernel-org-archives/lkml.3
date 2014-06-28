Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755638AbaF1Ruy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 13:50:54 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53706 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755600AbaF1Ruv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 13:50:51 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Chris Murphy <lists@colorremedies.com>, Liu Bo <bo.li.liu@oracle.com>,
        Chris Mason <clm@fb.com>
Subject: [PATCH 3.14 095/110] Btrfs: fix NULL pointer crash of deleting a seed device
Date: Sat, 28 Jun 2014 10:47:32 -0700
Message-Id: <20140628174551.104913978@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140628174545.354748696@linuxfoundation.org>
References: <20140628174545.354748696@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liu Bo <bo.li.liu@oracle.com>

commit 29cc83f69c8338ff8fd1383c9be263d4bdf52d73 upstream.

Same as normal devices, seed devices should be initialized with
fs_info->dev_root as well, otherwise we'll get a NULL pointer crash.

Cc: Chris Murphy <lists@colorremedies.com>
Reported-by: Chris Murphy <lists@colorremedies.com>
Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
Signed-off-by: Chris Mason <clm@fb.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/volumes.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -6057,10 +6057,14 @@ void btrfs_init_devices_late(struct btrf
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


