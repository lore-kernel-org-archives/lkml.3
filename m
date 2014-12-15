Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751206AbaLOM7o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 07:59:44 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:59928 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750722AbaLOM7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 07:59:41 -0500
Date: Mon, 15 Dec 2014 12:59:32 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Eddie Huang <eddie.huang@mediatek.com>
Cc: Matthias Brugger <matthias.bgg@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, Jason Cooper <jason@lakedaemon.net>,
        "srv_heupstream@mediatek.com" <srv_heupstream@mediatek.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Olof Johansson <olof@lixom.net>,
        "Joe.C" <yingjoe.chen@mediatek.com>,
        Robert Richter <rrichter@cavium.com>, Mark Brown <broonie@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Sascha Hauer <kernel@pengutronix.de>,
        "yh.chen@mediatek.com" <yh.chen@mediatek.com>
Subject: Re: [PATCH 3/4] arm64: dts: Add mediatek MT8173 SoC and evaluation
 board dts and Makefile
Message-ID: <20141215125932.GF462@leverpostej>
References: <1418208602-35584-1-git-send-email-eddie.huang@mediatek.com>
 <1418208602-35584-4-git-send-email-eddie.huang@mediatek.com>
 <20141211180245.GE28150@leverpostej>
 <1418371705.423.31.camel@mtksdaap41>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418371705.423.31.camel@mtksdaap41>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 12, 2014 at 08:08:25AM +0000, Eddie Huang wrote:
> Hi Mark,
> 
> On Thu, 2014-12-11 at 18:02 +0000, Mark Rutland wrote:
> > Hi,
> > 
> > On Wed, Dec 10, 2014 at 10:50:01AM +0000, Eddie Huang wrote:
> > > Add device tree support for MT8173 SoC and evalutaion board based on it.
> > > 
> > > +/ {
> > > +	model = "mediatek,mt8173-evb";
> > > +
> > > +	aliases {
> > > +		serial0 = &uart0;
> > > +		serial1 = &uart1;
> > > +		serial2 = &uart2;
> > > +		serial3 = &uart3;
> > 
> > Do any of these support earlycon?
> 
> Not yet
> 
> > 
> > > +	};
> > > +
> > > +	memory {
> > 
> > Nit: should be memory@40000000 (and you'll need to add device_type =
> > "memory").
> > 
> > > +		reg = <0 0x40000000 0 0x40000000>;
> > > +	};
> 
> skeleton.dtsi already has /memory node with address-cells=2,
> size-cells=1, which will cause build warning if I change to use
> memory@40000000, because we use size-cells=2. I will not include
> skeleton.dtsi and follow your suggestion in next version.

That sounds fine to me.

> 
> > > +
> > > +#include "skeleton.dtsi"
> > > +
> > > +/ {
> > > +	compatible = "mediatek,mt8173";
> > > +	interrupt-parent = <&sysirq>;
> > > +	#address-cells = <2>;
> > > +	#size-cells = <2>;
> > > +
> > > +	cpu-map {
> > 
> > This should live under /cpus, as documented in
> > Documentation/devicetree/bindings/arm/topology.txt.
> 
> Got it, fix next version
> 
> > > +
> > > +	psci {
> > > +		compatible = "arm,psci-0.2";
> > > +		method = "smc";
> > > +	};
> > 
> > What are you using as your PSCI 0.2 implementation?
> > 
> > Is it fully compliant? (e.g. are the reset and power off functions
> > implemented, may CPU0 be hotplugged)?
> > 
> > Given only portions of the GIC seem to be described below, what
> > exception level is your kernel entered at? Per the spec it should be
> > EL2, but given the brokenness below with the GIC I'm suspicious.
> > 
> 
> Currently we only implement CPU boot, no power off, no CPU0 hotplug
> either. And enter kernel at EL2. Actually, we run ATF in EL3, then
> switch to EL2 to run lk and kernel.

Ok. In the absence of CPU_OFF, this is not yet a conforming PSCI 0.2
implementation, so I'm wary of marking this as PSCI 0.2 until that is
the case. Any attempt to power of CPUs will hit a BUG() in cpu_die(),
and we don't want that.

Is CPU0 hotplug planned?

If not, does your PSCI implementation report CPU0 as
non-hotpluggable via MIGRATE_INFO_TYPE reporting a UP not migratable
trusted OS (and MIGRATE_INFO_UP_CPU reporting CPU0 as the resident CPU)?

Are SYSTEM_OFF and SYSTEM_RESET available?

Thanks,
Mark.
