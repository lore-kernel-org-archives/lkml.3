Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756677AbaJXNPJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 09:15:09 -0400
Received: from mail-yh0-f53.google.com ([209.85.213.53]:36392 "EHLO
	mail-yh0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756650AbaJXNPD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 09:15:03 -0400
MIME-Version: 1.0
In-Reply-To: <5448B930.7070800@samsung.com>
References: <1413734340-53108-1-git-send-email-stefan.hengelein@fau.de>
	<5444BCFF.8030803@samsung.com>
	<CABv5NL_GdtZegpw8wxau9oD6xXWdX3GUySLqCaoaoa549Kg_GQ@mail.gmail.com>
	<5445A345.7010401@codeaurora.org>
	<5448B930.7070800@samsung.com>
Date: Fri, 24 Oct 2014 15:15:02 +0200
X-Google-Sender-Auth: iu7kHMkyWI7uI_0vyBoLYyQ401E
Message-ID: <CABv5NL_E83CgBcHbAqo9xejWAEamO3oxX6ZjU+fo9X6k4cE_1w@mail.gmail.com>
Subject: Re: [PATCH] arm: dma-mapping: fix compilation error when CONFIG_MMU
 is not present
From: Stefan Hengelein <stefan.hengelein@fau.de>
To: Marek Szyprowski <m.szyprowski@samsung.com>,
        Laura Abbott <lauraa@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux@arm.linux.org.uk,
        akpm@linux-foundation.org, linux-arm-kernel@lists.infradead.org,
        Valentin Rothberg <valentinrothberg@gmail.com>,
        iommu@lists.linux-foundation.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

adding a dependency to CONFIG_ARM_DMA_USE_IOMMU is probably not a good
idea anyways.
If you read the Documentation/kbuild/kconfig-language.txt, you will see that:
1. in general, selected options should have no prompt and no dependencies
2. giving ARM_DMA_USE_IOMMU a dependency on MMU will and cannot solve
the problem, since ARM_DMA_USE_IOMMU itself is selected by several
sources and select will not enforce dependencies to be resolved (to be
precise, it will simply ignore them). Thus, CONFIG_MMU will not be
enabled (as you can see in your warning).
If you want to ensure CONFIG_MMU is enabled when
CONFIG_ARM_DMA_USE_IOMMU is selected, the selecting options (e.g.
SHMOBILE_IOMMU) should have a dependency on MMU.
However, i'm not sure if that's the right way to solve it, since it
will hide these options when MMU is not enabled.

Making the whole IOMMU subsystem depend on MMU would probably also
solve the problem. Is there any situation where it would make sense to
use an IOMMU without an MMU?

Best Regards,
Stefan Hengelein

2014-10-23 10:15 GMT+02:00 Marek Szyprowski <m.szyprowski@samsung.com>:
> Hello,
>
>
> On 2014-10-21 02:05, Laura Abbott wrote:
>>
>> On 10/20/2014 6:50 AM, Stefan Hengelein wrote:
>>>
>>> Well,
>>>
>>> arch/arm/mm/dma-mapping.c: In function ‘__atomic_get_pages’:
>>> arch/arm/mm/dma-mapping.c:1265:31: error: ‘atomic_pool’ undeclared
>>> (first use in this function)
>>>
>>> arch/arm/mm/dma-mapping.c: In function ‘__iommu_get_pages’:
>>> arch/arm/mm/dma-mapping.c:1275:2: error: implicit declaration of
>>> function ‘__in_atomic_pool’ [-Werror=implicit-function-declaration]
>>>
>>>
>>> others:
>>> arch/arm/mm/dma-mapping.c: In function ‘__iommu_alloc_remap’:
>>> arch/arm/mm/dma-mapping.c:1200:4: error: ‘VM_ARM_DMA_CONSISTENT’
>>> undeclared (first use in this function)
>>> arch/arm/mm/dma-mapping.c:1200:4: note: each undeclared identifier is
>>> reported only once for each function it appears in
>>>
>>> arch/arm/mm/dma-mapping.c: In function ‘__iommu_get_pages’:
>>> arch/arm/mm/dma-mapping.c:1282:29: error: ‘VM_ARM_DMA_CONSISTENT’
>>> undeclared (first use in this function)
>>> arch/arm/mm/dma-mapping.c: In function ‘arm_iommu_free_attrs’:
>>> arch/arm/mm/dma-mapping.c:1411:4: error: ‘VM_ARM_DMA_CONSISTENT’
>>> undeclared (first use in this function)
>>>
>>>
>>> i've attached a configuration where it happens.
>>> when you place the configuration in your tree and compile the file,
>>> the errors should show up.
>>>
>>> However, within the configuration CONFIG_ARM_DMA_USE_IOMMU is defined
>>> and CONFIG_MMU is not. AFAIUI, if both should be enabled together, it
>>> should be mapped in Kconfig somewhere, right?
>>
>>
>> There isn't a nice way to fixup the dma consistent flags so I would
>> say this option should just depend on MMU.
>
>
> The question is which option should depend on MMU? Making
> CONFIG_ARM_DMA_USE_IOMMU
> to depend on MMU doesn't solve this case. It only gives following warning
> with the
> mentioned .config:
> warning: (VIDEO_OMAP3 && EXYNOS_IOMMU && SHMOBILE_IOMMU && IPMMU_VMSA &&
> ARM_SMMU) selects ARM_DMA_USE_IOMMU which has unmet direct dependencies
> (MMU)
>
> IMHO the best solution will be to either make the whole IOMMU subsystem to
> depend
> on MMU or alternatively, add this dependency to all IOMMU drivers which can
> be
> enabled by COMPILE_TEST option (here the issue is caused by SHMOBILE_IOMMU,
> which
> otherwise cannot be enabled when no-mmu systems are selected).
>
>
> Best regards
> --
> Marek Szyprowski, PhD
> Samsung R&D Institute Poland
>
