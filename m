Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755110Ab3I3BvO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 21:51:14 -0400
Received: from ozlabs.org ([203.10.76.45]:44647 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755018Ab3I3BvM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 21:51:12 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jason Wang <jasowang@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Cc: Jason Wang <jasowang@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH net-next] virtio-net: switch to use XPS to choose txq
In-Reply-To: <1380261444-40918-1-git-send-email-jasowang@redhat.com>
References: <1380261444-40918-1-git-send-email-jasowang@redhat.com>
User-Agent: Notmuch/0.15.2+81~gd2c8818 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Mon, 30 Sep 2013 09:05:59 +0930
Message-ID: <874n932obk.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jason Wang <jasowang@redhat.com> writes:
> We used to use a percpu structure vq_index to record the cpu to queue
> mapping, this is suboptimal since it duplicates the work of XPS and
> loses all other XPS functionality such as allowing use to configure
> their own transmission steering strategy.
>
> So this patch switches to use XPS and suggest a default mapping when
> the number of cpus is equal to the number of queues. With XPS support,
> there's no need for keeping per-cpu vq_index and .ndo_select_queue(),
> so they were removed also.
>
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Michael S. Tsirkin <mst@redhat.com>
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
>  drivers/net/virtio_net.c |   55 +++++++--------------------------------------
>  1 files changed, 9 insertions(+), 46 deletions(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index defec2b..4102c1b 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -127,9 +127,6 @@ struct virtnet_info {
>  	/* Does the affinity hint is set for virtqueues? */
>  	bool affinity_hint_set;
>  
> -	/* Per-cpu variable to show the mapping from CPU to virtqueue */
> -	int __percpu *vq_index;
> -
>  	/* CPU hot plug notifier */
>  	struct notifier_block nb;
>  };
> @@ -1063,7 +1060,6 @@ static int virtnet_vlan_rx_kill_vid(struct net_device *dev,
>  static void virtnet_clean_affinity(struct virtnet_info *vi, long hcpu)
>  {
>  	int i;
> -	int cpu;
>  
>  	if (vi->affinity_hint_set) {
>  		for (i = 0; i < vi->max_queue_pairs; i++) {
> @@ -1073,20 +1069,11 @@ static void virtnet_clean_affinity(struct virtnet_info *vi, long hcpu)
>  
>  		vi->affinity_hint_set = false;
>  	}
> -
> -	i = 0;
> -	for_each_online_cpu(cpu) {
> -		if (cpu == hcpu) {
> -			*per_cpu_ptr(vi->vq_index, cpu) = -1;
> -		} else {
> -			*per_cpu_ptr(vi->vq_index, cpu) =
> -				++i % vi->curr_queue_pairs;
> -		}
> -	}
>  }
>  
>  static void virtnet_set_affinity(struct virtnet_info *vi)
>  {
> +	cpumask_var_t cpumask;
>  	int i;
>  	int cpu;
>  
> @@ -1100,15 +1087,21 @@ static void virtnet_set_affinity(struct virtnet_info *vi)
>  		return;
>  	}
>  
> +	if (!alloc_cpumask_var(&cpumask, GFP_KERNEL))
> +		return;
> +
>  	i = 0;
>  	for_each_online_cpu(cpu) {
>  		virtqueue_set_affinity(vi->rq[i].vq, cpu);
>  		virtqueue_set_affinity(vi->sq[i].vq, cpu);
> -		*per_cpu_ptr(vi->vq_index, cpu) = i;
> +		cpumask_clear(cpumask);
> +		cpumask_set_cpu(cpu, cpumask);
> +		netif_set_xps_queue(vi->dev, cpumask, i);
>  		i++;
>  	}
>  
>  	vi->affinity_hint_set = true;
> +	free_cpumask_var(cpumask);
>  }

Um, isn't this just cpumask_of(cpu)?

Cheers,
Rusty.
