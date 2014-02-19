Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751318AbaBSWTs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 17:19:48 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:51957 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942AbaBSWTq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 17:19:46 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Linus Walleij <linus.walleij@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Alexandre Courbot <gnurou@gmail.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH] gpio: document polarity flag best practices
Date: Wed, 19 Feb 2014 23:20:56 +0100
Message-ID: <13285112.itIsE0msVp@avalon>
User-Agent: KMail/4.11.5 (Linux/3.10.25-gentoo; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1392835406-9380-1-git-send-email-swarren@wwwdotorg.org>
References: <1392835406-9380-1-git-send-email-swarren@wwwdotorg.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

Thank you for the patch.

On Wednesday 19 February 2014 11:43:26 Stephen Warren wrote:
> From: Stephen Warren <swarren@nvidia.com>
> 
> Document what we (Laurent and I, following a mailing list dicussion)
> believe are best practices for the polarity flag in a GPIO specifier.
> 
> While touching the doc, I made a few minor editing changes to other
> areas.
> 
> Suggested-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Signed-off-by: Stephen Warren <swarren@nvidia.com>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  Documentation/devicetree/bindings/gpio/gpio.txt | 60 ++++++++++++++++++----
>  1 file changed, 52 insertions(+), 8 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/gpio/gpio.txt
> b/Documentation/devicetree/bindings/gpio/gpio.txt index
> 0c85bb6e3a80..3fb8f53071b8 100644
> --- a/Documentation/devicetree/bindings/gpio/gpio.txt
> +++ b/Documentation/devicetree/bindings/gpio/gpio.txt
> @@ -13,11 +13,11 @@ properties, each containing a 'gpio-list':
>  	gpio-specifier : Array of #gpio-cells specifying specific gpio
>  			 (controller specific)
> 
> -GPIO properties should be named "[<name>-]gpios".  Exact
> +GPIO properties should be named "[<name>-]gpios". The exact
>  meaning of each gpios property must be documented in the device tree
>  binding for each device.
> 
> -For example, the following could be used to describe gpios pins to use
> +For example, the following could be used to describe GPIO pins used
>  as chip select lines; with chip selects 0, 1 and 3 populated, and chip
>  select 2 left empty:
> 
> @@ -44,35 +44,79 @@ whether pin is open-drain and whether pin is logically
> inverted. Exact meaning of each specifier cell is controller specific, and
> must be documented in the device tree binding for the device.
> 
> -Example of the node using GPIOs:
> +Example of a node using GPIOs:
> 
>  	node {
>  		gpios = <&qe_pio_e 18 0>;
>  	};
> 
>  In this example gpio-specifier is "18 0" and encodes GPIO pin number,
> -and empty GPIO flags as accepted by the "qe_pio_e" gpio-controller.
> +and GPIO flags as accepted by the "qe_pio_e" gpio-controller.
> +
> +1.1) GPIO specifier best practices
> +----------------------------------
> +
> +A gpio-specifier should contain a flag indicating the GPIO polarity;
> active- +high or active-low. If it does, the follow best practices should
> be followed: +
> +The gpio-specifier's polarity flag should represent the physical level at
> the +GPIO controller that achieves (or represents, for inputs) a logically
> asserted +value at the device. The exact definition of logically asserted
> should be +defined by the binding for the device. If the board inverts the
> signal between +the GPIO controller and the device, then the gpio-specifier
> will represent the +opposite physical level than the signal at the device's
> pin.
> +
> +When the device's signal polarity is configurable, the binding for the
> +device must either:
> +
> +a) Define a single static polarity for the signal, with the expectation
> that +any software using that binding would statically program the device
> to use +that signal polarity.
> +
> +The static choice of polarity may be either:
> +
> +a1) (Preferred) Dictated by a binding-specific DT property.
> +
> +or:
> +
> +a2) Defined statically by the DT binding itself.
> +
> +In particular, the polarity cannot be derived from the gpio-specifier,
> since +that would prevent the DT from separately representing the two
> orthogonal +concepts of configurable signal polarity in the device, and
> possible board- +level signal inversion.
> +
> +or:
> +
> +b) Pick a single option for device signal polarity, and document this
> choice +in the binding. The gpio-specifier should represent the polarity of
> the signal +(at the GPIO controller) assuming that the device is configured
> for this +particular signal polarity choice. If software chooses to program
> the device +to generate or receive a signal of the opposite polarity,
> software will be +responsible for correctly interpreting (inverting) the
> GPIO signal at the GPIO +controller.
> 
>  2) gpio-controller nodes
>  ------------------------
> 
> -Every GPIO controller node must both an empty "gpio-controller"
> -property, and have #gpio-cells contain the size of the gpio-specifier.
> +Every GPIO controller node must contain both an empty "gpio-controller"
> +property, and a #gpio-cells integer property, which indicates the number of
> +cells in a gpio-specifier.
> 
>  Example of two SOC GPIO banks defined as gpio-controller nodes:
> 
>  	qe_pio_a: gpio-controller@1400 {
> -		#gpio-cells = <2>;
>  		compatible = "fsl,qe-pario-bank-a", "fsl,qe-pario-bank";
>  		reg = <0x1400 0x18>;
>  		gpio-controller;
> +		#gpio-cells = <2>;
>  	};
> 
>  	qe_pio_e: gpio-controller@1460 {
> -		#gpio-cells = <2>;
>  		compatible = "fsl,qe-pario-bank-e", "fsl,qe-pario-bank";
>  		reg = <0x1460 0x18>;
>  		gpio-controller;
> +		#gpio-cells = <2>;
>  	};
> 
>  2.1) gpio- and pin-controller interaction

-- 
Regards,

Laurent Pinchart

