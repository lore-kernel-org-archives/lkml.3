Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965755Ab3CZQBK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 12:01:10 -0400
Received: from mail-qe0-f43.google.com ([209.85.128.43]:47802 "EHLO
	mail-qe0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965745Ab3CZQBF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 12:01:05 -0400
Date: Tue, 26 Mar 2013 12:01:02 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Will Deacon <will.deacon@arm.com>
cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        "arnd@arndb.de" <arnd@arndb.de>, Marc Zyngier <Marc.Zyngier@arm.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>
Subject: Re: [PATCH v2 6/6] [RFC] arm: use PSCI if available
In-Reply-To: <20130326153730.GA22368@mudshark.cambridge.arm.com>
Message-ID: <alpine.LFD.2.03.1303261152141.1372@syhkavp.arg>
References: <alpine.DEB.2.02.1303261423530.4430@kaball.uk.xensource.com> <1364308875-26484-6-git-send-email-stefano.stabellini@eu.citrix.com> <20130326150444.GI20252@mudshark.cambridge.arm.com> <alpine.DEB.2.02.1303261509080.4430@kaball.uk.xensource.com>
 <20130326153730.GA22368@mudshark.cambridge.arm.com>
User-Agent: Alpine 2.03 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Mar 2013, Will Deacon wrote:

> On Tue, Mar 26, 2013 at 03:25:55PM +0000, Stefano Stabellini wrote:
> > On Tue, 26 Mar 2013, Will Deacon wrote:
> > > On Tue, Mar 26, 2013 at 02:41:15PM +0000, Stefano Stabellini wrote:
> > > > +struct smp_operations __initdata psci_smp_ops = {
> > > > +	.smp_init_cpus		= psci_smp_init_cpus,
> > > > +	.smp_prepare_cpus	= psci_smp_prepare_cpus,
> > > > +	.smp_secondary_init	= psci_secondary_init,
> > > > +	.smp_boot_secondary	= psci_boot_secondary,
> > > > +};
> > > 
> > > Whilst I like the idea of this, I don't think things will pan out this
> > > nicely in practice. There will almost always be a level of indirection
> > > required between the internal Linux SMP operations and the expectations of
> > > the PSCI firmware, whether this is in CPU numbering or other,
> > > platform-specific fields in various parameters.
> > > 
> > > Tying these two things together like this confuses the layering in my
> > > opinion and will likely lead to potentially subtle breakages if platforms
> > > start trying to adopt this.
> > 
> > What you are saying is that psci could either be used directly, like we
> > are doing, or it could just be the base of some higher level platform
> > specific smp_ops.
> > 
> > Honestly I think that psci is already high level enough that I would
> > worry if somebody started to wrap it around something else.
> 
> I don't agree. PSCI is a low-level firmware interface, which will naturally
> have implementation-specific parts to it. For example, many of the CPU power
> functions have platform-specific state ID parameters which we can't just
> ignore. Furthermore, the method by which a CPU is identified needn't match
> the value in our logical map. The purpose of the PSCI code in Linux is to
> provide a basic abstraction on top of this interface, so that platforms can
> incorporate them into higher-level power management functions, which
> themselves might be plumbed into smp_operations structures.

Absolutely.  PSCI is _not_ a Linux API.  It is a firmware API.  And 
remember that Linux has no stable API by design. So it is best to keep 
PSCI as one possible way to talk to the firmware, but a flexible shim 
layer (flexible as in "we can change its interface whenever we want to") 
around PSCI to provide a Linux API which also encompass all possible 
low-level implementations alternatives is a better idea.


Nicolas
