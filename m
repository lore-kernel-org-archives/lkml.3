Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760070Ab3B0BS7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 20:18:59 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41767 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755666Ab3BZX5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 18:57:11 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [ 018/150] serial: imx: Fix recursive locking bug
Date: Tue, 26 Feb 2013 15:54:35 -0800
Message-Id: <20130226235526.126335588@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130226235523.930663721@linuxfoundation.org>
References: <20130226235523.930663721@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

commit 677fe555cbfb188af58cce105f4dae9505e58c31 upstream.

commit 9ec1882df2 (tty: serial: imx: console write routing is unsafe
on SMP) introduced a recursive locking bug in imx_console_write().

The callchain is:

imx_rxint()
  spin_lock_irqsave(&sport->port.lock,flags);
  ...
  uart_handle_sysrq_char();
    sysrq_function();
      printk();
        imx_console_write();
          spin_lock_irqsave(&sport->port.lock,flags); <--- DEAD

The bad news is that the kernel debugging facilities can dectect the
problem, but the printks never surface on the serial console for
obvious reasons.

There is a similar issue with oops_in_progress. If the kernel crashes
we really don't want to be stuck on the lock and unable to tell what
happened.

In general most UP originated drivers miss these checks and nobody
ever notices because CONFIG_PROVE_LOCKING seems to be still ignored by
a large number of developers.

The solution is to avoid locking in the sysrq case and trylock in the
oops_in_progress case.

This scheme is used in other drivers as well and it would be nice if
we could move this to a common place, so the usual copy/paste/modify
bugs can be avoided.

Now there is another issue with this scheme:

CPU0 	    	     	 CPU1
printk()
			 rxint()
			   sysrq_detection() -> sets port->sysrq
			 return from interrupt
  console_write()
     if (port->sysrq)
     	avoid locking

port->sysrq is reset with the next receive character. So as long as
the port->sysrq is not reset and this can take an endless amount of
time if after the break no futher receive character follows, all
console writes happen unlocked.

While the current writer is protected against other console writers by
the console sem, it's unprotected against open/close or other
operations which fiddle with the port. That's what the above mentioned
commit tried to solve.

That's an issue in all drivers which use that scheme and unfortunately
there is no easy workaround. The only solution is to have a separate
indicator port->sysrq_cpu. uart_handle_sysrq_char() then sets it to
smp_processor_id() before calling into handle_sysrq() and resets it to
-1 after that. Then change the locking check to:

     if (port->sysrq_cpu == smp_processor_id())
     	 locked = 0;
     else if (oops_in_progress)
         locked = spin_trylock_irqsave(port->lock, flags);
     else
  	 spin_lock_irqsave(port->lock, flags);

That would force all other cpus into the spin_lock path. Problem
solved, but that's way beyond the scope of this fix and really wants
to be implemented in a common function which calls the uart specific
write function to avoid another gazillion of hard to debug
copy/paste/modify bugs.

Reported-and-tested-by: Tim Sander <tim@krieglstein.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/serial/imx.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/drivers/tty/serial/imx.c
+++ b/drivers/tty/serial/imx.c
@@ -1213,8 +1213,14 @@ imx_console_write(struct console *co, co
 	struct imx_port_ucrs old_ucr;
 	unsigned int ucr1;
 	unsigned long flags;
+	int locked = 1;
 
-	spin_lock_irqsave(&sport->port.lock, flags);
+	if (sport->port.sysrq)
+		locked = 0;
+	else if (oops_in_progress)
+		locked = spin_trylock_irqsave(&sport->port.lock, flags);
+	else
+		spin_lock_irqsave(&sport->port.lock, flags);
 
 	/*
 	 *	First, save UCR1/2/3 and then disable interrupts
@@ -1241,7 +1247,8 @@ imx_console_write(struct console *co, co
 
 	imx_port_ucrs_restore(&sport->port, &old_ucr);
 
-	spin_unlock_irqrestore(&sport->port.lock, flags);
+	if (locked)
+		spin_unlock_irqrestore(&sport->port.lock, flags);
 }
 
 /*


