Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755680AbaCSGls (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 02:41:48 -0400
Received: from ozlabs.org ([203.10.76.45]:44612 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752415AbaCSGlq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 02:41:46 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: tytso@mit.edu
Cc: Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        Venkatesh Srinivas <venkateshs@google.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, virtio-dev@lists.oasis-open.org,
        virtualization@lists.linux-foundation.org,
        Frank Swiderski <fes@google.com>
Subject: Re: [PATCH] virtio-blk: make the queue depth the max supportable by the hypervisor
In-Reply-To: <20140317054053.GF14162@thunk.org>
References: <1394841445-16142-1-git-send-email-venkateshs@google.com> <1394854471-25700-1-git-send-email-tytso@mit.edu> <87siqhu048.fsf@rustcorp.com.au> <20140317054053.GF14162@thunk.org>
User-Agent: Notmuch/0.15.2 (http://notmuchmail.org) Emacs/23.4.1 (x86_64-pc-linux-gnu)
Date: Wed, 19 Mar 2014 16:58:29 +1030
Message-ID: <871txysnw2.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tytso@mit.edu writes:
> On Mon, Mar 17, 2014 at 11:12:15AM +1030, Rusty Russell wrote:
>> 
>> Note that with indirect descriptors (which is supported by Almost
>> Everyone), we can actually use the full index, so this value is a bit
>> pessimistic.  But it's OK as a starting point.
>
> So is this something that can go upstream with perhaps a slight
> adjustment in the commit description?

Well, I rewrote it again, see below.

> Do you think we need to be able
> to dynamically adjust the queue depth after the module has been loaded
> or the kernel has been booted?

That would be nice, sure, but...

> If so, anyone a hint about the best
> way to do that would be much appreciated.

... I share your wonder and mystery at the ways of the block layer.

Subject: virtio-blk: base queue-depth on virtqueue ringsize or module param

Venkatash spake thus:

  virtio-blk set the default queue depth to 64 requests, which was
  insufficient for high-IOPS devices. Instead set the blk-queue depth to
  the device's virtqueue depth divided by two (each I/O requires at least
  two VQ entries).

But behold, Ted added a module parameter:

  Also allow the queue depth to be something which can be set at module
  load time or via a kernel boot-time parameter, for
  testing/benchmarking purposes.

And I rewrote it substantially, mainly to take
VIRTIO_RING_F_INDIRECT_DESC into account.

As QEMU sets the vq size for PCI to 128, Venkatash's patch wouldn't
have made a change.  This version does (since QEMU also offers
VIRTIO_RING_F_INDIRECT_DESC.

Inspired-by: "Theodore Ts'o" <tytso@mit.edu>
Based-on-the-true-story-of: Venkatesh Srinivas <venkateshs@google.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: virtio-dev@lists.oasis-open.org
Cc: virtualization@lists.linux-foundation.org
Cc: Frank Swiderski <fes@google.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index a2db9ed288f2..c101bbc72095 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -491,10 +491,11 @@ static struct blk_mq_ops virtio_mq_ops = {
 static struct blk_mq_reg virtio_mq_reg = {
 	.ops		= &virtio_mq_ops,
 	.nr_hw_queues	= 1,
-	.queue_depth	= 64,
+	.queue_depth	= 0, /* Set in virtblk_probe */
 	.numa_node	= NUMA_NO_NODE,
 	.flags		= BLK_MQ_F_SHOULD_MERGE,
 };
+module_param_named(queue_depth, virtio_mq_reg.queue_depth, uint, 0444);
 
 static void virtblk_init_vbr(void *data, struct blk_mq_hw_ctx *hctx,
 			     struct request *rq, unsigned int nr)
@@ -558,6 +559,13 @@ static int virtblk_probe(struct virtio_device *vdev)
 		goto out_free_vq;
 	}
 
+	/* Default queue sizing is to fill the ring. */
+	if (!virtio_mq_reg.queue_depth) {
+		virtio_mq_reg.queue_depth = vblk->vq->num_free;
+		/* ... but without indirect descs, we use 2 descs per req */
+		if (!virtio_has_feature(vdev, VIRTIO_RING_F_INDIRECT_DESC))
+			virtio_mq_reg.queue_depth /= 2;
+	}
 	virtio_mq_reg.cmd_size =
 		sizeof(struct virtblk_req) +
 		sizeof(struct scatterlist) * sg_elems;
