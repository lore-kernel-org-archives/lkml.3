Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754529Ab3J0NqN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 09:46:13 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:38735 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754207Ab3J0NqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 09:46:12 -0400
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [RFC 9/9] of/irq: create interrupts-extended property
To: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Rob Herring <rob.herring@calxeda.com>, Mark Rutland <mark.rutland@arm.com>,
        Pawel Moll <pawel.moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@kernel.crashing.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
In-Reply-To: <1381869563-16083-10-git-send-email-grant.likely@linaro.org>
References: <1381869563-16083-1-git-send-email-grant.likely@linaro.org> <1381869563-16083-10-git-send-email-grant.likely@linaro.org>
Date: Sun, 27 Oct 2013 13:46:07 +0000
Message-Id: <20131027134607.E1782C4039D@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Oct 2013 21:39:23 +0100, Grant Likely <grant.likely@linaro.org> wrote:
> The standard interrupts property in device tree can only handle
> interrupts coming from a single interrupt parent. If a device is wired
> to multiple interrupt controllers, then it needs to be attached to a
> node with an interrupt-map property to demux the interrupt specifiers
> which is confusing. It would be a lot easier if there was a form of the
> interrupts property that allows for a separate interrupt phandle for
> each interrupt specifier.
> 
> This patch does exactly that by creating a new interrupts-extended
> property which reuses the phandle+arguments pattern used by GPIOs and
> other core bindings.
> 
> Signed-off-by: Grant Likely <grant.likely@linaro.org>
> Cc: Rob Herring <rob.herring@calxeda.com>

Alright, I want to merge this one. I've got an Ack from Tony, general
agreement from an in person converstaion from Ben (aside from wishing he
could think of a better property name), and various rumblings of
approval from anyone I talked to about it at ksummit. I'd like to have
something more that that to put into the commit text. Please take a look
and let me know if you agree/disagree with this binding.

g.

