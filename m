Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965711AbaFSV3Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 17:29:25 -0400
Received: from fester.cwi.nl ([192.16.191.27]:41930 "EHLO fester.cwi.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964833AbaFSV3X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 17:29:23 -0400
X-Greylist: delayed 900 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 Jun 2014 17:29:23 EDT
Date: Thu, 19 Jun 2014 23:12:11 +0200
From: "Andries E. Brouwer" <Andries.Brouwer@cwi.nl>
To: "Cox, Alan" <alan.cox@intel.com>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "aeb@cwi.nl" <Andries.Brouwer@cwi.nl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Cannot partition 32GB disk on a 32bit machine (correct version
 of the patch this time)
Message-ID: <20140619211211.GA30404@jp>
References: <1403170201.10778.36.camel@acox1-desk.ger.corp.intel.com>
 <1403170400.10778.38.camel@acox1-desk.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403170400.10778.38.camel@acox1-desk.ger.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 19, 2014 at 09:33:26AM +0000, Cox, Alan wrote:
> On Thu, 2014-06-19 at 10:30 +0100, Alan Cox wrote:
> > The block code has 32bit cleanness problems with the iterator. This
> > prevents things like partitioning a 32GB volume on a 32bit system.
> > 
> > I hit this with a volume of exactly 32GB in size (easy to duplicate with
> > virtual machines). Tracing at step by step through the kernel I found
> > the problem lines in blkdev_read_iter which truncates the size value
> > into a 32bit value when setting up the iterator.
> 
> This is a simple initial "fix" that clips the problem cases so get
> behaviour that is at least sane and trivially backportable.
> 
> Signed-off-by: Alan Cox <alan@linux.intel.com>
> ---
>  fs/block_dev.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/fs/block_dev.c b/fs/block_dev.c
> index 6d72746..bef2414 100644
> --- a/fs/block_dev.c
> +++ b/fs/block_dev.c
> @@ -1603,6 +1603,9 @@ static ssize_t blkdev_read_iter(struct kiocb
> *iocb, struct iov_iter *to)
>  
>  	size -= pos;
>  	iov_iter_truncate(to, size);
> +	/* Fix up for 32bit boxes for now */
> +	if (to->count < size)
> +	        to->count = 0xFFFFFFFF;
>  	return generic_file_read_iter(iocb, to);
>  }


It is ages ago that I last looked at such things.
Certainly I have partitioned 160GB+ disks on 32-bit machines, years ago,
so maybe the problem is due to recent bitrot, e.g. the use of a size_t
instead of a loff_t somewhere.

Fetched linux-3.15.1 and linux-3.16-rc1 tar balls.
The diff shows

-static ssize_t blkdev_aio_read(struct kiocb *iocb, const struct iovec *iov,
-                        unsigned long nr_segs, loff_t pos)
+static ssize_t blkdev_read_iter(struct kiocb *iocb, struct iov_iter *to)
 {
        struct file *file = iocb->ki_filp;
        struct inode *bd_inode = file->f_mapping->host;
        loff_t size = i_size_read(bd_inode);
+       loff_t pos = iocb->ki_pos;
 
        if (pos >= size)
                return 0;
 
        size -= pos;
-       if (size < iocb->ki_nbytes)
-               nr_segs = iov_shorten((struct iovec *)iov, nr_segs, size);
-       return generic_file_aio_read(iocb, iov, nr_segs, pos);
+       iov_iter_truncate(to, size);
+       return generic_file_read_iter(iocb, to);
 }

that a test of size was deleted.

In older kernels the test was

        if (size < INT_MAX)
                nr_segs = iov_shorten((struct iovec *)iov, nr_segs, size);

which more clearly shows that this is because the last arg of iov_shorten()
is a size_t. In later source this is called iov_iter_truncate,

static inline void iov_iter_truncate(struct iov_iter *i, size_t count)

still with a size_t as lat arg, so probably the test is still needed.

Andries
