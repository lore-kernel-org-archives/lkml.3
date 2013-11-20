Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753928Ab3KTN5E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 08:57:04 -0500
Received: from mx4-phx2.redhat.com ([209.132.183.25]:59130 "EHLO
	mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751971Ab3KTN5C convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 08:57:02 -0500
Date: Wed, 20 Nov 2013 08:56:54 -0500 (EST)
From: Jason Wang <jasowang@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: rusty@rustcorp.com.au, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Dalton <mwdalton@google.com>,
        Eric Dumazet <edumazet@google.com>
Message-ID: <1382353279.27479040.1384955814610.JavaMail.root@redhat.com>
In-Reply-To: <20131120133707.GA8523@redhat.com>
References: <1384938447-3775-1-git-send-email-jasowang@redhat.com> <1384938447-3775-2-git-send-email-jasowang@redhat.com> <20131120103729.GG19341@redhat.com> <734327384.27426189.1384949330819.JavaMail.root@redhat.com> <20131120133707.GA8523@redhat.com>
Subject: Re: [PATCH net 2/3] virtio-net: fix num calculation on frag skb
 allocation failure
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [10.5.82.11]
X-Mailer: Zimbra 8.0.3_GA_5664 (ZimbraWebClient - GC31 (Win)/8.0.3_GA_5664)
Thread-Topic: virtio-net: fix num calculation on frag skb allocation failure
Thread-Index: cgqlu+a4lVAdjpkRe3SLlR25rxbCuw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



----- 原始邮件 -----
> On Wed, Nov 20, 2013 at 07:08:50AM -0500, Jason Wang wrote:
> > 
> > 
> > ----- 原始邮件 -----
> > > On Wed, Nov 20, 2013 at 05:07:26PM +0800, Jason Wang wrote:
> > > > We need decrease the rq->num after we can get a buf through
> > > > virtqueue_get_buf() even if we could not allocate frag skb. Otherwise,
> > > > the
> > > > refill routine won't be triggered under heavy memory stress since the
> > > > driver may
> > > > still think there's enough room.
> > > > 
> > > > This bug was introduced by commit
> > > > 2613af0ed18a11d5c566a81f9a6510b73180660a
> > > > (virtio_net: migrate mergeable rx buffers to page frag allocators).
> > > > 
> > > > Cc: Rusty Russell <rusty@rustcorp.com.au>
> > > > Cc: Michael S. Tsirkin <mst@redhat.com>
> > > > Cc: Michael Dalton <mwdalton@google.com>
> > > > Cc: Eric Dumazet <edumazet@google.com>
> > > > Signed-off-by: Jason Wang <jasowang@redhat.com>
> > > 
> > > So let's wrap virtqueue_get_buf to make sure we get it right?
> > > 
> > 
> > Ok. good idea.
> 
> So I did this (below) but the compiler is not smart enough to
> avoid two branches on data path.
> So I'm not sure anymore: with my patch it's pretty clear how
> the code works.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> 
> but I don't think we need to apply this.
> 

True, another point is we'd better to handle both increasing and decreasing in the 
same way. We do not increase it in a helper.
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 11d9cc9..1cc2e43 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -296,6 +296,14 @@ static struct sk_buff *page_to_skb(struct receive_queue
> *rq,
>  	return skb;
>  }
>  
> +static void *rq_get_buf(struct receive_queue *rq, unsigned int *len)
> +{
> +	void *buf = virtqueue_get_buf(rq->vq, len);
> +	if (buf)
> +		rq->num--;
> +	return buf;
> +}
> +
>  static struct sk_buff *receive_mergeable(struct net_device *dev,
>  					 struct receive_queue *rq,
>  					 void *buf,
> @@ -315,7 +323,7 @@ static struct sk_buff *receive_mergeable(struct
> net_device *dev,
>  	while (--num_buf) {
>  		int num_skb_frags;
>  
> -		buf = virtqueue_get_buf(rq->vq, &len);
> +		buf = rq_get_buf(rq, &len);
>  		if (unlikely(!buf)) {
>  			pr_debug("%s: rx error: %d buffers out of %d missing\n",
>  				 dev->name, num_buf, hdr->mhdr.num_buffers);
> @@ -329,7 +337,6 @@ static struct sk_buff *receive_mergeable(struct
> net_device *dev,
>  		}
>  
>  		page = virt_to_head_page(buf);
> -		--rq->num;
>  
>  		num_skb_frags = skb_shinfo(curr_skb)->nr_frags;
>  		if (unlikely(num_skb_frags == MAX_SKB_FRAGS)) {
> @@ -370,7 +377,7 @@ err_buf:
>  	dev->stats.rx_dropped++;
>  	dev_kfree_skb(head_skb);
>  	while (--num_buf) {
> -		buf = virtqueue_get_buf(rq->vq, &len);
> +		buf = rq_get_buf(rq, &len);
>  		if (unlikely(!buf)) {
>  			pr_debug("%s: rx error: %d buffers missing\n",
>  				 dev->name, num_buf);
> @@ -379,7 +386,6 @@ err_buf:
>  		}
>  		page = virt_to_head_page(buf);
>  		put_page(page);
> -		--rq->num;
>  	}
>  	return NULL;
>  }
> @@ -675,9 +681,8 @@ static int virtnet_poll(struct napi_struct *napi, int
> budget)
>  
>  again:
>  	while (received < budget &&
> -	       (buf = virtqueue_get_buf(rq->vq, &len)) != NULL) {
> +	       (buf = rq_get_buf(rq, &len)) != NULL) {
>  		receive_buf(rq, buf, len);
> -		--rq->num;
>  		received++;
>  	}
>  
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
