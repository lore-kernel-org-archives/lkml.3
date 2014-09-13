Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751778AbaIMIJu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2014 04:09:50 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:51789 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751703AbaIMIJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2014 04:09:47 -0400
Date: Sat, 13 Sep 2014 11:09:28 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: [patch -next] blk-mq: NULL dereference in __blk_mq_alloc_rq_maps()
Message-ID: <20140913080928.GA6469@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We shouldn't set "set->tags" to NULL here because if we return -ENOMEM
here then we call the function a second time.  On the second time
through the loop then the statement:

	set->tags[i] = blk_mq_init_rq_map(set, i);

will Oops.  Also it is a memory leak and a layering violation.  There is
a correct call to kfree(set->tags) in blk_mq_alloc_tag_set().

Fixes: a516440542af ('blk-mq: scale depth and rq map appropriate if low on memory')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 3d863df..7e7ca57 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1961,7 +1961,6 @@ out_unwind:
 	while (--i >= 0)
 		blk_mq_free_rq_map(set, set->tags[i], i);
 
-	set->tags = NULL;
 	return -ENOMEM;
 }
 
