Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754853AbaC3X6g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 19:58:36 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:37332 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754562AbaC3XnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 19:43:22 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Jens Axboe" <axboe@fb.com>
Date: Mon, 31 Mar 2014 00:23:35 +0100
Message-ID: <lsq.1396221815.309209672@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 107/200] block: add cond_resched() to potentially long
 running ioctl discard loop
In-Reply-To: <lsq.1396221814.369444335@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.56-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@fb.com>

commit c8123f8c9cb517403b51aa41c3c46ff5e10b2c17 upstream.

When mkfs issues a full device discard and the device only
supports discards of a smallish size, we can loop in
blkdev_issue_discard() for a long time. If preempt isn't enabled,
this can turn into a softlock situation and the kernel will
start complaining.

Add an explicit cond_resched() at the end of the loop to avoid
that.

Signed-off-by: Jens Axboe <axboe@fb.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 block/blk-lib.c | 8 ++++++++
 1 file changed, 8 insertions(+)

--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -101,6 +101,14 @@ int blkdev_issue_discard(struct block_de
 
 		atomic_inc(&bb.done);
 		submit_bio(type, bio);
+
+		/*
+		 * We can loop for a long time in here, if someone does
+		 * full device discards (like mkfs). Be nice and allow
+		 * us to schedule out to avoid softlocking if preempt
+		 * is disabled.
+		 */
+		cond_resched();
 	}
 
 	/* Wait for bios in-flight */

