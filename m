Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754294AbaJBP2t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 11:28:49 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:57771 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752502AbaJBP2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 11:28:47 -0400
Date: Thu, 2 Oct 2014 10:28:45 -0500
From: Andy Gross <agross@codeaurora.org>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
Cc: Mark Brown <broonie@kernel.org>, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Kumar Gala <galak@codeaurora.org>
Subject: Re: [Patch v3] spi: qup: Fix incorrect block transfers
Message-ID: <20141002152845.GB14663@qualcomm.com>
References: <1412112088-25928-1-git-send-email-agross@codeaurora.org>
 <1412257472.1027.37.camel@iivanov-dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412257472.1027.37.camel@iivanov-dev>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 02, 2014 at 04:44:32PM +0300, Ivan T. Ivanov wrote:
> 
> Hi Andy,
> 
> I am trying to understand why we need extra functions for block 
> read and write.

I separated them out because the constraints for doing the allowable
writes/reads was making the whole thing messy.  I opted for a cleaner
implementation.

> 
> Essentially fifo and block read/write function are looking
> the same for me. Except that block functions have one extra write
> in QUP_OPERATIONAL register.

It's not just that, the difference between the fifo and block is that you just
read/write the fifo until you hit the full or empty.  You can't do that with
block.  you have to read in block size transfers (4x32B read/writes).

> 
> On Tue, 2014-09-30 at 16:21 -0500, Andy Gross wrote:
> > This patch fixes a number of errors with the QUP block transfer mode.  Errors
> > manifested themselves as input underruns, output overruns, and timed out
> > transactions.
> > 
> > The block mode does not require the priming that occurs in FIFO mode.  At the
> > moment that the QUP is placed into the RUN state, the QUP will immediately raise
> > an interrupt if the request is a write.  Therefore, there is no need to prime
> > the pump.
> 
> But does this hurt in some way? I mean fist FIFO fill happens when
> controller is in PAUSED state. Once enabled it can start transfer 
> immediately. 

Unfortunately that creates a race in the block mode.  Because we hit run, we are
telling the controller to do something.  In the block case, it fires off an IRQ
to request output blocks.  This IRQ is going to hit sometime before, during, or
after the fifo_write function.  If we are unlucky and we are in the fifo_write
and somewhere in that loop, the irq is handled and we enter the fifo_write
function again.  We already did some number of writes/reads that have not been
recorded.  The IRQ fifo_write rips through and fills the fifo.  Then we return
from the IRQ and continue to read/write and this causes the overrun/underrun.

Letting the IRQ handle the block transfer start removes this specific issue.
The cost is one irq overhead and the read/write of 16 words.

> 
> > 
> > In addition, the block transfers require that whole blocks of data are
> > read/written at a time.  
> 
> Thats fine, but I can not see why this will not happen with existing
> fill functions. Fifo's are drained until there is data and filled
> until there is a space. And because we are not using pack/unpack mode, 
> every SPI word occupy one cell in fifo (32 bits), this means that 
> existing read/write functions are working in "block" mode.

Not true.  The block mode is different because the IRQ generation is tied to the
block size.  You won't get a service interrupt until either the transaction is
completely done, or a block of data is read/written.  And you get an IRQ for
each block that has to be ACKd.  That is completely different than the behavior
than the FIFO mode.  If you are not reading/writing full blocks of data, you are
doing it wrong.

In FIFO mode, you get a service interrupt when at least 1 word of data is ready
to be read, or there is space to place at least one word of data for write.

> 
> > The last block of data that completes a transaction may
> > contain less than a full blocks worth of data.
> > 
> > Each block of data results in an input/output service interrupt accompanied with
> > a input/output block flag set.  Additional block reads/writes require clearing
> > of the service flag.  It is ok to check for additional blocks of data in the
> > ISR, but you have to ack every block you transfer.  Imbalanced acks result in
> > early return from complete transactions with pending interrupts that still have
> > to be ack'd.  The next transaction can be affected by these interrupts.
> > Transactions are deemed complete when the MAX_INPUT or MAX_OUTPUT flag are set.
> 
> And this is the thing that can cause errors that you see, I suppose.
> We are getting extra interrupts, which are not cleared, even if we have
> drained fifo completely. 

We get errors because
1) We don't adhere to the programming model for block mode
2) We return early from transactions that have not been fully ack'd.

> 
> Regards,
> Ivan
> 
> P.S. They are still several coding style issues :-). The same as those that 
> I have already pointed to you.

Sigh, I thought i fixed those.  I'll have another look.

-- 
sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
