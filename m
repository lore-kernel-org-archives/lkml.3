Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756176Ab3C2QUF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 12:20:05 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:42359 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754127Ab3C2QUC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 12:20:02 -0400
Date: Fri, 29 Mar 2013 09:19:57 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Chanho Min <chanho.min@lge.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alan Cox <alan@linux.intel.com>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, Chanho Min <chanho0207@gmail.com>
Subject: Re: [PATCH] ARM: PL011: Add support for Rx DMA buffer polling.
Message-ID: <20130329161957.GA14717@kroah.com>
References: <CAOAMb1AcBprsZ1RpA3XDjUC6hAZMrbBcmvVJk7oryeMsPcJy1A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOAMb1AcBprsZ1RpA3XDjUC6hAZMrbBcmvVJk7oryeMsPcJy1A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 27, 2013 at 06:38:11PM +0900, Chanho Min wrote:
> In DMA support, The received data is not pushed to tty until the DMA buffer
> is filled. But some megabyte rate chips such as BT expect fast response and
> data should be pushed immediately. In order to fix this issue, We suggest
> the use of the timer for polling DMA buffer.
> In our test, no data loss occurred at high-baudrate as compared with interrupt-
> driven (We tested with 3Mbps).
> We changes:
> 
> - We add timer for polling. If we set poll_timer to 10, every 10ms,
>  timer handler checks the residue in the dma buffer and transfer data
>  to the tty. Also, last_residue is updated for the next polling.
> 
> - poll_timeout is used to prevent the timer's system cost.
>   If poll_timeout is set to 3000 and no data is received in 3 seconds,
>   we inactivate poll timer and driver falls back to interrupt-driven.
>   When data is received again in FIFO and UART irq is occurred, we switch
>   back to DMA mode and start polling.
> 
> - We use consistent DMA mappings to avoid from the frequent cache operation
>   of the timer function for default.
> 
> - pl011_dma_rx_chars is modified. the pending size is recalculated because
>   data can be taken by polling.
> 
> - the polling time is adjusted if dma rx poll is enabled but no rate is
>   specified. Ideal polling interval to push 1 character at every interval
>   is the reciprocal of 'baud rate / 10 line bits per character / 1000 ms
>   per sec'. But It is very aggressive to system. Experimentally,
>  '10000000 / baud' is suitable to receive dozens of characters. the poll rate
>  can be specified statically by dma_rx_poll_rate of the platform data as well.
> 
> Changes compared to v1:
>  - Use of consistent DMA mappings.
>  - Added dma_rx_poll_rate in platform data to specify the polling interval.
>  - Added dma_rx_poll_timeout in platform data to specify the polling timeout.
> 
> Changes compared to v2:
>  - Use of consistent DMA mappings for default.
>  - Added dma_rx_poll_enable in platform data to adjust the polling time
>    according to the baud rate.
>  - remove unnecessary lock from the polling function.
> 
> Signed-off-by: Chanho Min <chanho.min@lge.com>

This patch was line-wrapped and I had to fix it up by editing it by
hand.  Please fix your email client to not have this happen again.

greg k-h
