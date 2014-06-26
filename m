Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751385AbaFZTCI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 15:02:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12612 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750849AbaFZTCG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 15:02:06 -0400
Message-ID: <1403809223.31091.137.camel@ul30vt.home>
Subject: Re: [RFC PATCH v6 04/20] iommu/arm-smmu: add capability
 IOMMU_CAP_INTR_REMAP
From: Alex Williamson <alex.williamson@redhat.com>
To: "Chalamarla, Tirumalesh" <Tirumalesh.Chalamarla@caviumnetworks.com>
Cc: Joerg Roedel <joro@8bytes.org>, Will Deacon <will.deacon@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "stuart.yoder@freescale.com" <stuart.yoder@freescale.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "tech@virtualopensystems.com" <tech@virtualopensystems.com>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "moderated list:ARM SMMU DRIVER" 
	<linux-arm-kernel@lists.infradead.org>
Date: Thu, 26 Jun 2014 13:00:23 -0600
In-Reply-To: <b085e02e72dc424d9624c3e810951087@BY2PR07MB203.namprd07.prod.outlook.com>
References: <1401987808-23596-1-git-send-email-a.motakis@virtualopensystems.com>
	 <1401987808-23596-5-git-send-email-a.motakis@virtualopensystems.com>
	 <20140608103129.GC3279@lvm> <20140616145344.GD18986@8bytes.org>
	 <20140616151329.GQ16758@arm.com> <20140616152157.GB31771@8bytes.org>
	 <20140616152526.GR16758@arm.com> <20140616153832.GC31771@8bytes.org>
	 <9353770066894e85809e1e443b71d1cd@BY2PR07MB203.namprd07.prod.outlook.com>
	 <748dccbbd3284521af4659ccbbb11453@BY2PR07MB203.namprd07.prod.outlook.com>
	 <b085e02e72dc424d9624c3e810951087@BY2PR07MB203.namprd07.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-06-26 at 18:41 +0000, Chalamarla, Tirumalesh wrote:
> Sorry there was a type,
> 
> The question is:
>  
>             How is VFIO restricting software from writing to MSI/MSI-X vectors of the device. 

All interrupts are configured via ioctl, not MSI config space or the
MSI-X vector table in MMIO space.  VFIO protects the MSI config area by
virtualizing it (you can't actually write the physical enable bit or
address/data through VFIO).  The MSI-X vector table is protected by
preventing read, write, or mmap access to it.  QEMU provides further
virtualization above the basics provided by VFIO.  We really can't
guarantee that devices don't have backdoors to configure these though.
See the realtek quirk in QEMU for an example of a device that has such a
backdoor.  That's why we require interrupt remapping, so that a device
that does this can only hurt the guest, and require the user to opt-out
if they feel they have a sufficiently trusted guest.  Thanks,

Alex

> 
> -----Original Message-----
> From: Chalamarla, Tirumalesh 
> Sent: Thursday, June 26, 2014 11:16 AM
> To: Chalamarla, Tirumalesh; Joerg Roedel; Will Deacon
> Cc: kvm@vger.kernel.org; open list; alex.williamson@redhat.com; stuart.yoder@freescale.com; iommu@lists.linux-foundation.org; tech@virtualopensystems.com; kvmarm@lists.cs.columbia.edu; moderated list:ARM SMMU DRIVER
> Subject: RE: [RFC PATCH v6 04/20] iommu/arm-smmu: add capability IOMMU_CAP_INTR_REMAP
> 
> When I say emulating ITS, I mean translating guest ITS commands to physical ITS commands  and placing them in physical queue. 
> 
> Regards,
> Tirumalesh.
> 
> -----Original Message-----
> From: kvmarm-bounces@lists.cs.columbia.edu [mailto:kvmarm-bounces@lists.cs.columbia.edu] On Behalf Of Chalamarla, Tirumalesh
> Sent: Thursday, June 26, 2014 11:08 AM
> To: Joerg Roedel; Will Deacon
> Cc: kvm@vger.kernel.org; open list; alex.williamson@redhat.com; stuart.yoder@freescale.com; iommu@lists.linux-foundation.org; tech@virtualopensystems.com; kvmarm@lists.cs.columbia.edu; moderated list:ARM SMMU DRIVER
> Subject: RE: [RFC PATCH v6 04/20] iommu/arm-smmu: add capability IOMMU_CAP_INTR_REMAP
> 
> Forgive me if this discussion is not relative here, but I thought it is.  
> 
> How is VFIO restricting devices from writing  to MSI/MSI-X, Is all the vector area is mapped by VFIO to trap the accesses.  I am asking this because we might need to emulate ITS somewhere either in KVM or VFIO to provide direct access to devices.
> And I don't see any mentions on that.   I think this flag needs to be set by ITS emulation.
> 
> Regards,
> Tirumalesh.
> 
> -----Original Message-----
> From: kvmarm-bounces@lists.cs.columbia.edu [mailto:kvmarm-bounces@lists.cs.columbia.edu] On Behalf Of Joerg Roedel
> Sent: Monday, June 16, 2014 8:39 AM
> To: Will Deacon
> Cc: stuart.yoder@freescale.com; kvm@vger.kernel.org; open list; iommu@lists.linux-foundation.org; alex.williamson@redhat.com; moderated list:ARM SMMU DRIVER; tech@virtualopensystems.com; kvmarm@lists.cs.columbia.edu; Christoffer Dall
> Subject: Re: [RFC PATCH v6 04/20] iommu/arm-smmu: add capability IOMMU_CAP_INTR_REMAP
> 
> On Mon, Jun 16, 2014 at 04:25:26PM +0100, Will Deacon wrote:
> > Ok, thanks. In which case, I think this is really a combined property 
> > of the SMMU and the interrupt controller, so we might need some extra 
> > code so that the SMMU can check that the interrupt controller for the 
> > device is also capable of interrupt remapping.
> 
> Right, that this is part of IOMMU code has more or less historic reasons on x86. Interrupt remapping is purely implemented in the IOMMU there, so on ARM some clue-code between interrupt controler and smmu is needed.
> 
> 
> 	Joerg
> 
> 
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm



