Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753843Ab3A2HNw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 02:13:52 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40539 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752506Ab3A2HMG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 02:12:06 -0500
From: Hannes Reinecke <hare@suse.de>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, Stefan Weinhuber <wein@de.ibm.com>,
        Hannes Reinecke <hare@suse.de>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7/9] block: check for timeout function in blk_rq_timed_out()
Date: Tue, 29 Jan 2013 08:11:59 +0100
Message-Id: <1359443521-24670-8-git-send-email-hare@suse.de>
X-Mailer: git-send-email 1.7.4.2
In-Reply-To: <1359443521-24670-1-git-send-email-hare@suse.de>
References: <1359443521-24670-1-git-send-email-hare@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rq_timed_out_fn might have been unset while the request
was in flight, so we need to check for it in blk_rq_timed_out().

Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 block/blk-timeout.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/block/blk-timeout.c b/block/blk-timeout.c
index 6e4744c..65f1035 100644
--- a/block/blk-timeout.c
+++ b/block/blk-timeout.c
@@ -82,9 +82,10 @@ void blk_delete_timer(struct request *req)
 static void blk_rq_timed_out(struct request *req)
 {
 	struct request_queue *q = req->q;
-	enum blk_eh_timer_return ret;
+	enum blk_eh_timer_return ret = BLK_EH_RESET_TIMER;
 
-	ret = q->rq_timed_out_fn(req);
+	if (q->rq_timed_out_fn)
+		ret = q->rq_timed_out_fn(req);
 	switch (ret) {
 	case BLK_EH_HANDLED:
 		__blk_complete_request(req);
-- 
1.7.4.2

