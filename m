Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754347AbaANApt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 19:45:49 -0500
Received: from c60.cesmail.net ([216.154.195.49]:8553 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752476AbaANApn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 19:45:43 -0500
X-Greylist: delayed 581 seconds by postgrey-1.27 at vger.kernel.org; Mon, 13 Jan 2014 19:45:43 EST
Date: Mon, 13 Jan 2014 19:35:47 -0500
From: Pavel Roskin <proski@gnu.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org
Subject: serial8250: bogus low_latency destabilizes kernel, need sanity
 check
Message-ID: <20140113193547.47b7a646@IRBT4585>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

I've been debugging an instability of a kernel on some 32-bit x86
embedded system.  The kernel would just hang randomly.  I had to enable
most debug options to find the reason.

The system has several serial ports, including ttyS4.  There is also a
file called /etc/serial.conf that contains a line

/dev/ttyS4 uart 16550a irq 17 baud_base 921600 port 0xd000 low_latency

That file is processed by the setserial utility on startup that makes
the port as low_latency.

And then the kernel reports this:

BUG: sleeping function called from invalid context
at /root/src/linux-3.12.6/kernel/mutex.c:616 in_atomic(): 1,
irqs_disabled(): 1, pid: 0, name: swapper/0 INFO: lockdep is turned off.
irq event stamp: 296476
hardirqs last  enabled at (296475): [<c10b4ff1>]
tick_nohz_idle_exit+0x151/0x1b0 hardirqs last disabled at (296476):
[<c1588f45>] _raw_spin_lock_irq+0x15/0x80 softirqs last  enabled at
(296458): [<c1049c9d>] __do_softirq+0x2ad/0x3b0 softirqs last disabled
at (296421): [<c1004637>] do_softirq+0x97/0xf0 CPU: 0 PID: 0 Comm:
swapper/0 Not tainted 3.12.6 #3 Hardware name: RadiSys SandyBridge
Platform/S-CEQM67-i5-2515EE , BIOS 20.02.01 08/29/2012 00000000
00000000 f480de5c c1580991 c17d7a00 f480de84 c1076726 c1710154 00000001
00000001 00000000 c17d7cfc f495b000 f3df097c 00000000 f480decc c1584223
f495b058 00000001 f495b018 f480deb8 c134cf7c 00000001 00000002 Call
Trace: [<c1580991>] dump_stack+0x4b/0x66
[<c1076726>] __might_sleep+0x166/0x210
[<c1584223>] mutex_lock_nested+0x23/0x380
[<c134cf7c>] ? ldsem_down_read_trylock+0x7c/0xa0
[<c134acf2>] ? tty_ldisc_ref+0x22/0x50
[<c134acf2>] ? tty_ldisc_ref+0x22/0x50
[<c134bc5e>] flush_to_ldisc+0x3e/0x100
[<c134bd60>] tty_flip_buffer_push+0x40/0x50
[<c1361a15>] serial8250_rx_chars+0xc5/0x200
[<c158902b>] ? _raw_spin_lock_irqsave+0x7b/0x90
[<c1362e67>] ? serial8250_handle_irq+0x37/0xa0
[<c1362eb1>] serial8250_handle_irq+0x81/0xa0
[<c1362eec>] serial8250_default_handle_irq+0x1c/0x20
[<c1360d0c>] serial8250_interrupt+0x5c/0xd0
[<c10a3744>] handle_irq_event_percpu+0x54/0x390
[<c10a67e6>] ? handle_fasteoi_irq+0x16/0xe0
[<c10a3ab1>] ? handle_irq_event+0x31/0x60
[<c10a3aba>] handle_irq_event+0x3a/0x60
[<c10a67d0>] ? unmask_irq+0x30/0x30
[<c10a681e>] handle_fasteoi_irq+0x4e/0xe0
<IRQ>  [<c15922d2>] ? do_IRQ+0x42/0xc0

That's a backtrace for Linux 3.12.6, but 3.13-rc8 does the same thing.

serial8250_handle_irq() tries to use the DMA and fails, so it calls
serial8250_rx_chars().  That function calls tty_flip_buffer_push().
The comment above tty_flip_buffer_push() says:

"This function must not be called from IRQ context if port->low_latency
is set"

And that's precisely what we are doing.

Sure, root can damage the system by using incorrect configuration
files.  However, I think we need some sanity checking.  After all, the
device may degrade and stop working as a low-latency port, and we don't
want the whole system to hang because of that.

Maybe we should unset the low_latency flag as soon as DMA fails?  There
are two flags, one is state->uart_port->flags and the other is
port->low_latency.  I guess we need to unset both.

-- 
Regards,
Pavel Roskin
