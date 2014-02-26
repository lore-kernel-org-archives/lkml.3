Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751839AbaBZEfE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 23:35:04 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:37259 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751705AbaBZEel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 23:34:41 -0500
X-Original-SENDERIP: 10.177.220.194
X-Original-MAILFROM: minchan@kernel.org
Date: Wed, 26 Feb 2014 13:35:11 +0900
From: Minchan Kim <minchan@kernel.org>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Jerome Marchand <jmarchan@redhat.com>, Nitin Gupta <ngupta@vflare.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv7 4/7] zram: add multi stream functionality
Message-ID: <20140226043511.GC4606@bbox>
References: <1393328073-12313-1-git-send-email-sergey.senozhatsky@gmail.com>
 <1393328073-12313-5-git-send-email-sergey.senozhatsky@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393328073-12313-5-git-send-email-sergey.senozhatsky@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 25, 2014 at 02:34:30PM +0300, Sergey Senozhatsky wrote:
> This patch implements multi stream compression support.
> 
> Introduce struct zcomp_strm_multi and a set of functions to manage
> zcomp_strm stream access. zcomp_strm_multi has a list of idle zcomp_strm
> structs, spinlock to protect idle list and wait queue, making it possible
> to perform parallel compressions.
> 
> The following set of functions added:
> - zcomp_strm_multi_get()/zcomp_strm_multi_put()
>   get and put compression stream, implement required locking
> - zcomp_strm_multi_create()/zcomp_strm_multi_destroy()
>   create and destroy zcomp_strm_multi
> 
> zcomp ->strm_get() and ->strm_put() callbacks are set during initialisation
> to zcomp_strm_multi_get()/zcomp_strm_multi_put() correspondingly.
> 
> Each time zcomp issues a zcomp_strm_multi_get() call, the following set of
> operations performed:
> - spin lock strm_lock
> - if idle list is not empty, remove zcomp_strm from idle list, spin
>   unlock and return zcomp stream pointer to caller
> - if idle list is empty, current adds itself to wait queue. it will be
>   awaken by zcomp_strm_multi_put() caller.
> 
> zcomp_strm_multi_put():
> - spin lock strm_lock
> - add zcomp stream to idle list
> - spin unlock, wake up sleeper
> 
> Minchan Kim reported that spinlock-based locking scheme has demonstrated a
> severe perfomance regression for single compression stream case, comparing
> to mutex-based (https://lkml.org/lkml/2014/2/18/16)
> 
> base                      spinlock                    mutex
> 
> ==Initial write           ==Initial write             ==Initial  write
> records:  5               records:  5                 records:   5
> avg:      1642424.35      avg:      699610.40         avg:       1655583.71
> std:      39890.95(2.43%) std:      232014.19(33.16%) std:       52293.96
> max:      1690170.94      max:      1163473.45        max:       1697164.75
> min:      1568669.52      min:      573429.88         min:       1553410.23
> ==Rewrite                 ==Rewrite                   ==Rewrite
> records:  5               records:  5                 records:   5
> avg:      1611775.39      avg:      501406.64         avg:       1684419.11
> std:      17144.58(1.06%) std:      15354.41(3.06%)   std:       18367.42
> max:      1641800.95      max:      531356.78         max:       1706445.84
> min:      1593515.27      min:      488817.78         min:       1655335.73
> ==Random  write           ==Random  write             ==Random   write
> records:  5               records:  5                 records:   5
> avg:      1626318.29      avg:      497250.78         avg:       1695582.06
> std:      38550.23(2.37%) std:      1405.42(0.28%)    std:       9211.98
> max:      1665839.62      max:      498585.88         max:       1703808.22
> min:      1562141.21      min:      494526.45         min:       1677664.94
> ==Pwrite                  ==Pwrite                    ==Pwrite
> records:  5               records:  5                 records:   5
> avg:      1654641.25      avg:      581709.22         avg:       1641452.34
> std:      47202.59(2.85%) std:      9670.46(1.66%)    std:       38963.62
> max:      1740682.36      max:      591300.09         max:       1687387.69
> min:      1611436.34      min:      564324.38         min:       1570496.11
> 
> When only one compression stream available, mutex with spin on owner tends
> to perform much better than frequent wait_event()/wake_up(). This is why
> single stream implemented as a special case with mutex locking.
> 
> This is preparation patch, later patches will use this code.

I'm not sure it's good to introduce preparation patch without code using
that but builded together because it could make build warning.
It surely made code review easy so I'm not sure what's the best method
to make handle this case.

When I see next patch, it's not complex so I think we could merge this
and next patchset.

> 
> Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> ---
>  drivers/block/zram/zcomp.c | 119 ++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 118 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/block/zram/zcomp.c b/drivers/block/zram/zcomp.c
> index e20054b..6f238f5 100644
> --- a/drivers/block/zram/zcomp.c
> +++ b/drivers/block/zram/zcomp.c
> @@ -15,6 +15,8 @@
>  
>  #include "zcomp.h"
>  
> +extern struct zcomp_backend zcomp_lzo;
> +
>  /*
>   * single zcomp_strm backend
>   */
> @@ -23,7 +25,20 @@ struct zcomp_strm_single {
>  	struct zcomp_strm *zstrm;
>  };
>  
> -extern struct zcomp_backend zcomp_lzo;
> +/*
> + * multi zcomp_strm backend
> + */
> +struct zcomp_strm_multi {
> +	/* protect strm list */
> +	spinlock_t strm_lock;
> +	/* max possible number of zstrm streams */
> +	int max_strm;
> +	/* number of available zstrm streams */
> +	atomic_t avail_strm;
> +	/* list of available strms */
> +	struct list_head idle_strm;
> +	wait_queue_head_t strm_wait;
> +};
>  
>  static struct zcomp_backend *find_backend(const char *compress)
>  {
> @@ -63,6 +78,108 @@ static struct zcomp_strm *zcomp_strm_alloc(struct zcomp *comp)
>  	return zstrm;
>  }
>  
> +/*
> + * get idle zcomp_strm or wait until other process release
> + * (zcomp_strm_put()) one for us
> + */
> +static struct zcomp_strm *zcomp_strm_multi_get(struct zcomp *comp)
> +{
> +	struct zcomp_strm_multi *zs = comp->stream;
> +	struct zcomp_strm *zstrm;
> +
> +	while (1) {
> +		spin_lock(&zs->strm_lock);
> +		if (!list_empty(&zs->idle_strm)) {
> +			zstrm = list_entry(zs->idle_strm.next,
> +					struct zcomp_strm, list);
> +			list_del(&zstrm->list);
> +			spin_unlock(&zs->strm_lock);
> +			return zstrm;
> +		}
> +		/* zstrm streams limit reached, wait for idle stream */
> +		if (atomic_read(&zs->avail_strm) >= zs->max_strm) {

We need to declare it as atomic?
It seems you already protect it with spin_lock.

> +			spin_unlock(&zs->strm_lock);
> +			wait_event(zs->strm_wait, !list_empty(&zs->idle_strm));
> +			continue;
> +		}
> +		/* allocate new zstrm stream */
> +		atomic_inc(&zs->avail_strm);
> +		spin_unlock(&zs->strm_lock);
> +
> +		zstrm = zcomp_strm_alloc(comp);
> +		if (!zstrm) {
> +			atomic_dec(&zs->avail_strm);

If you use atomic due to this, it's not likely I guess so let's
use spin_lock in here, too then we could avoid atomic usage.

> +			wait_event(zs->strm_wait, !list_empty(&zs->idle_strm));
> +			continue;
> +		}
> +		break;
> +	}
> +	return zstrm;
> +}
> +
> +/* add stream back to idle list and wake up waiter or free the stream */
> +static void zcomp_strm_multi_put(struct zcomp *comp, struct zcomp_strm *zstrm)
> +{
> +	struct zcomp_strm_multi *zs = comp->stream;
> +
> +	spin_lock(&zs->strm_lock);
> +	if (atomic_read(&zs->avail_strm) <= zs->max_strm) {
> +		list_add(&zstrm->list, &zs->idle_strm);
> +		spin_unlock(&zs->strm_lock);
> +	} else {
> +		atomic_dec(&zs->avail_strm);
> +		spin_unlock(&zs->strm_lock);
> +		zcomp_strm_free(comp, zstrm);
> +	}
> +
> +	wake_up(&zs->strm_wait);

Nitpick:
Just wakeup only if we can return stream to idle list.

> +}
> +
> +static void zcomp_strm_multi_destroy(struct zcomp *comp)
> +{
> +	struct zcomp_strm_multi *zs = comp->stream;
> +	struct zcomp_strm *zstrm;
> +
> +	while (!list_empty(&zs->idle_strm)) {
> +		zstrm = list_entry(zs->idle_strm.next,
> +				struct zcomp_strm, list);
> +		list_del(&zstrm->list);
> +		zcomp_strm_free(comp, zstrm);
> +	}
> +	kfree(zs);
> +}
> +
> +static int zcomp_strm_multi_create(struct zcomp *comp, int num_strm)

Let's use max_strm instead of num_strm.

> +{
> +	struct zcomp_strm *zstrm;
> +	struct zcomp_strm_multi *zs;
> +	int i;
> +
> +	comp->destroy = zcomp_strm_multi_destroy;
> +	comp->strm_get = zcomp_strm_multi_get;
> +	comp->strm_put = zcomp_strm_multi_put;
> +	zs = kmalloc(sizeof(struct zcomp_strm_multi), GFP_KERNEL);
> +	comp->stream = zs;
> +	if (!zs)
> +		return -ENOMEM;
> +
> +	spin_lock_init(&zs->strm_lock);
> +	INIT_LIST_HEAD(&zs->idle_strm);
> +	init_waitqueue_head(&zs->strm_wait);
> +	zs->max_strm = num_strm;
> +	atomic_set(&zs->avail_strm, num_strm);

How about starting 1 stream rather than allocating max stream
in the first place?

> +
> +	for (i = 0; i < num_strm; i++) {
> +		zstrm = zcomp_strm_alloc(comp);
> +		if (!zstrm) {
> +			zcomp_strm_multi_destroy(comp);
> +			return -ENOMEM;
> +		}
> +		list_add(&zstrm->list, &zs->idle_strm);
> +	}
> +	return 0;
> +}
> +
>  static struct zcomp_strm *zcomp_strm_single_get(struct zcomp *comp)
>  {
>  	struct zcomp_strm_single *zs = comp->stream;
> -- 
> 1.9.0.291.g027825b
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Kind regards,
Minchan Kim
