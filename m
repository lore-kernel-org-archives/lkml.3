Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713AbaIKLmv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 07:42:51 -0400
Received: from www.linutronix.de ([62.245.132.108]:39312 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754313AbaIKLmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 07:42:49 -0400
Message-ID: <54118AAB.2010205@linutronix.de>
Date: Thu, 11 Sep 2014 13:42:35 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Heikki Krogerus <heikki.krogerus@linux.intel.com>
CC: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        tony@atomide.com, balbi@ti.com, gregkh@linuxfoundation.org,
        Alan Cox <alan@linux.intel.com>
Subject: Re: [PATCH 09/16] tty: serial: 8250_dma: Add a TX trigger workaround
 for AM33xx
References: <1410377411-26656-1-git-send-email-bigeasy@linutronix.de> <1410377411-26656-10-git-send-email-bigeasy@linutronix.de> <20140911111721.GB17476@xps8300>
In-Reply-To: <20140911111721.GB17476@xps8300>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/2014 01:17 PM, Heikki Krogerus wrote:
>> diff --git a/drivers/tty/serial/8250/8250.h b/drivers/tty/serial/8250/8250.h
>> index fbed1636e9c4..09489b391568 100644
>> --- a/drivers/tty/serial/8250/8250.h
>> +++ b/drivers/tty/serial/8250/8250.h
>> @@ -82,6 +82,9 @@ struct serial8250_config {
>>  #define UART_BUG_PARITY	(1 << 4)	/* UART mishandles parity if FIFO enabled */
>>  #define UART_BUG_DMA_RX	(1 << 5)	/* UART needs DMA RX req before there is
>>  					   data in FIFO */
>> +#define UART_BUG_DMA_TX	(1 << 6)	/* UART needs one byte in FIFO for
>> +					   kickstart */
> 
> I don't think we should go ahead with this patch. I'm pretty sure
> this is AM335 specific problem, or at least limited to only few
> platforms. And I don't think we should take any more "BUG" flags.
> 
> We should add hooks like tx_dma and rx_dma to struct uart_8250_dma so
> that the probe drivers can replace serial8250_tx_dma and
> seria8250_rx_dma, like I think Alan already suggested.

Okay. Wasn't aware that Alan already suggested that.
I also need a watchdog timer for TX since it seems that on omap3 the
DMA engine suddenly forgets to continue with DMA…

If this is really what we want, I would need to refactor a few things…

> Let's keep serial8250_tx_dma/rx_dma as the default, and not add any
> quirks to them. Only if there is a very common case should it be
> handled in those. The case of RX req needing to be sent before data in
> FIFO maybe one of those, but I'm no sure.

keep in mind that both (RX & TX bugs/hacks) need also a bit of handling
in the 8250-core so it works together (like the tx_err member so we
fall back to manual xmit)

Sebastian
