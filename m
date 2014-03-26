Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753444AbaCZIwm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 04:52:42 -0400
Received: from mail.karo-electronics.de ([81.173.242.67]:53919 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217AbaCZIwi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 04:52:38 -0400
Date: Wed, 26 Mar 2014 09:51:56 +0100
From: Lothar =?UTF-8?B?V2HDn21hbm4=?= <LW@KARO-electronics.de>
To: Huang Shijie <b32955@freescale.com>
Cc: Fabio Estevam <fabio.estevam@freescale.com>,
        Mark Rutland <mark.rutland@arm.com>, Shawn Guo <shawn.guo@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, Pawel Moll <pawel.moll@arm.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        linux-mtd@lists.infradead.org, linux-arm-kernel@lists.infradead.org,
        Rob Landley <rob@landley.net>, Kumar Gala <galak@codeaurora.org>,
        Brian Norris <computersforpeace@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Sascha Hauer <kernel@pengutronix.de>,
        Shawn Guo <shawn.guo@freescale.com>
Subject: Re: [PATCHv2 1/1] mtd: gpmi: make blockmark swapping optional
Message-ID: <20140326095156.3e5585b8@ipc1.ka-ro>
In-Reply-To: <20140324095902.GB11377@localhost>
References: <532BCFCC.4080205@freescale.com>
	<1395399017-19005-1-git-send-email-LW@KARO-electronics.de>
	<20140324095902.GB11377@localhost>
Organization: Ka-Ro electronics GmbH
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Huang Shijie wrote:
> On Fri, Mar 21, 2014 at 11:50:17AM +0100, Lothar Waßmann wrote:
> > With a flash-based BBT there is no reason to move the Factory Bad
> > Block Marker from the data area buffer (to where it is mapped by the
> > GPMI NAND controller) to the OOB buffer. Thus, make this feature
> > configurable via DT. This is required for the Ka-Ro electronics
> > platforms.
> > 
> > Signed-off-by: Lothar Waßmann <LW@KARO-electronics.de>
> > ---
> >  Documentation/devicetree/bindings/mtd/gpmi-nand.txt |    3 +++
> >  drivers/mtd/nand/gpmi-nand/gpmi-nand.c              |   10 +++++++---
> >  2 files changed, 10 insertions(+), 3 deletions(-)
> > 
> > diff --git a/Documentation/devicetree/bindings/mtd/gpmi-nand.txt b/Documentation/devicetree/bindings/mtd/gpmi-nand.txt
> > index 458d596..f28949a 100644
> > --- a/Documentation/devicetree/bindings/mtd/gpmi-nand.txt
> > +++ b/Documentation/devicetree/bindings/mtd/gpmi-nand.txt
> > @@ -25,6 +25,9 @@ Optional properties:
> >                         discoverable or this property is not enabled,
> >                         the software may chooses an implementation-defined
> >                         ECC scheme.
> > +  - fsl,no-blockmark-swap: Don't swap the bad block marker from the OOB
> > +                       area with the byte in the data area but rely on the
> > +                       BBT for identifying bad blocks.
> 
> Please add the following:
>        "NOTE: This property is not supported by the imx23 and imx28"
>
I don't see why this should not be supported on i.MX28 (i.MX23 doesn't
do byteswapping anyway, so this wouldn't change anything for i.MX23).
The partitions used by Linux need not necessarily be accessible for the
Boot ROM code (and vice versa).

> >  The device tree may optionally contain sub-nodes describing partitions of the
> >  address space. See partition.txt for more detail.
> > diff --git a/drivers/mtd/nand/gpmi-nand/gpmi-nand.c b/drivers/mtd/nand/gpmi-nand/gpmi-nand.c
> > index bb77f75..98562eb 100644
> > --- a/drivers/mtd/nand/gpmi-nand/gpmi-nand.c
> > +++ b/drivers/mtd/nand/gpmi-nand/gpmi-nand.c
> > @@ -1632,9 +1632,6 @@ static int gpmi_init_last(struct gpmi_nand_data *this)
> >  	struct bch_geometry *bch_geo = &this->bch_geometry;
> >  	int ret;
> >  
> > -	/* Set up swap_block_mark, must be set before the gpmi_set_geometry() */
> > -	this->swap_block_mark = !GPMI_IS_MX23(this);
> > -
> >  	/* Set up the medium geometry */
> >  	ret = gpmi_set_geometry(this);
> >  	if (ret)
> > @@ -1701,6 +1698,13 @@ static int gpmi_nand_init(struct gpmi_nand_data *this)
> >  	if (of_get_nand_on_flash_bbt(this->dev->of_node))
> >  		chip->bbt_options |= NAND_BBT_USE_FLASH | NAND_BBT_NO_OOB;
> >  
> > +	/* Set up swap_block_mark, must be set before the gpmi_set_geometry() */
> > +	if (!of_property_read_bool(this->dev->of_node, "fsl,no-blockmark-swap"))
> > +		this->swap_block_mark = !GPMI_IS_MX23(this);
> 
> the code should like this:
> ----------------------------------------------
> 	this->swap_block_mark = !GPMI_IS_MX23(this);
> 
> 	if (!GPMI_IS_IMX23(this) && !GPMI_IS_MX28(this) &&
>
the !GPMI_IS_MX23() is redundant here as i.MX23 will always have
swap_block_mark == false.
I would rather add a dependency on nand-on-flash-bbt as a
prerequisite for not checking the BB marks in each block.

> > +
> > +	dev_dbg(this->dev, "Blockmark swapping %sabled\n",
> > +		this->swap_block_mark ? "en" : "dis");
> > +
> >  	/*
> >  	 * Allocate a temporary DMA buffer for reading ID in the
> >  	 * nand_scan_ident().
> 
> There are some bugs in the gpmi driver which is caused by the assumption that
> we always enable the swapping except the imx23. 
> 
> So, there are some places should be changed with this patch:
>    [1] the subpage hook,
>         Please also change the gpmi_ecc_read_subpage() too.
> 
>    [2] the OOB hook,
>    	Please also change the gpmi_ecc_read_oob(). 
> 
>    [3] the markbad hook,
>    	Please also change the gpmi_block_markbad() . 
> 
OK, I'll check that.


Lothar Waßmann
-- 
___________________________________________________________

Ka-Ro electronics GmbH | Pascalstraße 22 | D - 52076 Aachen
Phone: +49 2408 1402-0 | Fax: +49 2408 1402-10
Geschäftsführer: Matthias Kaussen
Handelsregistereintrag: Amtsgericht Aachen, HRB 4996

www.karo-electronics.de | info@karo-electronics.de
___________________________________________________________
