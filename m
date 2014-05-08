Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754757AbaEHPNu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 11:13:50 -0400
Received: from mail-ve0-f179.google.com ([209.85.128.179]:33880 "EHLO
	mail-ve0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625AbaEHPNs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 11:13:48 -0400
MIME-Version: 1.0
In-Reply-To: <1399505033-3368-1-git-send-email-elder@linaro.org>
References: <1399505033-3368-1-git-send-email-elder@linaro.org>
Date: Thu, 8 May 2014 10:13:47 -0500
Message-ID: <CAL_JsqKoe6dz6Ncr4nKs8+6u6pZNtcyuVQpjwKenY2nHv-=Yfw@mail.gmail.com>
Subject: Re: [PATCH] devicetree: bindings: separate CPU enable method descriptions
From: Rob Herring <robherring2@gmail.com>
To: Alex Elder <elder@linaro.org>
Cc: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Rohit Vaswani <rvaswani@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 7, 2014 at 6:23 PM, Alex Elder <elder@linaro.org> wrote:
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

Please use get_maintainers.pl and copy those people.

> ---
> This series is available here:
>         http://git.linaro.org/landing-teams/working/broadcom/kernel.git
>         Branch review/enable-method-bindings
>
>  .../bindings/arm/cpu-enable-method/README          | 20 +++++
>  .../bindings/arm/cpu-enable-method/arm,psci.txt    | 69 ++++++++++++++++
>  .../arm/cpu-enable-method/qcom,gcc-msm8660         | 30 +++++++
>  .../arm/cpu-enable-method/qcom,kpss-acc-v1         | 56 +++++++++++++
>  .../arm/cpu-enable-method/qcom,kpss-acc-v2         | 56 +++++++++++++
>  .../bindings/arm/cpu-enable-method/spin-table.txt  | 96 ++++++++++++++++++++++
>  Documentation/devicetree/bindings/arm/cpus.txt     | 29 +------
>  7 files changed, 330 insertions(+), 26 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/arm/cpu-enable-method/README
>  create mode 100644 Documentation/devicetree/bindings/arm/cpu-enable-method/arm,psci.txt
>  create mode 100644 Documentation/devicetree/bindings/arm/cpu-enable-method/qcom,gcc-msm8660
>  create mode 100644 Documentation/devicetree/bindings/arm/cpu-enable-method/qcom,kpss-acc-v1
>  create mode 100644 Documentation/devicetree/bindings/arm/cpu-enable-method/qcom,kpss-acc-v2
>  create mode 100644 Documentation/devicetree/bindings/arm/cpu-enable-method/spin-table.txt

What about all the existing documentation:

.../arm/psci.txt
.../arm/msm/qcom,kpss-acc.txt

I can't tell what you are adding and what you are moving.

Rob

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
> diff --git a/Documentation/devicetree/bindings/arm/cpu-enable-method/arm,psci.txt b/Documentation/devicetree/bindings/arm/cpu-enable-method/arm,psci.txt
> new file mode 100644
> index 0000000..c80d68e
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/arm/cpu-enable-method/arm,psci.txt
> @@ -0,0 +1,69 @@
> +====================================
> +CPU enable-method "arm,psci" binding
> +====================================
> +
> +This document describes the "arm,psci" method for enabling secondary CPUs.
> +This is different from other CPU enable methods, in that CPU cores are
> +enabled and disabled using the ARM PSCI interface, which is defined in the
> +device tree independent of the CPUs.  Instead, a separate node compatible
> +with "arm,psci" defines the PSCI functions supported; if a "cpu_on" function
> +is defined, that is used for enabling a CPU core.
> +
> +Enable method:         Distinct node with compatible = "arm,psci" property
> +Compatible cpus:       (???)  (both 32- and 64-bit ARM have a hook)
> +Properties:
> +       - method
> +               Usage:          required
> +               Value type:     <string>
> +               Definition:
> +                       A string defining the specific instruction
> +                       used to enable the core.  The value must be
> +                       either "hvc" or "smc".
> +       - cpu_suspend
> +               Usage:          optional
> +               Value type:     <u32>
> +               Definition:
> +                       If present, this value defines the PSCI function id
> +                       used to suspend execution on a CPU core.
> +       - cpu_off
> +               Usage:          optional
> +               Value type:     <u32>
> +               Definition:
> +                       If present, this value defines the PSCI function id
> +                       used to power down a CPU core.
> +       - cpu_on
> +               Usage:          optional
> +               Value type:     <u32>
> +               Definition:
> +                       If present, this value defines the PSCI function id
> +                       used to power up a CPU core.
> +       - migrate
> +               Usage:          optional
> +               Value type:     <u32>
> +               Definition:
> +                       If present, this value defines the PSCI function id
> +                       used to migrate context to a different CPU core.
> +
> +Example (contrived 2-core ARM Cortex-A57 64-bit system):
> +
> +       psci {
> +               compatible = "arm,psci";
> +               method = "smc";
> +               cpu_on = 0x1;
> +       };
> +       cpus {
> +               #size-cells = <0>;
> +               #address-cells = <2>;
> +
> +               cpu@0 {
> +                       device_type = "cpu";
> +                       compatible = "arm,cortex-a57";  /* ??? */
> +                       reg = <0x0 0x0>;
> +               };
> +
> +               cpu@1 {
> +                       device_type = "cpu";
> +                       compatible = "arm,cortex-a57";
> +                       reg = <0x0 0x1>;
> +               };
> +       };
> diff --git a/Documentation/devicetree/bindings/arm/cpu-enable-method/qcom,gcc-msm8660 b/Documentation/devicetree/bindings/arm/cpu-enable-method/qcom,gcc-msm8660
> new file mode 100644
> index 0000000..1e002d9
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/arm/cpu-enable-method/qcom,gcc-msm8660
> @@ -0,0 +1,30 @@
> +======================================================
> +Secondary CPU enable-method "qcom,gcc-msm8660" binding
> +======================================================
> +
> +This document describes the "qcom,gcc-msm8660" method for enabling
> +secondary CPUs.  A "qcom,gcc-msm8660" enable method should only be
> +used in the "cpus" node, to apply to all CPUs.
> +
> +Enable method name:    "qcom,gcc-msm8660"
> +Compatible cpu:                "qcom,scorpion"
> +Related properties:    (none)
> +
> +Example:
> +
> +       cpus {
> +               #address-cells = <1>;
> +               #size-cells = <0>;
> +               compatible = "qcom,scorpion";
> +               enable-method = "qcom,gcc-msm8660";
> +
> +               cpu@0 {
> +                       device_type = "cpu";
> +                       reg = <0>;
> +               };
> +
> +               cpu@1 {
> +                       device_type = "cpu";
> +                       reg = <1>;
> +               };
> +       };
> diff --git a/Documentation/devicetree/bindings/arm/cpu-enable-method/qcom,kpss-acc-v1 b/Documentation/devicetree/bindings/arm/cpu-enable-method/qcom,kpss-acc-v1
> new file mode 100644
> index 0000000..3f6ce56
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/arm/cpu-enable-method/qcom,kpss-acc-v1
> @@ -0,0 +1,56 @@
> +======================================================
> +Secondary CPU enable-method "qcom,kpss-acc-v1" binding
> +======================================================
> +
> +This document describes the "qcom,kpss-acc-v1" method for enabling CPUs.
> +This enable method can be used in either the "cpus" node or in individual
> +"cpu" nodes.  Note that each "cpu" node must have both "qcom,saw" and
> +"qcom,acc" properties defined (even if the "enable-method" property was
> +defined only in the "cpus" node).
> +
> +Enable method name:    "qcom,kpss-acc-v1"
> +Compatible machine:    "qcom,msm8960"
> +Compatible cpu:                "qcom,krait"
> +Related properties:
> +       - qcom,saw
> +               Usage:          required (in each "cpu" node")
> +               Value type:     <phandle>
> +               Definition:
> +                       Specifies the SAW[1] node associated with this CPU.
> +
> +       - qcom,acc
> +               Usage:          required (in each "cpu" node")
> +               Value type:     <phandle>
> +               Definition:
> +                       Specifies the ACC[2] node associated with this CPU.
> +
> +Example:
> +
> +/ {
> +       compatible = "qcom,msm8960";
> +
> +       cpus {
> +               #address-cells = <1>;
> +               #size-cells = <0>;
> +               compatible = "qcom,krait";
> +               enable-method = "qcom,kpss-acc-v1";
> +
> +               cpu@0 {
> +                       device_type = "cpu";
> +                       reg = <0>;
> +                       qcom,acc = <&acc0>;
> +                       qcom,saw = <&saw0>;
> +               };
> +
> +               cpu@1 {
> +                       device_type = "cpu";
> +                       reg = <1>;
> +                       qcom,acc = <&acc1>;
> +                       qcom,saw = <&saw1>;
> +               };
> +       };
> +};
> +
> +--
> +[1] arm/msm/qcom,saw2.txt
> +[2] arm/msm/qcom,kpss-acc.txt
> diff --git a/Documentation/devicetree/bindings/arm/cpu-enable-method/qcom,kpss-acc-v2 b/Documentation/devicetree/bindings/arm/cpu-enable-method/qcom,kpss-acc-v2
> new file mode 100644
> index 0000000..4368d904
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/arm/cpu-enable-method/qcom,kpss-acc-v2
> @@ -0,0 +1,56 @@
> +======================================================
> +Secondary CPU enable-method "qcom,kpss-acc-v2" binding
> +======================================================
> +
> +This document describes the "qcom,kpss-acc-v2" method for enabling CPUs.
> +This enable method can be used in either the "cpus" node or in individual
> +"cpu" nodes.  Note that each "cpu" node must have both "qcom,saw" and
> +"qcom,acc" properties defined (even if the "enable-method" property was
> +defined only in the "cpus" node).
> +
> +Enable method name:    "qcom,kpss-acc-v2"
> +Compatible machine:    "qcom,msm8974"
> +Compatible cpu:                "qcom,krait"
> +Related properties:
> +       - qcom,saw
> +               Usage:          required (in each "cpu" node")
> +               Value type:     <phandle>
> +               Definition:
> +                       Specifies the SAW[1] node associated with this CPU.
> +
> +       - qcom,acc
> +               Usage:          required (in each "cpu" node")
> +               Value type:     <phandle>
> +               Definition:
> +                       Specifies the ACC[2] node associated with this CPU.
> +
> +Example:
> +
> +/ {
> +       compatible = "qcom,msm8974";
> +
> +       cpus {
> +               #address-cells = <1>;
> +               #size-cells = <0>;
> +               compatible = "qcom,krait";
> +               enable-method = "qcom,kpss-acc-v2";
> +
> +               cpu@0 {
> +                       device_type = "cpu";
> +                       reg = <0>;
> +                       qcom,acc = <&acc0>;
> +                       qcom,saw = <&saw0>;
> +               };
> +
> +               cpu@1 {
> +                       device_type = "cpu";
> +                       reg = <1>;
> +                       qcom,acc = <&acc1>;
> +                       qcom,saw = <&saw1>;
> +               };
> +       };
> +};
> +
> +--
> +[1] arm/msm/qcom,saw2.txt
> +[2] arm/msm/qcom,kpss-acc.txt
> diff --git a/Documentation/devicetree/bindings/arm/cpu-enable-method/spin-table.txt b/Documentation/devicetree/bindings/arm/cpu-enable-method/spin-table.txt
> new file mode 100644
> index 0000000..f57955a
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/arm/cpu-enable-method/spin-table.txt
> @@ -0,0 +1,96 @@
> +================================================
> +Secondary CPU enable-method "spin-table" binding
> +================================================
> +
> +This document describes the "spin-table" method for enabling secondary CPUs.
> +See the "README" file in this directory for more information on CPU enable
> +methods.  A "spin-table" enable method can be used in either the "cpus" node
> +or in individual "cpu" nodes.
> +
> +Enable method name:    "spin-table"
> +Compatible cpus:       "arm,cortex-a57" (?)
> +Related properties:
> +       - cpu-release-addr
> +               Usage:          required
> +               Value type:     <prop-encoded-array>
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
> +
> +               cpu@0 {
> +                       device_type = "cpu";
> +                       compatible = "arm,cortex-a57";
> +                       reg = <0x0 0x0>;
> +               };
> +
> +               cpu@1 {
> +                       device_type = "cpu";
> +                       compatible = "arm,cortex-a57";
> +                       reg = <0x0 0x1>;
> +               };
> +
> +               cpu@100 {
> +                       device_type = "cpu";
> +                       compatible = "arm,cortex-a57";
> +                       reg = <0x0 0x100>;
> +               };
> +
> +               cpu@101 {
> +                       device_type = "cpu";
> +                       compatible = "arm,cortex-a57";
> +                       reg = <0x0 0x101>;
> +               };
> +       };
> +
> +
> +The second example uses specifies distinct enable method properties for each
> +CPU core.
> +
> +       cpus {
> +               #size-cells = <0>;
> +               #address-cells = <2>;
> +
> +               cpu@0 {
> +                       device_type = "cpu";
> +                       compatible = "arm,cortex-a57";
> +                       reg = <0x0 0x0>;
> +                       enable-method = "spin-table";
> +                       cpu-release-addr = <0 0x20000000>;
> +               };
> +
> +               cpu@1 {
> +                       device_type = "cpu";
> +                       compatible = "arm,cortex-a57";
> +                       reg = <0x0 0x1>;
> +                       enable-method = "spin-table";
> +                       cpu-release-addr = <0 0x20000008>;
> +               };
> +
> +               cpu@100 {
> +                       device_type = "cpu";
> +                       compatible = "arm,cortex-a57";
> +                       reg = <0x0 0x100>;
> +                       enable-method = "spin-table";
> +                       cpu-release-addr = <0 0x20000010>;
> +               };
> +
> +               cpu@101 {
> +                       device_type = "cpu";
> +                       compatible = "arm,cortex-a57";
> +                       reg = <0x0 0x101>;
> +                       enable-method = "spin-table";
> +                       cpu-release-addr = <0 0x20000018>;
> +               };
> +       };
> diff --git a/Documentation/devicetree/bindings/arm/cpus.txt b/Documentation/devicetree/bindings/arm/cpus.txt
> index 333f4ae..2bb2a3e 100644
> --- a/Documentation/devicetree/bindings/arm/cpus.txt
> +++ b/Documentation/devicetree/bindings/arm/cpus.txt
> @@ -185,30 +185,8 @@ nodes to be present and contain the properties described below.
>                             "qcom,gcc-msm8660"
>                             "qcom,kpss-acc-v1"
>                             "qcom,kpss-acc-v2"
> -
> -       - cpu-release-addr
> -               Usage: required for systems that have an "enable-method"
> -                      property value of "spin-table".
> -               Value type: <prop-encoded-array>
> -               Definition:
> -                       # On ARM v8 64-bit systems must be a two cell
> -                         property identifying a 64-bit zero-initialised
> -                         memory location.
> -
> -       - qcom,saw
> -               Usage: required for systems that have an "enable-method"
> -                      property value of "qcom,kpss-acc-v1" or
> -                      "qcom,kpss-acc-v2"
> -               Value type: <phandle>
> -               Definition: Specifies the SAW[1] node associated with this CPU.
> -
> -       - qcom,acc
> -               Usage: required for systems that have an "enable-method"
> -                      property value of "qcom,kpss-acc-v1" or
> -                      "qcom,kpss-acc-v2"
> -               Value type: <phandle>
> -               Definition: Specifies the ACC[2] node associated with this CPU.
> -
> +               Details about use of these CPU enable methods is documented
> +               elsewhere[1].
>
>  Example 1 (dual-cluster big.LITTLE system 32-bit):
>
> @@ -403,5 +381,4 @@ cpus {
>  };
>
>  --
> -[1] arm/msm/qcom,saw2.txt
> -[2] arm/msm/qcom,kpss-acc.txt
> +[1] arm/cpu-enable-method/
> --
> 1.9.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe devicetree" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
