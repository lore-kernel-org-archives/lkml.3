Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751525AbaHOShe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 14:37:34 -0400
Received: from mail.csclub.uwaterloo.ca ([129.97.134.52]:44703 "EHLO
	mail.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027AbaHOShd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 14:37:33 -0400
From: "Lennart Sorensen" <lsorense@csclub.uwaterloo.ca>
Date: Fri, 15 Aug 2014 14:37:31 -0400
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        tony@atomide.com, balbi@ti.com, Vinod Koul <vinod.koul@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 05/15] tty: serial: Add 8250-core based omap driver
Message-ID: <20140815183731.GI17769@csclub.uwaterloo.ca>
References: <1408124563-31541-1-git-send-email-bigeasy@linutronix.de>
 <1408124563-31541-6-git-send-email-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1408124563-31541-6-git-send-email-bigeasy@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 15, 2014 at 07:42:33PM +0200, Sebastian Andrzej Siewior wrote:
> This patch provides a 8250-core based UART driver for the internal OMAP
> UART. The long term goal is to provide the same functionality as the
> current OMAP uart driver and DMA support.
> I tried to merge omap-serial code together with the 8250-core code.
> There should should be hardly a noticable difference. The trigger levels
> are different compared to omap-serial:
> - omap serial
>   TX: Interrupt comes after TX FIFO has room for 16 bytes.
>       TX of 4096 bytes in one go results in 256 interrupts
> 
>   RX: Interrupt comes after there is on byte in the FIFO.
                                       one
>       RX of 4096 bytes results in 4096 interrupts.
> 
> - this driver
>   TX: Interrupt comes once the TX FIFO is empty.
>       TX of 4096 bytes results in 65 interrupts. That means there will
>       be gaps on the line while the driver reloads the FIFO.

Any idea how long the gap is likely to be?  Probably not much.  I like
the reduction in the number of interrupts.

I suppose if you did an interrupt when half empty or 3/4 empty, you
would avoid the gap, and only increase the interrupt amount a little bit.
Waiting until completely empty gives you larger dma transfers and less
interrupts, but reduces your effective bandwidth on the port.  Is that
really the right tradeoff?  I think the original driver behaviour there
was fairly sane, although the 16 byte value could perhaps be increased
to 32 or 48.

>   RX: Interrupt comes once there are 48 bytes in the FIFO or less over
>       "longer" time frame. We have
>           1 / 11520 * 10^3 * 16 => 1.38… ms
>       1.38ms to react and purge the FIFO on 115200,8N1. Since the other
>       driver fired after each byte it had ~5.47ms time to react. This
>       _may_ cause problems if one relies on no missing bytes and has no
>       flow control. On the other hand we get only 85 interrupts for the
>       same amount of data.

Hmm, so if this was 32 instead of 48, it would double the amount of
time you have to react, while only increasing the interrupt rate by 50%
(1 every 32 rather than 1 every 48).  Could be interesting to tweak to
get the balance just right.  Maybe it could have an optional dtb entry
to control it if you don't like the default or is there a way to change
it from user space already?

I know for our system we would like to be able to tolerate 1ms at 230400
without data loss.

-- 
Len Sorensen
