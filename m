Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751317Ab3DONSX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 09:18:23 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:40040 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739Ab3DONSV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 09:18:21 -0400
Date: Mon, 15 Apr 2013 16:18:15 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Oskar Andero <oskar.andero@sonymobile.com>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Snild Dolkow <snild.dolkow@sonymobile.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Radovan Lekanovic <radovan.lekanovic@sonymobile.com>,
        Brian Swetland <swetland@google.com>
Subject: Re: [PATCH] lowmemorykiller: prevent multiple instances of low
 memory killer
Message-ID: <20130415131815.GG6638@mwanda>
References: <1366031009-21958-1-git-send-email-oskar.andero@sonymobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366031009-21958-1-git-send-email-oskar.andero@sonymobile.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 15, 2013 at 03:03:29PM +0200, Oskar Andero wrote:
> From: Snild Dolkow <snild.dolkow@sonymobile.com>
> 
> Running multiple instances of LMK is not useful since it will try to
> kill the same process.
> 
> This patch adds a spinlock to prevent multiple instances of the LMK
> running at the same time. Uses spin_trylock and return on failure to
> avoid blocking.
> 
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Brian Swetland <swetland@google.com>
> Reviewed-by: Radovan Lekanovic <radovan.lekanovic@sonymobile.com>
> Signed-off-by: Snild Dolkow <snild.dolkow@sonymobile.com>
> Signed-off-by: Oskar Andero <oskar.andero@sonymobile.com>
> ---
>  drivers/staging/android/lowmemorykiller.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/drivers/staging/android/lowmemorykiller.c b/drivers/staging/android/lowmemorykiller.c
> index 3b91b0f..0b19353 100644
> --- a/drivers/staging/android/lowmemorykiller.c
> +++ b/drivers/staging/android/lowmemorykiller.c
> @@ -38,6 +38,7 @@
>  #include <linux/rcupdate.h>
>  #include <linux/profile.h>
>  #include <linux/notifier.h>
> +#include <linux/spinlock.h>
>  
>  static uint32_t lowmem_debug_level = 2;
>  static short lowmem_adj[6] = {
> @@ -57,6 +58,8 @@ static int lowmem_minfree_size = 4;
>  
>  static unsigned long lowmem_deathpending_timeout;
>  
> +#define LMK_BUSY (-1)

Where is lowmem_shrink called from?  I only see shrink called from
the bcache sysfs handler __bch_cache_set().  The return value isn't
checked there.

Up to now this function has only returns positive numbers.

There isn't a place which check LMK_BUSY so maybe it's best to just
return zero?

regards,
dan carpenter

