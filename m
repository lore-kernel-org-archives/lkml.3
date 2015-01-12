Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752906AbbALKOn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 05:14:43 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44332 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752549AbbALKOm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 05:14:42 -0500
Date: Mon, 12 Jan 2015 11:14:37 +0100
From: Jan Kara <jack@suse.cz>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/1 linux-next] fs/affs/file.c: fix direct IO writes
 beyond EOF
Message-ID: <20150112101437.GD4468@quack.suse.cz>
References: <1420838383-6638-1-git-send-email-fabf@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420838383-6638-1-git-send-email-fabf@skynet.be>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 09-01-15 22:19:43, Fabian Frederick wrote:
> Use the same fallback to normal IO in case of write
> operations beyond EOF as fat direct IO. This patch fixes
> 
> fsx file -d -Z -r 4096 -w 4096
> 
> Report:
> 129(129 mod 256): TRUNCATE DOWN from 0x3ff01 to 0xb3f6
> 130(130 mod 256): WRITE    0x22000 thru 0x2dfff (0xc000 bytes) HOLE
> 
> Thanks to Jan for helping me on this problem.
> 
> Cc: Jan Kara <jack@suse.cz>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
  Yes, this looks fine to me. You can add:
Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
> Ideal solution suggested by Jan Kara would be to use cont_write_begin but
>  affs direct_IO shouldn't be used a lot anyway...
> 
>  fs/affs/file.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/fs/affs/file.c b/fs/affs/file.c
> index 7e83ba2..d2468bf 100644
> --- a/fs/affs/file.c
> +++ b/fs/affs/file.c
> @@ -398,6 +398,13 @@ affs_direct_IO(int rw, struct kiocb *iocb, struct iov_iter *iter,
>  	size_t count = iov_iter_count(iter);
>  	ssize_t ret;
>  
> +	if (rw == WRITE) {
> +		loff_t size = offset + count;
> +
> +		if (AFFS_I(inode)->mmu_private < size)
> +			return 0;
> +	}
> +
>  	ret = blockdev_direct_IO(rw, iocb, inode, iter, offset, affs_get_block);
>  	if (ret < 0 && (rw & WRITE))
>  		affs_write_failed(mapping, offset + count);
> -- 
> 2.1.0
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
