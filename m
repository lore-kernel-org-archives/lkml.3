Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932579AbaF1SA4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 14:00:56 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54471 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756170AbaF1RxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 13:53:12 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Wang Shilong <wangsl.fnst@cn.fujitsu.com>, Chris Mason <clm@fb.com>
Subject: [PATCH 3.15 123/139] Btrfs: set right total device count for seeding support
Date: Sat, 28 Jun 2014 10:48:04 -0700
Message-Id: <20140628174611.018351343@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140628174605.352098823@linuxfoundation.org>
References: <20140628174605.352098823@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/volumes.c |    1 -
 1 file changed, 1 deletion(-)

--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1903,7 +1903,6 @@ static int btrfs_prepare_sprout(struct b
 	fs_devices->seeding = 0;
 	fs_devices->num_devices = 0;
 	fs_devices->open_devices = 0;
-	fs_devices->total_devices = 0;
 	fs_devices->seed = seed_devices;
 
 	generate_random_uuid(fs_devices->fsid);


