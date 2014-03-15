Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755962AbaCOLLw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2014 07:11:52 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:39539 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752483AbaCOLLu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2014 07:11:50 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <1394854471-25700-1-git-send-email-tytso@mit.edu>
References: <1394841445-16142-1-git-send-email-venkateshs@google.com> <1394854471-25700-1-git-send-email-tytso@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8BIT
Subject: Re: [PATCH] virtio-blk: make the queue depth the max supportable by the hypervisor
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date: Sat, 15 Mar 2014 06:57:01 -0400
To: "Theodore Ts'o" <tytso@mit.edu>,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>
CC: Venkatesh Srinivas <venkateshs@google.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>, virtio-dev@lists.oasis-open.org,
        virtualization@lists.linux-foundation.org,
        Frank Swiderski <fes@google.com>
Message-ID: <990f1cbc-fa54-4cb2-a9ee-394a1a6d5f07@email.android.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On March 14, 2014 11:34:31 PM EDT, Theodore Ts'o <tytso@mit.edu> wrote:
>The current virtio block sets a queue depth of 64, which is
>insufficient for very fast devices.  It has been demonstrated that
>with a high IOPS device, using a queue depth of 256 can double the
>IOPS which can be sustained.
>
>As suggested by Venkatash Srinivas, set the queue depth by default to
>be one half the the device's virtqueue, which is the maximum queue
>depth that can be supported by the channel to the host OS (each I/O
>request requires at least two VQ entries).
>
>Also allow the queue depth to be something which can be set at module
>load time or via a kernel boot-time parameter, for
>testing/benchmarking purposes.
>
>Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
>Signed-off-by: Venkatesh Srinivas <venkateshs@google.com>
>Cc: Rusty Russell <rusty@rustcorp.com.au>
>Cc: "Michael S. Tsirkin" <mst@redhat.com>
>Cc: virtio-dev@lists.oasis-open.org
>Cc: virtualization@lists.linux-foundation.org
>Cc: Frank Swiderski <fes@google.com>
>---
>
>This is a combination of my patch and Vekatash's patch.  I agree that
>setting the default automatically is better than requiring the user to
>set the value by hand.
>
> drivers/block/virtio_blk.c | 10 ++++++++--
> 1 file changed, 8 insertions(+), 2 deletions(-)
>
>diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
>index 6a680d4..0f70c01 100644
>--- a/drivers/block/virtio_blk.c
>+++ b/drivers/block/virtio_blk.c
>@@ -481,6 +481,9 @@ static struct blk_mq_ops virtio_mq_ops = {
> 	.free_hctx	= blk_mq_free_single_hw_queue,
> };
> 
>+static int queue_depth = -1;
>+module_param(queue_depth, int, 0444);

?

>+
> static struct blk_mq_reg virtio_mq_reg = {
> 	.ops		= &virtio_mq_ops,
> 	.nr_hw_queues	= 1,
>@@ -551,9 +554,14 @@ static int virtblk_probe(struct virtio_device
>*vdev)
> 		goto out_free_vq;
> 	}
> 
>+	virtio_mq_reg.queue_depth = queue_depth > 0 ? queue_depth :
>+		(vblk->vq->num_free / 2);
> 	virtio_mq_reg.cmd_size =
> 		sizeof(struct virtblk_req) +
> 		sizeof(struct scatterlist) * sg_elems;
>+	virtblk_name_format("vd", index, vblk->disk->disk_name,
>DISK_NAME_LEN);
>+	pr_info("%s: using queue depth %d\n", vblk->disk->disk_name,
>+		virtio_mq_reg.queue_depth);

Isn't that visible from sysfs?
> 
> 	q = vblk->disk->queue = blk_mq_init_queue(&virtio_mq_reg, vblk);
> 	if (!q) {
>@@ -565,8 +573,6 @@ static int virtblk_probe(struct virtio_device
>*vdev)
> 
> 	q->queuedata = vblk;
> 
>-	virtblk_name_format("vd", index, vblk->disk->disk_name,
>DISK_NAME_LEN);
>-
> 	vblk->disk->major = major;
> 	vblk->disk->first_minor = index_to_minor(index);
> 	vblk->disk->private_data = vblk;


