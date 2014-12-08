Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754021AbaLHFV7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 00:21:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48974 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750776AbaLHFV5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 00:21:57 -0500
Message-ID: <1418016076.1095.30.camel@bling.home>
Subject: Re: [v2 17/25] KVM: kvm-vfio: User API for VT-d Posted-Interrupts
From: Alex Williamson <alex.williamson@redhat.com>
To: "Wu, Feng" <feng.wu@intel.com>
Cc: Eric Auger <eric.auger@linaro.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>, "gleb@kernel.org" <gleb@kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "jiang.liu@linux.intel.com" <jiang.liu@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Date: Sun, 07 Dec 2014 22:21:16 -0700
In-Reply-To: <E959C4978C3B6342920538CF579893F0022E2DD7@SHSMSX104.ccr.corp.intel.com>
References: <1417592394-24343-1-git-send-email-feng.wu@intel.com>
	 <1417592394-24343-18-git-send-email-feng.wu@intel.com>
	 <548069F6.7020308@linaro.org>
	 <E959C4978C3B6342920538CF579893F0022E2DD7@SHSMSX104.ccr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-12-08 at 04:58 +0000, Wu, Feng wrote:
> 
> > -----Original Message-----
> > From: kvm-owner@vger.kernel.org [mailto:kvm-owner@vger.kernel.org] On
> > Behalf Of Eric Auger
> > Sent: Thursday, December 04, 2014 10:05 PM
> > To: Wu, Feng; tglx@linutronix.de; mingo@redhat.com; hpa@zytor.com;
> > x86@kernel.org; gleb@kernel.org; pbonzini@redhat.com;
> > dwmw2@infradead.org; joro@8bytes.org; alex.williamson@redhat.com;
> > jiang.liu@linux.intel.com
> > Cc: linux-kernel@vger.kernel.org; iommu@lists.linux-foundation.org;
> > kvm@vger.kernel.org
> > Subject: Re: [v2 17/25] KVM: kvm-vfio: User API for VT-d Posted-Interrupts
> > 
> > Hi Feng,
> > On 12/03/2014 08:39 AM, Feng Wu wrote:
> > > This patch adds and documents a new attribute
> > > KVM_DEV_VFIO_DEVICE_POSTING_IRQ in KVM_DEV_VFIO_DEVICE group.
> > > This new attribute is used for VT-d Posted-Interrupts.
> > >
> > > When guest OS changes the interrupt configuration for an
> > > assigned device, such as, MSI/MSIx data/address fields,
> > > QEMU will use this IRQ attribute to tell KVM to update the
> > > related IRTE according the VT-d Posted-Interrrupts Specification,
> > > such as, the guest vector should be updated in the related IRTE.
> > >
> > > Signed-off-by: Feng Wu <feng.wu@intel.com>
> > > ---
> > >  Documentation/virtual/kvm/devices/vfio.txt |    9 +++++++++
> > >  include/uapi/linux/kvm.h                   |   10 ++++++++++
> > >  2 files changed, 19 insertions(+), 0 deletions(-)
> > >
> > > diff --git a/Documentation/virtual/kvm/devices/vfio.txt
> > b/Documentation/virtual/kvm/devices/vfio.txt
> > > index f7aff29..41e12b7 100644
> > > --- a/Documentation/virtual/kvm/devices/vfio.txt
> > > +++ b/Documentation/virtual/kvm/devices/vfio.txt
> > > @@ -42,3 +42,12 @@ activated before VFIO_DEVICE_SET_IRQS has been
> > called to trigger the IRQ
> > >  or associate an eventfd to it. Unforwarding can only be called while the
> > >  signaling has been disabled with VFIO_DEVICE_SET_IRQS. If this condition
> > is
> > >  not satisfied, the command returns an -EBUSY.
> > > +
> > > +  KVM_DEV_VFIO_DEVICE_POSTING_IRQ: Use posted interrtups
> > mechanism to post
> > typo
> > > +                                   the IRQ to guests.
> > > +For this attribute, kvm_device_attr.addr points to a kvm_vfio_dev_irq
> > struct.
> > > +
> > > +When guest OS changes the interrupt configuration for an assigned device,
> > > +such as, MSI/MSIx data/address fields, QEMU will use this IRQ attribute
> > > +to tell KVM to update the related IRTE according the VT-d
> > Posted-Interrrupts
> > > +Specification, such as, the guest vector should be updated in the related
> > IRTE.
> > For my curiosity are there any restrictions about the instant at which
> > the change can be done?
> > I do not get here how you deactivate the posting?
> 
> The current method is if the hardware supports interrupts posting, we will
> use it instead of interrupts remapping, since it has good performance. Why
> do I need deactivate interrupts posting?
> 
> Here is the reply to Alex for the same question:
> "In fact, I don't think we need to stop the posted-interrupts. For setting
> posted interrupts, we update the related IRTE according to the new
> format. If the guest reboots, or unload the drivers, or some other
> operations, the msi/msix will be disabled first, in this path, the irq
> will be disabled the related IRTE is not used anymore."

Right, and I'm still not sure I agree with that reasoning.  We need to
build the kernel interface to be generic, not tailored for a specific
userspace.  I don't really feel comfortable having something that can't
be disabled via a similar path to it being enabled.  For instance, what
about a dynamic debug interface where we want to enable tracing and see
each interrupt injected into the guest.  At that point we'd want to
disabled posted interrupts and direct KVM injection and route via QEMU.
Thanks,

Alex

> > > diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> > > index a269a42..7d98650 100644
> > > --- a/include/uapi/linux/kvm.h
> > > +++ b/include/uapi/linux/kvm.h
> > > @@ -949,6 +949,7 @@ struct kvm_device_attr {
> > >  #define  KVM_DEV_VFIO_DEVICE			2
> > >  #define   KVM_DEV_VFIO_DEVICE_FORWARD_IRQ			1
> > >  #define   KVM_DEV_VFIO_DEVICE_UNFORWARD_IRQ			2
> > > +#define   KVM_DEV_VFIO_DEVICE_POSTING_IRQ			3
> > Maybe we should align our naming verb vs verbing here?
> > Best Regards
> > Eric
> 
> No problem, I will align my patch in the next version. Thanks!
> 
> Thanks,
> Feng
> 
> > >
> > >  enum kvm_device_type {
> > >  	KVM_DEV_TYPE_FSL_MPIC_20	= 1,
> > > @@ -973,6 +974,15 @@ struct kvm_arch_forwarded_irq {
> > >  	__u32 gsi; /* gsi, ie. virtual IRQ number */
> > >  };
> > >
> > > +struct kvm_vfio_dev_irq {
> > > +	__u32	argsz;
> > > +	__u32	fd;		/* file descriptor of the VFIO device */
> > > +	__u32	index;		/* VFIO device IRQ index */
> > > +	__u32	start;
> > > +	__u32	count;
> > > +	__u32	gsi[];		/* gsi, ie. virtual IRQ number */
> > > +};
> > > +
> > >  /*
> > >   * ioctls for VM fds
> > >   */
> > >
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe kvm" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



