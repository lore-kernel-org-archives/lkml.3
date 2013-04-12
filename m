Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754719Ab3DLLnH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 07:43:07 -0400
Received: from mail.abilis.ch ([195.70.19.74]:22930 "EHLO mail.abilis.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753539Ab3DLLnF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 07:43:05 -0400
Date: Fri, 12 Apr 2013 13:42:40 +0200
From: Christian Ruppert <christian.ruppert@abilis.com>
To: Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Mike Turquette <mturquette@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.or,
        Shawn Guo <shawn.guo@freescale.com>
Subject: Re: [PATCH v2] clk: add device tree fixed-factor-clock binding
 support
Message-ID: <20130412114240.GA26039@ab42.lan>
References: <1365760708-4763-1-git-send-email-gregory.clement@free-electrons.com>
 <1365760708-4763-2-git-send-email-gregory.clement@free-electrons.com>
 <20130412103007.GE29291@ab42.lan>
 <5167ED84.4020000@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <5167ED84.4020000@free-electrons.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 12, 2013 at 01:18:28PM +0200, Gregory CLEMENT wrote:
> On 04/12/2013 12:30 PM, Christian Ruppert wrote:
> > Hi Gregory,
> > 
> > Just tested the patch and it works perfectly. Did you forget to update
> > Documentation/devicetree/bindings/clock/fixed-factor-clock.txt, however?
> 
> Oh yes you're right. I will send a v3 with this modification.
> Can I also add your tested-by flag?

definitely.

> > 
> > Greetings,
> >   Christian
> > 
> > On Fri, Apr 12, 2013 at 11:58:28AM +0200, Gregory CLEMENT wrote:
> >> Add support for DT "fixed-factor-clock" binding to the common fixed
> >> factor clock support.
> >>
> >> Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
> >> ---
> >>  .../bindings/clock/fixed-factor-clock.txt          |   24 +++++++++++++
> >>  drivers/clk/clk-fixed-factor.c                     |   36 ++++++++++++++++++++
> >>  include/linux/clk-provider.h                       |    2 ++
> >>  3 files changed, 62 insertions(+)
> >>  create mode 100644 Documentation/devicetree/bindings/clock/fixed-factor-clock.txt
> >>
> >> diff --git a/Documentation/devicetree/bindings/clock/fixed-factor-clock.txt b/Documentation/devicetree/bindings/clock/fixed-factor-clock.txt
> >> new file mode 100644
> >> index 0000000..7ed236f
> >> --- /dev/null
> >> +++ b/Documentation/devicetree/bindings/clock/fixed-factor-clock.txt
> >> @@ -0,0 +1,24 @@
> >> +Binding for simple fixed factor rate clock sources.
> >> +
> >> +This binding uses the common clock binding[1].
> >> +
> >> +[1] Documentation/devicetree/bindings/clock/clock-bindings.txt
> >> +
> >> +Required properties:
> >> +- compatible : shall be "fixed-factor-clock".
> >> +- #clock-cells : from common clock binding; shall be set to 0.
> >> +- div: fixed divider.
> >> +- mult: fixed multiplier.
> >> +- clocks: parent clock.
> >> +
> >> +Optional properties:
> >> +- clock-output-names : From common clock binding.
> >> +
> >> +Example:
> >> +	clock {
> >> +		compatible = "fixed-factor-clock";
> >> +		clocks = <&parentclk>;
> >> +		#clock-cells = <0>;
> >> +		div = <2>;
> >> +		mult = <1>;
> >> +	};
> >> diff --git a/drivers/clk/clk-fixed-factor.c b/drivers/clk/clk-fixed-factor.c
> >> index 1ef271e..9ff7d51 100644
> >> --- a/drivers/clk/clk-fixed-factor.c
> >> +++ b/drivers/clk/clk-fixed-factor.c
> >> @@ -11,6 +11,7 @@
> >>  #include <linux/clk-provider.h>
> >>  #include <linux/slab.h>
> >>  #include <linux/err.h>
> >> +#include <linux/of.h>
> >>  
> >>  /*
> >>   * DOC: basic fixed multiplier and divider clock that cannot gate
> >> @@ -96,3 +97,38 @@ struct clk *clk_register_fixed_factor(struct device *dev, const char *name,
> >>  
> >>  	return clk;
> >>  }
> >> +#ifdef CONFIG_OF
> >> +/**
> >> + * of_fixed_factor_clk_setup() - Setup function for simple fixed factor clock
> >> + */
> >> +void __init of_fixed_factor_clk_setup(struct device_node *node)
> >> +{
> >> +	struct clk *clk;
> >> +	const char *clk_name = node->name;
> >> +	const char *parent_name;
> >> +	u32 div, mult;
> >> +
> >> +	if (of_property_read_u32(node, "clock-div", &div)) {
> >> +		pr_err("%s Fixed factor clock <%s> must have a clock-div property\n",
> >> +			__func__, node->name);
> >> +		return;
> >> +	}
> >> +
> >> +	if (of_property_read_u32(node, "clock-mult", &mult)) {
> >> +		pr_err("%s Fixed factor clock <%s> must have a clokc-mult property\n",
> >> +			__func__, node->name);
> >> +		return;
> >> +	}
> >> +
> >> +	of_property_read_string(node, "clock-output-names", &clk_name);
> >> +	parent_name = of_clk_get_parent_name(node, 0);
> >> +
> >> +	clk = clk_register_fixed_factor(NULL, clk_name, parent_name, 0,
> >> +					mult, div);
> >> +	if (!IS_ERR(clk))
> >> +		of_clk_add_provider(node, of_clk_src_simple_get, clk);
> >> +}
> >> +EXPORT_SYMBOL_GPL(of_fixed_factor_clk_setup);
> >> +CLK_OF_DECLARE(fixed_factor_clk, "fixed-factor-clock",
> >> +		of_fixed_factor_clk_setup);
> >> +#endif
> >> diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
> >> index 7f197d7..7ea501b 100644
> >> --- a/include/linux/clk-provider.h
> >> +++ b/include/linux/clk-provider.h
> >> @@ -325,6 +325,8 @@ struct clk *clk_register_fixed_factor(struct device *dev, const char *name,
> >>  		const char *parent_name, unsigned long flags,
> >>  		unsigned int mult, unsigned int div);
> >>  
> >> +void of_fixed_factor_clk_setup(struct device_node *node);
> >> +
> >>  /**
> >>   * clk_register - allocate a new clock, register it and return an opaque cookie
> >>   * @dev: device that is registering this clock
> >> -- 
> >> 1.7.9.5
> >>
> > 
> 
> 
> -- 
> Gregory Clement, Free Electrons
> Kernel, drivers, real-time and embedded Linux
> development, consulting, training and support.
> http://free-electrons.com

-- 
  Christian Ruppert              ,          <christian.ruppert@abilis.com>
                                /|
  Tel: +41/(0)22 816 19-42     //|                 3, Chemin du Pré-Fleuri
                             _// | bilis Systems   CH-1228 Plan-les-Ouates
