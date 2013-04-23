Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756361Ab3DWNd1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 09:33:27 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:36421 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756138Ab3DWNd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 09:33:26 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>,
        Anmar Oueja <anmar.oueja@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Pankaj Dev <pankaj.dev@st.com>
Subject: Re: [PATCH] pinctrl: document the "GPIO mode" pitfall
Date: Tue, 23 Apr 2013 15:33:25 +0200
Message-ID: <2408684.1bsjMDDzMu@avalon>
User-Agent: KMail/4.10.2 (Linux/3.7.10-gentoo; KDE/4.10.2; x86_64; ; )
In-Reply-To: <1363345636-2006-1-git-send-email-linus.walleij@stericsson.com>
References: <1363345636-2006-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Friday 15 March 2013 12:07:16 Linus Walleij wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
> 
> Recently as adoption of the pinctrl framework is reaching
> niches where the pins are reconfigured during system sleep
> and datasheets often talk about something called "GPIO mode",
> some engineers become confused by this, thinking that since
> it is named "GPIO (something something)" it must be modeled
> in the kernel using <linux/gpio.h>.
> 
> To clarify things, let's put in this piece of documentation,
> or just start off the discussion here.
> 
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Cc: Pankaj Dev <pankaj.dev@st.com>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
>  Documentation/pinctrl.txt | 112 +++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 112 insertions(+)
> 
> diff --git a/Documentation/pinctrl.txt b/Documentation/pinctrl.txt
> index a2b57e0..3e41545 100644
> --- a/Documentation/pinctrl.txt
> +++ b/Documentation/pinctrl.txt
> @@ -736,6 +736,13 @@ All the above functions are mandatory to implement for
> a pinmux driver. Pin control interaction with the GPIO subsystem
>  ===============================================
> 
> +Note that the following implies that the use case is to use a certain pin
> +from the Linux kernel using the API in <linux/gpio.h> with gpio_request()
> +and similar functions. There are cases where you may be using something
> +that your datasheet calls "GPIO mode" but actually is just an electrical
> +configuration for a certain device. See the section below named
> +"GPIO mode pitfalls" for more details on this scenario.
> +
>  The public pinmux API contains two functions named pinctrl_request_gpio()
>  and pinctrl_free_gpio(). These two functions shall *ONLY* be called from
>  gpiolib-based drivers as part of their gpio_request() and
> @@ -774,6 +781,111 @@ obtain the function "gpioN" where "N" is the global
> GPIO pin number if no special GPIO-handler is registered.
> 
> 
> +GPIO mode pitfalls
> +==================
> +
> +Sometime the developer may be confused by a datasheet talking about a pin
> +being possible to set into "GPIO mode". It appears that what hardware
> +engineers mean with "GPIO mode" is not necessarily the use case that is
> +implied in the kernel interface <linux/gpio.h>: a pin that you grab from
> +kernel code and then either listen for input or drive high/low to
> +assert/deassert some external line.
> +
> +Rather hardware engineers think that "GPIO mode" means that you can
> +software-control a few electrical properties of the pin that you would
> +not be able to control if the pin was in some other mode, such as muxed in
> +for a device.
> +
> +Example: a pin is usually muxed in to be used as a UART TX line. But during
> +system sleep, we need to put this pin into "GPIO mode" and ground it. +
> +If you make a 1-to-1 map to the GPIO subsystem for this pin, you may start
> +to think that you need to come up with something real complex, that the
> +pin shall be used for UART TX and GPIO at the same time, that you will grab
> +a pin control handle and set it to a certain state to enable UART TX to be
> +muxed in, then twist it over to GPIO mode and use gpio_direction_output()
> +to drive it low during sleep, then mux it over to UART TX again when you
> +wake up and maybe even gpio_request/gpio_free as part of this cycle. This
> +all gets very complicated.
> +
> +The solution is to not think that what the datasheet calls "GPIO mode"
> +has to be handled by the <linux/gpio.h> interface. Instead view this as
> +a certain pin config setting. Look in e.g.
> + <linux/pinctrl/pinconf-generic.h> and you find this in the documentation:
> +
> +  PIN_CONFIG_OUTPUT: this will configure the pin in output, use argument
> +     1 to indicate high level, argument 0 to indicate low level.
> +
> +So it is perfectly possible to push a pin into "GPIO mode" and drive the
> +line low as part of the usual pin control map. So for example your UART
> +driver may look like this:
> +
> +#include <linux/pinctrl/consumer.h>
> +
> +struct pinctrl          *pinctrl;
> +struct pinctrl_state    *pins_default;
> +struct pinctrl_state    *pins_sleep;
> +
> +pins_default = pinctrl_lookup_state(uap->pinctrl, PINCTRL_STATE_DEFAULT);
> +pins_sleep = pinctrl_lookup_state(uap->pinctrl, PINCTRL_STATE_SLEEP);
> +
> +/* Normal mode */
> +retval = pinctrl_select_state(pinctrl, pins_default);
> +/* Sleep mode */
> +retval = pinctrl_select_state(pinctrl, pins_sleep);
> +
> +And your machine configuration may look like this:
> +--------------------------------------------------
> +
> +static unsigned long uart_default_mode[] = {
> +    PIN_CONF_PACKED(PIN_CONFIG_DRIVE_PUSH_PULL, 0),
> +};
> +
> +static unsigned long uart_sleep_mode[] = {
> +    PIN_CONF_PACKED(PIN_CONFIG_OUTPUT, 0),
> +};

