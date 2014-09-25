Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753499AbaIYQ4i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 12:56:38 -0400
Received: from www.linutronix.de ([62.245.132.108]:34829 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752983AbaIYQ4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 12:56:36 -0400
Date: Thu, 25 Sep 2014 18:56:32 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Sekhar Nori <nsekhar@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] ARM: edma: unconditionally ack the error interrupt
Message-ID: <20140925165632.GA5906@linutronix.de>
References: <1410377960-26921-1-git-send-email-bigeasy@linutronix.de>
 <541AA900.4080506@ti.com>
 <20140918161225.GA10232@linutronix.de>
 <541CA01D.1000006@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <541CA01D.1000006@ti.com>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Ujfalusi | 2014-09-20 00:29:01 [+0300]:

>mask 8000000 means URXEVT0 (UART0 rx), 4000000 is UTXEVT0 (UART0 tx) events.
>But it is clear that my theory was not even close to what's going on.
>Do you have some tool which can be used to reproduce this issue?

The latest uart patch set is at
    git://git.breakpoint.cc/bigeasy/linux.git uart_v10_pre3

and the latest one I tested and saw the issue was uart_v9.
The test case is, boot, login via serial, do "less file" and press space
for a while to get less to scroll the file.
The error counter increment after a while.

>> Fun fact: If I remove the write access to EDMA_EMCR register (the write
>> access after the read out) then I haven't seen [1] a single error interrupt
>> beeing "unhandled" out of 9. The former has three out of eight.
>
>Hrm, this is interesting. Am I interpret it right:
>if you clear the event missed register's bit for the event, you will receive
>the interrupt, but there if you read the EMR bits, they are all 0.
usually yes. Sometimes the EMR bits are set.

>if you do not clear the bit in the event missed register (even if it is not
>set) you will not receive the error interrupt. Right?
no, the error interrupt comes but the EMR is always non-zero.

>I think this can be due to the fact how edma (if I read the TRM right) works:
>the error irq will be asserted if there is a transition from 0 to 1 in one of
>the error registers. If you had error and you did not cleared the error bit,
>the next error will not going to cause another transition so no interrupt will
>be triggered. Having said that, there should be at least one error interrupt
>coming since at some point we should have had 0 -> 1 transition...
>
>Can you print out also the EDMA_EMR at places you were printing EDMA_EMCR?

So I had a "bug" where I changed the baud + DMA bits in the UART while
there was a DMA-TX in progress. Now I dropped this in v10_pre3 and it
seems not to trigger anymore.

Sebastian
