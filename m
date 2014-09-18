Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757462AbaIRV2C (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 17:28:02 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:59399 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755779AbaIRV2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 17:28:00 -0400
MIME-Version: 1.0
In-Reply-To: <1411025505-21628-3-git-send-email-zyw@rock-chips.com>
References: <1411025505-21628-1-git-send-email-zyw@rock-chips.com>
	<1411025505-21628-3-git-send-email-zyw@rock-chips.com>
Date: Thu, 18 Sep 2014 14:27:59 -0700
X-Google-Sender-Auth: 1R-71TSiExzFkfl0foBE7y7Clz0
Message-ID: <CAD=FV=UdSQZqGqY5XvLwKpkSbEWvtXG0s1vuk3xfdX0AJ27TBg@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] dt-bindings: add devicetree bindings for st-pwm regulator
From: Doug Anderson <dianders@chromium.org>
To: Chris Zhong <zyw@rock-chips.com>
Cc: =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        Tao Huang <huangtao@rock-chips.com>, Eddie Cai <cf@rock-chips.com>,
        zhangqing <zhangqing@rock-chips.com>, Lee Jones <lee.jones@linaro.org>,
        "broonie@kernel.org" <broonie@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris,

On Thu, Sep 18, 2014 at 12:31 AM, Chris Zhong <zyw@rock-chips.com> wrote:
> Document the st-pwm regulator
>
> Signed-off-by: Chris Zhong <zyw@rock-chips.com>
>
> ---
>
> Changes in v2:
> Adviced by Lee Jones
> - rename the documentation
> Adviced by Doug Anderson
> - update the example
> Adviced by Mark Rutland
> - remove pwm-reg-period
>
>  .../bindings/regulator/pwm-regulator.txt           |   29 ++++++++++++++++++++
>  1 file changed, 29 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/regulator/pwm-regulator.txt
>
> diff --git a/Documentation/devicetree/bindings/regulator/pwm-regulator.txt b/Documentation/devicetree/bindings/regulator/pwm-regulator.txt
> new file mode 100644
> index 0000000..7c62a30
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/regulator/pwm-regulator.txt
> @@ -0,0 +1,29 @@
> +pwm regulator bindings
> +
> +Required properties:
> +  - compatible: Should be "pwm-regulator"
> +  - pwms: OF device-tree PWM specification (see PWM binding pwm.txt)
> +  - voltage-table: voltage and duty table, include 2 merbers in each set of
> +    brackets, first one is voltage(unit: uv), the next is duty(unit: percent)
> +

I would be tempted to say that you should add a few required properties:

* regulator-boot-on
* regulator-always-on
* regulator-initial-microvolts

>From my understanding of how PWM-based regulators work there is no way
to "disable" them.  If you drive them low then they get their biggest
voltage.  If you drive them high then they get their smallest voltage.
If you make them floating then it's equivalent to 50% duty cycle
(right?)

Since your current bindings don't have an enable GPIO (which could
possibly be used to turn one of these off if it was hooked up) then
that means that the kernel had better keep the regulator always on.

The initial-microvolts also seems like a wise property to add.
There's no way (that I know of) to query what the voltage was at probe
time.  The bootloader (or power on default) of the device might have
left it as an input or might have left it driving high, driving low,
or even PWMing.  It seems like we should specify what voltage this
device should start up in.  You should make sure to use pinmux in
whatever way is needed (maybe can't use "default") so that you can
make sure that the PWM is configured and driving the initial voltage
before you actually set the pinmux.


All of the above could be done in followup patches since I think they
are new features.

> +Any property defined as part of the core regulator binding defined in
> +regulator.txt can also be used.
> +
> +Example:
> +       pwm_regulator {
> +               compatible = "pwm-regulator;
> +               pwms = <&pwm1 0 1000000 0>;

Since you're using the voltage table from the old st-pwm driver, maybe
you should specify a period that matches?  I think that means putting
8448 as your period here.

Wow, so if the ST's PWM regulator needs a period of 8448ns then it's
running at 118kHz?  The example you're showing runs at 1kHz, which is
pretty drastically different...
