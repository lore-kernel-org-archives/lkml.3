Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755701Ab3D1Ayz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Apr 2013 20:54:55 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:35035 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752141Ab3D1Ayy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Apr 2013 20:54:54 -0400
Date: Sun, 28 Apr 2013 08:54:46 +0800
From: Shaohua Li <shli@kernel.org>
To: Markus <M4rkusXXL@web.de>
Cc: lkml <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
Subject: Re: hybrid raid1 with trim support [REGRESSION]
Message-ID: <20130428005446.GA20018@kernel.org>
References: <3387108.NX1Tlx8b5x@f209>
 <3642314.Bs77jRSGfY@f209>
 <1533550.VmvE7tiNM7@f209>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1533550.VmvE7tiNM7@f209>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 27, 2013 at 06:29:49PM +0200, Markus wrote:
> Hi!
> 
> Now I had the time to bisect, started with 3.7 as good and 3.8 as bad.
> 0cfbcafcae8b7364b5fa96c2b26ccde7a3a296a9 is the bad commit. [1]
> block: add plug for blkdev_issue_discard
> 
> While 3.8.10 was still bad, the same kernel with the reverted patch applied is fine.
Thanks for the reporting. Does below patch work for you?

Thanks,
Shaohua


---
 drivers/md/raid1.c |    4 ++++
 1 file changed, 4 insertions(+)

Index: linux/drivers/md/raid1.c
===================================================================
--- linux.orig/drivers/md/raid1.c	2013-03-07 14:14:05.950824173 +0800
+++ linux/drivers/md/raid1.c	2013-04-28 08:52:06.761964780 +0800
@@ -981,6 +981,10 @@ static void raid1_unplug(struct blk_plug
 	while (bio) { /* submit pending writes */
 		struct bio *next = bio->bi_next;
 		bio->bi_next = NULL;
+		if (unlikely((bio->bi_rw & REQ_DISCARD) &&
+		    !blk_queue_discard(bdev_get_queue(bio->bi_bdev))))
+			/* Just ignore it */
+			bio_endio(bio, 0);
 		generic_make_request(bio);
 		bio = next;
 	}
