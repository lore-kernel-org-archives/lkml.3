Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836AbaLEMnH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 07:43:07 -0500
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:47393 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282AbaLEMnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 07:43:05 -0500
X-IronPort-AV: E=Sophos;i="5.07,522,1413270000"; 
   d="scan'208";a="52360672"
Message-ID: <5481A855.6000603@broadcom.com>
Date: Fri, 5 Dec 2014 13:43:01 +0100
From: Arend van Spriel <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.24) Gecko/20111103 Lightning/1.0b2 Thunderbird/3.1.16
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Will Deacon <will.deacon@arm.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        David Miller <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "brcm80211-dev-list@broadcom.com" <brcm80211-dev-list@broadcom.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: using DMA-API on ARM
References: <5481794E.4050406@broadcom.com> <20141205094507.GP11285@n2100.arm.linux.org.uk>
In-Reply-To: <20141205094507.GP11285@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05-12-14 10:45, Russell King - ARM Linux wrote:
> On Fri, Dec 05, 2014 at 10:22:22AM +0100, Arend van Spriel wrote:
>> For our brcm80211 development we are working on getting brcmfmac driver
>> up and running on a Broadcom ARM-based platform. The wireless device is
>> a PCIe device, which is hooked up to the system behind a PCIe host
>> bridge, and we transfer information between host and device using a
>> descriptor ring buffer allocated using dma_alloc_coherent(). We mostly
>> tested on x86 and seen no issue. However, on this ARM platform
>> (single-core A9) we detect occasionally that the descriptor content is
>> invalid. When this occurs we do a dma_sync_single_for_cpu() and this is
>> retried a number of times if the problem persists. Actually, found out
>> that someone made a mistake by using virt_to_dma(va) to get the
>> dma_handle parameter. So probably we only provided a delay in the retry
>> loop. After fixing that a single call to dma_sync_single_for_cpu() is
>> sufficient. The DMA-API-HOWTO clearly states that:
>>
>> """
>> the hardware should guarantee that the device and the CPU can access the
>> data in parallel and will see updates made by each other without any
>> explicit software flushing.
>> """
>>
>> So it seems incorrect that we would need to do a dma_sync for this
>> memory. That we do need it seems like this memory can end up in
>> cache(?), or whatever happens, in some rare condition. Is there anyway
>> to investigate this situation either through DMA-API or some low-level
>> ARM specific functions.
>
> It's been a long while since I looked at the code, and the code for
> dma_alloc_coherent() has completely changed since then with the
> addition of CMA.  I'm afraid that anything I would say about it would
> not be accurate without research into the possible paths through that
> code - it's no longer just a simple allocator.

I know. On this particular platform we are not using CMA.

> What you say is correct however: the memory should not have any cache
> lines associated with it, if it does, there's a bug somewhere.
>
> Also, the memory will be weakly ordered, which means that writes to such
> memory can be reordered.  If ordering matters, barriers should be used.
> rmb() and wmb() can be used for this.

Ok. You already had a peek in our code checking the memory barriers, 
which does not have the dma_sync_single_for_cpu() "workaround" yet. So 
here some more background. The problem is in DMA_FROM_DEVICE direction. 
Because of the possible reordering issue we first tried using rmb() in 
the retry loop but that did not solve it. Another experiment was to 
ignore the failed ring descriptor entry and proceed. So we get interrupt 
from device and access the ring descriptor entry. This should contain 
expected value X, however we get X-1 back. When proceeding everything 
works find until hitting the same ring descriptor entry again reading 
X-1 when X+1 would be valid. This lead us to the assumption that somehow 
this entry ended up in cache lines. The issue goes away using the 
dma_sync_single_for_cpu() with DMA_FROM_DEVICE in direction parameter. 
We are not longer using virt_to_dma() so that is no longer an issue. So 
is there any function interface to verify cache status.

Regards,
Arend

> (Added Marek for comment on dma_alloc_coherent(), Will for comment on
> barrier stuff.)
>

