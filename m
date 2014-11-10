Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753195AbaKJPJb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 10:09:31 -0500
Received: from mail-qa0-f45.google.com ([209.85.216.45]:36772 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752229AbaKJPJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 10:09:30 -0500
MIME-Version: 1.0
X-Originating-IP: [82.146.27.14]
In-Reply-To: <20140328190913.GJ25519@cbox>
References: <1394726249-1547-1-git-send-email-a.motakis@virtualopensystems.com>
 <1394726249-1547-2-git-send-email-a.motakis@virtualopensystems.com> <20140328190913.GJ25519@cbox>
From: Nikolay Nikolaev <n.nikolaev@virtualopensystems.com>
Date: Mon, 10 Nov 2014 17:09:07 +0200
Message-ID: <CADDJ2=Opx2d5ex0hWSXYJjs6uLifR9wZVsahUHzZ7zytSj7ZSg@mail.gmail.com>
Subject: Re: [RFC PATCH 1/4] ARM: KVM: on unhandled IO mem abort, route the
 call to the KVM MMIO bus
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Antonios Motakis <a.motakis@virtualopensystems.com>,
        kvmarm@lists.cs.columbia.edu,
        VirtualOpenSystems Technical Team <tech@virtualopensystems.com>,
        agraf@suse.de, marc.zyngier@arm.com, Gleb Natapov <gleb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Russell King <linux@arm.linux.org.uk>,
        "open list:KERNEL VIRTUAL MA..." <kvm@vger.kernel.org>,
        "moderated list:ARM PORT" <linux-arm-kernel@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Mar 28, 2014 at 9:09 PM, Christoffer Dall
<christoffer.dall@linaro.org> wrote:
>
> On Thu, Mar 13, 2014 at 04:57:26PM +0100, Antonios Motakis wrote:
> > On an unhandled IO memory abort, use the kvm_io_bus_* API in order to
> > handle the MMIO access through any registered read/write callbacks. This
> > is a dependency for eventfd support (ioeventfd and irqfd).
> >
> > However, accesses to the VGIC are still left implemented independently,
> > since the kvm_io_bus_* API doesn't pass the VCPU pointer doing the access.
> >
> > Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
> > Signed-off-by: Nikolay Nikolaev <n.nikolaev@virtualopensystems.com>
> > ---
> >  arch/arm/kvm/mmio.c | 32 ++++++++++++++++++++++++++++++++
> >  virt/kvm/arm/vgic.c |  5 ++++-
> >  2 files changed, 36 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/arm/kvm/mmio.c b/arch/arm/kvm/mmio.c
> > index 4cb5a93..1d17831 100644
> > --- a/arch/arm/kvm/mmio.c
> > +++ b/arch/arm/kvm/mmio.c
> > @@ -162,6 +162,35 @@ static int decode_hsr(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> >       return 0;
> >  }
> >
> > +/**
> > + * kvm_handle_mmio - handle an in-kernel MMIO access
> > + * @vcpu:    pointer to the vcpu performing the access
> > + * @run:     pointer to the kvm_run structure
> > + * @mmio:    pointer to the data describing the access
> > + *
> > + * returns true if the MMIO access has been performed in kernel space,
> > + * and false if it needs to be emulated in user space.
> > + */
> > +static bool handle_kernel_mmio(struct kvm_vcpu *vcpu, struct kvm_run *run,
> > +             struct kvm_exit_mmio *mmio)
> > +{
> > +     int ret;
> > +     if (mmio->is_write) {
> > +             ret = kvm_io_bus_write(vcpu->kvm, KVM_MMIO_BUS, mmio->phys_addr,
> > +                             mmio->len, &mmio->data);
> > +
> > +     } else {
> > +             ret = kvm_io_bus_read(vcpu->kvm, KVM_MMIO_BUS, mmio->phys_addr,
> > +                             mmio->len, &mmio->data);
> > +     }
> > +     if (!ret) {
> > +             kvm_prepare_mmio(run, mmio);
> > +             kvm_handle_mmio_return(vcpu, run);
> > +     }
> > +
> > +     return !ret;
> > +}
> > +
> >  int io_mem_abort(struct kvm_vcpu *vcpu, struct kvm_run *run,
> >                phys_addr_t fault_ipa)
> >  {
> > @@ -200,6 +229,9 @@ int io_mem_abort(struct kvm_vcpu *vcpu, struct kvm_run *run,
> >       if (vgic_handle_mmio(vcpu, run, &mmio))
> >               return 1;
> >
> > +     if (handle_kernel_mmio(vcpu, run, &mmio))
> > +             return 1;
> > +


We're reconsidering ioeventfds patchseries and we tried to evaluate
what you suggested here.

>
> this special-casing of the vgic is now really terrible.  Is there
> anything holding you back from doing the necessary restructure of the
> kvm_bus_io_*() API instead?

Restructuring the kvm_io_bus_ API is not a big thing (we actually did
it), but is not directly related to the these patches.
Of course it can be justified if we do it in the context of removing
vgic_handle_mmio and leaving only handle_kernel_mmio.

>
> That would allow us to get rid of the ugly
> Fix it! in the vgic driver as well.

Going through the vgic_handle_mmio we see that it will require large
refactoring:
 - there are 15 MMIO ranges for the vgic now - each should be
registered as a separate device
 - the handler of each range should be split into read and write
 - all handlers take 'struct kvm_exit_mmio', and pass it to
'vgic_reg_access', 'mmio_data_read' and 'mmio_data_read'

To sum up - if we do this refactoring of vgic's MMIO handling +
kvm_io_bus_ API getting 'vcpu" argument we'll get a 'much' cleaner
vgic code and as a bonus we'll get 'ioeventfd' capabilities.

We have 3 questions:
 - is the kvm_io_bus_ getting 'vcpu' argument acceptable for the other
architectures too?
 - is this huge vgic MMIO handling redesign acceptable/desired (it
touches a lot of code)?
 - is there a way that ioeventfd is accepted leaving vgic.c in it's
current state?

regards,
Nikolay NIkolaev
Virtual Open Systems

>
> -Christoffer
>
> >       kvm_prepare_mmio(run, &mmio);
> >       return 0;
> >  }
> > diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
> > index 8ca405c..afdecc3 100644
> > --- a/virt/kvm/arm/vgic.c
> > +++ b/virt/kvm/arm/vgic.c
> > @@ -849,13 +849,16 @@ struct mmio_range *find_matching_range(const struct mmio_range *ranges,
> >  }
> >
> >  /**
> > - * vgic_handle_mmio - handle an in-kernel MMIO access
> > + * vgic_handle_mmio - handle an in-kernel vgic MMIO access
> >   * @vcpu:    pointer to the vcpu performing the access
> >   * @run:     pointer to the kvm_run structure
> >   * @mmio:    pointer to the data describing the access
> >   *
> >   * returns true if the MMIO access has been performed in kernel space,
> >   * and false if it needs to be emulated in user space.
> > + *
> > + * This is handled outside of kvm_handle_mmio because the kvm_io_bus only
> > + * passes the VM pointer, while we need the VCPU performing the access.
> >   */
> >  bool vgic_handle_mmio(struct kvm_vcpu *vcpu, struct kvm_run *run,
> >                     struct kvm_exit_mmio *mmio)
> > --
> > 1.8.3.2
> >
