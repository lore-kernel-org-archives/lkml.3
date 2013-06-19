Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934476Ab3FSJ4S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 05:56:18 -0400
Received: from mail-ea0-f169.google.com ([209.85.215.169]:36368 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933991Ab3FSJ4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 05:56:17 -0400
Message-ID: <1371635763.3252.289.camel@edumazet-glaptop>
Subject: Re: [net-next rfc 1/3] net: avoid high order memory allocation for
 queues by using flex array
From: Eric Dumazet <eric.dumazet@gmail.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>, davem@davemloft.net, edumazet@google.com,
        hkchu@google.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 19 Jun 2013 02:56:03 -0700
In-Reply-To: <20130619091132.GA2816@redhat.com>
References: <1371620452-49349-1-git-send-email-jasowang@redhat.com>
	 <1371620452-49349-2-git-send-email-jasowang@redhat.com>
	 <1371623518.3252.267.camel@edumazet-glaptop>
	 <20130619091132.GA2816@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-06-19 at 12:11 +0300, Michael S. Tsirkin wrote:

> Well KVM supports up to 160 VCPUs on x86.
> 
> Creating a queue per CPU is very reasonable, and
> assuming cache line size of 64 bytes, netdev_queue seems to be 320
> bytes, that's 320*160 = 51200. So 12.5 pages, order-4 allocation.
> I agree most people don't have such systems yet, but
> they do exist.

Even so, it will just work, like a fork() is likely to work, even if a
process needs order-1 allocation for kernel stack.

Some drivers still use order-10 allocations with kmalloc(), and nobody
complained yet.

We had complains with mlx4 driver lately only bcause kmalloc() now gives
a warning if allocations above MAX_ORDER are attempted.

Having a single pointer means that we can :

- Attempts a regular kmalloc() call, it will work most of the time.
- fallback to vmalloc() _if_ kmalloc() failed.

Frankly, if you want one tx queue per cpu, I would rather use
NETIF_F_LLTX, like some other virtual devices.

This way, you can have real per cpu memory, with proper NUMA affinity.



