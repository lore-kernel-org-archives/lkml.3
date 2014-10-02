Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753060AbaJBWDW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 18:03:22 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:46158 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751885AbaJBWDV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 18:03:21 -0400
Message-ID: <542DCB9C.4020703@hurleysoftware.com>
Date: Thu, 02 Oct 2014 18:03:08 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Thomas Gleixner <tglx@linutronix.de>,
        Akinobu Mita <akinobu.mita@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        David Woodhouse <dwmw2@infradead.org>, Don Dutile <ddutile@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
        iommu@lists.linux-foundation.org, Greg KH <greg@kroah.com>
Subject: Re: [PATCH v3 0/5] enhance DMA CMA on x86
References: <1397567329-3771-1-git-send-email-akinobu.mita@gmail.com> <5426CA0A.7000806@hurleysoftware.com> <CAC5umyhgs8---HZLa7_DOSbqW0uPbLgqTfBweScZSR9oWbG9xg@mail.gmail.com> <54294C0B.1060705@hurleysoftware.com> <CAC5umyjP4OscSC8igVLYPEm-6gqiXt9md46sLu77Vut5UiPb=g@mail.gmail.com> <542ABF77.1020402@hurleysoftware.com> <alpine.DEB.2.11.1410010131380.4455@nanos> <542B5DC2.8020806@hurleysoftware.com> <20141002164121.GF1715@laptop.dumpdata.com>
In-Reply-To: <20141002164121.GF1715@laptop.dumpdata.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/02/2014 12:41 PM, Konrad Rzeszutek Wilk wrote:
> On Tue, Sep 30, 2014 at 09:49:54PM -0400, Peter Hurley wrote:
>> On 09/30/2014 07:45 PM, Thomas Gleixner wrote:
>>> Whether the proposed patchset is the correct solution to support it is
>>> a completely different question.
>>
>> This patchset has been in mainline since 3.16 and has already caused
>> regressions, so the question of whether this is the correct solution has
>> already been answered.
>>
>>> So either you stop this right now and help Akinobu to find the proper
>>> solution 
>>
>> If this is only a test platform for ARM parts then I don't think it
>> unreasonable to suggest forking x86 swiotlb support into a iommu=cma
> 
> Not sure what you mean by 'forking x86 swiotlb' ? As in have SWIOTLB
> work under ARM?

No, that's not what I meant.

>> selector that gets DMA mapping working for this test platform and doesn't
>> cause a bunch of breakage.
> 
> I think you might want to take a look at the IOMMU_DETECT macros
> and enable CMA there only if the certain devices are available.
> 
> That way the normal flow of detecting which IOMMU to use is still present
> and will turn of CMA if there is no device that would use it.
> 
>>
>> Which is different than if the plan is to ship production units for x86;
>> then a general purpose solution will be required.
>>
>> As to the good design of a general purpose solution for allocating and
>> mapping huge order pages, you are certainly more qualified to help Akinobu
>> than I am.

What Akinobu's patches intend to support is:

	phys_addr = dma_alloc_coherent(dev, 64 * 1024 * 1024, &bus_addr, GFP_KERNEL);

which raises three issues:

1. Where do coherent blocks of this size come from?
2. How to prevent fragmentation of these reserved blocks over time by
   existing DMA users?
3. Is this support generically required across all iommu implementations on x86?

Questions 1 and 2 are non-trivial, in the general case, otherwise the page
allocator would already do this. Simply dropping in the contiguous memory
allocator doesn't work because CMA does not have the same policy and performance
as the page allocator, and is already causing performance regressions even
in the absence of huge page allocations.

So that's why I raised question 3; is making the necessary compromises to support
64MB coherent DMA allocations across all x86 iommu implementations actually
required?

Prior to Akinobu's patches, the use of CMA by x86 iommu configurations was
designed to be limited to testing configurations, as the introductory
commit states:

commit 0a2b9a6ea93650b8a00f9fd5ee8fdd25671e2df6
Author: Marek Szyprowski <m.szyprowski@samsung.com>
Date:   Thu Dec 29 13:09:51 2011 +0100

    X86: integrate CMA with DMA-mapping subsystem
    
    This patch adds support for CMA to dma-mapping subsystem for x86
    architecture that uses common pci-dma/pci-nommu implementation. This
    allows to test CMA on KVM/QEMU and a lot of common x86 boxes.
    
    Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
    Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
    CC: Michal Nazarewicz <mina86@mina86.com>
    Acked-by: Arnd Bergmann <arnd@arndb.de>


Which brings me to my suggestion: if support for huge coherent DMA is
required only for a special test platform, then could not this support
be specific to a new iommu configuration, namely iommu=cma, which would
get initialized much the same way that iommu=calgary is now.

The code for such a iommu configuration would mostly duplicate
arch/x86/kernel/pci-swiotlb.c and the CMA support would get removed from
the other x86 iommu implementations.

Regards,
Peter Hurley
