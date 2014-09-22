Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753491AbaIVJ3D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 05:29:03 -0400
Received: from filter1.ibarracuda.nl ([83.247.7.10]:43721 "EHLO
	filter1.ibarracuda.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753354AbaIVJ27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 05:28:59 -0400
X-ASG-Debug-ID: 1411378135-0759e761294dbf10002-xx1T2L
X-Barracuda-Envelope-From: Frans.Klaver@xsens.com
X-Barracuda-AUTH-User: xsenscom
X-Barracuda-Apparent-Source-IP: 87.249.116.215
Date: Mon, 22 Sep 2014 11:28:54 +0200
From: Frans Klaver <frans.klaver@xsens.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Peter Hurley <peter@hurleysoftware.com>, <tony@atomide.com>,
        <gregkh@linuxfoundation.org>, <linux-kernel@vger.kernel.org>,
        <balbi@ti.com>, <linux-serial@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Alan Cox <alan@linux.intel.com>
Subject: Re: [PATCH 09/16] tty: serial: 8250_dma: Add a TX trigger workaround
 for AM33xx
Message-ID: <20140922092853.GH20438@ci00147.xsens-tech.local>
X-ASG-Orig-Subj: Re: [PATCH 09/16] tty: serial: 8250_dma: Add a TX trigger workaround
 for AM33xx
References: <20140911151114.GD28458@ci00147.xsens-tech.local>
 <5411C810.7070906@linutronix.de>
 <2cf997d9-e7de-465b-915d-3a0a5e7b95f7@email.android.com>
 <54129F6C.7040508@linutronix.de>
 <20140912094010.GE28458@ci00147.xsens-tech.local>
 <5412C21A.8020203@linutronix.de>
 <20140912102816.GF28458@ci00147.xsens-tech.local>
 <541716DC.9020904@linutronix.de>
 <20140917102812.GA20438@ci00147.xsens-tech.local>
 <20140921204100.GA10111@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140921204100.GA10111@linutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Originating-IP: [172.16.11.160]
X-Barracuda-Connect: rev-215.116.249.87.virtu.nl[87.249.116.215]
X-Barracuda-Start-Time: 1411378135
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://filter1.ibarracuda.nl:8000/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 1
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=5.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.9746
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 21, 2014 at 10:41:00PM +0200, Sebastian Andrzej Siewior wrote:
> * Frans Klaver | 2014-09-17 12:28:12 [+0200]:
> 
> >- Bone Black: Yocto poky, core-image-minimal
> >  Login, "less file" locks up, doesn't show anything. I can exit using
> >  Ctrl-C.
> 
> So I have the same with my and the serial-omap driver. No difference
> here. The trace looks like this:
> |           <idle>-0     [000] d.h.   444.393585: serial8250_handle_irq: iir cc lsr 61
> |           <idle>-0     [000] d.h.   444.393605: serial8250_rx_chars: get 0d
> received the enter key
> 
> |           <idle>-0     [000] d.h.   444.393609: serial8250_rx_chars: insert d lsr 61
> |           <idle>-0     [000] d.h.   444.393614: uart_insert_char: 1
> |           <idle>-0     [000] d.h.   444.393617: uart_insert_char: 2
> |           <idle>-0     [000] dnh.   444.393636: serial8250_tx_chars: empty
> |      kworker/0:2-753   [000] d...   444.393686: serial8250_start_tx: empty?1
> |      kworker/0:2-753   [000] d.h.   444.393699: serial8250_handle_irq: iir c2 lsr 60
> |      kworker/0:2-753   [000] d.h.   444.393705: serial8250_tx_chars: empty
> |               sh-1042  [000] d...   444.393822: serial8250_start_tx: empty?1
> |               sh-1042  [000] d.h.   444.393836: serial8250_handle_irq: iir c2 lsr 60
> |               sh-1042  [000] d.h.   444.393842: serial8250_tx_chars: empty
> |               sh-1042  [000] d...   444.393855: serial8250_start_tx: empty?0
> |               sh-1042  [000] d.h.   444.393863: serial8250_handle_irq: iir c2 lsr 60
> |               sh-1042  [000] d.h.   444.393867: serial8250_tx_chars: put 0d
> |               sh-1042  [000] d.h.   444.393871: serial8250_tx_chars: put 0a
> 
> shell responded with "\r\n" which I see and then
> 
> |               sh-1042  [000] d.h.   444.394057: serial8250_handle_irq: iir c2 lsr 60
> |               sh-1042  [000] d.h.   444.394065: serial8250_tx_chars: empty
> 
> nothing more. less isn't sending data for some reason. Exactly the same
> thing happens in a Debian environment except that it continues:
> …
> |             bash-2468  [000] d.h.    99.657899: serial8250_tx_chars: put 0a
> |             bash-2468  [000] d.h.    99.658089: serial8250_handle_irq: iir c2 lsr 60
> |             bash-2468  [000] d.h.    99.658095: serial8250_tx_chars: empty
> =>
> |             less-2474  [000] d...    99.696038: serial8250_start_tx: empty?0
> |             less-2474  [000] d.h.    99.696069: serial8250_handle_irq: iir c2 lsr 60
> |             less-2474  [000] d.h.    99.696078: serial8250_tx_chars: put 1b
> |             less-2474  [000] d.h.    99.696082: serial8250_tx_chars: put 5b
> |             less-2474  [000] d.h.    99.696085: serial8250_tx_chars: put 3f
> |             less-2474  [000] d.h.    99.696087: serial8250_tx_chars: put 31
> 
> It has to be something about the environment. Booting Debian and chroot
> into this RFS and less works perfectly. But since it behaves like that
> with both drivers, I guess the problem is somewhere else…
> 
> >  vi runs normally, only occupies part of the total screen estate in
> >  minicom. After quitting, a weird character shows up (typically I see
> >  ÿ there), but minicom can use the rest of the screen estate again.
> >  If we disregard the odd character, this is much like the behavior we
> >  have on the omap-serial driver.
> >- Custom board: Yocto poky, custom image
> >  Login, "less file" locks up, showing only "ÿ" in the top left corner
> >  of the screen. Can get out of there by having something dumped through
> >  /dev/kmsg.
> 
> I managed to run into something like that with vi on dra7 and with
> little more patience on am335x as well by "vi *" and then ":n".
> 
> This gets fixed indeed by writing. Hours of debugging and a lot of hair
> less later: the yocto RFS calls set_termios quite a lot. This includes
> changing the baudrate (not by yocto but the driver sets it to 0 and then
> to the requested one) and this seems to be responsible for the "bad
> bytes". I haven't figured out yet I don't see this with omap-serial.
> Even worse: If this (set_termios()) happens while the DMA is still
> active then it might stall it. A write into the FIFO seems to fix it and
> this is where your "echo >/dev/kmsg" fixes things.
> If I delay the restore_registers part of set_termios() until TX-DMA is
> complete then it seems that the TX-DMA stall does not tall anymore.

Wow, thanks for your work here. This does indeed sound hard to trap.

I guess then we'd still have to answer the question why the yocto build
calls set_termios() so often, but that's not on you then. Did you notice
it even changing settings? We might want to fix this even if the kernel
should be able to cope.

Thanks again,
Frans
