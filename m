Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753086Ab3BCLFT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 06:05:19 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:35604 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751982Ab3BCLFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 06:05:16 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 3 Feb 2013 12:03:44 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        rusty@rustcorp.com.au, bfields@fieldses.org, skinsbursky@parallels.com,
        ebiederm@xmission.com, jmorris@namei.org, axboe@kernel.dk,
        linux1394-devel@lists.sourceforge.net
Subject: Re: [PATCH 13/62] firewire: convert to idr_alloc()
Message-ID: <20130203120344.2e31b500@stein>
In-Reply-To: <1359854463-2538-14-git-send-email-tj@kernel.org>
References: <1359854463-2538-1-git-send-email-tj@kernel.org>
	<1359854463-2538-14-git-send-email-tj@kernel.org>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.12; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 02 Tejun Heo wrote:
> Convert to the much saner new idr interface.
> 
> Only compile tested.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>
> Cc: linux1394-devel@lists.sourceforge.net
> ---
> This patch depends on an earlier idr changes and I think it would be
> best to route these together through -mm.  Please holler if there's
> any objection.  Thanks.
> 
>  drivers/firewire/core-cdev.c   | 16 +++++++---------
>  drivers/firewire/core-device.c |  5 ++---
>  2 files changed, 9 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/firewire/core-cdev.c b/drivers/firewire/core-cdev.c
> index 68c3138..46a1f88 100644
> --- a/drivers/firewire/core-cdev.c
> +++ b/drivers/firewire/core-cdev.c
> @@ -490,24 +490,22 @@ static int add_client_resource(struct client *client,
>  	unsigned long flags;
>  	int ret;
>  
> - retry:
> -	if (idr_pre_get(&client->resource_idr, gfp_mask) == 0)
> -		return -ENOMEM;
> -
> +	idr_preload(gfp_mask);
>  	spin_lock_irqsave(&client->lock, flags);
> +
>  	if (client->in_shutdown)
>  		ret = -ECANCELED;
>  	else
> -		ret = idr_get_new(&client->resource_idr, resource,
> -				  &resource->handle);
> +		ret = idr_alloc(&client->resource_idr, resource, 0, 0,
> +				GFP_NOWAIT);
>  	if (ret >= 0) {
> +		resource->handle = ret;
>  		client_get(client);
>  		schedule_if_iso_resource(resource);
>  	}
> -	spin_unlock_irqrestore(&client->lock, flags);
>  
> -	if (ret == -EAGAIN)
> -		goto retry;
> +	spin_unlock_irqrestore(&client->lock, flags);
> +	idr_preload_end();
>  
>  	return ret < 0 ? ret : 0;
>  }

Most of the add_client_resource() callers are process context (user
process doing an ioctl()), and for them this is going to work fine.  But
one caller is tasklet context (firewire-ohci's asynchronous reception DMA
IRQ handler "bottom half").

The kerneldoc comment in 05/62 "idr: implement idr_preload[_end]() and
idr_alloc()" tells me that idr_preload and idr_preload_end must be used in
process context only.  Can it work in tasklet context regardless?  I am
not entirely sure from looking at the implementation.

> diff --git a/drivers/firewire/core-device.c b/drivers/firewire/core-device.c
> index 3873d53..c137de6 100644
> --- a/drivers/firewire/core-device.c
> +++ b/drivers/firewire/core-device.c
> @@ -1017,13 +1017,12 @@ static void fw_device_init(struct work_struct *work)
>  
>  	fw_device_get(device);
>  	down_write(&fw_device_rwsem);
> -	ret = idr_pre_get(&fw_device_idr, GFP_KERNEL) ?
> -	      idr_get_new(&fw_device_idr, device, &minor) :
> -	      -ENOMEM;
> +	ret = idr_alloc(&fw_device_idr, device, 0, 0, GFP_KERNEL);
>  	up_write(&fw_device_rwsem);
>  
>  	if (ret < 0)
>  		goto error;
> +	minor = ret;
>  
>  	device->device.bus = &fw_bus_type;
>  	device->device.type = &fw_device_type;

This hunk is OK, of course.
-- 
Stefan Richter
-=====-===-= --=- ---==
http://arcgraph.de/sr/
