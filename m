Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755854AbaE2EMJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 00:12:09 -0400
Received: from ozlabs.org ([103.22.144.67]:59709 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754282AbaE2EMH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 00:12:07 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Michael S. Tsirkin" <mst@redhat.com>, Minchan Kim <minchan@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: virtio_ring stack usage.
In-Reply-To: <20140528090409.GA16795@redhat.com>
References: <1401260039-18189-1-git-send-email-minchan@kernel.org> <1401260039-18189-2-git-send-email-minchan@kernel.org> <20140528090409.GA16795@redhat.com>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Thu, 29 May 2014 13:40:08 +0930
Message-ID: <87r43d6x9b.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Michael S. Tsirkin" <mst@redhat.com> writes:
> On Wed, May 28, 2014 at 03:53:59PM +0900, Minchan Kim wrote:
>> [ 1065.604404] kworker/-5766    0d..2 1071625993us : stack_trace_call:   9)     6456      80   __kmalloc+0x1cb/0x200
>> [ 1065.604404] kworker/-5766    0d..2 1071625993us : stack_trace_call:  10)     6376     376   vring_add_indirect+0x36/0x200
>> [ 1065.604404] kworker/-5766    0d..2 1071625993us : stack_trace_call:  11)     6000     144   virtqueue_add_sgs+0x2e2/0x320
>> [ 1065.604404] kworker/-5766    0d..2 1071625993us : stack_trace_call:  12)     5856     288   __virtblk_add_req+0xda/0x1b0
>> [ 1065.604404] kworker/-5766    0d..2 1071625993us : stack_trace_call:  13)     5568      96   virtio_queue_rq+0xd3/0x1d0
>
> virtio stack usage seems very high.
> Here is virtio_ring.su generated using -fstack-usage flag for gcc 4.8.2.
>
> virtio_ring.c:107:35:sg_next_arr        16      static
...
> <--- this is a surprise, I really expected it to be inlined
>      same for sg_next_chained.
> <--- Rusty: should we force compiler to inline it?

Extra cc's dropped.

Weird, works here (gcc 4.8.2, 32 bit).  Hmm, same with 64 bit:

gcc -Wp,-MD,drivers/virtio/.virtio_ring.o.d  -nostdinc -isystem /usr/lib/gcc/x86_64-linux-gnu/4.8/include -I/home/rusty/devel/kernel/linux/arch/x86/include -Iarch/x86/include/generated  -Iinclude -I/home/rusty/devel/kernel/linux/arch/x86/include/uapi -Iarch/x86/include/generated/uapi -I/home/rusty/devel/kernel/linux/include/uapi -Iinclude/generated/uapi -include /home/rusty/devel/kernel/linux/include/linux/kconfig.h -D__KERNEL__ -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common -Werror-implicit-function-declaration -Wno-format-security -fno-delete-null-pointer-checks -O2 -m64 -mno-mmx -mno-sse -mno-80387 -mno-fp-ret-in-387 -mpreferred-stack-boundary=3 -march=core2 -mno-red-zone -mcmodel=kernel -funit-at-a-time -maccumulate-outgoing-args -DCONFIG_AS_CFI=1 -DCONFIG_AS_CFI_SIGNAL_FRAME=1 -DCONFIG_AS_CFI_SECTIONS=1 -DCONFIG_AS_FXSAVEQ=1 -DCONFIG_AS_CRC32=1 -DCONFIG_AS_AVX=1 -DCONFIG_AS_AVX2=1 -pipe -Wno-sign-compare -fno-asynchronous-unwind-tables -mno-sse -mno-mmx -mno-sse2 -mno-3dnow -mno-avx -Wframe-larger-than=1024 -fno-stack-protector -Wno-unused-but-set-variable -fno-omit-frame-pointer -fno-optimize-sibling-calls -Wdeclaration-after-statement -Wno-pointer-sign -fno-strict-overflow -fconserve-stack -Werror=implicit-int -Werror=strict-prototypes -DCC_HAVE_ASM_GOTO    -D"KBUILD_STR(s)=#s" -D"KBUILD_BASENAME=KBUILD_STR(virtio_ring)"  -D"KBUILD_MODNAME=KBUILD_STR(virtio_ring)" -c -o drivers/virtio/virtio_ring.o drivers/virtio/virtio_ring.c

$ objdump -dr drivers/virtio/virtio_ring.o | grep sg_next
			988: R_X86_64_PC32	sg_next-0x4
			9d8: R_X86_64_PC32	sg_next-0x4
			ae9: R_X86_64_PC32	sg_next-0x4
			b99: R_X86_64_PC32	sg_next-0x4
			d31: R_X86_64_PC32	sg_next-0x4
			df1: R_X86_64_PC32	sg_next-0x4
$

It's worth noting that older GCCs would sometimes successfully inline
the indirect function (ie. sg_next_chained and sg_next_ar) but still
emit an unused copy.  Is that happening for you too?

I added a hack to actually measure how much stack we're using (x86-64):

gcc 4.8.4:
[    3.261826] virtio_blk: stack used = 408

gcc 4.6:
[    3.276449] virtio_blk: stack depth = 448

Here's the hack I used:

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 6d8a87f252de..bcd6336e3561 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -151,15 +151,19 @@ static void virtblk_done(struct virtqueue *vq)
 		blk_mq_start_stopped_hw_queues(vblk->disk->queue);
 }
 
+extern struct task_struct *record_stack;
+extern unsigned long stack_top;
+
 static int virtio_queue_rq(struct blk_mq_hw_ctx *hctx, struct request *req)
 {
+	unsigned long stack_bottom = (unsigned long)&stack_bottom;
 	struct virtio_blk *vblk = hctx->queue->queuedata;
 	struct virtblk_req *vbr = req->special;
 	unsigned long flags;
 	unsigned int num;
 	const bool last = (req->cmd_flags & REQ_END) != 0;
 	int err;
-
+	
 	BUG_ON(req->nr_phys_segments + 2 > vblk->sg_elems);
 
 	vbr->req = req;
@@ -199,7 +203,10 @@ static int virtio_queue_rq(struct blk_mq_hw_ctx *hctx, struct request *req)
 	}
 
 	spin_lock_irqsave(&vblk->vq_lock, flags);
+	record_stack = current;
 	err = __virtblk_add_req(vblk->vq, vbr, vbr->sg, num);
+	record_stack = NULL;
+	printk("virtio_blk: stack used = %lu\n", stack_bottom - stack_top);
 	if (err) {
 		virtqueue_kick(vblk->vq);
 		spin_unlock_irqrestore(&vblk->vq_lock, flags);
diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index 1e443629f76d..39158d6079a9 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -113,6 +113,14 @@ static inline struct scatterlist *sg_next_arr(struct scatterlist *sg,
 	return sg + 1;
 }
 
+extern struct task_struct *record_stack;
+struct task_struct *record_stack;
+EXPORT_SYMBOL(record_stack);
+
+extern unsigned long stack_top;
+unsigned long stack_top;
+EXPORT_SYMBOL(stack_top);
+
 /* Set up an indirect table of descriptors and add it to the queue. */
 static inline int vring_add_indirect(struct vring_virtqueue *vq,
 				     struct scatterlist *sgs[],
@@ -141,6 +149,9 @@ static inline int vring_add_indirect(struct vring_virtqueue *vq,
 	if (!desc)
 		return -ENOMEM;
 
+	if (record_stack == current)
+		stack_top = (unsigned long)&desc;
+
 	/* Transfer entries from the sg lists into the indirect page */
 	i = 0;
 	for (n = 0; n < out_sgs; n++) {
