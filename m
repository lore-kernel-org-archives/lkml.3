Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754739Ab3KTSrl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 13:47:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18326 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754444Ab3KTSrj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 13:47:39 -0500
Message-ID: <1384973243.2879.361.camel@ul30vt.home>
Subject: Re: [PATCH 0/9 v2] vfio-pci: add support for Freescale IOMMU (PAMU)
From: Alex Williamson <alex.williamson@redhat.com>
To: Bharat Bhushan <r65777@freescale.com>
Cc: joro@8bytes.org, bhelgaas@google.com, agraf@suse.de,
        scottwood@freescale.com, stuart.yoder@freescale.com,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Bharat Bhushan <bharat.bhushan@freescale.com>
Date: Wed, 20 Nov 2013 11:47:23 -0700
In-Reply-To: <1384838233-24847-1-git-send-email-Bharat.Bhushan@freescale.com>
References: <1384838233-24847-1-git-send-email-Bharat.Bhushan@freescale.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-11-19 at 10:47 +0530, Bharat Bhushan wrote:
> From: Bharat Bhushan <bharat.bhushan@freescale.com>
> 
> PAMU (FSL IOMMU) has a concept of primary window and subwindows.
> Primary window corresponds to the complete guest iova address space
> (including MSI space), with respect to IOMMU_API this is termed as
> geometry. IOVA Base of subwindow is determined from the number of
> subwindows (configurable using iommu API).
> MSI I/O page must be within the geometry and maximum supported
> subwindows, so MSI IO-page is setup just after guest memory iova space.
> 
> So patch 1/9-4/9(inclusive) are for defining the interface to get:
>   - Number of MSI regions (which is number of MSI banks for powerpc)
>   - MSI-region address range: Physical page which have the
>     address/addresses used for generating MSI interrupt
>     and size of the page.
> 
> Patch 5/9-7/9(inclusive) is defining the interface of setting up
> MSI iova-base for a msi region(bank) for a device. so that when
> msi-message will be composed then this configured iova will be used.
> Earlier we were using iommu interface for getting the configured iova
> which was not currect and Alex Williamson suggeested this type of interface.
> 
> patch 8/9 moves some common functions in a separate file so that these
> can be used by FSL_PAMU implementation (next patch uses this).
> These will be used later for iommu-none implementation. I believe we
> can do more of this but will take step by step.
> 
> Finally last patch actually adds the support for FSL-PAMU :)

Patches 1-3: msi_get_region needs to return an error an error (probably
-EINVAL) if called on a path where there's no backend implementation.
Otherwise the caller doesn't know that the data in the region pointer
isn't valid.

Patches 5&6: same as above for msi_set_iova, return an error if no
backend implementation.

Patch 7: Why does fsl_msi_del_iova_device bother to return anything if
it's always zero?  Return -ENODEV when not found?

Patch 9:

vfio_handle_get_attr() passes random kernel data back to userspace in
the event of iommu_domain_get_attr() error.

vfio_handle_set_attr(): I don't see any data validation happening, is
iommu_domain_set_attr() really that safe?

For both of those, drop the pr_err on unknown attribute, it's sufficient
to return error.

Is VFIO_IOMMU_PAMU_GET_MSI_BANK_COUNT per aperture (ie. each vfio user
has $COUNT regions at their disposal exclusively)?  Thanks,

Alex

> v1->v2
>  - Added interface for setting msi iova for a msi region for a device.
>    Earlier I added iommu interface for same but as per comment that is
>    removed and now created a direct interface between vfio and msi.
>  - Incorporated review comments (details is in individual patch)
> 
> Bharat Bhushan (9):
>   pci:msi: add weak function for returning msi region info
>   pci: msi: expose msi region information functions
>   powerpc: pci: Add arch specific msi region interface
>   powerpc: msi: Extend the msi region interface to get info from
>     fsl_msi
>   pci/msi: interface to set an iova for a msi region
>   powerpc: pci: Extend msi iova page setup to arch specific
>   pci: msi: Extend msi iova setting interface to powerpc arch
>   vfio: moving some functions in common file
>   vfio pci: Add vfio iommu implementation for FSL_PAMU
> 
>  arch/powerpc/include/asm/machdep.h |   10 +
>  arch/powerpc/kernel/msi.c          |   28 +
>  arch/powerpc/sysdev/fsl_msi.c      |  132 +++++-
>  arch/powerpc/sysdev/fsl_msi.h      |   25 +-
>  drivers/pci/msi.c                  |   35 ++
>  drivers/vfio/Kconfig               |    6 +
>  drivers/vfio/Makefile              |    5 +-
>  drivers/vfio/vfio_iommu_common.c   |  227 ++++++++
>  drivers/vfio/vfio_iommu_common.h   |   27 +
>  drivers/vfio/vfio_iommu_fsl_pamu.c | 1003 ++++++++++++++++++++++++++++++++++++
>  drivers/vfio/vfio_iommu_type1.c    |  206 +--------
>  include/linux/msi.h                |   14 +
>  include/linux/pci.h                |   21 +
>  include/uapi/linux/vfio.h          |  100 ++++
>  14 files changed, 1623 insertions(+), 216 deletions(-)
>  create mode 100644 drivers/vfio/vfio_iommu_common.c
>  create mode 100644 drivers/vfio/vfio_iommu_common.h
>  create mode 100644 drivers/vfio/vfio_iommu_fsl_pamu.c
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



