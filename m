Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755904AbaIKPLi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 11:11:38 -0400
Received: from filter1.ibarracuda.nl ([83.247.7.10]:51891 "EHLO
	filter1.ibarracuda.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665AbaIKPLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 11:11:36 -0400
X-ASG-Debug-ID: 1410448275-0759e72d3e2174d0002-xx1T2L
X-Barracuda-Envelope-From: Frans.Klaver@xsens.com
X-Barracuda-AUTH-User: xsenscom
X-Barracuda-Apparent-Source-IP: 87.249.116.215
Date: Thu, 11 Sep 2014 17:11:14 +0200
From: Frans Klaver <frans.klaver@xsens.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: Peter Hurley <peter@hurleysoftware.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>, <tony@atomide.com>,
        <gregkh@linuxfoundation.org>, <linux-kernel@vger.kernel.org>,
        <balbi@ti.com>, <linux-serial@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Alan Cox <alan@linux.intel.com>
Subject: Re: [PATCH 09/16] tty: serial: 8250_dma: Add a TX trigger workaround
 for AM33xx
Message-ID: <20140911151114.GD28458@ci00147.xsens-tech.local>
X-ASG-Orig-Subj: Re: [PATCH 09/16] tty: serial: 8250_dma: Add a TX trigger workaround
 for AM33xx
References: <1410377411-26656-1-git-send-email-bigeasy@linutronix.de>
 <1410377411-26656-10-git-send-email-bigeasy@linutronix.de>
 <20140911111721.GB17476@xps8300>
 <54118AAB.2010205@linutronix.de>
 <5411967A.6090406@hurleysoftware.com>
 <54119AAA.9080907@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <54119AAA.9080907@linutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Originating-IP: [172.16.11.160]
X-Barracuda-Connect: rev-215.116.249.87.virtu.nl[87.249.116.215]
X-Barracuda-Start-Time: 1410448276
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://filter1.ibarracuda.nl:8000/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 1
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=5.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.9372
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 11, 2014 at 02:50:50PM +0200, Sebastian Andrzej Siewior wrote:
> On 09/11/2014 02:32 PM, Peter Hurley wrote:
> > On 09/11/2014 07:42 AM, Sebastian Andrzej Siewior wrote:
> >> I also need a watchdog timer for TX since it seems that on omap3 the
> >> DMA engine suddenly forgets to continue with DMA…
> > 
> > One difference I noticed between the omap driver and the 8250 driver is
> > the way modem status interrupts are handled.
> > 
> > The omap driver only checks modem status for the UART_IIR_MSI interrupt type.
> > The 8250 driver checks modem status at every interrupt (other than NO_INT).
> > 
> > I think the UART_MSR_DCTS bit always reflects that the CTS input has changed
> > between reads of the MSR _even if auto CTS is on_. So perhaps the hardware
> > is being stopped by uart_handle_cts_change() when auto CTS is on?
> 
> I doubt that. What I see from a timer debug is that the TX-FIFO level
> is at 0, the DMA transfer for say 1024 bytes start.
> The FIFO is filled to 64bytes and refilled so it doesn't drop below 50.
> At the time of the stall I see that the DMA engine has outstanding
> bytes which it should transfer and the TX FIFO is empty. If hardware
> flow control stops the transfer, I would expect that the DMA engine
> still fills the TX-FIFO until 64 and then waits. But it doesn't.
> Writing bytes into the FIFO leads to bytes beeing sent (and I see them
> on the other side) but the DMA transfer is still on hold. Canceling the
> DMA transfer and re-programming the remaining bytes transfers the
> remaining bytes.
> 
> The odd thing is that I only triggered it with "less file". It doesn't
> happen on regular console interaction or "cat large-file". And it only
> triggers on beagle board xm (omap34xx) and I wasn't able to reproduce
> it on am335x or dra7. The latter shares the same DMA engine as beagle
> board xm.

I can still reproduce it on am335x. I can get out of it as soon as
something else gets written to the console though.

# echo "<3>something" >/dev/kmsg

Frans


> 
> I remember also that I disabled the HW/SW float control just to make
> sure it is not it.
> 
> > 
> > Regards,
> > Peter Hurley
> > 
> > [The UPF_HARD_FLOW thing was pretty much just done for omap even though
> > 8250 already had auto CTS/auto RTS. Serial core hardware flow control support
> > needs a redo as drivers have pretty much tacked stuff on randomly.]
> 
> Sebastian
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
