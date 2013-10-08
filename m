Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755394Ab3JHOPx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 10:15:53 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:39312 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755318Ab3JHOPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 10:15:49 -0400
Date: Tue, 8 Oct 2013 15:15:12 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: "mturquette@linaro.org" <mturquette@linaro.org>,
        "broonie@linaro.org" <broonie@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "rob@landley.net" <rob@landley.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "swarren@nvidia.com" <swarren@nvidia.com>
Subject: Re: [PATCH V2] clk: palmas: add clock driver for palmas
Message-ID: <20131008141512.GE1412@e106331-lin.cambridge.arm.com>
References: <1381154751-4565-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381154751-4565-1-git-send-email-ldewangan@nvidia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 07, 2013 at 03:05:51PM +0100, Laxman Dewangan wrote:
> Palmas devices has two clock output CLK32K_KG and CLK32K_KG_AUDIO
> which can be nebale/disable through software.
> 
> Add clock driver support for the Palmas 32k clocks.
> 
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> ---
> Changes from V1:
> - Call prepare if the clk is needed for boot-enable or sleep control.
> - change is_enabled to is_prepared.
> - Added ops palmas_clks_recalc_rate.
> - Added of_clk_add_provider().
> 
>  .../devicetree/bindings/clock/clk-palmas.txt       |   45 +++
>  drivers/clk/Kconfig                                |    7 +
>  drivers/clk/Makefile                               |    2 +
>  drivers/clk/clk-palmas.c                           |  336 ++++++++++++++++++++
>  4 files changed, 390 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/clock/clk-palmas.txt
>  create mode 100644 drivers/clk/clk-palmas.c
> 
> diff --git a/Documentation/devicetree/bindings/clock/clk-palmas.txt b/Documentation/devicetree/bindings/clock/clk-palmas.txt
> new file mode 100644
> index 0000000..c247538
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/clock/clk-palmas.txt
> @@ -0,0 +1,45 @@
> +* Palmas 32KHz clocks *
> +
> +Palmas device has two clock output pins for 32KHz, KG and KG_AUDIO.
> +
> +This binding uses the common clock binding ./clock-bindings.txt.
> +
> +Clock 32KHz KG is output 0 of the driver and clock 32KHz is output 1.
> +
> +Required properties:
> +- compatible : shall be "ti,palmas-clk".
> +- #clock-cells : from common clock binding; shall be set to 1.

It would make sense to describe the value values here, rather than
above.

> +
> +Optional subnode:
> +       The clock node has optional subnode to provide the init configuration of
> +       clocks like boot enable, sleep control.
> +
> +       The subnode name is fixed and it should be
> +               clk32k_kg for the 32KHz KG clock.
> +               clk32k_kg_audio for the 32KHz KG_AUDIO clock.
> +
> +       Optional subnode properties:
> +       ti,clock-boot-enable: Enable clock at the time of booting.

Why is this needed?

If drivers need clocks, they should request them. If they don't
currently, that's a bug in the driver.

> +       ti,external-sleep-control: The clock is enable/disabled by state
> +               of external enable input pins ENABLE, ENABLE2 and NSLEEP.
> +               The valid value for the external pins are:
> +                       1 for ENABLE1
> +                       2 for ENABLE2
> +                       3 for NSLEEP.
> +               Option 0 or missing this property means the clock is
> +               enabled/disabled via register access and these pins do
> +               not have any control.

What actually drives these pins to control the clock?

> +
> +Example:
> +       clock {
> +               compatible = "ti,palmas-clk";
> +               #clock-cells = <1>;
> +               clk32k_kg {
> +                       ti,clock-boot-enable;
> +                       ti,external-sleep-control = <3>;
> +               };
> +
> +               clk32k_kg_audio {
> +                       ti,clock-boot-enable;
> +               };
> +       };

How does the palmas-clk driver control these? No description of
registers, gpio, or any other component that could be used for control
is dfined.

Is the palmas-clk intended to be a subnode of the palmas mfd (the
palmas-rtc binding example suggests this)? It seems odd to describe
components of a device separately with no linkage between them.

I also note that the palmas MFD appears to be an I2C slave, but the
binding doesn't define that (which makes it somewhat confuding for
someone unfamiliar with the hardware).

Thanks,
Mark.
