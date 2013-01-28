Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753439Ab3A1HQl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 02:16:41 -0500
Received: from mail-wg0-f49.google.com ([74.125.82.49]:65256 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753340Ab3A1HQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 02:16:37 -0500
MIME-Version: 1.0
In-Reply-To: <1359333506-13599-1-git-send-email-minchan@kernel.org>
References: <1359333506-13599-1-git-send-email-minchan@kernel.org>
Date: Mon, 28 Jan 2013 09:16:35 +0200
X-Google-Sender-Auth: Wl_CXGdu2xbhi-WqwU8nZusvD7M
Message-ID: <CAOJsxLFg_5uhZsvPmVVC0nnsZLGpkJ0W6mHa=aavmguLGuTTnA@mail.gmail.com>
Subject: Re: [RESEND PATCH v5 1/4] zram: Fix deadlock bug in partial write
From: Pekka Enberg <penberg@kernel.org>
To: Minchan Kim <minchan@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Nitin Gupta <ngupta@vflare.org>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>, stable@vger.kernel.org,
        Jerome Marchand <jmarchan@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 28, 2013 at 2:38 AM, Minchan Kim <minchan@kernel.org> wrote:
> Now zram allocates new page with GFP_KERNEL in zram I/O path
> if IO is partial. Unfortunately, It may cuase deadlock with

s/cuase/cause/g

> reclaim path so this patch solves the problem.

It'd be nice to know about the problem in more detail. I'm also
curious on why you decided on GFP_ATOMIC for the read path and
GFP_NOIO in the write path.

>
> Cc: stable@vger.kernel.org
> Cc: Jerome Marchand <jmarchan@redhat.com>
> Acked-by: Nitin Gupta <ngupta@vflare.org>
> Signed-off-by: Minchan Kim <minchan@kernel.org>
> ---
>  drivers/staging/zram/zram_drv.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
> index 61fb8f1..b285b3a 100644
> --- a/drivers/staging/zram/zram_drv.c
> +++ b/drivers/staging/zram/zram_drv.c
> @@ -220,7 +220,7 @@ static int zram_bvec_read(struct zram *zram, struct bio_vec *bvec,
>         user_mem = kmap_atomic(page);
>         if (is_partial_io(bvec))
>                 /* Use  a temporary buffer to decompress the page */
> -               uncmem = kmalloc(PAGE_SIZE, GFP_KERNEL);
> +               uncmem = kmalloc(PAGE_SIZE, GFP_ATOMIC);
>         else
>                 uncmem = user_mem;
>
> @@ -268,7 +268,7 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
>                  * This is a partial IO. We need to read the full page
>                  * before to write the changes.
>                  */
> -               uncmem = kmalloc(PAGE_SIZE, GFP_KERNEL);
> +               uncmem = kmalloc(PAGE_SIZE, GFP_NOIO);
>                 if (!uncmem) {
>                         pr_info("Error allocating temp memory!\n");
>                         ret = -ENOMEM;
> --
> 1.7.9.5
>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
