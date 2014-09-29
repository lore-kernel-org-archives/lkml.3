Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752375AbaI2JXq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 05:23:46 -0400
Received: from filter1.ibarracuda.nl ([83.247.7.10]:57267 "EHLO
	filter1.ibarracuda.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751615AbaI2JXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 05:23:44 -0400
X-ASG-Debug-ID: 1411982621-0759e74bdc52b020002-xx1T2L
X-Barracuda-Envelope-From: Frans.Klaver@xsens.com
X-Barracuda-AUTH-User: xsenscom
X-Barracuda-Apparent-Source-IP: 87.249.116.215
Date: Mon, 29 Sep 2014 11:23:40 +0200
From: Frans Klaver <frans.klaver@xsens.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: <linux-serial@vger.kernel.org>, <tony@atomide.com>,
        <gregkh@linuxfoundation.org>, <linux-kernel@vger.kernel.org>,
        <balbi@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 12/16] tty: serial: 8250_dma: handle the UART RDI event
 while DMA remains idle
Message-ID: <20140929092340.GB13952@ci00147.xsens-tech.local>
X-ASG-Orig-Subj: Re: [PATCH 12/16] tty: serial: 8250_dma: handle the UART RDI event
 while DMA remains idle
References: <1410377411-26656-1-git-send-email-bigeasy@linutronix.de>
 <1410377411-26656-13-git-send-email-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <1410377411-26656-13-git-send-email-bigeasy@linutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Originating-IP: [172.16.11.160]
X-Barracuda-Connect: rev-215.116.249.87.virtu.nl[87.249.116.215]
X-Barracuda-Start-Time: 1411982622
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

On Wed, Sep 10, 2014 at 09:30:07PM +0200, Sebastian Andrzej Siewior wrote:
> Sometimes the OMAP UART does not signal the DMA engine to unload the FIFO.
> Usually this happens when we have >threshold bytes in the FIFO
> and start the DMA transfer. It seems that in those cases the UART won't
> trigger the transfer once the requested threshold is reached. In some
> rare cases the UART does not trigger the DMA transfer even if programmed
> while the FIFO was empty.
> In those cases the UART drops an RDI event and we have to empty the FIFO
> manually. If we ignore it because the DMA transfer is programmed then we
> will enter the function a few times until we receive the RX_TIMEOUT
> event. At that point the FIFO is usually full and we risk to overflow
> the FIFO.
> 
> Reviewed-by: Tony Lindgren <tony@atomide.com>
> Tested-by: Tony Lindgren <tony@atomide.com>
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
>  drivers/tty/serial/8250/8250_dma.c | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
> 
> diff --git a/drivers/tty/serial/8250/8250_dma.c b/drivers/tty/serial/8250/8250_dma.c
> index fa1dc966f394..898a6781d0b3 100644
> --- a/drivers/tty/serial/8250/8250_dma.c
> +++ b/drivers/tty/serial/8250/8250_dma.c
> @@ -193,6 +193,24 @@ int serial8250_rx_dma(struct uart_8250_port *p, unsigned int iir)
>  			__dma_rx_do_complete(p, true);
>  		}
>  		return -ETIMEDOUT;
> +	case UART_IIR_RDI:
> +		if (p->bugs & UART_BUG_DMA_RX)
> +			break;
> +		/*
> +		 * The OMAP UART is a special BEAST. If we receive RDI we _have_
> +		 * a DMA transfer programmed but it didn't worked. One reason is

didn't work

> +		 * that we were too slow and there were too many bytes in the
> +		 * FIFO, the UART counted wrong and never kicked the DMA engine
> +		 * to do anything. That means once we receive RDI on OMAP than

then

> +		 * the DMA won't do anything soon so we have to cancel the DMA
> +		 * transfer and purge the FIFO manually.
> +		 */
> +		if (dma->rx_running) {
> +			dmaengine_pause(dma->rxchan);
> +			__dma_rx_do_complete(p, true);
> +		}
> +		return -ETIMEDOUT;
> +
>  	default:
>  		break;
>  	}
> -- 
> 2.1.0
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
