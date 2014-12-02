Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753306AbaLBJzc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 04:55:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42284 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750964AbaLBJza (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 04:55:30 -0500
Date: Tue, 2 Dec 2014 11:55:23 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jason Wang <jasowang@redhat.com>
Cc: virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net, pagupta@redhat.com
Subject: Re: [PATCH RFC v4 net-next 0/5] virtio_net: enabling tx interrupts
Message-ID: <20141202095523.GA7877@redhat.com>
References: <1417429028-11971-1-git-send-email-jasowang@redhat.com>
 <20141201104223.GB16108@redhat.com>
 <1417490120.4405.2@smtp.corp.redhat.com>
 <1417507622.12638.0@smtp.corp.redhat.com>
 <20141202094318.GB7732@redhat.com>
 <1417513908.16540.0@smtp.corp.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417513908.16540.0@smtp.corp.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 02, 2014 at 09:59:48AM +0008, Jason Wang wrote:
> 
> 
> On Tue, Dec 2, 2014 at 5:43 PM, Michael S. Tsirkin <mst@redhat.com> wrote:
> >On Tue, Dec 02, 2014 at 08:15:02AM +0008, Jason Wang wrote:
> >>     On Tue, Dec 2, 2014 at 11:15 AM, Jason Wang <jasowang@redhat.com>
> >>wrote:
> >> >
> >> >
> >> >On Mon, Dec 1, 2014 at 6:42 PM, Michael S. Tsirkin <mst@redhat.com>
> >>wrote:
> >> >>On Mon, Dec 01, 2014 at 06:17:03PM +0800, Jason Wang wrote:
> >> >>> Hello:
> >> >>>  We used to orphan packets before transmission for virtio-net. This
> >> >>>breaks
> >> >>> socket accounting and can lead serveral functions won't work, e.g:
> >> >>>  - Byte Queue Limit depends on tx completion nofication to work.
> >> >>> - Packet Generator depends on tx completion nofication for the last
> >> >>>   transmitted packet to complete.
> >> >>> - TCP Small Queue depends on proper accounting of sk_wmem_alloc to
> >> >>>work.
> >> >>>  This series tries to solve the issue by enabling tx interrupts. To
> >> >>>minize
> >> >>> the performance impacts of this, several optimizations were used:
> >> >>>  - In guest side, virtqueue_enable_cb_delayed() was used to delay
> >>the
> >> >>>tx
> >> >>>   interrupt untile 3/4 pending packets were sent.
> >> >>> - In host side, interrupt coalescing were used to reduce tx
> >> >>>interrupts.
> >> >>>  Performance test results[1] (tx-frames 16 tx-usecs 16) shows:
> >> >>>  - For guest receiving. No obvious regression on throughput were
> >> >>>   noticed. More cpu utilization were noticed in few cases.
> >> >>> - For guest transmission. Very huge improvement on througput for
> >> >>>small
> >> >>>   packet transmission were noticed. This is expected since TSQ and
> >> >>>other
> >> >>>   optimization for small packet transmission work after tx
> >>interrupt.
> >> >>>But
> >> >>>   will use more cpu for large packets.
> >> >>> - For TCP_RR, regression (10% on transaction rate and cpu
> >> >>>utilization) were
> >> >>>   found. Tx interrupt won't help but cause overhead in this case.
> >> >>>Using
> >> >>>   more aggressive coalescing parameters may help to reduce the
> >> >>>regression.
> >> >>
> >> >>OK, you do have posted coalescing patches - does it help any?
> >> >
> >> >Helps a lot.
> >> >
> >> >For RX, it saves about 5% - 10% cpu. (reduce 60%-90% tx intrs)
> >> >For small packet TX, it increases 33% - 245% throughput. (reduce about
> >>60%
> >> >inters)
> >> >For TCP_RR, it increase the 3%-10% trans.rate. (reduce 40%-80% tx
> >>intrs)
> >> >
> >> >>
> >> >>I'm not sure the regression is due to interrupts.
> >> >>It would make sense for CPU but why would it
> >> >>hurt transaction rate?
> >> >
> >> >Anyway guest need to take some cycles to handle tx interrupts.
> >> >And transaction rate does increase if we coalesces more tx interurpts.
> >> >>
> >> >>
> >> >>It's possible that we are deferring kicks too much due to BQL.
> >> >>
> >> >>As an experiment: do we get any of it back if we do
> >> >>-        if (kick || netif_xmit_stopped(txq))
> >> >>-                virtqueue_kick(sq->vq);
> >> >>+        virtqueue_kick(sq->vq);
> >> >>?
> >> >
> >> >
> >> >I will try, but during TCP_RR, at most 1 packets were pending,
> >> >I suspect if BQL can help in this case.
> >> Looks like this helps a lot in multiple sessions of TCP_RR.
> >
> >so what's faster
> >	BQL + kick each packet
> >	no BQL
> >?
> 
> Quick and manual tests (TCP_RR 64, TCP_STREAM 512) does not show obvious
> differences.
> 
> May need a complete benchmark to see.

Okay so going forward something like BQL + kick each packet
might be a good solution.
The advantage of BQL is that it works without GSO.
For example, now that we don't do UFO, you might
see significant gains with UDP.


> >
> >
> >> How about move the BQL patch out of this series?
> >> Let's first converge tx interrupt and then introduce it?
> >> (e.g with kicking after queuing X bytes?)
> >
> >Sounds good.
