Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753252Ab3HACsK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 22:48:10 -0400
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:55041 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752786Ab3HACsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 22:48:07 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjgFADvL+VF5LPxHgWdsb2JhbABbvQ6FLoEfFw4BARYmKIIkAQEFJxMcIxAIAw4HAwklDwUlAyETiA+5MxaPcQeECwOXXooiilIq
Date: Thu, 1 Aug 2013 12:48:00 +1000
From: Dave Chinner <david@fromorbit.com>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, bpm@sgi.com, elder@kernel.org,
        hch@infradead.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
        xfs@oss.sgi.com, a.sangwan@samsung.com,
        Namjae Jeon <namjae.jeon@samsung.com>
Subject: Re: [PATCH 3/3] ext4: Implement FALLOC_FL_COLLAPSE_RANGE
Message-ID: <20130801024800.GK7118@dastard>
References: <1375281746-15908-1-git-send-email-linkinjeon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375281746-15908-1-git-send-email-linkinjeon@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 31, 2013 at 11:42:26PM +0900, Namjae Jeon wrote:
> From: Namjae Jeon <namjae.jeon@samsung.com>
> 
> New fallocate flag FALLOC_FL_COLLAPSE_RANGE implementation for Ext4
.....
> +
> +	punch_start = offset >> EXT4_BLOCK_SIZE_BITS(sb);
> +	punch_stop = (offset + len) >> EXT4_BLOCK_SIZE_BITS(sb);
> +
> +	rounding = max_t(uint, 1 << EXT4_BLOCK_SIZE_BITS(sb), PAGE_CACHE_SIZE);
> +	ioffset = offset & ~(rounding - 1);
> +
> +	/* Write out all dirty pages */
> +	ret = filemap_write_and_wait_range(inode->i_mapping, ioffset, -1);
> +	if (ret)
> +		return ret;
> +
> +	/* Take mutex lock */
> +	mutex_lock(&inode->i_mutex);
> +
> +	truncate_pagecache_range(inode, ioffset, -1);

Ted, that's invalidating the page cache from the start of the
collaspse range to the end of the file. So the ext4 code is doing
this bit correctly.  Why isn't this in the XFS patches? Clearly the
need for this was understood, and, well, this code is obviously
copied from the XFS hole punching code. i.e. from
xfs_free_file_space().

> +	/* Wait for existing dio to complete */
> +	ext4_inode_block_unlocked_dio(inode);
> +	inode_dio_wait(inode);

That should be done before invalidating the pagecache....

> +	credits = ext4_writepage_trans_blocks(inode);
> +	handle = ext4_journal_start(inode, EXT4_HT_TRUNCATE, credits);
> +	if (IS_ERR(handle)) {
> +		ret = PTR_ERR(handle);
> +		goto out_dio;
> +	}
> +
> +	down_write(&EXT4_I(inode)->i_data_sem);
> +
> +	ext4_discard_preallocations(inode);
> +
> +	ret = ext4_es_remove_extent(inode, punch_start,
> +				    EXT_MAX_BLOCKS - punch_start - 1);
> +	if (ret)
> +		goto journal_stop;
> +
> +	ret = ext4_ext_remove_space(inode, punch_start, punch_stop - 1);
> +	if (ret)
> +		goto journal_stop;

So, this code punches out the existing space in the file so that the
extent shifting is moving extents into a hole. Why is this in the
ext4 code, but not the XFS code?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
