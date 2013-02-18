Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757425Ab3BRUgQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 15:36:16 -0500
Received: from mail.tpi.com ([70.99.223.143]:2855 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753494Ab3BRUgM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 15:36:12 -0500
From: Tim Gardner <tim.gardner@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: Tim Gardner <tim.gardner@canonical.com>,
        Chirag Kantharia <chirag.kantharia@hp.com>, iss_storagedev@hp.com
Subject: [PATCH linux-next] cpqarray: do_ida_request() - reduce stack frame size
Date: Mon, 18 Feb 2013 13:35:58 -0700
Message-Id: <1361219758-112250-1-git-send-email-tim.gardner@canonical.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

do_ida_request() can be called from within interrupt context.
A stack frame of more then 1K runs the risk of overflowing the
kernel stack. Correct this situation by dynamically allocating
the large (and temporary) scatter/gather array. A failure from kmalloc()
will leave a stack trace in the kernel log.

drivers/block/cpqarray.c: In function ‘do_ida_request’:
drivers/block/cpqarray.c:969:1: warning: the frame size of 1072 bytes is larger than 1024 bytes [-Wframe-larger-than=]

Cc: Chirag Kantharia <chirag.kantharia@hp.com>
Cc: iss_storagedev@hp.com
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 drivers/block/cpqarray.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/block/cpqarray.c b/drivers/block/cpqarray.c
index 3f08713..2715b35 100644
--- a/drivers/block/cpqarray.c
+++ b/drivers/block/cpqarray.c
@@ -908,9 +908,13 @@ static void do_ida_request(struct request_queue *q)
 	ctlr_info_t *h = q->queuedata;
 	cmdlist_t *c;
 	struct request *creq;
-	struct scatterlist tmp_sg[SG_MAX];
+	struct scatterlist *tmp_sg;
 	int i, dir, seg;
 
+	tmp_sg = kmalloc(sizeof(*tmp_sg) * SG_MAX, GFP_ATOMIC);
+	if (!tmp_sg)
+		return;
+
 queue_next:
 	creq = blk_peek_request(q);
 	if (!creq)
@@ -966,6 +970,7 @@ DBGPX(	printk("Submitting %u sectors in %d segments\n", blk_rq_sectors(creq), se
 
 startio:
 	start_io(h);
+	kfree(tmp_sg);
 }
 
 /* 
-- 
1.7.9.5

