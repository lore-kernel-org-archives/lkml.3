Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755709AbaIZOLF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 10:11:05 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:54920 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755398AbaIZOLC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 10:11:02 -0400
Message-ID: <542573EE.8070103@hurleysoftware.com>
Date: Fri, 26 Sep 2014 10:10:54 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>, Rob Clark <robdclark@gmail.com>,
        Thomas Hellstrom <thellstrom@vmware.com>
CC: Chuck Ebbert <cebbert.lkml@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Hugh Dickens <hughd@google.com>,
        Linux kernel <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        linux-mm <linux-mm@kvack.org>, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Shaohua Li <shli@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Leann Ogasawara <leann.ogasawara@canonical.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: page allocator bug in 3.16?
References: <54246506.50401@hurleysoftware.com>	<20140925143555.1f276007@as>	<5424AAD0.9010708@hurleysoftware.com>	<542512AD.9070304@vmware.com>	<20140926054005.5c7985c0@as>	<542543D8.8020604@vmware.com> <CAF6AEGvOkPq5LQR76-VbspYyCvUxL1=W-dLc4g_aWX2wkUmRpg@mail.gmail.com> <54255EA5.3030207@redhat.com>
In-Reply-To: <54255EA5.3030207@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ +cc Leann Ogasawara, Marek Szyprowski, Kyungmin Park, Arnd Bergmann ]

On 09/26/2014 08:40 AM, Rik van Riel wrote:
> On 09/26/2014 08:28 AM, Rob Clark wrote:
>> On Fri, Sep 26, 2014 at 6:45 AM, Thomas Hellstrom
>> <thellstrom@vmware.com> wrote:
>>> On 09/26/2014 12:40 PM, Chuck Ebbert wrote:
>>>> On Fri, 26 Sep 2014 09:15:57 +0200 Thomas Hellstrom
>>>> <thellstrom@vmware.com> wrote:
>>>>
>>>>> On 09/26/2014 01:52 AM, Peter Hurley wrote:
>>>>>> On 09/25/2014 03:35 PM, Chuck Ebbert wrote:
>>>>>>> There are six ttm patches queued for 3.16.4:
>>>>>>>
>>>>>>> drm-ttm-choose-a-pool-to-shrink-correctly-in-ttm_dma_pool_shrink_scan.patch
>>>>>>>
>>>>>>>
> drm-ttm-fix-handling-of-ttm_pl_flag_topdown-v2.patch
>>>>>>> drm-ttm-fix-possible-division-by-0-in-ttm_dma_pool_shrink_scan.patch
>>>>>>>
>>>>>>>
> drm-ttm-fix-possible-stack-overflow-by-recursive-shrinker-calls.patch
>>>>>>> drm-ttm-pass-gfp-flags-in-order-to-avoid-deadlock.patch 
>>>>>>> drm-ttm-use-mutex_trylock-to-avoid-deadlock-inside-shrinker-functions.patch
>>>>>>
>>>>>>>
> Thanks for info, Chuck.
>>>>>>
>>>>>> Unfortunately, none of these fix TTM dma allocation doing
>>>>>> CMA dma allocation, which is the root problem.
>>>>>>
>>>>>> Regards, Peter Hurley
>>>>> The problem is not really in TTM but in CMA, There was a guy
>>>>> offering to fix this in the CMA code but I guess he didn't
>>>>> probably because he didn't receive any feedback.
>>>>>
>>>> Yeah, the "solution" to this problem seems to be "don't enable
>>>> CMA on x86". Maybe it should even be disabled in the config
>>>> system.
>>> Or, as previously suggested, don't use CMA for order 0 (single
>>> page) allocations....
>>
>> On devices that actually need CMA pools to arrange for memory to be
>> in certain ranges, I think you probably do want to have order 0
>> pages come from the CMA pool.
>>
>> Seems like disabling CMA on x86 (where it should be unneeded) is
>> the better way, IMO
> 
> CMA has its uses on x86. For example, CMA is used to allocate 1GB huge
> pages.
> 
> There may also be people with devices that do not scatter-gather, and
> need a large physically contiguous buffer, though there should be
> relatively few of those on x86.
> 
> I suspect it makes most sense to do DMA allocations up to PAGE_ORDER
> through the normal allocator on x86, and only invoking CMA for larger
> allocations.

The code that uses CMA to satisfy DMA allocations on x86 is
specific to the x86 arch and was added in 2011 as a means of _testing_
CMA in KVM:

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

(no x86 maintainer acks?).

Unfortunately, this code is enabled whenever CMA is enabled, rather
than as a separate test configuration.

So, while enabling CMA may have other purposes on x86, using it for
x86 swiotlb and nommu dma allocations is not one of the them.

And Ubuntu should not be enabling CONFIG_DMA_CMA for their i386
and amd64 configurations, as this is trying to drive _all_ dma mapping
allocations through a _very_ small window (which is killing GPU
performance).

Regards,
Peter Hurley


