Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756869AbaIEMBj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 08:01:39 -0400
Received: from ozlabs.org ([103.22.144.67]:50286 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751232AbaIEMBi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 08:01:38 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ming Lei <ming.lei@canonical.com>, Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        Kick In <pierre-andre.morey@canonical.com>,
        Chris J Arges <chris.j.arges@canonical.com>
Subject: Re: [PATCH] blk-merge: fix blk_recount_segments
In-Reply-To: <87bnquk4fe.fsf@rustcorp.com.au>
References: <1409670180-17352-1-git-send-email-ming.lei@canonical.com> <20140902162146.GA28741@infradead.org> <5405EF38.60007@kernel.dk> <20140903121902.7a9f5a5a@tom-ThinkPad-T410> <87bnquk4fe.fsf@rustcorp.com.au>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Fri, 05 Sep 2014 21:29:00 +0930
Message-ID: <878ulyjn23.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell <rusty@rustcorp.com.au> writes:
> Ming Lei <ming.lei@canonical.com> writes:
>> On Tue, 02 Sep 2014 10:24:24 -0600
>> Jens Axboe <axboe@kernel.dk> wrote:
>>
>>> On 09/02/2014 10:21 AM, Christoph Hellwig wrote:
>>> > Btw, one thing we should reconsider is where we set
>>> > QUEUE_FLAG_NO_SG_MERGE.  At least for virtio-blk it seems to me that
>>> > doing the S/G merge should be a lot cheaper than fanning out into the
>>> > indirect descriptors.
>>
>> Indirect is always considered first no matter SG merge is off or on,
>> at least from current virtio-blk implementation.
>>
>> But it is a good idea to try direct descriptor first, the below simple
>> change can improve randread(libaio, O_DIRECT, multi-queue) 7% in my test,
>> and 77% transfer starts to use direct descriptor, and almost all transfer
>> uses indirect descriptor only in current upstream implementation.
>
> Hi Ming!
>
>         In general, we want to use direct descriptors of we have plenty
> of descriptors, and indirect if the ring is going to fill up.  I was
> thinking about this just yesterday, in fact.
>
> I've been trying to use EWMA to figure out how full the ring gets, but
> so far it's not working well.  I'm still hacking on a solution though,
> and your thoughts would be welcome.

Here's what I have.  It seems to work as expected, but I haven't
benchmarked it.

Subject: virtio_ring: try to use direct descriptors when we're not likely to fill ring

Indirect virtio descriptors allow us to use a single ring entry for a
large scatter-gather list, at the cost of a kmalloc.  If our ring
isn't heavily used, there's no point preserving descriptors.

This patch tracks the maximum number of descriptors in the ring, with
a slow decay.  When we add a new buffer, we assume there will be that
maximum number of descriptors, and use a direct buffer if there would
be room for that many descriptors of this size.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index 6d2b5310c991..2ff583477139 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -78,6 +78,11 @@ struct vring_virtqueue
 	/* Number we've added since last sync. */
 	unsigned int num_added;
 
+	/* How many descriptors have been added. */
+	unsigned int num_in_use;
+	/* Maximum descriptors in use (degrades over time). */
+	unsigned int max_in_use;
+
 	/* Last used index we've seen. */
 	u16 last_used_idx;
 
@@ -120,6 +125,31 @@ static struct vring_desc *alloc_indirect(unsigned int total_sg, gfp_t gfp)
 	return desc;
 }
 
+static bool try_indirect(struct vring_virtqueue *vq, unsigned int total_sg)
+{
+	unsigned long num_expected;
+
+	if (!vq->indirect)
+		return false;
+
+	/* Completely full?  Don't even bother with indirect alloc */
+	if (!vq->vq.num_free)
+		return false;
+
+	/* We're not going to fit?  Try indirect. */
+	if (total_sg > vq->vq.num_free)
+		return true;
+
+	/* We should be tracking this. */
+	BUG_ON(vq->max_in_use < vq->num_in_use);
+
+	/* How many more descriptors do we expect at peak usage? */
+	num_expected = vq->max_in_use - vq->num_in_use;
+
+	/* If each were this size, would they overflow? */
+	return (total_sg * num_expected > vq->vq.num_free);
+}
+
 static inline int virtqueue_add(struct virtqueue *_vq,
 				struct scatterlist *sgs[],
 				unsigned int total_sg,
@@ -162,9 +192,7 @@ static inline int virtqueue_add(struct virtqueue *_vq,
 
 	head = vq->free_head;
 
-	/* If the host supports indirect descriptor tables, and we have multiple
-	 * buffers, then go indirect. FIXME: tune this threshold */
-	if (vq->indirect && total_sg > 1 && vq->vq.num_free)
+	if (try_indirect(vq, total_sg))
 		desc = alloc_indirect(total_sg, gfp);
 	else
 		desc = NULL;
@@ -243,6 +271,14 @@ static inline int virtqueue_add(struct virtqueue *_vq,
 	virtio_wmb(vq->weak_barriers);
 	vq->vring.avail->idx++;
 	vq->num_added++;
+	vq->num_in_use++;
+
+	/* Every vq->vring.num descriptors, decay the maximum value */
+	if (unlikely(avail == 0))
+		vq->max_in_use >>= 1;
+
+	if (vq->num_in_use > vq->max_in_use)
+		vq->max_in_use = vq->num_in_use;
 
 	/* This is very unlikely, but theoretically possible.  Kick
 	 * just in case. */
@@ -515,6 +551,7 @@ void *virtqueue_get_buf(struct virtqueue *_vq, unsigned int *len)
 		virtio_mb(vq->weak_barriers);
 	}
 
+	vq->num_in_use--;
 #ifdef DEBUG
 	vq->last_add_time_valid = false;
 #endif
@@ -737,6 +774,8 @@ struct virtqueue *vring_new_virtqueue(unsigned int index,
 	vq->last_used_idx = 0;
 	vq->num_added = 0;
 	list_add_tail(&vq->vq.list, &vdev->vqs);
+	vq->num_in_use = 0;
+	vq->max_in_use = 0;
 #ifdef DEBUG
 	vq->in_use = false;
 	vq->last_add_time_valid = false;
