Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753568Ab3A3PNZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 10:13:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16067 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751153Ab3A3PNW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 10:13:22 -0500
Message-ID: <51093864.9000008@redhat.com>
Date: Wed, 30 Jan 2013 16:12:36 +0100
From: Jerome Marchand <jmarchan@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Nitin Gupta <ngupta@vflare.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>, stable@vger.kernel.org,
        Pekka Enberg <penberg@kernel.org>
Subject: Re: [PATCH v6 1/4] zram: Fix deadlock bug in partial read/write
References: <1359513702-18709-1-git-send-email-minchan@kernel.org>
In-Reply-To: <1359513702-18709-1-git-send-email-minchan@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/30/2013 03:41 AM, Minchan Kim wrote:
> Now zram allocates new page with GFP_KERNEL in zram I/O path
> if IO is partial. Unfortunately, It may cause deadlock with
> reclaim path like below.
> 
> write_page from fs
> fs_lock
> allocation(GFP_KERNEL)
> reclaim
> pageout
> 				write_page from fs
> 				fs_lock <-- deadlock
> 
> This patch fixes it by using GFP_NOIO.  In read path, we
> reorganize code flow so that kmap_atomic is called after the
> GFP_NOIO allocation.

For the all series:
Acked-by: Jerome Marchand <jmarchand@redhat.com>

> 
> Cc: stable@vger.kernel.org
> Cc: Jerome Marchand <jmarchan@redhat.com>
> Acked-by: Nitin Gupta <ngupta@vflare.org>
> [ penberg@kernel.org: don't use GFP_ATOMIC ]
> Signed-off-by: Pekka Enberg <penberg@kernel.org>
> Signed-off-by: Minchan Kim <minchan@kernel.org>
> ---
>  drivers/staging/zram/zram_drv.c |    9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
> index 77a3f0d..5ff8749 100644
> --- a/drivers/staging/zram/zram_drv.c
> +++ b/drivers/staging/zram/zram_drv.c
> @@ -217,11 +217,12 @@ static int zram_bvec_read(struct zram *zram, struct bio_vec *bvec,
>  		return 0;
>  	}
>  
> -	user_mem = kmap_atomic(page);
>  	if (is_partial_io(bvec))
>  		/* Use  a temporary buffer to decompress the page */
> -		uncmem = kmalloc(PAGE_SIZE, GFP_KERNEL);
> -	else
> +		uncmem = kmalloc(PAGE_SIZE, GFP_NOIO);
> +
> +	user_mem = kmap_atomic(page);
> +	if (!is_partial_io(bvec))
>  		uncmem = user_mem;
>  
>  	if (!uncmem) {
> @@ -268,7 +269,7 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
>  		 * This is a partial IO. We need to read the full page
>  		 * before to write the changes.
>  		 */
> -		uncmem = kmalloc(PAGE_SIZE, GFP_KERNEL);
> +		uncmem = kmalloc(PAGE_SIZE, GFP_NOIO);
>  		if (!uncmem) {
>  			pr_info("Error allocating temp memory!\n");
>  			ret = -ENOMEM;
> 

