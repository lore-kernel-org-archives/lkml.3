Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756232AbaHHB1X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 21:27:23 -0400
Received: from longford.logfs.org ([213.229.74.203]:43739 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756057AbaHHB1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 21:27:19 -0400
X-Greylist: delayed 1753 seconds by postgrey-1.27 at vger.kernel.org; Thu, 07 Aug 2014 21:27:19 EDT
Date: Thu, 7 Aug 2014 20:54:43 -0400
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Jens Axboe <axboe@kernel.dk>, oren@purestorage.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Fix race in get_request()
Message-ID: <20140808005443.GA7895@logfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Jens!

I came across the below while investigating some other problem.
Something here doesn't seem right.  This looks like an obvious bug and
something roughly along the lines of my patch would fix it.  But I
must be in the wrong decade to find such a bug in the block layer.

Is this for real?  Or if not, what am I missing?

Jörn

--

If __get_request() returns NULL, get_request will call
prepare_to_wait_exclusive() followed by io_schedule().  Not rechecking
the sleep condition after prepare_to_wait_exclusive() leaves a race
where the condition changes before prepare_to_wait_exclusive(), but
not after and accordingly this thread never gets woken up.

The race must be exceedingly hard to hit, otherwise I cannot explain how
such a classic race could outlive the last millenium.

Signed-off-by: Joern Engel <joern@logfs.org>
---
 block/blk-core.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/block/blk-core.c b/block/blk-core.c
index 3275353957f0..00aa6c7abe5a 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1068,6 +1068,11 @@ retry:
 
 	trace_block_sleeprq(q, bio, rw_flags & 1);
 
+	rq = __get_request(rl, rw_flags, bio, gfp_mask);
+	if (rq) {
+		finish_wait(&rl->wait[is_sync], &wait);
+		return rq;
+	}
 	spin_unlock_irq(q->queue_lock);
 	io_schedule();
 
-- 
2.0.0.rc0.1.g7b2ba98

