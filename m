Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756055AbaDHAXP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 20:23:15 -0400
Received: from www.sr71.net ([198.145.64.142]:33283 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754690AbaDHAXN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 20:23:13 -0400
Message-ID: <5343416F.8010201@sr71.net>
Date: Mon, 07 Apr 2014 17:23:11 -0700
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Geert Uytterhoeven <geert+renesas@linux-m68k.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-serial@vger.kernel.org,
        jslaby@suse.cz
Subject: post 3.14 serial regression
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geert,

I have a piece of hardware where the two normal serial ports are
inaccessible and buried inside the system somewhere.  I put a PCIe
serial port card in which is normally detected as a ST16650V2:

[   17.939057] 0000:13:00.0: ttyS2 at I/O 0x1008 (irq = 18, base_baud =
115200) is a ST16650V2

I normally boot with both a console= and earlyprintk=.  Since the card
is at a non-standard I/O port, I have to use the I/O port directly in
the earlyprintk arguments instead of ttySXX:

	console=ttyS2,115200 earlyprintk=serial,0x1008,115200

However, after 3.14, commit 5f5c9ae56c3:

> commit 5f5c9ae56c38942623f69c3e6dc6ec78e4da2076
> Author: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
> Date:   Fri Feb 28 14:21:32 2014 +0100
> 
>     serial_core: Unregister console in uart_remove_one_port()

the system to appears to hang at boot:

...
> [    0.000000] NR_IRQS:16640 nr_irqs:2728 16
> [    0.000000] Console: colour VGA+ 80x25
> [    0.000000] console [ttyS2] enabled
> [    0.000000] bootconsole [earlyser0] disabled

Here's a boot with earlyprintk=...,keep so that I can get *some* output:

	http://sr71.net/~dave/intel/pre-3.15-console-dead.txt

At the end, you can see that init is somehow dying.  If I revert this
patch, init is happy again and doesn't die, and the serial console works
like before.  Could init somehow be angry that its console is gone or
broken somehow?  Also, if I boot without console=ttyS2,115200, the
system boots happily.

Here's the .config:

	http://sr71.net/~dave/intel/pre-3.15-console-dead.config.txt
