Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932100AbaHNUJX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 16:09:23 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:37233 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754070AbaHNUJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 16:09:21 -0400
Date: Thu, 14 Aug 2014 13:09:51 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: Sumit Semwal <sumit.semwal@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Colin Cross <ccross@google.com>, John Stultz <john.stultz@linaro.org>,
        devel@driverdev.osuosl.org
Subject: Re: [PATCH 2/2] android: add sync_fence_create_dma
Message-ID: <20140814130951.7c5da411@jbarnes-desktop>
In-Reply-To: <53EC876C.9050705@canonical.com>
References: <53EC8722.4070407@canonical.com>
	<53EC876C.9050705@canonical.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Aug 2014 11:54:52 +0200
Maarten Lankhorst <maarten.lankhorst@canonical.com> wrote:

> This allows users of dma fences to create a android fence.
> 
> Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
> Cc: Daniel Vetter <daniel@ffwll.ch>
> Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
> ---
>  drivers/staging/android/sync.c | 24 ++++++++++++++++++++----
>  drivers/staging/android/sync.h | 11 +++++++++++
>  2 files changed, 31 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/staging/android/sync.c b/drivers/staging/android/sync.c
> index 69139ce7420d..c9331250ac26 100644
> --- a/drivers/staging/android/sync.c
> +++ b/drivers/staging/android/sync.c
> @@ -188,7 +188,7 @@ static void fence_check_cb_func(struct fence *f, struct fence_cb *cb)
>  }
>  
>  /* TODO: implement a create which takes more that one sync_pt */
> -struct sync_fence *sync_fence_create(const char *name, struct sync_pt *pt)
> +static struct sync_fence *sync_fence_create_noref(const char *name, struct fence *pt)
>  {
>  	struct sync_fence *fence;
>  
> @@ -199,16 +199,32 @@ struct sync_fence *sync_fence_create(const char *name, struct sync_pt *pt)
>  	fence->num_fences = 1;
>  	atomic_set(&fence->status, 1);
>  
> -	fence->cbs[0].sync_pt = &pt->base;
> +	fence->cbs[0].sync_pt = pt;
>  	fence->cbs[0].fence = fence;
> -	if (fence_add_callback(&pt->base, &fence->cbs[0].cb,
> -			       fence_check_cb_func))
> +	if (fence_add_callback(pt, &fence->cbs[0].cb, fence_check_cb_func))
>  		atomic_dec(&fence->status);
>  
>  	sync_fence_debug_add(fence);
>  
>  	return fence;
>  }
> +
> +struct sync_fence *sync_fence_create_dma(const char *name, struct fence *pt)
> +{
> +	struct sync_fence *fence;

I ran into the same naming trouble in my implementation; I think I
ended up with sfence for sync fence declarations.

> +
> +	fence = sync_fence_create_noref(name, fence_get(pt));
> +	if (!fence)
> +		fence_put(pt);
> +
> +	return fence;
> +}
> +EXPORT_SYMBOL(sync_fence_create_dma);
> +
> +struct sync_fence *sync_fence_create(const char *name, struct sync_pt *pt)
> +{
> +	return sync_fence_create_noref(name, &pt->base);
> +}
>  EXPORT_SYMBOL(sync_fence_create);
>  
>  struct sync_fence *sync_fence_fdget(int fd)
> diff --git a/drivers/staging/android/sync.h b/drivers/staging/android/sync.h
> index 66b0f431f63e..7b3bf560790c 100644
> --- a/drivers/staging/android/sync.h
> +++ b/drivers/staging/android/sync.h
> @@ -254,6 +254,17 @@ void sync_pt_free(struct sync_pt *pt);
>   */
>  struct sync_fence *sync_fence_create(const char *name, struct sync_pt *pt);
>  
> +/**
> + * sync_fence_create_dma() - creates a sync fence from a dma fence
> + * @name:	name of fence to create
> + * @pt:		dma fence to add to the sync fence
> + *
> + * Creates a fence containg @pt.  Once this is called, the fence takes
> + * a reference on @pt, unlike sync_fence_create which doesn't add one.
> + */
> +struct sync_fence *sync_fence_create_dma(const char *name, struct fence *pt);
> +
> +
>  /*
>   * API for sync_fence consumers
>   */

Yeah, I've been using this, looks good.

Reviewed-by: Jesse Barnes <jbarnes@virtuousgeek.org>

-- 
Jesse Barnes, Intel Open Source Technology Center
