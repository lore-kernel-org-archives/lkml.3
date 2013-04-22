Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752706Ab3DVQH2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 12:07:28 -0400
Received: from mail-qe0-f43.google.com ([209.85.128.43]:60198 "EHLO
	mail-qe0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752262Ab3DVQH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 12:07:26 -0400
Date: Mon, 22 Apr 2013 12:07:23 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Ian Campbell <Ian.Campbell@citrix.com>
cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "marc.zyngier@arm.com" <marc.zyngier@arm.com>,
        "will.deacon@arm.com" <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [Xen-devel] [PATCH v6 1/4] arm: introduce psci_smp_ops
In-Reply-To: <1366644069.20256.8.camel@zakaz.uk.xensource.com>
Message-ID: <alpine.LFD.2.03.1304221151200.17375@syhkavp.arg>
References: <alpine.DEB.2.02.1304031239550.5078@kaball.uk.xensource.com> <1365167495-18508-1-git-send-email-stefano.stabellini@eu.citrix.com> <20130418161341.GB14496@n2100.arm.linux.org.uk> <alpine.DEB.2.02.1304181714560.7254@kaball.uk.xensource.com>
 <alpine.LFD.2.03.1304181237480.17375@syhkavp.arg> <alpine.DEB.2.02.1304181749260.7254@kaball.uk.xensource.com> <alpine.LFD.2.03.1304181336280.17375@syhkavp.arg> <alpine.DEB.2.02.1304191035360.7254@kaball.uk.xensource.com> <alpine.LFD.2.03.1304191146230.17375@syhkavp.arg>
 <1366388166.29403.2.camel@dagon.hellion.org.uk> <alpine.LFD.2.03.1304191223280.17375@syhkavp.arg> <alpine.DEB.2.02.1304191739120.7254@kaball.uk.xensource.com> <1366644069.20256.8.camel@zakaz.uk.xensource.com>
User-Agent: Alpine 2.03 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Apr 2013, Ian Campbell wrote:

> On Fri, 2013-04-19 at 18:06 +0100, Stefano Stabellini wrote:
> > On Fri, 19 Apr 2013, Nicolas Pitre wrote:
> > > On Fri, 19 Apr 2013, Ian Campbell wrote:
> > > 
> > > > On Fri, 2013-04-19 at 16:47 +0100, Nicolas Pitre wrote:
> > > > > No one should be probing registers without making sure it is safe to do 
> > > > > so.  Even on non virtualized hardware this can be a dangerous thing to 
> > > > > do.
> > > > 
> > > > Won't people writing per machine code consider, not unreasonably, that
> > > > having been called through a mdesc machine specific hook constitutes
> > > > enough "making sure" that they think it is safe to touch registers which
> > > > are specific to that machine?
> > > 
> > > Remember that this hook was introduced to decide at run time between 
> > > different possibilities for SMP ops on the _same_ machine configuration.  
> > > That machine shouldn't do things which is not permitted on either 
> > > possible alternatives already.  So far the actual usage of that hook 
> > > only looks in the DT to make a decision.  But even if it were to touch 
> > > the hardware, that means it has to be safe to do so on all the possible 
> > > hardware variations this mdesc is associated to.
> > 
> > This last sentence is the key.
> > 
> > It is not guaranteed that being safe on "all the possible hardware
> > variations this mdesc is associated to" and being safe on Xen are the
> > same thing.
> > 
> > What if the same magic configuration register exists on all the possible
> > variations of the platform?
> > I understand that it is unlikely but I think it is a possibility.
> 
> I think it is actually quite likely for such configuration registers,
> nvram etc to exist on all variants of a platform and not all that
> unlikely that smp_init might want to consult them.

In which case the rest of the kernel is also going to consult those 
registers for other purposes.

Again, what's the problem please?

> I think the key thing that non-Xen folks aren't aware of is that
> although Xen passes the majority of the underlying hardware to the dom0
> kernel to manage one of the few things it does not expose to guests
> (where "guests" includes dom0) is the SMP topology of the underlying system.

I suspect it is unlikely to pass on the DT information about the CCI 
either.  Which means that, in the case that started this thread, the 
smp_init function needed by MCPM will simply return false and the next 
priority in the list i.e. plain PSCI will be initialized instead.

I don't forsee the need to poke at the hardware directly within 
->smp_init, not since everything is moving to DT now.

Sure there are ways to screw up Xen support from within this hook, but 
that can be achieved in many other places.  Will Xen take over every 
possible hooks in the kernel to prevent that from happening?

So please let's not cry wolf needlessly.

> Currently the VCPUs are all considered to be uniform i.e. there is no
> big.LITTLE exposed to guests, although the hypervisor will most likely
> eventually support it and so may be scheduling the VCPUs among the big
> and LITTLE PCPUs according to $THINGS.

Indeed.  That's what I suggested earlier.


Nicolas
