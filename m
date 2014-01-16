Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751512AbaAPHm0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 02:42:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6445 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750910AbaAPHmW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 02:42:22 -0500
Date: Thu, 16 Jan 2014 09:42:09 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jason Wang <jasowang@redhat.com>
Cc: davem@davemloft.net, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH net-next] virtio-net: drop rq->max and rq->num
Message-ID: <20140116074209.GB20993@redhat.com>
References: <1389854724-48411-1-git-send-email-jasowang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389854724-48411-1-git-send-email-jasowang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 16, 2014 at 02:45:24PM +0800, Jason Wang wrote:
> It looks like there's no need for those two fields:
> 
> - Unless there's a failure for the first refill try, rq->max should be always
>   equal to the vring size.
> - rq->num is only used to determine the condition that we need to do the refill,
>   we could check vq->num_free instead.
> - rq->num was required to be increased or decreased explicitly after each
>   get/put which results a bad API.
> 
> So this patch removes them both to make the code simpler.
> 
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Michael S. Tsirkin <mst@redhat.com>
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> Acked-by: Rusty Russell <rusty@rustcorp.com.au>


Acked-by: Michael S. Tsirkin <mst@redhat.com>

> ---
>  drivers/net/virtio_net.c |   16 +++-------------
>  1 files changed, 3 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 7b17240..9bd70aa 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -72,9 +72,6 @@ struct receive_queue {
>  
>  	struct napi_struct napi;
>  
> -	/* Number of input buffers, and max we've ever had. */
> -	unsigned int num, max;
> -
>  	/* Chain pages by the private ptr. */
>  	struct page *pages;
>  
> @@ -360,7 +357,6 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
>  		}
>  
>  		page = virt_to_head_page(buf);
> -		--rq->num;
>  
>  		num_skb_frags = skb_shinfo(curr_skb)->nr_frags;
>  		if (unlikely(num_skb_frags == MAX_SKB_FRAGS)) {
> @@ -406,7 +402,6 @@ err_skb:
>  		}
>  		page = virt_to_head_page(buf);
>  		put_page(page);
> -		--rq->num;
>  	}
>  err_buf:
>  	dev->stats.rx_dropped++;
> @@ -628,10 +623,7 @@ static bool try_fill_recv(struct receive_queue *rq, gfp_t gfp)
>  		oom = err == -ENOMEM;
>  		if (err)
>  			break;
> -		++rq->num;
>  	} while (rq->vq->num_free);
> -	if (unlikely(rq->num > rq->max))
> -		rq->max = rq->num;
>  	if (unlikely(!virtqueue_kick(rq->vq)))
>  		return false;
>  	return !oom;
> @@ -699,11 +691,10 @@ again:
>  	while (received < budget &&
>  	       (buf = virtqueue_get_buf(rq->vq, &len)) != NULL) {
>  		receive_buf(rq, buf, len);
> -		--rq->num;
>  		received++;
>  	}
>  
> -	if (rq->num < rq->max / 2) {
> +	if (rq->vq->num_free > virtqueue_get_vring_size(rq->vq) / 2) {
>  		if (!try_fill_recv(rq, GFP_ATOMIC))
>  			schedule_delayed_work(&vi->refill, 0);
>  	}
> @@ -1398,9 +1389,7 @@ static void free_unused_bufs(struct virtnet_info *vi)
>  				give_pages(&vi->rq[i], buf);
>  			else
>  				dev_kfree_skb(buf);
> -			--vi->rq[i].num;
>  		}
> -		BUG_ON(vi->rq[i].num != 0);
>  	}
>  }
>  
> @@ -1671,7 +1660,8 @@ static int virtnet_probe(struct virtio_device *vdev)
>  		try_fill_recv(&vi->rq[i], GFP_KERNEL);
>  
>  		/* If we didn't even get one input buffer, we're useless. */
> -		if (vi->rq[i].num == 0) {
> +		if (vi->rq[i].vq->num_free ==
> +		    virtqueue_get_vring_size(vi->rq[i].vq)) {
>  			free_unused_bufs(vi);
>  			err = -ENOMEM;
>  			goto free_recv_bufs;
> -- 
> 1.7.1
