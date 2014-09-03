Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753787AbaICRs6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 13:48:58 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:33573 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150AbaICRsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 13:48:55 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18bijABhybafqsCXivAYuHT
Date: Wed, 3 Sep 2014 10:48:46 -0700
From: Tony Lindgren <tony@atomide.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: balbi@ti.com, linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Vinod Koul <vinod.koul@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paul Walmsley <paul@pwsan.com>
Subject: Re: [PATCH 15/15] tty: serial: 8250: omap: add dma support
Message-ID: <20140903174845.GE11766@atomide.com>
References: <20140828082348.GA5413@linutronix.de>
 <20140828164645.GG16006@atomide.com>
 <53FF84DF.7080406@linutronix.de>
 <20140828225454.GM16006@atomide.com>
 <540048B4.7010807@linutronix.de>
 <20140829161221.GO16006@atomide.com>
 <5404B149.6010400@linutronix.de>
 <54060EDA.6060204@linutronix.de>
 <20140902201536.GC11766@atomide.com>
 <540745CC.2090901@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <540745CC.2090901@linutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Sebastian Andrzej Siewior <bigeasy@linutronix.de> [140903 09:46]:
> On 09/02/2014 10:15 PM, Tony Lindgren wrote:
> >> - I see to face two kind of "deaths":
> >>   - the LED still goes on and off and the uart just does not respond
> >>     even if I tell the button print something on the screen (the button
> >>     also changes the frequency of the LED so I know that the button is
> >>     doing something).
> >>     Also from dumping the content of /proc/interrupts it seems that a
> >>     wake up is made, the uart should have restored the registers.
> > 
> > OK yeah this is the case I was seeing too. So do you just set the
> > LED triggers to none in sysfs to make it easier to reproduce?
> 
> Yes.
> 
> >>   - one where the system is dead and the LED does not blink anymore.
> >>     Also my button is dead.
> > 
> > This I don't think I've seen. This could also be the errata issue on
> > your earlier rev beagleboard-xm with off-idle.
> 
> might be.
> 
> Your pstore hint gave me something. I tried that earlier but somehow
> assumed that dram content was killed on init. But the content is even
> there are pressing the reset button :)

Yeah pstore is very nice for debugging mystery hangs :)
 
> However, I was able to capture the case where the LED was not blinking:
> The IIR register says 0xc6 (=> line status error). That is okay. At the
> same time LSR register says 0xe0. This is not okay. It means that there
> is some kind of error and at least one error bit is set in this
> register which is not the case. Also those bits are cleared on read
> which does not happen here. And we loop forever so the LED does blink
> anymore.

OK
 
> The RX-count register says that it is empty which sense because bit 0
> is not set (in LSR). However I can read multiple times from the RX FIFO
> until I get the "unhandled bus access" error which usually happens
> right away if the empty FIFO is read on omap3 HW. In the last test I
> mange to read 91 times before the crash. I hoped that this FIFO read
> would make the interrupt go away but it did not.
> 
> The HW seems to be in a strange state. It might be either the errata
> or something else. I even took the resume routine from omap-serial in
> case I did something wrong. In my last test it worked for 10minues
> before the interrupt storm came.
> 
> This is probably the same thing I see on the omap-serial driver where I
> got from pstore:
> 
> [   32.659271] random: nonblocking pool is initialized
> [  212.170623] NMI watchdog: BUG: soft lockup - CPU#0 stuck for 22s!
> [swapper:0]
> 
> So I *guess* the interrupt routine is looping. This is problem one, no
> idea what is going on (the register status captured on 8250-omap makes
> no sense).

See recent commit cc824534d4fe, and try commenting out the check for
HWMOD_FORCE_MSTANDBY in omap_hwmod.c so _reconfigure_io_chain() is always
called. If that changes something, we at least have some idea.

It could be also the wake-up interrupt looping. So you may also want to
try adding some printks (pstore only) into omap_prcm_irq_handler() and
omap3xxx_prm_clear_mod_irqs() as that's handling the wake-up event
interrupts.
 
> Problem two, where the UART does not wakeup:
> What I observed is that sometimes the UART does not wake up properly
> i.e. it does not write anything on the console, even where it should. I
> can't tell if the read is working properly, the write does not.
> From my capture I see that the resume routine was running and the
> register should have been written. That means the UART should be up and
> running but nothing happens.

This seems also be hinting to something needing _reconfigure_io_chain()
to be called along the lines of commit cc824534d4fe.

> It often works again after the system comes out of resume again (i.e.
> RPM suspens and resumes the UART). So it is okay on the next wakeup. Or
> the wakeup after next.
> From the script:
> 
> | while ((1))
> | do
> |
> |         echo -n 409-chars >/dev/ttyUSB0
> |
> |         sleep 1
> |         a=$(date)
> |         echo -e "\n#$a" >/dev/ttyUSB0
> |         echo $a
> |         sleep 13;
> | done
> 
> I see that sometimes one or two sequential timestamps are missing. And
> the it continues like nothing happened.

OK. At least it's starting to now sound that the bugs are pretty much
the same with 8250 and serial-omap :)

Regards,

Tony
