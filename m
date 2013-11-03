Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753612Ab3KCOtM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Nov 2013 09:49:12 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:49605 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752431Ab3KCOtK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Nov 2013 09:49:10 -0500
X-Sasl-enc: vpzIYYbcRZojcoEFd3kWevKQycwmtSnuFqIZxpfEHA3h 1383490149
Date: Sun, 3 Nov 2013 06:51:18 -0800
From: Greg KH <greg@kroah.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/4] random: use device attach events for entropy
Message-ID: <20131103145118.GD2007@kroah.com>
References: <1383485595-2020-1-git-send-email-tytso@mit.edu>
 <1383485595-2020-2-git-send-email-tytso@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383485595-2020-2-git-send-email-tytso@mit.edu>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 03, 2013 at 08:33:12AM -0500, Theodore Ts'o wrote:
> Some investigation from FreeBSD shows that there is entropy available
> from measuring the device attach times:
> 
> http://lists.randombit.net/pipermail/cryptography/2013-October/005689.html
> 
> This will hopefully help us more quickly initialize the entropy pools
> while the system is booting (which is one of the times when we really
> badly need more entropy, especially in the case of the first boot
> after an consumer electronics device is taken out of the box).
> 
> Measurements indicate this makes a huge improvement in the security of
> /dev/urandom during the boot sequence, so I'm cc'ing this to the
> stable kernel series.  Especially for embedded systems, which use
> flash and which don't necessarily have the network enabled when they
> first generate ssh or x.509 keys (sigh), this can be a big deal.
> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> Cc: stable@vger.kernel.org
> ---
>  drivers/base/core.c    | 3 +++
>  drivers/char/random.c  | 7 +++++++
>  include/linux/random.h | 2 ++
>  3 files changed, 12 insertions(+)
> 
> diff --git a/drivers/base/core.c b/drivers/base/core.c
> index 8856d74..5e98fc3 100644
> --- a/drivers/base/core.c
> +++ b/drivers/base/core.c
> @@ -26,6 +26,7 @@
>  #include <linux/async.h>
>  #include <linux/pm_runtime.h>
>  #include <linux/netdevice.h>
> +#include <linux/random.h>
>  
>  #include "base.h"
>  #include "power/power.h"
> @@ -1156,6 +1157,8 @@ int device_add(struct device *dev)
>  				class_intf->add_dev(dev, class_intf);
>  		mutex_unlock(&dev->class->p->mutex);
>  	}
> +	add_device_attach_randomness(dev);
> +
>  done:
>  	put_device(dev);
>  	return error;
> diff --git a/drivers/char/random.c b/drivers/char/random.c
> index f126bd2..51153fe 100644
> --- a/drivers/char/random.c
> +++ b/drivers/char/random.c
> @@ -829,6 +829,13 @@ void add_input_randomness(unsigned int type, unsigned int code,
>  }
>  EXPORT_SYMBOL_GPL(add_input_randomness);
>  
> +void add_device_attach_randomness(struct device *dev)
> +{
> +	static struct timer_rand_state attach_state = { 0, };
> +
> +	add_timer_randomness(&attach_state, dev->devt);

Is it an issue that dev->devt will almost always be 0,0 for this
function call?  Why not use the name instead here, that's more "unique"
and every device has one, not just a tiny %.

thanks,

greg k-h
