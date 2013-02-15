Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091Ab3BOHFP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 02:05:15 -0500
Received: from lvps176-28-13-145.dedicated.hosteurope.de ([176.28.13.145]:37384
	"EHLO lvps176-28-13-145.dedicated.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753320Ab3BOHFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 02:05:13 -0500
From: Tim Sander <tim@krieglstein.org>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
        gregkh@linuxfoundation.org
Subject: [PATHC] 3.6 spinlock fix
Date: Fri, 15 Feb 2013 08:05:08 +0100
Message-ID: <3258732.q5XBfts1EM@dabox>
User-Agent: KMail/4.10 (Linux/3.6.0; KDE/4.10.0; x86_64; ; )
In-Reply-To: <CAP=VYLo2zxJWy3s6AmZc+Hh6wXh67HMp+mM0nEkN6M_OpKJSug@mail.gmail.com>
References: <6003615.pRQnIgKCSn@dabox> <alpine.LFD.2.02.1302142334120.22263@ionos> <CAP=VYLo2zxJWy3s6AmZc+Hh6wXh67HMp+mM0nEkN6M_OpKJSug@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi
> On Thu, Feb 14, 2013 at 5:35 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> > On Thu, 14 Feb 2013, Tim Sander wrote:
> >> > That's true, but w/o seing the OOM output I can't tell what's
> >> > exhausting the memory.
> >> 
> >> When fuzzing the serial port one probably should switch of sysreq. It
> >> seems
> >> as if there is a break send somehow and then it selects the OOM option.
> >> So when switching of MAGIC_SYSRQ the OOMs are gone. So its a non issue.
> > 
> > Amazing that you get the break+oom combo out of that fuzzer!
That fuzzer is running at 57600Hz while the serial port of the fuzzed device is
running twice that rate. The break condition seems to be easy hit by the fuzzer
 i've sent in a previous mail. 
> Doing a basic "git whatchanged" and searching for "trinity" is rather
> impressive, regardless of the kernel version and/or where "rogue states"
> may currently be at with their "program"....   Kudos to davej for that.
Mh, but thats not trinity! Havn't tried that but well fuzzing at a different 
serial rate than the receiver might be a good idea even if it sounds pretty stupid.

Attached is the patch for the 3.6.9-rt kernel (but i think this should also apply 
to the "normal" 3.6 i guess).  But as Greg already took care of this patch i guess 
that only for convinience. Also it seems as if the patch sent to Greg is missing the
#include <linux/kdb.h>?

Best regards
Tim

    tglx: fix imx.c spinlock

diff --git a/drivers/tty/serial/imx.c b/drivers/tty/serial/imx.c
index e309e8b..39820ea 100644
--- a/drivers/tty/serial/imx.c
+++ b/drivers/tty/serial/imx.c
@@ -48,6 +48,7 @@
 #include <linux/of.h>
 #include <linux/of_device.h>
 #include <linux/pinctrl/consumer.h>
+#include <linux/kdb.h>
 
 #include <asm/io.h>
 #include <asm/irq.h>
@@ -1213,8 +1214,12 @@ imx_console_write(struct console *co, const char *s, unsigned int count)
        struct imx_port_ucrs old_ucr;
        unsigned int ucr1;
        unsigned long flags;
+       int locked = 1;
 
-       spin_lock_irqsave(&sport->port.lock, flags);
+       if (sport->port.sysrq || oops_in_progress || in_kdb_printk())
+               locked = spin_trylock_irqsave(&sport->port.lock, flags);
+       else
+               spin_lock_irqsave(&sport->port.lock, flags);
 
        /*
         *      First, save UCR1/2/3 and then disable interrupts
@@ -1241,7 +1246,8 @@ imx_console_write(struct console *co, const char *s, unsigned int count)
 
        imx_port_ucrs_restore(&sport->port, &old_ucr);
 
-       spin_unlock_irqrestore(&sport->port.lock, flags);
+       if (locked)
+               spin_unlock_irqrestore(&sport->port.lock, flags);
 }
 
 /*

