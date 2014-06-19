Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757508AbaFSOOA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 10:14:00 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:63670 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756435AbaFSON6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 10:13:58 -0400
Date: Thu, 19 Jun 2014 15:13:25 +0100
From: Will Deacon <will.deacon@arm.com>
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Eric Auger <eric.auger@linaro.org>,
        "eric.auger@st.com" <eric.auger@st.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "patches@linaro.org" <patches@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "christophe.barnichon@st.com" <christophe.barnichon@st.com>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2] ARM: KVM: add irqfd and irq routing support
Message-ID: <20140619141325.GB15659@arm.com>
References: <1401694196-30861-1-git-send-email-eric.auger@linaro.org>
 <20140605102831.GA3994@lvm>
 <53906D63.9040508@linaro.org>
 <20140605143950.GA10079@lvm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140605143950.GA10079@lvm>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I'm currently adding VFIO support for kvmtool, so I'm interested in this
patch series (although actually from a PCI perspective).

Eric: can you CC me on future versions of this series please? Once things
start to stabilise, I can help with testing.

On Thu, Jun 05, 2014 at 03:39:50PM +0100, Christoffer Dall wrote:
> On Thu, Jun 05, 2014 at 03:15:15PM +0200, Eric Auger wrote:
> > On 06/05/2014 12:28 PM, Christoffer Dall wrote:
> > > On Mon, Jun 02, 2014 at 09:29:56AM +0200, Eric Auger wrote:
> > >> +                  kvm_debug("Inject irqchip routed vIRQ %d\n",
> > >> +                                  e->irqchip.pin);
> > >> +                  kvm_vgic_inject_irq(kvm, 0, spi, level);
> > >> +                  /*
> > >> +                   * toggling down vIRQ wire is directly handled in
> > >> +                   * process_maintenance for this reason:
> > >> +                   * irqfd_resampler_ack is called in
> > >> +                   * process_maintenance which holds the dist lock.
> > >> +                   * irqfd_resampler_ack calls kvm_set_irq
> > >> +                   * which ends_up calling kvm_vgic_inject_irq.
> > >> +                   * This later attempts to take the lock -> deadlock!
> > >> +                   */
> > >
> > > Not sure I understand this comment.  What are we trying to achieve, are
> > > we using some sort of a workaround to avoid a deadlock?
> >
> > What I wanted to point out here is I would have prefered to handle both
> > levels 0 and 1 in a symetrical manner. irqfd_resampler_ack (in eventfd)
> > is calling kvm_set_irq with level 0. This would be the prefered way to
> > toggle down the SPI at GIC input instead of doing this in
> > process_maintenance in a dirty manner. However this does work because
> > irqfd_resampler_ack is called in process_maintenance (the place where
> > the EOI is analyzed). process_maintenance holds the dist lock and would
> > eventually call kvm_vgic_inject_irq which also attempts to take the lock.
> >
> 
> I'm afraid that's too much of a hack.  There's an external mechanism to
> set an interrupt line to active (level=1) or inactive (level=0) and we
> must support both.
> 
> The fact that vgic_process_maintenance() can set the interrupt line to
> inactive is just something we exploit to properly handle level-triggered
> interrupts, but the main API to the VGIC must absolutely be supported.
> 
> Am I completely wrong here?
> 
> The locking issue can be solved by splitting up the locking into a finer
> granularity as needed or deferring the call to irqfd_resampler_ack()
> until after unlocking the distributor lock in kvm_vgic_sync_hwstate().

Why can't we do what PowerPC does for mpic and x86 does for IOAPIC and
simply drop the distributor lock across the call to kvm_notify_acked_irq?

Given that I think the eventfd callbacks can block, holding a spinlock isn't
safe anyway, regardless of the vgic re-entrancy issue.

Will
