Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755747AbaICQqT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 12:46:19 -0400
Received: from www.linutronix.de ([62.245.132.108]:45765 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751989AbaICQqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 12:46:16 -0400
Message-ID: <540745CC.2090901@linutronix.de>
Date: Wed, 03 Sep 2014 18:46:04 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: balbi@ti.com, linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Vinod Koul <vinod.koul@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paul Walmsley <paul@pwsan.com>
Subject: Re: [PATCH 15/15] tty: serial: 8250: omap: add dma support
References: <53FE3779.5090908@linutronix.de> <20140827202313.GF16006@atomide.com> <20140828082348.GA5413@linutronix.de> <20140828164645.GG16006@atomide.com> <53FF84DF.7080406@linutronix.de> <20140828225454.GM16006@atomide.com> <540048B4.7010807@linutronix.de> <20140829161221.GO16006@atomide.com> <5404B149.6010400@linutronix.de> <54060EDA.6060204@linutronix.de> <20140902201536.GC11766@atomide.com>
In-Reply-To: <20140902201536.GC11766@atomide.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/02/2014 10:15 PM, Tony Lindgren wrote:
>> - I see to face two kind of "deaths":
>>   - the LED still goes on and off and the uart just does not respond
>>     even if I tell the button print something on the screen (the button
>>     also changes the frequency of the LED so I know that the button is
>>     doing something).
>>     Also from dumping the content of /proc/interrupts it seems that a
>>     wake up is made, the uart should have restored the registers.
> 
> OK yeah this is the case I was seeing too. So do you just set the
> LED triggers to none in sysfs to make it easier to reproduce?

Yes.

>>   - one where the system is dead and the LED does not blink anymore.
>>     Also my button is dead.
> 
> This I don't think I've seen. This could also be the errata issue on
> your earlier rev beagleboard-xm with off-idle.

might be.

Your pstore hint gave me something. I tried that earlier but somehow
assumed that dram content was killed on init. But the content is even
there are pressing the reset button :)

However, I was able to capture the case where the LED was not blinking:
The IIR register says 0xc6 (=> line status error). That is okay. At the
same time LSR register says 0xe0. This is not okay. It means that there
is some kind of error and at least one error bit is set in this
register which is not the case. Also those bits are cleared on read
which does not happen here. And we loop forever so the LED does blink
anymore.

The RX-count register says that it is empty which sense because bit 0
is not set (in LSR). However I can read multiple times from the RX FIFO
until I get the "unhandled bus access" error which usually happens
right away if the empty FIFO is read on omap3 HW. In the last test I
mange to read 91 times before the crash. I hoped that this FIFO read
would make the interrupt go away but it did not.

The HW seems to be in a strange state. It might be either the errata
or something else. I even took the resume routine from omap-serial in
case I did something wrong. In my last test it worked for 10minues
before the interrupt storm came.

This is probably the same thing I see on the omap-serial driver where I
got from pstore:

[   32.659271] random: nonblocking pool is initialized
[  212.170623] NMI watchdog: BUG: soft lockup - CPU#0 stuck for 22s!
[swapper:0]

So I *guess* the interrupt routine is looping. This is problem one, no
idea what is going on (the register status captured on 8250-omap makes
no sense).

Problem two, where the UART does not wakeup:
What I observed is that sometimes the UART does not wake up properly
i.e. it does not write anything on the console, even where it should. I
can't tell if the read is working properly, the write does not.
>From my capture I see that the resume routine was running and the
register should have been written. That means the UART should be up and
running but nothing happens.
It often works again after the system comes out of resume again (i.e.
RPM suspens and resumes the UART). So it is okay on the next wakeup. Or
the wakeup after next.
>From the script:

| while ((1))
| do
|
|         echo -n 409-chars >/dev/ttyUSB0
|
|         sleep 1
|         a=$(date)
|         echo -e "\n#$a" >/dev/ttyUSB0
|         echo $a
|         sleep 13;
| done

I see that sometimes one or two sequential timestamps are missing. And
the it continues like nothing happened.

> Tony

Sebastian
