Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936622Ab3DRWJ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 18:09:29 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41669 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752689Ab3DRWJ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 18:09:27 -0400
Date: Fri, 19 Apr 2013 00:08:51 +0200
From: Jan Kara <jack@suse.cz>
To: Lukas Czerner <lczerner@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: Re: [PATCH v3 11/18] Revert "ext4: remove no longer used functions
 in inode.c"
Message-ID: <20130418220851.GB19244@quack.suse.cz>
References: <1365498867-27782-1-git-send-email-lczerner@redhat.com>
 <1365498867-27782-12-git-send-email-lczerner@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365498867-27782-12-git-send-email-lczerner@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 09-04-13 11:14:20, Lukas Czerner wrote:
> This reverts commit ccb4d7af914e0fe9b2f1022f8ea6c300463fd5e6.
> 
> This commit reintroduces functions ext4_block_truncate_page() and
> ext4_block_zero_page_range() which has been previously removed in favour
> of ext4_discard_partial_page_buffers().
> 
> In future commits we want to reintroduce those function and remove
> ext4_discard_partial_page_buffers() since it is duplicating some code
> and also partially duplicating work of truncate_pagecache_range(),
> moreover the old implementation was much clearer.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
  When checking the functions, I've noticed one thing:

> +	if (ext4_should_journal_data(inode)) {
> +		BUFFER_TRACE(bh, "get write access");
> +		err = ext4_journal_get_write_access(handle, bh);
> +		if (err)
> +			goto unlock;
> +	}
> +
> +	zero_user(page, offset, length);
> +
> +	BUFFER_TRACE(bh, "zeroed end of block");
> +
> +	err = 0;
> +	if (ext4_should_journal_data(inode)) {
> +		err = ext4_handle_dirty_metadata(handle, inode, bh);
> +	} else
> +		mark_buffer_dirty(bh);
  I think we should call also ext4_jbd2_file_inode() in data=ordered mode.
Otherwise a crash after the truncate transaction has committed could still
result in the tail of the block not being zeroed on disk...

								Honza
> +
> +unlock:
> +	unlock_page(page);
> +	page_cache_release(page);
> +	return err;
> +}
> +
>  int ext4_can_truncate(struct inode *inode)
>  {
>  	if (S_ISREG(inode->i_mode))
> -- 
> 1.7.7.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
