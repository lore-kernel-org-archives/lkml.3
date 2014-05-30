Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934307AbaE3Q5U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 12:57:20 -0400
Received: from p3plex2out03.prod.phx3.secureserver.net ([184.168.131.16]:56113
	"EHLO p3plex2out03.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933745AbaE3Q5P convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 12:57:15 -0400
From: Hartley Sweeten <HartleyS@visionengravers.com>
To: Chase Southwood <chase.southwood@gmail.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "abbotti@mev.co.uk" <abbotti@mev.co.uk>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 5/6] staging: comedi: addi_apci_1564: hook-up the
 interrupt subdevice
Thread-Topic: [PATCH 5/6] staging: comedi: addi_apci_1564: hook-up the
 interrupt subdevice
Thread-Index: AQHPe8HEojo9AYwBUk2s24XPSyRPGJtZVoig
Date: Fri, 30 May 2014 16:57:14 +0000
Message-ID: <DC148C5AA1CEBA4E87973D432B1C2D8825E83E2A@P3PWEX4MB008.ex4.secureserver.net>
References: <1401424853-21683-1-git-send-email-chase.southwood@gmail.com>
 <1401425014-22548-1-git-send-email-chase.southwood@gmail.com>
In-Reply-To: <1401425014-22548-1-git-send-email-chase.southwood@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [184.183.19.121]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, May 29, 2014 9:44 PM, Chase Southwood wrote:
> The board supported by this driver can generate an interrupt based
> on the state of input channels 0-15.
>
> The apci1564_di_config() function is used to configure which
> inputs are used to generate the interrupt. Currently this function
> is broken since it does not follow the comedi API for insn_config
> functions. Fix this function by implementing the config instruction
> INSN_CONFIG_DIGITAL_TRIG.
>
> Add the remaining subdevice operations necessary for the interrupt
> subdevice to support async commands.
>
> Signed-off-by: Chase Southwood <chase.southwood@gmail.com>
> Cc: Ian Abbott <abbotti@mev.co.uk>
> Cc: H Hartley Sweeten <hsweeten@visionengravers.com>
> ---
>
> The structure of _much_ of this code was taken from/based on the similar
> code found in addi_apci_1032.c.  As such, I would appreciate as much
> review I can get to make sure what I've done here actually makes sense
> for this driver :)
>
>  .../comedi/drivers/addi-data/hwdrv_apci1564.c      |  37 +---
>  drivers/staging/comedi/drivers/addi_apci_1564.c    | 228 +++++++++++++++++++--
>  2 files changed, 210 insertions(+), 55 deletions(-)
>
> diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
> index 054e731..41aa889 100644
> --- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
> +++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
> @@ -95,45 +95,14 @@ static unsigned int ui_InterruptData, ui_Type;
>  
>  struct apci1564_private {
>  	unsigned int amcc_iobase;	/* base of AMCC I/O registers */
> +	unsigned int mode1;		/* riding-edge/high level channels */
> +	unsigned int mode2;		/* falling-edge/low level channels */
> +	unsigned int ctrl;		/* interrupt mode OR (edge) . AND (level) */
>  	unsigned char timer_select_mode;
>  	unsigned char mode_select_register;
>  };

[snip]

> diff --git a/drivers/staging/comedi/drivers/addi_apci_1564.c b/drivers/staging/comedi/drivers/addi_apci_1564.c
> index 183fdc3..cf58f90 100644
> --- a/drivers/staging/comedi/drivers/addi_apci_1564.c
> +++ b/drivers/staging/comedi/drivers/addi_apci_1564.c
> @@ -8,6 +8,42 @@
>  
>  #include "addi-data/hwdrv_apci1564.c"
>  
> +#define APCI1564_CTRL_INT_OR		(0 << 1)
> +#define APCI1564_CTRL_INT_AND		(1 << 1)
> +#define APCI1564_CTRL_INT_ENA		(1 << 2)
> +
> +static int apci1564_reset(struct comedi_device *dev)
> +{
> +	struct apci1564_private *devpriv = dev->private;
> +
> +	ui_Type = 0;
> +
> +	/* Disable the input interrupts and reset status register */
> +	outl(0x0, devpriv->amcc_iobase + APCI1564_DI_IRQ_REG);
> +	inl(devpriv->amcc_iobase + APCI1564_DI_INT_STATUS_REG);
> +	outl(0x0, devpriv->amcc_iobase + APCI1564_DI_INT_MODE1_REG);
> +	outl(0x0, devpriv->amcc_iobase + APCI1564_DI_INT_MODE2_REG);
> +
> +	/* Reset the output channels and disable interrupts */
> +	outl(0x0, devpriv->amcc_iobase + APCI1564_DO_REG);
> +	outl(0x0, devpriv->amcc_iobase + APCI1564_DO_INT_CTRL_REG);
> +
> +	/* Reset the watchdog registers */
> +	addi_watchdog_reset(devpriv->amcc_iobase + APCI1564_WDOG_REG);
> +
> +	/* Reset the timer registers */
> +	outl(0x0, devpriv->amcc_iobase + APCI1564_TIMER_CTRL_REG);
> +	outl(0x0, devpriv->amcc_iobase + APCI1564_TIMER_RELOAD_REG);
> +
> +	/* Reset the counter registers */
> +	outl(0x0, dev->iobase + APCI1564_TCW_CTRL_REG(APCI1564_COUNTER1));
> +	outl(0x0, dev->iobase + APCI1564_TCW_CTRL_REG(APCI1564_COUNTER2));
> +	outl(0x0, dev->iobase + APCI1564_TCW_CTRL_REG(APCI1564_COUNTER3));
> +	outl(0x0, dev->iobase + APCI1564_TCW_CTRL_REG(APCI1564_COUNTER4));
> +
> +	return 0;
> +}

You are using this 'board reset' function as the (*cancel) operation for the interrupt
subdevice. I think this is a bit too aggressive for the (*cancel) since it also resets all
the outputs, the watchdog, and timer/counters.

Pull out the first chunk of this function that disables the interrupts and use that for
the (*cancel) operation.
 
The reset seems to look ok.

Regards,
Hartley

