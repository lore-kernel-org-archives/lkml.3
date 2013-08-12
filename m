Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757367Ab3HLQT5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 12:19:57 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:48932 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754885Ab3HLQTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 12:19:54 -0400
Date: Mon, 12 Aug 2013 17:19:52 +0100
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
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Nicolas Pitre <nico@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Subject: Re: [PATCH 3/4] ARM: msm: Add SMP support for 8960
Message-ID: <20130812161952.GD27165@e106331-lin.cambridge.arm.com>
References: <1375409725-22004-1-git-send-email-rvaswani@codeaurora.org>
 <1375409725-22004-4-git-send-email-rvaswani@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375409725-22004-4-git-send-email-rvaswani@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 02, 2013 at 03:15:24AM +0100, Rohit Vaswani wrote:
> Add the cpus bindings and the Krait release sequence
> to make SMP work for MSM8960
> 
> Signed-off-by: Rohit Vaswani <rvaswani@codeaurora.org>
> ---
>  Documentation/devicetree/bindings/arm/cpus.txt     |  2 +
>  Documentation/devicetree/bindings/arm/msm/kpss.txt | 16 ++++++
>  arch/arm/boot/dts/msm8960-cdp.dts                  | 22 +++++++++
>  arch/arm/mach-msm/platsmp.c                        | 57 ++++++++++++++++++++++
>  arch/arm/mach-msm/scm-boot.h                       |  8 +--
>  5 files changed, 102 insertions(+), 3 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/arm/msm/kpss.txt
> 
> diff --git a/Documentation/devicetree/bindings/arm/cpus.txt b/Documentation/devicetree/bindings/arm/cpus.txt
> index 327aad2..1132eac 100644
> --- a/Documentation/devicetree/bindings/arm/cpus.txt
> +++ b/Documentation/devicetree/bindings/arm/cpus.txt
> @@ -45,11 +45,13 @@ For the ARM architecture every CPU node must contain the following properties:
>  		"marvell,xsc3"
>  		"marvell,xscale"
>  		"qcom,scorpion"
> +		"qcom,krait"
>  - enable-method: Specifies the method used to enable or take the secondary cores
>  		 out of reset. This allows different reset sequence for
>  		 different types of cpus.
>  		 This should be one of:
>  		 "qcom,scss"
> +		 "qcom,kpssv1"

Hopefully (though this series implies otherwise) we won't have an
explosion of enable-methods. We haven't listed any common ones yet (e.g.
PSCI), and both this and qcom,scss are "poke some cpu-specific
registers".

I take it by the "v1" suffix you're expecting more variation here?

>  
>  Example:
>  
> diff --git a/Documentation/devicetree/bindings/arm/msm/kpss.txt b/Documentation/devicetree/bindings/arm/msm/kpss.txt
> new file mode 100644
> index 0000000..7272340
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/arm/msm/kpss.txt
> @@ -0,0 +1,16 @@
> +* KPSS - Krait Processor Sub-system
> +
> +Properties
> +
> +- compatible : Should contain "qcom,kpss".
> +
> +- reg: Specifies the base address for the KPSS registers used for
> +       booting up secondary cores.
> +
> +Example:
> +
> +	kpss@2088000 {
> +		compatible = "qcom,kpss";
> +		reg = <0x02088000 0x1000
> +			0x02098000 0x2000>;
> +	};

What's the secondary bank of registers? The binding only mentions one...

Is this a register bank per-cpu? There's no linkage to CPU ID, which
means that handling logical mapping is going to get quite painful.

For the vaguely standard "spin-table" enable-method, the address to poke
(cpu-release-addr) may be stored inside a specific cpu node. Following
that style may make more sense here, unless the kpss hardware is used
for anything more than processor hotplug.

We could have the cpu node refer to the specific kpss/register combo,
which would also allow for future expansion if the kpss unit is
per-cluster:

/ {
	cpus {
		device_type = "cpu";
		compatible = "qcom,krait";
		enable-method = "qcom,kpssv1";

		cpu@0 {
			reg = <0>;
			qcom,kpss-reg = <&kpss 1>; /* reg[1] in kpss */
		};

		cpu@1 {
			reg = <1>;
			qcom,kpss-reg = <&kpss 0>; /* reg[0] in kpss */
		};
	}

	kpss: kpss@2088000 {
		compatible = "qcom,kpss";
		reg = <0x02088000 0x1000>,
		      <0x02098000 0x2000>;
	};
}

