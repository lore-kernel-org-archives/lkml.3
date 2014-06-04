Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752144AbaFDKtr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 06:49:47 -0400
Received: from www.linutronix.de ([62.245.132.108]:34451 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992AbaFDKtq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 06:49:46 -0400
Date: Wed, 4 Jun 2014 12:49:27 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        John Stultz <john.stultz@linaro.org>, Olof Johansson <olof@lixom.net>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: linux-next: build failure after merge of the tip tree
In-Reply-To: <20140604160522.1d788c1e@canb.auug.org.au>
Message-ID: <alpine.DEB.2.10.1406041134070.3319@nanos>
References: <20140604160522.1d788c1e@canb.auug.org.au>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Jun 2014, Stephen Rothwell wrote:

> Hi all,
> 
> After merging the tip tree, today's linux-next build (arm
> multi_v7_defconfig) failed like this:
> 
> 
> drivers/clocksource/versatile.c: In function 'versatile_sched_clock_init':
> drivers/clocksource/versatile.c:37:2: error: implicit declaration of function 'setup_sched_clock' [-Werror=implicit-function-declaration]
> 
> Caused by commit c04ae71c9c26 ("sched_clock: Remove deprecated
> setup_sched_clock() API") from the tip tree.  The usage was only added
> to Linus' tree today by commit 220e2a8d22cd ("clocksource: Sched clock
> source for Versatile Express") (but this commit has been in linux-next
> since May 22 at least).
> 
> I have reverted the tip tree commit for today.

Dammit. Why the heck can ARM folks not route their stuff through the
relevant maintainers? Because ARM is a different universe with
different rules or what?

Of course this crap is already in Linus next branch, so it essentially
blocks me from sending my pending timers/core branch.

Patch below. Linus, can you please apply this?

I've ranted about this before. It's not the first time that ARM breaks
stuff I maintain.

Again: Send your stuff against drivers/clocksource and drivers/irqchip
to the maintainers. 

I'm happy to provide you a separate branch to pull that stuff from me,
if you have dependencies on that, but I really don't want to see any
of this again, ever.

Yours seriously grumpy

      tglx

------------>
Subject: clocksource: versatile: Use sched_clock_register()
From: Thomas Gleixner <tglx@linutronix.de>
Date: Wed, 04 Jun 2014 12:34:15 +0200

The newly merged versatile sched clock support uses a deprecated
interface. Of course that patch got routed through the ARM tree
instead of going through the relevant maintainer tree.

Use the proper interface so we can get rid of the cruft.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
diff --git a/drivers/clocksource/versatile.c b/drivers/clocksource/versatile.c
index e4c50ad..2798e74 100644
--- a/drivers/clocksource/versatile.c
+++ b/drivers/clocksource/versatile.c
@@ -20,7 +20,7 @@
 
 static void __iomem *versatile_sys_24mhz;
 
-static u32 notrace versatile_sys_24mhz_read(void)
+static u64 notrace versatile_sys_24mhz_read(void)
 {
 	return readl(versatile_sys_24mhz);
 }
@@ -34,7 +34,7 @@ static void __init versatile_sched_clock_init(struct device_node *node)
 
 	versatile_sys_24mhz = base + SYS_24MHZ;
 
-	setup_sched_clock(versatile_sys_24mhz_read, 32, 24000000);
+	sched_clock_register(versatile_sys_24mhz_read, 32, 24000000);
 }
 CLOCKSOURCE_OF_DECLARE(versatile, "arm,vexpress-sysreg",
-		versatile_sched_clock_init);
+		       versatile_sched_clock_init);
