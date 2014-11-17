Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751881AbaKQLPA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 06:15:00 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:59156 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236AbaKQLO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 06:14:59 -0500
Date: Mon, 17 Nov 2014 11:14:50 +0000
From: Will Deacon <will.deacon@arm.com>
To: Mark Rutland <mark.rutland@arm.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 07/11] arm: perf: document PMU affinity binding
Message-ID: <20141117111450.GD18061@arm.com>
References: <1415377536-12841-1-git-send-email-mark.rutland@arm.com>
 <1415377536-12841-8-git-send-email-mark.rutland@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415377536-12841-8-git-send-email-mark.rutland@arm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Fri, Nov 07, 2014 at 04:25:32PM +0000, Mark Rutland wrote:
> To describe the various ways CPU PMU interrupts might be wired up, we
> can refer to the topology information in the device tree.
> 
> This patch adds a new property to the PMU binding, interrupts-affinity,
> which describes the relationship between CPUs and interrupts. This
> information is necessary to handle systems with heterogeneous PMU
> implementations (e.g. big.LITTLE). Documentation is added describing the
> use of said property.

I'm not entirely comfortable with using interrupt affinity to convey
PMU affinity. It seems perfectly plausible for somebody to play the usual
trick of ORing all the irq lines together, despite having a big/little
PMU configuration.

Can you describe such a system with this binding?

> +Example 2 (Multiple clusters with single interrupts):
> +
> +cpus {
> +	#address-cells = <1>;
> +	#size-cells = <1>;
> +
> +	CPU0: cpu@0 {
> +		reg = <0x0>;
> +		compatible = "arm,cortex-a15-pmu";
> +	};
> +
> +	CPU1: cpu@1 {
> +		reg = <0x1>;
> +		compatible = "arm,cotex-a15-pmu";

cortex

> +	};
> +
> +	CPU100: cpu@100 {
> +		reg = <0x100>;
> +		compatible = "arm,cortex-a7-pmu";
> +	};
> +
> +	cpu-map {
> +		cluster0 {
> +			CORE_0_0: core0 {
> +				cpu = <&CPU0>;
> +			};
> +			CORE_0_1: core1 {
> +				cpu = <&CPU1>;
> +			};
> +		};
> +		cluster1 {
> +			CORE_1_0: core0 {
> +				cpu = <&CPU100>;
> +			};
> +		};
> +	};
> +};
> +
> +pmu_a15 {
> +	compatible = "arm,cortex-a15-pmu";
> +	interrupts = <100>, <101>;
> +	interrupts-affinity = <&CORE0>, <&CORE1>;
> +};
> +
> +pmu_a7 {
> +	compatible = "arm,cortex-a7-pmu";
> +	interrupts = <105>;
> +	interrupts-affinity = <&CORE_1_0>;
> +};
> +
> +Example 3 (Multiple clusters with per-cpu interrupts):
> +
> +cpus {
> +	#address-cells = <1>;
> +	#size-cells = <1>;
> +
> +	CPU0: cpu@0 {
> +		reg = <0x0>;
> +		compatible = "arm,cortex-a15-pmu";
> +	};
> +
> +	CPU1: cpu@1 {
> +		reg = <0x1>;
> +		compatible = "arm,cotex-a15-pmu";

Same here.

Will
