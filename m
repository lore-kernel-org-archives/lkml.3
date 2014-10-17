Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753296AbaJQDIq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 23:08:46 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:35959 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643AbaJQDIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 23:08:44 -0400
MIME-Version: 1.0
In-Reply-To: <20141016171012.GE5252@e104818-lin.cambridge.arm.com>
References: <CAGZxSSSBpCvJt=PFbihTmPneJqiocU8VZSDHpXgkf5dhWZ850Q@mail.gmail.com>
	<20141016171012.GE5252@e104818-lin.cambridge.arm.com>
Date: Fri, 17 Oct 2014 11:08:43 +0800
Message-ID: <CAGZxSSSZ+b28rcHYRi5EWV9K4izHZBkO3fJTdang5XTaNMRTrw@mail.gmail.com>
Subject: Re: [PATCH v2] arm64: mm: use macro instead of if judgement of ZONE_DMA
From: Yifan Zhang <yifan.zhangm@gmail.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <Will.Deacon@arm.com>, Mark Rutland <Mark.Rutland@arm.com>,
        "lauraa@codeaurora.org" <lauraa@codeaurora.org>,
        "ganapatrao.kulkarni@caviumnetworks.com" 
	<ganapatrao.kulkarni@caviumnetworks.com>,
        "robh@kernel.org" <robh@kernel.org>,
        "leif.lindholm@linaro.org" <leif.lindholm@linaro.org>,
        "Yalin.Wang@sonymobile.com" <Yalin.Wang@sonymobile.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yifan Zhang <zhangyf@marvell.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Catalin,

I found In current arm64 code, there is no normal zone, only DMA zone.

Number of blocks type     Unmovable  Reclaimable      Movable
Reserve          CMA      Isolate

Node 0, zone    DMA          142           12           69
1           28            0


When zone_sizes_init, zone_size[ZONE_NORMAL] is initialized to 0. (it
is 3.10, I didn't try the latest code base)

static void __init zone_sizes_init(unsigned long min, unsigned long max)
{
    struct memblock_region *reg;
    unsigned long zone_size[MAX_NR_ZONES], zhole_size[MAX_NR_ZONES];
    unsigned long max_dma = min;

    memset(zone_size, 0, sizeof(zone_size));

#ifdef CONFIG_ZONE_DMA
    /* 4GB maximum for 32-bit only capable devices */
    unsigned long max_dma_phys =
        (unsigned long)(dma_to_phys(NULL, DMA_BIT_MASK(32)) + 1);
    max_dma = max(min, min(max, max_dma_phys >> PAGE_SHIFT));
    zone_size[ZONE_DMA] = max_dma - min;
#endif
    zone_size[ZONE_NORMAL] = max - max_dma;


Then I just tried to enable ZONE_NORMAL in our platform, and found
this compiling error.

Is this ZONE_DMA cover full memory and ZONE_NORMAL = 0 strategy on
purpose ? We will not use ZONE_NORMAL on arm64 ?



On Fri, Oct 17, 2014 at 1:10 AM, Catalin Marinas
<catalin.marinas@arm.com> wrote:
> On Thu, Oct 16, 2014 at 10:41:01AM +0100, Yifan Zhang wrote:
>> if disable CONFIG_ZONE_DMA, ZONE_DMA becomes undefined.
>
> I agree that this is the case but can you explain why you need to
> disable ZONE_DMA? It currently is def_bool y, so it cannot be disabled
> unless you hack the Kconfig.
>
> --
> Catalin
