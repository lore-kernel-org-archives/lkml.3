Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756226AbaEDQWm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 12:22:42 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36382 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754340AbaEDPmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 11:42:10 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Kent Overstreet <kmo@daterainc.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>, Jens Axboe <axboe@fb.com>
Subject: [PATCH 3.14 147/158] block: Fix for_each_bvec()
Date: Sun,  4 May 2014 11:40:56 -0400
Message-Id: <20140504154050.002033457@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140504154029.975081050@linuxfoundation.org>
References: <20140504154029.975081050@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Martin K. Petersen" <martin.petersen@oracle.com>

commit b7aa84d9cb9f26da1a9312c3e39dbd1a3c25a426 upstream.

Commit 4550dd6c6b062 introduced for_each_bvec() which iterates over each
bvec attached to a bio or bip. However, the macro fails to check bi_size
before dereferencing which can lead to crashes while counting/mapping
integrity scatterlist segments.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Kent Overstreet <kmo@daterainc.com>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Jens Axboe <axboe@fb.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/bio.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -216,9 +216,9 @@ static inline void bvec_iter_advance(str
 }
 
 #define for_each_bvec(bvl, bio_vec, iter, start)			\
-	for ((iter) = start;						\
-	     (bvl) = bvec_iter_bvec((bio_vec), (iter)),			\
-		(iter).bi_size;						\
+	for (iter = (start);						\
+	     (iter).bi_size &&						\
+		((bvl = bvec_iter_bvec((bio_vec), (iter))), 1);	\
 	     bvec_iter_advance((bio_vec), &(iter), (bvl).bv_len))
 
 


