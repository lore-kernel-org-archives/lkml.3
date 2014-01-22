Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754661AbaAVWvv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 17:51:51 -0500
Received: from mga02.intel.com ([134.134.136.20]:54178 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752130AbaAVWvt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 17:51:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,702,1384329600"; 
   d="scan'208";a="470977918"
Date: Wed, 22 Jan 2014 15:51:56 -0700 (MST)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
X-X-Sender: rzwisler@scrumpy
To: Matthew Wilcox <matthew.r.wilcox@intel.com>
cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-ext4@vger.kernel.org
Subject: Re: [PATCH v5 22/22] XIP: Add support for unwritten extents
In-Reply-To: <CEFD7DAD.22F65%matthew.r.wilcox@intel.com>
Message-ID: <alpine.OSX.2.00.1401221546240.70541@scrumpy>
References: <cover.1389779961.git.matthew.r.wilcox@intel.com> <CEFD7DAD.22F65%matthew.r.wilcox@intel.com>
User-Agent: Alpine 2.00 (OSX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Jan 2014, Matthew Wilcox wrote:

>  static ssize_t xip_io(int rw, struct inode *inode, const struct iovec
> *iov,
>  			loff_t start, loff_t end, unsigned nr_segs,
>  			get_block_t get_block, struct buffer_head *bh)
> @@ -103,21 +109,29 @@ static ssize_t xip_io(int rw, struct inode *inode,
> const struct iovec *iov,
>  			retval = get_block(inode, block, bh, rw == WRITE);
>  			if (retval)
>  				break;
> -			if (buffer_mapped(bh)) {
> -				retval = xip_get_addr(inode, bh, &addr);
> -				if (retval < 0)
> -					break;
> -				addr += offset - (block << inode->i_blkbits);
> -				hole = false;
> -				size = retval;
> -			} else {
> -				if (rw == WRITE) {
> +			if (rw == WRITE) {
> +				if (!buffer_mapped(bh)) {
>  					retval = -EIO;
>  					break;
>  				}
> +				hole = false;
> +			} else {
> +				hole = !buffer_written(bh);
> +			}
> +
> +			if (hole) {
>  				addr = NULL;
> -				hole = true;
>  				size = bh->b_size;
> +			} else {
> +				unsigned first;
> +				retval = xip_get_addr(inode, bh, &addr);
> +				if (retval < 0)
> +					break;
> +				size = retval;
> +				first = offset - (block << inode->i_blkbits);
> +				if (buffer_unwritten(bh))
> +					memset(addr, 0, first);
> +				addr += first;

+                               size -= first;

This is needed so that we don't overrun the XIP buffer we are given in the
event that our user buffer >= our XIP buffer and the start of our I/O isn't
block aligned.

You can add my 
Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com> 

Thanks,
- Ross
