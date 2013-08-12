Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757262Ab3HLPuX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 11:50:23 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:48497 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757154Ab3HLPuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 11:50:20 -0400
Date: Mon, 12 Aug 2013 16:50:16 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Rohit Vaswani <rvaswani@codeaurora.org>
Cc: David Brown <davidb@codeaurora.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Nicolas Pitre <nico@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
Subject: Re: [RESEND PATCH 2/4] ARM: msm: Re-organize platsmp to make it
 extensible
Message-ID: <20130812155016.GC27165@e106331-lin.cambridge.arm.com>
References: <1375409725-22004-1-git-send-email-rvaswani@codeaurora.org>
 <1375409725-22004-3-git-send-email-rvaswani@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375409725-22004-3-git-send-email-rvaswani@codeaurora.org>
Thread-Topic: [RESEND PATCH 2/4] ARM: msm: Re-organize platsmp to make it
 extensible
Accept-Language: en-GB, en-US
Content-Language: en-US
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Apologies for the long delay for review on this.

I really like the direction this is going, but I have some qualms with
the implementation.

On Fri, Aug 02, 2013 at 03:15:23AM +0100, Rohit Vaswani wrote:
> This makes it easy to add SMP support for new targets
> by adding cpus property and the release sequence.
> We add the enable-method property for the cpus property to
> specify which release sequence to use.
> While at it, add the 8660 cpus bindings to make SMP work.
> 
> Signed-off-by: Rohit Vaswani <rvaswani@codeaurora.org>
> ---
>  Documentation/devicetree/bindings/arm/cpus.txt     |  6 ++
>  Documentation/devicetree/bindings/arm/msm/scss.txt | 15 ++++
>  arch/arm/boot/dts/msm8660-surf.dts                 | 23 +++++-
>  arch/arm/mach-msm/platsmp.c                        | 94 +++++++++++++++++-----
>  4 files changed, 115 insertions(+), 23 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/arm/msm/scss.txt
> 
> diff --git a/Documentation/devicetree/bindings/arm/cpus.txt b/Documentation/devicetree/bindings/arm/cpus.txt
> index f32494d..327aad2 100644
> --- a/Documentation/devicetree/bindings/arm/cpus.txt
> +++ b/Documentation/devicetree/bindings/arm/cpus.txt
> @@ -44,6 +44,12 @@ For the ARM architecture every CPU node must contain the following properties:
>  		"marvell,mohawk"
>  		"marvell,xsc3"
>  		"marvell,xscale"
> +		"qcom,scorpion"
> +- enable-method: Specifies the method used to enable or take the secondary cores
> +		 out of reset. This allows different reset sequence for
> +		 different types of cpus.
> +		 This should be one of:
> +		 "qcom,scss"

While I'd certainly like to see a move to using enable-method for
32-bit, I think this needs a bit more thought:

What does "qcom,scss" mean, precisely? It seems to be that we poke some
registers in a "qcom,scss" device. I think we need to document
enable-methods *very* carefully (and we need to do that for 64-bit as
well with psci), as it's very likely there'll be subtle
incompatibilities between platforms, especially if firmware is involved.
We should try to leaves as little room for error as possible.

I don't want to see this devolve into meaning "whatever the Linux driver
for this happens to do at the current point in time", as that just leads
to breakage as we have no clear distinction between actual requirements
and implementation details.

Given we already have platforms without an enable-method, we can't make
it a required property either -- those platforms are already booting by
figuring out an enable method from the platform's compatible string.

With PSCI, enable-method also implies a method for disabling a
particular CPU, so it would be nice for the description to cover this.

>  
>  Example:
>  
> diff --git a/Documentation/devicetree/bindings/arm/msm/scss.txt b/Documentation/devicetree/bindings/arm/msm/scss.txt
> new file mode 100644
> index 0000000..21c3e26
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/arm/msm/scss.txt
> @@ -0,0 +1,15 @@
> +* SCSS - Scorpion Sub-system
> +
> +Properties
> +
> +- compatible : Should contain "qcom,scss".
> +
> +- reg: Specifies the base address for the SCSS registers used for
> +       booting up secondary cores.
> +
> +Example:
> +
> +	scss@902000 {
> +		compatible = "qcom,scss";
> +		reg = <0x00902000 0x2000>;
> +	};
> diff --git a/arch/arm/boot/dts/msm8660-surf.dts b/arch/arm/boot/dts/msm8660-surf.dts
> index cdc010e..203e51a 100644
> --- a/arch/arm/boot/dts/msm8660-surf.dts
> +++ b/arch/arm/boot/dts/msm8660-surf.dts
> @@ -7,6 +7,22 @@
>  	compatible = "qcom,msm8660-surf", "qcom,msm8660";
>  	interrupt-parent = <&intc>;
>  
> +	cpus {
> +		#address-cells = <1>;
> +		#size-cells = <0>;
> +		compatible = "qcom,scorpion";
> +		device_type = "cpu";
> +		enable-method = "qcom,scss";
> +
> +		cpu@0 {
> +			reg = <0>;
> +		};
> +
> +		cpu@1 {
> +			reg = <1>;
> +		};
> +	};
> +

I *really* like moving the common properties out into the /cpus node --
ePAPR suggests it, it's less error prone, and it takes up less space.
However, I'm not sure our generic/arch code handles it properly, and I
think we need to audit that before we can start writing dts that depend
on it. I'd be happy to be wrong here if anyone can correct me. :)

We probably need to factor out the way we read properties for cpu nodes,
falling back to ones present in /cpus if not present. There's already a
lot of pain getting the node for a logical (rather than physical) cpu
id.

Sudeep recently factored out finding the cpu node for a logical cpu id
[1,2] in generic code with a per-arch callback, it shouldn't be too hard
to have shims around that to read (optionally) common properties.

