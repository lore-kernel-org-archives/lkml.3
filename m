Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756312AbaIWREY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 13:04:24 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:59651 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756168AbaIWREW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 13:04:22 -0400
Message-ID: <5421A7F7.3070109@hurleysoftware.com>
Date: Tue, 23 Sep 2014 13:03:51 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Frans Klaver <frans.klaver@xsens.com>
CC: Heikki Krogerus <heikki.krogerus@linux.intel.com>, tony@atomide.com,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, balbi@ti.com,
        linux-serial@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Alan Cox <alan@linux.intel.com>
Subject: Re: [PATCH 09/16] tty: serial: 8250_dma: Add a TX trigger workaround
 for AM33xx
References: <54119AAA.9080907@linutronix.de> <20140911151114.GD28458@ci00147.xsens-tech.local> <5411C810.7070906@linutronix.de> <2cf997d9-e7de-465b-915d-3a0a5e7b95f7@email.android.com> <54129F6C.7040508@linutronix.de> <20140912094010.GE28458@ci00147.xsens-tech.local> <5412C21A.8020203@linutronix.de> <20140912102816.GF28458@ci00147.xsens-tech.local> <541716DC.9020904@linutronix.de> <20140917102812.GA20438@ci00147.xsens-tech.local> <20140921204100.GA10111@linutronix.de>
In-Reply-To: <20140921204100.GA10111@linutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/21/2014 04:41 PM, Sebastian Andrzej Siewior wrote:
> * Frans Klaver | 2014-09-17 12:28:12 [+0200]:
> 
>> - Bone Black: Yocto poky, core-image-minimal
>>  Login, "less file" locks up, doesn't show anything. I can exit using
>>  Ctrl-C.
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
>>  vi runs normally, only occupies part of the total screen estate in
>>  minicom. After quitting, a weird character shows up (typically I see
>>  ÿ there), but minicom can use the rest of the screen estate again.
>>  If we disregard the odd character, this is much like the behavior we
>>  have on the omap-serial driver.
>> - Custom board: Yocto poky, custom image
>>  Login, "less file" locks up, showing only "ÿ" in the top left corner
>>  of the screen. Can get out of there by having something dumped through
>>  /dev/kmsg.
> 
> I managed to run into something like that with vi on dra7 and with
> little more patience on am335x as well by "vi *" and then ":n".
> 
> This gets fixed indeed by writing. Hours of debugging and a lot of hair
> less later: the yocto RFS calls set_termios quite a lot.

readline() does this; it 'saves' the caller's termios, sets termios
for non-canonical reads, reads one char, and 'restores' the caller's
termios.

> This includes
> changing the baudrate (not by yocto but the driver sets it to 0 and then
> to the requested one) and this seems to be responsible for the "bad
> bytes". I haven't figured out yet I don't see this with omap-serial.
> Even worse: If this (set_termios()) happens while the DMA is still
> active then it might stall it. A write into the FIFO seems to fix it and
> this is where your "echo >/dev/kmsg" fixes things.
> If I delay the restore_registers part of set_termios() until TX-DMA is
> complete then it seems that the TX-DMA stall does not tall anymore.

The tty core calls the driver's wait_until_sent() method before changing
the termios (if TCSADRAIN is used for tcsetattr(), which I think for readline()
it does).

But DMA is cheating if the UART driver's tx_empty() method is saying the
transmitter is empty while TX DMA is still running.

Regards,
Peter Hurley
 

