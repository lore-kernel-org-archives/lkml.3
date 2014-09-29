Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752650AbaI2J0O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 05:26:14 -0400
Received: from filter1.ibarracuda.nl ([83.247.7.10]:57818 "EHLO
	filter1.ibarracuda.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055AbaI2J0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 05:26:11 -0400
X-ASG-Debug-ID: 1411982768-0759e74bdc52bab0002-xx1T2L
X-Barracuda-Envelope-From: Frans.Klaver@xsens.com
X-Barracuda-AUTH-User: xsenscom
X-Barracuda-Apparent-Source-IP: 87.249.116.215
Date: Mon, 29 Sep 2014 11:26:06 +0200
From: Frans Klaver <frans.klaver@xsens.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: <linux-serial@vger.kernel.org>, <tony@atomide.com>,
        <gregkh@linuxfoundation.org>, <linux-kernel@vger.kernel.org>,
        <balbi@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 13/16] tty: serial: 8250_dma: add pm runtime
Message-ID: <20140929092606.GC13952@ci00147.xsens-tech.local>
X-ASG-Orig-Subj: Re: [PATCH 13/16] tty: serial: 8250_dma: add pm runtime
References: <1410377411-26656-1-git-send-email-bigeasy@linutronix.de>
 <1410377411-26656-14-git-send-email-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <1410377411-26656-14-git-send-email-bigeasy@linutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Originating-IP: [172.16.11.160]
X-Barracuda-Connect: rev-215.116.249.87.virtu.nl[87.249.116.215]
X-Barracuda-Start-Time: 1411982768
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://filter1.ibarracuda.nl:8000/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 1
X-Barracuda-Spam-Score: 0.50
X-Barracuda-Spam-Status: No, SCORE=0.50 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=5.0 tests=BSF_RULE7568M
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.10016
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
	0.50 BSF_RULE7568M          Custom Rule 7568M
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2014 at 09:30:08PM +0200, Sebastian Andrzej Siewior wrote:
> There is nothing to do for RPM in the RX path. If the HW goes off then it
> won't assert the DMA line and the transfer won't happen. So we hope that
> the HW does not go off for RX to work (DMA or PIO makes no difference
> here).
> 
> For TX the situation is slightly different. RPM is enabled on
> start_tx(). We can't disable RPM on DMA complete callback because there
> is still data in the FIFO which is being sent. We have to wait until
> the FIFO is empty before we disable it.
> For this to happen we fake a TX sent error and enable THRI. Once the
> FIFO is empty we receive an interrupt and since the TTY-buffer is still
> empty we "put RPM" via __stop_tx(). Should it been filed then in the
> start_tx() path we should program the DMA transfer and remove the error
> flag and the THRI bit.

That last sentence starts out a bit messy.


> 
> Reviewed-by: Tony Lindgren <tony@atomide.com>
> Tested-by: Tony Lindgren <tony@atomide.com>
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
>  drivers/tty/serial/8250/8250_dma.c | 16 +++++++++++-----
>  1 file changed, 11 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/tty/serial/8250/8250_dma.c b/drivers/tty/serial/8250/8250_dma.c
> index 898a6781d0b3..e8850219b150 100644
> --- a/drivers/tty/serial/8250/8250_dma.c
> +++ b/drivers/tty/serial/8250/8250_dma.c
> @@ -21,6 +21,7 @@ static void __dma_tx_complete(void *param)
>  	struct uart_8250_dma	*dma = p->dma;
>  	struct circ_buf		*xmit = &p->port.state->xmit;
>  	unsigned long	flags;
> +	bool en_thri = false;
>  
>  	dma_sync_single_for_cpu(dma->txchan->device->dev, dma->tx_addr,
>  				UART_XMIT_SIZE, DMA_TO_DEVICE);
> @@ -40,11 +41,16 @@ static void __dma_tx_complete(void *param)
>  		int ret;
>  
>  		ret = serial8250_tx_dma(p);
> -		if (ret) {
> -			dma->tx_err = 1;
> -			p->ier |= UART_IER_THRI;
> -			serial_port_out(&p->port, UART_IER, p->ier);
> -		}
> +		if (ret)
> +			en_thri = true;
> +
> +	} else if (p->capabilities & UART_CAP_RPM)
> +		en_thri = true;
> +
> +	if (en_thri) {
> +		dma->tx_err = 1;
> +		p->ier |= UART_IER_THRI;
> +		serial_port_out(&p->port, UART_IER, p->ier);
>  	}
>  
>  	spin_unlock_irqrestore(&p->port.lock, flags);
> -- 
> 2.1.0
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
