Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753807AbaLCLt3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 06:49:29 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54664 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752422AbaLCL1V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 06:27:21 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Heinz Mauelshagen <heinzm@redhat.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Mike Snitzer <snitzer@redhat.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 048/101] dm raid: ensure superblock's size matches device's logical block size
Date: Wed,  3 Dec 2014 12:26:10 +0100
Message-Id: <e90b799e47a5d3923e58d8cc11bdff39117580c3.1417605922.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
References: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
In-Reply-To: <cover.1417605922.git.jslaby@suse.cz>
References: <cover.1417605922.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heinz Mauelshagen <heinzm@redhat.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 40d43c4b4cac4c2647bf07110d7b07d35f399a84 upstream.

The dm-raid superblock (struct dm_raid_superblock) is padded to 512
bytes and that size is being used to read it in from the metadata
device into one preallocated page.

Reading or writing this on a 512-byte sector device works fine but on
a 4096-byte sector device this fails.

Set the dm-raid superblock's size to the logical block size of the
metadata device, because IO at that size is guaranteed too work.  Also
add a size check to avoid silent partial metadata loss in case the
superblock should ever grow past the logical block size or PAGE_SIZE.

[includes pointer math fix from Dan Carpenter]
Reported-by: "Liuhua Wang" <lwang@suse.com>
Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/md/dm-raid.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 4880b69e2e9e..59715389b3cf 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -785,8 +785,7 @@ struct dm_raid_superblock {
 	__le32 layout;
 	__le32 stripe_sectors;
 
-	__u8 pad[452];		/* Round struct to 512 bytes. */
-				/* Always set to 0 when writing. */
+	/* Remainder of a logical block is zero-filled when writing (see super_sync()). */
 } __packed;
 
 static int read_disk_sb(struct md_rdev *rdev, int size)
@@ -823,7 +822,7 @@ static void super_sync(struct mddev *mddev, struct md_rdev *rdev)
 		    test_bit(Faulty, &(rs->dev[i].rdev.flags)))
 			failed_devices |= (1ULL << i);
 
-	memset(sb, 0, sizeof(*sb));
+	memset(sb + 1, 0, rdev->sb_size - sizeof(*sb));
 
 	sb->magic = cpu_to_le32(DM_RAID_MAGIC);
 	sb->features = cpu_to_le32(0);	/* No features yet */
@@ -858,7 +857,11 @@ static int super_load(struct md_rdev *rdev, struct md_rdev *refdev)
 	uint64_t events_sb, events_refsb;
 
 	rdev->sb_start = 0;
-	rdev->sb_size = sizeof(*sb);
+	rdev->sb_size = bdev_logical_block_size(rdev->meta_bdev);
+	if (rdev->sb_size < sizeof(*sb) || rdev->sb_size > PAGE_SIZE) {
+		DMERR("superblock size of a logical block is no longer valid");
+		return -EINVAL;
+	}
 
 	ret = read_disk_sb(rdev, rdev->sb_size);
 	if (ret)
-- 
2.1.3

