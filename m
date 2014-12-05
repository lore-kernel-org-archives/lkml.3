Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753110AbaLEM4t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 07:56:49 -0500
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:30119 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157AbaLEM4s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 07:56:48 -0500
X-IronPort-AV: E=Sophos;i="5.07,522,1413270000"; 
   d="scan'208";a="52529090"
From: Hante Meuleman <meuleman@broadcom.com>
To: Will Deacon <will.deacon@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Arend Van Spriel <arend@broadcom.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        David Miller <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        brcm80211-dev-list <brcm80211-dev-list@broadcom.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
Subject: RE: using DMA-API on ARM
Thread-Topic: using DMA-API on ARM
Thread-Index: AQHQEGz8Uq/ZoaNhbU+cR76RcmjkiZyBRZEAgAAsfoD//36ZUA==
Date: Fri, 5 Dec 2014 12:56:45 +0000
Message-ID: <F51492713EF10846800D8C0ED37A7DCE019016E1@SJEXCHMB15.corp.ad.broadcom.com>
References: <5481794E.4050406@broadcom.com>
 <20141205094507.GP11285@n2100.arm.linux.org.uk>
 <20141205122423.GK1630@arm.com>
In-Reply-To: <20141205122423.GK1630@arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.16.203.100]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The problem is with data coming from device, so DMA from device to host. The DMA takes place from device local memory to host memory, where the host memory is allocated with dma_alloc_coherent, which we thought should not be cached. The host is an ARM (as is the device). The data being DMA'ed ends up in a ring buffer. This ring is only being read by host when it is a d2h ring (device to host). Each entry in the ring is 32 bytes, and contains a sequence number. The sequence number is a modulo 253 and the ring has 256 entries. At some point we read a sequence number which was "old". Then we loop to see if the sequence number changes. The loop is 1024 times and uses an rmb() call. This does not help. After looping 1024 times it is still reading the same value for sequence number. Now it can happen that 256 entries further we are still reading this old sequence (so iso reading a seqnum which is off by 3, it is off by 6). This was an indication that it was cached. So instead of using rmb() we used dma_sync_single_for_cpu. When using that call the problem was fixed. Whenever an old sequence number was read a single call to dma_sync_single_for_cpu would flush the cache and the next read would be correct. 

However: this indicates that dma_alloc_coherent on an ARM target may result in a memory buffer which can be cached which conflicts with the API of this function. This problem has sofar not been observed on x86 hosts.

Regards,
Hante

-----Original Message-----
From: Will Deacon [mailto:will.deacon@arm.com] 
Sent: vrijdag 5 december 2014 13:24
To: Russell King - ARM Linux
Cc: Arend Van Spriel; Marek Szyprowski; linux-arm-kernel@lists.infradead.org; David Miller; linux-kernel@vger.kernel.org; brcm80211-dev-list; linux-wireless
Subject: Re: using DMA-API on ARM

On Fri, Dec 05, 2014 at 09:45:08AM +0000, Russell King - ARM Linux wrote:
> On Fri, Dec 05, 2014 at 10:22:22AM +0100, Arend van Spriel wrote:
> > For our brcm80211 development we are working on getting brcmfmac driver
> > up and running on a Broadcom ARM-based platform. The wireless device is
> > a PCIe device, which is hooked up to the system behind a PCIe host
> > bridge, and we transfer information between host and device using a
> > descriptor ring buffer allocated using dma_alloc_coherent(). We mostly
> > tested on x86 and seen no issue. However, on this ARM platform
> > (single-core A9) we detect occasionally that the descriptor content is
> > invalid. When this occurs we do a dma_sync_single_for_cpu() and this is
> > retried a number of times if the problem persists. Actually, found out
> > that someone made a mistake by using virt_to_dma(va) to get the
> > dma_handle parameter. So probably we only provided a delay in the retry
> > loop. After fixing that a single call to dma_sync_single_for_cpu() is
> > sufficient. The DMA-API-HOWTO clearly states that:
> > 
> > """
> > the hardware should guarantee that the device and the CPU can access the
> > data in parallel and will see updates made by each other without any
> > explicit software flushing.
> > """
> > 
> > So it seems incorrect that we would need to do a dma_sync for this
> > memory. That we do need it seems like this memory can end up in
> > cache(?), or whatever happens, in some rare condition. Is there anyway
> > to investigate this situation either through DMA-API or some low-level
> > ARM specific functions.
> 
> It's been a long while since I looked at the code, and the code for
> dma_alloc_coherent() has completely changed since then with the
> addition of CMA.  I'm afraid that anything I would say about it would
> not be accurate without research into the possible paths through that
> code - it's no longer just a simple allocator.
> 
> What you say is correct however: the memory should not have any cache
> lines associated with it, if it does, there's a bug somewhere.
> 
> Also, the memory will be weakly ordered, which means that writes to such
> memory can be reordered.  If ordering matters, barriers should be used.
> rmb() and wmb() can be used for this.
> 
> (Added Marek for comment on dma_alloc_coherent(), Will for comment on
> barrier stuff.)

I'm not quite clear on the issue being seen here: is this on write from
the CPU to the descriptor ring, or the other way around (or both?).

Either way, you need barriers on the CPU side to ensure ordering of
accesses to the buffer. rmb/wmb will work, but are heavier than what you
need (relaxed versions have been proposed on LKML recently).

Will
