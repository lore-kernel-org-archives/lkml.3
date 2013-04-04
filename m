Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761557Ab3DDOMu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 10:12:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57458 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761465Ab3DDOMs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 10:12:48 -0400
Date: Thu, 4 Apr 2013 16:12:36 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Gleb Natapov <gleb@redhat.com>
Cc: Alexander Graf <agraf@suse.de>, Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Takuya Yoshikawa <yoshikawa_takuya_b1@lab.ntt.co.jp>,
        Alex Williamson <alex.williamson@redhat.com>,
        Will Deacon <will.deacon@arm.com>,
        Christoffer Dall <c.dall@virtualopensystems.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH RFC] kvm: add PV MMIO EVENTFD
Message-ID: <20130404131236.GH6467@redhat.com>
References: <20130404104846.GA6227@redhat.com>
 <6D40C5F1-849E-4F32-B391-E1A1BFA8C59D@suse.de>
 <20130404120825.GD17919@redhat.com>
 <959E147D-EB7B-4F4B-9F84-4F1BBA98DEF8@suse.de>
 <20130404123806.GG17919@redhat.com>
 <EF153515-9835-4FB9-B6BC-73D0BDC86492@suse.de>
 <20130404124501.GH17919@redhat.com>
 <1B68D701-103D-4B1A-8F5E-3916753699CB@suse.de>
 <20130404125649.GI17919@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130404125649.GI17919@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 04, 2013 at 03:56:49PM +0300, Gleb Natapov wrote:
> On Thu, Apr 04, 2013 at 02:49:39PM +0200, Alexander Graf wrote:
> > 
> > On 04.04.2013, at 14:45, Gleb Natapov wrote:
> > 
> > > On Thu, Apr 04, 2013 at 02:39:51PM +0200, Alexander Graf wrote:
> > >> 
> > >> On 04.04.2013, at 14:38, Gleb Natapov wrote:
> > >> 
> > >>> On Thu, Apr 04, 2013 at 02:32:08PM +0200, Alexander Graf wrote:
> > >>>> 
> > >>>> On 04.04.2013, at 14:08, Gleb Natapov wrote:
> > >>>> 
> > >>>>> On Thu, Apr 04, 2013 at 01:57:34PM +0200, Alexander Graf wrote:
> > >>>>>> 
> > >>>>>> On 04.04.2013, at 12:50, Michael S. Tsirkin wrote:
> > >>>>>> 
> > >>>>>>> With KVM, MMIO is much slower than PIO, due to the need to
> > >>>>>>> do page walk and emulation. But with EPT, it does not have to be: we
> > >>>>>>> know the address from the VMCS so if the address is unique, we can look
> > >>>>>>> up the eventfd directly, bypassing emulation.
> > >>>>>>> 
> > >>>>>>> Add an interface for userspace to specify this per-address, we can
> > >>>>>>> use this e.g. for virtio.
> > >>>>>>> 
> > >>>>>>> The implementation adds a separate bus internally. This serves two
> > >>>>>>> purposes:
> > >>>>>>> - minimize overhead for old userspace that does not use PV MMIO
> > >>>>>>> - minimize disruption in other code (since we don't know the length,
> > >>>>>>> devices on the MMIO bus only get a valid address in write, this
> > >>>>>>> way we don't need to touch all devices to teach them handle
> > >>>>>>> an dinvalid length)
> > >>>>>>> 
> > >>>>>>> At the moment, this optimization is only supported for EPT on x86 and
> > >>>>>>> silently ignored for NPT and MMU, so everything works correctly but
> > >>>>>>> slowly.
> > >>>>>>> 
> > >>>>>>> TODO: NPT, MMU and non x86 architectures.
> > >>>>>>> 
> > >>>>>>> The idea was suggested by Peter Anvin.  Lots of thanks to Gleb for
> > >>>>>>> pre-review and suggestions.
> > >>>>>>> 
> > >>>>>>> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > >>>>>> 
> > >>>>>> This still uses page fault intercepts which are orders of magnitudes slower than hypercalls. Why don't you just create a PV MMIO hypercall that the guest can use to invoke MMIO accesses towards the host based on physical addresses with explicit length encodings?
> > >>>>>> 
> > >>>>> It is slower, but not an order of magnitude slower. It become faster
> > >>>>> with newer HW.
> > >>>>> 
> > >>>>>> That way you simplify and speed up all code paths, exceeding the speed of PIO exits even. It should also be quite easily portable, as all other platforms have hypercalls available as well.
> > >>>>>> 
> > >>>>> We are trying to avoid PV as much as possible (well this is also PV,
> > >>>>> but not guest visible
> > >>>> 
> > >>>> Also, how is this not guest visible? Who sets KVM_IOEVENTFD_FLAG_PV_MMIO? The comment above its definition indicates that the guest does so, so it is guest visible.
> > >>>> 
> > >>> QEMU sets it.
> > >> 
> > >> How does QEMU know?
> > >> 
> > > Knows what? When to create such eventfd? virtio device knows.
> > 
> > Where does it know from?
> > 
> It does it always.
> 
> > > 
> > >>> 
> > >>>> +/*
> > >>>> + * PV_MMIO - Guest can promise us that all accesses touching this address
> > >>>> + * are writes of specified length, starting at the specified address.
> > >>>> + * If not - it's a Guest bug.
> > >>>> + * Can not be used together with either PIO or DATAMATCH.
> > >>>> + */
> > >>>> 
> > >>> Virtio spec will state that access to a kick register needs to be of
> > >>> specific length. This is reasonable thing for HW to ask.
> > >> 
> > >> This is a spec change. So the guest would have to indicate that it adheres to a newer spec. Thus it's a guest visible change.
> > >> 
> > > There is not virtio spec that has kick register in MMIO. The spec is in
> > > the works AFAIK. Actually PIO will not be deprecated and my suggestion
> > 
> > So the guest would indicate that it supports a newer revision of the spec (in your case, that it supports MMIO). How is that any different from exposing that it supports a PV MMIO hcall?
> > 
> Guest will indicate nothing. New driver will use MMIO if PIO is bar is
> not configured. All driver will not work for virtio devices with MMIO
> bar, but not PIO bar.
> 
> > > is to move to MMIO only when PIO address space is exhausted. For PCI it
> > > will be never, for PCI-e it will be after ~16 devices.
> > 
> > Ok, let's go back a step here. Are you actually able to measure any speed in performance with this patch applied and without when going through MMIO kicks?
> > 
> > 
> That's the question for MST. I think he did only micro benchmarks till
> now and he already posted his result here:
> 
> mmio-wildcard-eventfd:pci-mem 3529
> mmio-pv-eventfd:pci-mem 1878
> portio-wildcard-eventfd:pci-io 1846
> 
> So the patch speedup mmio by almost 100% and it is almost the same as PIO.

Exactly. I sent patches for kvm unittest so you can try it yourself.
At the moment you need a box with EPT to try this.

> --
> 			Gleb.
