Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934179Ab3BTKLA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 05:11:00 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:29627 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S933782Ab3BTKKz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 05:10:55 -0500
X-IronPort-AV: E=Sophos;i="4.84,700,1355068800"; 
   d="scan'208";a="6735914"
Message-ID: <5124A0F2.2030806@cn.fujitsu.com>
Date: Wed, 20 Feb 2013 18:09:54 +0800
From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Reply-To: gaowanlong@cn.fujitsu.com
Organization: Fujitsu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Paolo Bonzini <pbonzini@redhat.com>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH 09/16] virtio_net: use simplified virtqueue accessors.
References: <1361260594-601-1-git-send-email-rusty@rustcorp.com.au> <1361260594-601-10-git-send-email-rusty@rustcorp.com.au>
In-Reply-To: <1361260594-601-10-git-send-email-rusty@rustcorp.com.au>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/20 18:10:14,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/20 18:10:14,
	Serialize complete at 2013/02/20 18:10:14
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/19/2013 03:56 PM, Rusty Russell wrote:
> We never add buffers with input and output parts, so use the new accessors.
> 
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

Reviewed-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>

> ---
>  drivers/net/virtio_net.c |   11 +++++------
>  1 file changed, 5 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index dbd5cd1..8ca69c0 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -443,7 +443,7 @@ static int add_recvbuf_small(struct receive_queue *rq, gfp_t gfp)
>  
>  	skb_to_sgvec(skb, rq->sg + 1, 0, skb->len);
>  
> -	err = virtqueue_add_buf(rq->vq, rq->sg, 0, 2, skb, gfp);
> +	err = virtqueue_add_inbuf(rq->vq, rq->sg, 2, skb, gfp);
>  	if (err < 0)
>  		dev_kfree_skb(skb);
>  
> @@ -488,8 +488,8 @@ static int add_recvbuf_big(struct receive_queue *rq, gfp_t gfp)
>  
>  	/* chain first in list head */
>  	first->private = (unsigned long)list;
> -	err = virtqueue_add_buf(rq->vq, rq->sg, 0, MAX_SKB_FRAGS + 2,
> -				first, gfp);
> +	err = virtqueue_add_inbuf(rq->vq, rq->sg, MAX_SKB_FRAGS + 2,
> +				  first, gfp);
>  	if (err < 0)
>  		give_pages(rq, first);
>  
> @@ -507,7 +507,7 @@ static int add_recvbuf_mergeable(struct receive_queue *rq, gfp_t gfp)
>  
>  	sg_init_one(rq->sg, page_address(page), PAGE_SIZE);
>  
> -	err = virtqueue_add_buf(rq->vq, rq->sg, 0, 1, page, gfp);
> +	err = virtqueue_add_inbuf(rq->vq, rq->sg, 1, page, gfp);
>  	if (err < 0)
>  		give_pages(rq, page);
>  
> @@ -710,8 +710,7 @@ static int xmit_skb(struct send_queue *sq, struct sk_buff *skb)
>  		sg_set_buf(sq->sg, &hdr->hdr, sizeof hdr->hdr);
>  
>  	num_sg = skb_to_sgvec(skb, sq->sg + 1, 0, skb->len) + 1;
> -	return virtqueue_add_buf(sq->vq, sq->sg, num_sg,
> -				 0, skb, GFP_ATOMIC);
> +	return virtqueue_add_outbuf(sq->vq, sq->sg, num_sg, skb, GFP_ATOMIC);
>  }
>  
>  static netdev_tx_t start_xmit(struct sk_buff *skb, struct net_device *dev)
> 

