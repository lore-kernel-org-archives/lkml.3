Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751175AbaLOLLo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 06:11:44 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:57426 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750704AbaLOLLl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 06:11:41 -0500
Date: Mon, 15 Dec 2014 11:07:06 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Howard Chen <howard.chen@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <Pawel.Moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] ARM: dts: mt8173: Add psci cpuidle support
Message-ID: <20141215110706.GD462@leverpostej>
References: <1418633948-2513-1-git-send-email-howard.chen@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418633948-2513-1-git-send-email-howard.chen@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 15, 2014 at 08:59:08AM +0000, Howard Chen wrote:
> add device tree for psci-0.2 on mt8173 platform
> add device tree for cupidle-arm64 on mt8173 platform
> 
> Signed-off-by: Howard Chen <howard.chen@linaro.org>
> ---
>  arch/arm64/boot/dts/mt8173.dtsi | 51 +++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 51 insertions(+)
> 
> diff --git a/arch/arm64/boot/dts/mt8173.dtsi b/arch/arm64/boot/dts/mt8173.dtsi
> index 79b7e46..c5e1127 100644
> --- a/arch/arm64/boot/dts/mt8173.dtsi
> +++ b/arch/arm64/boot/dts/mt8173.dtsi
> @@ -44,6 +44,11 @@
>  		};
>  	};
>  
> +	psci {
> +		compatible = "arm,psci-0.2";
> +		method = "smc";
> +	};
> +
>  	cpus {
>  		#address-cells = <1>;
>  		#size-cells = <0>;
> @@ -54,6 +59,7 @@
>  			reg = <0x000>;
>  			enable-method = "mt-boot";

What is "mt-boot", and why is this not "psci"?

What tree is this based on?

The additions for idle look fine as of themselves, but we shouldn't
require non-standard enable method code with PSCI.

Mark.

>  			cpu-release-addr = <0x0 0x40000200>;
> +			cpu-idle-states = <&CPU_SLEEP_1_0 &CLUSTER_SLEEP_1>;
>  		};
>  
>  		cpu1: cpu@1 {
> @@ -62,6 +68,7 @@
>  			reg = <0x001>;
>  			enable-method = "mt-boot";
>  			cpu-release-addr = <0x0 0x40000200>;
> +			cpu-idle-states = <&CPU_SLEEP_1_0 &CLUSTER_SLEEP_1>;
>  		};
>  
>  		cpu2: cpu@2 {
> @@ -70,6 +77,7 @@
>  			reg = <0x100>;
>  			enable-method = "mt-boot";
>  			cpu-release-addr = <0x0 0x40000200>;
> +			cpu-idle-states = <&CPU_SLEEP_0_0 &CLUSTER_SLEEP_0>;
>  		};
>  
>  		cpu3: cpu@3 {
> @@ -78,8 +86,51 @@
>  			reg = <0x101>;
>  			enable-method = "mt-boot";
>  			cpu-release-addr = <0x0 0x40000200>;
> +			cpu-idle-states = <&CPU_SLEEP_0_0 &CLUSTER_SLEEP_0>;
>  		};
>  
> +		idle-states {
> +			entry-method = "arm,psci-0.2";
> +
> +			CPU_SLEEP_0_0: cpu-sleep-0-0 {
> +				compatible = "arm,idle-state";
> +				local-timer-stop;
> +				arm,psci-suspend-param = <0x0010000>;
> +				entry-latency-us = <250>;
> +				exit-latency-us = <500>;
> +				min-residency-us = <950>;
> +			};
> +
> +			CLUSTER_SLEEP_0: cluster-sleep-0 {
> +				compatible = "arm,idle-state";
> +				local-timer-stop;
> +				arm,psci-suspend-param = <0x1010000>;
> +				entry-latency-us = <600>;
> +				exit-latency-us = <1100>;
> +				min-residency-us = <2700>;
> +				wakeup-latency-us = <1500>;
> +			};
> +
> +			CPU_SLEEP_1_0: cpu-sleep-1-0 {
> +				compatible = "arm,idle-state";
> +				local-timer-stop;
> +				arm,psci-suspend-param = <0x0010000>;
> +				entry-latency-us = <70>;
> +				exit-latency-us = <100>;
> +				min-residency-us = <300>;
> +				wakeup-latency-us = <150>;
> +			};
> +
> +			CLUSTER_SLEEP_1: cluster-sleep-1 {
> +				compatible = "arm,idle-state";
> +				local-timer-stop;
> +				arm,psci-suspend-param = <0x1010000>;
> +				entry-latency-us = <500>;
> +				exit-latency-us = <1200>;
> +				min-residency-us = <3500>;
> +				wakeup-latency-us = <1300>;
> +			};
> +		};
>  	};
>  
>  	clocks {
> -- 
> 1.9.1
> 
> 
