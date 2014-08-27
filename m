Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935957AbaH0WLF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 18:11:05 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:38206 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932246AbaH0WLD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 18:11:03 -0400
MIME-Version: 1.0
In-Reply-To: <20140827190125.29558.80166.stgit@gimli.home>
References: <20140827190125.29558.80166.stgit@gimli.home>
Date: Wed, 27 Aug 2014 18:11:01 -0400
Message-ID: <CADnq5_MaPBTm-PtCq57KLJqZuxw4qTuZgyzHGqhfQoY95YxYsQ@mail.gmail.com>
Subject: Re: [PATCH] radeon: Test for PCI root bus before assuming bus->self
From: Alex Deucher <alexdeucher@gmail.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: "Deucher, Alexander" <alexander.deucher@amd.com>,
        Christian Koenig <christian.koenig@amd.com>,
        Maling list - DRI developers 
	<dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2014 at 3:01 PM, Alex Williamson
<alex.williamson@redhat.com> wrote:
> If we assign a Radeon device to a virtual machine, we can no longer
> assume a fixed hardware topology, like the GPU having a parent device.
> This patch simply adds a few pci_is_root_bus() tests to avoid passing
> a NULL pointer to PCI access functions, allowing the radeon driver to
> work in a QEMU 440FX machine with an assigned HD8570 on the emulated
> PCI root bus.
>
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>

Added to my -fixes queue.  thanks!

Alex


> ---
>
>  drivers/gpu/drm/radeon/cik.c |    6 +++++-
>  drivers/gpu/drm/radeon/si.c  |    6 +++++-
>  2 files changed, 10 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/gpu/drm/radeon/cik.c b/drivers/gpu/drm/radeon/cik.c
> index 79a5a55..cc34308 100644
> --- a/drivers/gpu/drm/radeon/cik.c
> +++ b/drivers/gpu/drm/radeon/cik.c
> @@ -9555,6 +9555,9 @@ static void cik_pcie_gen3_enable(struct radeon_device *rdev)
>         int ret, i;
>         u16 tmp16;
>
> +       if (pci_is_root_bus(rdev->pdev->bus))
> +               return;
> +
>         if (radeon_pcie_gen2 == 0)
>                 return;
>
> @@ -9781,7 +9784,8 @@ static void cik_program_aspm(struct radeon_device *rdev)
>                         if (orig != data)
>                                 WREG32_PCIE_PORT(PCIE_LC_LINK_WIDTH_CNTL, data);
>
> -                       if (!disable_clkreq) {
> +                       if (!disable_clkreq &&
> +                           !pci_is_root_bus(rdev->pdev->bus)) {
>                                 struct pci_dev *root = rdev->pdev->bus->self;
>                                 u32 lnkcap;
>
> diff --git a/drivers/gpu/drm/radeon/si.c b/drivers/gpu/drm/radeon/si.c
> index a1274a3..ffb1d4e 100644
> --- a/drivers/gpu/drm/radeon/si.c
> +++ b/drivers/gpu/drm/radeon/si.c
> @@ -7177,6 +7177,9 @@ static void si_pcie_gen3_enable(struct radeon_device *rdev)
>         int ret, i;
>         u16 tmp16;
>
> +       if (pci_is_root_bus(rdev->pdev->bus))
> +               return;
> +
>         if (radeon_pcie_gen2 == 0)
>                 return;
>
> @@ -7454,7 +7457,8 @@ static void si_program_aspm(struct radeon_device *rdev)
>                         if (orig != data)
>                                 WREG32_PIF_PHY1(PB1_PIF_CNTL, data);
>
> -                       if (!disable_clkreq) {
> +                       if (!disable_clkreq &&
> +                           !pci_is_root_bus(rdev->pdev->bus)) {
>                                 struct pci_dev *root = rdev->pdev->bus->self;
>                                 u32 lnkcap;
>
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
