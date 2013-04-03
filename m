Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763329Ab3DCJo4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 05:44:56 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:49511 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763317Ab3DCJoy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 05:44:54 -0400
Date: Wed, 3 Apr 2013 11:44:44 +0200
From: Richard GENOUD <richard.genoud@gmail.com>
To: Wenyou Yang <wenyou.yang@atmel.com>
Cc: linux-arm-kernel@lists.infradead.org, grant.likely@secretlab.ca,
        broonie@opensource.wolfsonmicro.com, plagnioj@jcrosoft.com,
        nicolas.ferre@atmel.com, JM.Lin@atmel.com,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 2/8] spi/spi-atmel: add flag to controller data for
 lock operations
Message-ID: <20130403094442.GB26067@lnx-rg>
References: <1364968581-23700-1-git-send-email-wenyou.yang@atmel.com>
 <1364968716-23848-1-git-send-email-wenyou.yang@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364968716-23848-1-git-send-email-wenyou.yang@atmel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On [mer., 03.04.2013 13:58:36], Wenyou Yang wrote:
> From: Nicolas Ferre <nicolas.ferre@atmel.com>
> 
> Will allow to drop the lock during DMA operations.
> 
> Replacing non-irqsave versions with irqsave versions of the lock
> to make it correct in both pdc and dmaengine transfer mode
> 
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> Cc: spi-devel-general@lists.sourceforge.net
> Cc: linux-kernel@vger.kernel.org
> [wenyou.yang@atmel.com: submit the patch]
> Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
> ---
>  drivers/spi/spi-atmel.c |   35 +++++++++++++++++++++--------------
>  1 file changed, 21 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/spi/spi-atmel.c b/drivers/spi/spi-atmel.c
> index 38f8c0d..2df562f 100644
> --- a/drivers/spi/spi-atmel.c
> +++ b/drivers/spi/spi-atmel.c
> @@ -195,6 +195,7 @@ struct atmel_spi_caps {
>   */
>  struct atmel_spi {
>  	spinlock_t		lock;
> +	unsigned long		flags;
>  
>  	phys_addr_t		phybase;
>  	void __iomem		*regs;
> @@ -333,6 +334,16 @@ static void cs_deactivate(struct atmel_spi *as, struct spi_device *spi)
>  		gpio_set_value(asd->npcs_pin, !active);
>  }
>  
> +static void atmel_spi_lock(struct atmel_spi *as)
> +{
> +	spin_lock_irqsave(&as->lock, as->flags);
> +}
> +
> +static void atmel_spi_unlock(struct atmel_spi *as)
> +{
> +	spin_unlock_irqrestore(&as->lock, as->flags);
> +}
> +
>  static inline int atmel_spi_xfer_is_last(struct spi_message *msg,
>  					struct spi_transfer *xfer)
>  {
> @@ -569,9 +580,9 @@ atmel_spi_msg_done(struct spi_master *master, struct atmel_spi *as,
>  		"xfer complete: %u bytes transferred\n",
>  		msg->actual_length);
>  
> -	spin_unlock(&as->lock);
> +	atmel_spi_unlock(as);
>  	msg->complete(msg->context);
> -	spin_lock(&as->lock);
> +	atmel_spi_lock(as);
>  
>  	as->current_transfer = NULL;
>  	as->next_transfer = NULL;
> @@ -594,7 +605,7 @@ atmel_spi_interrupt(int irq, void *dev_id)
>  	u32			status, pending, imr;
>  	int			ret = IRQ_NONE;
>  
> -	spin_lock(&as->lock);
> +	atmel_spi_lock(as);
>  
>  	xfer = as->current_transfer;
>  	msg = list_entry(as->queue.next, struct spi_message, queue);
> @@ -697,7 +708,7 @@ atmel_spi_interrupt(int irq, void *dev_id)
>  		}
>  	}
>  
> -	spin_unlock(&as->lock);
> +	atmel_spi_unlock(as);
>  
>  	return ret;
>  }
> @@ -802,13 +813,11 @@ static int atmel_spi_setup(struct spi_device *spi)
>  		spi->controller_state = asd;
>  		gpio_direction_output(npcs_pin, !(spi->mode & SPI_CS_HIGH));
>  	} else {
> -		unsigned long		flags;
> -
> -		spin_lock_irqsave(&as->lock, flags);
> +		atmel_spi_lock(as);
>  		if (as->stay == spi)
>  			as->stay = NULL;
>  		cs_deactivate(as, spi);
> -		spin_unlock_irqrestore(&as->lock, flags);
> +		atmel_spi_unlock(as);
>  	}
>  
>  	asd->csr = csr;
> @@ -827,7 +836,6 @@ static int atmel_spi_transfer(struct spi_device *spi, struct spi_message *msg)
>  {
>  	struct atmel_spi	*as;
>  	struct spi_transfer	*xfer;
> -	unsigned long		flags;
>  	struct device		*controller = spi->master->dev.parent;
>  	u8			bits;
>  	struct atmel_spi_device	*asd;
> @@ -892,11 +900,11 @@ static int atmel_spi_transfer(struct spi_device *spi, struct spi_message *msg)
>  	msg->status = -EINPROGRESS;
>  	msg->actual_length = 0;
>  
> -	spin_lock_irqsave(&as->lock, flags);
> +	atmel_spi_lock(as);
>  	list_add_tail(&msg->queue, &as->queue);
>  	if (!as->current_transfer)
>  		atmel_spi_next_message(spi->master);
> -	spin_unlock_irqrestore(&as->lock, flags);
> +	atmel_spi_unlock(as);
>  
>  	return 0;
>  }
> @@ -906,17 +914,16 @@ static void atmel_spi_cleanup(struct spi_device *spi)
>  	struct atmel_spi	*as = spi_master_get_devdata(spi->master);
>  	struct atmel_spi_device	*asd = spi->controller_state;
>  	unsigned		gpio = (unsigned) spi->controller_data;
> -	unsigned long		flags;
>  
>  	if (!asd)
>  		return;
>  
> -	spin_lock_irqsave(&as->lock, flags);
> +	atmel_spi_lock(as);
>  	if (as->stay == spi) {
>  		as->stay = NULL;
>  		cs_deactivate(as, spi);
>  	}
> -	spin_unlock_irqrestore(&as->lock, flags);
> +	atmel_spi_unlock(as);
>  
>  	spi->controller_state = NULL;
>  	gpio_free(gpio);
> -- 
> 1.7.9.5
>
On sam9g35 with DMA and PIO (3.9-rc5 + device tree patches)
Tested-by: Richard Genoud <richard.genoud@gmail.com>
