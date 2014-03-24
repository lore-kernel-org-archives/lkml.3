Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752953AbaCXKt7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 06:49:59 -0400
Received: from co9ehsobe004.messaging.microsoft.com ([207.46.163.27]:39461
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752794AbaCXKt4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 06:49:56 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(zz98dIc89bh1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6h1082kzz1de098h1de097hz2dh2a8h839h947hd25hd2bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h16a6h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1de2h1dfeh1dffh1fe8h1ff5h209eh2216h22d0h2336h2438h2461h2487h24d7h2516h2545h255eh25cch25f6h2605h268bh1155h)
Date: Mon, 24 Mar 2014 17:59:03 +0800
From: Huang Shijie <b32955@freescale.com>
To: Lothar =?iso-8859-1?Q?Wa=DFmann?= <LW@KARO-electronics.de>
CC: Arnd Bergmann <arnd@arndb.de>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Brian Norris <computersforpeace@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Mark Rutland <mark.rutland@arm.com>,
        Pawel Moll <pawel.moll@arm.com>, Rob Herring <robh+dt@kernel.org>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        Sascha Hauer <kernel@pengutronix.de>,
        Shawn Guo <shawn.guo@freescale.com>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-mtd@lists.infradead.org>,
        Shawn Guo <shawn.guo@linaro.org>
Subject: Re: [PATCHv2 1/1] mtd: gpmi: make blockmark swapping optional
Message-ID: <20140324095902.GB11377@localhost>
References: <532BCFCC.4080205@freescale.com>
 <1395399017-19005-1-git-send-email-LW@KARO-electronics.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <1395399017-19005-1-git-send-email-LW@KARO-electronics.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 21, 2014 at 11:50:17AM +0100, Lothar Waﬂmann wrote:
> With a flash-based BBT there is no reason to move the Factory Bad
> Block Marker from the data area buffer (to where it is mapped by the
> GPMI NAND controller) to the OOB buffer. Thus, make this feature
> configurable via DT. This is required for the Ka-Ro electronics
> platforms.
> 
> Signed-off-by: Lothar Waﬂmann <LW@KARO-electronics.de>
> ---
>  Documentation/devicetree/bindings/mtd/gpmi-nand.txt |    3 +++
>  drivers/mtd/nand/gpmi-nand/gpmi-nand.c              |   10 +++++++---
>  2 files changed, 10 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/mtd/gpmi-nand.txt b/Documentation/devicetree/bindings/mtd/gpmi-nand.txt
> index 458d596..f28949a 100644
> --- a/Documentation/devicetree/bindings/mtd/gpmi-nand.txt
> +++ b/Documentation/devicetree/bindings/mtd/gpmi-nand.txt
> @@ -25,6 +25,9 @@ Optional properties:
>                         discoverable or this property is not enabled,
>                         the software may chooses an implementation-defined
>                         ECC scheme.
> +  - fsl,no-blockmark-swap: Don't swap the bad block marker from the OOB
> +                       area with the byte in the data area but rely on the
> +                       BBT for identifying bad blocks.

Please add the following:
       "NOTE: This property is not supported by the imx23 and imx28"
>  
>  The device tree may optionally contain sub-nodes describing partitions of the
>  address space. See partition.txt for more detail.
> diff --git a/drivers/mtd/nand/gpmi-nand/gpmi-nand.c b/drivers/mtd/nand/gpmi-nand/gpmi-nand.c
> index bb77f75..98562eb 100644
> --- a/drivers/mtd/nand/gpmi-nand/gpmi-nand.c
> +++ b/drivers/mtd/nand/gpmi-nand/gpmi-nand.c
> @@ -1632,9 +1632,6 @@ static int gpmi_init_last(struct gpmi_nand_data *this)
>  	struct bch_geometry *bch_geo = &this->bch_geometry;
>  	int ret;
>  
> -	/* Set up swap_block_mark, must be set before the gpmi_set_geometry() */
> -	this->swap_block_mark = !GPMI_IS_MX23(this);
> -
>  	/* Set up the medium geometry */
>  	ret = gpmi_set_geometry(this);
>  	if (ret)
> @@ -1701,6 +1698,13 @@ static int gpmi_nand_init(struct gpmi_nand_data *this)
>  	if (of_get_nand_on_flash_bbt(this->dev->of_node))
>  		chip->bbt_options |= NAND_BBT_USE_FLASH | NAND_BBT_NO_OOB;
>  
> +	/* Set up swap_block_mark, must be set before the gpmi_set_geometry() */
> +	if (!of_property_read_bool(this->dev->of_node, "fsl,no-blockmark-swap"))
> +		this->swap_block_mark = !GPMI_IS_MX23(this);

the code should like this:
----------------------------------------------
	this->swap_block_mark = !GPMI_IS_MX23(this);

	if (!GPMI_IS_IMX23(this) && !GPMI_IS_MX28(this) &&
		of_property_read_bool(this->dev->of_node, "fsl,no-blockmark-swap"))
		this->swap_block_mark = false;
----------------------------------------------
          
> +
> +	dev_dbg(this->dev, "Blockmark swapping %sabled\n",
> +		this->swap_block_mark ? "en" : "dis");
> +
>  	/*
>  	 * Allocate a temporary DMA buffer for reading ID in the
>  	 * nand_scan_ident().

There are some bugs in the gpmi driver which is caused by the assumption that
we always enable the swapping except the imx23. 

So, there are some places should be changed with this patch:
   [1] the subpage hook,
        Please also change the gpmi_ecc_read_subpage() too.

   [2] the OOB hook,
   	Please also change the gpmi_ecc_read_oob(). 


   [3] the markbad hook,
   	Please also change the gpmi_block_markbad() . 

thanks
Huang Shijie
        

	



