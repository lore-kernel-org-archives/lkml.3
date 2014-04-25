Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752024AbaDYWNg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 18:13:36 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:44165 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751389AbaDYWNf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 18:13:35 -0400
X-Sasl-enc: FXpVDbsdrV19rx/yF7tTRsHWrWG8cBfSJJLNu5HGdEUm 1398464013
Date: Fri, 25 Apr 2014 15:16:25 -0700
From: Greg KH <greg@kroah.com>
To: Camille Bordignon <camille.bordignon@gmail.com>
Cc: arve@android.com, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] staging: android: Fix warning cast removes address
 space of expression
Message-ID: <20140425221625.GA2936@kroah.com>
References: <1397985057.12169.7.camel@vash.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397985057.12169.7.camel@vash.home>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 20, 2014 at 11:10:57AM +0200, Camille Bordignon wrote:
> Fix sparse warning "cast removes address space of expression"
> Add lost flag "__user" due to cast
> 
> Signed-off-by: Camille Bordignon <camille.bordignon@gmail.com>
> ---
> diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/binder.c
> index cfe4bc8..952c4ae 100644
> --- a/drivers/staging/android/binder.c
> +++ b/drivers/staging/android/binder.c
> @@ -2683,16 +2683,21 @@ static long binder_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
>  		binder_free_thread(proc, thread);
>  		thread = NULL;
>  		break;
> -	case BINDER_VERSION:
> -		if (size != sizeof(struct binder_version)) {
> +	case BINDER_VERSION: {
> +		struct binder_version __user *bv = ubuf;
> +
> +		if (size != sizeof(*bv)) {
>  			ret = -EINVAL;
>  			goto err;
>  		}
> -		if (put_user(BINDER_CURRENT_PROTOCOL_VERSION, &((struct binder_version *)ubuf)->protocol_version)) {
> +
> +		if (put_user(BINDER_CURRENT_PROTOCOL_VERSION,
> +				&bv->protocol_version)) {
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

This does not apply to my tree :(
