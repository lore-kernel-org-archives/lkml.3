Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753814Ab3C0QXe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 12:23:34 -0400
Received: from smtp.citrix.com ([66.165.176.89]:10313 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753669Ab3C0QXc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 12:23:32 -0400
X-IronPort-AV: E=Sophos;i="4.84,920,1355097600"; 
   d="scan'208";a="15926184"
Date: Wed, 27 Mar 2013 16:23:15 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Will Deacon <will.deacon@arm.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "arnd@arndb.de" <arnd@arndb.de>, Marc Zyngier <Marc.Zyngier@arm.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "nico@linaro.org" <nico@linaro.org>
Subject: Re: [PATCH v3] [RFC] arm: use PSCI if available
In-Reply-To: <20130327133811.GE18429@mudshark.cambridge.arm.com>
Message-ID: <alpine.DEB.2.02.1303271610430.4430@kaball.uk.xensource.com>
References: <1364388639-11210-1-git-send-email-stefano.stabellini@eu.citrix.com> <20130327133811.GE18429@mudshark.cambridge.arm.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Mar 2013, Will Deacon wrote:
> Hi Stefano,
> 
> On Wed, Mar 27, 2013 at 12:50:39PM +0000, Stefano Stabellini wrote:
> > Check for the presence of PSCI before setting smp_ops, use PSCI if it is
> > available.
> > 
> > This is useful because at least when running on Xen it's possible to have a
> > PSCI node for example on a Versatile Express or an Exynos5 machine. In these
> > cases the PSCI SMP calls should be the ones to be called.
> > 
> > Remove virt_smp_ops and platsmp.c from mach-virt because they aren't needed
> > anymore.
> 
> [...]
> 
> > +struct psci_operations psci_ops = {
> > +	.cpu_suspend = psci_cpu_suspend,
> > +	.cpu_off     = psci_cpu_off,
> > +	.cpu_on      = psci_cpu_on,
> > +	.migrate     = psci_migrate,
> > +};
> > +
> > +#ifdef CONFIG_SMP
> > +static void __init psci_smp_init_cpus(void)
> > +{
> > +}
> > +
> > +static void __init psci_smp_prepare_cpus(unsigned int max_cpus)
> > +{
> > +}
> > +
> > +static int __cpuinit psci_boot_secondary(unsigned int cpu,
> > +					 struct task_struct *idle)
> > +{
> > +	return psci_cpu_on(cpu_logical_map(cpu), __pa(secondary_startup));
> > +}
> > +
> > +static void __cpuinit psci_secondary_init(unsigned int cpu)
> > +{
> > +	gic_secondary_init(0);
> > +}
> > +
> > +struct smp_operations __initdata psci_smp_ops = {
> > +	.smp_init_cpus		= psci_smp_init_cpus,
> > +	.smp_prepare_cpus	= psci_smp_prepare_cpus,
> > +	.smp_secondary_init	= psci_secondary_init,
> > +	.smp_boot_secondary	= psci_boot_secondary,
> > +};
> > +#endif
> 
> As I said before, I don't agree with bolting these two interfaces together
> like this and, as it stands, I'm afraid I have to NAK this patch.
> 
> A potential alternative is to have a set of virt_smp_ops, which have
> wrappers around the psci functions, but that requires agreement from Xen and
> KVM to implement the same PSCI interface, which feels unfair to me.
> 
> I see what you're trying to do, but I can't go along with it. Sorry.
 
OK, let's see if I can make this acceptable to you.


Would you agree on a patch that moves virt_smp_ops out of mach-virt and
renames them to psci_smp_ops (maybe to arch/arm/kernel/psci_smp_ops.c)?

Would you agree on initializing psci from setup_arch, right after the
call to arm_dt_init_cpu_maps()?

Finally the most controversial point: would you agree on using
psci_smp_ops by default if they are available?
If not, would you at least agree on letting Xen overwrite the default
machine smp_ops?
We need one or the other for dom0 support.
