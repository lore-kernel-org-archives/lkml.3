Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752500AbaKZNMR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 08:12:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58751 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750828AbaKZNMO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 08:12:14 -0500
Date: Wed, 26 Nov 2014 15:11:56 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
        rusty@au1.ibm.com, nab@linux-iscsi.org, pbonzini@redhat.com,
        Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: Re: [PATCH v4 21/42] virtio_net: get rid of
 virtio_net_hdr/skb_vnet_hdr
Message-ID: <20141126131156.GA5127@redhat.com>
References: <1416933600-21398-1-git-send-email-mst@redhat.com>
 <1416933600-21398-22-git-send-email-mst@redhat.com>
 <20141126135053.1bf4f97c.cornelia.huck@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141126135053.1bf4f97c.cornelia.huck@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2014 at 01:50:53PM +0100, Cornelia Huck wrote:
> On Tue, 25 Nov 2014 18:42:53 +0200
> "Michael S. Tsirkin" <mst@redhat.com> wrote:
> 
> > virtio 1.0 doesn't use virtio_net_hdr anymore, and in fact, it's not
> > really useful since virtio_net_hdr_mrg_rxbuf includes that as the first
> > field anyway.
> > 
> > Let's drop it, precalculate header len and store within vi instead.
> > 
> > This way we can also remove struct skb_vnet_hdr.
> > 
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > ---
> >  drivers/net/virtio_net.c | 90 ++++++++++++++++++++++--------------------------
> >  1 file changed, 41 insertions(+), 49 deletions(-)
> > 
> 
> > @@ -260,13 +256,11 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
> > 
> >  	hdr = skb_vnet_hdr(skb);
> > 
> > -	if (vi->mergeable_rx_bufs) {
> > -		hdr_len = sizeof hdr->mhdr;
> > -		hdr_padded_len = sizeof hdr->mhdr;
> > -	} else {
> > -		hdr_len = sizeof hdr->hdr;
> > +	hdr_len = vi->hdr_len;
> > +	if (vi->mergeable_rx_bufs)
> > +		hdr_padded_len = sizeof *hdr;
> 
> sizeof without () looks weird to me.

It's how it was originally, so I think I'd rather keep it.
I kind of like it too: it stresses the fact that sizeof is not a function
and so does not actually dereference the pointer
even though it looks like it does.

We can change it with a patch on top, but should then be changed
everywhere in this file.

> > +	else
> >  		hdr_padded_len = sizeof(struct padded_vnet_hdr);
> > -	}
> > 
> >  	memcpy(hdr, p, hdr_len);
> > 
> 
> Otherwise:
> 
> Reviewed-by: Cornelia Huck <cornelia.huck@de.ibm.com>
