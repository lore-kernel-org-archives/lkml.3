Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229Ab3DVPVj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 11:21:39 -0400
Received: from smtp.eu.citrix.com ([46.33.159.39]:5453 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753660Ab3DVPVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 11:21:37 -0400
X-IronPort-AV: E=Sophos;i="4.87,527,1363132800"; 
   d="scan'208";a="3801097"
Message-ID: <1366644069.20256.8.camel@zakaz.uk.xensource.com>
Subject: Re: [Xen-devel] [PATCH v6 1/4] arm: introduce psci_smp_ops
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: Nicolas Pitre <nicolas.pitre@linaro.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "marc.zyngier@arm.com" <marc.zyngier@arm.com>,
        "will.deacon@arm.com" <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Mon, 22 Apr 2013 16:21:09 +0100
In-Reply-To: <alpine.DEB.2.02.1304191739120.7254@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1304031239550.5078@kaball.uk.xensource.com>
	 <1365167495-18508-1-git-send-email-stefano.stabellini@eu.citrix.com>
	 <20130418161341.GB14496@n2100.arm.linux.org.uk>
	 <alpine.DEB.2.02.1304181714560.7254@kaball.uk.xensource.com>
	 <alpine.LFD.2.03.1304181237480.17375@syhkavp.arg>
	 <alpine.DEB.2.02.1304181749260.7254@kaball.uk.xensource.com>
	 <alpine.LFD.2.03.1304181336280.17375@syhkavp.arg>
	 <alpine.DEB.2.02.1304191035360.7254@kaball.uk.xensource.com>
	 <alpine.LFD.2.03.1304191146230.17375@syhkavp.arg>
	 <1366388166.29403.2.camel@dagon.hellion.org.uk>
	 <alpine.LFD.2.03.1304191223280.17375@syhkavp.arg>
	 <alpine.DEB.2.02.1304191739120.7254@kaball.uk.xensource.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-04-19 at 18:06 +0100, Stefano Stabellini wrote:
> On Fri, 19 Apr 2013, Nicolas Pitre wrote:
> > On Fri, 19 Apr 2013, Ian Campbell wrote:
> > 
> > > On Fri, 2013-04-19 at 16:47 +0100, Nicolas Pitre wrote:
> > > > No one should be probing registers without making sure it is safe to do 
> > > > so.  Even on non virtualized hardware this can be a dangerous thing to 
> > > > do.
> > > 
> > > Won't people writing per machine code consider, not unreasonably, that
> > > having been called through a mdesc machine specific hook constitutes
> > > enough "making sure" that they think it is safe to touch registers which
> > > are specific to that machine?
> > 
> > Remember that this hook was introduced to decide at run time between 
> > different possibilities for SMP ops on the _same_ machine configuration.  
> > That machine shouldn't do things which is not permitted on either 
> > possible alternatives already.  So far the actual usage of that hook 
> > only looks in the DT to make a decision.  But even if it were to touch 
> > the hardware, that means it has to be safe to do so on all the possible 
> > hardware variations this mdesc is associated to.
> 
> This last sentence is the key.
> 
> It is not guaranteed that being safe on "all the possible hardware
> variations this mdesc is associated to" and being safe on Xen are the
> same thing.
> 
> What if the same magic configuration register exists on all the possible
> variations of the platform?
> I understand that it is unlikely but I think it is a possibility.

I think it is actually quite likely for such configuration registers,
nvram etc to exist on all variants of a platform and not all that
unlikely that smp_init might want to consult them.

> If we don't take further precautions I'll be forced to regularly scan
> the list for smp_init implementations and look for possible breakages,
> pointing the unaware author of the patches to this conversation.
> Honestly it is not my idea of fun.
> 
> 
> > And if Xen wants to emulate one of those hardware alternatives, then it 
> > better be ready to emulate it properly, or manage for _another_ mdesc to 
> > be selected instead.  That's why mach-virt was introduced.
> 
> I don't mean to argue pointlessly here, but I thought that it was clear
> that Xen does not emulate any hardware interfaces at all.
> 
> Of course when a convenient virtualization aware hardware interface is
> available (the vGIC for example) Xen is going to use it, but other than
> that no emulation is going to be done.

I think the key thing that non-Xen folks aren't aware of is that
although Xen passes the majority of the underlying hardware to the dom0
kernel to manage one of the few things it does not expose to guests
(where "guests" includes dom0) is the SMP topology of the underlying system.

The physical CPUs are managed/scheduled/etc by the hypervisor and it is
the hypervisor which will need to be aware of big.LITTLE and MCPM etc.

The guests, and again this includes dom0, see only a set of VCPUs which
are scheduled amongst the PCPUs by the hypervisor. It is not unusual to
configure dom0 to have less VCPUs than there are PCPUs in the system.
Currently the VCPUs are all considered to be uniform i.e. there is no
big.LITTLE exposed to guests, although the hypervisor will most likely
eventually support it and so may be scheduling the VCPUs among the big
and LITTLE PCPUs according to $THINGS.

I don't think we want to go the route of mandating a 1:1 PCPU:VCPU
relationship for dom0 for Xen on ARM.

Ian.

