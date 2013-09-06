Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751771Ab3IFTxb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 15:53:31 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:43512 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395Ab3IFTx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 15:53:29 -0400
Date: Fri, 6 Sep 2013 14:53:00 -0500
From: Josh Cartwright <joshc@codeaurora.org>
To: Rohit Vaswani <rvaswani@codeaurora.org>
Cc: David Brown <davidb@codeaurora.org>, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Russell King <linux@arm.linux.org.uk>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCHv3 1/2] ARM: msm: Add support for APQ8074 Dragonboard
Message-ID: <20130906195300.GJ808@joshc.qualcomm.com>
References: <1378495943-2572-1-git-send-email-rvaswani@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378495943-2572-1-git-send-email-rvaswani@codeaurora.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 06, 2013 at 12:32:22PM -0700, Rohit Vaswani wrote:
> This patch adds basic board support for APQ8074 Dragonboard
> which belongs to the Snapdragon 800 family.
> For now, just support a basic machine with device tree.
> 
> Signed-off-by: Rohit Vaswani <rvaswani@codeaurora.org>
> ---
[..]
> index 0000000..5b7b6a0
> --- /dev/null
> +++ b/arch/arm/boot/dts/apq8074-dragonboard.dts
> @@ -0,0 +1,6 @@
> +/include/ "msm8974.dtsi"
> +
> +/ {
> +	model = "Qualcomm APQ8074 Dragonboard";
> +	compatible = "qcom,apq8074-dragonboard", "qcom,apq8074";
> +};
> diff --git a/arch/arm/boot/dts/msm8974.dtsi b/arch/arm/boot/dts/msm8974.dtsi
> new file mode 100644
> index 0000000..f04b643
> --- /dev/null
> +++ b/arch/arm/boot/dts/msm8974.dtsi
> @@ -0,0 +1,35 @@
> +/dts-v1/;
> +
> +/include/ "skeleton.dtsi"
> +
> +/ {
> +	model = "Qualcomm MSM8974";
> +	compatible = "qcom,msm8974";
> +	interrupt-parent = <&intc>;
> +
> +	soc: soc { };
> +};
> +
> +&soc {

Breaking these up seems a little odd to me, but okay.

> +	#address-cells = <1>;
> +	#size-cells = <1>;
> +	ranges;
> +	compatible = "simple-bus";
> +
> +	intc: interrupt-controller@f9000000 {
> +		compatible = "qcom,msm-qgic2";
> +		interrupt-controller;
> +		#interrupt-cells = <3>;
> +		reg = <0xf9000000 0x1000>,
> +		      <0xf9002000 0x1000>;
> +	};
> +
> +	timer {
> +		compatible = "arm,armv7-timer";
> +		interrupts = <1 2 0xf08>,
> +			     <1 3 0xf08>,
> +			     <1 4 0xf08>,
> +			     <1 1 0xf08>;
> +		clock-frequency = <19200000>;
> +	};
> +};
> diff --git a/arch/arm/mach-msm/Kconfig b/arch/arm/mach-msm/Kconfig
> index 905efc8..499e8fe 100644
> --- a/arch/arm/mach-msm/Kconfig
> +++ b/arch/arm/mach-msm/Kconfig
[..]
> +config ARCH_MSM8974
> +	bool "MSM8974"
> +	select ARM_GIC
> +	select CPU_V7
> +	select HAVE_ARM_ARCH_TIMER
> +	select HAVE_SMP
> +	select MSM_SCM if SMP
> +	select USE_OF
> +
> +config ARCH_MSM_DT
> +	def_bool y
> +	depends on (ARCH_MSM8X60 || ARCH_MSM8960 || ARCH_MSM8974)
> +

Selecting _only_ ARCH_MSM8974 with these changes breaks the build with:

scripts/kconfig/conf --silentoldconfig Kconfig
#
# configuration written to .config
#
  CHK     include/generated/uapi/linux/version.h
  CHK     include/generated/utsrelease.h
make[1]: `include/generated/mach-types.h' is up to date.
  CC      arch/arm/kernel/asm-offsets.s
  GEN     include/generated/asm-offsets.h
  CALL    scripts/checksyscalls.sh
  CC      init/main.o
In file included from arch/arm/include/asm/irq.h:7:0,
                 from arch/arm/include/asm/hardirq.h:6,
                 from include/linux/hardirq.h:8,
                 from include/linux/ftrace_event.h:7,
                 from include/trace/syscall.h:6,
                 from include/linux/syscalls.h:79,
                 from init/main.c:18:
arch/arm/mach-msm/include/mach/irqs.h:35:2: error: #error "Unknown architecture specification"
 #error "Unknown architecture specification"
  ^
arch/arm/mach-msm/include/mach/irqs.h:38:18: error: 'NR_MSM_IRQS' undeclared here (not in a function)
 #define NR_IRQS (NR_MSM_IRQS + NR_GPIO_IRQS + NR_BOARD_IRQS)
                  ^
include/linux/irqdesc.h:76:33: note: in expansion of macro 'NR_IRQS'
 extern struct irq_desc irq_desc[NR_IRQS];
                                 ^
arch/arm/mach-msm/include/mach/irqs.h:38:32: error: 'NR_GPIO_IRQS' undeclared here (not in a function)
 #define NR_IRQS (NR_MSM_IRQS + NR_GPIO_IRQS + NR_BOARD_IRQS)
                                ^
include/linux/irqdesc.h:76:33: note: in expansion of macro 'NR_IRQS'
 extern struct irq_desc irq_desc[NR_IRQS];
                                 ^
arch/arm/mach-msm/include/mach/irqs.h:38:47: error: 'NR_BOARD_IRQS' undeclared here (not in a function)
 #define NR_IRQS (NR_MSM_IRQS + NR_GPIO_IRQS + NR_BOARD_IRQS)
                                               ^
include/linux/irqdesc.h:76:33: note: in expansion of macro 'NR_IRQS'
 extern struct irq_desc irq_desc[NR_IRQS];
                                 ^
make[1]: *** [init/main.o] Error 1
make: *** [init] Error 2

  Josh

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
