Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752914Ab3KTMIz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 07:08:55 -0500
Received: from mx3-phx2.redhat.com ([209.132.183.24]:46508 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751390Ab3KTMIx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 07:08:53 -0500
Date: Wed, 20 Nov 2013 07:08:50 -0500 (EST)
From: Jason Wang <jasowang@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: rusty@rustcorp.com.au, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Dalton <mwdalton@google.com>,
        Eric Dumazet <edumazet@google.com>
Message-ID: <734327384.27426189.1384949330819.JavaMail.root@redhat.com>
In-Reply-To: <20131120103729.GG19341@redhat.com>
References: <1384938447-3775-1-git-send-email-jasowang@redhat.com> <1384938447-3775-2-git-send-email-jasowang@redhat.com> <20131120103729.GG19341@redhat.com>
Subject: Re: [PATCH net 2/3] virtio-net: fix num calculation on frag skb
 allocation failure
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [10.5.82.11]
X-Mailer: Zimbra 8.0.3_GA_5664 (ZimbraWebClient - GC31 (Win)/8.0.3_GA_5664)
Thread-Topic: virtio-net: fix num calculation on frag skb allocation failure
Thread-Index: 1o76VnPAC/IrTF8D8j9rvTk81BbpHA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



----- 原始邮件 -----
> On Wed, Nov 20, 2013 at 05:07:26PM +0800, Jason Wang wrote:
> > We need decrease the rq->num after we can get a buf through
> > virtqueue_get_buf() even if we could not allocate frag skb. Otherwise, the
> > refill routine won't be triggered under heavy memory stress since the
> > driver may
> > still think there's enough room.
> > 
> > This bug was introduced by commit 2613af0ed18a11d5c566a81f9a6510b73180660a
> > (virtio_net: migrate mergeable rx buffers to page frag allocators).
> > 
> > Cc: Rusty Russell <rusty@rustcorp.com.au>
> > Cc: Michael S. Tsirkin <mst@redhat.com>
> > Cc: Michael Dalton <mwdalton@google.com>
> > Cc: Eric Dumazet <edumazet@google.com>
> > Signed-off-by: Jason Wang <jasowang@redhat.com>
> 
> So let's wrap virtqueue_get_buf to make sure we get it right?
> 

Ok. good idea.
> > ---
> > The patch was needed for 3.12 stable.
> > ---
> >  drivers/net/virtio_net.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > index 24fd502..de1d6ca 100644
> > --- a/drivers/net/virtio_net.c
> > +++ b/drivers/net/virtio_net.c
> > @@ -333,6 +333,7 @@ static int receive_mergeable(struct receive_queue *rq,
> > struct sk_buff *head_skb)
> >  			head_skb->dev->stats.rx_length_errors++;
> >  			return -EINVAL;
> >  		}
> > +		--rq->num;
> >  		if (unlikely(len > MERGE_BUFFER_LEN)) {
> >  			pr_debug("%s: rx error: merge buffer too long\n",
> >  				 head_skb->dev->name);
> > @@ -367,7 +368,6 @@ static int receive_mergeable(struct receive_queue *rq,
> > struct sk_buff *head_skb)
> >  			skb_add_rx_frag(curr_skb, num_skb_frags, page,
> >  					offset, len, MERGE_BUFFER_LEN);
> >  		}
> > -		--rq->num;
> >  	}
> >  	return 0;
> >  }
> > --
> > 1.8.3.2
> 
