Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756021Ab3FFBUm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 21:20:42 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:57225 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755732Ab3FFBUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 21:20:41 -0400
Date: Wed, 5 Jun 2013 18:20:35 -0700
From: Tejun Heo <tj@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: hunger <hunger@hunger.hu>, Emese Revfy <re.emese@gmail.com>,
        PaX Team <pageexec@freemail.hu>, linux-kernel@vger.kernel.org
Subject: [PATCH] block: don't call kobj_map() with 0 @range
Message-ID: <20130606012035.GQ10693@mtj.dyndns.org>
References: <51AE6E08.84.10D1DE36@pageexec.freemail.hu>
 <20130605031520.GP14916@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130605031520.GP14916@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When fully dynamic devt allocation is used, gendisk->minors is zero.
In such cases, add_disk() calls blk_register_region() with 0 @range
expecting it to do nothing; however, blk_register_region() is a thin
wrapper around kobj_map(), which doesn't expect 0 @range input and
goes through an underflow while calculating the number of mapping
entries to allocate.  Fortunately, it has limit check built-in and
this doesn't lead to anything disastrous - it just wastes 255 *
sizeof(struct probe) bytes.

When gendisk->minors is zero, the kobj_map isn't used at all and both
blk_[un]register_region() are expected to be noops.  Add conditionals
to blk_[un]register_region() so that nothing happens when @range is
zero.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: PaX Team <pageexec@freemail.hu>
Cc: stable@vger.kernel.org
---
 block/genhd.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index 20625ee..3a4a1ed 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -467,21 +467,24 @@ static char *bdevt_str(dev_t devt, char *buf)
 
 /*
  * Register device numbers dev..(dev+range-1)
- * range must be nonzero
+ * Noop if @range is zero.
  * The hash chain is sorted on range, so that subranges can override.
  */
 void blk_register_region(dev_t devt, unsigned long range, struct module *module,
 			 struct kobject *(*probe)(dev_t, int *, void *),
 			 int (*lock)(dev_t, void *), void *data)
 {
-	kobj_map(bdev_map, devt, range, module, probe, lock, data);
+	if (range)
+		kobj_map(bdev_map, devt, range, module, probe, lock, data);
 }
 
 EXPORT_SYMBOL(blk_register_region);
 
+/* undo blk_register_region(), noop if @range is zero */
 void blk_unregister_region(dev_t devt, unsigned long range)
 {
-	kobj_unmap(bdev_map, devt, range);
+	if (range)
+		kobj_unmap(bdev_map, devt, range);
 }
 
 EXPORT_SYMBOL(blk_unregister_region);
