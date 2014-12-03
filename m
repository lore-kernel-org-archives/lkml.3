Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751347AbaLCRe2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 12:34:28 -0500
Received: from mail-la0-f53.google.com ([209.85.215.53]:55415 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751173AbaLCRe0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 12:34:26 -0500
Content-Type: text/plain; charset=koi8-r
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: Question about patch "i2c: omap: resize fifos before each message"
From: Alexander Kochetkov <al.kochet@gmail.com>
In-Reply-To: <20141203154936.GF16138@saruman>
Date: Wed, 3 Dec 2014 20:34:21 +0300
Cc: Kevin Hilman <khilman@kernel.org>, Tony Lindgren <tony@atomide.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        linux-omap <linux-omap@vger.kernel.org>, linux-i2c@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <8C51B585-BFD6-48CC-A2C4-EB88CB820426@gmail.com>
References: <A20987D6-DEEC-488D-9655-36A4D186599B@gmail.com> <20141203154936.GF16138@saruman>
To: balbi@ti.com
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


03 дек. 2014 г., в 18:49, Felipe Balbi <balbi@ti.com> написал(а):

> 
>> 2. I want to avoid changing fifos before message submission, because
>> IP can start receiving message in a slave mode (race).
> 
> I2C is not full-duplex. There's no way it will receive any data while
> you're transmitting, right ?
> 

I2C is half duplex, right. But, IP work in slave receiver and master transmitter modes.
And IP switch to slave receiver mode after master transfer (simply clear MST bit and ready for
reception and that TRM state about). 
And question sounds like: what happen if we reset or change FIFO threshold value
(in order to submit new master transfer) when IP start receiving data to the fifo.
How many bytes we have to read on RRDY?
That race I'am talking about. And there is only one place where race couldn't happen: it's
ISR (thread). So I want to move almost all master initialization code into ISR.


>> 3. dev->threshold is changed in range 1-fifo_size/2. So instead of RDR
>> we get RRDY and for messages larger then fifo_size/2 we still get RRDY
>> and RDR.
> 
> we will only get RDR if message_size % threshold > 0. If we have a 16
> byte transfer and we program threshold to 8 bytes, we will get two RRDY
> IRQs.
> 
>> Felipe, do you have in mind why do you want to avoid RDR and XDR events?
>> Something about errata?
> 
> nothing about errata. As the commit log say (or tried to say), if the
> entire message fits into the FIFO we save one interrupt. It's a
> micro-optimization.

I see, thank you. But due to error only half of fifo is utilized for that.
And, I'll try to move fifo threshold init code into ISR. Don't see something wrong.

Thank you a lot!

Regards,
Alexander.

