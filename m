Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755767AbaIQSQ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 14:16:27 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:42270 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755561AbaIQSQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 14:16:25 -0400
MIME-Version: 1.0
In-Reply-To: <1410959280-29662-3-git-send-email-zyw@rock-chips.com>
References: <1410959280-29662-1-git-send-email-zyw@rock-chips.com>
	<1410959280-29662-3-git-send-email-zyw@rock-chips.com>
Date: Wed, 17 Sep 2014 11:16:23 -0700
X-Google-Sender-Auth: 7ETNLbHCW64dO2ln96KVrZ8oFgU
Message-ID: <CAD=FV=WCQ4oU1O9JcZ9SuwWJ7g+GLsUiE=wmQQoWvL41o24eWg@mail.gmail.com>
Subject: Re: [PATCH 2/2] dt-bindings: add devicetree bindings for st-pwm regulator
From: Doug Anderson <dianders@chromium.org>
To: Chris Zhong <zyw@rock-chips.com>
Cc: =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        Tao Huang <huangtao@rock-chips.com>, Eddie Cai <cf@rock-chips.com>,
        zhangqing <zhangqing@rock-chips.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "broonie@kernel.org" <broonie@kernel.org>,
        Lee Jones <lee.jones@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris,

On Wed, Sep 17, 2014 at 6:08 AM, Chris Zhong <zyw@rock-chips.com> wrote:
> Document the st-pwm regulator
>
> Signed-off-by: Chris Zhong <zyw@rock-chips.com>
>
> ---
>
>  .../devicetree/bindings/regulator/st-pwm.txt       |   35 ++++++++++++++++++++
>  1 file changed, 35 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/regulator/st-pwm.txt
>
> diff --git a/Documentation/devicetree/bindings/regulator/st-pwm.txt b/Documentation/devicetree/bindings/regulator/st-pwm.txt
> new file mode 100644
> index 0000000..38fec1d
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/regulator/st-pwm.txt
> @@ -0,0 +1,35 @@
> +st pwm regulator bindings
> +
> +Required properties:
> +  - compatible: "pwm-regulator"

This compatible string doesn't include "st,b2105-pwm-regulator".

Should be something like:

  - compatible: Should be "pwm-regulator" to get voltage table / regulator
    period from the device tree.  Deprecated: if "st,b2105-pwm-regulator" then
    voltage table and regulator will be handled by the driver.

Assuming that everyone is OK calling "st,b2105-pwm-regulator" the
deprecated way of doing things.


> +  - pwms: OF device-tree PWM specification (see PWM binding pwm.txt)
> +  - voltage-table: voltage and duty table, include 2 merbers in each set of
> +    brackets, first one is voltage(unit: uv), the next is duty(unit: percent)
> +  - pwm-reg-period: duration (in nanoseconds) of one cycle

The voltage-table and pwm-reg-period should not be required if we're
using "st,b2105-pwm-regulator".  If someone lists both
"st,b2105-pwm-regulator" and "pwm-regulator" then I'd assume that
you'd allow them to override via the device tree but fallback to the
old hardcoded values.


> +
> +Any property defined as part of the core regulator binding defined in
> +regulator.txt can also be used.
> +
> +Example:
> +       pwm_regulator {
> +                compatible = "st,b2105-pwm-regulator;
> +                pwms = <&pwm1 0 1000000 0>;
> +
> +               voltage-table = <1114000 0>,
> +                               <1095000 10>,
> +                               <1076000 20>,
> +                               <1056000 30>,
> +                               <1036000 40>,
> +                               <1016000 50>;
> +
> +               pwm-reg-period = <8448>;
> +               regulators {
> +                       vdd_logic: pwm-regulator {
> +                               regulator-always-on;
> +                               regulator-boot-on;
> +                               regulator-min-microvolt = <1016000>;
> +                               regulator-max-microvolt = <1114000>;
> +                               regulator-name = "vdd_logic";
> +                       };
> +               };

I _think_ that the "regulators" subnode and the "pwm-regulator"
subnode are not needed at all and should be removed.  Other instances
of devices that are "just" regulators don't have it (like
fixed-regulator, gpio-regulator, etc).

I think your final example should be:

+       vdd_logic: pwm-regulator {
+                compatible = "pwm-regulator;
+                pwms = <&pwm1 0 1000000 0>;
+
+               voltage-table = <1114000 0>,
+                               <1095000 10>,
+                               <1076000 20>,
+                               <1056000 30>,
+                               <1036000 40>,
+                               <1016000 50>;
+
+               pwm-reg-period = <8448>;
+
+               regulator-always-on;
+               regulator-boot-on;
+               regulator-min-microvolt = <1016000>;
+               regulator-max-microvolt = <1114000>;
+               regulator-name = "vdd_logic";
+       };

-Doug
