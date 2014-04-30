Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946061AbaD3UpV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 16:45:21 -0400
Received: from mail.ispras.ru ([83.149.199.45]:56026 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946030AbaD3UpT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 16:45:19 -0400
Message-ID: <536160DE.80508@ispras.ru>
Date: Thu, 01 May 2014 00:45:18 +0400
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: David Fries <David@Fries.net>, Evgeniy Polyakov <zbr@ioremap.net>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Subject: Re: [PATCH] w1: do not unlock unheld list_mutex in __w1_remove_master_device()
References: <1398890278-15319-1-git-send-email-khoroshilov@ispras.ru>
In-Reply-To: <1398890278-15319-1-git-send-email-khoroshilov@ispras.ru>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As far as it is 3.15-rc1 regression introduced by 9fcbbac5ded48,
it makes sense to fix it in 3.15 cycle.

--
Alexey

On 01.05.2014 00:37, Alexey Khoroshilov wrote:
> w1_process_callbacks() expects to be called with dev->list_mutex held,
> but it is the fact only in w1_process(). __w1_remove_master_device()
> calls w1_process_callbacks() after it releases list_mutex.
>
> The patch fixes __w1_remove_master_device() to acquire list_mutex
> for w1_process_callbacks(). It is implemented by moving
> w1_process_callbacks() functionality to __w1_process_callbacks()
> and adding a wrapper with the old name.
>
> Found by Linux Driver Verification project (linuxtesting.org).
>
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

