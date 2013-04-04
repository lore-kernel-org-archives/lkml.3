Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759998Ab3DDMft (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 08:35:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2828 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759001Ab3DDMfs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 08:35:48 -0400
Date: Thu, 4 Apr 2013 15:34:38 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Alexander Graf <agraf@suse.de>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
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
Message-ID: <20130404123438.GF17919@redhat.com>
References: <20130404104846.GA6227@redhat.com>
 <6D40C5F1-849E-4F32-B391-E1A1BFA8C59D@suse.de>
 <20130404120825.GD17919@redhat.com>
 <194AE9A4-07C6-4597-B3AA-1EDF3DA97FA0@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <194AE9A4-07C6-4597-B3AA-1EDF3DA97FA0@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 04, 2013 at 02:22:09PM +0200, Alexander Graf wrote:
> 
> On 04.04.2013, at 14:08, Gleb Natapov wrote:
> 
> > On Thu, Apr 04, 2013 at 01:57:34PM +0200, Alexander Graf wrote:
> >> 
> >> On 04.04.2013, at 12:50, Michael S. Tsirkin wrote:
> >> 
> >>> With KVM, MMIO is much slower than PIO, due to the need to
> >>> do page walk and emulation. But with EPT, it does not have to be: we
> >>> know the address from the VMCS so if the address is unique, we can look
> >>> up the eventfd directly, bypassing emulation.
> >>> 
> >>> Add an interface for userspace to specify this per-address, we can
> >>> use this e.g. for virtio.
> >>> 
> >>> The implementation adds a separate bus internally. This serves two
> >>> purposes:
> >>> - minimize overhead for old userspace that does not use PV MMIO
> >>> - minimize disruption in other code (since we don't know the length,
> >>> devices on the MMIO bus only get a valid address in write, this
> >>> way we don't need to touch all devices to teach them handle
> >>> an dinvalid length)
> >>> 
> >>> At the moment, this optimization is only supported for EPT on x86 and
> >>> silently ignored for NPT and MMU, so everything works correctly but
> >>> slowly.
> >>> 
> >>> TODO: NPT, MMU and non x86 architectures.
> >>> 
> >>> The idea was suggested by Peter Anvin.  Lots of thanks to Gleb for
> >>> pre-review and suggestions.
> >>> 
> >>> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> >> 
> >> This still uses page fault intercepts which are orders of magnitudes slower than hypercalls. Why don't you just create a PV MMIO hypercall that the guest can use to invoke MMIO accesses towards the host based on physical addresses with explicit length encodings?
> >> 
> > It is slower, but not an order of magnitude slower. It become faster
> > with newer HW.
> > 
> >> That way you simplify and speed up all code paths, exceeding the speed of PIO exits even. It should also be quite easily portable, as all other platforms have hypercalls available as well.
> >> 
> > We are trying to avoid PV as much as possible (well this is also PV,
> > but not guest visible). We haven't replaced PIO with hypercall for the
> > same reason. My hope is that future HW will provide us with instruction
> > decode for basic mov instruction at which point this optimisation can be
> > dropped.
> 
> The same applies to an MMIO hypercall. Once the PV interface becomes obsolete, we can drop the capability we expose to the guest.
> 
Disable it on newer HW is easy, but it is not that simple to get rid of the guest code.

> > And hypercall has its own set of problems with Windows guests.
> > When KVM runs in Hyper-V emulation mode it expects to get Hyper-V
> > hypercalls.  Mixing KVM hypercalls and Hyper-V requires some tricks. It
> 
> Can't we simply register a hypercall ID range with Microsoft?
Doubt it. This is not only about the rang though. The calling convention
is completely different.

> 
> > may also affect WHQLing Windows drivers since driver will talk to HW
> > bypassing Windows interfaces.
> 
> Then the WHQL'ed driver doesn't support the PV MMIO hcall?
> 
All Windows drivers have to be WHQL'ed, saying that is like saying that
we do not care about Windows guest virtio speed.

--
			Gleb.
