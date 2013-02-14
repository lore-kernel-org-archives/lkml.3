Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934707Ab3BNPiU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 10:38:20 -0500
Received: from lvps176-28-13-145.dedicated.hosteurope.de ([176.28.13.145]:46828
	"EHLO lvps176-28-13-145.dedicated.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760579Ab3BNPiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 10:38:19 -0500
From: Tim Sander <tim@krieglstein.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] 3.4.28-rt40 tglx fix imx.c spinlock
Date: Thu, 14 Feb 2013 16:38:14 +0100
Message-ID: <16398840.IK9i4U2q2d@dabox>
User-Agent: KMail/4.10 (Linux/3.6.0; KDE/4.10.0; x86_64; ; )
In-Reply-To: <alpine.LFD.2.02.1302131828050.22263@ionos>
References: <6003615.pRQnIgKCSn@dabox> <3970144.HqS49ZSYWh@dabox> <alpine.LFD.2.02.1302131828050.22263@ionos>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas
> > > > Just another update on this stuff. I noticed that there has been a
> > > > patch
> > > > added* with spinlocks to the imx.c serial driver. I reverted this
> > > > patch
> > > > and now my serialfuz programm "only" kills the serial port with a not
> > > > so
> > > > nice oom condition. But at least it does not show the runaway
> > > > interrupt
> > > > problem.
> > > 
> > > That does not make any sense, really. The runnaway interrupt issue is
> > > completely unrelated to this commit.
> > 
> > One thing that puzzles me is the fact that it does! So removing the
> > mentioned spinlock patch creates the same result as using your fixed
> > patch.
> > 
> > As the other problem with the driver i posted shows the same interrupt
> > runaway symptom as this i have a very bad gut feeling about this...
> > Or probably its not a runnaway interrupt problem but a double
> > spin_lock_irqsave.
> 
> Well, you claimed that it is a runnaway interrupt. So much for the
> theory :)
Well i sleept over that one. The symptoms in both cases seem to be identical:
system locked up,interrupt pending, no output at all. 

But there are some differences. Concerning the issue described in this mail:
http://www.spinics.net/lists/linux-rt-users/msg09303.html
After the complete lockup of the system i could get into a working system
 by switching of the interrupt source of the respective interrupt. After that the
interrupt readings in /proc/interrupts where insanely high. So definetly a runnaway
 interrupt issue. But this issue seems to be not related to preempt rt. They where
just so similar on the first glance that i thought they where related.

I could not get the system back running in switching of the serial interrupt.
Concerning the serial problem i consider the problem solved by the patch below. 
Thanks!

A patch for 3.6-rt will be sent in another reply. As it does not apply cleanly.

> The issue with the recursive locking is not an RT issue. You can
> observe the problem on mainline, when you enable PROVE_LOCKING and
> issue a sysrq or oopsing in a section which holds the port.lock
> already.
> 
> The reason why you can't observe it with PREEMPT_RT_FULL=n and
> PROVE_LOCKING=n is, that the spinlocks on UP machines are compiled
> away, so recursive locking does not lead to an observable dead lock.
Ah, yes that perfectly explains why i have not seen this error in non preempt-rt
mode.

> > Also the fact that my serialfuz program i posted is able to give the
> > system an Out Of Memory condition is strange. I mean throwing random
> > chars at a getty should'nt exhaust memory so fast.
> 
> That's true, but w/o seing the OOM output I can't tell what's
> exhausting the memory.
When fuzzing the serial port one probably should switch of sysreq. It seems 
as if there is a break send somehow and then it selects the OOM option.
So when switching of MAGIC_SYSRQ the OOMs are gone. So its a non issue.

Best regards
Tim


Signed-off-by: Tim Sander <tim@krieglstein.org>

---
 drivers/tty/serial/imx.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/imx.c b/drivers/tty/serial/imx.c
index 0de7ed7..f1f5c4e 100644
--- a/drivers/tty/serial/imx.c
+++ b/drivers/tty/serial/imx.c
@@ -47,6 +47,7 @@
 #include <linux/slab.h>
 #include <linux/of.h>
 #include <linux/of_device.h>
+#include <linux/kdb.h>

 #include <asm/io.h>
 #include <asm/irq.h>
@@ -1225,8 +1226,12 @@ imx_console_write(struct console *co, const char *s, unsigned int count)
    struct imx_port_ucrs old_ucr;
    unsigned int ucr1;
    unsigned long flags;
+   int locked = 1;

-   spin_lock_irqsave(&sport->port.lock, flags);
+   if (sport->port.sysrq || oops_in_progress || in_kdb_printk())
+       locked = spin_trylock_irqsave(&sport->port.lock, flags);
+   else
+       spin_lock_irqsave(&sport->port.lock, flags);

    /*
     *  First, save UCR1/2/3 and then disable interrupts
@@ -1253,7 +1258,8 @@ imx_console_write(struct console *co, const char *s, unsigned int count)

    imx_port_ucrs_restore(&sport->port, &old_ucr);

-   spin_unlock_irqrestore(&sport->port.lock, flags);
+   if (locked)
+       spin_unlock_irqrestore(&sport->port.lock, flags);
 }

 /*
-- 
1.7.9.5




