Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753729AbaBMKkY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 05:40:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15985 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751744AbaBMKkW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 05:40:22 -0500
Message-ID: <52FC97AB.7040901@redhat.com>
Date: Thu, 13 Feb 2014 18:00:11 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org,
        David Miller <davem@davemloft.net>
CC: Qin Chuanyu <qinchuanyu@huawei.com>, kvm@vger.kernel.org,
        virtio-dev@lists.oasis-open.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: Re: [PATCH net v2] vhost: fix ref cnt checking deadlock
References: <1392284448-1977-1-git-send-email-mst@redhat.com>
In-Reply-To: <1392284448-1977-1-git-send-email-mst@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/13/2014 05:42 PM, Michael S. Tsirkin wrote:
> vhost checked the counter within the refcnt before decrementing.  It
> really wanted to know that it is the one that has the last reference, as
> a way to batch freeing resources a bit more efficiently.
>
> Note: we only let refcount go to 0 on device release.
>
> This works well but we now access the ref counter twice so there's a
> race: all users might see a high count and decide to defer freeing
> resources.
> In the end no one initiates freeing resources until the last reference
> is gone (which is on VM shotdown so might happen after a looooong time).
>
> Let's do what we probably should have done straight away:
> switch from kref to plain atomic, documenting the
> semantics, return the refcount value atomically after decrement,
> then use that to avoid the deadlock.
>
> Reported-by: Qin Chuanyu <qinchuanyu@huawei.com>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>
> This patch is needed for 3.14 and -stable.
>
>  drivers/vhost/net.c | 41 ++++++++++++++++++++---------------------
>  1 file changed, 20 insertions(+), 21 deletions(-)
>
> diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
> index 831eb4f..b12176f 100644
> --- a/drivers/vhost/net.c
> +++ b/drivers/vhost/net.c
> @@ -70,7 +70,12 @@ enum {
>  };
>  
>  struct vhost_net_ubuf_ref {
> -	struct kref kref;
> +	/* refcount follows semantics similar to kref:
> +	 *  0: object is released
> +	 *  1: no outstanding ubufs
> +	 * >1: outstanding ubufs
> +	 */
> +	atomic_t refcount;
>  	wait_queue_head_t wait;
>  	struct vhost_virtqueue *vq;
>  };
> @@ -116,14 +121,6 @@ static void vhost_net_enable_zcopy(int vq)
>  	vhost_net_zcopy_mask |= 0x1 << vq;
>  }
>  
> -static void vhost_net_zerocopy_done_signal(struct kref *kref)
> -{
> -	struct vhost_net_ubuf_ref *ubufs;
> -
> -	ubufs = container_of(kref, struct vhost_net_ubuf_ref, kref);
> -	wake_up(&ubufs->wait);
> -}
> -
>  static struct vhost_net_ubuf_ref *
>  vhost_net_ubuf_alloc(struct vhost_virtqueue *vq, bool zcopy)
>  {
> @@ -134,21 +131,24 @@ vhost_net_ubuf_alloc(struct vhost_virtqueue *vq, bool zcopy)
>  	ubufs = kmalloc(sizeof(*ubufs), GFP_KERNEL);
>  	if (!ubufs)
>  		return ERR_PTR(-ENOMEM);
> -	kref_init(&ubufs->kref);
> +	atomic_set(&ubufs->refcount, 1);
>  	init_waitqueue_head(&ubufs->wait);
>  	ubufs->vq = vq;
>  	return ubufs;
>  }
>  
> -static void vhost_net_ubuf_put(struct vhost_net_ubuf_ref *ubufs)
> +static int vhost_net_ubuf_put(struct vhost_net_ubuf_ref *ubufs)
>  {
> -	kref_put(&ubufs->kref, vhost_net_zerocopy_done_signal);
> +	int r = atomic_sub_return(1, &ubufs->refcount);
> +	if (unlikely(!r))
> +		wake_up(&ubufs->wait);
> +	return r;
>  }
>  
>  static void vhost_net_ubuf_put_and_wait(struct vhost_net_ubuf_ref *ubufs)
>  {
> -	kref_put(&ubufs->kref, vhost_net_zerocopy_done_signal);
> -	wait_event(ubufs->wait, !atomic_read(&ubufs->kref.refcount));
> +	vhost_net_ubuf_put(ubufs);
> +	wait_event(ubufs->wait, !atomic_read(&ubufs->refcount));
>  }
>  
>  static void vhost_net_ubuf_put_wait_and_free(struct vhost_net_ubuf_ref *ubufs)
> @@ -306,22 +306,21 @@ static void vhost_zerocopy_callback(struct ubuf_info *ubuf, bool success)
>  {
>  	struct vhost_net_ubuf_ref *ubufs = ubuf->ctx;
>  	struct vhost_virtqueue *vq = ubufs->vq;
> -	int cnt = atomic_read(&ubufs->kref.refcount);
> +	int cnt;
>  
>  	/* set len to mark this desc buffers done DMA */
>  	vq->heads[ubuf->desc].len = success ?
>  		VHOST_DMA_DONE_LEN : VHOST_DMA_FAILED_LEN;
> -	vhost_net_ubuf_put(ubufs);
> +	cnt = vhost_net_ubuf_put(ubufs);
>  
>  	/*
>  	 * Trigger polling thread if guest stopped submitting new buffers:
> -	 * in this case, the refcount after decrement will eventually reach 1
> -	 * so here it is 2.
> +	 * in this case, the refcount after decrement will eventually reach 1.
>  	 * We also trigger polling periodically after each 16 packets
>  	 * (the value 16 here is more or less arbitrary, it's tuned to trigger
>  	 * less than 10% of times).
>  	 */
> -	if (cnt <= 2 || !(cnt % 16))
> +	if (cnt <= 1 || !(cnt % 16))
>  		vhost_poll_queue(&vq->poll);
>  }
>  
> @@ -420,7 +419,7 @@ static void handle_tx(struct vhost_net *net)
>  			msg.msg_control = ubuf;
>  			msg.msg_controllen = sizeof(ubuf);
>  			ubufs = nvq->ubufs;
> -			kref_get(&ubufs->kref);
> +			atomic_inc(&ubufs->refcount);
>  			nvq->upend_idx = (nvq->upend_idx + 1) % UIO_MAXIOV;
>  		} else {
>  			msg.msg_control = NULL;
> @@ -785,7 +784,7 @@ static void vhost_net_flush(struct vhost_net *n)
>  		vhost_net_ubuf_put_and_wait(n->vqs[VHOST_NET_VQ_TX].ubufs);
>  		mutex_lock(&n->vqs[VHOST_NET_VQ_TX].vq.mutex);
>  		n->tx_flush = false;
> -		kref_init(&n->vqs[VHOST_NET_VQ_TX].ubufs->kref);
> +		atomic_set(&n->vqs[VHOST_NET_VQ_TX].ubufs->refcount, 1);
>  		mutex_unlock(&n->vqs[VHOST_NET_VQ_TX].vq.mutex);
>  	}
>  }

Acked-by: Jason Wang <jasowang@redhat.com>
