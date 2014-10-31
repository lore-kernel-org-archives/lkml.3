Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760038AbaJaU71 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 16:59:27 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:59992 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758927AbaJaU7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 16:59:22 -0400
Message-ID: <5453F80C.4090006@gmail.com>
Date: Fri, 31 Oct 2014 13:58:52 -0700
From: Florian Fainelli <f.fainelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
CC: linux-arm-kernel@lists.infradead.org,
        Brian Norris <computersforpeace@gmail.com>,
        Gregory Fong <gregory.0xf0@gmail.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, lauraa@codeaurora.org, gioh.kim@lge.com,
        aneesh.kumar@linux.vnet.ibm.com, mina86@mina86.com,
        m.szyprowski@samsung.com, akpm@linux-foundation.org,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: DMA allocations from CMA and fatal_signal_pending check
References: <544FE9BE.6040503@gmail.com> <20141031082818.GB14642@js1304-P5Q-DELUXE>
In-Reply-To: <20141031082818.GB14642@js1304-P5Q-DELUXE>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joonsoo,

On 10/31/2014 01:28 AM, Joonsoo Kim wrote:
> On Tue, Oct 28, 2014 at 12:08:46PM -0700, Florian Fainelli wrote:
>> Hello,
>>
>> While debugging why some dma_alloc_coherent() allocations where
>> returning NULL on our brcmstb platform, specifically with
>> drivers/net/ethernet/broadcom/bcmcsysport.c, I came across the
>> fatal_signal_pending() check in mm/page_alloc.c which is there.
>>
>> This driver calls dma_alloc_coherent(, GFP_KERNEL) which ends up making
>> a coherent allocation from a CMA region on our platform. Since that
>> allocation is allowed to sleep, and because we are in bcm_syport_open(),
>> executed from process context, a pending signal makes
>> dma_alloc_coherent() return NULL.
> 
> Hello, Florian.
> 
> fatal_signal_pending means that there is SIGKILL on that process.
> I guess that caller of dma_alloc_coherent() will die soon.
> In this case, why CMA should be succeed?

I agree that the CMA allocation should not be allowed to succeed, but
the dma_alloc_coherent() allocation should succeed. If we look at the
sysport driver, there are kmalloc() calls to initialize private
structures, those will succeed (except under high memory pressure), so
by the same token, a driver expects DMA allocations to succeed (unless
we are under high memory pressure)

What are we trying to solve exactly with the fatal_signal_pending()
check here? Are we just optimizing for the case where a process has
allocated from a CMA region to allow this region to be returned to the
pool of free pages when it gets killed? Could there be another mechanism
used to reclaim those pages if we know the process is getting killed anyway?

> 
>>
>> There are two ways I could fix this:
>>
>> - use a GFP_ATOMIC allocation, which would avoid this sensitivity to a
>> pending signal being fatal (we suffer from the same issue in
>> bcm_sysport_resume)
>>
>> - move the DMA coherent allocation before bcm_sysport_open(), in the
>> driver's probe function, but if the network interface is never used, we
>> would be waisting precious DMA coherent memory for nothing (it is only 4
>> bytes times 32 but still
> 
> I guess that it is okay that bcm_sysport_open() return -EINTR?

Well, not really. This driver is not an isolated case, there are tons of
other networking drivers that do exactly the same thing, and we do
expect these dma_alloc_* calls to succeed.

I think we would want to ignore the fatal_signal_pending() check for
allocations coming through the dma_alloc_* API, although I agree this
could be a tough one when they are done from process context.

Updating all drivers to switch to GFP_ATOMIC allocations is not a good
idea, since that would exhaust the atomic DMA coherent pool for no good
reason.

FYI, we are hitting the same problem during suspend/resume, if you are
unlucky enough the suspending process get interrupted, you can get a lot
of crashes from drivers that do not expect their dma_alloc_coherent()
allocation to be sensible to signals.
--
Florian

