Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933667Ab3FRSYX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 14:24:23 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:50348 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932189Ab3FRSYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 14:24:21 -0400
MIME-Version: 1.0
In-Reply-To: <51C099D2.3090506@zytor.com>
References: <1371154622-8929-1-git-send-email-yinghai@kernel.org>
	<51C08B01.40200@zytor.com>
	<CAE9FiQXM=mgvUqLh_Uj9NA8fMOSt+zCz-ev-ujnVkhHm8fQW_g@mail.gmail.com>
	<51C099D2.3090506@zytor.com>
Date: Tue, 18 Jun 2013 11:24:20 -0700
X-Google-Sender-Auth: bTkbLJlT2AbXU0cGcggbPHn85SY
Message-ID: <CAE9FiQWFgzF4fxULiNz5tqB8YEDCJ8TdPtUFpWKnR1wuwNQXgA@mail.gmail.com>
Subject: Re: [PATCH v3 0/2] x86, mtrr: fixs for mtrr_cleanup
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Joshua Covington <joshuacov@googlemail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 18, 2013 at 10:33 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 06/18/2013 12:28 PM, Yinghai Lu wrote:
>> On Tue, Jun 18, 2013 at 9:29 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>>>
>>> On this subject: what do we need to happen to be able to dump the MTRR
>>> cleanup stuff?
>>
>> the old x server like to add Write-combining entry in MTRR.
>> looks like drm for mga200 is adding that too ?
>>
>
> "Old X server" here has been a long time now.  I need to dig into the
> MGA200 I guess...
>
>> We need to make them to use PAT instead.

looks that we have more mtrr_add calling:

