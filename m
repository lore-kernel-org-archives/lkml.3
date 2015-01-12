Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395AbbALXJp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 18:09:45 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36108 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753344AbbALXJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 18:09:42 -0500
Date: Mon, 12 Jan 2015 15:09:41 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Matthew Wilcox <matthew.r.wilcox@intel.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, willy@linux.intel.com
Subject: Re: [PATCH v12 06/20] dax,ext2: Replace XIP read and write with DAX
 I/O
Message-Id: <20150112150941.ab63f50561322415cca7eca9@linux-foundation.org>
In-Reply-To: <1414185652-28663-7-git-send-email-matthew.r.wilcox@intel.com>
References: <1414185652-28663-1-git-send-email-matthew.r.wilcox@intel.com>
	<1414185652-28663-7-git-send-email-matthew.r.wilcox@intel.com>
X-Mailer: Sylpheed 3.4.1 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Oct 2014 17:20:38 -0400 Matthew Wilcox <matthew.r.wilcox@intel.com> wrote:

> Use the generic AIO infrastructure instead of custom read and write
> methods.  In addition to giving us support for AIO, this adds the missing
> locking between read() and truncate().
> 
> ...
>
> +/*
> + * When ext4 encounters a hole, it returns without modifying the buffer_head
> + * which means that we can't trust b_size.  To cope with this, we set b_state
> + * to 0 before calling get_block and, if any bit is set, we know we can trust
> + * b_size.  Unfortunate, really, since ext4 knows precisely how long a hole is
> + * and would save us time calling get_block repeatedly.
> + */
> +static bool buffer_size_valid(struct buffer_head *bh)
> +{
> +	return bh->b_state != 0;
> +}

Yitch.  Is there a cleaner way of doing this?

> +static ssize_t dax_io(int rw, struct inode *inode, struct iov_iter *iter,
> +			loff_t start, loff_t end, get_block_t get_block,
> +			struct buffer_head *bh)

hm, some documentation would be nice.  I expected "dax_io" to do IO,
but this doesn't.  Is it well named?

> +{
> +	ssize_t retval = 0;
> +	loff_t pos = start;
> +	loff_t max = start;
> +	loff_t bh_max = start;
> +	void *addr;
> +	bool hole = false;
> +
> +	if (rw != WRITE)
> +		end = min(end, i_size_read(inode));
> +
> +	while (pos < end) {
> +		unsigned len;
> +		if (pos == max) {
> +			unsigned blkbits = inode->i_blkbits;
> +			sector_t block = pos >> blkbits;
> +			unsigned first = pos - (block << blkbits);
> +			long size;
> +
> +			if (pos == bh_max) {
> +				bh->b_size = PAGE_ALIGN(end - pos);
> +				bh->b_state = 0;
> +				retval = get_block(inode, block, bh,
> +								rw == WRITE);
> +				if (retval)
> +					break;
> +				if (!buffer_size_valid(bh))
> +					bh->b_size = 1 << blkbits;
> +				bh_max = pos - first + bh->b_size;
> +			} else {
> +				unsigned done = bh->b_size -
> +						(bh_max - (pos - first));
> +				bh->b_blocknr += done >> blkbits;
> +				bh->b_size -= done;
> +			}
> +
> +			hole = (rw != WRITE) && !buffer_written(bh);
> +			if (hole) {
> +				addr = NULL;
> +				size = bh->b_size - first;
> +			} else {
> +				retval = dax_get_addr(bh, &addr, blkbits);
> +				if (retval < 0)
> +					break;
> +				if (buffer_unwritten(bh) || buffer_new(bh))
> +					dax_new_buf(addr, retval, first, pos,
> +									end);
> +				addr += first;
> +				size = retval - first;
> +			}
> +			max = min(pos + size, end);
> +		}
> +
> +		if (rw == WRITE)
> +			len = copy_from_iter(addr, max - pos, iter);
> +		else if (!hole)
> +			len = copy_to_iter(addr, max - pos, iter);
> +		else
> +			len = iov_iter_zero(max - pos, iter);
> +
> +		if (!len)
> +			break;
> +
> +		pos += len;
> +		addr += len;
> +	}
> +
> +	return (pos == start) ? retval : pos - start;
> +}
> +
> +/**
> + * dax_do_io - Perform I/O to a DAX file
> + * @rw: READ to read or WRITE to write
> + * @iocb: The control block for this I/O
> + * @inode: The file which the I/O is directed at
> + * @iter: The addresses to do I/O from or to
> + * @pos: The file offset where the I/O starts
> + * @get_block: The filesystem method used to translate file offsets to blocks
> + * @end_io: A filesystem callback for I/O completion
> + * @flags: See below
> + *
> + * This function uses the same locking scheme as do_blockdev_direct_IO:
> + * If @flags has DIO_LOCKING set, we assume that the i_mutex is held by the
> + * caller for writes.  For reads, we take and release the i_mutex ourselves.
> + * If DIO_LOCKING is not set, the filesystem takes care of its own locking.
> + * As with do_blockdev_direct_IO(), we increment i_dio_count while the I/O
> + * is in progress.

It would be helpful here to explain *why* this code uses i_dio_count:
what is trying to protect (against)?

Oh, is that how it works ;)

Perhaps a few BUG_ON(!mutex_is_locked(&inode->i_mutex)) would clarfiy
and prevent mistakes.

> + */
> +ssize_t dax_do_io(int rw, struct kiocb *iocb, struct inode *inode,
> +			struct iov_iter *iter, loff_t pos,
> +			get_block_t get_block, dio_iodone_t end_io, int flags)
>
> ...
>
