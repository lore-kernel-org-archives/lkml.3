Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755707AbaBFRD3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 12:03:29 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:37902 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751234AbaBFRD1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 12:03:27 -0500
Date: Thu, 6 Feb 2014 17:03:25 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Alan Tull <delicious.quinoa@gmail.com>
Cc: Linus Walleij <linus.walleij@linaro.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Jamie Iles <jamie@jamieiles.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Heiko Stuebner <heiko@sntech.de>, Alan Tull <atull@altera.com>,
        Dinh Nguyen <dinguyen@altera.com>,
        Yves Vandervennet <rocket.yvanderv@gmail.com>
Subject: Re: [PATCH v10] gpio: add a driver for the Synopsys DesignWare APB
 GPIO block
Message-ID: <20140206170325.GF16551@e106331-lin.cambridge.arm.com>
References: <1391702147-6617-1-git-send-email-delicious.quinoa@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391702147-6617-1-git-send-email-delicious.quinoa@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 06, 2014 at 03:55:47PM +0000, Alan Tull wrote:
> From: Jamie Iles <jamie@jamieiles.com>
> 
> The Synopsys DesignWare block is used in some ARM devices (picoxcell)
> and can be configured to provide multiple banks of GPIO pins.
> 
> Signed-off-by: Jamie Iles <jamie@jamieiles.com>
> Signed-off-by: Alan Tull <atull@altera.com>
> Reviewed-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> 
> v10:    - in documentation nr-gpio -> nr-gpios
> v9:     - cleanup in dt bindings doc
>         - use of_get_child_count()
> v8:     - remove socfpga.dtsi changes
>         - minor cleanup in devicetree documentation
> v7:     - use irq_generic_chip
>         - support one irq per gpio line or one irq for many
>         - s/bank/port/ and other cleanup
> v6:     - (atull) squash the set of patches
>         - use linear irq domain
>         - build fixes. Original driver was reviewed on v3.2.
>         - Fix setting irq edge type for 'rising' and 'both'.
>         - Support as a loadable module.
>         - Use bgpio_chip's spinlock during register access.
>         - Clean up register names to match spec
>         - s/bank/port/ because register names use the word 'port'
>         - s/nr-gpio/nr-gpios/
>         - don't get/put the of_node
>         - remove signoffs/acked-by's because of changes
>         - other cleanup
> v5:     - handle sparse bank population correctly
> v3:     - depend on rather than select IRQ_DOMAIN
>         - split IRQ support into a separate patch
> v2:     - use Rob Herring's irqdomain in generic irq chip patches
>         - use reg property to indicate bank index
>         - support irqs on both edges based on LinusW's u300 driver
> ---
>  .../devicetree/bindings/gpio/snps-dwapb-gpio.txt   |   59 +++
>  drivers/gpio/Kconfig                               |    9 +
>  drivers/gpio/Makefile                              |    1 +
>  drivers/gpio/gpio-dwapb.c                          |  415 ++++++++++++++++++++
>  4 files changed, 484 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/gpio/snps-dwapb-gpio.txt
>  create mode 100644 drivers/gpio/gpio-dwapb.c
> 
> diff --git a/Documentation/devicetree/bindings/gpio/snps-dwapb-gpio.txt b/Documentation/devicetree/bindings/gpio/snps-dwapb-gpio.txt
> new file mode 100644
> index 0000000..cb01f9f
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/gpio/snps-dwapb-gpio.txt
> @@ -0,0 +1,59 @@
> +* Synopsys DesignWare APB GPIO controller
> +
> +Required properties:
> +- compatible : Should contain "snps,dw-apb-gpio"
> +- reg : Address and length of the register set for the device

Presumably #address-cells and #size-cells should be described here?

> +
> +The GPIO controller has a configurable number of ports, each of which are
> +represented as child nodes with the following properties:
> +
> +Required properties:
> +- compatible : "snps,dw-apb-gpio-port"
> +- gpio-controller : Marks the device node as a gpio controller.
> +- #gpio-cells : Should be two.  The first cell is the pin number and
> +  the second cell is used to specify optional parameters (currently
> +  unused).

Why not just have this as one cell for now if the second cell is unused?

If it needs to be expanded the driver can read #gpio-cells to figure out
what to do at runtime, and it prevents crap DTSs in the mean time that
could get in the way if you need to use additional cells in future.

> +- reg : The integer port index of the port, a single cell.
> +- #address-cells : should be 1.
> +- #size-cells : should be 0.

As mentioned above, presumably #address-cells and #size-cells should be
in the parent node, as is the case in the example?

> +
> +Optional properties:
> +- interrupt-controller : The first port may be configured to be an interrupt
> +controller.
> +- #interrupt-cells : Specifies the number of cells needed to encode an
> +interrupt.  Shall be set to 2.  The first cell defines the interrupt number,
> +the second encodes the triger flags encoded as described in
> +Documentation/devicetree/bindings/interrupts.txt
> +- interrupt-parent : The parent interrupt controller.
> +- interrupts : The interrupts to the parent controller raised when GPIOs
> +generate the interrupts.

How many are expected?

Otherwise, the binding looks ok to me.

[...]

> +static void dwapb_configure_irqs(struct dwapb_gpio *gpio,
> +                                struct dwapb_gpio_port *port)
> +{
> +       struct gpio_chip *gc = &port->bgc.gc;
> +       struct device_node *node =  gc->of_node;
> +       struct irq_chip_generic *irq_gc;
> +       unsigned int hwirq, ngpio = gc->ngpio;
> +       struct irq_chip_type *ct;
> +       int reg, err, irq;
> +
> +       if (of_get_property(node, "interrupts", &reg) == NULL)
> +               return;

of_get_property can take a NULL lenp (core OF code depends on this
fact), so you don't need the somewhat confusing &reg here.

Cheers,
Mark.