drivers/gpu/drm/ast/ast_ttm.c:  ast->fb_mtrr =
drm_mtrr_add(pci_resource_start(dev->pdev, 0),
drivers/gpu/drm/cirrus/cirrus_ttm.c:    cirrus->fb_mtrr =
drm_mtrr_add(pci_resource_start(dev->pdev, 0),
drivers/gpu/drm/drm_bufs.c:                             map->mtrr =
mtrr_add(map->offset, map->size,
drivers/gpu/drm/drm_pci.c:
mtrr_add(dev->agp->agp_info.aper_base,
drivers/gpu/drm/i915/i915_dma.c:        dev_priv->mm.gtt_mtrr =
mtrr_add(base, size, MTRR_TYPE_WRCOMB, 1);
drivers/gpu/drm/mgag200/mgag200_ttm.c:  mdev->fb_mtrr =
drm_mtrr_add(pci_resource_start(dev->pdev, 0),
drivers/gpu/drm/nouveau/nouveau_ttm.c:  drm->ttm.mtrr =
drm_mtrr_add(pci_resource_start(dev->pdev, 1),
drivers/gpu/drm/radeon/radeon_object.c:         rdev->mc.vram_mtrr =
mtrr_add(rdev->mc.aper_base, rdev->mc.aper_size,
drivers/gpu/drm/savage/savage_bci.c:
drm_mtrr_add(dev_priv->mtrr[0].base,
drivers/gpu/drm/savage/savage_bci.c:
drm_mtrr_add(dev_priv->mtrr[1].base,
drivers/gpu/drm/savage/savage_bci.c:
drm_mtrr_add(dev_priv->mtrr[2].base,
drivers/gpu/drm/savage/savage_bci.c:
drm_mtrr_add(dev_priv->mtrr[0].base,
drivers/gpu/drm/vmwgfx/vmwgfx_drv.c:    dev_priv->mmio_mtrr =
drm_mtrr_add(dev_priv->mmio_start,
drivers/infiniband/hw/ipath/ipath_wc_x86_64.c:          cookie =
mtrr_add(pioaddr, piolen, MTRR_TYPE_WRCOMB, 0);
drivers/infiniband/hw/ipath/ipath_wc_x86_64.c:
          "mtrr_add()  WC for PIO bufs "
drivers/infiniband/hw/qib/qib_wc_x86_64.c:              cookie =
mtrr_add(pioaddr, piolen, MTRR_TYPE_WRCOMB, 0);
drivers/infiniband/hw/qib/qib_wc_x86_64.c:
          "mtrr_add()  WC for PIO bufs failed (%d)\n",
drivers/media/pci/ivtv/ivtvfb.c:                if
(mtrr_add(oi->fb_start_aligned_physaddr,
drivers/message/fusion/mptbase.c:               ioc->mtrr_reg =
mtrr_add(ioc->req_frames_dma,
drivers/net/ethernet/myricom/myri10ge/myri10ge.c:       mgp->mtrr =
mtrr_add(mgp->iomem_base, mgp->board_span,

will be in drm:

drivers/staging/xgifb/XGI_main_26.c:    xgifb_info->mtrr =
mtrr_add(xgifb_info->video_base,

video:

drivers/video/arkfb.c:          par->mtrr_reg =
mtrr_add(info->fix.smem_start, info->fix.smem_len, MTRR_TYPE_WRCOMB,
1);
drivers/video/aty/aty128fb.c:           par->mtrr.vram =
mtrr_add(info->fix.smem_start,
drivers/video/aty/atyfb_base.c:         par->mtrr_aper =
mtrr_add(par->res_start, par->res_size,
drivers/video/aty/atyfb_base.c:                 par->mtrr_reg =
mtrr_add(par->res_start + 0x800000 -
drivers/video/aty/radeon_base.c:        rinfo->mtrr_hdl = nomtrr ? -1
: mtrr_add(rinfo->fb_base_phys,
drivers/video/gbefb.c:  mtrr_add(gbe_mem_phys, gbe_mem_size,
MTRR_TYPE_WRCOMB, 1);
drivers/video/i740fb.c:         par->mtrr_reg = mtrr_add(info->fix.smem_start,
drivers/video/i810/i810_main.h: par->mtrr_reg = mtrr_add((u32)
par->aperture.physical,
drivers/video/intelfb/intelfbdrv.c:     dinfo->mtrr_reg =
mtrr_add(dinfo->aperture.physical,
drivers/video/kyro/fbdev.c:                     mtrr_add(kyro_fix.smem_start,
drivers/video/matrox/matroxfb_base.c:           minfo->mtrr.vram =
mtrr_add(video_base_phys, minfo->video.len, MTRR_TYPE_WRCOMB, 1);
drivers/video/neofb.c:          mtrr_add(info->fix.smem_start,
pci_resource_len(dev, 0),
drivers/video/nvidia/nvidia.c:          par->mtrr.vram =
mtrr_add(nvidiafb_fix.smem_start,
drivers/video/pm2fb.c:                  mtrr_add(pm2fb_fix.smem_start,
drivers/video/pm3fb.c:          par->mtrr_handle =
mtrr_add(pm3fb_fix.smem_start,
drivers/video/riva/fbdev.c:             default_par->mtrr.vram =
mtrr_add(rivafb_fix.smem_start,
drivers/video/s3fb.c:           par->mtrr_reg =
mtrr_add(info->fix.smem_start, info->fix.smem_len, MTRR_TYPE_WRCOMB,
1);
drivers/video/savage/savagefb_driver.c: par->video.mtrr =
mtrr_add(par->video.pbase, video_len,
drivers/video/sgivwfb.c:        mtrr_add(sgivwfb_mem_phys,
sgivwfb_mem_size, MTRR_TYPE_WRCOMB, 1);
drivers/video/sis/sis_main.c:           ivideo->mtrr =
mtrr_add(ivideo->video_base, ivideo->video_size,
drivers/video/tdfxfb.c:static inline int mtrr_add(unsigned long base,
unsigned long size,
drivers/video/tdfxfb.c:                 mtrr_add(info->fix.smem_start,
info->fix.smem_len,
drivers/video/uvesafb.c:                                rc =
mtrr_add(info->fix.smem_start,
drivers/video/vesafb.c:                         rc =
mtrr_add(vesafb_fix.smem_start, temp_size,
drivers/video/vt8623fb.c:               par->mtrr_reg =
mtrr_add(info->fix.smem_start, info->fix.smem_len, MTRR_TYPE_WRCOMB,
1);
