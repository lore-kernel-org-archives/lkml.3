Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161788AbaKNSBH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 13:01:07 -0500
Received: from mail-lb0-f180.google.com ([209.85.217.180]:37723 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161460AbaKNSBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 13:01:04 -0500
From: Rabin Vincent <rabin@rab.in>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Ingo Molnar <mingo@redhat.com>, bigeasy@linutronix.de,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rabin Vincent <rabin@rab.in>
Subject: [PATCH] serial: 8250: don't attempt a trylock if in sysrq
Date: Fri, 14 Nov 2014 19:00:41 +0100
Message-Id: <1415988041-6124-1-git-send-email-rabin@rab.in>
X-Mailer: git-send-email 2.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Attempting to use SysRq via the 8250 serial port with spin lock
debugging on on a uniprocessor system results in the following splat:

 SysRq :
 BUG: spinlock trylock failure on UP on CPU#0, swapper/0
  lock: serial8250_ports+0x0/0x8c0, .magic: dead4ead, .owner: swapper/0, .owner_cpu: 0
 CPU: 0 PID: 0 Comm: swapper Not tainted 3.18.0-rc4+ #37
 Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
  ffffffff8245ba00 ffffffff81628b28 ffffffff812c8d27 ffffffff81628b48
  ffffffff8106812e ffffffff8245ba00 ffffffff814e22ed ffffffff81628b68
  ffffffff810681a6 0000000000000000 0000000000000000 ffffffff81628b88
 Call Trace:
  <IRQ>  [<ffffffff812c8d27>] dump_stack+0x19/0x1b
  [<ffffffff8106812e>] spin_dump+0x7e/0xd0
  [<ffffffff810681a6>] spin_bug+0x26/0x30
  [<ffffffff8106843c>] do_raw_spin_trylock+0x4c/0x60
  [<ffffffff812cdb1d>] _raw_spin_trylock+0x1d/0x60
  [<ffffffff812336d8>] serial8250_console_write+0x68/0x190
  [<ffffffff811eb0b0>] ? sprintf+0x40/0x50
  [<ffffffff8106ab5e>] call_console_drivers.constprop.11+0x9e/0xf0
  [<ffffffff8106b276>] console_unlock+0x3e6/0x490
  [<ffffffff8106b595>] vprintk_emit+0x275/0x530
  [<ffffffff812c869a>] printk+0x4d/0x4f
  [<ffffffff8121e612>] __handle_sysrq+0x62/0x1b0
  [<ffffffff8121e5b5>] ? __handle_sysrq+0x5/0x1b0
  [<ffffffff8121ebc6>] handle_sysrq+0x26/0x30
  [<ffffffff81233157>] serial8250_rx_chars+0x1d7/0x250
  [<ffffffff812338bb>] serial8250_handle_irq+0x7b/0x90
  [<ffffffff812338f3>] serial8250_default_handle_irq+0x23/0x30
  [<ffffffff812318b3>] serial8250_interrupt+0x63/0xe0
  [<ffffffff8106d80e>] handle_irq_event_percpu+0x4e/0x200
  [<ffffffff8106da01>] handle_irq_event+0x41/0x70
  [<ffffffff810701ee>] ? handle_edge_irq+0x1e/0x110
  [<ffffffff8107026e>] handle_edge_irq+0x9e/0x110
  [<ffffffff810041c2>] handle_irq+0x22/0x40
  [<ffffffff812d096e>] do_IRQ+0x4e/0xf0
  [<ffffffff812cf4ed>] common_interrupt+0x6d/0x6d
  <EOI>  [<ffffffff8100acbf>] ? default_idle+0x1f/0xd0
  [<ffffffff8100acbd>] ? default_idle+0x1d/0xd0
  [<ffffffff8100b61f>] arch_cpu_idle+0xf/0x20
  [<ffffffff8105c1db>] cpu_startup_entry+0x25b/0x360
  [<ffffffff812c726e>] rest_init+0xbe/0xd0
  [<ffffffff816a4dcb>] start_kernel+0x339/0x346
  [<ffffffff816a4495>] x86_64_start_reservations+0x2a/0x2c
  [<ffffffff816a4589>] x86_64_start_kernel+0xf2/0xf6
 HELP : loglevel(0-9) reboot(b) crash(c) show-all-locks(d) te...

Before ebade5e833eda30 ("serial: 8250: Clean up the locking for -rt")
this was handled by not even attempting to try the lock if port->sysrq,
since it is known to be taken by the interrupt handler; see
https://bugzilla.kernel.org/show_bug.cgi?id=6716#c1.  Restore that
behavior.

Signed-off-by: Rabin Vincent <rabin@rab.in>
---
 drivers/tty/serial/8250/8250_core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/serial/8250/8250_core.c b/drivers/tty/serial/8250/8250_core.c
index ca5cfdc..aec51eb 100644
--- a/drivers/tty/serial/8250/8250_core.c
+++ b/drivers/tty/serial/8250/8250_core.c
@@ -3198,7 +3198,9 @@ serial8250_console_write(struct console *co, const char *s, unsigned int count)
 
 	serial8250_rpm_get(up);
 
-	if (port->sysrq || oops_in_progress)
+	if (port->sysrq)
+		locked = 0;
+	else if (oops_in_progress)
 		locked = spin_trylock_irqsave(&port->lock, flags);
 	else
 		spin_lock_irqsave(&port->lock, flags);
-- 
2.1.1

