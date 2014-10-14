Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932627AbaJNVsJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 17:48:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5492 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755505AbaJNVsH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 17:48:07 -0400
Date: Wed, 15 Oct 2014 00:51:33 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: David Miller <davem@davemloft.net>
Cc: jasowang@redhat.com, rusty@rustcorp.com.au,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH net-next RFC 0/3] virtio-net: Conditionally enable tx
 interrupt
Message-ID: <20141014215133.GA23344@redhat.com>
References: <1413011806-3813-1-git-send-email-jasowang@redhat.com>
 <20141014.145327.365091739350390288.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141014.145327.365091739350390288.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 14, 2014 at 02:53:27PM -0400, David Miller wrote:
> From: Jason Wang <jasowang@redhat.com>
> Date: Sat, 11 Oct 2014 15:16:43 +0800
> 
> > We free old transmitted packets in ndo_start_xmit() currently, so any
> > packet must be orphaned also there. This was used to reduce the overhead of
> > tx interrupt to achieve better performance. But this may not work for some
> > protocols such as TCP stream. TCP depends on the value of sk_wmem_alloc to
> > implement various optimization for small packets stream such as TCP small
> > queue and auto corking. But orphaning packets early in ndo_start_xmit()
> > disable such things more or less since sk_wmem_alloc was not accurate. This
> > lead extra low throughput for TCP stream of small writes.
> > 
> > This series tries to solve this issue by enable tx interrupts for all TCP
> > packets other than the ones with push bit or pure ACK. This is done through
> > the support of urgent descriptor which can force an interrupt for a
> > specified packet. If tx interrupt was enabled for a packet, there's no need
> > to orphan it in ndo_start_xmit(), we can free it tx napi which is scheduled
> > by tx interrupt. Then sk_wmem_alloc was more accurate than before and TCP
> > can batch more for small write. More larger skb was produced by TCP in this
> > case to improve both throughput and cpu utilization.
> > 
> > Test shows great improvements on small write tcp streams. For most of the
> > other cases, the throughput and cpu utilization are the same in the
> > past. Only few cases, more cpu utilization was noticed which needs more
> > investigation.
> > 
> > Review and comments are welcomed.
> 
> I think proper accounting and queueing (at all levels, not just TCP
> sockets) is more important than trying to skim a bunch of cycles by
> avoiding TX interrupts.
> 
> Having an event to free the SKB is absolutely essential for the stack
> to operate correctly.
> 
> And with virtio-net you don't even have the excuse of "the HW
> unfortunately doesn't have an appropriate TX event."
> 
> So please don't play games, and instead use TX interrupts all the
> time.  You can mitigate them in various ways, but don't turn them on
> selectively based upon traffic type, that's terrible.

This got me thinking: how about using virtqueue_enable_cb_delayed
for this mitigation?

It's pretty easy to implement - I'll send a proof of concept patch
separately.

