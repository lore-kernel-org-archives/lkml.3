Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755068Ab3IPACJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Sep 2013 20:02:09 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:50521 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754657Ab3IPACH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Sep 2013 20:02:07 -0400
X-AuditID: 9c930197-b7b82ae000001256-f4-52364a7c30f4
Date: Mon, 16 Sep 2013 09:02:17 +0900
From: Minchan Kim <minchan@kernel.org>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Jerome Marchand <jmarchan@redhat.com>,
        driverdev-devel@linuxdriverproject.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] staging: zram: fix handle_pending_slot_free() and
 zram_reset_device() race
Message-ID: <20130916000217.GA18616@bbox>
References: <20130906151255.GE2238@swordfish.minsk.epam.com>
 <20130909123329.GZ19256@mwanda>
 <20130909124942.GA2221@swordfish.minsk.epam.com>
 <20130909132124.GY6329@mwanda>
 <522DD125.1030607@redhat.com>
 <522DF2DF.5060407@redhat.com>
 <20130910143416.GC2270@swordfish>
 <20130910145802.GD19256@mwanda>
 <20130910231250.GA2450@swordfish>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130910231250.GA2450@swordfish>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Sergey,

Sorry for really slow response. I was really busy by internal works
and Thanks for pointing the BUG, Dan, Jerome and Sergey.
I read your threads roughly so I may miss something. If so, sorry
for that. Anyway I will put my opinion.

On Wed, Sep 11, 2013 at 02:12:50AM +0300, Sergey Senozhatsky wrote:
> Dan Carpenter noted that handle_pending_slot_free() is racy with
> zram_reset_device(). Take write init_lock in zram_slot_free(), thus

Right but "init_lock" is what I really want to remove.
Yes. It's just read-side lock so most of time it doesn't hurt us but it
makes code very complicated and deadlock prone so I'd like to replace
it with RCU. Yeah, It's off topic but just let me put my opinion in
future direction.

Abought the bug, how about moving flush_work below down_write(init_lock)?
zram_make_request is already closed by init_lock and we have a rule about
lock ordering as following so I don't see any problem.

  init_lock
    zram->lock

> preventing any concurrent zram_slot_free(), zram_bvec_rw() or
> zram_reset_device(). This also allows to safely check zram->init_done
> in handle_pending_slot_free().
> 
> Initial intention was to minimze number of handle_pending_slot_free()
> call from zram_bvec_rw(), which were slowing down READ requests due to
> slot_free_lock spin lock. Jerome Marchand suggested to remove
> handle_pending_slot_free() from zram_bvec_rw().
> 
> Link: https://lkml.org/lkml/2013/9/9/172
> Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> 
> ---
> 
>  drivers/staging/zram/zram_drv.c | 13 +++++--------
>  1 file changed, 5 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
> index 91d94b5..7a2d4de 100644
> --- a/drivers/staging/zram/zram_drv.c
> +++ b/drivers/staging/zram/zram_drv.c
> @@ -521,7 +521,8 @@ static void handle_pending_slot_free(struct zram *zram)
>  	while (zram->slot_free_rq) {
>  		free_rq = zram->slot_free_rq;
>  		zram->slot_free_rq = free_rq->next;
> -		zram_free_page(zram, free_rq->index);
> +		if (zram->init_done)
> +			zram_free_page(zram, free_rq->index);
>  		kfree(free_rq);
>  	}
>  	spin_unlock(&zram->slot_free_lock);
> @@ -534,16 +535,13 @@ static int zram_bvec_rw(struct zram *zram, struct bio_vec *bvec, u32 index,
>  
>  	if (rw == READ) {
>  		down_read(&zram->lock);
> -		handle_pending_slot_free(zram);

Read side is okay but actually I have a nitpick.
If someone poll a block in zram-swap device, he would see a block
has zero value suddenly although there was no I/O.(I don't want to argue
it's sane user or not, anyway) it never happens on real block device and
it never happens on zram-block device. Only it can happen zram-swap device.
And such behavior was there since we introduced swap_slot_free_notify.
(off-topic: I'd like to remove it because it makes tight coupling between
zram and swap and obviously, it was layering violation function)
so now, I don't have strong objection. 

The idea is to remove swap_slot_free_notify is to use frontswap when
user want to use zram as swap so zram can be notified when the block
lose the owner but still we should solve the mutex problem in notify
handler.


>  		ret = zram_bvec_read(zram, bvec, index, offset, bio);
>  		up_read(&zram->lock);
>  	} else {
>  		down_write(&zram->lock);
> -		handle_pending_slot_free(zram);

Why did you remove this in write-side?
We can't expect when the work will trigger. It means the work could remove
valid block under the us.


>  		ret = zram_bvec_write(zram, bvec, index, offset);
>  		up_write(&zram->lock);
>  	}
> -
>  	return ret;
>  }
>  
> @@ -750,12 +748,11 @@ error:
>  
>  static void zram_slot_free(struct work_struct *work)
>  {
> -	struct zram *zram;
> +	struct zram *zram = container_of(work, struct zram, free_work);
>  
> -	zram = container_of(work, struct zram, free_work);
> -	down_write(&zram->lock);
> +	down_write(&zram->init_lock);

I don't like this.
Primary problem is we should handle it as atomic so that we should use
spinlock instead of mutex. Yeah, /me kicks his ass. From the beginning,
I should solve this problem as that way.

The simple solution popped from my mind is that


diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
index 91d94b5..b23bf0e 100644
--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@ -534,11 +534,14 @@ static int zram_bvec_rw(struct zram *zram, struct bio_vec *bvec, u32 index,
 
 	if (rw == READ) {
 		down_read(&zram->lock);
-		handle_pending_slot_free(zram);
 		ret = zram_bvec_read(zram, bvec, index, offset, bio);
 		up_read(&zram->lock);
 	} else {
 		down_write(&zram->lock);
+		/*
+		 * We should free pending slot. Otherwise it would
+		 * free valid blocks under the us.
+		 */
 		handle_pending_slot_free(zram);
 		ret = zram_bvec_write(zram, bvec, index, offset);
 		up_write(&zram->lock);
@@ -552,7 +555,6 @@ static void zram_reset_device(struct zram *zram, bool reset_capacity)
 	size_t index;
 	struct zram_meta *meta;
 
-	flush_work(&zram->free_work);
 
 	down_write(&zram->init_lock);
 	if (!zram->init_done) {
@@ -560,6 +562,7 @@ static void zram_reset_device(struct zram *zram, bool reset_capacity)
 		return;
 	}
 
+	flush_work(&zram->free_work);
 	meta = zram->meta;
 	zram->init_done = 0;
 
 But more ideal way I am thinking now is 

1) replace init_lock with RCU lock
2) introduce new meta atmoic lock instead of zram->mutex, which is very coarse-grained.
3) use atmoic lock in notify handler.

-- 
Kind regards,
Minchan Kim
