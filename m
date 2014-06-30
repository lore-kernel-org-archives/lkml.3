Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756198AbaF3Mtr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 08:49:47 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:53045 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753290AbaF3Mad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 08:30:33 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Wang Shilong <wangsl.fnst@cn.fujitsu.com>,
        Chris Mason <clm@fb.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 169/181] Btrfs: set right total device count for seeding support
Date: Mon, 30 Jun 2014 13:53:10 +0200
Message-Id: <e4de74491ca5c9db7496ab2750efe1c9e5a241ba.1404128998.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
References: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
In-Reply-To: <cover.1404128997.git.jslaby@suse.cz>
References: <cover.1404128997.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/btrfs/volumes.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index f0f50531c6c3..c06616106fa9 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1889,7 +1889,6 @@ static int btrfs_prepare_sprout(struct btrfs_root *root)
 	fs_devices->seeding = 0;
 	fs_devices->num_devices = 0;
 	fs_devices->open_devices = 0;
-	fs_devices->total_devices = 0;
 	fs_devices->seed = seed_devices;
 
 	generate_random_uuid(fs_devices->fsid);
-- 
2.0.0

