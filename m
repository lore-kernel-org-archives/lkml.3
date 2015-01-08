Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756102AbbAHVTR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 16:19:17 -0500
Received: from mail-wg0-f47.google.com ([74.125.82.47]:48175 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752315AbbAHVTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 16:19:15 -0500
MIME-Version: 1.0
In-Reply-To: <1420681257-3078-3-git-send-email-cw00.choi@samsung.com>
References: <1420681257-3078-1-git-send-email-cw00.choi@samsung.com> <1420681257-3078-3-git-send-email-cw00.choi@samsung.com>
From: Rob Herring <robherring2@gmail.com>
Date: Thu, 8 Jan 2015 15:18:53 -0600
Message-ID: <CAL_Jsq+5sdsm_-VW-ta+qV-NBao-XTHvsYWcbMdZmbP0Nw43Cw@mail.gmail.com>
Subject: Re: [PATCHv3 2/8] devfreq: exynos: Add documentation for generic
 exynos memory bus frequency driver
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: myungjoo.ham@samsung.com, kgene@kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        Mark Rutland <mark.rutland@arm.com>, a.kesavan@samsung.com,
        Tomasz Figa <tomasz.figa@gmail.com>, k.kozlowski@samsung.com,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Rob Herring <robh+dt@kernel.org>, InKi Dae <inki.dae@samsung.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        Viresh Kumar <viresh.kumar@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding Viresh.

On Wed, Jan 7, 2015 at 7:40 PM, Chanwoo Choi <cw00.choi@samsung.com> wrote:
> This patch adds the documentation for generic exynos memory bus frequency
> driver.
>
> Cc: MyungJoo Ham <myungjoo.ham@samsung.com>
> Cc: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Kukjin Kim <kgene@kernel.org>
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> ---
>  .../devicetree/bindings/devfreq/exynos-busfreq.txt | 184 +++++++++++++++++++++
>  1 file changed, 184 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/devfreq/exynos-busfreq.txt
>
> diff --git a/Documentation/devicetree/bindings/devfreq/exynos-busfreq.txt b/Documentation/devicetree/bindings/devfreq/exynos-busfreq.txt
> new file mode 100644
> index 0000000..c601e88
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/devfreq/exynos-busfreq.txt
> @@ -0,0 +1,184 @@
> +
> +* Generic Exynos Memory Bus device
> +
> +The Samsung Exynos SoCs have many memory buses for data transfer between DRAM
> +memory and MMC/sub-IP in SoC. Almost Exynos SoCs have the common architecture
> +for memory buses. Generally, Exynos SoC express the memory bus by using memory
> +bus group and block. The memory bus group has one more memory bus blocks and
> +OPP table (including frequency and voltage for DVFS), regulator, devfreq-event
> +devices. Each memory bus block has a clock for own memory bus speen and
> +frequency table for DVFS. There are a little different among Exynos SoCs
> +because each Exynos SoC has the different sub-IP and differnt memory bus.
> +So, this difference should be specified in devicetree file.
> +
> +Required properties for memory bus group:
> +- compatible: Should be "samsung,exynos-memory-bus".
> +- operating-points: the OPP table including frequency/voltage information to
> +                  support DVFS (Dynamic Voltage/Frequency Scaling) feature.
> +- devfreq-events: the devfreq-event device to monitor the curret state of
> +                  memory bus group.

I don't understand what goes in here.

> +- vdd-mem-supply: the regulator to provide memory bus group with the voltage.
> +
> +Required properties for memory bus block:
> +- clock-names : the name of clock used by the memory bus, "memory-bus".
> +- clocks : phandles for clock specified in "clock-names" property.
> +- #clock-cells: should be 1.
> +- frequency: the frequency table to support DVFS feature.

So you have just defined a new OPP table format. We already have one
and Viresh is working to create a more extendable one. He asked about
what's needed in devfreq, so Viresh here you go. :)

> +
> +Example1 : Memory bus group/block in exynos3250.dtsi are listed below.
> +       Exynos3250 has two memory bus group (MIF, INT group). MIF memory bus
> +       group includes one memory bus block between DRAM and eMMC. Also, INT
> +       memory bus group includes eight memory bus blocks which support each
> +       sub-IPs between DRAM and sub-IPs.
> +
> +       memory_bus_mif: memory_bus@0 {
> +               compatible = "samsung,exynos-memory-bus";
> +
> +               operating-points = <
> +                       400000 875000
> +                       200000 800000
> +                       133000 800000
> +                       100000 800000
> +                       50000  800000>;
> +               status = "disabled";

Why is this not part of the DDR controller or /memory node?

> +               blocks {
> +                       dmc_block: memory_bus_block1 {
> +                               clocks = <&cmu_dmc CLK_DIV_DMC>;
> +                               clock-names = "memory-bus";
> +                               frequency = <
> +                                       400000
> +                                       200000
> +                                       133000
> +                                       100000
> +                                       50000>;

This is just duplicated from the operating-points table.

> +                       };
> +               };
> +       };
> +
> +       memory_bus_int: memory_bus@1 {
> +               compatible = "samsung,exynos-memory-bus";
> +
> +               operating-points = <
> +                       400000 950000
> +                       200000 950000
> +                       133000 925000
> +                       100000 850000
> +                       80000  850000
> +                       50000  850000>;
> +
> +               status = "disabled";
> +
> +               blocks {
> +                       peri_block: memory_bus_block1 {

Why is this and the following nodes not part of the respective
peripheral nodes or buses. If you need more hierarchy in your bus add
that to DT first. I'm sure just a flat "simple-bus" was done which
doesn't reflect the actual bus and now you need it to.

> +                               clocks = <&cmu CLK_DIV_ACLK_100>;
> +                               clock-names = "memory-bus";
> +                               frequency = <
> +                                       100000
> +                                       100000
> +                                       100000
> +                                       100000
> +                                       50000
> +                                       50000>;
> +                       };

This just looks like constraints on the clock frequency. This should
be added in a standard way to the clock binding.


> +
> +                       display_block: memory_bus_block2 {
> +                               clocks = <&cmu CLK_DIV_ACLK_160>;
> +                               clock-names = "memory-bus";
> +                               frequency = <
> +                                       200000
> +                                       160000
> +                                       100000
> +                                       80000
> +                                       80000
> +                                       50000>;
> +                       };
> +
> +                       isp_block: memory_bus_block3 {
> +                               clocks = <&cmu CLK_DIV_ACLK_200>;
> +                               clock-names = "memory-bus";
> +                               frequency = <
> +                                       200000
> +                                       200000
> +                                       100000
> +                                       80000
> +                                       50000
> +                                       50000>;
> +                       };
> +
> +                       gps_block: memory_bus_block4 {
> +                               clocks = <&cmu CLK_DIV_ACLK_266>;
> +                               clock-names = "memory-bus";
> +                               frequency = <
> +                                       300000
> +                                       200000
> +                                       133000
> +                                       100000
> +                                       50000
> +                                       50000>;
> +                       };
> +
> +                       mcuisp_block: memory_bus_block5 {
> +                               clocks = <&cmu CLK_DIV_ACLK_400_MCUISP>;
> +                               clock-names = "memory-bus";
> +                               frequency = <
> +                                       400000
> +                                       200000
> +                                       50000
> +                                       50000
> +                                       50000
> +                                       50000>;
> +                       };
> +
> +                       leftbus_block: memory_bus_block6 {
> +                               clocks = <&cmu CLK_DIV_GDL>;
> +                               clock-names = "memory-bus";
> +                               frequency = <
> +                                       200000
> +                                       200000
> +                                       133000
> +                                       100000
> +                                       100000
> +                                       100000>;
> +                       };
> +
> +                       rightbus_block: memory_bus_block7 {
> +                               clocks = <&cmu CLK_DIV_GDR>;
> +                               clock-names = "memory-bus";
> +                               frequency = <
> +                                       200000
> +                                       200000
> +                                       133000
> +                                       100000
> +                                       100000
> +                                       100000>;
> +                       };
> +
> +                       mfc_block: memory_bus_block8 {
> +                               clocks = <&cmu CLK_SCLK_MFC>;
> +                               clock-names = "memory-bus";
> +                               frequency = <
> +                                       200000
> +                                       200000
> +                                       200000
> +                                       133000
> +                                       100000
> +                                       80000>;
> +                       };
> +               };
> +       };
> +
> +Example2 : Usage case to handle the frequency/voltage of memory bus on runtime
> +       in exynos3250-rinato.dts are listed below.
> +
> +       &memory_bus_mif {
> +               devfreq-events = <&ppmu_dmc0_3>, <&ppmu_dmc1_3>;
> +               vdd-mem-supply = <&buck1_reg>;
> +               status = "okay";
> +       };
> +
> +       &memory_bus_int {
> +               devfreq-events = <&ppmu_leftbus_3>, <&ppmu_rightbus_3>;
> +               vdd-mem-supply = <&buck3_reg>;
> +               status = "okay";
> +       };
> --
> 1.8.5.5
>
