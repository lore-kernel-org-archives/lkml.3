Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932269Ab3LDL4d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 06:56:33 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:44381 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932099Ab3LDL4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 06:56:30 -0500
Date: Wed, 4 Dec 2013 11:56:28 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Alan Tull <delicious.quinoa@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
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
Subject: Re: [PATCH v8] gpio: add a driver for the Synopsys DesignWare APB
 GPIO block
Message-ID: <20131204115628.GL16025@e106331-lin.cambridge.arm.com>
References: <1386088876-29205-1-git-send-email-delicious.quinoa@gmail.com>
 <1386088876-29205-2-git-send-email-delicious.quinoa@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386088876-29205-2-git-send-email-delicious.quinoa@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 03, 2013 at 04:41:16PM +0000, Alan Tull wrote:
> From: Jamie Iles <jamie@jamieiles.com>
> 
> The Synopsys DesignWare block is used in some ARM devices (picoxcell)
> and can be configured to provide multiple banks of GPIO pins.
> 
> Signed-off-by: Alan Tull <atull@altera.com>
> Reviewed-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> 
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
>  .../devicetree/bindings/gpio/snps-dwapb-gpio.txt   |   57 +++
>  drivers/gpio/Kconfig                               |    9 +
>  drivers/gpio/Makefile                              |    1 +
>  drivers/gpio/gpio-dwapb.c                          |  426 ++++++++++++++++++++
>  4 files changed, 493 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/gpio/snps-dwapb-gpio.txt
>  create mode 100644 drivers/gpio/gpio-dwapb.c
> 
> diff --git a/Documentation/devicetree/bindings/gpio/snps-dwapb-gpio.txt b/Documentation/devicetree/bindings/gpio/snps-dwapb-gpio.txt
> new file mode 100644
> index 0000000..e7f144f
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/gpio/snps-dwapb-gpio.txt
> @@ -0,0 +1,57 @@
> +* Synopsys DesignWare APB GPIO controller
> +
> +Required properties:
> +- compatible : Should be "snps,dw-apb-gpio"

s/be/contain/

> +- reg : Address and length of the register set for the device

As this has children with reg entries, it should have #address-cells and
#size-cells (as the example does).

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
> +- reg : The integer port index of the port, a single cell.
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
> +- snps,nr-gpios : The number of pins in the port, a single cell.
> +
> +Example:
> +
> +gpio: gpio@20000 {
> +       compatible = "snps,dw-apb-gpio";
> +       reg = <0x20000 0x1000>;
> +       #address-cells = <1>;
> +       #size-cells = <0>;
> +
> +       porta: gpio-controller@0 {
> +               compatible = "snps,dw-apb-gpio-port";
> +               gpio-controller;
> +               #gpio-cells = <2>;
> +               snps,nr-gpio = <8>;
> +               reg = <0>;
> +               interrupt-controller;
> +               #interrupt-cells = <2>;
> +               interrupt-parent = <&vic1>;
> +               interrupts = <0 1 2 3 4 5 6 7>;

Nit: please bracket list entries individually.

Otherwise this looks fine to me.

Thanks,
Mark.
