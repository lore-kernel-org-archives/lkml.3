Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753872Ab3KCO2X (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Nov 2013 09:28:23 -0500
Received: from mga03.intel.com ([143.182.124.21]:24707 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753418Ab3KCO2W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Nov 2013 09:28:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,626,1378882800"; 
   d="scan'208";a="421597491"
Date: Sun, 3 Nov 2013 22:28:17 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Jason Wang <jasowang@redhat.com>, "David S. Miller" <davem@davemloft.net>
Cc: virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [virtio-net] BUG: sleeping function called from invalid context
 at kernel/mutex.c:616
Message-ID: <20131103142817.GA7641@localhost>
References: <20131020023418.GA6737@localhost>
 <526638D4.1030403@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <526638D4.1030403@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I noticed that this fix is still not upstreamed. Any chance to push it
to Linus before the 3.12 release?

> >From 01e6c3f71c202aa02e4feda169e7cc9fb24193f5 Mon Sep 17 00:00:00 2001
> From: Jason Wang <jasowang@redhat.com>
> Date: Mon, 21 Oct 2013 20:39:09 +0800
> Subject: [PATCH] virtio-net: fix
> 
> ---
>  drivers/net/virtio_net.c | 13 ++++++-------
>  1 file changed, 6 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 9fbdfcd..bbc9cb8 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -1118,11 +1118,6 @@ static int virtnet_cpu_callback(struct notifier_block *nfb,
>  {
>  	struct virtnet_info *vi = container_of(nfb, struct virtnet_info, nb);
>  
> -	mutex_lock(&vi->config_lock);
> -
> -	if (!vi->config_enable)
> -		goto done;
> -
>  	switch(action & ~CPU_TASKS_FROZEN) {
>  	case CPU_ONLINE:
>  	case CPU_DOWN_FAILED:
> @@ -1136,8 +1131,6 @@ static int virtnet_cpu_callback(struct notifier_block *nfb,
>  		break;
>  	}
>  
> -done:
> -	mutex_unlock(&vi->config_lock);
>  	return NOTIFY_OK;
>  }
>  
> @@ -1699,6 +1692,8 @@ static int virtnet_freeze(struct virtio_device *vdev)
>  	struct virtnet_info *vi = vdev->priv;
>  	int i;
>  
> +	unregister_hotcpu_notifier(&vi->nb);
> +
>  	/* Prevent config work handler from accessing the device */
>  	mutex_lock(&vi->config_lock);
>  	vi->config_enable = false;
> @@ -1747,6 +1742,10 @@ static int virtnet_restore(struct virtio_device *vdev)
>  	virtnet_set_queues(vi, vi->curr_queue_pairs);
>  	rtnl_unlock();
>  
> +	err = register_hotcpu_notifier(&vi->nb);
> +	if (err)
> +		return err;
> +
>  	return 0;
>  }
>  #endif
> -- 
> 1.8.1.2
> 

