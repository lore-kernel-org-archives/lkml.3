Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755497AbaIHXRf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 19:17:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36376 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755345AbaIHXRe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 19:17:34 -0400
Date: Mon, 8 Sep 2014 16:17:33 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Johannes Thumshirn <johannes.thumshirn@men.de>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tty: serial: men_z135_uart: Fix driver for changes in
 hardware
Message-ID: <20140908231733.GB23907@kroah.com>
References: <1409229140-14407-1-git-send-email-johannes.thumshirn@men.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409229140-14407-1-git-send-email-johannes.thumshirn@men.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 28, 2014 at 02:32:20PM +0200, Johannes Thumshirn wrote:
> 16z135 IP Core has changed so the driver needs to be updated to respect
> these changes. The following changes have been made:
> 
> * Don't invert the 16z135 modem status register when reading.
> * Add module parameter to configure the (baud rate dependent) RX timeout.
>   Character timeout in seconds = (timeout_reg * baud_reg * 4)/freq_reg.
> * Enable the handling of UART core's automatic flow control feature.
>   When AFE is active disable generation of modem status IRQs.
> * Rework the handling of IRQs to be conform with newer FPGA versions and
>   take precautions not to miss an interrupt because of the destructive read
>   of the IIR register.
> 
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@men.de>
> ---
>  drivers/tty/serial/men_z135_uart.c | 87 +++++++++++++++++++++++---------------
>  1 file changed, 53 insertions(+), 34 deletions(-)
> 
> diff --git a/drivers/tty/serial/men_z135_uart.c b/drivers/tty/serial/men_z135_uart.c
> index 30e9e60..d31b8a4 100644
> --- a/drivers/tty/serial/men_z135_uart.c
> +++ b/drivers/tty/serial/men_z135_uart.c
> @@ -34,12 +34,11 @@
>  #define MEN_Z135_CONF_REG		0x808
>  #define MEN_Z135_UART_FREQ		0x80c
>  #define MEN_Z135_BAUD_REG		0x810
> -#define MENZ135_TIMEOUT			0x814
> +#define MEN_Z135_TIMEOUT		0x814
>  
>  #define MEN_Z135_MEM_SIZE		0x818
>  
> -#define IS_IRQ(x) ((x) & 1)
> -#define IRQ_ID(x) (((x) >> 1) & 7)
> +#define IRQ_ID(x) ((x) & 0x1f)
>  
>  #define MEN_Z135_IER_RXCIEN BIT(0)		/* RX Space IRQ */
>  #define MEN_Z135_IER_TXCIEN BIT(1)		/* TX Space IRQ */
> @@ -94,11 +93,11 @@
>  #define MEN_Z135_LSR_TEXP BIT(6)
>  #define MEN_Z135_LSR_RXFIFOERR BIT(7)
>  
> -#define MEN_Z135_IRQ_ID_MST 0
> -#define MEN_Z135_IRQ_ID_TSA 1
> -#define MEN_Z135_IRQ_ID_RDA 2
> -#define MEN_Z135_IRQ_ID_RLS 3
> -#define MEN_Z135_IRQ_ID_CTI 6
> +#define MEN_Z135_IRQ_ID_RLS BIT(0)
> +#define MEN_Z135_IRQ_ID_RDA BIT(1)
> +#define MEN_Z135_IRQ_ID_CTI BIT(2)
> +#define MEN_Z135_IRQ_ID_TSA BIT(3)
> +#define MEN_Z135_IRQ_ID_MST BIT(4)
>  
>  #define LCR(x) (((x) >> MEN_Z135_LCR_SHIFT) & 0xff)
>  
> @@ -118,6 +117,10 @@ static int align;
>  module_param(align, int, S_IRUGO);
>  MODULE_PARM_DESC(align, "Keep hardware FIFO write pointer aligned, default 0");
>  
> +static int rx_timeout;
> +module_param(rx_timeout, uint, S_IRUGO);
> +MODULE_PARM_DESC(rx_timeout, "RX timeout");

Why add a module parameter?  Who will know to set this?  And to what
value?

And what about this driver working on old hardware, didn't you just
break this?

thanks,

greg k-h
