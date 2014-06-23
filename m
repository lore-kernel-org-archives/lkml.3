Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751398AbaFWDm5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 23:42:57 -0400
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:39952 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750936AbaFWDmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 23:42:55 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AudFAFuhp1N5LC2vPGdsb2JhbABZgw2DSIUIow8BAQEBAQEGmTUBgQUXBAEBAQE4NYQDAQEFOhwjEAgDGAklDwUlAwcaE4hBxgUXFoVNiRkHhEMEmkuVZIFUKw
Date: Mon, 23 Jun 2014 13:42:51 +1000
From: Dave Chinner <david@fromorbit.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Ming Lei <ming.lei@canonical.com>, Jens Axboe <axboe@kernel.dk>,
        linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        linux-api@vger.kernel.org, virtualization@lists.linux-foundation.org,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v1 2/2] block: virtio-blk: support multi virt queues per
 virtio-blk device
Message-ID: <20140623034251.GR4453@dastard>
References: <1403278181-28455-1-git-send-email-ming.lei@canonical.com>
 <1403278181-28455-3-git-send-email-ming.lei@canonical.com>
 <20140622102448.GB17067@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140622102448.GB17067@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 22, 2014 at 01:24:48PM +0300, Michael S. Tsirkin wrote:
> On Fri, Jun 20, 2014 at 11:29:40PM +0800, Ming Lei wrote:
> > @@ -24,8 +26,8 @@ static struct workqueue_struct *virtblk_wq;
> >  struct virtio_blk
> >  {
> >  	struct virtio_device *vdev;
> > -	struct virtqueue *vq;
> > -	spinlock_t vq_lock;
> > +	struct virtqueue *vq[MAX_NUM_VQ];
> > +	spinlock_t vq_lock[MAX_NUM_VQ];
> 
> array of struct {
>     *vq;
>     spinlock_t lock;
> }
> would use more memory but would get us better locality.
> It might even make sense to add padding to avoid
> cacheline sharing between two unrelated VQs.
> Want to try?

It's still false sharing because the queue objects share cachelines.
To operate without contention they have to be physically separated
from each other like so:

struct vq {
	struct virtqueue	*q;
	spinlock_t		lock;
} ____cacheline_aligned_in_smp;

struct some_other_struct {
	....
	struct vq	vq[MAX_NUM_VQ];
	....
};

This keeps locality to objects within a queue, but separates each
queue onto it's own cacheline....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
