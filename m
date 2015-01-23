Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756023AbbAWRDS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 12:03:18 -0500
Received: from mail.skyhub.de ([78.46.96.112]:39478 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752791AbbAWRDN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 12:03:13 -0500
Date: Fri, 23 Jan 2015 18:03:06 +0100
From: Borislav Petkov <bp@alien8.de>
To: Joerg Roedel <joro@8bytes.org>
Cc: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Joerg Roedel <jroedel@suse.de>
Subject: Re: [PATCH 2/3] x86, swiotlb: Try coherent allocations with
 __GFP_NOWARN
Message-ID: <20150123170306.GH22635@pd.tnic>
References: <1420555874-11506-1-git-send-email-joro@8bytes.org>
 <1420555874-11506-3-git-send-email-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1420555874-11506-3-git-send-email-joro@8bytes.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2015 at 03:51:13PM +0100, Joerg Roedel wrote:
> From: Joerg Roedel <jroedel@suse.de>
> 
> When we boot a kdump kernel in high memory, there is by
> default only 72MB of low memory available. The swiotlb code
> takes 64MB of it (by default) so that there are only 8MB
> left to allocate from. On systems with many devices this
> causes page allocator warnings from dma_generic_alloc_coherent():
> 
> systemd-udevd: page allocation failure: order:0, mode:0x280d4
> CPU: 0 PID: 197 Comm: systemd-udevd Tainted: G        W       3.12.28-4-default #1
> Hardware name: HP ProLiant DL980 G7, BIOS P66 07/30/2012
>  ffff8800781335e0 ffffffff8150b1db 00000000000280d4 ffffffff8113af90
>  0000000000000000 0000000000000000 ffff88007efdbb00 0000000100000000
>  0000000000000000 0000000000000000 0000000000000000 0000000000000001
> Call Trace:
>  [<ffffffff8100467d>] dump_trace+0x7d/0x2d0
>  [<ffffffff81004964>] show_stack_log_lvl+0x94/0x170
>  [<ffffffff81005d91>] show_stack+0x21/0x50
>  [<ffffffff8150b1db>] dump_stack+0x41/0x51
>  [<ffffffff8113af90>] warn_alloc_failed+0xf0/0x160
>  [<ffffffff8150763a>] __alloc_pages_slowpath+0x72f/0x796
>  [<ffffffff8113ee7a>] __alloc_pages_nodemask+0x1ea/0x210
>  [<ffffffff81008256>] dma_generic_alloc_coherent+0x96/0x140
>  [<ffffffff8103fccc>] x86_swiotlb_alloc_coherent+0x1c/0x50
>  [<ffffffffa048ae5b>] ttm_dma_pool_alloc_new_pages+0xab/0x320 [ttm]
>  [<ffffffffa048bc6e>] ttm_dma_populate+0x3ce/0x640 [ttm]
>  [<ffffffffa0486>] ttm_tt_bind+0x36/0x60 [ttm]
>  [<ffffffffa0484faf>] ttm_bo_handle_move_mem+0x55f/0x5c0 [ttm]
>  [<ffffffffa0485be5>] ttm_bo_move_buffer+0x105/0x130 [ttm]
>  [<ffffffffa0485cd1>] ttm_bo_validate+0xc1/0x130 [ttm]
>  [<ffffffffa0485f8b>] ttm_bo_init+0x24b/0x400 [ttm]
>  [<ffffffffa054f8bc>] radeon_bo_create+0x16c/0x200 [radeon]
>  [<ffffffffa0563c8e>] radeon_ring_init+0x11e/0x2b0 [radeon]
>  [<ffffffffa056c143>] r100_cp_init+0x123/0x5b0 [radeon]
>  [<ffffffffa056e8e4>] r100_startup+0x194/0x230 [radeon]
>  [<ffffffffa056ece3>] r100_init+0x223/0x410 [radeon]
>  [<ffffffffa053495f>] radeon_device_init+0x6af/0x830 [radeon]
>  [<ffffffffa0536979>] radeon_driver_load_kms+0x89/0x180 [radeon]
>  [<ffffffffa04eeb31>] drm_get_pci_dev+0x121/0x2f0 [drm]
>  [<ffffffff812d3ec9>ocal_pci_probe+0x39/0x60
>  [<ffffffff812d51e9>] pci_device_probe+0xa9/0x120
>  [<ffffffff8139871d>] driver_probe_device+0x9d/0x3d0
>  [<ffffffff81398b1b>] __driver_attach+0x8b/0x90
>  [<ffffffff8139667b>] bus_for_each_dev+0x5b/0x90
>  [<ffffffff81397cd8>] bus_add_driver+0x1f8/0x2c0
>  [<ffffffff8139911b>] driver_register+0x5b/0xe0
>  [<ffffffff810002c2>] do_one_initcall+0xf2/0x1a0
>  [<ffffffff810c8837>] load_module+0x1207/0x1c70
>  [<ffffffff810c93f5>] SYSC_finit_module+0x75/0xa0
>  [<ffffffff81519329>] system_call_fastpath+0x16/0x1b
>  [<00007fac533d2789>] 0x7fac533d2788

Please remove those addresses and offsets and leave only the function
names in the call trace - the rest is useless clutter only as those
addresses don't mean anything on else but this kernel.

> After these warnings the code enters a fall-back path and
> allocated directly from the swiotlb aperture in the end.
> So remove these warnings as this is not a fatal error.
> 
> Signed-off-by: Joerg Roedel <jroedel@suse.de>
> ---
>  arch/x86/kernel/pci-swiotlb.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/arch/x86/kernel/pci-swiotlb.c b/arch/x86/kernel/pci-swiotlb.c
> index 77dd0ad..79b2291 100644
> --- a/arch/x86/kernel/pci-swiotlb.c
> +++ b/arch/x86/kernel/pci-swiotlb.c
> @@ -20,6 +20,14 @@ void *x86_swiotlb_alloc_coherent(struct device *hwdev, size_t size,
>  {
>  	void *vaddr;
>  
> +	/*
> +	 * When booting a kdump kernel in high memory these allocations are very
> +	 * likely to fail, as there are by default only 8MB of low memory to
> +	 * allocate from. So disable the warnings from the allocator when this
> +	 * happens.  SWIOTLB also implements fall-backs for failed allocations.
> +	 */
> +	flags |= __GFP_NOWARN;

Ok, so this practically does all allocations __GFP_NOWARN now. Shouldn't
you be doing this before swiotlb_alloc_coherent() and not before
dma_generic_alloc_coherent()?

>  	vaddr = dma_generic_alloc_coherent(hwdev, size, dma_handle, flags,
>  					   attrs);
>  	if (vaddr)

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
--
