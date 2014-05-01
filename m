Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752050AbaEADsY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 23:48:24 -0400
Received: from SpacedOut.fries.net ([67.64.210.234]:46758 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034AbaEADsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 23:48:23 -0400
Date: Wed, 30 Apr 2014 22:48:00 -0500
From: David Fries <David@Fries.net>
To: Alexey Khoroshilov <khoroshilov@ispras.ru>
Cc: Evgeniy Polyakov <zbr@ioremap.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Subject: Re: [PATCH] w1: do not unlock unheld list_mutex in
 __w1_remove_master_device()
Message-ID: <20140501034759.GG5096@spacedout.fries.net>
References: <1398890278-15319-1-git-send-email-khoroshilov@ispras.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398890278-15319-1-git-send-email-khoroshilov@ispras.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.3.9 (SpacedOut.fries.net [127.0.0.1]); Wed, 30 Apr 2014 22:48:02 -0500 (CDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 01, 2014 at 12:37:58AM +0400, Alexey Khoroshilov wrote:
> w1_process_callbacks() expects to be called with dev->list_mutex held,
> but it is the fact only in w1_process(). __w1_remove_master_device()
> calls w1_process_callbacks() after it releases list_mutex.
> 
> The patch fixes __w1_remove_master_device() to acquire list_mutex
> for w1_process_callbacks(). It is implemented by moving
> w1_process_callbacks() functionality to __w1_process_callbacks()
> and adding a wrapper with the old name.

Good catch.  I guess as it was in the shutdown path it failed the
unlock silently.

I would prefer a different fix.  If w1_process_callbacks was more of a
public facing API called from multiple locations where the caller
doesn't have access to the locks, something like this would probably
be the way to go.  This is called from two areas of the code, and not
likely to be called from any new areas in the future.

Adding a documentation comment is good.  I would be tempted in
__w1_remove_master_device to move the dev->list_mutex down after the
while loop, but I can't be sure that whatever has a refcnt wouldn't
need list_mutex.  The last w1_process_callbacks after the while loop
shouldn't be needed I wouldn't think, I was just being defensive.  By
the time it completes the while loop the reference count is 0 so there
shouldn't be anything left for it to process and if there is, it's a
race condition and game over anyway.  So just sandwich
w1_process_callbacks with the lock/unlock in
__w1_remove_master_device please.

> Found by Linux Driver Verification project (linuxtesting.org).

Was this found with code inspection or hardware testing with lock
debugging enabled?

> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
> ---
>  drivers/w1/w1.c |  8 +++++---
>  drivers/w1/w1.h | 13 ++++++++++++-
>  2 files changed, 17 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/w1/w1.c b/drivers/w1/w1.c
> index ff52618cafbe..e507c51512aa 100644
> --- a/drivers/w1/w1.c
> +++ b/drivers/w1/w1.c
> @@ -1075,12 +1075,14 @@ static void w1_search_process(struct w1_master *dev, u8 search_type)
>  }
>  
>  /**
> - * w1_process_callbacks() - execute each dev->async_list callback entry
> + * __w1_process_callbacks() - execute each dev->async_list callback entry
>   * @dev: w1_master device
>   *
> + * The w1 master list_mutex must be held.
> + *
>   * Return: 1 if there were commands to executed 0 otherwise
>   */
> -int w1_process_callbacks(struct w1_master *dev)
> +int __w1_process_callbacks(struct w1_master *dev)
>  {
>  	int ret = 0;
>  	struct w1_async_cmd *async_cmd, *async_n;
> @@ -1122,7 +1124,7 @@ int w1_process(void *data)
>  		/* Note, w1_process_callback drops the lock while processing,
>  		 * but locks it again before returning.
>  		 */
> -		if (!w1_process_callbacks(dev) && jremain) {
> +		if (!__w1_process_callbacks(dev) && jremain) {
>  			/* a wake up is either to stop the thread, process
>  			 * callbacks, or search, it isn't process callbacks, so
>  			 * schedule a search.
> diff --git a/drivers/w1/w1.h b/drivers/w1/w1.h
> index 734dab7fc687..e357321a5e13 100644
> --- a/drivers/w1/w1.h
> +++ b/drivers/w1/w1.h
> @@ -341,9 +341,20 @@ extern int w1_max_slave_ttl;
>  extern struct list_head w1_masters;
>  extern struct mutex w1_mlock;
>  
> -extern int w1_process_callbacks(struct w1_master *dev);
> +extern int __w1_process_callbacks(struct w1_master *dev);
>  extern int w1_process(void *);
>  
> +static inline int w1_process_callbacks(struct w1_master *dev)
> +{
> +	int ret;
> +
> +	mutex_lock(&dev->list_mutex);
> +	ret = __w1_process_callbacks(dev);
> +	mutex_unlock(&dev->list_mutex);
> +	return ret;
> +}
> +
> +
>  #endif /* __KERNEL__ */
>  
>  #endif /* __W1_H */
> -- 
> 1.8.3.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
David Fries <david@fries.net>    PGP pub CB1EE8F0
http://fries.net/~david/
