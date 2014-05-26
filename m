Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752204AbaEZJ6l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 05:58:41 -0400
Received: from mail-ve0-f169.google.com ([209.85.128.169]:43868 "EHLO
	mail-ve0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914AbaEZJ6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 05:58:39 -0400
MIME-Version: 1.0
In-Reply-To: <1400837055.4921.4.camel@weser.hi.pengutronix.de>
References: <1400492771-9746-1-git-send-email-acourbot@nvidia.com>
 <1400493433.8467.24.camel@weser.hi.pengutronix.de> <5379D7A0.3050509@nvidia.com>
 <1400494582.8467.28.camel@weser.hi.pengutronix.de> <CAAVeFuLKTjaZPSxNSK3nEG+XK+mMmPDDq85qMF-EHp3bGwVJYA@mail.gmail.com>
 <1400837055.4921.4.camel@weser.hi.pengutronix.de>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Mon, 26 May 2014 18:58:18 +0900
Message-ID: <CAAVeFuKHc3mexegZjgvRwdVKMwrzXp1nZLF=-kmMMKMsHya0eg@mail.gmail.com>
Subject: Re: [RFC] drm/nouveau: disable caching for VRAM BOs on ARM
To: Lucas Stach <l.stach@pengutronix.de>
Cc: Alexandre Courbot <acourbot@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 23, 2014 at 6:24 PM, Lucas Stach <l.stach@pengutronix.de> wrote:
>> The best way to solve this issue would be to not use the BAR at all
>> since the memory behind these objects can be directly accessed by the
>> CPU. As such it would better be mapped using ttm_bo_kmap_ttm()
>> instead. But right now this is clearly not how nouveau_bo.c is written
>> and it does not look like this can easily be done. :/
>
> Yeah, it sounds like we want this shortcut for stolen VRAM
> implementations.

Tried playing a bit with nouveau_bo and the following hack allows a
simple Mesa program to run to completion... once (second time leads to
a kernel panic):

diff --git a/drivers/gpu/drm/nouveau/nouveau_bo.c
b/drivers/gpu/drm/nouveau/nouveau_bo.c
index f00ae18003f1..6317d30a8e1d 100644
--- a/drivers/gpu/drm/nouveau/nouveau_bo.c
+++ b/drivers/gpu/drm/nouveau/nouveau_bo.c
@@ -538,7 +538,6 @@ nouveau_bo_init_mem_type(struct ttm_bo_device
*bdev, uint32_t type,
                man->available_caching = TTM_PL_MASK_CACHING;
                man->default_caching = TTM_PL_FLAG_CACHED;
                break;
-       case TTM_PL_VRAM:
                if (nv_device(drm->device)->card_type >= NV_50) {
                        man->func = &nouveau_vram_manager;
                        man->io_reserve_fastpath = false;
@@ -556,6 +555,7 @@ nouveau_bo_init_mem_type(struct ttm_bo_device
*bdev, uint32_t type,
                man->default_caching = TTM_PL_FLAG_WC;
 #endif
                break;
+       case TTM_PL_VRAM:
        case TTM_PL_TT:
                if (nv_device(drm->device)->card_type >= NV_50)
                        man->func = &nouveau_gart_manager;
@@ -1297,6 +1297,7 @@ nouveau_ttm_io_mem_reserve(struct ttm_bo_device
*bdev, struct ttm_mem_reg *mem)
                        break;
                /* fallthrough, tiled memory */
        case TTM_PL_VRAM:
+               break;
                mem->bus.offset = mem->start << PAGE_SHIFT;
                mem->bus.base = nv_device_resource_start(nouveau_dev(dev), 1);
                mem->bus.is_iomem = true;


Of course it won't go very far this way, but I wonder if the principle
is not what we would want to do for UMA devices? Not using the vram
manager at all, and strictly rely on TT placements for BOs. We will
need to add extra handling for things like tiled memory. Does that
look like the right direction?
