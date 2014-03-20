Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760035AbaCTVEG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 17:04:06 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:29537 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759365AbaCTVEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 17:04:04 -0400
Date: Thu, 20 Mar 2014 15:03:58 -0600
From: Jens Axboe <axboe@fb.com>
To: <torvalds@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>
Subject: [PATCH] block: free q->flush_rq in blk_init_allocated_queue error
 paths
Message-ID: <20140320210358.GA14059@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-Originating-IP: [192.168.57.29]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.87,1.0.14,0.0.0000
 definitions=2014-03-20_04:2014-03-20,2014-03-20,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0
 kscore.is_bulkscore=7.90038884312949e-09 kscore.compositescore=0
 circleOfTrustscore=7.0302659978126 compositescore=0.998049563855454
 urlsuspect_oldscore=0.998049563855454 suspectscore=10
 recipient_domain_to_sender_totalscore=0 phishscore=0 bulkscore=0
 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=64355
 rbsscore=0.998049563855454 spamscore=0
 recipient_to_sender_domain_totalscore=0 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1403200124
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Turns out there was a potential leak in the error path of the flush
fixup from the last pull, which Dave Jones spotted.

Can you apply this to your current tree before tagging 3.14? Thanks!

From: Dave Jones <davej@redhat.com>

Commit 7982e90c3a ("block: fix q->flush_rq NULL pointer crash on
dm-mpath flush") moved an allocation to blk_init_allocated_queue(),
but neglected to free that allocation on the error paths that
follow.

Signed-off-by: Dave Jones <davej@fedoraproject.org>
Acked-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Jens Axboe <axboe@fb.com>

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
 

-- 
Jens Axboe

