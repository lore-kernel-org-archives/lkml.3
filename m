Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752068Ab3FIHLA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jun 2013 03:11:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45438 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751457Ab3FIHK7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jun 2013 03:10:59 -0400
Date: Sun, 9 Jun 2013 10:11:27 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: "David S. Miller" <davem@davemloft.net>, Jason Wang <jasowang@redhat.com>,
        Cong Wang <amwang@redhat.com>, Amos Kong <akong@redhat.com>,
        Dave Jones <davej@redhat.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, qemu-devel@nongnu.org
Subject: Re: [PATCH] virtio-net: put virtio net header inline with data
Message-ID: <20130609071127.GC13082@redhat.com>
References: <20130606095456.GA7865@redhat.com>
 <87hahar7ms.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87hahar7ms.fsf@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 07, 2013 at 11:42:43AM +0930, Rusty Russell wrote:
> "Michael S. Tsirkin" <mst@redhat.com> writes:
> > For small packets we can simplify xmit processing by linearizing buffers
> > with the header: most packets seem to have enough head room we can use
> > for this purpose.
> >
> > Since some older hypervisors (e.g. qemu before version 1.5)
> > required that header is the first s/g element,
> > we need a feature bit for this.
> 
> OK, we know this is horrible.  But I will sleep better knowing that we
> this feature need never make it into a final 1.0 spec, since it can be
> assumed at that point...

Nod. Though if we want to require this for all devices,
virtio-blk scsi command passthrough will need to change -
I sent a spec patch a while ago
	virtio-spec: add field for scsi command size
any comments on it?

> >  	pr_debug("%s: xmit %p %pM\n", vi->dev->name, skb, dest);
> > +	if (vi->mergeable_rx_bufs)
> > +		hdr_len = sizeof hdr->mhdr;
> > +	else
> > +		hdr_len = sizeof hdr->hdr;
> > +
> > +	can_push = vi->any_header_sg &&
> > +		!((unsigned long)skb->data & (__alignof__(*hdr) - 1)) &&
> > +		!skb_header_cloned(skb) && skb_headroom(skb) >= hdr_len;
> 
> Idle thought: how often does this fail?

I think it's mostly doesn't fail in my testing.

It's probably a good idea to add a counter here, then
if it starts triggering we can optimize.

I think things like skb_header_cloned depend on guest config
really, e.g. tcpdump running on the interface in guest can cause this.

>  Would it suck if we copied
> headers which didn't let us prepend data?

I think it will - copies are generally best avoided,
and header is easily 1K of data.

>  Or could we bump
> dev->hard_header_len appropriately?

Needs some thought, though from experience it's a pain.


> Thanks,
> Rusty.
