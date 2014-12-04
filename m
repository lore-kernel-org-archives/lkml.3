Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933081AbaLDSAf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 13:00:35 -0500
Received: from v032797.home.net.pl ([89.161.177.31]:50555 "HELO
	v032797.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932455AbaLDSAc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 13:00:32 -0500
Message-ID: <5480A132.2010103@elproma.com.pl>
Date: Thu, 04 Dec 2014 19:00:18 +0100
From: =?ISO-8859-2?Q?Janusz_U=BFycki?= <j.uzycki@elproma.com.pl>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Philipp Zabel <p.zabel@pengutronix.de>,
        Mike Turquette <mturquette@linaro.org>,
        Thierry Reding <thierry.reding@gmail.com>
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pwm@vger.kernel.org
Subject: Re: [PATCH v2] clk: Add PWM clock driver
References: <1415007078-7947-1-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1415007078-7947-1-git-send-email-p.zabel@pengutronix.de>
Content-Type: text/plain; charset=iso-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

W dniu 2014-11-03 o 10:31, Philipp Zabel pisze:
> Some board designers, when running out of clock output pads, decide to
> (mis)use PWM output pads to provide a clock to external components.
> This driver supports this practice by providing an adapter between the
> PWM and clock bindings in the device tree. As the PWM bindings specify
> the period in the device tree, this is a fixed clock.
>
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> ---
> I'm resending this because last time the linux-pwm list was not in Cc:
> So far I have not received any comments on the patch itself. I have used
> it on a BoundaryDevices Nitrogen6X board to produce a master clock for
> the OV5640 MIPI CSI-2 camera module.
>
> Changes since v1:
>   - none (rebased onto v3.18-rc3)
> ---
>   .../devicetree/bindings/clock/pwm-clock.txt        |  23 +++++
>   drivers/clk/Kconfig                                |   7 ++
>   drivers/clk/Makefile                               |   1 +
>   drivers/clk/clk-pwm.c                              | 110 +++++++++++++++++++++
>   4 files changed, 141 insertions(+)
>   create mode 100644 Documentation/devicetree/bindings/clock/pwm-clock.txt
>   create mode 100644 drivers/clk/clk-pwm.c
>
> diff --git a/Documentation/devicetree/bindings/clock/pwm-clock.txt b/Documentation/devicetree/bindings/clock/pwm-clock.txt
> new file mode 100644
> index 0000000..d127d17
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/clock/pwm-clock.txt
> @@ -0,0 +1,23 @@
> +Binding for an external clock signal driven by a PWM pin.
> +
> +This binding uses the common clock binding[1] and the common PWM binding[2].
> +
> +[1] Documentation/devicetree/bindings/clock/clock-bindings.txt
> +[2] Documentation/devicetree/bindings/pwm/pwm.txt
> +
> +Required properties:
> +- compatible : shall be "pwm-clock".
> +- #clock-cells : from common clock binding; shall be set to 0.
> +- pwms : from common PWM binding; this determines the clock frequency
> +  via the PWM period given in the pwm-specifier.
> +
> +Optional properties:
> +- clock-output-names : From common clock binding.
> +
> +Example:
> +	clock {
> +		compatible = "pwm-clock";
> +		#clock-cells = <0>;
> +		clock-output-names = "mipi_mclk";
> +		pwms = <&pwm2 0 40>; /* 1 / 40 ns = 25 MHz */

Before I asked about [MHz/kHz] <-> [ns] conversion problem but I didn't 
noticed
you've just used [ns] in dt. As Thierry wrote:
"Also the PWM chips will most likely use the concept of period and 
duty-cycle
internally anyway, so it will convert back from Hz/percentage to nanoseconds
and fall victim to similar rounding effects."

Unfortunately I discovered that many pwm drivers are buggy around upper 
freqs limit.
The example is pwm-mxs.c. PWM has 24MHz clock. There is no problem to set
registers directly for 12MHz 50% output (period_cycles=2-1=1, 
inactive_c=1, active_c=0).

When I set pwm-mxs period to 83ns / duty to 42ns the output is low because
it sets inactive_c=0!
For 125ns/63ns I got about 6MHz instead of 8MHz, and +width=42ns.
When I set 42ns/42ns I got 12MHz 50%.
It means new patches for pwms...

I will test the patch backported to 3.14 using the mxs platform.
However as I wrote I  need to patch pwm-mxs first.

> [...]
>
> +static struct platform_driver clk_pwm_driver = {
> +	.probe = clk_pwm_probe,
> +	.driver = {
> +		.name = "pwm-clock",
> +		.owner = THIS_MODULE,

AFAIR new drivers don't need to set .owner.

thanks
Janusz

> +		.of_match_table = of_match_ptr(clk_pwm_dt_ids),
> +	},
> +};
> +
> +module_platform_driver(clk_pwm_driver);

