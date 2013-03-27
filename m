Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753108Ab3C0SWW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 14:22:22 -0400
Received: from smtp.citrix.com ([66.165.176.89]:33178 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751791Ab3C0SWU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 14:22:20 -0400
X-IronPort-AV: E=Sophos;i="4.84,920,1355097600"; 
   d="scan'208";a="15963434"
Date: Wed, 27 Mar 2013 18:22:15 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Nicolas Pitre <nicolas.pitre@linaro.org>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Rob Herring <robherring2@gmail.com>, Will Deacon <will.deacon@arm.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "arnd@arndb.de" <arnd@arndb.de>, Marc Zyngier <Marc.Zyngier@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3] [RFC] arm: use PSCI if available
In-Reply-To: <alpine.LFD.2.03.1303271321290.1372@syhkavp.arg>
Message-ID: <alpine.DEB.2.02.1303271753130.4430@kaball.uk.xensource.com>
References: <1364388639-11210-1-git-send-email-stefano.stabellini@eu.citrix.com> <20130327133811.GE18429@mudshark.cambridge.arm.com> <alpine.DEB.2.02.1303271610430.4430@kaball.uk.xensource.com> <51531FE3.8010905@gmail.com> <alpine.DEB.2.02.1303271642340.4430@kaball.uk.xensource.com>
 <alpine.LFD.2.03.1303271321290.1372@syhkavp.arg>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Mar 2013, Nicolas Pitre wrote:
> On Wed, 27 Mar 2013, Stefano Stabellini wrote:
> 
> > On Wed, 27 Mar 2013, Rob Herring wrote:
> > > On 03/27/2013 11:23 AM, Stefano Stabellini wrote:
> > > > Would you agree on a patch that moves virt_smp_ops out of mach-virt and
> > > > renames them to psci_smp_ops (maybe to arch/arm/kernel/psci_smp_ops.c)?
> > > > 
> > > > Would you agree on initializing psci from setup_arch, right after the
> > > > call to arm_dt_init_cpu_maps()?
> > > > 
> > > > Finally the most controversial point: would you agree on using
> > > > psci_smp_ops by default if they are available?
> > > > If not, would you at least agree on letting Xen overwrite the default
> > > > machine smp_ops?
> > > > We need one or the other for dom0 support.
> > > 
> > > It should not be *always* use PSCI smp ops if available, but use them
> > > only if the platform does not define its own smp ops.
> > 
> > Well, that is the one additional problem that we have on Xen.
> > 
> > On x86 Xen replaces a lot of core native function calls with its own
> > implementations (see paravirt_ops).
> > On ARM we only need *one* set of calls: the smp_ops calls.
> > 
> > So if we don't want to give priority to PSCI over the platform smp_ops,
> > then we need a simple workaround just for Xen in common code like the
> > one appended below.
> > Not pretty, but at least small:
> [...]
> 
> What about the patch below that I'm carying in my MCPM branch 
> which has been posted here already:

It's a step in the right direction but it still wouldn't solve the
problem.
Let me describe the scenario again:

- we have a versatile express machine with Xen running on it (or an
  exynos5, etc.);
- Xen boots Linux as Dom0, passing a versatile express device tree with
  the Xen hypervisor node added to it;
- Linux is booting, using the versatile express device tree for hardware
  discovery;
- Linux can access the hardware described in the device tree because Xen
  remapped the MMIO regions appropriately;
- Linux needs to bring secondary cpus up, but Xen only exports a PSCI
  interface, so the native versatile express smp_ops don't work;
- Linux needs to detect that PSCI is available (or Xen is available with
  its set of xen_smp_ops) and preferable on this platform and uses it
  instead of the versatile express smp_ops.



> From: Jon Medhurst <tixy@linaro.org>
> Date: Thu, 13 Dec 2012 13:23:13 +0000
> Subject: [PATCH] ARM: Enable selection of SMP operations at boot time
> 
> Add a new 'smp_init' hook to machine_desc so platforms can specify a
> function to be used to setup smp ops instead of having a statically
> defined value.
> 
> Signed-off-by: Jon Medhurst <tixy@linaro.org>
> Signed-off-by: Nicolas Pitre <nicolas.pitre@linaro.org>
> Reviewed-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
> 
> diff --git a/arch/arm/include/asm/mach/arch.h b/arch/arm/include/asm/mach/arch.h
> index 308ad7d6f9..c01bf53b85 100644
> --- a/arch/arm/include/asm/mach/arch.h
> +++ b/arch/arm/include/asm/mach/arch.h
> @@ -16,8 +16,10 @@ struct pt_regs;
>  struct smp_operations;
>  #ifdef CONFIG_SMP
>  #define smp_ops(ops) (&(ops))
> +#define smp_init_ops(ops) (&(ops))
>  #else
>  #define smp_ops(ops) (struct smp_operations *)NULL
> +#define smp_init_ops(ops) (void (*)(void))NULL
>  #endif
>  
>  struct machine_desc {
> @@ -41,6 +43,7 @@ struct machine_desc {
>  	unsigned char		reserve_lp2 :1;	/* never has lp2	*/
>  	char			restart_mode;	/* default restart mode	*/
>  	struct smp_operations	*smp;		/* SMP operations	*/
> +	void			(*smp_init)(void);
>  	void			(*fixup)(struct tag *, char **,
>  					 struct meminfo *);
>  	void			(*reserve)(void);/* reserve mem blocks	*/
> diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
> index 3f6cbb2e3e..41edca8582 100644
> --- a/arch/arm/kernel/setup.c
> +++ b/arch/arm/kernel/setup.c
> @@ -768,7 +768,10 @@ void __init setup_arch(char **cmdline_p)
>  	arm_dt_init_cpu_maps();
>  #ifdef CONFIG_SMP
>  	if (is_smp()) {
> -		smp_set_ops(mdesc->smp);
> +		if(mdesc->smp_init)
> +			(*mdesc->smp_init)();
> +		else
> +			smp_set_ops(mdesc->smp);
>  		smp_init_cpus();
>  	}
>  #endif
> 
