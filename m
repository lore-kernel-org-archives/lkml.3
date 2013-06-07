Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752807Ab3FGDDH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 23:03:07 -0400
Received: from ozlabs.org ([203.10.76.45]:56312 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751264Ab3FGDDF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 23:03:05 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jason Wang <jasowang@redhat.com>, Cong Wang <amwang@redhat.com>,
        Amos Kong <akong@redhat.com>, Dave Jones <davej@redhat.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: qemu-devel@nongnu.org
Subject: Re: [PATCH] virtio-net: put virtio net header inline with data
In-Reply-To: <20130606095456.GA7865@redhat.com>
References: <20130606095456.GA7865@redhat.com>
User-Agent: Notmuch/0.15.2+81~gd2c8818 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Fri, 07 Jun 2013 11:42:43 +0930
Message-ID: <87hahar7ms.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Michael S. Tsirkin" <mst@redhat.com> writes:
> For small packets we can simplify xmit processing by linearizing buffers
> with the header: most packets seem to have enough head room we can use
> for this purpose.
>
> Since some older hypervisors (e.g. qemu before version 1.5)
> required that header is the first s/g element,
> we need a feature bit for this.

OK, we know this is horrible.  But I will sleep better knowing that we
this feature need never make it into a final 1.0 spec, since it can be
assumed at that point...

>  	pr_debug("%s: xmit %p %pM\n", vi->dev->name, skb, dest);
> +	if (vi->mergeable_rx_bufs)
> +		hdr_len = sizeof hdr->mhdr;
> +	else
> +		hdr_len = sizeof hdr->hdr;
> +
> +	can_push = vi->any_header_sg &&
> +		!((unsigned long)skb->data & (__alignof__(*hdr) - 1)) &&
> +		!skb_header_cloned(skb) && skb_headroom(skb) >= hdr_len;

Idle thought: how often does this fail?  Would it suck if we copied
headers which didn't let us prepend data?  Or could we bump
dev->hard_header_len appropriately?

Thanks,
Rusty.
