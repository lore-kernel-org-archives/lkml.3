Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935710AbaH0TCN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 15:02:13 -0400
Received: from mail-qg0-f47.google.com ([209.85.192.47]:52117 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753594AbaH0TBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 15:01:43 -0400
MIME-Version: 1.0
In-Reply-To: <20140827185651.29388.16082.stgit@gimli.home>
References: <20140827185651.29388.16082.stgit@gimli.home>
Date: Wed, 27 Aug 2014 15:01:42 -0400
Message-ID: <CADnq5_N-2R49jeftB3_+pKeQ_51WE9RW3iZ6=q-q62Lc6eMOJg@mail.gmail.com>
Subject: Re: [PATCH] drm: Test for PCI root bus to avoid NULL pointer dereference
From: Alex Deucher <alexdeucher@gmail.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Dave Airlie <airlied@linux.ie>,
        Maling list - DRI developers 
	<dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2014 at 2:57 PM, Alex Williamson
<alex.williamson@redhat.com> wrote:
> If we have a GPU on the PCI root bus that calls
> drm_pcie_get_speed_cap_mask() we end up with a NULL pointer
> dereference since pdev->bus->self is NULL.  We already protect
> against callers passing non-PCI devices, so let's also catch this
> case and return -EINVAL.
>
> Root complex graphics are not terribly likely outside of IGD, but
> when we assign a standard plugin GPU to a virtual machine, our
> assumption that we have a parent device quickly becomes invalid.
>
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>

Reviewed-by: Alex Deucher <alexander.deucher@amd.com>

> ---
>
>  drivers/gpu/drm/drm_pci.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/gpu/drm/drm_pci.c b/drivers/gpu/drm/drm_pci.c
> index 020cfd9..411e806 100644
> --- a/drivers/gpu/drm/drm_pci.c
> +++ b/drivers/gpu/drm/drm_pci.c
> @@ -390,7 +390,7 @@ int drm_pcie_get_speed_cap_mask(struct drm_device *dev, u32 *mask)
>         u32 lnkcap, lnkcap2;
>
>         *mask = 0;
> -       if (!dev->pdev)
> +       if (!dev->pdev || pci_is_root_bus(dev->pdev->bus))
>                 return -EINVAL;
>
>         root = dev->pdev->bus->self;
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
