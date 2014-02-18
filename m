Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751861AbaBRTHF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 14:07:05 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:48088 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126AbaBRTHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 14:07:04 -0500
Date: Tue, 18 Feb 2014 11:08:28 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: John Stultz <john.stultz@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Serban Constantinescu <serban.constantinescu@arm.com>,
        Colin Cross <ccross@android.com>,
        Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        Android Kernel Team <kernel-team@android.com>
Subject: Re: [PATCH 12/14] staging: binder: Fix ABI for 64bit Android
Message-ID: <20140218190828.GA10376@kroah.com>
References: <1392674322-9036-1-git-send-email-john.stultz@linaro.org>
 <1392674322-9036-13-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1392674322-9036-13-git-send-email-john.stultz@linaro.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 17, 2014 at 01:58:40PM -0800, John Stultz wrote:
> From: Serban Constantinescu <serban.constantinescu@arm.com>
> 
> This patch fixes the ABI for 64bit Android userspace.
> BC_REQUEST_DEATH_NOTIFICATION and BC_CLEAR_DEATH_NOTIFICATION claim
> to be using struct binder_ptr_cookie, but they are using a 32bit handle
> and a pointer.
> 
> On 32bit systems the payload size is the same as the size of struct
> binder_ptr_cookie, however for 64bit systems this will differ. This
> patch adds struct binder_handle_cookie that fixes this issue for 64bit
> Android.
> 
> Since there are no 64bit users of this interface that we know of this
> change should not affect any existing systems.

But you are changing the ioctl structures here, what is that going to
cause with old programs?

> 
> Cc: Colin Cross <ccross@android.com>
> Cc: Arve Hjønnevåg <arve@android.com>
> Cc: Serban Constantinescu <serban.constantinescu@arm.com>
> Cc: Android Kernel Team <kernel-team@android.com>

I am going to require Acks from someone on the Android team to accept
this, or any other 64bit binder patch, given all the back-and-forth that
has happened with the different patch sets here over the past year or
so.

Until then, I can't take this (and I think this patch is still
broken...)

> Signed-off-by: Serban Constantinescu <serban.constantinescu@arm.com>
> [jstultz: Minor commit tweaks, few 80+ col fixes for checkpatch]
> Signed-off-by: John Stultz <john.stultz@linaro.org>
> ---
>  drivers/staging/android/uapi/binder.h | 15 +++++++++++----
>  1 file changed, 11 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/staging/android/uapi/binder.h b/drivers/staging/android/uapi/binder.h
> index 2b1eb81..4071fcf 100644
> --- a/drivers/staging/android/uapi/binder.h
> +++ b/drivers/staging/android/uapi/binder.h
> @@ -152,6 +152,11 @@ struct binder_ptr_cookie {
>  	void *cookie;
>  };
>  
> +struct binder_handle_cookie {
> +	__u32 handle;
> +	void *cookie;
> +} __attribute__((packed));

Are you sure this isn't supposed to be a union?

> +
>  struct binder_pri_desc {
>  	__s32 priority;
>  	__u32 desc;
> @@ -308,15 +313,17 @@ enum binder_driver_command_protocol {
>  	 * of looping threads it has available.
>  	 */
>  
> -	BC_REQUEST_DEATH_NOTIFICATION = _IOW('c', 14, struct binder_ptr_cookie),
> +	BC_REQUEST_DEATH_NOTIFICATION = _IOW('c', 14,
> +						struct binder_handle_cookie),
>  	/*
> -	 * void *: ptr to binder
> +	 * int: handle
>  	 * void *: cookie

How does this not break existing user/kernel code if only one of them
gets rebuilt with this new header file?  You just changed the ABI here,
not nice...

greg k-h
