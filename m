Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755334Ab3BZW25 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 17:28:57 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:44677 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752163Ab3BZW24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 17:28:56 -0500
Date: Tue, 26 Feb 2013 14:28:42 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Taprogge <jens.taprogge@taprogge.org>,
        industrypack-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ipack: add missing put_device() after device_register()
 failed
Message-ID: <20130226222842.GA20670@core.coreip.homeip.net>
References: <1361869395-23110-1-git-send-email-siglesias@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1361869395-23110-1-git-send-email-siglesias@igalia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2013 at 10:03:15AM +0100, Samuel Iglesias Gonsalvez wrote:
> put_device() must be called after device_register() fails,
> since device_register() always initializes the refcount
> on the device structure to one.
> 
> dev->id is free'd inside of ipack_device_release function.
> So, it's not needed to do it here.
> 
> Signed-off-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
> ---
>  drivers/ipack/ipack.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/ipack/ipack.c b/drivers/ipack/ipack.c
> index 7ec6b20..3588ccf 100644
> --- a/drivers/ipack/ipack.c
> +++ b/drivers/ipack/ipack.c
> @@ -449,7 +449,7 @@ int ipack_device_register(struct ipack_device *dev)
>  
>  	ret = device_register(&dev->dev);
>  	if (ret < 0)
> -		kfree(dev->id);
> +		put_device(&dev->dev);

Now callers have no idea if they have to free (put_device) it in case of
failure or it is already done for them, because a few lines earlier, if
pack_device_read_id() fails, it simply returns error code.

IMO if a function did not allocate object it should not try to free it,
callers should dispose of the device as they see fit.

What is missing, however, is dev->id = NULL assignment so that if caller
does put_device() kit won't double-free the memory. Also it would make
sense to split device_register into device_init() and device_add() so
that device_init() is very first thing you do and in case of all
failures callers should use put_device().

Also tpci200.c need to learn to clean up after itself and I also not
sure why it tries to provide its own release function.

Thanks.

-- 
Dmitry
