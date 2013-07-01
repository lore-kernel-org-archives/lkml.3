Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754730Ab3GARKD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 13:10:03 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:35239 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752093Ab3GARKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 13:10:01 -0400
Date: Mon, 1 Jul 2013 18:09:41 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>, Will Deacon <will.deacon@arm.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Nicolas Pitre <nico@linaro.org>
Subject: Re: [RFC PATCH 5/6] ARM, mm: change meaning of max_low_pfn to
	maximum pfn for nobootmem
Message-ID: <20130701170941.GC24642@n2100.arm.linux.org.uk>
References: <1364184674-13798-1-git-send-email-iamjoonsoo.kim@lge.com> <1364184674-13798-6-git-send-email-iamjoonsoo.kim@lge.com> <51D18ED5.50103@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51D18ED5.50103@ti.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 01, 2013 at 10:14:45AM -0400, Santosh Shilimkar wrote:
> I have been also carrying similar patch as yours in an attempt
> to make LPAE kernel work on ARM. Your patch carries better
> description, so will your version and include in my series
> which I plan to post on the list after some more testing.
> Will copy you. The changes are very similar to your series.

And will you try to investigate and/or address my concerns with this
change?

Consider this code in the block layer:

static int __init blk_settings_init(void)
{
        blk_max_low_pfn = max_low_pfn - 1;
        blk_max_pfn = max_pfn - 1;
        return 0;
}

void blk_queue_bounce_limit(struct request_queue *q, u64 dma_mask)
{
        unsigned long b_pfn = dma_mask >> PAGE_SHIFT;
...
        if (b_pfn < blk_max_low_pfn)
                dma = 1;
        q->limits.bounce_pfn = b_pfn;
        if (dma) {
                init_emergency_isa_pool();
                q->bounce_gfp = GFP_NOIO | GFP_DMA;
                q->limits.bounce_pfn = b_pfn;
        }
}

and this in SCSI:

u64 scsi_calculate_bounce_limit(struct Scsi_Host *shost)
{
        struct device *host_dev;
        u64 bounce_limit = 0xffffffff;
...
        host_dev = scsi_get_device(shost);
        if (host_dev && host_dev->dma_mask)
                bounce_limit = *host_dev->dma_mask;

        return bounce_limit;
}

struct request_queue *__scsi_alloc_queue(struct Scsi_Host *shost,
                                         request_fn_proc *request_fn)
{
...
        blk_queue_bounce_limit(q, scsi_calculate_bounce_limit(shost));

Now, what happens when you have a device which can only address the first
64MB of system memory, which is at 3GB(physical), but you have 1GB of
system memory available both before changing max_low_pfn, and after
changing max_low_pfn.

Bear in mind that you will find that virtually all places in the kernel
set the device DMA mask to be "DMA_BIT_MASK(number_of_bits_driven)" and
not offset by the base of physical memory.  In the above case, consider
what happens with a 24 bit DMA mask.

So... if we make this change, I would much prefer to also see a number
of other patches preceding this one:

(a) blk_queue_bounce_limit()'s parameter renamed from "dma_mask" to
   "max_addr" or indeed just taking b_pfn directly.
(b) a helper: dma_max_pfn(dev) which converts a DMA bitmask of bits
   to a b_pfn number which is just "dev->dma_mask >> PAGE_SHIFT" in the
   generic case, but ARM can override this later.
(c) a patch changing max_low_pfn/max_pfn to include the physical offset
   of memory, and providing an ARM version of this which adds in the
   appropriate offset.

Here's an example dma_max_pfn() helper for the generic case:

diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index 48ef6f5..a083724 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -153,6 +153,13 @@ static inline int dma_set_seg_boundary(struct device *dev, unsigned long mask)
 		return -EIO;
 }
 
+#ifndef dma_max_pfn
+static inline unsigned long dma_max_pfn(struct device *dev)
+{
+	return dev->dma_mask ? (*dev->dma_mask >> PAGE_SHIFT) : 0;
+}
+#endif
+
 static inline void *dma_zalloc_coherent(struct device *dev, size_t size,
 					dma_addr_t *dma_handle, gfp_t flag)
 {

Arches can then override this with:

static inline unsigned long dma_max_pfn(struct device *dev)
{
	...
}
#define dma_max_pfn dma_max_pfn
