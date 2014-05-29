Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932081AbaE2Cs4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 22:48:56 -0400
Received: from ozlabs.org ([103.22.144.67]:36196 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755405AbaE2Csz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 22:48:55 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Minchan Kim <minchan@kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        linux-mm@kvack.org, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave.hansen@intel.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: [RFC 2/2] x86_64: expand kernel stack to 16K
In-Reply-To: <20140529010940.GA10092@bbox>
References: <1401260039-18189-1-git-send-email-minchan@kernel.org> <1401260039-18189-2-git-send-email-minchan@kernel.org> <20140528090409.GA16795@redhat.com> <20140529010940.GA10092@bbox>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Thu, 29 May 2014 12:17:10 +0930
Message-ID: <87tx89713l.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Minchan Kim <minchan@kernel.org> writes:
> On Wed, May 28, 2014 at 12:04:09PM +0300, Michael S. Tsirkin wrote:
>> On Wed, May 28, 2014 at 03:53:59PM +0900, Minchan Kim wrote:
>> > [ 1065.604404] kworker/-5766    0d..2 1071625993us : stack_trace_call:   9)     6456      80   __kmalloc+0x1cb/0x200
>> > [ 1065.604404] kworker/-5766    0d..2 1071625993us : stack_trace_call:  10)     6376     376   vring_add_indirect+0x36/0x200
>> > [ 1065.604404] kworker/-5766    0d..2 1071625993us : stack_trace_call:  11)     6000     144   virtqueue_add_sgs+0x2e2/0x320

Hmm, we can actually skip the vring_add_indirect if we're hurting for
stack.  It just means the request will try to fit linearly in the ring,
rather than using indirect.

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index 1e443629f76d..496e727cefc8 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -184,6 +184,13 @@ static inline int vring_add_indirect(struct vring_virtqueue *vq,
 	return head;
 }
 
+/* The Morton Technique */
+static noinline bool stack_trouble(void)
+{
+	unsigned long sp = (unsigned long)&sp;
+	return sp - (sp & ~(THREAD_SIZE - 1)) < 3000;
+}
+
 static inline int virtqueue_add(struct virtqueue *_vq,
 				struct scatterlist *sgs[],
 				struct scatterlist *(*next)
@@ -226,7 +233,7 @@ static inline int virtqueue_add(struct virtqueue *_vq,
 
 	/* If the host supports indirect descriptor tables, and we have multiple
 	 * buffers, then go indirect. FIXME: tune this threshold */
-	if (vq->indirect && total_sg > 1 && vq->vq.num_free) {
+	if (vq->indirect && total_sg > 1 && vq->vq.num_free && !stack_trouble()) {
 		head = vring_add_indirect(vq, sgs, next, total_sg, total_out,
 					  total_in,
 					  out_sgs, in_sgs, gfp);
