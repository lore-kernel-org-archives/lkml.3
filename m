Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751859Ab3KTNYg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 08:24:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49271 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751558Ab3KTNYd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 08:24:33 -0500
Date: Wed, 20 Nov 2013 15:27:29 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jason Wang <jasowang@redhat.com>
Cc: rusty@rustcorp.com.au, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Dalton <mwdalton@google.com>,
        Eric Dumazet <edumazet@google.com>, Shirley Ma <xma@us.ibm.com>
Subject: Re: [PATCH net 1/3] virtio-net: drop the rest of buffers when we
 can't allocate skb
Message-ID: <20131120132729.GB8455@redhat.com>
References: <1384938447-3775-1-git-send-email-jasowang@redhat.com>
 <20131120103406.GF19341@redhat.com>
 <1146110853.27426099.1384949282266.JavaMail.root@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1146110853.27426099.1384949282266.JavaMail.root@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 20, 2013 at 07:08:02AM -0500, Jason Wang wrote:
> 
> 
> ----- 原始邮件 -----
> > On Wed, Nov 20, 2013 at 05:07:25PM +0800, Jason Wang wrote:
> > > When mergeable buffer were used, we only put the first page buf leave the
> > > rest
> > > of buffers in the virt queue. This will cause the driver could not get the
> > > correct head buffer any more. Fix this by dropping the rest of buffers for
> > > this
> > > packet.
> > > 
> > > The bug was introduced by commit 9ab86bbcf8be755256f0a5e994e0b38af6b4d399
> > > (virtio_net: Defer skb allocation in receive path).
> > > 
> > > Cc: Rusty Russell <rusty@rustcorp.com.au>
> > > Cc: Michael S. Tsirkin <mst@redhat.com>
> > > Cc: Michael Dalton <mwdalton@google.com>
> > > Cc: Eric Dumazet <edumazet@google.com>
> > > Cc: Shirley Ma <xma@us.ibm.com>
> > > Signed-off-by: Jason Wang <jasowang@redhat.com>
> > > ---
> > > This patch was needed for stable
> > > ---
> > >  drivers/net/virtio_net.c | 18 +++++++++++++++++-
> > >  1 file changed, 17 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > > index 7bab4de..24fd502 100644
> > > --- a/drivers/net/virtio_net.c
> > > +++ b/drivers/net/virtio_net.c
> > > @@ -222,6 +222,17 @@ static void skb_xmit_done(struct virtqueue *vq)
> > >  	netif_wake_subqueue(vi->dev, vq2txq(vq));
> > >  }
> > >  
> > > +static void drop_mergeable_buffer(struct receive_queue *rq, int num_buf)
> > > +{
> > > +	char *buf;
> > > +	int len;
> > > +
> > > +	while (--num_buf && (buf = virtqueue_get_buf(rq->vq, &len)) != NULL) {
> > > +		--rq->num;
> > > +		put_page(virt_to_head_page(buf));
> > > +	}
> > > +}
> > > +
> > 
> > This is the same code we have in receive_mergeable anyway.
> > So let's reuse that.
> > 
> > 
> 
> receive_mergeable() was called after page_to_skb() was called and 
> there's lots of conditions check there. I'm not sure how could we 
> reuse them.

I posted a patch showing how :)

> > >  /* Called from bottom half context */
> > >  static struct sk_buff *page_to_skb(struct receive_queue *rq,
> > >  				   struct page *page, unsigned int offset,
> > > @@ -237,8 +248,13 @@ static struct sk_buff *page_to_skb(struct
> > > receive_queue *rq,
> > >  
> > >  	/* copy small packet so we can reuse these pages for small data */
> > >  	skb = netdev_alloc_skb_ip_align(vi->dev, GOOD_COPY_LEN);
> > > -	if (unlikely(!skb))
> > > +	if (unlikely(!skb)) {
> > > +		if (vi->mergeable_rx_bufs) {
> > > +			hdr = (struct skb_vnet_hdr *)p;
> > > +			drop_mergeable_buffer(rq, hdr->mhdr.num_buffers);
> > > +		}
> > >  		return NULL;
> > > +	}
> > >  
> > >  	hdr = skb_vnet_hdr(skb);
> > >  
> > > --
> > > 1.8.3.2
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> > 
