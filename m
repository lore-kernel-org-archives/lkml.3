Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932260Ab3BSDzI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 22:55:08 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:33190 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932167Ab3BSDyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 22:54:12 -0500
X-Authority-Analysis: v=2.0 cv=H5hZMpki c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=XHIcPCUdav8A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=Ys_0Hq5Qgs4A:10 a=CodCKRyIAAAA:8 a=ag1SF4gXAAAA:8 a=6ohNodAXAAAA:8 a=hVcwujEvAAAA:8 a=KKAkSRfTAAAA:8 a=VwQbUJbxAAAA:8 a=ZNN4yaR7mgoeiYcO7SkA:9 a=Zh68SRI7RUMA:10 a=j0Y22Z3SadcA:10 a=1TSTQ8KKaH4A:10 a=gDjHQkheYgsA:10 a=WwgC8nHKvroA:10 a=XNN-oNMjSfgA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130219035410.547368902@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 18 Feb 2013 22:53:43 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Xinyu Chen <xinyu.chen@freescale.com>,
        Dirk Behme <dirk.behme@de.bosch.com>, Shawn Guo <shawn.guo@linaro.org>,
        Tim Sander <tim@krieglstein.org>,
        Sascha Hauer <s.hauer@pengutronix.de>, <stable-rt@vger.kernel.org>
Subject: [PATCH RT 4/7] serial: Imx: Fix recursive locking bug
References: <20130219035339.428477998@goodmis.org>
Content-Disposition: inline; filename=0004-serial-Imx-Fix-recursive-locking-bug.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

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
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: Xinyu Chen <xinyu.chen@freescale.com>
Cc: Dirk Behme <dirk.behme@de.bosch.com>
Cc: Shawn Guo <shawn.guo@linaro.org>
Cc: Tim Sander <tim@krieglstein.org>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Cc: stable-rt@vger.kernel.org
Link: http://lkml.kernel.org/r/alpine.LFD.2.02.1302142006050.22263@ionos
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/tty/serial/imx.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/imx.c b/drivers/tty/serial/imx.c
index 0de7ed7..6604736 100644
--- a/drivers/tty/serial/imx.c
+++ b/drivers/tty/serial/imx.c
@@ -1225,8 +1225,14 @@ imx_console_write(struct console *co, const char *s, unsigned int count)
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
@@ -1253,7 +1259,8 @@ imx_console_write(struct console *co, const char *s, unsigned int count)
 
 	imx_port_ucrs_restore(&sport->port, &old_ucr);
 
-	spin_unlock_irqrestore(&sport->port.lock, flags);
+	if (locked)
+		spin_unlock_irqrestore(&sport->port.lock, flags);
 }
 
 /*
-- 
1.7.10.4


