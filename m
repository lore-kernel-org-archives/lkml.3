Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752172AbaASKiG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jan 2014 05:38:06 -0500
Received: from mail.linux-iscsi.org ([67.23.28.174]:51129 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752046AbaASKhe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jan 2014 05:37:34 -0500
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Kent Overstreet <kmo@daterainc.com>, Jens Axboe <axboe@kernel.dk>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 2/5] blk-mq: Update percpu_ida_alloc to use task state bitmask
Date: Sun, 19 Jan 2014 10:16:53 +0000
Message-Id: <1390126616-29560-3-git-send-email-nab@linux-iscsi.org>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1390126616-29560-1-git-send-email-nab@linux-iscsi.org>
References: <1390126616-29560-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch updates percpu_ida_alloc() usage within blk-mq tag
allocation code to use TASK_UNINTERRUPTIBLE (may sleep) or
ASK_RUNNING (cannot sleep), following the changes to percpu_ida
to allow for task state bitmask to be passed from the caller.

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: <stable@vger.kernel.org> #3.13+
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 block/blk-mq-tag.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
index d64a02f..5d70edc 100644
--- a/block/blk-mq-tag.c
+++ b/block/blk-mq-tag.c
@@ -36,7 +36,8 @@ static unsigned int __blk_mq_get_tag(struct blk_mq_tags *tags, gfp_t gfp)
 {
 	int tag;
 
-	tag = percpu_ida_alloc(&tags->free_tags, gfp);
+	tag = percpu_ida_alloc(&tags->free_tags, (gfp & __GFP_WAIT) ?
+			       TASK_UNINTERRUPTIBLE : TASK_RUNNING);
 	if (tag < 0)
 		return BLK_MQ_TAG_FAIL;
 	return tag + tags->nr_reserved_tags;
@@ -52,7 +53,8 @@ static unsigned int __blk_mq_get_reserved_tag(struct blk_mq_tags *tags,
 		return BLK_MQ_TAG_FAIL;
 	}
 
-	tag = percpu_ida_alloc(&tags->reserved_tags, gfp);
+	tag = percpu_ida_alloc(&tags->reserved_tags, (gfp & __GFP_WAIT) ?
+			       TASK_UNINTERRUPTIBLE : TASK_RUNNING);
 	if (tag < 0)
 		return BLK_MQ_TAG_FAIL;
 	return tag;
-- 
1.7.10.4

