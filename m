Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751749AbaKOJTH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2014 04:19:07 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:41536 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190AbaKOJTA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2014 04:19:00 -0500
Date: Sat, 15 Nov 2014 18:19:21 +0900
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Minchan Kim <minchan@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Nitin Gupta <ngupta@vflare.org>,
        Jerome Marchand <jmarchan@redhat.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        Karam Lee <karam.lee@lge.com>, Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] zram: rely on the bi_end_io for zram_rw_page fails
Message-ID: <20141115091921.GA1046@swordfish>
References: <1415926147-9023-1-git-send-email-minchan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415926147-9023-1-git-send-email-minchan@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On (11/14/14 09:49), Minchan Kim wrote:
> When I tested zram, I found processes got segfaulted.
> The reason was zram_rw_page doesn't make the page dirty
> again when swap write failed, and even it doesn't return
> error by [1].
> 
> If error by zram internal happens, zram_rw_page should return
> non-zero without calling page_endio.
> It causes resubmit the IO with bio so that it ends up calling
> bio->bi_end_io.
> 
> The reason is zram could be used for a block device for FS and
> swap, which they uses different bio complete callback, which
> works differently. So, we should rely on the bio I/O complete
> handler rather than zram_bvec_rw itself in case of I/O fail.
> 
> This patch fixes the segfault issue as well one [1]'s
> mentioned
> 
> [1] zram: make rw_page opeartion return 0
> 
> Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>
> Cc: Karam Lee <karam.lee@lge.com>
> Cc: Dave Chinner <david@fromorbit.com>
> Signed-off-by: Minchan Kim <minchan@kernel.org>
> ---
>  drivers/block/zram/zram_drv.c | 8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
> index 4b4f4dbc3cfd..0e0650feab2a 100644
> --- a/drivers/block/zram/zram_drv.c
> +++ b/drivers/block/zram/zram_drv.c
> @@ -978,12 +978,10 @@ static int zram_rw_page(struct block_device *bdev, sector_t sector,
>  out_unlock:
>  	up_read(&zram->init_lock);
>  out:
> -	page_endio(page, rw, err);
> +	if (unlikely(err))
> +		return err;

this unlikely() case can be turned into a likely() one:

	if (err == 0)
		page_endio(page, rw, 0);
	return err;

> -	/*
> -	 * Return 0 prevents I/O fallback trial caused by rw_page fail
> -	 * and upper layer can handle this IO error via page error.
> -	 */
> +	page_endio(page, rw, 0);
>  	return 0;
>  }

seems like we also can drop at least one goto (jump-to-return) for
invalid request.

(not sure about `goto out_unblock', yet another up_read(&zram->init_lock)
just will make function bigger).

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

---

 drivers/block/zram/zram_drv.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 0e0650f..decca6f 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -956,8 +956,7 @@ static int zram_rw_page(struct block_device *bdev, sector_t sector,
 	zram = bdev->bd_disk->private_data;
 	if (!valid_io_request(zram, sector, PAGE_SIZE)) {
 		atomic64_inc(&zram->stats.invalid_io);
-		err = -EINVAL;
-		goto out;
+		return -EINVAL;
 	}
 
 	down_read(&zram->init_lock);
@@ -974,15 +973,11 @@ static int zram_rw_page(struct block_device *bdev, sector_t sector,
 	bv.bv_offset = 0;
 
 	err = zram_bvec_rw(zram, &bv, index, offset, rw);
-
 out_unlock:
 	up_read(&zram->init_lock);
-out:
-	if (unlikely(err))
-		return err;
-
-	page_endio(page, rw, 0);
-	return 0;
+	if (err == 0)
+		page_endio(page, rw, 0);
+	return err;
 }
 
 static const struct block_device_operations zram_devops = {

