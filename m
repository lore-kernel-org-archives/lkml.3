Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753267AbaJMGys (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 02:54:48 -0400
Received: from ozlabs.org ([103.22.144.67]:33383 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752846AbaJMGyq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 02:54:46 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Alexey Lapitsky <lex.public@gmail.com>
Cc: Dave Airlie <airlied@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        virtualization@lists.linux-foundation.org
Subject: Re: BUG_ON in virtio-ring.c
In-Reply-To: <CAAts5mM_+Mj=vjWyJc8wZCvZehfK5dZxeA0Y9eowHwFDiWxo9Q@mail.gmail.com>
References: <CAPM=9tyLrJ8VAdGCw_1guRS-ogCPE1Qp7faE_nrx_dAm2gvHLQ@mail.gmail.com> <87vc65p5a7.fsf@rustcorp.com.au> <CAPM=9tzw8jEv8yoLr7ktjO2DHCDzA+mURmJ-DXby_nsWUUNoyg@mail.gmail.com> <87li71oucu.fsf@rustcorp.com.au> <CAAts5mM_+Mj=vjWyJc8wZCvZehfK5dZxeA0Y9eowHwFDiWxo9Q@mail.gmail.com>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Mon, 13 Oct 2014 16:09:18 +1030
Message-ID: <87fvesedfd.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Lapitsky <lex.public@gmail.com> writes:
> Hi,
>
> I'm hitting this bug with both ext4 and btrfs.
>
> Here's an example of the backtrace:
> https://gist.github.com/vzctl/e888a821333979120932
>
> I tried raising this BUG only for direct ring and it solved the problem:
>
>  -       BUG_ON(total_sg > vq->vring.num);
> +       BUG_ON(total_sg > vq->vring.num && !vq->indirect);
>
> Shall I submit the patch or is a more elaborate fix required?

This is wrong.  It looks like the block layer is spending down
more sg elements than we have ring entries, yet we tell it not to:

	blk_queue_max_segments(q, vblk->sg_elems-2);

If you apply this patch, what happens?  Here it prints:

[    0.616564] virtqueue elements = 128, max_segments = 126 (1 queues)
[    0.621244]  vda: vda1 vda2 < vda5 >
[    0.632290] virtqueue elements = 128, max_segments = 126 (1 queues)
[    0.683526]  vdb: vdb1 vdb2 < vdb5 >

Cheers,
Rusty.

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 0a581400de0f..aa9d4d313587 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -683,6 +683,13 @@ static int virtblk_probe(struct virtio_device *vdev)
 	/* We can handle whatever the host told us to handle. */
 	blk_queue_max_segments(q, vblk->sg_elems-2);
 
+	printk("virtqueue elements = %u, max_segments = %u (%u queues)", 
+	       virtqueue_get_vring_size(vblk->vqs[0].vq),
+	       vblk->sg_elems-2,
+	       vblk->num_vqs);
+
+	BUG_ON(vblk->sg_elems-2 > virtqueue_get_vring_size(vblk->vqs[0].vq));
+
 	/* No need to bounce any requests */
 	blk_queue_bounce_limit(q, BLK_BOUNCE_ANY);
 


