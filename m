Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753911AbaG2OTN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 10:19:13 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:41270 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752101AbaG2OTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 10:19:12 -0400
Date: Tue, 29 Jul 2014 07:19:08 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, suruchi <suruchi.a.kadu@intel.com>,
        ak <ak@linux.intel.com>, Dave Hansen <dave.hansen@intel.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        "hubert.nueckel" <hubert.nueckel@intel.com>,
        beth.marsh-prime@intel.com, "doug.nelson" <doug.nelson@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [Regression 3.16-rc kernel] -55% reduction in throughput for
 OLTP benchmark
Message-ID: <20140729141908.GA4464@infradead.org>
References: <1406584299.2970.924.camel@schen9-DESK>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406584299.2970.924.camel@schen9-DESK>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tim,

I think the problem is that sdio.size doesn't get set set with
the new dio code.  Please try the patch below to fix this by not
relying on that field:

diff --git a/fs/direct-io.c b/fs/direct-io.c
index 194d0d1..adbb847 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -71,7 +71,6 @@ struct dio_submit {
 					   been performed at the start of a
 					   write */
 	int pages_in_io;		/* approximate total IO pages */
-	size_t	size;			/* total request size (doesn't change)*/
 	sector_t block_in_file;		/* Current offset into the underlying
 					   file in dio_block units. */
 	unsigned blocks_available;	/* At block_in_file.  changes */
@@ -1104,7 +1103,8 @@ do_blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
 	unsigned blkbits = i_blkbits;
 	unsigned blocksize_mask = (1 << blkbits) - 1;
 	ssize_t retval = -EINVAL;
-	loff_t end = offset + iov_iter_count(iter);
+	size_t count = iov_iter_count(iter);
+	loff_t end = offset + count;
 	struct dio *dio;
 	struct dio_submit sdio = { 0, };
 	struct buffer_head map_bh = { 0, };
@@ -1286,16 +1286,14 @@ do_blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
 	 * This had *better* be the only place that raises -EIOCBQUEUED.
 	 */
 	BUG_ON(retval == -EIOCBQUEUED);
-	if (dio->is_async && retval == 0 && dio->result &&
-	    ((rw == READ) || (dio->result == sdio.size)))
+	if (dio->is_async && rw == READ && retval == 0 && dio->result == count)
 		retval = -EIOCBQUEUED;
-
-	if (retval != -EIOCBQUEUED)
+	else
 		dio_await_completion(dio);
 
-	if (drop_refcount(dio) == 0) {
+	if (drop_refcount(dio) == 0)
 		retval = dio_complete(dio, offset, retval, false);
-	} else
+	else
 		BUG_ON(retval != -EIOCBQUEUED);
 
 out:
