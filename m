Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935042Ab3DGXdt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 19:33:49 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46866 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935021Ab3DGXdm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 19:33:42 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>,
        "Jan Beulich" <jbeulich@suse.com>, "Jan Beulich" <JBeulich@suse.com>
Date: Sun, 07 Apr 2013 23:45:42 +0100
Message-ID: <lsq.1365374742.239793909@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [19/74] xen-blkback: fix dispatch_rw_block_io() error path
In-Reply-To: <lsq.1365374742.214522651@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:b4b3:7e2a:e2d0:3478
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.43-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/block/xen-blkback/blkback.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

--- a/drivers/block/xen-blkback/blkback.c
+++ b/drivers/block/xen-blkback/blkback.c
@@ -758,13 +758,7 @@ static int dispatch_rw_block_io(struct x
 		}
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
@@ -792,6 +786,7 @@ static int dispatch_rw_block_io(struct x
  fail_put_bio:
 	for (i = 0; i < nbio; i++)
 		bio_put(biolist[i]);
+	atomic_set(&pending_req->pendcnt, 1);
 	__end_block_io_op(pending_req, -EINVAL);
 	msleep(1); /* back off a bit */
 	return -EIO;

