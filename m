Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756781AbaBUBJe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 20:09:34 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:45280 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754487AbaBTXub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 18:50:31 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jens Axboe <axboe@fb.com>
Subject: [PATCH 3.4 18/25] block: add cond_resched() to potentially long running ioctl discard loop
Date: Thu, 20 Feb 2014 15:51:34 -0800
Message-Id: <20140220234842.993896954@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140220234842.483343851@linuxfoundation.org>
References: <20140220234842.483343851@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 block/blk-lib.c |    8 ++++++++
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


