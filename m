Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932961AbaDBSOB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 14:14:01 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47851 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932517AbaDBSN5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 14:13:57 -0400
Date: Wed, 2 Apr 2014 20:13:54 +0200
From: Jan Kara <jack@suse.cz>
To: Jianyu Zhan <nasa4836@gmail.com>
Cc: axboe@kernel.dk, hch@lst.de, jack@suse.cz, viro@zeniv.linux.org.uk,
        kmo@daterainc.com, namjae.jeon@samsung.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] blkdev: use an efficient way to check merge flags
Message-ID: <20140402181354.GB13479@quack.suse.cz>
References: <1396451946-13924-1-git-send-email-nasa4836@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396451946-13924-1-git-send-email-nasa4836@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 02-04-14 23:19:06, Jianyu Zhan wrote:
> A bitwise flag comparison could be done using a more efficient bit-ops way.
  OK, but have you checked the generated code is actually any better? This
is something I'd expect a compiler might be able to optimize anyway. And the
original code looks more readable to me.

								Honza

> Signed-off-by: Jianyu Zhan <nasa4836@gmail.com>
> ---
>  include/linux/blkdev.h | 13 +++----------
>  1 file changed, 3 insertions(+), 10 deletions(-)
> 
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 1e1fa3f..adfa40a 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -655,16 +655,9 @@ static inline bool rq_mergeable(struct request *rq)
>  static inline bool blk_check_merge_flags(unsigned int flags1,
>  					 unsigned int flags2)
>  {
> -	if ((flags1 & REQ_DISCARD) != (flags2 & REQ_DISCARD))
> -		return false;
> -
> -	if ((flags1 & REQ_SECURE) != (flags2 & REQ_SECURE))
> -		return false;
> -
> -	if ((flags1 & REQ_WRITE_SAME) != (flags2 & REQ_WRITE_SAME))
> -		return false;
> -
> -	return true;
> +	return (flags1 & (REQ_DISCARD | REQ_SECURE | REQ_WRITE_SAME)) ^
> +	       (flags2 & (REQ_DISCARD | REQ_SECURE | REQ_WRITE_SAME))
> +		== 0;
>  }
>  
>  static inline bool blk_write_same_mergeable(struct bio *a, struct bio *b)
> -- 
> 1.9.0.GIT
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
