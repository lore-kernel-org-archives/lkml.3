Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933762Ab3DBW2u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 18:28:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33457 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933675Ab3DBWOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 18:14:14 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jan Beulich <jbeulich@suse.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [ 21/68] xen-blkback: fix dispatch_rw_block_io() error path
Date: Tue,  2 Apr 2013 15:13:10 -0700
Message-Id: <20130402221332.408466104@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130402221329.915209206@linuxfoundation.org>
References: <20130402221329.915209206@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Beulich <JBeulich@suse.com>

commit 0e5e098ac22dae38f957e951b70d3cf73beff0f7 upstream.

Commit 7708992 ("xen/blkback: Seperate the bio allocation and the bio
submission") consolidated the pendcnt updates to just a single write,
neglecting the fact that the error path relied on it getting set to 1
up front (such that the decrement in __end_block_io_op() would actually
drop the count to zero, triggering the necessary cleanup actions).

Also remove a misleading and a stale (after said commit) comment.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/block/xen-blkback/blkback.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

--- a/drivers/block/xen-blkback/blkback.c
+++ b/drivers/block/xen-blkback/blkback.c
@@ -742,13 +742,7 @@ static int dispatch_rw_block_io(struct x
 		bio->bi_end_io  = end_block_io_op;
 	}
 
-	/*
-	 * We set it one so that the last submit_bio does not have to call
-	 * atomic_inc.
-	 */
 	atomic_set(&pending_req->pendcnt, nbio);
-
-	/* Get a reference count for the disk queue and start sending I/O */
 	blk_start_plug(&plug);
 
 	for (i = 0; i < nbio; i++)
@@ -776,6 +770,7 @@ static int dispatch_rw_block_io(struct x
  fail_put_bio:
 	for (i = 0; i < nbio; i++)
 		bio_put(biolist[i]);
+	atomic_set(&pending_req->pendcnt, 1);
 	__end_block_io_op(pending_req, -EINVAL);
 	msleep(1); /* back off a bit */
 	return -EIO;


