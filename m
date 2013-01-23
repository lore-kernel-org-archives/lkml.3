Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752531Ab3AWVxR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 16:53:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27665 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752181Ab3AWVxL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 16:53:11 -0500
Date: Wed, 23 Jan 2013 23:04:11 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Romain Francoise <romain@orebokech.com>
Cc: kvm@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vhost-net: fall back to vmalloc if high-order allocation
 fails
Message-ID: <20130123210411.GA9055@redhat.com>
References: <87k3r31vbc.fsf@silenus.orebokech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87k3r31vbc.fsf@silenus.orebokech.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 23, 2013 at 09:46:47PM +0100, Romain Francoise wrote:
> Creating a vhost-net device allocates an object large enough (34320 bytes
> on x86-64) to trigger an order-4 allocation, which may fail if memory if
> fragmented:
> 
>  libvirtd: page allocation failure: order:4, mode:0x2000d0
>  ...
>  SLAB: Unable to allocate memory on node 0 (gfp=0xd0)
>    cache: size-65536, object size: 65536, order: 4
>    node 0: slabs: 8/8, objs: 8/8, free: 0
> 
> In that situation, rather than forcing the caller to use regular
> virtio-net, try to allocate the descriptor with vmalloc().
> 
> Signed-off-by: Romain Francoise <romain@orebokech.com>

Thanks for the patch.
Hmm, I haven't seen this.
Maybe we should try and reduce our memory usage,
I will look into this.

> ---
>  drivers/vhost/net.c | 18 +++++++++++++++---
>  1 file changed, 15 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
> index ebd08b2..1ded79b 100644
> --- a/drivers/vhost/net.c
> +++ b/drivers/vhost/net.c
> @@ -18,6 +18,7 @@
>  #include <linux/rcupdate.h>
>  #include <linux/file.h>
>  #include <linux/slab.h>
> +#include <linux/vmalloc.h>
>  
>  #include <linux/net.h>
>  #include <linux/if_packet.h>
> @@ -603,12 +604,23 @@ static void handle_rx_net(struct vhost_work *work)
>  	handle_rx(net);
>  }
>  
> +static void vhost_net_kvfree(void *addr)
> +{
> +	if (is_vmalloc_addr(addr))
> +		vfree(addr);
> +	else
> +		kfree(addr);
> +}
> +
>  static int vhost_net_open(struct inode *inode, struct file *f)
>  {
> -	struct vhost_net *n = kmalloc(sizeof *n, GFP_KERNEL);
> +	struct vhost_net *n;
>  	struct vhost_dev *dev;
>  	int r;
>  
> +	n = kmalloc(sizeof *n, GFP_KERNEL | __GFP_NOWARN);
> +	if (!n)
> +		n = vmalloc(sizeof *n);
>  	if (!n)
>  		return -ENOMEM;
>  
> @@ -617,7 +629,7 @@ static int vhost_net_open(struct inode *inode, struct file *f)
>  	n->vqs[VHOST_NET_VQ_RX].handle_kick = handle_rx_kick;
>  	r = vhost_dev_init(dev, n->vqs, VHOST_NET_VQ_MAX);
>  	if (r < 0) {
> -		kfree(n);
> +		vhost_net_kvfree(n);
>  		return r;
>  	}
>  
> @@ -719,7 +731,7 @@ static int vhost_net_release(struct inode *inode, struct file *f)
>  	/* We do an extra flush before freeing memory,
>  	 * since jobs can re-queue themselves. */
>  	vhost_net_flush(n);
> -	kfree(n);
> +	vhost_net_kvfree(n);
>  	return 0;
>  }
>  
> -- 
> 1.8.1.1
