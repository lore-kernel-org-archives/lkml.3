Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758576Ab3J2Raw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 13:30:52 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:56125 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758129Ab3J2Rav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 13:30:51 -0400
Date: Wed, 30 Oct 2013 01:30:47 +0800
From: Shaohua Li <shli@kernel.org>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org
Subject: [patch]blk-mq: mq plug list breakage
Message-ID: <20131029173047.GA12405@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We switched to plug mq_list for mq, but some code are still using old list.

Signed-off-by: Shaohua Li <shli@fusionio.com>
---
 block/blk-core.c |    8 +++++++-
 block/blk-mq.c   |    2 +-
 2 files changed, 8 insertions(+), 2 deletions(-)

Index: linux/block/blk-core.c
===================================================================
--- linux.orig/block/blk-core.c	2013-10-29 11:26:16.556586892 -0600
+++ linux/block/blk-core.c	2013-10-29 11:26:21.014356939 -0600
@@ -1411,6 +1411,7 @@
 	struct blk_plug *plug;
 	struct request *rq;
 	bool ret = false;
+	struct list_head *plug_list;
 
 	if (blk_queue_nomerges(q))
 		goto out;
@@ -1420,7 +1421,12 @@
 		goto out;
 	*request_count = 0;
 
-	list_for_each_entry_reverse(rq, &plug->list, queuelist) {
+	if (q->mq_ops)
+		plug_list = &plug->mq_list;
+	else
+		plug_list = &plug->list;
+
+	list_for_each_entry_reverse(rq, plug_list, queuelist) {
 		int el_ret;
 
 		if (rq->q == q)
Index: linux/block/blk-mq.c
===================================================================
--- linux.orig/block/blk-mq.c	2013-10-29 11:26:16.556586892 -0600
+++ linux/block/blk-mq.c	2013-10-29 11:26:21.014356939 -0600
@@ -950,7 +950,7 @@
 
 		if (plug) {
 			blk_mq_bio_to_request(rq, bio);
-			if (list_empty(&plug->list))
+			if (list_empty(&plug->mq_list))
 				trace_block_plug(q);
 			else if (request_count >= BLK_MAX_REQUEST_COUNT) {
 				blk_flush_plug_list(plug, false);
