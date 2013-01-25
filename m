Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757469Ab3AYT0X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 14:26:23 -0500
Received: from mail-pb0-f49.google.com ([209.85.160.49]:39940 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756561Ab3AYT0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 14:26:21 -0500
Date: Fri, 25 Jan 2013 11:26:17 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, ngupta@vflare.org, konrad.wilk@oracle.com,
        sjenning@linux.vnet.ibm.com, minchan@kernel.org
Subject: Re: [PATCH 2/2] staging: zcache: optional support for zsmalloc as
 alternate allocator
Message-ID: <20130125192617.GA26634@kroah.com>
References: <1358977591-24485-1-git-send-email-dan.magenheimer@oracle.com>
 <1358977591-24485-2-git-send-email-dan.magenheimer@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358977591-24485-2-git-send-email-dan.magenheimer@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 23, 2013 at 01:46:31PM -0800, Dan Magenheimer wrote:
> "New" zcache uses zbud for all sub-page allocation which is more flexible but
> results in lower density.  "Old" zcache supported zsmalloc for frontswap
> pages.  Add zsmalloc to "new" zcache as a compile-time and run-time option
> for backwards compatibility in case any users wants to use zcache with
> highest possible density.
> 
> Note that most of the zsmalloc stats in old zcache are not included here
> because old zcache used sysfs and new zcache has converted to debugfs.
> These stats may be added later.
> 
> Note also that ramster is incompatible with zsmalloc as the two use
> the least significant bits in a pampd differently.
> 
> Signed-off-by: Dan Magenheimer <dan.magenheimer@oracle.com>
> ---
>  drivers/staging/zcache/Kconfig       |   11 ++
>  drivers/staging/zcache/zcache-main.c |  210 ++++++++++++++++++++++++++++++++--
>  drivers/staging/zcache/zcache.h      |    3 +
>  3 files changed, 215 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/staging/zcache/Kconfig b/drivers/staging/zcache/Kconfig
> index c1dbd04..116f8d5 100644
> --- a/drivers/staging/zcache/Kconfig
> +++ b/drivers/staging/zcache/Kconfig
> @@ -10,6 +10,17 @@ config ZCACHE
>  	  memory to store clean page cache pages and swap in RAM,
>  	  providing a noticeable reduction in disk I/O.
>  
> +config ZCACHE_ZSMALLOC
> +	bool "Allow use of zsmalloc allocator for compression of swap pages"
> +	depends on ZSMALLOC=y && !RAMSTER
> +	default n
> +	help
> +	  Zsmalloc is a much more efficient allocator for compresssed
> +	  pages but currently has some design deficiencies in that it
> +	  does not support reclaim nor compaction.  Select this if
> +	  you are certain your workload will fit or has mostly short
> +	  running processes.  Zsmalloc is incompatible with RAMster.

How can anyone be "certain"?


> --- a/drivers/staging/zcache/zcache-main.c
> +++ b/drivers/staging/zcache/zcache-main.c
> @@ -26,6 +26,12 @@
>  #include <linux/cleancache.h>
>  #include <linux/frontswap.h>
>  #include "tmem.h"
> +#ifdef CONFIG_ZCACHE_ZSMALLOC
> +#include "../zsmalloc/zsmalloc.h"

Don't #ifdef .h files in .c files.

> +static int zsmalloc_enabled;
> +#else
> +#define zsmalloc_enabled 0
> +#endif

That should have been your only ifdef in this .c file, all of the ones
you have after this should not be needed, so I can't take this patch,
sorry.

thanks,

greg k-h
