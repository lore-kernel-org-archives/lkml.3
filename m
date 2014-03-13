Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754191AbaCMVfA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 17:35:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42387 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752254AbaCMVe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 17:34:58 -0400
Date: Thu, 13 Mar 2014 14:34:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jan Kara <jack@suse.cz>
Cc: Roman Peniaev <r.peniaev@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 1/1] fs/mpage.c: forgotten WRITE_SYNC in case of data
 integrity write
Message-Id: <20140313143456.157404fd7f208638ca70e317@linux-foundation.org>
In-Reply-To: <20140313200119.GB504@quack.suse.cz>
References: <1392519268-29991-1-git-send-email-r.peniaev@gmail.com>
	<20140218155945.ee2e22e07fa3b4f242b16a7f@linux-foundation.org>
	<CACZ9PQV8RsaefFAOt5b-aL33G3CiD+3+fTuW15io6u1DH3XJ6Q@mail.gmail.com>
	<CACZ9PQUKzsP4mwJSO3c=Z3W2pYr2AME-9j+1Cqg9t8a4T+uQQg@mail.gmail.com>
	<20140313200119.GB504@quack.suse.cz>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Mar 2014 21:01:19 +0100 Jan Kara <jack@suse.cz> wrote:

>   Hello,
> 
> On Wed 12-03-14 23:29:04, Roman Peniaev wrote:
> > could you please explain the real purpose of WAIT_SYNC?
> > In case of wbc->sync_mode == WB_SYNC_ALL.
> > Because my current understanding is if writeback control has
> > WB_SYNC_ALL everything
> > should be submitted with WAIT_SYNC.
>   So AFAIK the idea is that REQ_SYNC flag should indicate the IO is
> synchronous - i.e., someone is waiting for it to complete. This is opposed
> to asynchronous writeback done by flusher threads where noone waits for
> particular write to complete. Subsequently, IO scheduler is expected (but
> not required to - only CFQ honors REQ_SYNC AFAIK) to treat sync requests
> with higher priority than async onces.
> 
> When to set REQ_SYNC is not an obvious question. If we set it for too much
> IO, it has no effect. If we don't set it for some IO we risk that someone
> waiting for that IO to complete will be starved by others setting REQ_SYNC.
> 
> So all in all I think that using WRITE_SYNC iff we are doing WB_SYNC_ALL
> writeback is a reasonable choice.

I added this to the changelog:

: akpm: afaict this change will cause the data integrity write bios to be
: placed onto the second queue in cfq_io_cq.cfqq[], which presumably results
: in special treatment.  The documentation for REQ_SYNC is horrid.

Which is pretty pathetic.

Jens isn't talking to us.  Tejun, are you able explain REQ_SYNC?

I just don't know about this patch.  It will presumably have some
effect on data-integrity writes.  But is that a good effect or a bad
one?  Will it result in a sys_sync() starving out other IO for ages in
an undesirable fashion?  It might well do!  Will it prioritize those
writes, resulting in overall less efficient IO patterns?  It might well
do!

I don't see how we can proceed without understanding the tradeoffs and
deciding that the overall effect is a desirable one.




From: Roman Pen <r.peniaev@gmail.com>
Subject: fs/mpage.c: forgotten WRITE_SYNC in case of data integrity write

In case of wbc->sync_mode == WB_SYNC_ALL we need to do data integrity
write, thus mark request as WRITE_SYNC.

akpm: afaict this change will cause the data integrity write bios to be
placed onto the second queue in cfq_io_cq.cfqq[], which presumably results
in special treatment.  The documentation for REQ_SYNC is horrid.

Signed-off-by: Roman Pen <r.peniaev@gmail.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/mpage.c |   23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff -puN fs/mpage.c~fs-mpagec-forgotten-write_sync-in-case-of-data-integrity-write fs/mpage.c
--- a/fs/mpage.c~fs-mpagec-forgotten-write_sync-in-case-of-data-integrity-write
+++ a/fs/mpage.c
@@ -462,6 +462,7 @@ static int __mpage_writepage(struct page
 	struct buffer_head map_bh;
 	loff_t i_size = i_size_read(inode);
 	int ret = 0;
+	int wr = (wbc->sync_mode == WB_SYNC_ALL ?  WRITE_SYNC : WRITE);
 
 	if (page_has_buffers(page)) {
 		struct buffer_head *head = page_buffers(page);
@@ -570,7 +571,7 @@ page_is_mapped:
 	 * This page will go to BIO.  Do we need to send this BIO off first?
 	 */
 	if (bio && mpd->last_block_in_bio != blocks[0] - 1)
-		bio = mpage_bio_submit(WRITE, bio);
+		bio = mpage_bio_submit(wr, bio);
 
 alloc_new:
 	if (bio == NULL) {
@@ -587,7 +588,7 @@ alloc_new:
 	 */
 	length = first_unmapped << blkbits;
 	if (bio_add_page(bio, page, length, 0) < length) {
-		bio = mpage_bio_submit(WRITE, bio);
+		bio = mpage_bio_submit(wr, bio);
 		goto alloc_new;
 	}
 
@@ -620,7 +621,7 @@ alloc_new:
 	set_page_writeback(page);
 	unlock_page(page);
 	if (boundary || (first_unmapped != blocks_per_page)) {
-		bio = mpage_bio_submit(WRITE, bio);
+		bio = mpage_bio_submit(wr, bio);
 		if (boundary_block) {
 			write_boundary_block(boundary_bdev,
 					boundary_block, 1 << blkbits);
@@ -632,7 +633,7 @@ alloc_new:
 
 confused:
 	if (bio)
-		bio = mpage_bio_submit(WRITE, bio);
+		bio = mpage_bio_submit(wr, bio);
 
 	if (mpd->use_writepage) {
 		ret = mapping->a_ops->writepage(page, wbc);
@@ -688,8 +689,11 @@ mpage_writepages(struct address_space *m
 		};
 
 		ret = write_cache_pages(mapping, wbc, __mpage_writepage, &mpd);
-		if (mpd.bio)
-			mpage_bio_submit(WRITE, mpd.bio);
+		if (mpd.bio) {
+			int wr = (wbc->sync_mode == WB_SYNC_ALL ?
+				  WRITE_SYNC : WRITE);
+			mpage_bio_submit(wr, mpd.bio);
+		}
 	}
 	blk_finish_plug(&plug);
 	return ret;
@@ -706,8 +710,11 @@ int mpage_writepage(struct page *page, g
 		.use_writepage = 0,
 	};
 	int ret = __mpage_writepage(page, wbc, &mpd);
-	if (mpd.bio)
-		mpage_bio_submit(WRITE, mpd.bio);
+	if (mpd.bio) {
+		int wr = (wbc->sync_mode == WB_SYNC_ALL ?
+			  WRITE_SYNC : WRITE);
+		mpage_bio_submit(wr, mpd.bio);
+	}
 	return ret;
 }
 EXPORT_SYMBOL(mpage_writepage);
_

