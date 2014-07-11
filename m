Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753252AbaGKHiH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 03:38:07 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:62414 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751508AbaGKHiC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 03:38:02 -0400
Date: Fri, 11 Jul 2014 09:38:07 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Daniel Vetter <daniel@ffwll.ch>, Ben Skeggs <bskeggs@redhat.com>,
        David Airlie <airlied@linux.ie>,
        David Herrmann <dh.herrmann@gmail.com>, Lucas Stach <dev@lynxeye.de>,
        Thierry Reding <thierry.reding@gmail.com>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        nouveau@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-tegra@vger.kernel.org,
        Alexandre Courbot <gnurou@gmail.com>
Subject: Re: [Nouveau] [PATCH v4 2/6] drm/nouveau: map pages using DMA API on
 platform devices
Message-ID: <20140711073807.GV17271@phenom.ffwll.local>
Mail-Followup-To: Alexandre Courbot <acourbot@nvidia.com>,
	Ben Skeggs <bskeggs@redhat.com>, David Airlie <airlied@linux.ie>,
	David Herrmann <dh.herrmann@gmail.com>,
	Lucas Stach <dev@lynxeye.de>,
	Thierry Reding <thierry.reding@gmail.com>,
	Maarten Lankhorst <maarten.lankhorst@canonical.com>,
	nouveau@lists.freedesktop.org, linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org, linux-tegra@vger.kernel.org,
	Alexandre Courbot <gnurou@gmail.com>
References: <1404807961-30530-1-git-send-email-acourbot@nvidia.com>
 <1404807961-30530-3-git-send-email-acourbot@nvidia.com>
 <20140710125849.GF17271@phenom.ffwll.local>
 <53BF4D6B.70904@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53BF4D6B.70904@nvidia.com>
X-Operating-System: Linux phenom 3.15.0-rc3+ 
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2014 at 11:35:23AM +0900, Alexandre Courbot wrote:
> On 07/10/2014 09:58 PM, Daniel Vetter wrote:
> >On Tue, Jul 08, 2014 at 05:25:57PM +0900, Alexandre Courbot wrote:
> >>page_to_phys() is not the correct way to obtain the DMA address of a
> >>buffer on a non-PCI system. Use the DMA API functions for this, which
> >>are portable and will allow us to use other DMA API functions for
> >>buffer synchronization.
> >>
> >>Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
> >>---
> >>  drivers/gpu/drm/nouveau/core/engine/device/base.c | 8 +++++++-
> >>  1 file changed, 7 insertions(+), 1 deletion(-)
> >>
> >>diff --git a/drivers/gpu/drm/nouveau/core/engine/device/base.c b/drivers/gpu/drm/nouveau/core/engine/device/base.c
> >>index 18c8c7245b73..e4e9e64988fe 100644
> >>--- a/drivers/gpu/drm/nouveau/core/engine/device/base.c
> >>+++ b/drivers/gpu/drm/nouveau/core/engine/device/base.c
> >>@@ -489,7 +489,10 @@ nv_device_map_page(struct nouveau_device *device, struct page *page)
> >>  		if (pci_dma_mapping_error(device->pdev, ret))
> >>  			ret = 0;
> >>  	} else {
> >>-		ret = page_to_phys(page);
> >>+		ret = dma_map_page(&device->platformdev->dev, page, 0,
> >>+				   PAGE_SIZE, DMA_BIDIRECTIONAL);
> >>+		if (dma_mapping_error(&device->platformdev->dev, ret))
> >>+			ret = 0;
> >>  	}
> >>
> >>  	return ret;
> >>@@ -501,6 +504,9 @@ nv_device_unmap_page(struct nouveau_device *device, dma_addr_t addr)
> >>  	if (nv_device_is_pci(device))
> >>  		pci_unmap_page(device->pdev, addr, PAGE_SIZE,
> >>  			       PCI_DMA_BIDIRECTIONAL);
> >
> >pci_map/unmap alias to dma_unmap/map when called on the underlying struct
> >device embedded in pci_device (like for platform drivers). Dunno whether
> >it's worth to track a pointer to the struct device directly and always
> >call dma_unmap/map.
> 
> Isn't it (theoretically) possible to have a platform that does not use the
> DMA API for its PCI implementation and thus requires the pci_* functions to
> be called? I could not find such a case in -next, which suggests that all
> PCI platforms have been converted to the DMA API already and that we could
> indeed refactor this to always use the DMA functions.
> 
> But at the same time the way we use APIs should not be directed by their
> implementation, but by their intent - and unless the PCI API has been
> deprecated in some way (something I am not aware of), the rule is still that
> you should use it on a PCI device.

Hm, somehow I've thought that it's recommended to just use the dma api
directly. It's what we're doing in i915 at least, but now I'm not so sure
any more. My guess is that this is just history really when the dma api
was pci-only.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
