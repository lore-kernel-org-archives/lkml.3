Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751953AbaF1HFt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 03:05:49 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:12384 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751001AbaF1HFr convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 03:05:47 -0400
From: Marc Zyngier <marc.zyngier@arm.com>
To: "Chalamarla\, Tirumalesh" <Tirumalesh.Chalamarla@caviumnetworks.com>
Cc: Will Deacon <Will.Deacon@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        "kvm\@vger.kernel.org" <kvm@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "stuart.yoder\@freescale.com" <stuart.yoder@freescale.com>,
        "iommu\@lists.linux-foundation.org" 
	<iommu@lists.linux-foundation.org>,
        "tech\@virtualopensystems.com" <tech@virtualopensystems.com>,
        "kvmarm\@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "moderated list\:ARM SMMU DRIVER" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH v6 04/20] iommu/arm-smmu: add capability IOMMU_CAP_INTR_REMAP
In-Reply-To: <2645e3a22f5e4ae9994c0ee8fa327cb4@BY2PR07MB203.namprd07.prod.outlook.com>
	(Tirumalesh Chalamarla's message of "Fri, 27 Jun 2014 22:57:28 +0100")
Organization: ARM Ltd
References: <20140616151329.GQ16758@arm.com>
	<20140616152157.GB31771@8bytes.org> <20140616152526.GR16758@arm.com>
	<20140616153832.GC31771@8bytes.org>
	<9353770066894e85809e1e443b71d1cd@BY2PR07MB203.namprd07.prod.outlook.com>
	<748dccbbd3284521af4659ccbbb11453@BY2PR07MB203.namprd07.prod.outlook.com>
	<b085e02e72dc424d9624c3e810951087@BY2PR07MB203.namprd07.prod.outlook.com>
	<1403809223.31091.137.camel@ul30vt.home>
	<ec8dbbcb991e4d73b73f4b4f98342445@BY2PR07MB203.namprd07.prod.outlook.com>
	<1403811384.31091.151.camel@ul30vt.home>
	<20140627084722.GB26276@arm.com>
	<2645e3a22f5e4ae9994c0ee8fa327cb4@BY2PR07MB203.namprd07.prod.outlook.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
Date: Sat, 28 Jun 2014 08:05:28 +0100
Message-ID: <86ionl4ipz.fsf@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 27 2014 at 10:57:28 PM, "Chalamarla, Tirumalesh" <Tirumalesh.Chalamarla@caviumnetworks.com> wrote:
> Marc,
>
>          What is your opinion on ITS emulation . is it should be part
>          of KVM or VFIO.

Making any sort of emulation part of VFIO sounds quite wrong. That's not
what VFIO is about, at all. Emulation belongs to the hypervisor, and
nowhere else.

>         Also this code needs to depend on ITS host driver a lot, Host
>         ITS driver needs to have an interface for this code to use.

You can share the command interface as some form of library, but that's
about it. There is no more relationship between the ITS driver and the
ITS emulation as there is between the GIC driver and its emulation
counterpart.

	M.


> Thanks,
>  Tirumalesh
>      
> -----Original Message-----
> From: Will Deacon [mailto:will.deacon@arm.com] 
> Sent: Friday, June 27, 2014 1:47 AM
> To: Alex Williamson
> Cc: Chalamarla, Tirumalesh; Joerg Roedel; kvm@vger.kernel.org; open list; stuart.yoder@freescale.com; iommu@lists.linux-foundation.org; tech@virtualopensystems.com; kvmarm@lists.cs.columbia.edu; moderated list:ARM SMMU DRIVER; marc.zyngier@arm.com
> Subject: Re: [RFC PATCH v6 04/20] iommu/arm-smmu: add capability IOMMU_CAP_INTR_REMAP
>
> On Thu, Jun 26, 2014 at 08:36:24PM +0100, Alex Williamson wrote:
>> On Thu, 2014-06-26 at 19:10 +0000, Chalamarla, Tirumalesh wrote:
>> > Thanks for the clarification Alex, That’s exactly my point, why are 
>> > we relying on  QEMU or something else to emulate the MSI space when 
>> > we can directly give access to devices using ITS (of course with a 
>> > small emulation code).  This way we are also benefited from all ITS 
>> > services like VCPU migration etc.
>> 
>> I have no idea what ITS is.
>
> ITS is the MSI doorbell for GICv3 (ARM's latest interrupt controller).
>
> I agree that we will need an ITS emulation if we want to use MSIs in
>> the guest, and I believe that Marc (CC'd) had already started
>> thinking about that.
>
>
>> > What about non QEMU VFIO users, for example, if I wanted to use VFIO to
>> > assign a device to a user process I don't need to depend on QEMU.   I
>> > thought this is one of the main goals of vfio to make it independent of
>> > hypervisors.     
>> 
>> Where did QEMU become a requirement?  Maybe I'm missing something in 
>> the ARM part of the conversation that got chopped off, but this is 
>> exactly why we have the VFIO/QEMU split that we do.  VFIO provides 
>> basic virtualization for config space and restricts access to other 
>> areas that users shouldn't be allowed to change.  QEMU is just one 
>> example of a userspace VFIO driver.  QEMU takes the decomposed device 
>> exposed through the VFIO ABI and re-creates a PCI device out of it.  
>> VFIO itself has no dependency on QEMU.  Thanks,
>
> I also don't understand the QEMU part here. The MSI emulation would be
>> in the kernel, just like the GICv2 emulation that we already
>> have. For userspace drivers, wouldn't you just use eventfd rather
>> than bother with emulating MSIs?
>
> Finally, the interrupt remapping part is about the SMMU preventing MSI
>> writes to arbitrary portions of the host address space. The ITS is
>> about routing interrupts to CPUs.
>
> Will

-- 
Jazz is not dead. It just smells funny.
