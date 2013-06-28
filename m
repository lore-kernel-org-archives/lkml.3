Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755263Ab3F1PI6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 11:08:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42393 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751845Ab3F1PI5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 11:08:57 -0400
From: Jan Kara <jack@suse.cz>
To: Jens Axboe <axboe@kernel.dk>
Cc: LKML <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>
Subject: [PATCH] block: Reserve only one queue tag for sync IO if only 3 tags are available
Date: Fri, 28 Jun 2013 17:08:47 +0200
Message-Id: <1372432127-9716-1-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case a device has three tags available we still reserve two of them
for sync IO. That leaves only a single tag for async IO such as
writeback from flusher thread which results in poor performance.

Allow async IO to consume two tags in case queue has three tag availabe
to get a decent async write performance.

This patch improves streaming write performance on a machine with such disk
from ~21 MB/s to ~52 MB/s. Also postmark throughput in presence of
streaming writer improves from 8 to 12 transactions per second so sync
IO doesn't seem to be harmed in presence of heavy async writer.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 block/blk-tag.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/block/blk-tag.c b/block/blk-tag.c
index cc345e1..3f33d86 100644
--- a/block/blk-tag.c
+++ b/block/blk-tag.c
@@ -348,9 +348,16 @@ int blk_queue_start_tag(struct request_queue *q, struct request *rq)
 	 */
 	max_depth = bqt->max_depth;
 	if (!rq_is_sync(rq) && max_depth > 1) {
-		max_depth -= 2;
-		if (!max_depth)
+		switch (max_depth) {
+		case 2:
 			max_depth = 1;
+			break;
+		case 3:
+			max_depth = 2;
+			break;
+		default:
+			max_depth -= 2;
+		}
 		if (q->in_flight[BLK_RW_ASYNC] > max_depth)
 			return 1;
 	}
-- 
1.8.1.4

