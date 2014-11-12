Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752505AbaKLL3V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 06:29:21 -0500
Received: from mga14.intel.com ([192.55.52.115]:49700 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752235AbaKLL3S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 06:29:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,368,1413270000"; 
   d="scan'208";a="621123434"
Date: Wed, 12 Nov 2014 17:00:11 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: dan.j.williams@intel.com, geunsik.lim@samsung.com, inki.dae@samsung.com,
        chanho61.park@samsung.com, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dma: pl330: Fix bug to allocate resources on ARM 64bit
 SoC
Message-ID: <20141112113010.GL24582@intel.com>
References: <1415790133-4206-1-git-send-email-cw00.choi@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415790133-4206-1-git-send-email-cw00.choi@samsung.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2014 at 08:02:13PM +0900, Chanwoo Choi wrote:
> This patch fix following bug to allocate resources on ARM 64bit SoC.
> The patch[1] adds to check wheter dev is NULL or not.

Fixed already by below in my tree

commit 1d7e691f1b1793f8a9439b2e8eae069e5996a187
Author: Andrew Jackson <Andrew.Jackson@arm.com>
Date:   Thu Nov 6 11:39:47 2014 +0000

    dmaengine: pl330: Correct device assignment.

    Commit f6f2421c0a1c removed pl330_info structure by embedding it into
    pl330_dmac structure, but did not ensure that the dmac->ddma.dev
    pointer gets initialised before use. When dma_alloc_coherent() gets
    called on arm64 a WARN() gets triggered due to dev being NULL.

    ------------[ cut here ]------------
    WARNING: CPU: 1 PID: 1 at arch/arm64/mm/dma-mapping.c:49
__dma_alloc_coherent+0xd0/0xe0()
    Use an actual device structure for DMA allocation
    Modules linked in:
    CPU: 1 PID: 1 Comm: swapper/0 Not tainted 3.17.0+ #5
    Call trace:
    [<ffffffc000087f24>] dump_backtrace+0x0/0x130
    [<ffffffc000088064>] show_stack+0x10/0x1c
    [<ffffffc0004e8af8>] dump_stack+0x74/0xb8
    [<ffffffc0000aa444>] warn_slowpath_common+0x8c/0xb4
    [<ffffffc0000aa4b8>] warn_slowpath_fmt+0x4c/0x58
    [<ffffffc000092580>] __dma_alloc_coherent+0xcc/0xe0
    [<ffffffc000092734>] __dma_alloc_noncoherent+0x64/0x158
    [<ffffffc000312cd8>] pl330_probe+0x650/0x8f0
    [<ffffffc00030e1d4>] amba_probe+0xa0/0xc8
    [<ffffffc000350240>] really_probe+0xc4/0x22c
    [<ffffffc0003504b4>] __driver_attach+0xa0/0xa8
    [<ffffffc00034e5fc>] bus_for_each_dev+0x54/0x98
    [<ffffffc00034fd8c>] driver_attach+0x1c/0x28
    [<ffffffc00034fa08>] bus_add_driver+0x14c/0x204
    [<ffffffc000350b84>] driver_register+0x64/0x130
    [<ffffffc00030dcf8>] amba_driver_register+0x50/0x5c
    [<ffffffc0006a60d0>] pl330_driver_init+0x10/0x1c
    [<ffffffc0000814ac>] do_one_initcall+0x88/0x19c
    [<ffffffc00068dab8>] kernel_init_freeable+0x140/0x1e0
    [<ffffffc0004e5e18>] kernel_init+0x10/0xd4
    ---[ end trace 76f2d47a444e523e ]---
    (NULL device *): dmac_alloc_resources:1821 Can't allocate memory!
    (NULL device *): Unable to create channels for DMAC

    This patch will also ensure that any dev_err messages are printed
    with the appropriate device name.

    Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
    Signed-off-by: Andrew Jackson <Andrew.Jackson@arm.com>
    Signed-off-by: Vinod Koul <vinod.koul@intel.com>

-- 
~Vinod

> 
>  [1] arm64: Warn on NULL device structure for dma APIs)
>  - http://lists.infradead.org/pipermail/linux-arm-kernel/2013-December/218650.html
> 
> [    0.488475] ------------[ cut here ]------------
> [    0.493008] WARNING: CPU: 0 PID: 1 at arch/arm64/mm/dma-mapping.c:95 __dma_alloc_coherent+0x104/0x114()
> [    0.503038] Use an actual device structure for DMA allocation
> [    0.509123] Modules linked in:
> [    0.512093] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.18.0-rc3+ #54
> [    0.518548] Call trace:
> [    0.520949] [<ffffffc000087eb8>] dump_backtrace+0x0/0x124
> [    0.526345] [<ffffffc000087fec>] show_stack+0x10/0x1c
> [    0.531359] [<ffffffc0005101cc>] dump_stack+0x74/0xb8
> [    0.536412] [<ffffffc0000ac698>] warn_slowpath_common+0x8c/0xb4
> [    0.542295] [<ffffffc0000ac70c>] warn_slowpath_fmt+0x4c/0x58
> [    0.547958] [<ffffffc000093860>] __dma_alloc_coherent+0x100/0x114
> [    0.554012] [<ffffffc0000938d8>] __dma_alloc_noncoherent+0x64/0x180
> [    0.560281] [<ffffffc00032c034>] pl330_probe+0x650/0x8f8
> [    0.565574] [<ffffffc000325f10>] amba_probe+0x90/0xe0
> [    0.570595] [<ffffffc00036c1c4>] really_probe+0x7c/0x220
> [    0.575902] [<ffffffc00036c474>] __driver_attach+0xa0/0xa8
> [    0.581355] [<ffffffc00036a5c8>] bus_for_each_dev+0x54/0x98
> [    0.586925] [<ffffffc00036bd58>] driver_attach+0x1c/0x28
> [    0.592205] [<ffffffc00036b9d4>] bus_add_driver+0x14c/0x204
> [    0.597776] [<ffffffc00036cb50>] driver_register+0x64/0x130
> [    0.603315] [<ffffffc000325a38>] amba_driver_register+0x50/0x5c
> [    0.609234] [<ffffffc0006f2de0>] pl330_driver_init+0x10/0x1c
> [    0.614859] [<ffffffc0000814bc>] do_one_initcall+0x88/0x1ac
> [    0.620432] [<ffffffc0006d9acc>] kernel_init_freeable+0x148/0x1e8
> [    0.626508] [<ffffffc00050d41c>] kernel_init+0x10/0xd4
> [    0.632028] ---[ end trace d75c52ba9660e12a ]---
> 
> Cc: Vinod Koul <vinod.koul@intel.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> ---
>  drivers/dma/pl330.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
> index 4839bfa..8c7d4e1 100644
> --- a/drivers/dma/pl330.c
> +++ b/drivers/dma/pl330.c
> @@ -2611,6 +2611,7 @@ pl330_probe(struct amba_device *adev, const struct amba_id *id)
>  	}
>  
>  	pl330->mcbufsz = pdat ? pdat->mcbuf_sz : 0;
> +	pl330->ddma.dev = &adev->dev;
>  
>  	res = &adev->res;
>  	pl330->base = devm_ioremap_resource(&adev->dev, res);
> -- 
> 1.8.5.5
> 

-- 
