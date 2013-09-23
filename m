Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887Ab3IWOIa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 10:08:30 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:41965 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753493Ab3IWOI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 10:08:28 -0400
Date: Mon, 23 Sep 2013 15:08:23 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
Cc: "kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "rob@landley.net" <rob@landley.net>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "t.figa@samsung.com" <t.figa@samsung.com>,
        "m.szyprowski@samsung.com" <m.szyprowski@samsung.com>,
        "b.zolnierkie@samsung.com" <b.zolnierkie@samsung.com>
Subject: Re: [PATCH v2] MTD: Onenand: Add device tree support for samsung
 onenand
Message-ID: <20130923140823.GC16069@e106331-lin.cambridge.arm.com>
References: <1379941608-5068-1-git-send-email-m.krawczuk@partner.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1379941608-5068-1-git-send-email-m.krawczuk@partner.samsung.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 23, 2013 at 02:06:48PM +0100, Mateusz Krawczuk wrote:
> This patch add clk and device tree nodes for samsung onenand driver.
> 
> since v1:
> Updated Documentation according to Mark Rutland notes.
> 
> Signed-off-by: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  .../devicetree/bindings/mtd/samsung-onenand.txt    | 44 ++++++++++++++++++++++
>  drivers/mtd/onenand/samsung.c                      | 37 +++++++++++++++++-
>  2 files changed, 80 insertions(+), 1 deletion(-)
>  create mode 100644 Documentation/devicetree/bindings/mtd/samsung-onenand.txt
> 
> diff --git a/Documentation/devicetree/bindings/mtd/samsung-onenand.txt b/Documentation/devicetree/bindings/mtd/samsung-onenand.txt
> new file mode 100644
> index 0000000..5bf931c
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/mtd/samsung-onenand.txt
> @@ -0,0 +1,44 @@
> +Device tree bindings for Samsung Onenand
> +
> +Required properties:
> +  - compatible: value should be either of the following.
> +      (a) "samsung,s3c6400-onenand",
> +		for onenand controller compatible with s3c6400.
> +      (b) "samsung,s3c6410-onenand",
> +		for onenand controller compatible with s3c6410.
> +      (c) "samsung,s5pc100-onenand",
> +		for onenand controller compatible with s5pc100.
> +      (d) "samsung,s5pc110-onenand",
> +      for s5pc100-like onenand controller used on s5pc110 which supports DMA.
> +

As I asked on the last posting, what are the differences between these
implementations?

> +Required properties for s5pc110:
> +
> + - reg: the offset and length of the control registers. First region describes
> +	OneNAND interface, second control registers.

Also, the complete reg description is a bit confusing. How about
something like:

 - reg: two register specifiers:
        [0] - The OneNAND interface
	[1] - The control registers

Do we expect future OneNAND devices which may require more reg entries
to describe?

> + - interrupt-parent, interrupts		Onenand memory interrupts

As it's a common property, I don't think interrupt-parent needs to
be described.

Is there more than one interrupt? What's it called on the manual?

> +
> +Required properties for others:
> +
> + - reg: the offset and length of the control registers. First region describes
> +	control registers, second OneNAND interface.

Why does the s5pc110 OneNAND binding take its registers in the opposite
order to the rest of these? Can we not fix up the driver first to make
it consistent? Then we only need to describe this once and it's going to
be far less of a headache to support.

> +
> +Clocks:
> + - gate - clock which output is supplied to external OneNAND flash memory.

How about the following (without the Clocks header):

- clocks: clock-specifiers for the clocks named in clock-names, per the
          common clock bindings.

- clock-names: should contain "gate" for the clock to the OneNAND flash
               memory.

Is this the only clock that might be necessary on all platforms?

> +
> +
> +For partiton table parsing (optional) please refer to:
> + [1] Documentation/devicetree/bindings/mtd/partition.txt
> +
> +Example for an s5pv210 board:
> +
> +		onenand@b0000000 {
> +			compatible = "samsung,s5pc110-onenand";
> +			reg = <0xb0000000 0x20000>, <0xb0600000 0x2000>;
> +			interrupt-parent = <&vic1>;
> +			interrupts = <31>;
> +			#address-cells = <1>;
> +			#size-cells = <1>;
> +			clocks = <&clocks NANDXL>;
> +			clock-names = "gate";
> +			status = "okay";
> +		};

Cheers,
Mark.