I'm having a bit of trouble with PIN_CONFIG_DRIVE_PUSH_PULL and 
PIN_CONFIG_OUTPUT. Strictly speaking, when configured in output mode, the pin 
will be in a push-pull configuration. Could you clarify the exact scope of the 
two configuration parameters ?

> +static struct pinctrl_map __initdata pinmap[] = {
> +    PIN_MAP_MUX_GROUP("uart", PINCTRL_STATE_DEFAULT", "pinctrl-foo",
> +                      "u0_group", "u0"),
> +    PIN_MAP_CONFIGS_PIN("uart", PINCTRL_STATE_DEFAULT, "pinctrl-foo",
> +                        "UART_TX_PIN", uart_default_mode),
> +    PIN_MAP_MUX_GROUP("uart", PINCTRL_STATE_SLEEP, "pinctrl-foo",
> +                      "u0_group", "gpio-mode"),
> +    PIN_MAP_CONFIGS_PIN("uart", PINCTRL_STATE_SLEEP, "pinctrl-foo",
> +                        "UART_TX_PIN", uart_sleep_mode),
> +};
> +
> +foo_init(void) {
> +    pinctrl_register_mappings(pinmap, ARRAY_SIZE(pinmap));
> +}
> +
> +Here the pins we want to control are in the "u0_group" and there is some
> +function called "u0" that can be enabled on this group of pins, and then
> +everything is UART business as usual. But there is also some function
> +named "gpio-mode" that can be mapped onto the same pins to move them into
> +GPIO mode.
> +
> +This will give the desired effect without any bogus interaction with the
> +GPIO subsystem. It is just an electrical configuration used by that device
> +when going to sleep, it might imply that the pin is set into something the
> +datasheet calls "GPIO mode" but that is not the point: it is still used
> +by that UART device to control the pins that pertain to that very UART
> +driver, putting them into modes needed by the UART. GPIO in the Linux
> +kernel sense are just some 1-bit line, and is a different use case.
> +
> +How the registers are poked to attain the push/pull and output low
> +configuration and the muxing of the "u0" or "gpio-mode" group onto these
> +pins is a question for the driver.
> +
> +Some datasheets will be more helpful and refer to the "GPIO mode" as
> +"low power mode" rather than anything to do with GPIO. This often means
> +the same thing electrically speaking, but in this latter case the
> +software engineers will usually quickly identify that this is some
> +specific muxing/configuration rather than anything related to the GPIO
> +API.
> +
> +
>  Board/machine configuration
>  ==================================

-- 
Regards,

Laurent Pinchart