> diff --git a/arch/arm/boot/dts/msm8960-cdp.dts b/arch/arm/boot/dts/msm8960-cdp.dts
> index db2060c..8c82d5e 100644
> --- a/arch/arm/boot/dts/msm8960-cdp.dts
> +++ b/arch/arm/boot/dts/msm8960-cdp.dts
> @@ -7,6 +7,22 @@
>  	compatible = "qcom,msm8960-cdp", "qcom,msm8960";
>  	interrupt-parent = <&intc>;
>  
> +	cpus {
> +		#address-cells = <1>;
> +		#size-cells = <0>;
> +		compatible = "qcom,krait";
> +		device_type = "cpu";
> +		enable-method = "qcom,kpssv1";
> +
> +		cpu@0 {
> +			reg = <0>;
> +		};
> +
> +		cpu@1 {
> +			reg = <1>;
> +		};
> +	};

Similarly to my comments on the first patch, I like making properties
shared, but we *need* to have common infrastructure before we can do
things this way.

> +
>  	intc: interrupt-controller@2000000 {
>  		compatible = "qcom,msm-qgic2";
>  		interrupt-controller;
> @@ -37,6 +53,12 @@
>  		reg = <0xfd510000 0x4000>;
>  	};
>  
> +	kpss@2088000 {
> +		compatible = "qcom,kpss";
> +		reg = <0x02088000 0x1000
> +			0x02098000 0x2000>;
> +	};
> +
>  	serial@16440000 {
>  		compatible = "qcom,msm-hsuart", "qcom,msm-uart";
>  		reg = <0x16440000 0x1000>,
> diff --git a/arch/arm/mach-msm/platsmp.c b/arch/arm/mach-msm/platsmp.c
> index 17022e0..82eb079 100644
> --- a/arch/arm/mach-msm/platsmp.c
> +++ b/arch/arm/mach-msm/platsmp.c
> @@ -74,6 +74,56 @@ static int scorpion_release_secondary(void)
>  	return 0;
>  }
>  
> +static int msm8960_release_secondary(unsigned int cpu)
> +{
> +	void __iomem *reg;
> +	struct device_node *dn = NULL;
> +
> +	if (cpu == 0 || cpu >= num_possible_cpus())
> +		return -EINVAL;

We seem to describe a reg bank for CPU0. Is this check because we don't
(yet) have a way of hotplugging CPU0 off? Is CPU0 special in that
regard?

> +
> +	dn = of_find_compatible_node(dn, NULL, "qcom,kpss");
> +	if (!dn) {
> +		pr_err("%s : Missing kpss node from device tree\n", __func__);
> +		return -ENXIO;
> +	}
> +
> +	reg = of_iomap(dn, cpu);

That doesn't handle logical id mapping.

> +	if (!reg)
> +		return -ENOMEM;
> +
> +	pr_debug("Starting secondary CPU %d\n", cpu);
> +
> +	/* Turn on CPU Rail */
> +	writel_relaxed(0xA4, reg+0x1014);

Symbolic names for registers please.

[...]

> @@ -151,6 +206,8 @@ static void __init msm_smp_init_cpus(void)
>  static const int cold_boot_flags[] __initconst = {
>  	0,
>  	SCM_FLAG_COLDBOOT_CPU1,
> +	SCM_FLAG_COLDBOOT_CPU2,
> +	SCM_FLAG_COLDBOOT_CPU3,
>  };
>  
>  static void __init msm_smp_prepare_cpus(unsigned int max_cpus)
> diff --git a/arch/arm/mach-msm/scm-boot.h b/arch/arm/mach-msm/scm-boot.h
> index 7be32ff..6aabb24 100644
> --- a/arch/arm/mach-msm/scm-boot.h
> +++ b/arch/arm/mach-msm/scm-boot.h
> @@ -13,9 +13,11 @@
>  #define __MACH_SCM_BOOT_H
>  
>  #define SCM_BOOT_ADDR			0x1
> -#define SCM_FLAG_COLDBOOT_CPU1		0x1
> -#define SCM_FLAG_WARMBOOT_CPU1		0x2
> -#define SCM_FLAG_WARMBOOT_CPU0		0x4
> +#define SCM_FLAG_COLDBOOT_CPU1		0x01
> +#define SCM_FLAG_COLDBOOT_CPU2		0x08
> +#define SCM_FLAG_COLDBOOT_CPU3		0x20
> +#define SCM_FLAG_WARMBOOT_CPU0		0x04
> +#define SCM_FLAG_WARMBOOT_CPU1		0x02

Is there any obvious sequencing for these values?

How will they be extended in future for more CPUs/clusters?

Do we possibly need this information in DT?

Thanks,
Mark.
