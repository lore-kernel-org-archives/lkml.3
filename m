Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754854AbaJWT35 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 15:29:57 -0400
Received: from mail.cybernetics.com ([173.71.130.66]:54210 "EHLO
	mail.cybernetics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751148AbaJWT34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 15:29:56 -0400
X-Greylist: delayed 1174 seconds by postgrey-1.27 at vger.kernel.org; Thu, 23 Oct 2014 15:29:56 EDT
Message-ID: <5449529D.5070804@cybernetics.com>
Date: Thu, 23 Oct 2014 15:10:21 -0400
From: Tony Battersby <tonyb@cybernetics.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        Jens Axboe <axboe@kernel.dk>
CC: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: [PATCH] lib/scatterlist: fix memory leak with scsi-mq
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a memory leak with scsi-mq triggered by commands with large data
transfer length.

Fixes: c53c6d6a68b1 ("scatterlist: allow chaining to preallocated chunks")
Cc: <stable@vger.kernel.org> # 3.17.x
Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
---

For inclusion in 3.18 and 3.17.x.

--- a/lib/scatterlist.c	2014-10-23 13:32:27.000000000 -0400
+++ b/lib/scatterlist.c	2014-10-23 13:32:36.000000000 -0400
@@ -203,10 +203,10 @@ void __sg_free_table(struct sg_table *ta
 		}
 
 		table->orig_nents -= sg_size;
-		if (!skip_first_chunk) {
-			free_fn(sgl, alloc_size);
+		if (skip_first_chunk)
 			skip_first_chunk = false;
-		}
+		else
+			free_fn(sgl, alloc_size);
 		sgl = next;
 	}
 

