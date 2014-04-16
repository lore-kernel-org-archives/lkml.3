Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756751AbaDPVzB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 17:55:01 -0400
Received: from p3plex2out02.prod.phx3.secureserver.net ([184.168.131.14]:36281
	"EHLO p3plex2out02.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754550AbaDPVy7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 17:54:59 -0400
From: Hartley Sweeten <HartleyS@visionengravers.com>
To: Chase Southwood <chase.southwood@yahoo.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "abbotti@mev.co.uk" <abbotti@mev.co.uk>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 2/2 v2] staging: comedi: addi_apci_1564: fixup and
 absorb apci1564_reset()
Thread-Topic: [PATCH 2/2 v2] staging: comedi: addi_apci_1564: fixup and
 absorb apci1564_reset()
Thread-Index: AQHPWUE7M3nOdFBij0yv+F/IFwsTw5sUxzdA
Date: Wed, 16 Apr 2014 21:54:58 +0000
Message-ID: <DC148C5AA1CEBA4E87973D432B1C2D8825E04EF4@P3PWEX4MB008.ex4.secureserver.net>
References: <1397631465-13169-1-git-send-email-chase.southwood@yahoo.com>
In-Reply-To: <1397631465-13169-1-git-send-email-chase.southwood@yahoo.com>
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

