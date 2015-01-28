Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934551AbbA1EZS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 23:25:18 -0500
Received: from mail.kernel.org ([198.145.29.136]:41001 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965190AbbA1EZO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 23:25:14 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Heinz Mauelshagen <heinzm@redhat.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Mike Snitzer <snitzer@redhat.com>, Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 146/177] dm raid: ensure superblock's size matches device's logical block size
Date: Wed, 28 Jan 2015 12:10:04 +0800
Message-Id: <1422418236-12852-237-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422418050-12581-1-git-send-email-lizf@kernel.org>
References: <1422418050-12581-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heinz Mauelshagen <heinzm@redhat.com>

3.4.106-rc1 review patch.  If anyone has any objections, please let me know.

------------------


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
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 drivers/md/dm-raid.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index ead5ca9..5dea02c 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -592,8 +592,7 @@ struct dm_raid_superblock {
 	__le32 layout;
 	__le32 stripe_sectors;
 
-	__u8 pad[452];		/* Round struct to 512 bytes. */
-				/* Always set to 0 when writing. */
+	/* Remainder of a logical block is zero-filled when writing (see super_sync()). */
 } __packed;
 
 static int read_disk_sb(struct md_rdev *rdev, int size)
@@ -628,7 +627,7 @@ static void super_sync(struct mddev *mddev, struct md_rdev *rdev)
 		if ((r->raid_disk >= 0) && test_bit(Faulty, &r->flags))
 			failed_devices |= (1ULL << r->raid_disk);
 
-	memset(sb, 0, sizeof(*sb));
+	memset(sb + 1, 0, rdev->sb_size - sizeof(*sb));
 
 	sb->magic = cpu_to_le32(DM_RAID_MAGIC);
 	sb->features = cpu_to_le32(0);	/* No features yet */
@@ -663,7 +662,11 @@ static int super_load(struct md_rdev *rdev, struct md_rdev *refdev)
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
1.9.1

