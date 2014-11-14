Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161640AbaKNSba (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 13:31:30 -0500
Received: from www.linutronix.de ([62.245.132.108]:54566 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161463AbaKNSb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 13:31:28 -0500
Message-ID: <54664A7C.5030404@linutronix.de>
Date: Fri, 14 Nov 2014 19:31:24 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Rabin Vincent <rabin@rab.in>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Ingo Molnar <mingo@redhat.com>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] serial: 8250: don't attempt a trylock if in sysrq
References: <1415988041-6124-1-git-send-email-rabin@rab.in>
In-Reply-To: <1415988041-6124-1-git-send-email-rabin@rab.in>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/14/2014 07:00 PM, Rabin Vincent wrote:
> Attempting to use SysRq via the 8250 serial port with spin lock
> debugging on on a uniprocessor system results in the following splat:
>
>  SysRq :
>  BUG: spinlock trylock failure on UP on CPU#0, swapper/0
>   lock: serial8250_ports+0x0/0x8c0, .magic: dead4ead, .owner: swapper/0, .owner_cpu: 0
>  Call Trace:
>   <IRQ>  [<ffffffff812c8d27>] dump_stack+0x19/0x1b
>   [<ffffffff8106812e>] spin_dump+0x7e/0xd0
>   [<ffffffff810681a6>] spin_bug+0x26/0x30
>   [<ffffffff8106843c>] do_raw_spin_trylock+0x4c/0x60
>   [<ffffffff812cdb1d>] _raw_spin_trylock+0x1d/0x60
>   [<ffffffff812336d8>] serial8250_console_write+0x68/0x190
>   [<ffffffff811eb0b0>] ? sprintf+0x40/0x50
>   [<ffffffff8106ab5e>] call_console_drivers.constprop.11+0x9e/0xf0
>   [<ffffffff8106b276>] console_unlock+0x3e6/0x490
>   [<ffffffff8106b595>] vprintk_emit+0x275/0x530
>   [<ffffffff812c869a>] printk+0x4d/0x4f
>   [<ffffffff8121e612>] __handle_sysrq+0x62/0x1b0
>   [<ffffffff8121ebc6>] handle_sysrq+0x26/0x30
>   [<ffffffff81233157>] serial8250_rx_chars+0x1d7/0x250
>   [<ffffffff812338bb>] serial8250_handle_irq+0x7b/0x90
>   [<ffffffff812338f3>] serial8250_default_handle_irq+0x23/0x30
>   [<ffffffff812318b3>] serial8250_interrupt+0x63/0xe0
>   [<ffffffff8106d80e>] handle_irq_event_percpu+0x4e/0x200

>  HELP : loglevel(0-9) reboot(b) crash(c) show-all-locks(d) te...
> 
> Before ebade5e833eda30 ("serial: 8250: Clean up the locking for -rt")
> this was handled by not even attempting to try the lock if port->sysrq,
> since it is known to be taken by the interrupt handler; see
> https://bugzilla.kernel.org/show_bug.cgi?id=6716#c1.  Restore that
> behavior.

Given the callchain it is expected that the lock is already taken.
While this splat is easy to trigger in the sysrq way you might get the
same splat in the oops_in_progress case which would be still okay.

While this is harmless to apply, I wonder if it is worth the effort to
teach lockdep that in this case it would be okay if the try_lock fails.

> Signed-off-by: Rabin Vincent <rabin@rab.in>
> ---
>  drivers/tty/serial/8250/8250_core.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/tty/serial/8250/8250_core.c b/drivers/tty/serial/8250/8250_core.c
> index ca5cfdc..aec51eb 100644
> --- a/drivers/tty/serial/8250/8250_core.c
> +++ b/drivers/tty/serial/8250/8250_core.c
> @@ -3198,7 +3198,9 @@ serial8250_console_write(struct console *co, const char *s, unsigned int count)
>  
>  	serial8250_rpm_get(up);
>  
> -	if (port->sysrq || oops_in_progress)
> +	if (port->sysrq)
> +		locked = 0;
> +	else if (oops_in_progress)
>  		locked = spin_trylock_irqsave(&port->lock, flags);
>  	else
>  		spin_lock_irqsave(&port->lock, flags);
> 

Sebastian
