Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752007AbbANUqh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 15:46:37 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42003 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719AbbANUqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 15:46:36 -0500
Date: Wed, 14 Jan 2015 12:46:35 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: ashishsangwan2@gmail.com
Cc: linux-kernel@vger.kernel.org, Ashish Sangwan <a.sangwan@samsung.com>,
        Namjae Jeon <namjae.jeon@samsung.com>
Subject: Re: [PATCH] driver core: access dev->driver under dev->mutex in
 dev_uevent
Message-ID: <20150114204635.GD31119@kroah.com>
References: <1421259054-2574-1-git-send-email-a.sangwan@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421259054-2574-1-git-send-email-a.sangwan@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2015 at 11:40:54PM +0530, ashishsangwan2@gmail.com wrote:
> From: Ashish Sangwan <a.sangwan@samsung.com>
> 
> We have hit a race condition while parallely accessing device's uevent
> and rmmoding device's driver.

How are you doing that?  By reading the uevent file and removing the
device?

Removing a kernel module is not a "normal" thing at all, so this type of
"error" is very low on anyone's list.

> In dev_uevent() first dev->driver is checked if
> present which becomes true but before calling add_uevent_var 
> dev->driver is set to NULL and driver is freed in __device_release_driver().
> This results in either NULL pointer derefrence or invalid virtual address
> access. Fix this race by accessing dev->driver under dev->mutex.
> 
> Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> ---
>  drivers/base/core.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/base/core.c b/drivers/base/core.c
> index 97e2baf..f8e854a 100644
> --- a/drivers/base/core.c
> +++ b/drivers/base/core.c
> @@ -326,8 +326,15 @@ static int dev_uevent(struct kset *kset, struct kobject *kobj,
>  	if (dev->type && dev->type->name)
>  		add_uevent_var(env, "DEVTYPE=%s", dev->type->name);
>  
> +	/*
> +	 * dev->driver is set NULL under dev->mutex so it should be checked
> +	 * after acquiring dev->mutex. This prevents a race between 
> +	 * __device_release_driver and dev_uevent.
> +	 */
> +	device_lock(dev);
>  	if (dev->driver)
>  		add_uevent_var(env, "DRIVER=%s", dev->driver->name);
> +	device_unlock(dev);

Always run your patches through checkpatch before sending them out so
you don't get grumpy email responses about how you need to run patches
through checkpatch before sending them out...

thanks,

greg k-h
