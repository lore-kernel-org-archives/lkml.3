Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933435AbaKLBe1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:34:27 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59606 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933394AbaKLBeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:34:17 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Tony Battersby <tonyb@cybernetics.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@fb.com>
Subject: [PATCH 3.17 250/319] lib/scatterlist: fix memory leak with scsi-mq
Date: Wed, 12 Nov 2014 10:16:28 +0900
Message-Id: <20141112011034.143366246@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112010952.553519040@linuxfoundation.org>
References: <20141112010952.553519040@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tony Battersby <tonyb@cybernetics.com>

commit c21e59d8dc04b2107bdb4ff0f412a9b7ae3349f3 upstream.

Fix a memory leak with scsi-mq triggered by commands with large data
transfer length.

Fixes: c53c6d6a68b1 ("scatterlist: allow chaining to preallocated chunks")
Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Jens Axboe <axboe@fb.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 lib/scatterlist.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/lib/scatterlist.c
+++ b/lib/scatterlist.c
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
 


