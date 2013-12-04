Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932852Ab3LDXzh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 18:55:37 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36279 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932482Ab3LDXzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 18:55:32 -0500
Date: Wed, 4 Dec 2013 15:17:45 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Serban Constantinescu <serban.constantinescu@arm.com>
Cc: arve@android.com, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        john.stultz@linaro.org, ccross@android.com, Dave.Butcher@arm.com,
        irogers@google.com, romlem@android.com
Subject: Re: [PATCH v1 2/9] staging: android: binder: Add
 binder_copy_to_user()
Message-ID: <20131204231745.GA10410@kroah.com>
References: <1386180581-6710-1-git-send-email-serban.constantinescu@arm.com>
 <1386180581-6710-3-git-send-email-serban.constantinescu@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386180581-6710-3-git-send-email-serban.constantinescu@arm.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 04, 2013 at 06:09:34PM +0000, Serban Constantinescu wrote:
> This patch adds binder_copy_to_user() to be used for copying binder
> commands to user address space. This way we can abstract away the
> copy_to_user() calls and add separate handling for the compat layer.
> 
> Signed-off-by: Serban Constantinescu <serban.constantinescu@arm.com>
> ---
>  drivers/staging/android/binder.c |   39 ++++++++++++++++++++------------------
>  1 file changed, 21 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/binder.c
> index 233889c..6fbb340 100644
> --- a/drivers/staging/android/binder.c
> +++ b/drivers/staging/android/binder.c
> @@ -2117,6 +2117,18 @@ static int binder_has_thread_work(struct binder_thread *thread)
>  		(thread->looper & BINDER_LOOPER_STATE_NEED_RETURN);
>  }
>  
> +static int binder_copy_to_user(uint32_t cmd, void *parcel,
> +			       void __user **ptr, size_t size)
> +{
> +	if (put_user(cmd, (uint32_t __user *)*ptr))
> +		return -EFAULT;
> +	*ptr += sizeof(uint32_t);
> +	if (copy_to_user(*ptr, parcel, size))
> +		return -EFAULT;
> +	*ptr += size;
> +	return 0;
> +}

I know what you are trying to do here, but ick, why not just use the
structure involved in the copying out here?  Or just copy the thing out
in one "chunk", not two different calls, which should make this go
faster, right?


> +
>  static int binder_thread_read(struct binder_proc *proc,
>  			      struct binder_thread *thread,
>  			      void  __user *buffer, size_t size,
> @@ -2263,15 +2275,12 @@ retry:
>  				node->has_weak_ref = 0;
>  			}
>  			if (cmd != BR_NOOP) {
> -				if (put_user(cmd, (uint32_t __user *)ptr))
> -					return -EFAULT;
> -				ptr += sizeof(uint32_t);
> -				if (put_user(node->ptr, (void * __user *)ptr))
> -					return -EFAULT;
> -				ptr += sizeof(void *);
> -				if (put_user(node->cookie, (void * __user *)ptr))
> +				struct binder_ptr_cookie tmp;
> +
> +				tmp.ptr = node->ptr;
> +				tmp.cookie = node->cookie;
> +				if (binder_copy_to_user(cmd, &tmp, &ptr, sizeof(struct binder_ptr_cookie)))
>  					return -EFAULT;
> -				ptr += sizeof(void *);

Are you sure this is correct?  You are now no longer incrementing ptr
anymore, is that ok with the larger loop here?


>  
>  				binder_stat_br(proc, thread, cmd);
>  				binder_debug(BINDER_DEBUG_USER_REFS,
> @@ -2306,12 +2315,10 @@ retry:
>  				cmd = BR_CLEAR_DEATH_NOTIFICATION_DONE;
>  			else
>  				cmd = BR_DEAD_BINDER;
> -			if (put_user(cmd, (uint32_t __user *)ptr))
> -				return -EFAULT;
> -			ptr += sizeof(uint32_t);
> -			if (put_user(death->cookie, (void * __user *)ptr))
> +
> +			if (binder_copy_to_user(cmd, &death->cookie, &ptr, sizeof(void *)))
>  				return -EFAULT;
> -			ptr += sizeof(void *);
> +

Same here, no more ptr incrementing.


>  			binder_stat_br(proc, thread, cmd);
>  			binder_debug(BINDER_DEBUG_DEATH_NOTIFICATION,
>  				     "%d:%d %s %p\n",
> @@ -2373,12 +2380,8 @@ retry:
>  					ALIGN(t->buffer->data_size,
>  					    sizeof(void *));
>  
> -		if (put_user(cmd, (uint32_t __user *)ptr))
> -			return -EFAULT;
> -		ptr += sizeof(uint32_t);
> -		if (copy_to_user(ptr, &tr, sizeof(tr)))
> +		if (binder_copy_to_user(cmd, &tr, &ptr, sizeof(struct binder_transaction_data)))
>  			return -EFAULT;
> -		ptr += sizeof(tr);

And here, no more ptr incrementing.

thanks,

greg k-h
