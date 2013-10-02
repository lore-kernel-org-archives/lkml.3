Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753279Ab3JBGNa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 02:13:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62465 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753069Ab3JBGN2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 02:13:28 -0400
Date: Wed, 2 Oct 2013 09:15:45 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: David Miller <davem@davemloft.net>
Cc: jasowang@redhat.com, rusty@rustcorp.com.au,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [net-next PATCH V2] virtio-net: switch to use XPS to choose txq
Message-ID: <20131002061545.GA6880@redhat.com>
References: <1380526637-35524-1-git-send-email-jasowang@redhat.com>
 <20130930.221040.543720988967287293.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130930.221040.543720988967287293.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 30, 2013 at 10:10:40PM -0700, David Miller wrote:
> From: Jason Wang <jasowang@redhat.com>
> Date: Mon, 30 Sep 2013 15:37:17 +0800
> 
> > We used to use a percpu structure vq_index to record the cpu to queue
> > mapping, this is suboptimal since it duplicates the work of XPS and
> > loses all other XPS functionality such as allowing use to configure
> > their own transmission steering strategy.
> > 
> > So this patch switches to use XPS and suggest a default mapping when
> > the number of cpus is equal to the number of queues. With XPS support,
> > there's no need for keeping per-cpu vq_index and .ndo_select_queue(),
> > so they were removed also.
> > 
> > Cc: Rusty Russell <rusty@rustcorp.com.au>
> > Cc: Michael S. Tsirkin <mst@redhat.com>
> > Signed-off-by: Jason Wang <jasowang@redhat.com>
> > ---
> > Changes from V1:
> > - use cpumask_of() instead of allocate dynamically
> 
> This generates build warnings:
> 
> drivers/net/virtio_net.c: In function ‘virtnet_set_affinity’:
> drivers/net/virtio_net.c:1093:3: warning: passing argument 2 of ‘netif_set_xps_queue’ discards ‘const’ qualifier from pointer target type [enabled by default]
> In file included from drivers/net/virtio_net.c:20:0:
> include/linux/netdevice.h:2275:5: note: expected ‘struct cpumask *’ but argument is of type ‘const struct cpumask *’

Looks like we just need to tweak the signature there to const struct
cpumask *: it's never changed.

I just sent a patch
	[PATCH] netif_set_xps_queue: make cpu mask const
that does exactly that.

-- 
MST
