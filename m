Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753259AbaCMGZy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 02:25:54 -0400
Received: from moutng.kundenserver.de ([212.227.126.131]:63087 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753189AbaCMGZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 02:25:53 -0400
Message-ID: <1394691946.5396.43.camel@marge.simpson.net>
Subject: [PATCH] block,loop: ratelimit error messages
From: Mike Galbraith <bitbucket@online.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: LKML <linux-kernel@vger.kernel.org>
Date: Thu, 13 Mar 2014 07:25:46 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:4Qom62zuZbX/AkqSh992qeioC4kbp9c8DrmA00nB4O/
 nU2Uj7wGK5GGlLxqxwO5qdfcneQ9Dyp5BRvsf8M+Mo9G7XEKgb
 rEWO2Rj+1oIjQK2f+6nkh5WdyF9USS+xQgSrZHq0pqfVW+Ht4e
 3t+dVBbnUowY7F7l6TG/ldzAToDWakuDItbaZsRH0H2evcyjdB
 gbVqitaVlvR/4cXHp2q5C5/T7pfh6KHgyWL2FB2dwFboRf3QrR
 6S4ZZgx1RRspqBwZ9ydnvcG9rmhFxRURrgxQpQR9c4387o8i2l
 IhLEz1RXmgJU8gP4f+WDSFIyZkxaJafe2E0irYQugGI3N8dWPc
 WNJ3wjGgrvLbWsPjeVpFpxy9lWUg2V2VndPPCRPTe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Metric tons of high speed spew is not helpful when things go pear shaped.
systemd lost its mind, forgot how to stop services it insists on being
sole manager of, massive printk() flood ensued, box eventually died.

[16206.684000] loop: Write error at byte offset 11412291584, length 4096.
[16206.684000] systemd-journald[1758]: /dev/kmsg buffer overrun, some messages lost.
[16206.684000] loop: Write error at byte offset 13155434496, length 4096.
[16206.684000] loop: Write error at byte offset 13155438592, length 4096.
[16206.684000] loop: Write error at byte offset 13155442688, length 4096.
[16206.684000] loop: Write error at byte offset 13960736768, length 4096.
[16206.684000] loop: Write error at byte offset 14229172224, length 4096.
[16206.684000] systemd-journald[1758]: /dev/kmsg buffer overrun, some messages lost.
[16206.684000] loop: Write error at byte offset 14766043136, length 4096.
[16206.684000] loop: Write error at byte offset 15034478592, length 4096.
[16206.684000] systemd-journald[1758]: /dev/kmsg buffer overrun, some messages lost.

Signed-off-by: Mike Galbraith <bitbucket@online.de>
---
 drivers/block/loop.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -237,7 +237,7 @@ static int __do_lo_send_write(struct fil
 	file_end_write(file);
 	if (likely(bw == len))
 		return 0;
-	printk(KERN_ERR "loop: Write error at byte offset %llu, length %i.\n",
+	printk_ratelimited(KERN_ERR "loop: Write error at byte offset %llu, length %i.\n",
 			(unsigned long long)pos, len);
 	if (bw >= 0)
 		bw = -EIO;
@@ -277,7 +277,7 @@ static int do_lo_send_write(struct loop_
 		return __do_lo_send_write(lo->lo_backing_file,
 				page_address(page), bvec->bv_len,
 				pos);
-	printk(KERN_ERR "loop: Transfer error at byte offset %llu, "
+	printk_ratelimited(KERN_ERR "loop: Transfer error at byte offset %llu, "
 			"length %i.\n", (unsigned long long)pos, bvec->bv_len);
 	if (ret > 0)
 		ret = -EIO;
@@ -316,7 +316,7 @@ static int lo_send(struct loop_device *l
 out:
 	return ret;
 fail:
-	printk(KERN_ERR "loop: Failed to allocate temporary page for write.\n");
+	printk_ratelimited(KERN_ERR "loop: Failed to allocate temporary page for write.\n");
 	ret = -ENOMEM;
 	goto out;
 }
@@ -345,7 +345,7 @@ lo_splice_actor(struct pipe_inode_info *
 		size = p->bsize;
 
 	if (lo_do_transfer(lo, READ, page, buf->offset, p->page, p->offset, size, IV)) {
-		printk(KERN_ERR "loop: transfer error block %ld\n",
+		printk_ratelimited(KERN_ERR "loop: transfer error block %ld\n",
 		       page->index);
 		size = -EINVAL;
 	}


