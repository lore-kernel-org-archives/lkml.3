Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755500AbaKYL3S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 06:29:18 -0500
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:33648 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754257AbaKYL3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 06:29:15 -0500
Date: Tue, 25 Nov 2014 11:29:05 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Ding Tianhong <dingtianhong@huawei.com>
Subject: Re: For the problem when using swiotlb
Message-ID: <20141125112905.GC3836@n2100.arm.linux.org.uk>
References: <5469E26B.2010905@huawei.com>
 <20141121175118.GA10451@localhost>
 <20141121180925.GG19783@e104818-lin.cambridge.arm.com>
 <2166613.l2i4mdmtLA@wuerfel>
 <20141125105815.GB18858@e104818-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141125105815.GB18858@e104818-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 25, 2014 at 10:58:15AM +0000, Catalin Marinas wrote:
> Since we don't have a coherent_dma_supported() function, we defer the
> validity check of coherent_dma_mask to dma_alloc_coherent() (and here we
> can remove bouncing since swiotlb has relatively small buffers).

Bouncing of coherent DMA buffers is insane; if you have to bounce them,
they're by definition not coherent.

Think about one of the common uses of coherent DMA buffers: ring buffers,
where both the CPU and the DMA agent write to the ring:

- CPU writes to ring, loading address and length, then writing to the
  status word for the ring entry.
- DMA reads the ring status word, sees it owns the entry, processes it,
  DMA writes to the ring status word to give it back.

What this means is that if you are bouncing the buffer, you are copying
it whole-sale between the CPU visible version and the DMA visible
version, which means that you can miss DMA updates to it.  So, bouncing
a coherent DMA buffer is simply not an acceptable implementation for
dma_alloc_coherent().

As for validity of masks, it is defined in the DMA API documentation that
if a DMA mask is suitable for the streaming APIs, then it is also suitable
for the coherent APIs.  The reverse is left open, and so may not
necessarily be true.

In other words:

	err = dma_set_mask(dev, mask);
	if (err == 0)
		assert(dma_set_coherent_mask(dev, mask) == 0);

must always succeed, but reversing the two calls has no guarantee.

Note that there seems to be only one driver which has different coherent
and streaming DMA masks today:

drivers/media/pci/sta2x11/sta2x11_vip.c:
        if (dma_set_mask(&pdev->dev, DMA_BIT_MASK(26))) {
        err = dma_set_coherent_mask(&vip->pdev->dev, DMA_BIT_MASK(29));

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
