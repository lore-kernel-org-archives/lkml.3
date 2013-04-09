Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936105Ab3DIMVz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 08:21:55 -0400
Received: from mail-ee0-f54.google.com ([74.125.83.54]:40266 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759169Ab3DIMVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 08:21:54 -0400
Date: Tue, 9 Apr 2013 13:21:45 +0100
From: Dave Martin <dave.martin@linaro.org>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>,
        "marc.zyngier@arm.com" <marc.zyngier@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v4 2/2] arm: prefer PSCI for SMP bringup
Message-ID: <20130409122133.GA2233@linaro.org>
References: <1364575371-8926-2-git-send-email-stefano.stabellini@eu.citrix.com>
 <alpine.LFD.2.03.1303291320580.1372@syhkavp.arg>
 <alpine.DEB.2.02.1303291735080.4430@kaball.uk.xensource.com>
 <alpine.LFD.2.03.1303291349150.1372@syhkavp.arg>
 <5155EC28.8050608@gmail.com>
 <alpine.DEB.2.02.1304011541010.5078@kaball.uk.xensource.com>
 <alpine.LFD.2.03.1304011412030.1171@syhkavp.arg>
 <alpine.DEB.2.02.1304021522230.5078@kaball.uk.xensource.com>
 <alpine.LFD.2.03.1304021202520.1171@syhkavp.arg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.03.1304021202520.1171@syhkavp.arg>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 02, 2013 at 12:11:25PM -0400, Nicolas Pitre wrote:
> On Tue, 2 Apr 2013, Stefano Stabellini wrote:
> 
> > On Mon, 1 Apr 2013, Nicolas Pitre wrote:
> > > On Mon, 1 Apr 2013, Stefano Stabellini wrote:
> > > > What are the platforms that are going to use smp_init? Do we know how do
> > > > they intend to use it?
> > > 
> > > VExpress for one.  When booting on a big.LITTLE system such as TC2 on 
> > > VExpress, the MCPM layer needs to arbitrate power management operations 
> > > on a per cluster basis.  In that case there is a MCPM specific set of 
> > > SMP ops to be used, even if it may end up calling into PSCI.
> > > 
> > > But the important point is that we don't know beforehand what to use, 
> > > especially with a kernel that can boot on multiple different VExpress 
> > > configurations.  The decision has to be made at run time, and therefore 
> > > a static default or mdesc->smp ops doesn't cut it.
> > 
> > I certainly like the principle and I am in favor of anything that moves
> > the decisions at runtime. I have pulled the patch in the series, it's
> > going to be in the next version.
> > 
> > However I am concerned that these platform specific operations won't
> > work with Xen at all.
> > I am getting increasingly certain that we need a Xen specific check in
> > setup_arch to bump up of the priority of PSCI over anything else if Xen
> > is running. 
> 
> I'm concerned about mixing big.LITTLE and Xen as well.  I don't think 
> this is going to make an easy match.  KVM might have an easier fit here.
> 
> But, in any case, even if the MCPM layer gets involved, if Xen is there 
> then PSCI will end up being the ultimate interface anyway.

Note that big.LITTLE != MCPM.  Virtualisation hosts might be large multi-
cluster systems, but the CPUs might be all of the same type.  MCPM or
similar would me needed for the multi-cluster power management even
though there is no big.LITTLE mix of CPUs.

> But let's cross that bridge when we get to it.  For now this is still a 
> non existing problem.

That's a big open question.  Either the host or hypervisor needs to be
very clever about scheduling guests, or you need to bind each guest virtual
CPU to a specific class of physical CPUs -- so, for example you provide
a guest with an explicit mix of bigs and littles.

All we can say about that for now is that it's a potential research area...

Cheers
---Dave
