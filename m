Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754682AbaG2X5S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 19:57:18 -0400
Received: from mga02.intel.com ([134.134.136.20]:18518 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750702AbaG2X5Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 19:57:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,760,1400050800"; 
   d="scan'208";a="550974743"
Subject: Re: [Regression 3.16-rc kernel] -55% reduction in throughput for
 OLTP benchmark
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, suruchi <suruchi.a.kadu@intel.com>,
        ak <ak@linux.intel.com>, Dave Hansen <dave.hansen@intel.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        "hubert.nueckel" <hubert.nueckel@intel.com>,
        beth.marsh-prime@intel.com, "doug.nelson" <doug.nelson@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <20140729164951.GA23863@infradead.org>
References: <1406584299.2970.924.camel@schen9-DESK>
	 <20140729141908.GA4464@infradead.org>
	 <1406651702.2970.927.camel@schen9-DESK>
	 <20140729164951.GA23863@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 29 Jul 2014 16:57:12 -0700
Message-ID: <1406678232.2970.943.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-07-29 at 09:49 -0700, Christoph Hellwig wrote:
> On Tue, Jul 29, 2014 at 09:35:02AM -0700, Tim Chen wrote:
> > On Tue, 2014-07-29 at 07:19 -0700, Christoph Hellwig wrote:
> > > Hi Tim,
> > > 
> > > I think the problem is that sdio.size doesn't get set set with
> > > the new dio code.  Please try the patch below to fix this by not
> > > relying on that field:
> > 
> > Thanks for your quick response.  We'll test this patch and let you
> > know the results.
> 
> There actually was a little bug in it, please try the version below
> instead:
> 

Christoph, we're glad to report that this patch does fix the problem.
Wonder if Al or someone can pick it up.  It is a large regression
that should not be left unfixed for 3.16.

Tim


> 
> diff --git a/fs/direct-io.c b/fs/direct-io.c
> index 194d0d1..17e39b0 100644
> --- a/fs/direct-io.c
> +++ b/fs/direct-io.c
> @@ -71,7 +71,6 @@ struct dio_submit {
>  					   been performed at the start of a
>  					   write */
>  	int pages_in_io;		/* approximate total IO pages */
> -	size_t	size;			/* total request size (doesn't change)*/
>  	sector_t block_in_file;		/* Current offset into the underlying
>  					   file in dio_block units. */
>  	unsigned blocks_available;	/* At block_in_file.  changes */
> @@ -1104,7 +1103,8 @@ do_blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
>  	unsigned blkbits = i_blkbits;
>  	unsigned blocksize_mask = (1 << blkbits) - 1;
>  	ssize_t retval = -EINVAL;
> -	loff_t end = offset + iov_iter_count(iter);
> +	size_t count = iov_iter_count(iter);
> +	loff_t end = offset + count;
>  	struct dio *dio;
>  	struct dio_submit sdio = { 0, };
>  	struct buffer_head map_bh = { 0, };
> @@ -1287,10 +1287,9 @@ do_blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
>  	 */
>  	BUG_ON(retval == -EIOCBQUEUED);
>  	if (dio->is_async && retval == 0 && dio->result &&
> -	    ((rw == READ) || (dio->result == sdio.size)))
> +	    (rw == READ || dio->result == count))
>  		retval = -EIOCBQUEUED;
> -
> -	if (retval != -EIOCBQUEUED)
> +	else
>  		dio_await_completion(dio);
>  
>  	if (drop_refcount(dio) == 0) {
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


