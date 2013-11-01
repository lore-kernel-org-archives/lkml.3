Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752332Ab3KAOyM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 10:54:12 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:37838 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750719Ab3KAOyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 10:54:10 -0400
Date: Fri, 1 Nov 2013 10:54:09 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Ming Lei <ming.lei@canonical.com>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        USB list <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 2/2] USB: storage: use sg_miter_* APIs to access scsi
 buffer
In-Reply-To: <1383062878-28489-1-git-send-email-ming.lei@canonical.com>
Message-ID: <Pine.LNX.4.44L0.1311011040410.1364-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Oct 2013, Ming Lei wrote:

> We have sg_miter_* APIs for accessing scsi sg buffer, so
> use them to make code clean and bug free.

Hmmm.  You could simply call sg_copy_buffer, if you didn't mind the 
quadratic penalty for the sg_miter_skip operations.

> --- a/drivers/usb/storage/protocol.c
> +++ b/drivers/usb/storage/protocol.c
> @@ -135,69 +135,43 @@ unsigned int usb_stor_access_xfer_buf(unsigned char *buffer,
>  	unsigned int buflen, struct scsi_cmnd *srb, struct scatterlist **sgptr,
>  	unsigned int *offset, enum xfer_buf_dir dir)
>  {
> -	unsigned int cnt;
> +	unsigned int cnt = 0;
>  	struct scatterlist *sg = *sgptr;
> +	struct sg_mapping_iter miter;
> +	unsigned int nents = scsi_sg_count(srb);
>  
> -	/* We have to go through the list one entry
> -	 * at a time.  Each s-g entry contains some number of pages, and
> -	 * each page has to be kmap()'ed separately.  If the page is already
> -	 * in kernel-addressable memory then kmap() will return its address.
> -	 * If the page is not directly accessible -- such as a user buffer
> -	 * located in high memory -- then kmap() will map it to a temporary
> -	 * position in the kernel's virtual address space.
> -	 */
> -
> -	if (!sg)
> +	if (sg)
> +		nents -= sg - scsi_sglist(srb);

This is definitely wrong.  Scatterlist entries are not always stored in 
a linear array.  To do this properly, you would have to make the caller 
keep track of the current value of nents.

Or better yet, have the caller store and pass the sg_mapping_iter 
structure rather than sgptr and offset.

> +	else
>  		sg = scsi_sglist(srb);
>  
> -	/* This loop handles a single s-g list entry, which may
> -	 * include multiple pages.  Find the initial page structure
> -	 * and the starting offset within the page, and update
> -	 * the *offset and **sgptr values for the next loop.
> -	 */
> -	cnt = 0;
> -	while (cnt < buflen && sg) {
> -		struct page *page = sg_page(sg) +
> -				((sg->offset + *offset) >> PAGE_SHIFT);
> -		unsigned int poff = (sg->offset + *offset) & (PAGE_SIZE-1);
> -		unsigned int sglen = sg->length - *offset;
> -
> -		if (sglen > buflen - cnt) {
> -
> -			/* Transfer ends within this s-g entry */
> -			sglen = buflen - cnt;
> -			*offset += sglen;
> -		} else {
> +	if (dir == FROM_XFER_BUF)
> +		sg_miter_start(&miter, sg, nents, SG_MITER_FROM_SG);
> +	else
> +		sg_miter_start(&miter, sg, nents, SG_MITER_TO_SG);

I find this style somewhat annoying.  Maybe the compiler is smart 
enough to optimize it, maybe not.  In any case, I would prefer to see

	if (dir == FROM_XFER_BUF)
		sgdir = SG_MITER_FROM_SG;
	else
		sgdir = SG_MITER_TO_SG;
	sg_miter_start(&miter, nents, sgdir);

Or even:

	sg_miter_start(&miter, nents, (dir == FROM_XFER_BUF ?
			SG_MITER_FROM_SG : SG_MITER_TO_SG));

> -			/* Transfer continues to next s-g entry */
> -			*offset = 0;
> -			sg = sg_next(sg);
> -		}
> +	if (!sg_miter_skip(&miter, *offset))
> +		return cnt;
> +
> +	while (sg_miter_next(&miter) && cnt < buflen) {
> +		unsigned int len = min(miter.length, buflen - cnt);
> +
> +		if (dir == FROM_XFER_BUF)
> +			memcpy(buffer + cnt, miter.addr, len);
> +		else
> +			memcpy(miter.addr, buffer + cnt, len);
>  
> -		/* Transfer the data for all the pages in this
> -			* s-g entry.  For each page: call kmap(), do the
> -			* transfer, and call kunmap() immediately after. */
> -		while (sglen > 0) {
> -			unsigned int plen = min(sglen, (unsigned int)
> -					PAGE_SIZE - poff);
> -			unsigned char *ptr = kmap(page);
> -
> -			if (dir == TO_XFER_BUF)
> -				memcpy(ptr + poff, buffer + cnt, plen);
> -			else
> -				memcpy(buffer + cnt, ptr + poff, plen);
> -			kunmap(page);
> -
> -			/* Start at the beginning of the next page */
> -			poff = 0;
> -			++page;
> -			cnt += plen;
> -			sglen -= plen;
> +		if (*offset + len < miter.piter.sg->length) {
> +			*offset += len;
> +			*sgptr = miter.piter.sg;
> +		} else {
> +			*offset = 0;
> +			*sgptr = sg_next(miter.piter.sg);
>  		}
> +		cnt += len;
>  	}
> -	*sgptr = sg;
> +	sg_miter_stop(&miter);
>  
> -	/* Return the amount actually transferred */

Why remove this comment?

>  	return cnt;
>  }
>  EXPORT_SYMBOL_GPL(usb_stor_access_xfer_buf);

Alan Stern