[...]

> -static void prepare_cold_cpu(unsigned int cpu)
> +static int scorpion_release_secondary(void)
>  {
> -	int ret;
> -	ret = scm_set_boot_addr(virt_to_phys(secondary_startup),
> -				SCM_FLAG_COLDBOOT_CPU1);
> -	if (ret == 0) {
> -		void __iomem *sc1_base_ptr;
> -		sc1_base_ptr = ioremap_nocache(0x00902000, SZ_4K*2);
> -		if (sc1_base_ptr) {
> -			writel(0, sc1_base_ptr + VDD_SC1_ARRAY_CLAMP_GFS_CTL);
> -			writel(0, sc1_base_ptr + SCSS_CPU1CORE_RESET);
> -			writel(3, sc1_base_ptr + SCSS_DBG_STATUS_CORE_PWRDUP);
> -			iounmap(sc1_base_ptr);
> -		}
> -	} else
> -		printk(KERN_DEBUG "Failed to set secondary core boot "
> -				  "address\n");
> +	void __iomem *sc1_base_ptr;
> +	struct device_node *dn = NULL;
> +
> +	dn = of_find_compatible_node(dn, NULL, "qcom,scss");
> +	if (!dn) {
> +		pr_err("%s: Missing scss node in device tree\n", __func__);
> +		return -ENXIO;
> +	}
> +
> +	sc1_base_ptr = of_iomap(dn, 0);
> +	if (sc1_base_ptr) {
> +		writel_relaxed(0, sc1_base_ptr + VDD_SC1_ARRAY_CLAMP_GFS_CTL);
> +		writel_relaxed(0, sc1_base_ptr + SCSS_CPU1CORE_RESET);
> +		writel_relaxed(3, sc1_base_ptr + SCSS_DBG_STATUS_CORE_PWRDUP);
> +		mb();
> +		iounmap(sc1_base_ptr);

Does this boot *all* secondary CPUs directly into the kernel? Is that
safe (e.g. if the kernel supports fewer CPUs than are physically
present)?

Is this a one-time thing, or are we able to dynamically hotplug CPUs? If
the latter, the map/unmap looks odd to me.

> +	} else {
> +		return -ENOMEM;
> +	}
> +
> +	return 0;
>  }
>  
> -static int msm_boot_secondary(unsigned int cpu, struct task_struct *idle)
> +static DEFINE_PER_CPU(int, cold_boot_done);
> +
> +static void boot_cold_cpu(unsigned int cpu)
>  {
> -	static int cold_boot_done;
> +	const char *enable_method;
> +	struct device_node *dn = NULL;
>  
> -	/* Only need to bring cpu out of reset this way once */
> -	if (cold_boot_done == false) {
> -		prepare_cold_cpu(cpu);
> -		cold_boot_done = true;
> +	dn = of_find_node_by_name(dn, "cpus");
> +	if (!dn) {
> +		pr_err("%s: Missing node cpus in device tree\n", __func__);
> +		return;
>  	}
>  
> +	enable_method = of_get_property(dn, "enable-method", NULL);

Please factor this out from the platform code.

If we're going to use enable-method, it should be decoupled from
platform code -- common code should parse it to find the appropriate
handler. Also, we *must* support having an enable-method per-cpu as KVM
does for PSCI (though I definitely would like support for shared
properties as mentioned above).

> +	if (!enable_method) {
> +			pr_err("%s: cpus node is missing enable-method property\n",
> +					__func__);
> +	} else if (!strcmp(enable_method, "qcom,scss")) {
> +		if (per_cpu(cold_boot_done, cpu) == false) {
> +			scorpion_release_secondary();
> +			per_cpu(cold_boot_done, cpu) = true;
> +		}
> +	} else {
> +		pr_err("%s: Invalid enable-method property: %s\n",
> +				__func__, enable_method);
> +	}
> +}
> +
> +static int msm_boot_secondary(unsigned int cpu, struct task_struct *idle)
> +{
> +	boot_cold_cpu(cpu);
> +
>  	/*
>  	 * set synchronisation state between this boot processor
>  	 * and the secondary one
> @@ -118,8 +148,28 @@ static void __init msm_smp_init_cpus(void)
>  		set_cpu_possible(i, true);
>  }
>  
> +static const int cold_boot_flags[] __initconst = {
> +	0,
> +	SCM_FLAG_COLDBOOT_CPU1,
> +};

So we only ever support booting two CPUs?

Is the mapping of MPIDR to register bits arbitrary? Or do we know what
they would be for four CPUs, four clusters, and beyond?

> +
>  static void __init msm_smp_prepare_cpus(unsigned int max_cpus)
>  {
> +	int cpu, map;
> +	unsigned int flags = 0;
> +
> +	for_each_present_cpu(cpu) {
> +		map = cpu_logical_map(cpu);
> +		if (map > ARRAY_SIZE(cold_boot_flags)) {
> +			set_cpu_present(cpu, false);
> +			__WARN();
> +			continue;
> +		}
> +		flags |= cold_boot_flags[map];

It's a shame that this leaves a window where some CPUs seem bootable,
but aren't (though I can't offer a better way of handling this given we
have dts without enable-method properties).

> +	}
> +
> +	if (scm_set_boot_addr(virt_to_phys(secondary_startup), flags))
> +		pr_warn("Failed to set CPU boot address\n");
>  }
>  
>  struct smp_operations msm_smp_ops __initdata = {
> -- 
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> hosted by The Linux Foundation
> 

Thanks,
Mark

[1] http://lists.infradead.org/pipermail/linux-arm-kernel/2013-July/184150.html
[2] http://lists.infradead.org/pipermail/linux-arm-kernel/2013-August/189619.html
