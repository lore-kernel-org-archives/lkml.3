Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751353AbaLCTBk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 14:01:40 -0500
Received: from mail-lb0-f182.google.com ([209.85.217.182]:48600 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124AbaLCTBi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 14:01:38 -0500
Content-Type: text/plain; charset=koi8-r
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: Question about patch "i2c: omap: resize fifos before each message"
From: Alexander Kochetkov <al.kochet@gmail.com>
In-Reply-To: <20141203174938.GJ16138@saruman>
Date: Wed, 3 Dec 2014 22:01:33 +0300
Cc: Kevin Hilman <khilman@kernel.org>, Tony Lindgren <tony@atomide.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        linux-omap <linux-omap@vger.kernel.org>, linux-i2c@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <7602A84A-43B2-4C22-ACFA-FEA0640A6B7D@gmail.com>
References: <A20987D6-DEEC-488D-9655-36A4D186599B@gmail.com> <20141203154936.GF16138@saruman> <8C51B585-BFD6-48CC-A2C4-EB88CB820426@gmail.com> <20141203174938.GJ16138@saruman>
To: balbi@ti.com
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


03 дек. 2014 г., в 20:49, Felipe Balbi <balbi@ti.com> написал(а):


>  It can also be a master receiver and a
> slave transmitter. 
Agree, but this unrelated to races.

>  Note also that MST bit does *not* auto clear.

Yes, it *does* auto clear!
MST bit automatically clear when IP receive AL.
See TRM [1]. All other TRMs (omap3530, omap3430, 
omap4, omap5) has the same picture.

>From TRM:
2Ci.I2C_CON[10] MST bits are cleared by hardware

And MST bit clear after IP send STP (success transfer).

Did you see what value is in CON register after successful master transfer?
Apply my patch and see that.
It doesn't have MST bit set. That mean IP is in slave mode
(receiver or transmitter - doesn't matter) after *any* master transfer.

And simple test show that. IP respond to GC address (address 0).
And respond to SA address (if programmed).

And TRM[1] figure has comment for 'end' state:
"I2C controller goes into slave receiver mode."

And IP keeps into slave mode until 'suspend'.

Then, after 'resume' IP initialized into slave receiver mode. There is short 
time after resume and master start initialize new transfer.

So, then we start new transfer IP could start receiving slave command.

> Also,
> the IP won't do anything (considering it's always in master mode) until
> STT bit is set again
Yes, it do slave reception or tranmittion with STT bit set to 0.

You could set STT bit to 1, and then it got cleared to 0, you
now, that IP received Start condition with slave transfer.

You could leave STT bit set to 0, but IP still respond to slave transfer.
(at least the IP on dm3730).

And we can't set MST bit again after master transfer to leave IP in the
master mode. We must disable IP (clear EN bit) before transfers to
disable slave mode, or we must handle slave interrupts.
Because un handled  slave interrupt leave SCL low.

[1] AM-DM37x Multimedia Device Silicon Revision 1.x  - sprugn4r,
    p.2815, Figure 17-32. HS I2C Master Receiver Mode, 
    Interrupt Method, in F/S and HS Modes (I2C Mode)

