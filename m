Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751691AbaCYAya (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 20:54:30 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:45370 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875AbaCYAy3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 20:54:29 -0400
Date: Tue, 25 Mar 2014 01:54:30 +0100
From: Mathieu Maret <mathieu.maret@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, arve@android.com, gregkh@linuxfoundation.org
Subject: Re: [PATCH 1/2] staging: binder: add __user annotation in binder.c
Message-ID: <20140325005430.GA25815@zebulon>
References: <1395707065-23808-1-git-send-email-mathieu.maret@gmail.com>
 <1395708685.31285.2.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1395708685.31285.2.camel@joe-AO722>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches wrote:
> On Tue, 2014-03-25 at 01:24 +0100, Mathieu Maret wrote:
> > Fix the following spare warning
> 
> sparse
> 
> > drivers/staging/android/binder.c:2691:21: warning: incorrect type in argument 1 (different address spaces)
> []
> > diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/binder.c
> []
> > @@ -2688,7 +2688,7 @@ static long binder_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
> []
> > -		if (put_user(BINDER_CURRENT_PROTOCOL_VERSION, &((struct binder_version *)ubuf)->protocol_version)) {
> > +		if (put_user(BINDER_CURRENT_PROTOCOL_VERSION, &((struct binder_version __user *)ubuf)->protocol_version)) {
> 
> That's certainly one way to do it, but I'd suggest
> using a temporary instead
> 
>  drivers/staging/android/binder.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/binder.c
> index cfe4bc8..1f5e249 100644
> --- a/drivers/staging/android/binder.c
> +++ b/drivers/staging/android/binder.c
> @@ -2683,16 +2683,20 @@ static long binder_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
>  		binder_free_thread(proc, thread);
>  		thread = NULL;
>  		break;
> -	case BINDER_VERSION:
> +	case BINDER_VERSION: {
> +		struct binder_version __user *ver = ubuf;
> +
>  		if (size != sizeof(struct binder_version)) {
>  			ret = -EINVAL;
>  			goto err;
>  		}
> -		if (put_user(BINDER_CURRENT_PROTOCOL_VERSION, &((struct binder_version *)ubuf)->protocol_version)) {
> +		if (put_user(BINDER_CURRENT_PROTOCOL_VERSION,
> +			     &ver->protocol_version)) {
>  			ret = -EINVAL;
>  			goto err;
>  		}
>  		break;
> +	}
>  	default:
>  		ret = -EINVAL;
>  		goto err;
> 
>
And you solve the issue with the line size btw.
Good move!
