Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932214AbaCSTMi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 15:12:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18943 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754420AbaCSTMg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 15:12:36 -0400
Date: Wed, 19 Mar 2014 15:12:21 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: snitzer@redhat.com, axboe@fb.com
Subject: block: free q->flush_rq in blk_init_allocated_queue error paths.
Message-ID: <20140319191221.GA10034@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	snitzer@redhat.com, axboe@fb.com
References: <20140318010053.D08A2660CC5@gitolite.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140318010053.D08A2660CC5@gitolite.kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 7982e90c3a ("block: fix q->flush_rq NULL pointer crash on dm-mpath flush")
moved an allocation to blk_init_allocated_queue(), but neglected to free
that allocation on the error paths that follow.

Signed-off-by: Dave Jones <davej@fedoraproject.org>

diff --git a/block/blk-core.c b/block/blk-core.c
index 4cd5ffc18442..bfe16d5af9f9 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -713,7 +713,7 @@ blk_init_allocated_queue(struct request_queue *q, request_fn_proc *rfn,
 		return NULL;
 
 	if (blk_init_rl(&q->root_rl, q, GFP_KERNEL))
-		return NULL;
+		goto fail;
 
 	q->request_fn		= rfn;
 	q->prep_rq_fn		= NULL;
@@ -737,12 +737,16 @@ blk_init_allocated_queue(struct request_queue *q, request_fn_proc *rfn,
 	/* init elevator */
 	if (elevator_init(q, NULL)) {
 		mutex_unlock(&q->sysfs_lock);
-		return NULL;
+		goto fail;
 	}
 
 	mutex_unlock(&q->sysfs_lock);
 
 	return q;
+
+fail:
+	kfree(q->flush_rq);
+	return NULL;
 }
 EXPORT_SYMBOL(blk_init_allocated_queue);
 
