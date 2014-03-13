Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755511AbaCMUkj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 16:40:39 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42101 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754884AbaCMUkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 16:40:37 -0400
Date: Thu, 13 Mar 2014 13:40:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>,
        linux-kernel@vger.kernel.org,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Jerome Marchand <jmarchan@redhat.com>
Subject: Re: [PATCH v3] zram: support REQ_DISCARD
Message-Id: <20140313134035.5362a0b51b0a3c280ddc7667@linux-foundation.org>
In-Reply-To: <20140313024617.GA4900@lge.com>
References: <1394611269-7582-1-git-send-email-iamjoonsoo.kim@lge.com>
	<20140312133318.60c5e63ba26e9bf71098cc6e@linux-foundation.org>
	<20140313024617.GA4900@lge.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Mar 2014 11:46:17 +0900 Joonsoo Kim <iamjoonsoo.kim@lge.com> wrote:

> Hello, Andrew.
> 
> I applied all your comments in below patch. :)

OK, thanks.  I'll grab this instead of v5 - I wasn't thinking very
clearly with the lock hold time issue.  Let's go for low latency then
worry about it later if this function starts showing on profiles.

I modified your code comments somewhat - please check.

--- a/drivers/block/zram/zram_drv.c~zram-support-req_discard-v4-fix
+++ a/drivers/block/zram/zram_drv.c
@@ -552,8 +552,8 @@ static int zram_bvec_rw(struct zram *zra
 
 /*
  * zram_bio_discard - handler on discard request
- * @index: physical block index by PAGE_SIZE unit
- * @offset: offset within physical block
+ * @index: physical block index in PAGE_SIZE units
+ * @offset: byte offset within physical block
  */
 static void zram_bio_discard(struct zram *zram, u32 index,
 			     int offset, struct bio *bio)
@@ -561,14 +561,14 @@ static void zram_bio_discard(struct zram
 	size_t n = bio->bi_iter.bi_size;
 
 	/*
-	 * zram manages data by physical block size unit. Because logical block
+	 * zram manages data in physical block size units. Because logical block
 	 * size isn't identical with physical block size on some arch, we
-	 * could get discard request pointing to specific offset within certain
-	 * physical block. Although we can handle this request by reading that
-	 * physiclal block and decompressing and partially zeroing and
-	 * re-compressing and then re-storing it, it isn't reasonable because
-	 * our intention of handling discard request is to save memory.
-	 * So skipping this logical block is approriate here.
+	 * could get a discard request pointing to a specific offset within a
+	 * certain physical block.  Although we can handle this request by
+	 * reading that physiclal block and decompressing and partially zeroing
+	 * and re-compressing and then re-storing it, this isn't reasonable
+	 * because our intent with a discard request is to save memory.  So
+	 * skipping this logical block is appropriate here.
 	 */
 	if (offset) {
 		if (n < offset)
@@ -580,9 +580,8 @@ static void zram_bio_discard(struct zram
 
 	while (n >= PAGE_SIZE) {
 		/*
-		 * discard request can be too large so that the zram can
-		 * be stucked for a long time if we handle the request
-		 * at once. So handle the request by PAGE_SIZE unit at a time.
+		 * Discard request can be large so the lock hold times could be
+		 * lengthy.  So take the lock once per page.
 		 */
 		write_lock(&zram->meta->tb_lock);
 		zram_free_page(zram, index);
@@ -907,9 +906,10 @@ static int create_device(struct zram *zr
 	/*
 	 * zram_bio_discard() will clear all logical blocks if logical block
 	 * size is identical with physical block size(PAGE_SIZE). But if it is
-	 * different, we will skip to discard some parts of logical blocks in
-	 * whole request range which isn't aligned to physical block size.
-	 * So we can't ensure that some discarded logical block is zeroed.
+	 * different, we will skip discarding some parts of logical blocks in
+	 * the part of the request range which isn't aligned to physical block
+	 * size.  So we can't ensure that all discarded logical blocks are
+	 * zeroed.
 	 */
 	if (ZRAM_LOGICAL_BLOCK_SIZE == PAGE_SIZE)
 		zram->disk->queue->limits.discard_zeroes_data = 1;
_

