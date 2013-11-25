Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757026Ab3KYQiZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 11:38:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44734 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754507Ab3KYQiX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 11:38:23 -0500
Message-ID: <1385397493.2879.557.camel@ul30vt.home>
Subject: Re: [PATCH 0/9 v2] vfio-pci: add support for Freescale IOMMU (PAMU)
From: Alex Williamson <alex.williamson@redhat.com>
To: Bharat Bhushan <Bharat.Bhushan@freescale.com>
Cc: Scott Wood <scottwood@freescale.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "agraf@suse.de" <agraf@suse.de>,
        Stuart Yoder <stuart.yoder@freescale.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 25 Nov 2013 09:38:13 -0700
In-Reply-To: <6A3DF150A5B70D4F9B66A25E3F7C888D0722C180@039-SN2MPN1-012.039d.mgd.msft.net>
References: <1384838233-24847-1-git-send-email-Bharat.Bhushan@freescale.com>
	 <1384973243.2879.361.camel@ul30vt.home>
	 <6A3DF150A5B70D4F9B66A25E3F7C888D0721D9AC@039-SN2MPN1-012.039d.mgd.msft.net>
	 <1385066603.2879.414.camel@ul30vt.home>
	 <1385066835.1403.489.camel@snotra.buserror.net>
	 <1385067648.2879.421.camel@ul30vt.home>
	 <6A3DF150A5B70D4F9B66A25E3F7C888D0722C180@039-SN2MPN1-012.039d.mgd.msft.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-11-25 at 05:33 +0000, Bharat Bhushan wrote:
> 
> > -----Original Message-----
> > From: Alex Williamson [mailto:alex.williamson@redhat.com]
> > Sent: Friday, November 22, 2013 2:31 AM
> > To: Wood Scott-B07421
> > Cc: Bhushan Bharat-R65777; linux-pci@vger.kernel.org; agraf@suse.de; Yoder
> > Stuart-B08248; iommu@lists.linux-foundation.org; bhelgaas@google.com; linuxppc-
> > dev@lists.ozlabs.org; linux-kernel@vger.kernel.org
> > Subject: Re: [PATCH 0/9 v2] vfio-pci: add support for Freescale IOMMU (PAMU)
> > 
> > On Thu, 2013-11-21 at 14:47 -0600, Scott Wood wrote:
> > > On Thu, 2013-11-21 at 13:43 -0700, Alex Williamson wrote:
> > > > On Thu, 2013-11-21 at 11:20 +0000, Bharat Bhushan wrote:
> > > > >
> > > > > > -----Original Message-----
> > > > > > From: Alex Williamson [mailto:alex.williamson@redhat.com]
> > > > > > Sent: Thursday, November 21, 2013 12:17 AM
> > > > > > To: Bhushan Bharat-R65777
> > > > > > Cc: joro@8bytes.org; bhelgaas@google.com; agraf@suse.de; Wood
> > > > > > Scott-B07421; Yoder Stuart-B08248;
> > > > > > iommu@lists.linux-foundation.org; linux- pci@vger.kernel.org;
> > > > > > linuxppc-dev@lists.ozlabs.org; linux- kernel@vger.kernel.org;
> > > > > > Bhushan Bharat-R65777
> > > > > > Subject: Re: [PATCH 0/9 v2] vfio-pci: add support for Freescale
> > > > > > IOMMU (PAMU)
> > > > > >
> > > > > > Is VFIO_IOMMU_PAMU_GET_MSI_BANK_COUNT per aperture (ie. each
> > > > > > vfio user has $COUNT regions at their disposal exclusively)?
> > > > >
> > > > > Number of msi-bank count is system wide and not per aperture, But will be
> > setting windows for banks in the device aperture.
> > > > > So say if we are direct assigning 2 pci device (both have different iommu
> > group, so 2 aperture in iommu) to VM.
> > > > > Now qemu can make only one call to know how many msi-banks are there but
> > it must set sub-windows for all banks for both pci device in its respective
> > aperture.
> > > >
> > > > I'm still confused.  What I want to make sure of is that the banks
> > > > are independent per aperture.  For instance, if we have two separate
> > > > userspace processes operating independently and they both chose to
> > > > use msi bank zero for their device, that's bank zero within each
> > > > aperture and doesn't interfere.  Or another way to ask is can a
> > > > malicious user interfere with other users by using the wrong bank.
> > > > Thanks,
> > >
> > > They can interfere.
> 
> Want to be sure of how they can interfere?

What happens if more than one user selects the same MSI bank?
Minimally, wouldn't that result in the IOMMU blocking transactions from
the previous user once the new user activates their mapping?

> >>  With this hardware, the only way to prevent that
> > > is to make sure that a bank is not shared by multiple protection contexts.
> > > For some of our users, though, I believe preventing this is less
> > > important than the performance benefit.
> 
> So should we let this patch series in without protection?

No.

> > 
> > I think we need some sort of ownership model around the msi banks then.
> > Otherwise there's nothing preventing another userspace from attempting an MSI
> > based attack on other users, or perhaps even on the host.  VFIO can't allow
> > that.  Thanks,
> 
> We have very few (3 MSI bank on most of chips), so we can not assign
> one to each userspace. What we can do is host and userspace does not
> share a MSI bank while userspace will share a MSI bank.

Then you probably need VFIO to "own" the MSI bank and program devices
into it rather than exposing the MSI banks to userspace to let them have
direct access.  Thanks,

Alex

