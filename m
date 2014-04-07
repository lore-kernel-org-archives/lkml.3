Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755786AbaDGTbO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 15:31:14 -0400
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:46792 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755322AbaDGTbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 15:31:12 -0400
Date: Mon, 7 Apr 2014 21:30:57 +0200
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: "Luck, Tony" <tony.luck@intel.com>, Andi Kleen <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <ak@linux.intel.com>, tglx@linutronix.de,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Felipe Balbi <balbi@ti.com>,
        shawn.guo@linaro.org, grant.likely@linaro.org,
        Richard Kuo <rkuo@codeaurora.org>, Mikael Starvik <starvik@axis.com>,
        David Howells <dhowells@redhat.com>,
        Hirokazu Takata <takata@linux-m32r.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH 01/11] random: don't feed stack data into pool when
 interrupt regs NULL
Message-ID: <20140407193057.GA16588@breakpoint.cc>
References: <1380572952-30729-1-git-send-email-andi@firstfloor.org>
 <1380572952-30729-2-git-send-email-andi@firstfloor.org>
 <3908561D78D1C84285E8C5FCA982C28F31D1F249@ORSMSX106.amr.corp.intel.com>
 <20131001124424.GA2097@thunk.org>
 <20140404165447.GA28040@breakpoint.cc>
 <20140407040137.GA29755@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140407040137.GA29755@thunk.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-04-07 00:01:37 [-0400], Theodore Ts'o wrote:
> Yes, ARM sucks for not implement random_get_entropy() on all
> platforms.  Film at 11.  I'm told that Cortex ARM systms are supposed
> to have a cycle counter.  I'm not sure why it hasn't been wired up,
> but it really should be.

I see.

> Actually regs should be available nearly all of the time.  So the
> situation isn't quite as dire as you describe, but agreed, it is
> pretty bad.

You dropped that part where I suggested to use something like AES+CTR
and create the numbers on demand and dropping that attempt to create as
much random data with custom functions as possible. You completly dislike
that approach? And if so, why?

> Still, it would be nice if random_get_entropy() could be wired up on
> as many platforms as possible.  

Yes. Usually there is generic function doing something sane but not as
good as it could do with arch specific code. Or the code is completly
disabled unless the architecture wires it up. Dropping a new function and
hoping everyone will wire it up in no time is, ehm, brave. Nobody implemented
random_get_entropy(), everyone falls back to get_cycles. From a quick
grep I can see that atleast Hexagon, Cris, Frv, m32r and m68k return 0. I 
put some of the maintainers Cc, I am curious if they know about the side
effects.

> This is lacking in subtly, and while I'm sympathetic with your
> frustration, and unfortunately, there are a huge number of CPU's/SOC's
> that don't implement a cycle counter or some other kind of cheap, high
> resolution counter.  I'm not against putting in a warning printk, but

Cheap? I know there a few platforms running on a 16bit counter. It is
enough for a high resolution timer, it overflows quite often, too (i.e.
in less than two seconds). However it is the only thing as time base that
they have and from clocksource point of view it is enough.

> issuing a WARN_ON(1) would be really be too obnoxious.  Maybe
> something like, "you're running on a crap CPU architecture and so
> /dev/random may very well be insecure", but I think that's about as
> blunt as we can really afford to be at this point.

A backtrace is something you catch during boot up. A single line may get
lost in the mass and I think this is important.
However, as you wish, here are the changes.

> 
> 	     	    	   	     - Ted
> 
> P.S.  Maybe if Intel started a marketing campaign on G+ explaining why
> ChromeOS on Intel machines is much more secure than ChromeOS on ARM,
> we could finally get some action out of the !@#!?! ARM chip
> manufacturers.  :-/

Maybe post people are not aware what is going on here. A huge campaing
with ballons is one way to get attention. Just drop /dev/random if the
missing infrastucture isn't available and it shouldn't need G+ to get
the infrastrucure. And the CTR thingy might be a good one because it
would require *one* thing to get done and not each arch/subarch.

>From 1d2d3ef3c411af7fc6b1beb0db7a2c35c1a72702 Mon Sep 17 00:00:00 2001
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Date: Fri, 4 Apr 2014 18:49:29 +0200
Subject: [PATCH] random: yell if random_get_entropy() returns a constant

A few architectures still return 0 (i.e. a constant) if
random_get_entropy() is invoked. Make them aware of this so they may fix
this.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/char/random.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 429b75b..33508f9 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -241,6 +241,7 @@
 #include <linux/major.h>
 #include <linux/string.h>
 #include <linux/fcntl.h>
+#include <linux/delay.h>
 #include <linux/slab.h>
 #include <linux/random.h>
 #include <linux/poll.h>
@@ -1675,3 +1676,22 @@ randomize_range(unsigned long start, unsigned long end, unsigned long len)
 		return 0;
 	return PAGE_ALIGN(get_random_int() % range + start);
 }
+
+static int check_random_get_entropy(void)
+{
+	cycles_t cyc1;
+	cycles_t cyc2;
+
+	cyc1 = random_get_entropy();
+	cyc2 = random_get_entropy();
+	if (cyc1 != cyc2)
+		return 0;
+	udelay(1);
+	cyc2 = random_get_entropy();
+	if (cyc1 != cyc2)
+		return 0;
+
+	pr_err("Error: you're running on a crap CPU architecture and so /dev/random may very well be insecure");
+	return -EINVAL;
+}
+late_initcall(check_random_get_entropy);
-- 
1.9.1

