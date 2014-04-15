Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754393AbaDOKGX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 06:06:23 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:59477 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752551AbaDOKDg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 06:03:36 -0400
Message-ID: <534D03F2.5070502@mev.co.uk>
Date: Tue, 15 Apr 2014 11:03:30 +0100
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Chase Southwood <chase.southwood@yahoo.com>, <gregkh@linuxfoundation.org>
CC: <hsweeten@visionengravers.com>, <devel@driverdev.osuosl.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] staging: comedi: addi_apci_1564: fixup and absorb
 apci1564_reset()
References: <1397541235-2574-1-git-send-email-chase.southwood@yahoo.com> <1397541284-2774-1-git-send-email-chase.southwood@yahoo.com>
In-Reply-To: <1397541284-2774-1-git-send-email-chase.southwood@yahoo.com>
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MEVEXCHANGE.mev.local (10.0.0.4) To MEVEXCHANGE.mev.local
 (10.0.0.4)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-04-15 06:54, Chase Southwood wrote:
> We can remove this function from the boardinfo and move the code from
> hwdrv_apci1564.c into addi_apci_1564.c since it is the only reset function
> used by the driver.  The function was also messy and failed to reset a few
> registers, these issues were fixed on the move.
>
> Signed-off-by: Chase Southwood <chase.southwood@yahoo.com>
> Cc: H Hartley Sweeten <hsweeten@visionengravers.com>
> ---
> Hartley,
> Could you take a look at the fixes I have done to this reset function?
> The old version was awfully disorganized and seemingly didn't clear all
> of the required registers, and I believe that it is better now.  But, as I
> can only compile test, I'd appreciate it if you could make sure the function
> works as intended now.  Thanks, Chase.
>
>   .../comedi/drivers/addi-data/hwdrv_apci1564.c      | 28 ---------------
>   drivers/staging/comedi/drivers/addi_apci_1564.c    | 41 +++++++++++++++++++++-
>   2 files changed, 40 insertions(+), 29 deletions(-)
>
> diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
> index 4db3bea..45617cf 100644
> --- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
> +++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
> @@ -576,31 +576,3 @@ static void apci1564_interrupt(int irq, void *d)
>   	}
>   	return;
>   }
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
> index 11aa0bd..c1b2260 100644
> --- a/drivers/staging/comedi/drivers/addi_apci_1564.c
> +++ b/drivers/staging/comedi/drivers/addi_apci_1564.c
> @@ -4,6 +4,7 @@
>   #include "../comedidev.h"
>   #include "comedi_fc.h"
>   #include "amcc_s5933.h"
> +#include "addi_watchdog.h"
>
>   #include "addi-data/addi_common.h"
>
> @@ -22,7 +23,6 @@ static const struct addi_board apci1564_boardtypes[] = {
>   		.i_DoMaxdata		= 0xffffffff,
>   		.i_Timer		= 1,
>   		.interrupt		= apci1564_interrupt,
> -		.reset			= apci1564_reset,
>   		.di_config		= apci1564_di_config,
>   		.di_bits		= apci1564_di_insn_bits,
>   		.do_config		= apci1564_do_config,
> @@ -34,6 +34,45 @@ static const struct addi_board apci1564_boardtypes[] = {
>   	},
>   };
>
> +static int apci1564_reset(struct comedi_device *dev)
> +{
> +	struct addi_private *devpriv = dev->private;
> +
> +	ui_Type = 0;
> +
> +	/* Disable the input interrupts and reset status register */
> +	outl(0x0, devpriv->i_IobaseAmcc + APCI1564_DI_INT_MODE1_REG);
> +	outl(0x0, devpriv->i_IobaseAmcc + APCI1564_DI_INT_MODE2_REG);
> +	inl(devpriv->i_IobaseAmcc + APCI1564_DI_INT_STATUS_REG);
> +	outl(0x0, devpriv->i_IobaseAmcc + APCI1564_DI_IRQ_REG);

I'm not sure how much the ordering of those register accesses matters, 
but I'd be inclined to use the original ordering if there's no reason to 
change it:

write APCI1564_DI_IRQ_REG
read APCI1564_DI_INT_STATUS_REG
write APCI1564_DI_INT_MODE1_REG
write APCI1564_DI_INT_MODE2_REG

A register-level programming manual would be handy, but I haven't 
managed to find one.

> +
> +	/* Reset the output channels and disable interrupts */
> +	outl(0x0, devpriv->i_IobaseAmcc + APCI1564_DO_REG);
> +	outl(0x0, devpriv->i_IobaseAmcc + APCI1564_DO_INT_CTRL_REG);
> +	inl(devpriv->i_IobaseAmcc + APCI1564_DO_INT_STATUS_REG);
> +	outl(0x0, devpriv->i_IobaseAmcc + APCI1564_DO_IRQ_REG);

I'm really not sure about the "correct" order of accesses to 
APCI1564_DO_INT_CTRL_REG, APCI1564_DO_INT_STATUS_REG and 
APCI1564_DO_IRQ_REG or even which ones are needed.  (I'm guessing that 
reading APCI1564_DO_INT_STATUS_REG wouldn't change the internal state of 
the card, so would be inclined to omit that, but it should be harmless.)

> +
> +	/* Reset the watchdog registers */
> +	addi_watchdog_reset(devpriv->i_IobaseAmcc + APCI1564_WDOG_REG);
> +
> +	/* Reset the timer registers */
> +	outl(0x0, devpriv->i_IobaseAmcc + APCI1564_TIMER_RELOAD_REG);
> +	outl(0x0, devpriv->i_IobaseAmcc + APCI1564_TIMER_CTRL_REG);
> +
> +	/* Reset the counter registers */
> +	outl(0x0, dev->iobase + APCI1564_TCW_RELOAD_REG(APCI1564_COUNTER1));
> +	outl(0x0, dev->iobase + APCI1564_TCW_RELOAD_REG(APCI1564_COUNTER1));
> +	outl(0x0, dev->iobase + APCI1564_TCW_RELOAD_REG(APCI1564_COUNTER1));
> +	outl(0x0, dev->iobase + APCI1564_TCW_RELOAD_REG(APCI1564_COUNTER1));

I think you forgot to edit those four lines to access different counters.

> +
> +	outl(0x0, dev->iobase + APCI1564_TCW_CTRL_REG(APCI1564_COUNTER1));
> +	outl(0x0, dev->iobase + APCI1564_TCW_CTRL_REG(APCI1564_COUNTER2));
> +	outl(0x0, dev->iobase + APCI1564_TCW_CTRL_REG(APCI1564_COUNTER3));
> +	outl(0x0, dev->iobase + APCI1564_TCW_CTRL_REG(APCI1564_COUNTER4));
> +
> +	return 0;
> +}
> +
>   static int apci1564_auto_attach(struct comedi_device *dev,
>   				unsigned long context)
>   {
>


-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
