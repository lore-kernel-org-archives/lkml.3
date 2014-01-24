Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751802AbaAXJeG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 04:34:06 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:40025 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750753AbaAXJd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 04:33:59 -0500
Date: Fri, 24 Jan 2014 09:33:49 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Mark Brown <broonie@kernel.org>,
        "linux-spi@vger.kernel.org" <linux-spi@vger.kernel.org>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH v4 13/14] spi: rspi: Add DT support
Message-ID: <20140124093349.GK15586@e106331-lin.cambridge.arm.com>
References: <1390553044-11860-1-git-send-email-geert@linux-m68k.org>
 <1390553044-11860-14-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1390553044-11860-14-git-send-email-geert@linux-m68k.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 24, 2014 at 08:44:03AM +0000, Geert Uytterhoeven wrote:
> From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
> Cc: devicetree@vger.kernel.org
> ---
> v2:
>   - Clarify RSPI/QSPI
>   - Add interrupt-parent
>   - s/should/must/ for #address-cells and #size-cells
> v3:
>   - Add renesas,rspi-sh
>   - Drop -rcar suffix for QSPI
>   - Clarify num-cs
>   - Implement DT support in driver
>   - Changed one-line summary from "Documentation: dt: Add Renesas RSPI/QSPI
>     bindings" to "spi: rspi: Add DT support"
> v4:
>   - Clarify SoCtype and interrupts
>   - Add clock property
>   - Add QSPI example
>   - Add interrupt-names
>   - Add link to Renesas pinctrl
>   - Rename "renesas,rspi-sh" to "renesas,rspi", to match platform device
>     naming
>   - spi-rspi.c:
>       - Remove Soc-specific matching from spi-rspi.c given the fallback is
> 	mandatory
>       - Things became a lot simpler due to the replacement of platform_data
>         fields by the "rspi-rz" platform device binding.
> ---
>  Documentation/devicetree/bindings/spi/spi-rspi.txt |   58 +++++++++++
>  drivers/spi/spi-rspi.c                             |  106 ++++++++++++++------
>  2 files changed, 135 insertions(+), 29 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/spi/spi-rspi.txt
> 
> diff --git a/Documentation/devicetree/bindings/spi/spi-rspi.txt b/Documentation/devicetree/bindings/spi/spi-rspi.txt
> new file mode 100644
> index 000000000000..ed84299a9c61
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/spi/spi-rspi.txt
> @@ -0,0 +1,58 @@
> +Device tree configuration for Renesas RSPI/QSPI driver
> +
> +Required properties:
> +- compatible       : For Renesas Serial Peripheral Interface on legacy SH:
> +		     "renesas,rspi-<soctype>", "renesas,rspi" as fallback.
> +		     For Renesas Serial Peripheral Interface on RZ/A1H:
> +		     "renesas,rspi-<soctype>", "renesas,rspi-rz" as fallback.
> +		     For Quad Serial Peripheral Interface on R-Car Gen2:
> +		     "renesas,qspi-<soctype>", "renesas,qspi" as fallback.
> +		     Examples of valid soctypes are "sh7757" (SH),
> +		     "r7s72100" (RZ/A1H), "r8a7790" (R-Car H2), and
> +		     "r8a7791" (R-Car M2).
> +- reg              : Address start and address range size of the device
> +- interrupts       : 1 interrupt for RSPI cores using a single multiplexed
> +		     interrupt,
> +		     3 interrupts (SPEI, SPRI, SPTI) for RSPI cores using
> +		     separate interrupts.
> +- interrupt-names  : Array of strings associated with the interrupt numbers:
> +		     "error" for SPEI, "rx" for SPRI, and "tx" for SPTI.
> +		     For RSPI cores using a single multiplexed interrupt, the
> +		     name "mux" is optional.


Rather than defining the set of interrupts twice, it would be nice to
have interrupts defined in terms of interrupt-names:

- interrupts: a list of interrupt-specifiers, one for each entry in
  interrupt-names. If interrupt-names is not present, an interrupt
  specifier for a single muxed interrupt.

- interrupt-names: A list of interrupt names. Should contain (if
  present):
  * "error" for SPEI
  * "rx" for SPRI
  * "tx" to SPTI
  * "mux" for a single muxed interrupt

Thanks,
Mark.
