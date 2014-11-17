Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752360AbaKQOdU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 09:33:20 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:63743 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647AbaKQOdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 09:33:19 -0500
MIME-Version: 1.0
In-Reply-To: <1415377536-12841-8-git-send-email-mark.rutland@arm.com>
References: <1415377536-12841-1-git-send-email-mark.rutland@arm.com> <1415377536-12841-8-git-send-email-mark.rutland@arm.com>
From: Rob Herring <robherring2@gmail.com>
Date: Mon, 17 Nov 2014 08:32:57 -0600
Message-ID: <CAL_Jsq+u9--tP-pYBut0V6oAnRDbwqpaJ9UMyW55AhCNFV10sA@mail.gmail.com>
Subject: Re: [PATCH 07/11] arm: perf: document PMU affinity binding
To: Mark Rutland <mark.rutland@arm.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Will Deacon <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 7, 2014 at 10:25 AM, Mark Rutland <mark.rutland@arm.com> wrote:
> To describe the various ways CPU PMU interrupts might be wired up, we
> can refer to the topology information in the device tree.
>
> This patch adds a new property to the PMU binding, interrupts-affinity,
> which describes the relationship between CPUs and interrupts. This
> information is necessary to handle systems with heterogeneous PMU
> implementations (e.g. big.LITTLE). Documentation is added describing the
> use of said property.
>
> Signed-off-by: Mark Rutland <mark.rutland@arm.com>
> ---
>  Documentation/devicetree/bindings/arm/pmu.txt | 104 +++++++++++++++++++++++++-
>  1 file changed, 103 insertions(+), 1 deletion(-)
>
> diff --git a/Documentation/devicetree/bindings/arm/pmu.txt b/Documentation/devicetree/bindings/arm/pmu.txt
> index 75ef91d..23a0675 100644
> --- a/Documentation/devicetree/bindings/arm/pmu.txt
> +++ b/Documentation/devicetree/bindings/arm/pmu.txt
> @@ -24,12 +24,114 @@ Required properties:
>
>  Optional properties:
>
> +- interrupts-affinity : A list of phandles to topology nodes (see topology.txt) describing
> +            the set of CPUs associated with the interrupt at the same index.

Are there cases beyond PMUs we need to handle? I would think so, so we
should document this generically.

>  - qcom,no-pc-write : Indicates that this PMU doesn't support the 0xc and 0xd
>                       events.
>
> -Example:
> +Example 1 (A single CPU):

Isn't this a single cluster of 2 cpus?

>
>  pmu {
>          compatible = "arm,cortex-a9-pmu";
>          interrupts = <100 101>;
>  };
> +
> +Example 2 (Multiple clusters with single interrupts):

The meaning of single could be made a bit more clear especially if you
consider Will's case. But I haven't really thought of better
wording...

> +
> +cpus {
> +       #address-cells = <1>;
> +       #size-cells = <1>;
> +
> +       CPU0: cpu@0 {
> +               reg = <0x0>;
> +               compatible = "arm,cortex-a15-pmu";
> +       };
> +
> +       CPU1: cpu@1 {
> +               reg = <0x1>;
> +               compatible = "arm,cotex-a15-pmu";
> +       };
> +
> +       CPU100: cpu@100 {
> +               reg = <0x100>;
> +               compatible = "arm,cortex-a7-pmu";
> +       };
> +
> +       cpu-map {
> +               cluster0 {
> +                       CORE_0_0: core0 {
> +                               cpu = <&CPU0>;
> +                       };
> +                       CORE_0_1: core1 {
> +                               cpu = <&CPU1>;
> +                       };
> +               };
> +               cluster1 {
> +                       CORE_1_0: core0 {
> +                               cpu = <&CPU100>;
> +                       };
> +               };
> +       };
> +};
> +
> +pmu_a15 {
> +       compatible = "arm,cortex-a15-pmu";
> +       interrupts = <100>, <101>;
> +       interrupts-affinity = <&CORE0>, <&CORE1>;

The phandle names are wrong here.

> +};
> +
> +pmu_a7 {
> +       compatible = "arm,cortex-a7-pmu";
> +       interrupts = <105>;
> +       interrupts-affinity = <&CORE_1_0>;
> +};
> +
> +Example 3 (Multiple clusters with per-cpu interrupts):
> +
> +cpus {
> +       #address-cells = <1>;
> +       #size-cells = <1>;
> +
> +       CPU0: cpu@0 {
> +               reg = <0x0>;
> +               compatible = "arm,cortex-a15-pmu";
> +       };
> +
> +       CPU1: cpu@1 {
> +               reg = <0x1>;
> +               compatible = "arm,cotex-a15-pmu";
> +       };
> +
> +       CPU100: cpu@100 {
> +               reg = <0x100>;
> +               compatible = "arm,cortex-a7-pmu";
> +       };
> +
> +       cpu-map {
> +               CLUSTER0: cluster0 {
> +                       core0 {
> +                               cpu = <&CPU0>;
> +                       };
> +                       core1 {
> +                               cpu = <&CPU1>;
> +                       };
> +               };
> +               CLUSTER1: cluster1 {
> +                        core0 {
> +                               cpu = <&CPU100>;
> +                       };
> +               };
> +       };
> +};
> +
> +pmu_a15 {
> +       compatible = "arm,cortex-a15-pmu";
> +       interrupts = <100>;
> +       interrupts-affinity = <&CLUSTER0>;
> +};
> +
> +pmu_a7 {
> +       compatible = "arm,cortex-a7-pmu";
> +       interrupts = <105>;
> +       interrupts-affinity = <&CLUSTER1>;
> +};
> --
> 1.9.1
>
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
