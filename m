Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760209AbaLLGR6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 01:17:58 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51846 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759489AbaLLGRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 01:17:19 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Dan Carpenter" <dan.carpenter@oracle.com>,
        "Mike Snitzer" <snitzer@redhat.com>,
        "Heinz Mauelshagen" <heinzm@redhat.com>,
        "Liuhua Wang" <lwang@suse.com>
Date: Fri, 12 Dec 2014 06:14:25 +0000
Message-ID: <lsq.1418364865.508869035@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 067/164] dm raid: ensure superblock's size matches
 device's logical block size
In-Reply-To: <lsq.1418364865.554543691@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:c97:8151:cc89:c28d
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.65-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Heinz Mauelshagen <heinzm@redhat.com>

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/md/dm-raid.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -591,8 +591,7 @@ struct dm_raid_superblock {
 	__le32 layout;
 	__le32 stripe_sectors;
 
-	__u8 pad[452];		/* Round struct to 512 bytes. */
-				/* Always set to 0 when writing. */
+	/* Remainder of a logical block is zero-filled when writing (see super_sync()). */
 } __packed;
 
 static int read_disk_sb(struct md_rdev *rdev, int size)
@@ -625,7 +624,7 @@ static void super_sync(struct mddev *mdd
 		if ((r->raid_disk >= 0) && test_bit(Faulty, &r->flags))
 			failed_devices |= (1ULL << r->raid_disk);
 
-	memset(sb, 0, sizeof(*sb));
+	memset(sb + 1, 0, rdev->sb_size - sizeof(*sb));
 
 	sb->magic = cpu_to_le32(DM_RAID_MAGIC);
 	sb->features = cpu_to_le32(0);	/* No features yet */
@@ -660,7 +659,11 @@ static int super_load(struct md_rdev *rd
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