On Tuesday, April 15, 2014 11:58 PM, Chase Southwood wrote:
> We can remove this function from the boardinfo and move the code from
> hwdrv_apci1564.c into addi_apci_1564.c since it is the only reset function
> used by the driver. The function was also messy and failed to reset a few
> registers, these issues were fixed on the move.
>
> Signed-off-by: Chase Southwood <chase.southwood@yahoo.com>
> ---
> 2: *Changed order of register accesses for digital input registers back to
> original ordering.
> *Removed read of digital output status register and reordered the accesses
> of digital output registers to agree with the order found in addi_apci_2032.
> *Fixed copy/paste error in the counter register reset lines.
>
> Ian, I addressed your comments as above.
> Chase
>  .../comedi/drivers/addi-data/hwdrv_apci1564.c      | 28 ---------------
>  drivers/staging/comedi/drivers/addi_apci_1564.c    | 40 +++++++++++++++++++++-
>  2 files changed, 39 insertions(+), 29 deletions(-)
>
> diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
> index 4db3bea..45617cf 100644
> --- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
> +++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
> @@ -576,31 +576,3 @@ static void apci1564_interrupt(int irq, void *d)
>  	}
>  	return;
>  }
> -
> -static int apci1564_reset(struct comedi_device *dev)
> -{
> -	struct addi_private *devpriv = dev->private;
> -
> -	/* disable the interrupts */
> -	outl(0x0, devpriv->i_IobaseAmcc + APCI1564_DI_IRQ_REG);
> -	/* Reset the interrupt status register */
> -	inl(devpriv->i_IobaseAmcc + APCI1564_DI_INT_STATUS_REG);
> -	/* Disable the and/or interrupt */
> -	outl(0x0, devpriv->i_IobaseAmcc + APCI1564_DI_INT_MODE1_REG);
> -	outl(0x0, devpriv->i_IobaseAmcc + APCI1564_DI_INT_MODE2_REG);
> -	devpriv->b_DigitalOutputRegister = 0;
> -	ui_Type = 0;
> -	/* Resets the output channels */
> -	outl(0x0, devpriv->i_IobaseAmcc + APCI1564_DO_REG);
> -	/* Disables the interrupt. */
> -	outl(0x0, devpriv->i_IobaseAmcc + APCI1564_DO_INT_CTRL_REG);
> -	outl(0x0, devpriv->i_IobaseAmcc + APCI1564_WDOG_RELOAD_REG);
> -	outl(0x0, devpriv->i_IobaseAmcc + APCI1564_TIMER_REG);
> -	outl(0x0, devpriv->i_IobaseAmcc + APCI1564_TIMER_CTRL_REG);
> -
> -	outl(0x0, dev->iobase + APCI1564_TCW_CTRL_REG(APCI1564_COUNTER1));
> -	outl(0x0, dev->iobase + APCI1564_TCW_CTRL_REG(APCI1564_COUNTER2));
> -	outl(0x0, dev->iobase + APCI1564_TCW_CTRL_REG(APCI1564_COUNTER3));
> -	outl(0x0, dev->iobase + APCI1564_TCW_CTRL_REG(APCI1564_COUNTER4));
> -	return 0;
> -}
> diff --git a/drivers/staging/comedi/drivers/addi_apci_1564.c b/drivers/staging/comedi/drivers/addi_apci_1564.c
> index 11aa0bd..546dad7 100644
> --- a/drivers/staging/comedi/drivers/addi_apci_1564.c
> +++ b/drivers/staging/comedi/drivers/addi_apci_1564.c
> @@ -4,6 +4,7 @@
>  #include "../comedidev.h"
>  #include "comedi_fc.h"
>  #include "amcc_s5933.h"
> +#include "addi_watchdog.h"
>  
>  #include "addi-data/addi_common.h"
>  
> @@ -22,7 +23,6 @@ static const struct addi_board apci1564_boardtypes[] = {
>  		.i_DoMaxdata		= 0xffffffff,
>  		.i_Timer		= 1,
>  		.interrupt		= apci1564_interrupt,
> -		.reset			= apci1564_reset,

You can't do this yet.

The addi_acpi_1564 driver needs to be separated from addi_common.c before you
can start ripping the callbacks out of this struct.

If you compile test this you will see:
  CC [M]  drivers/staging/comedi/drivers/addi_apci_1564.o
In file included from drivers/staging/comedi/drivers/addi_apci_1564.c:11:0:
drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c:581:12: warning: 'apci1564_reset' defined but not used [-Wunused-function]

>  		.di_config		= apci1564_di_config,
>  		.di_bits		= apci1564_di_insn_bits,
>  		.do_config		= apci1564_do_config,
> @@ -34,6 +34,44 @@ static const struct addi_board apci1564_boardtypes[] = {
>  	},
>  };
>  
> +static int apci1564_reset(struct comedi_device *dev)
> +{
> +	struct addi_private *devpriv = dev->private;
> +
> +	ui_Type = 0;
> +
> +	/* Disable the input interrupts and reset status register */
> +	outl(0x0, devpriv->i_IobaseAmcc + APCI1564_DI_IRQ_REG);
> +	inl(devpriv->i_IobaseAmcc + APCI1564_DI_INT_STATUS_REG);
> +	outl(0x0, devpriv->i_IobaseAmcc + APCI1564_DI_INT_MODE1_REG);
> +	outl(0x0, devpriv->i_IobaseAmcc + APCI1564_DI_INT_MODE2_REG);
> +
> +	/* Reset the output channels and disable interrupts */
> +	outl(0x0, devpriv->i_IobaseAmcc + APCI1564_DO_IRQ_REG);

This register is read only. Bit 0 is set if there is a digital output IRQ pending.

> +	outl(0x0, devpriv->i_IobaseAmcc + APCI1564_DO_REG);
> +	outl(0x0, devpriv->i_IobaseAmcc + APCI1564_DO_INT_CTRL_REG);
> +
> +	/* Reset the watchdog registers */
> +	addi_watchdog_reset(devpriv->i_IobaseAmcc + APCI1564_WDOG_REG);
> +
> +	/* Reset the timer registers */
> +	outl(0x0, devpriv->i_IobaseAmcc + APCI1564_TIMER_CTRL_REG);
> +	outl(0x0, devpriv->i_IobaseAmcc + APCI1564_TIMER_RELOAD_REG);
> +
> +	/* Reset the counter registers */
> +	outl(0x0, dev->iobase + APCI1564_TCW_CTRL_REG(APCI1564_COUNTER1));
> +	outl(0x0, dev->iobase + APCI1564_TCW_CTRL_REG(APCI1564_COUNTER2));
> +	outl(0x0, dev->iobase + APCI1564_TCW_CTRL_REG(APCI1564_COUNTER3));
> +	outl(0x0, dev->iobase + APCI1564_TCW_CTRL_REG(APCI1564_COUNTER4));
> +
> +	outl(0x0, dev->iobase + APCI1564_TCW_RELOAD_REG(APCI1564_COUNTER1));
> +	outl(0x0, dev->iobase + APCI1564_TCW_RELOAD_REG(APCI1564_COUNTER2));
> +	outl(0x0, dev->iobase + APCI1564_TCW_RELOAD_REG(APCI1564_COUNTER3));
> +	outl(0x0, dev->iobase + APCI1564_TCW_RELOAD_REG(APCI1564_COUNTER4));

It's probably not necessary to clear the reload values since you have disabled all the timers.
But, it shouldn't hurt anything.

> +
> +	return 0;
> +}
> +
>  static int apci1564_auto_attach(struct comedi_device *dev,
>  				unsigned long context)
>  {

Regards,
Hartley

