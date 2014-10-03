Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932174AbaJCXQg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 19:16:36 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46742 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757872AbaJCWNw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 18:13:52 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Pontus Fuchs <pontus.fuchs@gmail.com>, Jens Axboe <axboe@fb.com>
Subject: [PATCH 3.14 176/238] genhd: fix leftover might_sleep() in blk_free_devt()
Date: Fri,  3 Oct 2014 14:31:31 -0700
Message-Id: <20141003212919.309216031@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212913.680985295@linuxfoundation.org>
References: <20141003212913.680985295@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@fb.com>

commit 46f341ffcfb5d8530f7d1e60f3be06cce6661b62 upstream.

Commit 2da78092 changed the locking from a mutex to a spinlock,
so we now longer sleep in this context. But there was a leftover
might_sleep() in there, which now triggers since we do the final
free from an RCU callback. Get rid of it.

Reported-by: Pontus Fuchs <pontus.fuchs@gmail.com>
Signed-off-by: Jens Axboe <axboe@fb.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 block/genhd.c |    2 --
 1 file changed, 2 deletions(-)

--- a/block/genhd.c
+++ b/block/genhd.c
@@ -445,8 +445,6 @@ int blk_alloc_devt(struct hd_struct *par
  */
 void blk_free_devt(dev_t devt)
 {
-	might_sleep();
-
 	if (devt == MKDEV(0, 0))
 		return;
 


