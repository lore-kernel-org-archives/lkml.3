Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756360AbaHYSEI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 14:04:08 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:34033 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755638AbaHYSEF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 14:04:05 -0400
Date: Mon, 25 Aug 2014 12:03:45 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Scot Doyle <lkml14@scotdoyle.com>
Cc: Peter Huewe <peterhuewe@gmx.de>, Ashley Lai <ashley@ashleylai.com>,
        Marcel Selhorst <tpmdd@selhorst.net>,
        Stefan Berger <stefanb@linux.vnet.ibm.com>,
        Luigi Semenzato <semenzato@google.com>,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tpm: fix interrupt timeouts
Message-ID: <20140825180345.GA1298@obsidianresearch.com>
References: <alpine.LNX.2.11.1408250710470.1443@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.11.1408250710470.1443@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 25, 2014 at 07:14:03AM +0000, Scot Doyle wrote:
> commit 4c663cfc523a88d97a8309b04a089c27dc57fd7e
>     wait: fix false timeouts when using wait_event_timeout()
> 
> changed the semantics of wait_event_interruptible_timeout so that a
> condition check is performed after timeout and 1 is returned if true.
> 
> The TPM chip may not send interrupts even though the tpm module is
> attempting to receive interrupts. In this case, after the module
> sends a command to the TPM chip it performs a blocking wait on the
> interrupt queue. No interrupts are sent from the chip, the queue is
> not woken up and the blocking wait times out. Despite timing out,
> the command has completed and the condition check performed by
> wait_event_interruptible_timeout after timeout is true, resulting in
> a return value of 1. Since the expected return value on timeout is 0
> the timeout is not detected.
> 
> To fix, assume a return value of 1 or less indicates an elapsed
> timeout. It is possible for the return value to be 1 after receiving
> an interrupt, but this should be rare. The condition is not double-
> checked because of possible side effects.

Hum.. Okay, so I see what you are trying to fix here, but the code is
actually using wait_event_interruptible_timeout correctly as is. 

The TPM actually did complete the operation, and the test sentinal
checks directly at the TPM - which makes sense to me..

I think you'll have to directly test in the tis driver if the
interrupt is working.

The ordering in the TIS driver is wrong, interrupts should be turned
on before any TPM commands are issued. This is what other drivers are
doing.
	
If you fix this, tis can then just count interrupts recieved and check
if that is 0 to detect failure and then turn them off.

Jason
