Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755769Ab3CPNGr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Mar 2013 09:06:47 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:37782 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755593Ab3CPNGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Mar 2013 09:06:45 -0400
Date: Sat, 16 Mar 2013 09:06:39 -0400
From: Konrad Rzeszutek Wilk <konrad@darnok.org>
To: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Minchan Kim <minchan@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/4] introduce zero-filled page stat count
Message-ID: <20130316130638.GB5987@konrad-lan.dumpdata.com>
References: <1363255697-19674-1-git-send-email-liwanp@linux.vnet.ibm.com>
 <1363255697-19674-4-git-send-email-liwanp@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363255697-19674-4-git-send-email-liwanp@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 14, 2013 at 06:08:16PM +0800, Wanpeng Li wrote:
> Introduce zero-filled page statistics to monitor the number of
> zero-filled pages.

Hm, you must be using an older version of the driver. Please
rebase it against Greg KH's staging tree. This is where most if not
all of the DebugFS counters got moved to a different file.

> 
> Acked-by: Dan Magenheimer <dan.magenheimer@oracle.com>
> Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
> ---
>  drivers/staging/zcache/zcache-main.c |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/staging/zcache/zcache-main.c b/drivers/staging/zcache/zcache-main.c
> index db200b4..2091a4d 100644
> --- a/drivers/staging/zcache/zcache-main.c
> +++ b/drivers/staging/zcache/zcache-main.c
> @@ -196,6 +196,7 @@ static ssize_t zcache_eph_nonactive_puts_ignored;
>  static ssize_t zcache_pers_nonactive_puts_ignored;
>  static ssize_t zcache_writtenback_pages;
>  static ssize_t zcache_outstanding_writeback_pages;
> +static ssize_t zcache_pages_zero;
>  
>  #ifdef CONFIG_DEBUG_FS
>  #include <linux/debugfs.h>
> @@ -257,6 +258,7 @@ static int zcache_debugfs_init(void)
>  	zdfs("outstanding_writeback_pages", S_IRUGO, root,
>  				&zcache_outstanding_writeback_pages);
>  	zdfs("writtenback_pages", S_IRUGO, root, &zcache_writtenback_pages);
> +	zdfs("pages_zero", S_IRUGO, root, &zcache_pages_zero);
>  	return 0;
>  }
>  #undef	zdebugfs
> @@ -326,6 +328,7 @@ void zcache_dump(void)
>  	pr_info("zcache: outstanding_writeback_pages=%zd\n",
>  				zcache_outstanding_writeback_pages);
>  	pr_info("zcache: writtenback_pages=%zd\n", zcache_writtenback_pages);
> +	pr_info("zcache: pages_zero=%zd\n", zcache_pages_zero);
>  }
>  #endif
>  
> @@ -562,6 +565,7 @@ static void *zcache_pampd_eph_create(char *data, size_t size, bool raw,
>  		kunmap_atomic(user_mem);
>  		clen = 0;
>  		zero_filled = true;
> +		zcache_pages_zero++;
>  		goto got_pampd;
>  	}
>  	kunmap_atomic(user_mem);
> @@ -645,6 +649,7 @@ static void *zcache_pampd_pers_create(char *data, size_t size, bool raw,
>  		kunmap_atomic(user_mem);
>  		clen = 0;
>  		zero_filled = true;
> +		zcache_pages_zero++;
>  		goto got_pampd;
>  	}
>  	kunmap_atomic(user_mem);
> @@ -866,6 +871,7 @@ static int zcache_pampd_get_data_and_free(char *data, size_t *sizep, bool raw,
>  		zpages = 0;
>  		if (!raw)
>  			*sizep = PAGE_SIZE;
> +		zcache_pages_zero--;
>  		goto zero_fill;
>  	}
>  
> @@ -922,6 +928,7 @@ static void zcache_pampd_free(void *pampd, struct tmem_pool *pool,
>  		zero_filled = true;
>  		zsize = 0;
>  		zpages = 0;
> +		zcache_pages_zero--;
>  	}
>  
>  	if (pampd_is_remote(pampd) && !zero_filled) {
> -- 
> 1.7.7.6
> 
