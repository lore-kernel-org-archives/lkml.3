Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752832Ab3IFOqZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 10:46:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20316 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751225Ab3IFOqX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 10:46:23 -0400
Message-ID: <5229E9BF.5020604@redhat.com>
Date: Fri, 06 Sep 2013 16:42:07 +0200
From: Jerome Marchand <jmarchan@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Minchan Kim <minchan@kernel.org>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] staging: zram: minimize `slot_free_lock' usage
References: <20130906134706.GA2238@swordfish.minsk.epam.com>
In-Reply-To: <20130906134706.GA2238@swordfish.minsk.epam.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/06/2013 03:47 PM, Sergey Senozhatsky wrote:
> Calling handle_pending_slot_free() for every RW operation may
> cause unneccessary slot_free_lock locking, because most likely
> process will see NULL slot_free_rq. handle_pending_slot_free()
> only when current detects that slot_free_rq is not NULL.
> 
> Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> 
> ---
> 
>  drivers/staging/zram/zram_drv.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
> index 91d94b5..17386e2 100644
> --- a/drivers/staging/zram/zram_drv.c
> +++ b/drivers/staging/zram/zram_drv.c
> @@ -532,14 +532,15 @@ static int zram_bvec_rw(struct zram *zram, struct bio_vec *bvec, u32 index,
>  {
>  	int ret;
>  
> +	if (zram->slot_free_rq)
> +		handle_pending_slot_free(zram);
> +

Calling handle_pending_slot_free() without holding zram->lock?
That's racy.

Jerome

>  	if (rw == READ) {
>  		down_read(&zram->lock);
> -		handle_pending_slot_free(zram);
>  		ret = zram_bvec_read(zram, bvec, index, offset, bio);
>  		up_read(&zram->lock);
>  	} else {
>  		down_write(&zram->lock);
> -		handle_pending_slot_free(zram);
>  		ret = zram_bvec_write(zram, bvec, index, offset);
>  		up_write(&zram->lock);
>  	}
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

