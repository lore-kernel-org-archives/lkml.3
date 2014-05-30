Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755014AbaE3GCp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 02:02:45 -0400
Received: from ozlabs.org ([103.22.144.67]:36915 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751955AbaE3GCo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 02:02:44 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>, Jens Axboe <axboe@kernel.dk>,
        Minchan Kim <minchan@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave.hansen@intel.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 4/4] virtio_ring: unify direct/indirect code paths.
In-Reply-To: <20140529112905.GD30210@redhat.com>
References: <87oayh6s3s.fsf@rustcorp.com.au> <1401348405-18614-1-git-send-email-rusty@rustcorp.com.au> <1401348405-18614-5-git-send-email-rusty@rustcorp.com.au> <20140529112905.GD30210@redhat.com>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Fri, 30 May 2014 12:07:44 +0930
Message-ID: <87d2ew6lfr.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Michael S. Tsirkin" <mst@redhat.com> writes:
> On Thu, May 29, 2014 at 04:56:45PM +0930, Rusty Russell wrote:
>> virtqueue_add() populates the virtqueue descriptor table from the sgs
>> given.  If it uses an indirect descriptor table, then it puts a single
>> descriptor in the descriptor table pointing to the kmalloc'ed indirect
>> table where the sg is populated.
>> +	for (i = 0; i < total_sg; i++)
>> +		desc[i].next = i+1;
>> +	return desc;
>
> Hmm we are doing an extra walk over descriptors here.
> This might hurt performance esp for big descriptors.

Yes, this needs to be benchmarked; since it's cache hot my gut feel is
that it's a NOOP, but on modern machines my gut feel is always wrong.

>> +	if (vq->indirect && total_sg > 1 && vq->vq.num_free)
>> +		desc = alloc_indirect(total_sg, gfp);
>
> else desc = NULL will be a bit clearer won't it?

Agreed.

>>  	/* Update free pointer */
>> -	vq->free_head = i;
>> +	if (desc == vq->vring.desc)
>> +		vq->free_head = i;
>> +	else
>> +		vq->free_head = vq->vring.desc[head].next;
>
> This one is slightly ugly isn't it?

Yes, but it avoided another variable, and I was originally aiming
at stack conservation.  Turns out adding 'bool indirect' adds 32 bytes
more stack for gcc 4.6.4 :(

virtio_ring: minor neating

Before:
	gcc 4.8.2: virtio_blk: stack used = 408
	gcc 4.6.4: virtio_blk: stack used = 432

After:
	gcc 4.8.2: virtio_blk: stack used = 408
	gcc 4.6.4: virtio_blk: stack used = 464

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index 3adf5978b92b..7a7849bc26af 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -141,9 +141,10 @@ static inline int virtqueue_add(struct virtqueue *_vq,
 {
 	struct vring_virtqueue *vq = to_vvq(_vq);
 	struct scatterlist *sg;
-	struct vring_desc *desc = NULL;
+	struct vring_desc *desc;
 	unsigned int i, n, avail, uninitialized_var(prev);
 	int head;
+	bool indirect;
 
 	START_USE(vq);
 
@@ -176,21 +177,25 @@ static inline int virtqueue_add(struct virtqueue *_vq,
 	 * buffers, then go indirect. FIXME: tune this threshold */
 	if (vq->indirect && total_sg > 1 && vq->vq.num_free)
 		desc = alloc_indirect(total_sg, gfp);
+	else
+		desc = NULL;
 
 	if (desc) {
 		/* Use a single buffer which doesn't continue */
 		vq->vring.desc[head].flags = VRING_DESC_F_INDIRECT;
 		vq->vring.desc[head].addr = virt_to_phys(desc);
-		/* avoid kmemleak false positive (tis hidden by virt_to_phys) */
+		/* avoid kmemleak false positive (hidden by virt_to_phys) */
 		kmemleak_ignore(desc);
 		vq->vring.desc[head].len = total_sg * sizeof(struct vring_desc);
 
 		/* Set up rest to use this indirect table. */
 		i = 0;
 		total_sg = 1;
+		indirect = true;
 	} else {
 		desc = vq->vring.desc;
 		i = head;
+		indirect = false;
 	}
 
 	if (vq->vq.num_free < total_sg) {
@@ -230,10 +235,10 @@ static inline int virtqueue_add(struct virtqueue *_vq,
 	desc[prev].flags &= ~VRING_DESC_F_NEXT;
 
 	/* Update free pointer */
-	if (desc == vq->vring.desc)
-		vq->free_head = i;
-	else
+	if (indirect)
 		vq->free_head = vq->vring.desc[head].next;
+	else
+		vq->free_head = i;
 
 	/* Set token. */
 	vq->data[head] = data;