> ---
>  .../bindings/interrupt-controller/interrupts.txt   | 29 +++++++--
>  arch/arm/boot/dts/testcases/tests-interrupts.dtsi  | 16 +++++
>  arch/arm/boot/dts/versatile-ab.dts                 |  2 +-
>  arch/arm/boot/dts/versatile-pb.dts                 |  2 +-
>  drivers/of/irq.c                                   | 16 +++--
>  drivers/of/selftest.c                              | 70 ++++++++++++++++++++++
>  6 files changed, 122 insertions(+), 13 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/interrupt-controller/interrupts.txt b/Documentation/devicetree/bindings/interrupt-controller/interrupts.txt
> index 72a06c0..1486497 100644
> --- a/Documentation/devicetree/bindings/interrupt-controller/interrupts.txt
> +++ b/Documentation/devicetree/bindings/interrupt-controller/interrupts.txt
> @@ -4,16 +4,33 @@ Specifying interrupt information for devices
>  1) Interrupt client nodes
>  -------------------------
>  
> -Nodes that describe devices which generate interrupts must contain an
> -"interrupts" property. This property must contain a list of interrupt
> -specifiers, one per output interrupt. The format of the interrupt specifier is
> -determined by the interrupt controller to which the interrupts are routed; see
> -section 2 below for details.
> +Nodes that describe devices which generate interrupts must contain an either an
> +"interrupts" property or an "interrupts-extended" property. These properties
> +contain a list of interrupt specifiers, one per output interrupt. The format of
> +the interrupt specifier is determined by the interrupt controller to which the
> +interrupts are routed; see section 2 below for details.
> +
> +  Example:
> +	interrupt-parent = <&intc1>;
> +	interrupts = <5 0>, <6 0>;
>  
>  The "interrupt-parent" property is used to specify the controller to which
>  interrupts are routed and contains a single phandle referring to the interrupt
>  controller node. This property is inherited, so it may be specified in an
> -interrupt client node or in any of its parent nodes.
> +interrupt client node or in any of its parent nodes. Interrupts listed in the
> +"interrupts" property are always in reference to the node's interrupt parent.
> +
> +The "interrupts-extended" property is a special form for use when a node needs
> +to reference multiple interrupt parents. Each entry in this property contains
> +both the parent phandle and the interrupt specifier. "interrupts-extended"
> +should only be used when a device has multiple interrupt parents.
> +
> +  Example:
> +	interrupts-extended = <&intc1 5 1>, <&intc2 1 0>;
> +
> +A device node may contain either "interrupts" or "interrupts-extended", but not
> +both. If both properties are present, then the operating system should log an
> +error and use only the data in "interrupts".
>  
>  2) Interrupt controller nodes
>  -----------------------------
> diff --git a/arch/arm/boot/dts/testcases/tests-interrupts.dtsi b/arch/arm/boot/dts/testcases/tests-interrupts.dtsi
> index 6ecda71..560d6bf 100644
> --- a/arch/arm/boot/dts/testcases/tests-interrupts.dtsi
> +++ b/arch/arm/boot/dts/testcases/tests-interrupts.dtsi
> @@ -27,6 +27,12 @@
>  						<4 &test_intc2 15 16>;
>  			};
>  
> +			test_intmap1: intmap1 {
> +				#interrupt-cells = <2>;
> +				#address-cells = <0>;
> +				interrupt-map = <1 2 &test_intc0 15>;
> +			};
> +
>  			interrupts0 {
>  				interrupt-parent = <&test_intc0>;
>  				interrupts = <1>, <2>, <3>, <4>;
> @@ -36,6 +42,16 @@
>  				interrupt-parent = <&test_intmap0>;
>  				interrupts = <1>, <2>, <3>, <4>;
>  			};
> +
> +			interrupts-extended0 {
> +				interrupts-extended = <&test_intc0 1>,
> +						      <&test_intc1 2 3 4>,
> +						      <&test_intc2 5 6>,
> +						      <&test_intmap0 1>,
> +						      <&test_intmap0 2>,
> +						      <&test_intmap0 3>,
> +						      <&test_intmap1 1 2>;
> +			};
>  		};
>  	};
>  };
> diff --git a/arch/arm/boot/dts/versatile-ab.dts b/arch/arm/boot/dts/versatile-ab.dts
> index dde75ae..e01e5a0 100644
> --- a/arch/arm/boot/dts/versatile-ab.dts
> +++ b/arch/arm/boot/dts/versatile-ab.dts
> @@ -185,7 +185,7 @@
>  			mmc@5000 {
>  				compatible = "arm,primecell";
>  				reg = < 0x5000 0x1000>;
> -				interrupts = <22 34>;
> +				interrupts-extended = <&vic 22 &sic 2>;
>  			};
>  			kmi@6000 {
>  				compatible = "arm,pl050", "arm,primecell";
> diff --git a/arch/arm/boot/dts/versatile-pb.dts b/arch/arm/boot/dts/versatile-pb.dts
> index 7e81752..f43907c 100644
> --- a/arch/arm/boot/dts/versatile-pb.dts
> +++ b/arch/arm/boot/dts/versatile-pb.dts
> @@ -41,7 +41,7 @@
>  			mmc@b000 {
>  				compatible = "arm,primecell";
>  				reg = <0xb000 0x1000>;
> -				interrupts = <23 34>;
> +				interrupts-extended = <&vic 23 &sic 2>;
>  			};
>  		};
>  	};
> diff --git a/drivers/of/irq.c b/drivers/of/irq.c
> index ddea945..c01f60e 100644
> --- a/drivers/of/irq.c
> +++ b/drivers/of/irq.c
> @@ -292,17 +292,23 @@ int of_irq_parse_one(struct device_node *device, int index, struct of_phandle_ar
>  	if (of_irq_workarounds & OF_IMAP_OLDWORLD_MAC)
>  		return of_irq_parse_oldworld(device, index, out_irq);
>  
> +	/* Get the reg property (if any) */
> +	addr = of_get_property(device, "reg", NULL);
> +
>  	/* Get the interrupts property */
>  	intspec = of_get_property(device, "interrupts", &intlen);
> -	if (intspec == NULL)
> -		return -EINVAL;
> +	if (intspec == NULL) {
> +		/* Try the new-style interrupts-extended */
> +		res = of_parse_phandle_with_args(device, "interrupts-extended",
> +						"#interrupt-cells", index, out_irq);
> +		if (res)
> +			return -EINVAL;
> +		return of_irq_parse_raw(addr, out_irq);
> +	}
>  	intlen /= sizeof(*intspec);
>  
>  	pr_debug(" intspec=%d intlen=%d\n", be32_to_cpup(intspec), intlen);
>  
> -	/* Get the reg property (if any) */
> -	addr = of_get_property(device, "reg", NULL);
> -
>  	/* Look for the interrupt parent. */
>  	p = of_irq_find_parent(device);
>  	if (p == NULL)
> diff --git a/drivers/of/selftest.c b/drivers/of/selftest.c
> index 9c80f0b..e21012b 100644
> --- a/drivers/of/selftest.c
> +++ b/drivers/of/selftest.c
> @@ -231,6 +231,75 @@ static void __init of_selftest_parse_interrupts(void)
>  	of_node_put(np);
>  }
>  
> +static void __init of_selftest_parse_interrupts_extended(void)
> +{
> +	struct device_node *np;
> +	struct of_phandle_args args;
> +	int i, rc;
> +
> +	np = of_find_node_by_path("/testcase-data/interrupts/interrupts-extended0");
> +	if (!np) {
> +		pr_err("missing testcase data\n");
> +		return;
> +	}
> +
> +	for (i = 0; i < 7; i++) {
> +		bool passed = true;
> +		rc = of_irq_parse_one(np, i, &args);
> +
> +		/* Test the values from tests-phandle.dtsi */
> +		switch (i) {
> +		case 0:
> +			passed &= !rc;
> +			passed &= (args.args_count == 1);
> +			passed &= (args.args[0] == 1);
> +			break;
> +		case 1:
> +			passed &= !rc;
> +			passed &= (args.args_count == 3);
> +			passed &= (args.args[0] == 2);
> +			passed &= (args.args[1] == 3);
> +			passed &= (args.args[2] == 4);
> +			break;
> +		case 2:
> +			passed &= !rc;
> +			passed &= (args.args_count == 2);
> +			passed &= (args.args[0] == 5);
> +			passed &= (args.args[1] == 6);
> +			break;
> +		case 3:
> +			passed &= !rc;
> +			passed &= (args.args_count == 1);
> +			passed &= (args.args[0] == 9);
> +			break;
> +		case 4:
> +			passed &= !rc;
> +			passed &= (args.args_count == 3);
> +			passed &= (args.args[0] == 10);
> +			passed &= (args.args[1] == 11);
> +			passed &= (args.args[2] == 12);
> +			break;
> +		case 5:
> +			passed &= !rc;
> +			passed &= (args.args_count == 2);
> +			passed &= (args.args[0] == 13);
> +			passed &= (args.args[1] == 14);
> +			break;
> +		case 6:
> +			passed &= !rc;
> +			passed &= (args.args_count == 1);
> +			passed &= (args.args[0] == 15);
> +			break;
> +		default:
> +			passed = false;
> +		}
> +
> +		selftest(passed, "index %i - data error on node %s rc=%i\n",
> +			 i, args.np->full_name, rc);
> +	}
> +	of_node_put(np);
> +}
> +
>  static int __init of_selftest(void)
>  {
>  	struct device_node *np;
> @@ -246,6 +315,7 @@ static int __init of_selftest(void)
>  	of_selftest_parse_phandle_with_args();
>  	of_selftest_property_match_string();
>  	of_selftest_parse_interrupts();
> +	of_selftest_parse_interrupts_extended();
>  	pr_info("end of selftest - %i passed, %i failed\n",
>  		selftest_results.passed, selftest_results.failed);
>  	return 0;
> -- 
> 1.8.1.2
> 

