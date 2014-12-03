Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752060AbaLCUEn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 15:04:43 -0500
Received: from mail-la0-f43.google.com ([209.85.215.43]:61053 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183AbaLCUEl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 15:04:41 -0500
Content-Type: text/plain; charset=koi8-r
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: Question about patch "i2c: omap: resize fifos before each message"
From: Alexander Kochetkov <al.kochet@gmail.com>
In-Reply-To: <20141203193826.GK16138@saruman>
Date: Wed, 3 Dec 2014 23:04:37 +0300
Cc: Kevin Hilman <khilman@kernel.org>, Tony Lindgren <tony@atomide.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        linux-omap <linux-omap@vger.kernel.org>, linux-i2c@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <7EACB0B2-7079-4FEB-8009-58682730F8A6@gmail.com>
References: <A20987D6-DEEC-488D-9655-36A4D186599B@gmail.com> <20141203154936.GF16138@saruman> <8C51B585-BFD6-48CC-A2C4-EB88CB820426@gmail.com> <20141203174938.GJ16138@saruman> <7602A84A-43B2-4C22-ACFA-FEA0640A6B7D@gmail.com> <20141203193826.GK16138@saruman>
To: balbi@ti.com
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


03 дек. 2014 г., в 22:38, Felipe Balbi <balbi@ti.com> написал(а):

> then handle slave interrupts :-) But handle them so that it won't race
> with a master transfer request. Moving omap_i2c_xfer() inside the IRQ
> handler isn't the best way to do it, however.

I do that with care :)

Currently, only 'resize fifo' and 'clear fifo' is the one thing what must 
be moved into ISR (I'll check is it possible or late). 
Because I can't ask ISR to generate interrupt to start master transfer.
I thought about that without luck.
I have to write to CON register. I can lock xfer for short time to
check STAT (for AAS) and either write CON or flag to start master after
slave complete.

'clear fifo' must be done in response to NACK. TRM states this[1]"
"TX and RX FIFOs must be cleared (the I2Ci.I2C_BUF[6] TXFIFO_CLR
and I2Ci.I2C_BUF[14] RXFIFO_CLR bits are set to 1)."

'resize fifo' could be avoided at all, but, it so nice feature.

And yes, if we could utilize full fifo to send message, we could set
threshold to message size and get only RRDY at the end.

If message size is greater than fifo size, we want to use double
buffer scheme to minimize ISR latencies.

But now, variable 'fifo_size' is set to half of IP real fifo size.
And for messages with fifo_size/2 ... fifo_size we use drainig
feature (get RDR, XRD). While we could receive only one IRQ.
I'll fix that.

>> And, I'll try to move fifo threshold init code into ISR. Don't see
>> something wrong.
> 
> I wouldn't do that. It's just too late... look, IRQs won't fire until
> I2C_CON is setup to start a transfer (transmit or receive), you *must*
> resize FIFO before starting a transfer otherwise, well, you know...
Looks, like RRDY is fired after simple compare with threshold.
I'll check is this possible (but, that doesn't cover into TRM).
Or may be it is late to change it.

[1] AM-DM37x Multimedia Device Silicon Revision 1.x  - sprugn4r,
     p. 2796, Table 17-9. HS I2C Interrupt Events