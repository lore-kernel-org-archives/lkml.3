Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755333AbaBUOe0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 09:34:26 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:62583 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754253AbaBUOeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 09:34:24 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Alistair Popple <alistair@popple.id.au>
Cc: benh@kernel.crashing.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 7/7] powerpc: Added PCI MSI support using the HSTA module
Date: Fri, 21 Feb 2014 15:33:58 +0100
Message-ID: <1574137.lzDhNaVqIe@wuerfel>
User-Agent: KMail/4.11.3 (Linux/3.11.0-15-generic; KDE/4.11.3; x86_64; ; )
In-Reply-To: <1392964293-13687-8-git-send-email-alistair@popple.id.au>
References: <1392964293-13687-1-git-send-email-alistair@popple.id.au> <1392964293-13687-8-git-send-email-alistair@popple.id.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:URxkyDtmmADexlmo4ERdoyK7cohOp+yPaqada37PDM9
 w0JoY1Str78L+gWUrQNzO2TopsjIyaZ5EJWw5Qk5HvgS9ficJm
 SVN23j9GkIH1EJjMMkc5SwEuX/YzpuUhmY+rahVrxWqIGLcbwW
 UYFJtrQ5cETco/6LveBivCC1a1wVMZnxG6p4K5kknApWEtMvKx
 b2RvoukMTREPS6xsQpGkT+qZw/4xRwXfm8Zpgm04Zc2LrN2lJ+
 K5vq8nIgSjGhu5gA3xvx8mI0CrnyDQpd6Vf2sEjwSfD6/Hx2jj
 4ayovOV/xBmCsXA/ZGOmmatq16bu60lZul4HaI9/ZTj/hNhxkR
 7Rm+x9ojJ0IsVtXvR5n8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 21 February 2014 17:31:33 Alistair Popple wrote:
>  
> +		HSTA0: hsta@310000e0000 {
> +			compatible = "ibm,476gtr-hsta-msi", "ibm,hsta-msi";
> +			reg = <0x310 0x000e0000 0x0 0xf0>;
> +			interrupt-parent = <&MPIC>;
> +			interrupts = <108 0
> +				      109 0
> +				      110 0
> +				      111 0
> +				      112 0
> +				      113 0
> +				      114 0
> +				      115 0
> +				      116 0
> +				      117 0
> +				      118 0
> +				      119 0
> +				      120 0
> +				      121 0
> +				      122 0
> +				      123 0>;
> +		};

Please add a binding to Documentation/devicetree for this device.

> @@ -242,8 +264,10 @@
>  			ranges = <0x02000000 0x00000000 0x80000000 0x00000110 0x80000000 0x0 0x80000000
>  			          0x01000000 0x0        0x0        0x00000140 0x0        0x0 0x00010000>;
>  
> -			/* Inbound starting at 0 to memsize filled in by zImage */
> -			dma-ranges = <0x42000000 0x0 0x0 0x0 0x0 0x0 0x0>;
> +			/* Inbound starting at 0x0 to 0x40000000000. In order to use MSI
> +			 * PCI devices must be able to write to the HSTA module.
> +			 */
> +			dma-ranges = <0x42000000 0x0 0x0 0x0 0x0 0x400 0x0>;
>  
>  			/* This drives busses 0 to 0xf */
>  			bus-range = <0x0 0xf>;

Ah, I first only saw the line you are removing and was about
to suggest what you do anyway. Great!

> diff --git a/arch/powerpc/sysdev/ppc4xx_pci.c b/arch/powerpc/sysdev/ppc4xx_pci.c
> index 54ec1d5..7cc3acc 100644
> --- a/arch/powerpc/sysdev/ppc4xx_pci.c
> +++ b/arch/powerpc/sysdev/ppc4xx_pci.c
> @@ -176,8 +176,12 @@ static int __init ppc4xx_parse_dma_ranges(struct pci_controller *hose,
>  		return -ENXIO;
>  	}
>  
> -	/* Check that we are fully contained within 32 bits space */
> -	if (res->end > 0xffffffff) {
> +	/* Check that we are fully contained within 32 bits space if we are not
> +	 * running on a 460sx or 476fpe which have 64 bit bus addresses.
> +	 */
> +	if (res->end > 0xffffffff &&
> +	    !(of_device_is_compatible(hose->dn, "ibm,plb-pciex-460sx")
> +	      || of_device_is_compatible(hose->dn, "ibm,plb-pciex-476fpe"))) {
>  		printk(KERN_ERR "%s: dma-ranges outside of 32 bits space\n",
>  		       hose->dn->full_name);
>  		return -ENXIO;

A more general question for BenH: Apparently this PCI implementation is
getting reused on arm64 for APM X-Gene. Do you see any value in trying to
share host controller drivers like this one across powerpc and arm64?

It's possible we are going to see the same situation with fsl_pci in the
future, if arm and powerpc qoriq chips use the same peripherals. My
plan for arm64 right now is to make PCI work without any code in arch/,
just using new helper functions in drivers/pci and sticking the host
drivers into drivers/pci/host as we started doing for arm32, but it
can require significant work to make those drivers compatible with
the powerpc pci-common.c.

	Arnd
