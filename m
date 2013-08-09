Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966642Ab3HIKhj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 06:37:39 -0400
Received: from ni.piap.pl ([195.187.100.4]:49089 "EHLO ni.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753754Ab3HIKhh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 06:37:37 -0400
From: khalasa@piap.pl (Krzysztof =?utf-8?Q?Ha=C5=82asa?=)
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, James Bottomley <JBottomley@Parallels.com>,
        "David S. Miller" <davem@davemloft.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <m3fvujgrcr.fsf@t19.piap.pl>
	<20130809093506.GN23006@n2100.arm.linux.org.uk>
Date: Fri, 09 Aug 2013 12:34:11 +0200
In-Reply-To: <20130809093506.GN23006@n2100.arm.linux.org.uk> (Russell King's
	message of "Fri, 9 Aug 2013 10:35:06 +0100")
MIME-Version: 1.0
Message-ID: <m3bo57gnks.fsf@t19.piap.pl>
Content-Type: text/plain
Subject: Re: DMA masks
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.44/RELEASE,
	 bases: 20130809 #10903734, check: 20130809 clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King - ARM Linux <linux@arm.linux.org.uk> writes:

>> struct device {
>>         ...
>> 
>>         u64             *dma_mask;      /* dma mask (if dma'able device) */
>> ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>
> "If dma-able device" gives a clue.  It is now the case that the DMA API
> refuses DMA (via dma_supported) if the DMA mask pointer is NULL.

But precisely the same effect can be obtained by setting the (actual)
dma_mask to 0 (most preferably, using DMA API's dma_set_mask()).
This is what coherent_dma_mask does.

Actually, when the (pointer) dma_mask is NULL, the behaviour isn't
exactly simple. I guess this all works because devices without DMA
capability don't try to use DMA.

There is also that old saying that both the DMA masks should default to
0xFFFFFFFF (it does on some archs).

Perhaps I'm wrong, but wouldn't the conversion to simple u64 remove
a lot of unneeded code, make all the archs/platforms behave more
consistently, and generally make the world a bit better?

arch/unicore32/include/asm/dma-mapping.h:
static inline bool dma_capable(struct device *dev, dma_addr_t addr, size_t size)
{
        if (dev && dev->dma_mask)
                return addr + size - 1 <= *dev->dma_mask;

        return 1;
	^^^^^^^^^
}

arch/microblaze/include/asm/dma-mapping.h:
static inline unsigned long device_to_mask(struct device *dev)
{
        if (dev->dma_mask && *dev->dma_mask)
                return *dev->dma_mask;
        /* Assume devices without mask can take 32 bit addresses */
        return 0xfffffffful;
}

arch/hexagon/kernel/dma.c:
static int check_addr(const char *name, struct device *hwdev,
                      dma_addr_t bus, size_t size)
{
        if (hwdev && hwdev->dma_mask && !dma_capable(hwdev, bus, size)) {
                if (*hwdev->dma_mask >= DMA_BIT_MASK(32))
                        printk(KERN_ERR
                                "%s: overflow %Lx+%zu of device mask %Lx\n",
                                name, (long long)bus, size,
                                (long long)*hwdev->dma_mask);
                return 0;
        }
        return 1;
}

arch/powerpc/include/asm/dma-mapping.h:
static inline unsigned long device_to_mask(struct device *dev)
{
        if (dev->dma_mask && *dev->dma_mask)
                return *dev->dma_mask;
        /* Assume devices without mask can take 32 bit addresses */
        return 0xfffffffful;
}

etc.


Things like this:
	pdev1->dev.dma_mask = &pdev1->dev.coherent_dma_mask;
	pdev1->dev.coherent_dma_mask = DMA_BIT_MASK(32);
(which are all over the place) make me wonder what happens when some
code requires and tries to set different masks for normal and coherent
DMA.

> However, placing the storage for the dma_mask pointer into struct device
> is something which I've recently discussed with Greg, and is something
> he'd like to see happen, so I'll be adding that to my DMA masks patch
> series in the very near future.

Does this mean the dma_mask would remain a pointer, but it would point
(usually) to a variable in struct device?
-- 
Krzysztof Halasa

Research Institute for Automation and Measurements PIAP
Al. Jerozolimskie 202, 02-486 Warsaw, Poland
