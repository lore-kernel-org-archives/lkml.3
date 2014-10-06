Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752414AbaJFFGe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 01:06:34 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:33032 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751264AbaJFFGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 01:06:31 -0400
Date: Sun, 5 Oct 2014 22:06:26 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel@stlinux.com, pekon@pek-sem.com, linux-mtd@lists.infradead.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH 5/9] mtd: nand: stm_nand_bch: provide Device Tree
 documentation
Message-ID: <20141006050626.GF3248@norris-Latitude-E6410>
References: <1409143344-22458-1-git-send-email-lee.jones@linaro.org>
 <1409143344-22458-6-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409143344-22458-6-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2014 at 01:42:20PM +0100, Lee Jones wrote:
> This is where we describe the different new and generic options used by
> the ST BCH driver.
> 
> Cc: devicetree@vger.kernel.org
> Reviewed-By: Pekon Gupta <pekon@pek-sem.com>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  Documentation/devicetree/bindings/mtd/stm-nand.txt | 74 ++++++++++++++++++++++
>  1 file changed, 74 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/mtd/stm-nand.txt
> 
> diff --git a/Documentation/devicetree/bindings/mtd/stm-nand.txt b/Documentation/devicetree/bindings/mtd/stm-nand.txt
> new file mode 100644
> index 0000000..5872a39
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/mtd/stm-nand.txt
> @@ -0,0 +1,74 @@
> +STM BCH NAND Support
> +--------------------
> +
> +Required properties:
> +
> +- compatible		: Should be "st,nand-bch"
> +- reg			: Should contain register's location and length
> +- reg-names		: "emi_nand" - NAND Controller register map
> +			  "emiss" - External Memory Interface Subsystem base
> +- interrupts		: Interrupt number
> +- interrupt-names	: "nand_irq" - NAND Controller IRQ
> +- st,nand-banks		: Subnode representing one or more "banks" of NAND
> +			  Flash, connected to an STM NAND Controller (see
> +			  description below).

Why plural? Shouldn't you have one node for each bank, as they are
independent? Also, I don't see this property being used anywhere, even
though it's listed as "required".

Really, this property shouldn't be listed here (under the NAND
controller node), but should only be listed under the bank description
below (and it should actually be *used* there).

> +- nand-ecc-strength	: Generic NAND property (See mtd/nand.txt)
> +			  Options are; 0, 18 or 30. If not present, the driver
> +			  will choose the strongest scheme compatible if the
> +			  OOB size.

nand-ecc-strength is optional, not required.

Also, this is probably where you should add a paragraph about how the
NAND controller node should contain one or more banks, each of which
represents an attached NAND flash and can be described using the
following:

> +
> +Properties describing Bank of NAND Flash ("st,nand-banks"):
> +

You should list a "compatible" property here (i.e., "st,nand-bank" or
"st,nand-banks").

> +- st,nand-csn		: Chip select associated with the Bank.

I'm pretty sure a chip select is not very specific to ST. Maybe we
should have a generic "nand-chip-select" or "nand-cs" property for
Documentation/devicetree/bindings/mtd/nand.txt. I know of at least one
other piece of hardware that could use this property.

> +
> +- st,nand-timing-relax	: [Optional] Number of IP clock cycles by which to
> +			  "relax" timing configuration.  Required on some boards
> +			  to accommodate board-level limitations. Applies to
> +			  ONFI timing mode configuration.
> +
> +- nand-on-flash-bbt	: Generic NAND property (See mtd/nand.txt)
> +
> +- partitions		: [Optional] Subnode describing MTD partition map
> +			  (see mtd/partition.txt)

Hmm, does this really need a separate subnode? That doesn't seem to be
the best description, and it doesn't match standard practice AFAICT.
Can't you just have the partition nodes be direct subnodes of the NAND
bank?

> +
> +Note, during initialisation, the NAND Controller timing registers are configured
> +according to one of the following methods, in order of precedence:
> +
> +	   1. Configuration based on ONFI timing mode, as advertised by the
> +	      device during ONFI-probing (ONFI-compliant NAND only).
> +
> +	   2. Use reset/safe timing values
> +
> +Example:
> +
> +	nand@fe901000 {
> +		compatible = "st,nand-bch";
> +		reg = <0xfe901000 0x1000>, <0xfef00800 0x0800>;
> +		reg-names = "emi_nand", "emiss";
> +		interrupts = <0 139 0x0>;
> +		interrupt-names = "nand_irq";
> +		nand-ecc-strength = <30>;
> +
> +		status = "okay";
> +
> +		bank0 {

No "compatible" property? (BTW, be sure to update the *.dts* files if
we're updating this binding doc.)

> +			/* NAND_BBT_USE_FLASH */

This comment doesn't belong here.

> +			nand-on-flash-bbt;
> +			st,nand-csn		= <0>;
> +
> +			partitions {
> +				#address-cells = <1>;
> +				#size-cells = <1>;
> +
> +				partition@0{
> +					label = "NANDFlash1";
> +					reg = <0x00000000 0x00800000>;
> +				};
> +
> +				partition@800000{
> +					label = "NANDFlash2";
> +					reg = <0x00800000 0x0f800000>;
> +				};
> +			};
> +		};
> +	};

Brian
