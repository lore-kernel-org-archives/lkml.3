Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932249AbaEIQdx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 12:33:53 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:42076 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755542AbaEIQdw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 12:33:52 -0400
Date: Fri, 9 May 2014 17:32:43 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Xiubo Li <Li.Xiubo@freescale.com>
Cc: "broonie@kernel.org" <broonie@kernel.org>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "rdunlap@infradead.org" <rdunlap@infradead.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCHv4 1/2] dt/bindings: Add the DT binding documentation
 for endianness
Message-ID: <20140509163243.GD16418@e106331-lin.cambridge.arm.com>
References: <1399601073-19278-1-git-send-email-Li.Xiubo@freescale.com>
 <1399601073-19278-2-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399601073-19278-2-git-send-email-Li.Xiubo@freescale.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 09, 2014 at 03:04:32AM +0100, Xiubo Li wrote:
> Device-Tree binding for device endianness
> 
> The endianness mode of CPU & Device scenarios:
> Index    CPU       Device     Endianness properties
> ------------------------------------------------------------
> 1        LE        LE         -
> 2        LE        BE         'big-endian{,-*}'
> 3        BE        BE         -
> 4        BE        LE         'little-endian{,-*}'
> 
> {big,little}-endian{,-*}: these are boolean properties, if absent
> meaning that the CPU and the Device are in the same endianness mode.

That's not really true though. A device might usually be little-endian,
regardless of the endianness of a CPU. Some vendors may integrate it as
big-endian after a binding is added, and in the absence of a specified
endianness a driver is likely to assume LE.

I am not keen on stating in such a generic document that the device is
the same endianness as the CPU. As some CPUs can change endianness
dynamically it's meaningless to say so.

> 
> Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
> ---
>  .../devicetree/bindings/endianness/endianness.txt  | 48 ++++++++++++++++++++++
>  1 file changed, 48 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/endianness/endianness.txt
> 
> diff --git a/Documentation/devicetree/bindings/endianness/endianness.txt b/Documentation/devicetree/bindings/endianness/endianness.txt
> new file mode 100644
> index 0000000..cc5f7f8
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/endianness/endianness.txt
> @@ -0,0 +1,48 @@
> +Device-Tree binding for device endianness
> +
> +The endianness mode of CPU & Device scenarios:
> +Index    CPU       Device     Endianness properties
> +------------------------------------------------------------
> +1        LE        LE         -
> +2        LE        BE         'big-endian{,-*}'
> +3        BE        BE         -
> +4        BE        LE         'little-endian{,-*}'
> +
> +For one device driver, which will run in different scenarios above
> +on different SoCs using the devicetree, we need one way to simplify
> +this.
> +
> +Required properties:
> +- {big,little}-endian{,-*}: these are boolean properties, if absent
> +  meaning that the CPU and the Device are in the same endianness mode.

As stated above, I disagree with this statement.

The endianness of the CPU should have nothing to do with the device
description. The DT should not consider the endianness of the CPU at all
because this can be a dynamic property of the system.  The kernel knows
which endianness the CPU is in, and in some cases the kernel will have
explicitly changed the endianness of the CPU.

All this document needs to say is that if a device may be integrated
with little-endian or big-endian registers, the preferred way to
distinguish between these cases is with a boolean big-endian or
little-endian property. Whether this is required and what the default
happens to be is entirely binding specific.

For those cases where the endianness of sub-componenets may vary (i.e. a
single regsiter may vary endianness, or a whole sub-block), then
big-endian-* and little-endian-* properties are the preferred way to
describe this.

This definitely cannot be required in general. We already have bindings
which optionally use this style of property.

Cheers,
Mark.

> +
> +Examples:
> +Scenario 1 : CPU in LE mode & device in LE mode.
> +dev: dev@40031000 {
> +	      compatible = "name";
> +	      reg = <0x40031000 0x1000>;
> +	      ...
> +};
> +
> +Scenario 2 : CPU in LE mode & device in BE mode.
> +dev: dev@40031000 {
> +	      compatible = "name";
> +	      reg = <0x40031000 0x1000>;
> +	      ...
> +	      big-endian{,-*};
> +};
> +
> +Scenario 3 : CPU in BE mode & device in BE mode.
> +dev: dev@40031000 {
> +	      compatible = "name";
> +	      reg = <0x40031000 0x1000>;
> +	      ...
> +};
> +
> +Scenario 4 : CPU in BE mode & device in LE mode.
> +dev: dev@40031000 {
> +	      compatible = "name";
> +	      reg = <0x40031000 0x1000>;
> +	      ...
> +	      little-endian{,-*};
> +};
> -- 
> 1.8.4
> 
> 
