Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753672AbaG2Qt7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 12:49:59 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:52014 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751575AbaG2Qt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 12:49:57 -0400
Date: Tue, 29 Jul 2014 09:49:51 -0700
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
Message-ID: <20140729164951.GA23863@infradead.org>
References: <1406584299.2970.924.camel@schen9-DESK>
 <20140729141908.GA4464@infradead.org>
 <1406651702.2970.927.camel@schen9-DESK>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406651702.2970.927.camel@schen9-DESK>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2014 at 09:35:02AM -0700, Tim Chen wrote:
> On Tue, 2014-07-29 at 07:19 -0700, Christoph Hellwig wrote:
> > Hi Tim,
> > 
> > I think the problem is that sdio.size doesn't get set set with
> > the new dio code.  Please try the patch below to fix this by not
> > relying on that field:
> 
> Thanks for your quick response.  We'll test this patch and let you
> know the results.

There actually was a little bug in it, please try the version below
instead:


diff --git a/fs/direct-io.c b/fs/direct-io.c
index 194d0d1..17e39b0 100644
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
@@ -1287,10 +1287,9 @@ do_blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
 	 */
 	BUG_ON(retval == -EIOCBQUEUED);
 	if (dio->is_async && retval == 0 && dio->result &&
-	    ((rw == READ) || (dio->result == sdio.size)))
+	    (rw == READ || dio->result == count))
 		retval = -EIOCBQUEUED;
-
-	if (retval != -EIOCBQUEUED)
+	else
 		dio_await_completion(dio);
 
 	if (drop_refcount(dio) == 0) {
