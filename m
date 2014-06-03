Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753072AbaFCKJi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 06:09:38 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:60232 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751747AbaFCKJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 06:09:35 -0400
Date: Tue, 3 Jun 2014 11:08:53 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Alex Elder <elder@linaro.org>
Cc: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "rdunlap@infradead.org" <rdunlap@infradead.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        "gregory.clement@free-electrons.com" 
	<gregory.clement@free-electrons.com>,
        "rvaswani@codeaurora.org" <rvaswani@codeaurora.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RESEND] devicetree: bindings: separate CPU enable method
 descriptions
Message-ID: <20140603100853.GB1310@leverpostej>
References: <1401487914-21016-1-git-send-email-elder@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401487914-21016-1-git-send-email-elder@linaro.org>
Thread-Topic: [PATCH RESEND] devicetree: bindings: separate CPU enable method
 descriptions
Accept-Language: en-GB, en-US
Content-Language: en-US
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alex,

On Fri, May 30, 2014 at 11:11:54PM +0100, Alex Elder wrote:
> The bindings for CPU enable methods are defined in ".../arm/cpus.txt".  As
> additional 32-bit ARM CPUS are converted to use the "enable-method" CPU
> property to imply a particular set of SMP operations to use, the list of these
> methods is likely to become unwieldy.  The current documentation already
> contains several property descriptions that are meaningful only for certain
> enable methods.
>
> This patch defines a new Documentation subdirectory whose purpose is to give
> each CPU enable method its own place to define how and when it's used, as
> well as what other properties (optional or required) are associated with
> the method.  The existing enable method documentation is expanded and moved
> from ".../arm/cpus.txt" into new files accordingly.
>
> Signed-off-by: Alex Elder <elder@linaro.org>
> ---
> v2:  Rename "arm,psci.txt" to be "psci.txt" and fix its content
>
>  .../bindings/arm/cpu-enable-method/README          | 20 +++++
>  .../bindings/arm/cpu-enable-method/psci.txt        | 45 ++++++++++
>  .../arm/cpu-enable-method/qcom,gcc-msm8660         | 30 +++++++
>  .../arm/cpu-enable-method/qcom,kpss-acc-v1         | 56 +++++++++++++
>  .../arm/cpu-enable-method/qcom,kpss-acc-v2         | 56 +++++++++++++
>  .../bindings/arm/cpu-enable-method/spin-table.txt  | 95 ++++++++++++++++++++++
>  Documentation/devicetree/bindings/arm/cpus.txt     | 29 +------
>  7 files changed, 305 insertions(+), 26 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/arm/cpu-enable-method/README
>  create mode 100644 Documentation/devicetree/bindings/arm/cpu-enable-method/psci.txt
>  create mode 100644 Documentation/devicetree/bindings/arm/cpu-enable-method/qcom,gcc-msm8660
>  create mode 100644 Documentation/devicetree/bindings/arm/cpu-enable-method/qcom,kpss-acc-v1
>  create mode 100644 Documentation/devicetree/bindings/arm/cpu-enable-method/qcom,kpss-acc-v2
>  create mode 100644 Documentation/devicetree/bindings/arm/cpu-enable-method/spin-table.txt
>
> diff --git a/Documentation/devicetree/bindings/arm/cpu-enable-method/README b/Documentation/devicetree/bindings/arm/cpu-enable-method/README
> new file mode 100644
> index 0000000..cc9431e
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/arm/cpu-enable-method/README
> @@ -0,0 +1,20 @@
> +==========================
> +CPU enable-method bindings
> +==========================
> +
> +The device tree describes the layout of CPUs in a machine in a single "cpus"
> +node, which in turn contains a number of "cpu" sub-nodes defining properties
> +for each cpu.
> +
> +For multiprocessing configurations, CPU cores can be individually enabled
> +and disabled.  The enabling capability is used for SMP startup as well as
> +CPU hotplug.  A CPU enable method--normally specified in the device tree
> +using an "enable-method" property--defines how cores are enabled.  If all
> +CPUs in a machine use the same enable method and related property values,
> +these properties should be defined in the "cpus" node, which associates the
> +property values with all CPUs.  Alternatively, every "cpu" node can define
> +its "enable-method" separately.
> +
> +Documents in this directory define how each of the CPU enable methods are to
> +be used, as well the names and possible values of related properties that
> +are required by or affect each enable method.
> diff --git a/Documentation/devicetree/bindings/arm/cpu-enable-method/psci.txt b/Documentation/devicetree/bindings/arm/cpu-enable-method/psci.txt
> new file mode 100644
> index 0000000..68b26c2
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/arm/cpu-enable-method/psci.txt
> @@ -0,0 +1,45 @@
> +================================
> +CPU enable-method "psci" binding
> +================================
> +
> +This document describes the "psci" method for enabling secondary CPUs.  A
> +"psci" enable method is supported only in individual "cpu" nodes (even if
> +       all CPU cores use the "psci" enable method).
> +
> +Enable method name:    "psci"
> +Compatible cpus:       "arm,cortex-a57" (?)

