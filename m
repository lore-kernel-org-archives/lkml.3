Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759189AbaGXK25 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 06:28:57 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54589 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758082AbaGXJqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 05:46:40 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Wang Shilong <wangsl.fnst@cn.fujitsu.com>, Chris Mason <clm@fb.com>,
        David Sterba <dsterba@suse.cz>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 009/128] Btrfs: set right total device count for seeding support
Date: Thu, 24 Jul 2014 10:44:18 +0100
Message-Id: <1406195177-8656-10-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
References: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>

commit 298658414a2f0bea1f05a81876a45c1cd96aa2e0 upstream.

Seeding device support allows us to create a new filesystem
based on existed filesystem.

However newly created filesystem's @total_devices should include seed
devices. This patch fix the following problem:

 # mkfs.btrfs -f /dev/sdb
 # btrfstune -S 1 /dev/sdb
 # mount /dev/sdb /mnt
 # btrfs device add -f /dev/sdc /mnt --->fs_devices->total_devices = 1
 # umount /mnt
 # mount /dev/sdc /mnt               --->fs_devices->total_devices = 2

This is because we record right @total_devices in superblock, but
@fs_devices->total_devices is reset to be 0 in btrfs_prepare_sprout().

Fix this problem by not resetting @fs_devices->total_devices.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Signed-off-by: Chris Mason <clm@fb.com>
Cc: David Sterba <dsterba@suse.cz>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/btrfs/volumes.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index f79b027fa0f1..ca9a51400035 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1844,7 +1844,6 @@ static int btrfs_prepare_sprout(struct btrfs_root *root)
 	fs_devices->seeding = 0;
 	fs_devices->num_devices = 0;
 	fs_devices->open_devices = 0;
-	fs_devices->total_devices = 0;
 	fs_devices->seed = seed_devices;
 
 	generate_random_uuid(fs_devices->fsid);
-- 
1.9.1

