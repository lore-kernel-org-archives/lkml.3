Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754833Ab3KUUnj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 15:43:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4111 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753866Ab3KUUng (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 15:43:36 -0500
Message-ID: <1385066603.2879.414.camel@ul30vt.home>
Subject: Re: [PATCH 0/9 v2] vfio-pci: add support for Freescale IOMMU (PAMU)
From: Alex Williamson <alex.williamson@redhat.com>
To: Bharat Bhushan <Bharat.Bhushan@freescale.com>
Cc: "joro@8bytes.org" <joro@8bytes.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "agraf@suse.de" <agraf@suse.de>, Scott Wood <scottwood@freescale.com>,
        Stuart Yoder <stuart.yoder@freescale.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 21 Nov 2013 13:43:23 -0700
In-Reply-To: <6A3DF150A5B70D4F9B66A25E3F7C888D0721D9AC@039-SN2MPN1-012.039d.mgd.msft.net>
References: <1384838233-24847-1-git-send-email-Bharat.Bhushan@freescale.com>
	 <1384973243.2879.361.camel@ul30vt.home>
	 <6A3DF150A5B70D4F9B66A25E3F7C888D0721D9AC@039-SN2MPN1-012.039d.mgd.msft.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-11-21 at 11:20 +0000, Bharat Bhushan wrote:
> 
> > -----Original Message-----
> > From: Alex Williamson [mailto:alex.williamson@redhat.com]
> > Sent: Thursday, November 21, 2013 12:17 AM
> > To: Bhushan Bharat-R65777
> > Cc: joro@8bytes.org; bhelgaas@google.com; agraf@suse.de; Wood Scott-B07421;
> > Yoder Stuart-B08248; iommu@lists.linux-foundation.org; linux-
> > pci@vger.kernel.org; linuxppc-dev@lists.ozlabs.org; linux-
> > kernel@vger.kernel.org; Bhushan Bharat-R65777
> > Subject: Re: [PATCH 0/9 v2] vfio-pci: add support for Freescale IOMMU (PAMU)
> > 
> > On Tue, 2013-11-19 at 10:47 +0530, Bharat Bhushan wrote:
> > > From: Bharat Bhushan <bharat.bhushan@freescale.com>
> > >
> > > PAMU (FSL IOMMU) has a concept of primary window and subwindows.
> > > Primary window corresponds to the complete guest iova address space
> > > (including MSI space), with respect to IOMMU_API this is termed as
> > > geometry. IOVA Base of subwindow is determined from the number of
> > > subwindows (configurable using iommu API).
> > > MSI I/O page must be within the geometry and maximum supported
> > > subwindows, so MSI IO-page is setup just after guest memory iova space.
> > >
> > > So patch 1/9-4/9(inclusive) are for defining the interface to get:
> > >   - Number of MSI regions (which is number of MSI banks for powerpc)
> > >   - MSI-region address range: Physical page which have the
> > >     address/addresses used for generating MSI interrupt
> > >     and size of the page.
> > >
> > > Patch 5/9-7/9(inclusive) is defining the interface of setting up MSI
> > > iova-base for a msi region(bank) for a device. so that when
> > > msi-message will be composed then this configured iova will be used.
> > > Earlier we were using iommu interface for getting the configured iova
> > > which was not currect and Alex Williamson suggeested this type of interface.
> > >
> > > patch 8/9 moves some common functions in a separate file so that these
> > > can be used by FSL_PAMU implementation (next patch uses this).
> > > These will be used later for iommu-none implementation. I believe we
> > > can do more of this but will take step by step.
> > >
> > > Finally last patch actually adds the support for FSL-PAMU :)
> > 
> > Patches 1-3: msi_get_region needs to return an error an error (probably
> > -EINVAL) if called on a path where there's no backend implementation.
> > Otherwise the caller doesn't know that the data in the region pointer isn't
> > valid.
> 
> will correct.
> 
> > 
> > Patches 5&6: same as above for msi_set_iova, return an error if no backend
> > implementation.
> 
> Ok
> 
> > 
> > Patch 7: Why does fsl_msi_del_iova_device bother to return anything if it's
> > always zero?  Return -ENODEV when not found?
> 
> Will make -ENODEV.
> 
> > 
> > Patch 9:
> > 
> > vfio_handle_get_attr() passes random kernel data back to userspace in the event
> > of iommu_domain_get_attr() error.
> 
> Will correct.
> 
> > 
> > vfio_handle_set_attr(): I don't see any data validation happening, is
> > iommu_domain_set_attr() really that safe?
> 
> We do not need any data validation here and iommu driver does whatever needed.
> So yes,  iommu_domain_set_attr() is safe.
> 
> > 
> > For both of those, drop the pr_err on unknown attribute, it's sufficient to
> > return error.
> 
> ok
> 
> > 
> > Is VFIO_IOMMU_PAMU_GET_MSI_BANK_COUNT per aperture (ie. each vfio user has
> > $COUNT regions at their disposal exclusively)?
> 
> Number of msi-bank count is system wide and not per aperture, But will be setting windows for banks in the device aperture.
> So say if we are direct assigning 2 pci device (both have different iommu group, so 2 aperture in iommu) to VM.
> Now qemu can make only one call to know how many msi-banks are there but it must set sub-windows for all banks for both pci device in its respective aperture.

I'm still confused.  What I want to make sure of is that the banks are
independent per aperture.  For instance, if we have two separate
userspace processes operating independently and they both chose to use
msi bank zero for their device, that's bank zero within each aperture
and doesn't interfere.  Or another way to ask is can a malicious user
interfere with other users by using the wrong bank.  Thanks,

Alex

