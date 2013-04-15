Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965056Ab3DPQiO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 12:38:14 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42079 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936026Ab3DPQg0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 12:36:26 -0400
Date: Mon, 15 Apr 2013 16:53:42 +0200
From: Jan Kara <jack@suse.cz>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        viro@zeniv.linux.org.uk, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] fs: fix differed error reporting
Message-ID: <20130415145342.GJ2299@quack.suse.cz>
References: <1365684479-29187-1-git-send-email-dmonakhov@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365684479-29187-1-git-send-email-dmonakhov@openvz.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 11-04-13 16:47:59, Dmitry Monakhov wrote:
> There are two convenient ways to report errors to userspace
> 1) retun error to original syscall for example write(2)
> 2) mark mapping with error flag and return it on later fsync(2)
> 
> Second one is broken if (mapping->nrpages == 0)
> This is real-life situation because after error pages are likey
> to be truncated or invalidated.
> 
> We have to return an error regardless to number of pages in the mapping.
> 
> #Original testcase: git@github.com:dmonakhov/xfstests.git
> MOUNT_OPTIONS="-b1024"
> ./check shared/305
  Makes sence to me. You can add:
Reviewed-by: Jan Kara <jack@suse.cz>

  BTW, this more belongs to the mm area so Andrew Morton might be the right
person to merge this. Added to CC.

								Honza
> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> ---
>  mm/filemap.c |   29 +++++++++++++++++++++--------
>  1 files changed, 21 insertions(+), 8 deletions(-)
> 
> diff --git a/mm/filemap.c b/mm/filemap.c
> index e1979fd..ca47f0b 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -184,6 +184,17 @@ static int sleep_on_page_killable(void *word)
>  	return fatal_signal_pending(current) ? -EINTR : 0;
>  }
>  
> +static int filemap_check_errors(struct address_space *mapping)
> +{
> +	int ret = 0;
> +	/* Check for outstanding write errors */
> +	if (test_and_clear_bit(AS_ENOSPC, &mapping->flags))
> +		ret = -ENOSPC;
> +	if (test_and_clear_bit(AS_EIO, &mapping->flags))
> +		ret = -EIO;
> +	return ret;
> +}
> +
>  /**
>   * __filemap_fdatawrite_range - start writeback on mapping dirty pages in range
>   * @mapping:	address space structure to write
> @@ -265,10 +276,10 @@ int filemap_fdatawait_range(struct address_space *mapping, loff_t start_byte,
>  	pgoff_t end = end_byte >> PAGE_CACHE_SHIFT;
>  	struct pagevec pvec;
>  	int nr_pages;
> -	int ret = 0;
> +	int ret2, ret = 0;
>  
>  	if (end_byte < start_byte)
> -		return 0;
> +		goto out;
>  
>  	pagevec_init(&pvec, 0);
>  	while ((index <= end) &&
> @@ -291,12 +302,10 @@ int filemap_fdatawait_range(struct address_space *mapping, loff_t start_byte,
>  		pagevec_release(&pvec);
>  		cond_resched();
>  	}
> -
> -	/* Check for outstanding write errors */
> -	if (test_and_clear_bit(AS_ENOSPC, &mapping->flags))
> -		ret = -ENOSPC;
> -	if (test_and_clear_bit(AS_EIO, &mapping->flags))
> -		ret = -EIO;
> +out:
> +	ret2 = filemap_check_errors(mapping);
> +	if (!ret)
> +		ret = ret2;
>  
>  	return ret;
>  }
> @@ -337,6 +346,8 @@ int filemap_write_and_wait(struct address_space *mapping)
>  			if (!err)
>  				err = err2;
>  		}
> +	} else {
> +		err = filemap_check_errors(mapping);
>  	}
>  	return err;
>  }
> @@ -368,6 +379,8 @@ int filemap_write_and_wait_range(struct address_space *mapping,
>  			if (!err)
>  				err = err2;
>  		}
> +	} else {
> +		err = filemap_check_errors(mapping);
>  	}
>  	return err;
>  }
> -- 
> 1.7.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
