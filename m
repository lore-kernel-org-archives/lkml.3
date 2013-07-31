Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752114Ab3GaEQq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 00:16:46 -0400
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:34985 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750771Ab3GaEQC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 00:16:02 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApgDAKOO+FF5LPxHgWdsb2JhbABbwz0XDgEBFiYogiQBAQUnLyMQCBgxOQMbGYgPuGqQG4NzA6xRKg
From: Dave Chinner <david@fromorbit.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, davej@redhat.com,
        viro@zeniv.linux.org.uk, jack@suse.cz, glommer@parallels.com
Subject: [PATCH 01/11] writeback: plug writeback at a high level
Date: Wed, 31 Jul 2013 14:15:40 +1000
Message-Id: <1375244150-27296-2-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1375244150-27296-1-git-send-email-david@fromorbit.com>
References: <1375244150-27296-1-git-send-email-david@fromorbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Doing writeback on lots of little files causes terrible IOPS storms
because of the per-mapping writeback plugging we do. This
essentially causes imeediate dispatch of IO for each mapping,
regardless of the context in which writeback is occurring.

IOWs, running a concurrent write-lots-of-small 4k files using fsmark
on XFS results in a huge number of IOPS being issued for data
writes.  Metadata writes are sorted and plugged at a high level by
XFS, so aggregate nicely into large IOs. However, data writeback IOs
are dispatched in individual 4k IOs, even when the blocks of two
consecutively written files are adjacent.

Test VM: 8p, 8GB RAM, 4xSSD in RAID0, 100TB sparse XFS filesystem,
metadata CRCs enabled.

Kernel: 3.10-rc5 + xfsdev + my 3.11 xfs queue (~70 patches)

Test:

$ ./fs_mark  -D  10000  -S0  -n  10000  -s  4096  -L  120  -d
/mnt/scratch/0  -d  /mnt/scratch/1  -d  /mnt/scratch/2  -d
/mnt/scratch/3  -d  /mnt/scratch/4  -d  /mnt/scratch/5  -d
/mnt/scratch/6  -d  /mnt/scratch/7

Result:

		wall	sys	create rate	Physical write IO
		time	CPU	(avg files/s)	 IOPS	Bandwidth
		-----	-----	------------	------	---------
unpatched	6m56s	15m47s	24,000+/-500	26,000	130MB/s
patched		5m06s	13m28s	32,800+/-600	 1,500	180MB/s
improvement	-26.44%	-14.68%	  +36.67%	-94.23%	+38.46%

If I use zero length files, this workload at about 500 IOPS, so
plugging drops the data IOs from roughly 25,500/s to 1000/s.
3 lines of code, 35% better throughput for 15% less CPU.

The benefits of plugging at this layer are likely to be higher for
spinning media as the IO patterns for this workload are going make a
much bigger difference on high IO latency devices.....

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/fs-writeback.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 68851ff..1d23d9a 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -589,7 +589,9 @@ static long writeback_sb_inodes(struct super_block *sb,
 	unsigned long start_time = jiffies;
 	long write_chunk;
 	long wrote = 0;  /* count both pages and inodes */
+	struct blk_plug plug;
 
+	blk_start_plug(&plug);
 	while (!list_empty(&wb->b_io)) {
 		struct inode *inode = wb_inode(wb->b_io.prev);
 
@@ -686,6 +688,7 @@ static long writeback_sb_inodes(struct super_block *sb,
 				break;
 		}
 	}
+	blk_finish_plug(&plug);
 	return wrote;
 }
 
-- 
1.8.3.2

