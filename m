Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756588Ab3FSMVi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 08:21:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37685 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754131Ab3FSMVg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 08:21:36 -0400
Date: Wed, 19 Jun 2013 15:22:18 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Jason Wang <jasowang@redhat.com>, davem@davemloft.net, edumazet@google.com,
        hkchu@google.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [net-next rfc 1/3] net: avoid high order memory allocation for
 queues by using flex array
Message-ID: <20130619122218.GA4990@redhat.com>
References: <1371620452-49349-1-git-send-email-jasowang@redhat.com>
 <1371620452-49349-2-git-send-email-jasowang@redhat.com>
 <1371623518.3252.267.camel@edumazet-glaptop>
 <20130619091132.GA2816@redhat.com>
 <1371635763.3252.289.camel@edumazet-glaptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371635763.3252.289.camel@edumazet-glaptop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 19, 2013 at 02:56:03AM -0700, Eric Dumazet wrote:
> On Wed, 2013-06-19 at 12:11 +0300, Michael S. Tsirkin wrote:
> 
> > Well KVM supports up to 160 VCPUs on x86.
> > 
> > Creating a queue per CPU is very reasonable, and
> > assuming cache line size of 64 bytes, netdev_queue seems to be 320
> > bytes, that's 320*160 = 51200. So 12.5 pages, order-4 allocation.
> > I agree most people don't have such systems yet, but
> > they do exist.
> 
> Even so, it will just work, like a fork() is likely to work, even if a
> process needs order-1 allocation for kernel stack.
> Some drivers still use order-10 allocations with kmalloc(), and nobody
> complained yet.
> 
> We had complains with mlx4 driver lately only bcause kmalloc() now gives
> a warning if allocations above MAX_ORDER are attempted.
> 
> Having a single pointer means that we can :
> 
> - Attempts a regular kmalloc() call, it will work most of the time.
> - fallback to vmalloc() _if_ kmalloc() failed.

Most drivers create devices at boot time, when this is more likely to work.
What makes tun (and macvlan) a bit special is that the device is created
from userspace.  Virt setups create/destroy them all the
time.

> 
> Frankly, if you want one tx queue per cpu, I would rather use
> NETIF_F_LLTX, like some other virtual devices.
> 
> This way, you can have real per cpu memory, with proper NUMA affinity.
> 

Hmm good point, worth looking at.

Thanks,
-- 
MST
