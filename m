Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751691AbaIMFGp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2014 01:06:45 -0400
Received: from ozlabs.org ([103.22.144.67]:47229 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751123AbaIMFGn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2014 01:06:43 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ming Lei <ming.lei@canonical.com>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kick In <pierre-andre.morey@canonical.com>,
        Chris J Arges <chris.j.arges@canonical.com>
Subject: Re: [PATCH] blk-merge: fix blk_recount_segments
In-Reply-To: <CACVXFVOX=Tcc9fN_C0FuEHsF22dave9vXtoVct5sx1iK1AWRXg@mail.gmail.com>
References: <1409670180-17352-1-git-send-email-ming.lei@canonical.com> <20140902162146.GA28741@infradead.org> <5405EF38.60007@kernel.dk> <20140903121902.7a9f5a5a@tom-ThinkPad-T410> <87bnquk4fe.fsf@rustcorp.com.au> <878ulyjn23.fsf@rustcorp.com.au> <87y4trhwqr.fsf@rustcorp.com.au> <CACVXFVOX=Tcc9fN_C0FuEHsF22dave9vXtoVct5sx1iK1AWRXg@mail.gmail.com>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Fri, 12 Sep 2014 11:13:26 +0930
Message-ID: <87oaulhav5.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ming Lei <ming.lei@canonical.com> writes:
> On Thu, Sep 11, 2014 at 7:38 AM, Rusty Russell <rusty@rustcorp.com.au> wrote:
>> Rusty Russell <rusty@rustcorp.com.au> writes:
>>> Rusty Russell <rusty@rustcorp.com.au> writes:
>>> Here's what I have.  It seems to work as expected, but I haven't
>>> benchmarked it.
>>
>> Hi Ming,
>>
>>         Any chance you can run your benchmarks against this patch?
>
> I can run the previous benchmark against this patch, but I am wondering
> if it is enough since the change need lots of test cases to verify.

Indeed, I'll particularly need to run network tests as well, but you're
the one who suggesting the fix for block so I'm relying on you to see
if this helps :)

> BTW, looks your patch doesn't against upstream kernel, since I can't
> find alloc_indirect() in drivers/virtio/virtio_ring.c

Yes, the code in my pending-rebases tree has been reworked.  Here's
the backport for you:

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index 4d08f45a9c29..5a911e1f7462 100644
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
 
@@ -184,6 +189,31 @@ static inline int vring_add_indirect(struct vring_virtqueue *vq,
 	return head;
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
 				struct scatterlist *(*next)
@@ -226,7 +256,7 @@ static inline int virtqueue_add(struct virtqueue *_vq,
 
 	/* If the host supports indirect descriptor tables, and we have multiple
 	 * buffers, then go indirect. FIXME: tune this threshold */
-	if (vq->indirect && total_sg > 1 && vq->vq.num_free) {
+	if (try_indirect(vq, total_sg)) {
 		head = vring_add_indirect(vq, sgs, next, total_sg, total_out,
 					  total_in,
 					  out_sgs, in_sgs, gfp);
@@ -291,6 +321,14 @@ add_head:
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
@@ -569,6 +607,7 @@ void *virtqueue_get_buf(struct virtqueue *_vq, unsigned int *len)
 		virtio_mb(vq->weak_barriers);
 	}
 
+	vq->num_in_use--;
 #ifdef DEBUG
 	vq->last_add_time_valid = false;
 #endif
@@ -791,6 +830,8 @@ struct virtqueue *vring_new_virtqueue(unsigned int index,
 	vq->last_used_idx = 0;
 	vq->num_added = 0;
 	list_add_tail(&vq->vq.list, &vdev->vqs);
+	vq->num_in_use = 0;
+	vq->max_in_use = 0;
 #ifdef DEBUG
 	vq->in_use = false;
 	vq->last_add_time_valid = false;
