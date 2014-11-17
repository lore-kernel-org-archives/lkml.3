Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752594AbaKQL0M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 06:26:12 -0500
Received: from mga14.intel.com ([192.55.52.115]:14056 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751297AbaKQL0J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 06:26:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,402,1413270000"; 
   d="scan'208";a="623520138"
From: "Wu, Feng" <feng.wu@intel.com>
To: Alex Williamson <alex.williamson@redhat.com>,
        Christoffer Dall <christoffer.dall@linaro.org>
CC: Eric Auger <eric.auger@linaro.org>,
        "eric.auger@st.com" <eric.auger@st.com>,
        "marc.zyngier@arm.com" <marc.zyngier@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "joel.schopp@amd.com" <joel.schopp@amd.com>,
        "kim.phillips@freescale.com" <kim.phillips@freescale.com>,
        "paulus@samba.org" <paulus@samba.org>,
        "gleb@kernel.org" <gleb@kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "patches@linaro.org" <patches@linaro.org>,
        "will.deacon@arm.com" <will.deacon@arm.com>,
        "a.motakis@virtualopensystems.com" <a.motakis@virtualopensystems.com>,
        "a.rigo@virtualopensystems.com" <a.rigo@virtualopensystems.com>,
        "john.liuli@huawei.com" <john.liuli@huawei.com>,
        "Wu, Feng" <feng.wu@intel.com>
Subject: RE: [RFC v2 0/9] KVM-VFIO IRQ forward control
Thread-Topic: [RFC v2 0/9] KVM-VFIO IRQ forward control
Thread-Index: AQHPzX7FGqjeXc5tW0qdMyvZxluW9ZxlFqBQ
Date: Mon, 17 Nov 2014 11:25:59 +0000
Message-ID: <E959C4978C3B6342920538CF579893F002291EBC@SHSMSX104.ccr.corp.intel.com>
References: <1409575968-5329-1-git-send-email-eric.auger@linaro.org>
	 <1409691941.3804.133.camel@ul30vt.home> <20140911031044.GK2784@lvm>
 <1410412173.2982.288.camel@ul30vt.home>
In-Reply-To: <1410412173.2982.288.camel@ul30vt.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id sAHBQKPt012336



> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org
> [mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of Alex Williamson
> Sent: Thursday, September 11, 2014 1:10 PM
> To: Christoffer Dall
> Cc: Eric Auger; eric.auger@st.com; marc.zyngier@arm.com;
> linux-arm-kernel@lists.infradead.org; kvmarm@lists.cs.columbia.edu;
> kvm@vger.kernel.org; joel.schopp@amd.com; kim.phillips@freescale.com;
> paulus@samba.org; gleb@kernel.org; pbonzini@redhat.com;
> linux-kernel@vger.kernel.org; patches@linaro.org; will.deacon@arm.com;
> a.motakis@virtualopensystems.com; a.rigo@virtualopensystems.com;
> john.liuli@huawei.com
> Subject: Re: [RFC v2 0/9] KVM-VFIO IRQ forward control
> 
> On Thu, 2014-09-11 at 05:10 +0200, Christoffer Dall wrote:
> > On Tue, Sep 02, 2014 at 03:05:41PM -0600, Alex Williamson wrote:
> > > On Mon, 2014-09-01 at 14:52 +0200, Eric Auger wrote:
> > > > This RFC proposes an integration of "ARM: Forwarding physical
> > > > interrupts to a guest VM" (http://lwn.net/Articles/603514/) in
> > > > KVM.
> > > >
> > > > It enables to transform a VFIO platform driver IRQ into a forwarded
> > > > IRQ. The direct benefit is that, for a level sensitive IRQ, a VM
> > > > switch can be avoided on guest virtual IRQ completion. Before this
> > > > patch, a maintenance IRQ was triggered on the virtual IRQ completion.
> > > >
> > > > When the IRQ is forwarded, the VFIO platform driver does not need to
> > > > disable the IRQ anymore. Indeed when returning from the IRQ handler
> > > > the IRQ is not deactivated. Only its priority is lowered. This means
> > > > the same IRQ cannot hit before the guest completes the virtual IRQ
> > > > and the GIC automatically deactivates the corresponding physical IRQ.
> > > >
> > > > Besides, the injection still is based on irqfd triggering. The only
> > > > impact on irqfd process is resamplefd is not called anymore on
> > > > virtual IRQ completion since this latter becomes "transparent".
> > > >
> > > > The current integration is based on an extension of the KVM-VFIO
> > > > device, previously used by KVM to interact with VFIO groups. The
> > > > patch serie now enables KVM to directly interact with a VFIO
> > > > platform device. The VFIO external API was extended for that purpose.
> > > >
> > > > Th KVM-VFIO device can get/put the vfio platform device, check its
> > > > integrity and type, get the IRQ number associated to an IRQ index.
> > > >
> > > > The IRQ forward programming is architecture specific (virtual interrupt
> > > > controller programming basically). However the whole infrastructure is
> > > > kept generic.
> > > >
> > > > from a user point of view, the functionality is provided through new
> > > > KVM-VFIO device commands,
> KVM_DEV_VFIO_DEVICE_(UN)FORWARD_IRQ
> > > > and the capability can be checked with KVM_HAS_DEVICE_ATTR.
> > > > Assignment can only be changed when the physical IRQ is not active.
> > > > It is the responsability of the user to do this check.
> > > >
> > > > This patch serie has the following dependencies:
> > > > - "ARM: Forwarding physical interrupts to a guest VM"
> > > >   (http://lwn.net/Articles/603514/) in
> > > > - [PATCH v3] irqfd for ARM
> > > > - and obviously the VFIO platform driver serie:
> > > >   [RFC PATCH v6 00/20] VFIO support for platform devices on ARM
> > > >   https://www.mail-archive.com/kvm@vger.kernel.org/msg103247.html
> > > >
> > > > Integrated pieces can be found at
> > > > ssh://git.linaro.org/people/eric.auger/linux.git
> > > > on branch 3.17rc3_irqfd_forward_integ_v2
> > > >
> > > > This was was tested on Calxeda Midway, assigning the xgmac main IRQ.
> > > >
> > > > v1 -> v2:
> > > > - forward control is moved from architecture specific file into generic
> > > >   vfio.c module.
> > > >   only kvm_arch_set_fwd_state remains architecture specific
> > > > - integrate Kim's patch which enables KVM-VFIO for ARM
> > > > - fix vgic state bypass in vgic_queue_hwirq
> > > > - struct kvm_arch_forwarded_irq moved from
> arch/arm/include/uapi/asm/kvm.h
> > > >   to include/uapi/linux/kvm.h
> > > >   also irq_index renamed into index and guest_irq renamed into gsi
> > > > - ASSIGN/DEASSIGN renamed into FORWARD/UNFORWARD
> > > > - vfio_external_get_base_device renamed into vfio_external_base_device
> > > > - vfio_external_get_type removed
> > > > - kvm_vfio_external_get_base_device renamed into
> kvm_vfio_external_base_device
> > > > - __KVM_HAVE_ARCH_KVM_VFIO renamed into
> __KVM_HAVE_ARCH_KVM_VFIO_FORWARD
> > > >
> > > > Eric Auger (8):
> > > >   KVM: ARM: VGIC: fix multiple injection of level sensitive forwarded
> > > >     IRQ
> > > >   KVM: ARM: VGIC: add forwarded irq rbtree lock
> > > >   VFIO: platform: handler tests whether the IRQ is forwarded
> > > >   KVM: KVM-VFIO: update user API to program forwarded IRQ
> > > >   VFIO: Extend external user API
> > > >   KVM: KVM-VFIO: add new VFIO external API hooks
> > > >   KVM: KVM-VFIO: generic KVM_DEV_VFIO_DEVICE command and IRQ
> forwarding
> > > >     control
> > > >   KVM: KVM-VFIO: ARM forwarding control
> > > >
> > > > Kim Phillips (1):
> > > >   ARM: KVM: Enable the KVM-VFIO device
> > > >
> > > >  Documentation/virtual/kvm/devices/vfio.txt |  26 ++
> > > >  arch/arm/include/asm/kvm_host.h            |   7 +
> > > >  arch/arm/kvm/Kconfig                       |   1 +
> > > >  arch/arm/kvm/Makefile                      |   4 +-
> > > >  arch/arm/kvm/kvm_vfio_arm.c                |  85 +++++
> > > >  drivers/vfio/platform/vfio_platform_irq.c  |   7 +-
> > > >  drivers/vfio/vfio.c                        |  24 ++
> > > >  include/kvm/arm_vgic.h                     |   1 +
> > > >  include/linux/kvm_host.h                   |  27 ++
> > > >  include/linux/vfio.h                       |   3 +
> > > >  include/uapi/linux/kvm.h                   |   9 +
> > > >  virt/kvm/arm/vgic.c                        |  59 +++-
> > > >  virt/kvm/vfio.c                            | 497
> ++++++++++++++++++++++++++++-
> > > >  13 files changed, 733 insertions(+), 17 deletions(-)
> > > >  create mode 100644 arch/arm/kvm/kvm_vfio_arm.c
> > > >
> > >
> > > Have we ventured too far in the other direction?  I suppose what I was
> > > hoping to see was something more like:
> > >
> > > 	case KVM_DEV_VFIO_DEVICE_FORWARD_IRQ:{
> > >
> > > 		/* get vfio_device */
> > >
> > > 		/* get mutex */
> > >
> > > 		/* verify device+irq isn't already forwarded */
> > >
> > > 		/* allocate device/forwarded irq */
> > >
> > > 		/* get struct device */
> > >
> > > 		/* callout to arch code passing struct device, gsi, ... */
> > >
> > > 		/* if success, add to kv, else free and error */
> > >
> > > 		/* mutex unlock */
> > > 	}
> >
> > I think that's essentially what this patch set is trying to do, but
> > there are just too many complicated intertwining cases right now that
> > makes the code hard to read.
> >
> > >
> > > Exposing the internal mutex out to arch code, as in v1, was an
> > > indication that we were pushing too much out to arch code, but including
> > > platform_device.h into virt/kvm/vfio.c tells me we're still not
> > > abstracting at the right point.  Thanks,
> > >
> > I raised my eyebrows over the platform device bus thingy here as well,
> > but on the other hand, there's nothing ARM-specific about referring to
> > the platform device bus.
> >
> > I think perhaps it just has to be made more clear that the generic code
> > deals with translating the device resources in the necessary way, and
> > currently it only supports vfio-platform devices?
> 
> Ok, you're probably right, looking at it again it is closer than I
> thought.  At the same time, the use of platform device in
> virt/kvm/vfio.c is pointless and can easily be pushed out to the arch
> code as just another error return case.  vfio.c doesn't need to be aware
> of hwirq.  The rest of the code is just overly complicated, with three
> different cleanup functions and validation function bloat.  Thanks,
> 
> Alex


Hi Alex, Could you please tell what is the current status of this patch set.
As you mentioned in another thread, something(such as, kvm_vfio_device_get_external_user(), etc.)
in this patch set can be leveraged for VT-d Posted-interrtups.

Thanks,
Feng

> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
