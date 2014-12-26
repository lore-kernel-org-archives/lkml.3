Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751688AbaLZJaU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2014 04:30:20 -0500
Received: from nasmtp01.atmel.com ([192.199.1.245]:29737 "EHLO
	DVREDG01.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751211AbaLZJaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2014 04:30:16 -0500
Message-ID: <549D2A9D.50407@atmel.com>
Date: Fri, 26 Dec 2014 17:30:05 +0800
From: Josh Wu <josh.wu@atmel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Boris Brezillon <boris.brezillon@free-electrons.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        <linux-mtd@lists.infradead.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        "Mark Rutland" <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/4] mtd: nand: atmel: Update DT documentation after splitting
 NFC and NAND
References: <1417732214-3292-1-git-send-email-boris.brezillon@free-electrons.com> <1417732214-3292-3-git-send-email-boris.brezillon@free-electrons.com>
In-Reply-To: <1417732214-3292-3-git-send-email-boris.brezillon@free-electrons.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.168.5.13]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Boris

Thanks for the patch.

You need to rebase on the top of current mtd-l2 git tree. As I had some 
change on the binding document.

Best Regards,
Josh Wu

On 12/5/2014 6:30 AM, Boris Brezillon wrote:
> The NAND and NFC (NAND Flash Controller) were linked together with a
> parent <-> child relationship.
>
> This model has several drawbacks:
> - it does not allow for multiple NAND chip handling while the controller
>    support multi-chip (even though the driver is not ready yet)
> - it mixes NAND partitions and NFC nodes at the same level (which is a bit
>    disturbing)
> - the introduction of the EBI bus implies defining NAND chips under the
>    EBI node, and the ranges available under the EBI node should be
>    restricted to EBI address space, while the NFC references several
>    registers outside of these EBI ranges.
>
> Move the NFC node outside of the NAND node, to get a more future-proof
> model.
>
> Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
> ---
>   .../devicetree/bindings/mtd/atmel-nand.txt         | 46 ++++++++++++----------
>   1 file changed, 26 insertions(+), 20 deletions(-)
>
> diff --git a/Documentation/devicetree/bindings/mtd/atmel-nand.txt b/Documentation/devicetree/bindings/mtd/atmel-nand.txt
> index 6edc3b6..8896850 100644
> --- a/Documentation/devicetree/bindings/mtd/atmel-nand.txt
> +++ b/Documentation/devicetree/bindings/mtd/atmel-nand.txt
> @@ -30,15 +30,19 @@ Optional properties:
>     sector size 1024.
>   - nand-bus-width : 8 or 16 bus width if not present 8
>   - nand-on-flash-bbt: boolean to enable on flash bbt option if not present false
> -- Nand Flash Controller(NFC) is a slave driver under Atmel nand flash
> -  - Required properties:
> -    - compatible : "atmel,sama5d3-nfc".
> -    - reg : should specify the address and size used for NFC command registers,
> -            NFC registers and NFC Sram. NFC Sram address and size can be absent
> -            if don't want to use it.
> -    - clocks: phandle to the peripheral clock
> -  - Optional properties:
> -    - atmel,write-by-sram: boolean to enable NFC write by sram.
> +- atmel,nfc: phandle referencing the NAND Flash Controller, if available.
> +
> +The NAND Flash Controller (NFC) is an advanced NAND controller and should be
> +used in conjunction with the NAND flash device.
> +Required properties:
> + - compatible : "atmel,sama5d3-nfc".
> + - reg : should specify the address and size used for NFC command registers,
> +         NFC registers and NFC Sram. NFC Sram address and size can be absent
> +         if you don't want to use it.
> + - clocks: phandle to the peripheral clock
> +
> +Optional properties:
> + - atmel,write-by-sram: boolean to enable NFC write by sram.
>   
>   Examples:
>   nand0: nand@40000000,0 {
> @@ -89,21 +93,23 @@ nand0: nand@40000000 {
>   };
>   
>   /* for NFC supported chips */
> +nfc: nfc@70000000 {
> +	compatible = "atmel,sama5d3-nfc";
> +	#address-cells = <1>;
> +	#size-cells = <1>;
> +	clocks = <&hsmc_clk>
> +	reg = <
> +		0x70000000 0x10000000	/* NFC Command Registers */
> +		0xffffc000 0x00000070	/* NFC HSMC regs */
> +		0x00200000 0x00100000	/* NFC SRAM banks */
> +	>;
> +};
> +
>   nand0: nand@40000000 {
>   	compatible = "atmel,at91rm9200-nand";
>   	#address-cells = <1>;
>   	#size-cells = <1>;
>   	ranges;
> +	atmel,nfc = <&nfc>;
>           ...
> -        nfc@70000000 {
> -		compatible = "atmel,sama5d3-nfc";
> -		#address-cells = <1>;
> -		#size-cells = <1>;
> -		clocks = <&hsmc_clk>
> -		reg = <
> -			0x70000000 0x10000000	/* NFC Command Registers */
> -			0xffffc000 0x00000070	/* NFC HSMC regs */
> -			0x00200000 0x00100000	/* NFC SRAM banks */
> -		>;
> -	};
>   };