Any CPU with the security extensions or hypervisor extensions may
support PSCI. So far, implementations exist for at Cortex-A{7,15,53,57},
in addition to AEMs.

> +Related properties:    (none)
> +
> +Note:
> +This enable method is only available if a valid PSCI node[1] (compatible
> +with "arm,psci") is present in the device tree, and it defines a "cpu_on"
> +property.
> +
> +Example (contrived 2-core ARM Cortex-A57 64-bit system):
> +
> +       psci {
> +               compatible = "arm,psci";
> +               method = "smc";
> +               cpu_on = 0x1;

Missing '<' and '>'.

> +       };
> +       cpus {
> +               #size-cells = <0>;
> +               #address-cells = <2>;
> +
> +               cpu@0 {
> +                       device_type = "cpu";
> +                       compatible = "arm,cortex-a57";
> +                       reg = <0x0 0x0>;
> +                       enable-method = "psci";
> +               };
> +
> +               cpu@1 {
> +                       device_type = "cpu";
> +                       compatible = "arm,cortex-a57";
> +                       reg = <0x0 0x1>;
> +                       enable-method = "psci";
> +               };
> +       };
> +
> +--
> +[1] arm/psci.txt

It may be worth folding the existing PSCI binding document in with the
enable-method portion.

> diff --git a/Documentation/devicetree/bindings/arm/cpu-enable-method/qcom,gcc-msm8660 b/Documentation/devicetree/bindings/arm/cpu-enable-method/qcom,gcc-msm8660
> new file mode 100644
> index 0000000..b19f51c
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/arm/cpu-enable-method/qcom,gcc-msm8660
> @@ -0,0 +1,30 @@
> +======================================================
> +Secondary CPU enable-method "qcom,gcc-msm8660" binding
> +======================================================
> +
> +This document describes the "qcom,gcc-msm8660" method for enabling secondary
> +CPUs.  A "qcom,gcc-msm8660" enable method should only be used in the "cpus"
> +node, to apply to all CPUs.
> +
> +Enable method name:    "qcom,gcc-msm8660"
> +Compatible cpu:                "qcom,scorpion"
> +Related properties:    (none)

>From a look at the code, we need a node compatible with
"qcom,gcc-msm8660" somewhere in the tree (see scss_release_secondary).
It would be good to mention that.

[...]

> diff --git a/Documentation/devicetree/bindings/arm/cpu-enable-method/spin-table.txt b/Documentation/devicetree/bindings/arm/cpu-enable-method/spin-table.txt
> new file mode 100644
> index 0000000..aee3617
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/arm/cpu-enable-method/spin-table.txt
> @@ -0,0 +1,95 @@
> +================================================
> +Secondary CPU enable-method "spin-table" binding
> +================================================
> +
> +This document describes the "spin-table" method for enabling secondary CPUs.
> +A "spin-table" enable method can be used in either the "cpus" node or in
> +individual "cpu" nodes.
> +
> +Enable method name:    "spin-table"
> +Compatible cpus:       "arm,cortex-a57" (?)

Any CPU with AArch64 may support this.

> +Related properties:
> +       - cpu-release-addr
> +               Usage:          required
> +               Value type:     <prop-encoded-array>

Just say it's a 64-bit value, "prop-encoded-array" isn't all that
helpful.

> +               Definition:
> +                       A two cell value identifying a 64-bit memory location
> +                       used by the boot CPU to inform a secondary CPU it
> +                       should begin its kernel bootstrap.  Memory at this
> +                       location must initially be zeroed.
> +
> +Examples (contrived 4-core ARM Cortex-A57 64-bit systems):
> +
> +The first example uses the same enable method for all cores.
> +
> +       cpus {
> +               #size-cells = <0>;
> +               #address-cells = <2>;
> +               enable-method = "spin-table";
> +               cpu-release-addr = <0 0x20000000>;

Linux currently expects this to be described per-cpu, and does not
support either of these properties this being defined in /cpus for
arm64.

I would also very much like to discourage using a single release address
-- it means we can only throw all CPUs into the kernel pen, where some
may have to sit forever (breaking things like kexec). Ideally if a
system has to use spin-table the addresses should be unique.

So could we just have the example with unique addresses please?

[...]

Otherwise, this looks like a good first step. It would be nice to see
some qcom folk review the qcom documentation changes.

Mark.
