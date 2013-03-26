Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934905Ab3CZPtT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 11:49:19 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:21205 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934835Ab3CZPtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:49:15 -0400
X-IronPort-AV: E=Sophos;i="4.84,913,1355097600"; 
   d="scan'208";a="14920037"
Date: Tue, 26 Mar 2013 15:49:12 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Will Deacon <will.deacon@arm.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        "arnd@arndb.de" <arnd@arndb.de>, Marc Zyngier <Marc.Zyngier@arm.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "nico@linaro.org" <nico@linaro.org>
Subject: Re: [PATCH v2 6/6] [RFC] arm: use PSCI if available
In-Reply-To: <20130326153730.GA22368@mudshark.cambridge.arm.com>
Message-ID: <alpine.DEB.2.02.1303261541070.4430@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1303261423530.4430@kaball.uk.xensource.com> <1364308875-26484-6-git-send-email-stefano.stabellini@eu.citrix.com> <20130326150444.GI20252@mudshark.cambridge.arm.com> <alpine.DEB.2.02.1303261509080.4430@kaball.uk.xensource.com>
 <20130326153730.GA22368@mudshark.cambridge.arm.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
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
> 
> > However we still support that use case just fine:  they can just avoid
> > having a psci node on device tree and just keep using their machine
> > specific smp_ops. It's up to them really.
> 
> Why get rid of the node? That's there to initialise the PSCI backend
> accordingly and shouldn't have anything to do with SMP.
> 
> > They can even base the implementation of their smp_ops on the current
> > psci code, in order to facilitate that I could get rid of psci_ops
> > (which initialization is based on device tree) and export the psci_cpu_*
> > functions instead, so that they can be called directly by other smp_ops.
> 
> Again, I think this destroys the layering. The whole point is that the PSCI
> functions are called from within something that understands precisely how to
> talk to the firmware and what it is capable of.

All right, I am not going to pretend to know better the final purpose of
PSCI :-)

Assuming that you are correct, I can't see any other options than
have a Xen specific override setup.c, but it's really ugly:

diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
index 3f6cbb2..7876865 100644
--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -768,7 +768,12 @@ void __init setup_arch(char **cmdline_p)
 	arm_dt_init_cpu_maps();
 #ifdef CONFIG_SMP
 	if (is_smp()) {
-		smp_set_ops(mdesc->smp);
+		int rc = -ENODEV;
+#ifdef CONFIG_XEN
+		rc = xen_init_smp();
+#endif
+		if (rc)
+			smp_set_ops(mdesc->smp);
 		smp_init_cpus();
 	}
 #endif


> > > If this can indeed work for the virtual platforms (Xen and KVM), then I
> > > think it would be better expressed using `virt' smp_ops, which map directly
> > > to PSCI, rather than putting them here. Even then, it's tying KVM and Xen
> > > together on the firmware side of things...
> > 
> > Keep in mind that dom0 on Xen boots as a native machine (versatile
> > express or exynos5 for example) with a Xen hypervisor node on it.  We
> > would need to find a way to override the default machine smp_ops with
> > a set of xen_smp_ops early at boot.
> > I don't like this option very much, I think is fragile.
> 
> Why can't dom0 use whatever smp ops the native machine would use?

Because Xen doesn't export them (and it's not going to).
