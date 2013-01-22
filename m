Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754887Ab3AVSCR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 13:02:17 -0500
Received: from mail-da0-f48.google.com ([209.85.210.48]:47239 "EHLO
	mail-da0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754732Ab3AVSCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 13:02:14 -0500
Message-ID: <50FED422.4020508@vflare.org>
Date: Tue, 22 Jan 2013 10:02:10 -0800
From: Nitin Gupta <ngupta@vflare.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Jerome Marchand <jmarchan@redhat.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v4 1/4] zram: Fix deadlock bug in partial write
References: <1358813253-20913-1-git-send-email-minchan@kernel.org>
In-Reply-To: <1358813253-20913-1-git-send-email-minchan@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21/2013 04:07 PM, Minchan Kim wrote:
> Now zram allocates new page with GFP_KERNEL in zram I/O path
> if IO is partial. Unfortunately, It may cuase deadlock with
> reclaim path so this patch solves the problem.
>
> Cc: Nitin Gupta <ngupta@vflare.org>
> Cc: Jerome Marchand <jmarchan@redhat.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Minchan Kim <minchan@kernel.org>
> ---
>

For the entire series:
Acked-by: Nitin Gupta <ngupta@vflare.org>


> We could use GFP_IO instead of GFP_ATOMIC in zram_bvec_read with
> some modification related to buffer allocation in case of partial IO.
> But it needs more churn and prevent merge this patch into stable
> if we should send this to stable so I'd like to keep it as simple
> as possbile. GFP_IO usage could be separate patch after we merge it.
> Thanks.
>
>   drivers/staging/zram/zram_drv.c |    4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
> index 61fb8f1..b285b3a 100644
> --- a/drivers/staging/zram/zram_drv.c
> +++ b/drivers/staging/zram/zram_drv.c
> @@ -220,7 +220,7 @@ static int zram_bvec_read(struct zram *zram, struct bio_vec *bvec,
>   	user_mem = kmap_atomic(page);
>   	if (is_partial_io(bvec))
>   		/* Use  a temporary buffer to decompress the page */
> -		uncmem = kmalloc(PAGE_SIZE, GFP_KERNEL);
> +		uncmem = kmalloc(PAGE_SIZE, GFP_ATOMIC);
>   	else
>   		uncmem = user_mem;
>
> @@ -268,7 +268,7 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
>   		 * This is a partial IO. We need to read the full page
>   		 * before to write the changes.
>   		 */
> -		uncmem = kmalloc(PAGE_SIZE, GFP_KERNEL);
> +		uncmem = kmalloc(PAGE_SIZE, GFP_NOIO);
>   		if (!uncmem) {
>   			pr_info("Error allocating temp memory!\n");
>   			ret = -ENOMEM;
>

