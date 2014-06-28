Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964787AbaF1S2o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 14:28:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53782 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755658AbaF1Ru6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 13:50:58 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org,
        Ming Lei <ming.lei@canonical.com>, Jens Axboe <axboe@fb.com>
Subject: [PATCH 3.15 002/139] block: virtio_blk: dont hold spin lock during world switch
Date: Sat, 28 Jun 2014 10:46:03 -0700
Message-Id: <20140628174605.469557168@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140628174605.352098823@linuxfoundation.org>
References: <20140628174605.352098823@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Lei <ming.lei@canonical.com>

commit e8edca6f7f92234202d6dd163c118ef495244d7c upstream.

Firstly, it isn't necessary to hold lock of vblk->vq_lock
when notifying hypervisor about queued I/O.

Secondly, virtqueue_notify() will cause world switch and
it may take long time on some hypervisors(such as, qemu-arm),
so it isn't good to hold the lock and block other vCPUs.

On arm64 quad core VM(qemu-kvm), the patch can increase I/O
performance a lot with VIRTIO_RING_F_EVENT_IDX enabled:
	- without the patch: 14K IOPS
	- with the patch: 34K IOPS

fio script:
	[global]
	direct=1
	bsrange=4k-4k
	timeout=10
	numjobs=4
	ioengine=libaio
	iodepth=64

	filename=/dev/vdc
	group_reporting=1

	[f1]
	rw=randread

Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: virtualization@lists.linux-foundation.org
Signed-off-by: Ming Lei <ming.lei@canonical.com>
Acked-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Jens Axboe <axboe@fb.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/block/virtio_blk.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -159,6 +159,7 @@ static int virtio_queue_rq(struct blk_mq
 	unsigned int num;
 	const bool last = (req->cmd_flags & REQ_END) != 0;
 	int err;
+	bool notify = false;
 
 	BUG_ON(req->nr_phys_segments + 2 > vblk->sg_elems);
 
@@ -211,10 +212,12 @@ static int virtio_queue_rq(struct blk_mq
 		return BLK_MQ_RQ_QUEUE_ERROR;
 	}
 
-	if (last)
-		virtqueue_kick(vblk->vq);
-
+	if (last && virtqueue_kick_prepare(vblk->vq))
+		notify = true;
 	spin_unlock_irqrestore(&vblk->vq_lock, flags);
+
+	if (notify)
+		virtqueue_notify(vblk->vq);
 	return BLK_MQ_RQ_QUEUE_OK;
 }
 


