Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753881Ab3ITDGP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 23:06:15 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:41078 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752067Ab3ITDGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 23:06:14 -0400
Date: Thu, 19 Sep 2013 20:06:02 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
To: Kent Overstreet <kmo@daterainc.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mgorman@suse.de>, Jens Axboe <axboe@kernel.dk>,
        Jan Kara <jack@suse.cz>, Hannes Reinecke <hare@suse.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] mm: Fix a regression where MS_SNAP_STABLE (stable pages
 snapshotting) was ignored
Message-ID: <20130920030602.GC4565@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "force" parameter in __blk_queue_bounce was being ignored, which means that
stable page snapshots are not always happening (on ext3).  This of course
leads to DIF disks reporting checksum errors, so fix this regression.

The regression was introduced in commit 6bc454d1 (bounce: Refactor
__blk_queue_bounce to not use bi_io_vec)

Reported-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 mm/bounce.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/bounce.c b/mm/bounce.c
index c9f0a43..5a7d58f 100644
--- a/mm/bounce.c
+++ b/mm/bounce.c
@@ -204,6 +204,8 @@ static void __blk_queue_bounce(struct request_queue *q, struct bio **bio_orig,
 	struct bio_vec *to, *from;
 	unsigned i;
 
+	if (force)
+		goto bounce;
 	bio_for_each_segment(from, *bio_orig, i)
 		if (page_to_pfn(from->bv_page) > queue_bounce_pfn(q))
 			goto bounce;
