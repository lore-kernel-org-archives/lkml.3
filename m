Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752584Ab3IQLFI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 07:05:08 -0400
Received: from TYO200.gate.nec.co.jp ([202.32.8.215]:63267 "EHLO
	tyo200.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752471Ab3IQLFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 07:05:06 -0400
X-Greylist: delayed 363 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 Sep 2013 07:05:06 EDT
Message-ID: <523835AD.1030300@ce.jp.nec.com>
Date: Tue, 17 Sep 2013 19:57:49 +0900
From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
CC: device-mapper development <dm-devel@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Frank Mayhar <fmayhar@google.com>, Mike Snitzer <snitzer@redhat.com>,
        Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] block: Add nr_bios to block_rq_remap tracepoint
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding the number of bios in a remapped request to 'block_rq_remap'
tracepoint.

Request remapper clones bios in a request to track the completion
status of each bio. So the number of bios can be useful information
for investigation.

Related discussions:
  http://www.redhat.com/archives/dm-devel/2013-August/msg00084.html
  http://www.redhat.com/archives/dm-devel/2013-September/msg00024.html

Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Acked-by: Mike Snitzer <snitzer@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>

diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 2fdb4a4..0e6f765 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -862,6 +862,17 @@ static inline unsigned int blk_rq_get_max_sectors(struct request *rq)
 	return blk_queue_get_max_sectors(q, rq->cmd_flags);
 }
 
+static inline unsigned int blk_rq_count_bios(struct request *rq)
+{
+	unsigned int nr_bios = 0;
+	struct bio *bio;
+
+	__rq_for_each_bio(bio, rq)
+		nr_bios++;
+
+	return nr_bios;
+}
+
 /*
  * Request issue related functions.
  */
diff --git a/include/trace/events/block.h b/include/trace/events/block.h
index 60ae7c3..4c2301d 100644
--- a/include/trace/events/block.h
+++ b/include/trace/events/block.h
@@ -618,6 +618,7 @@ TRACE_EVENT(block_rq_remap,
 		__field( unsigned int,	nr_sector	)
 		__field( dev_t,		old_dev		)
 		__field( sector_t,	old_sector	)
+		__field( unsigned int,	nr_bios		)
 		__array( char,		rwbs,	RWBS_LEN)
 	),
 
@@ -627,15 +628,16 @@ TRACE_EVENT(block_rq_remap,
 		__entry->nr_sector	= blk_rq_sectors(rq);
 		__entry->old_dev	= dev;
 		__entry->old_sector	= from;
+		__entry->nr_bios	= blk_rq_count_bios(rq);
 		blk_fill_rwbs(__entry->rwbs, rq->cmd_flags, blk_rq_bytes(rq));
 	),
 
-	TP_printk("%d,%d %s %llu + %u <- (%d,%d) %llu",
+	TP_printk("%d,%d %s %llu + %u <- (%d,%d) %llu %u",
 		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->rwbs,
 		  (unsigned long long)__entry->sector,
 		  __entry->nr_sector,
 		  MAJOR(__entry->old_dev), MINOR(__entry->old_dev),
-		  (unsigned long long)__entry->old_sector)
+		  (unsigned long long)__entry->old_sector, __entry->nr_bios)
 );
 
 #endif /* _TRACE_BLOCK_H */
