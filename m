Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753343AbaDDQy6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 12:54:58 -0400
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:39701 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752060AbaDDQy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 12:54:57 -0400
Date: Fri, 4 Apr 2014 18:54:47 +0200
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: "Theodore Ts'o" <tytso@mit.edu>, "Luck, Tony" <tony.luck@intel.com>,
        Andi Kleen <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <ak@linux.intel.com>, tglx@linutronix.de,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Felipe Balbi <balbi@ti.com>,
        shawn.guo@linaro.org
Subject: Re: [PATCH 01/11] random: don't feed stack data into pool when
 interrupt regs NULL
Message-ID: <20140404165447.GA28040@breakpoint.cc>
References: <1380572952-30729-1-git-send-email-andi@firstfloor.org>
 <1380572952-30729-2-git-send-email-andi@firstfloor.org>
 <3908561D78D1C84285E8C5FCA982C28F31D1F249@ORSMSX106.amr.corp.intel.com>
 <20131001124424.GA2097@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131001124424.GA2097@thunk.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-10-01 08:44:24 [-0400], Theodore Ts'o wrote:
> The changes queued for the next merge window in the random tree solve
> this problem slightly differently:
> 
> 	...
> 	input[0] = cycles ^ j_high ^ irq;
> 	input[1] = now ^ c_high;
> 	ip = regs ? instruction_pointer(regs) : _RET_IP_;
> 	input[2] = ip;
> 	input[3] = ip >> 32;
> 
> 	fast_mix(fast_pool, input);
> 	...
> 
> (Note the lack of nbytes parameter in fast_mix --- there are some
> optimizations so that we mix in the changes by 32-bit words, instead
> of bytes, and the number of 32-bit words is fixed to 4, since it's the
> only way fast_mix is called).
> 
> _RET_IP_ isn't that much better than 0, but it's at least kernel
> specific, and I figured it was better to shut up bogus warnings, as
> opposed to trying to depend on stack garbage (which would likely be
> kernel specific anyway).

That ip pointer was earlier optional. Now with _RET_IP_ it is a
constant since there is _one_ caller. Plus on 32bit the upper bits are
always zero. It probably didn't get worse because the four bytes on
stack were mostlikly constant as well. [2] is constant if _RET_IP_ is
used. The IP is kind of random. The lower bits are mostlikely 0 due to
32bit alignment (not on x86, okay).
Lets look further. c_high is != 0 only if cycles is larger than 4 bytes.
This is in most cases a long which makes 4 bytes on all 32bit arches.
This makes [1] the lower bytes of jiffies. And you can imagine how often
the upper 16bit change.
Which brings me to [0]. The irq number changes now and then and mostlikely
only the lower 8 bit. j_high is 0 on 32bit platforms. Even on 64bit
with HZ=250 the lower 32bit overflows every ~198 days unless I miscalculated.
Doesn't this make it a constant?
And finally cycles which is random_get_entropy(). On ARM (as previously on
MIPS) this returns 0. Well not always but for all platforms which do not
implement register_current_timer_delay() which makes a lot of them.
This makes
[0] = irq (8 bit)
[1] = jiffies
[2] = a constant unless regs is available and
[3] = 0 

from looking at the code it reads like 16 random bytes are fed but now it
looks a little different.

May I kill this and save a few cycles in irq context?
Why don't you take a small amount of randomness and use that as a key and
feed into a block cipher in CTR mode instead of giving it to user right
away? This _can_ work in parallell and should provide *good* pseudo random
numbers on demand with a high performance.

But seriously. What about this:

>From 082dab5c482728a9ef695aa5b42217dcec8e3dd5 Mon Sep 17 00:00:00 2001
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Date: Fri, 4 Apr 2014 18:49:29 +0200
Subject: [PATCH] random: yell if random_get_entropy() returns a constant

A few architectures still return 0 (i.e. a constant) if
random_get_entropy() is invoked. Make them aware of this so they may fix
this.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/char/random.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 429b75b..48775f8 100644
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
@@ -1675,3 +1676,23 @@ randomize_range(unsigned long start, unsigned long end, unsigned long len)
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
+
+	if (cyc1 != cyc2)
+		return 0;
+	pr_err("Error: random_get_entropy() does not return anything random\n");
+	WARN_ON(1);
+	return -EINVAL;
+}
+late_initcall(check_random_get_entropy);
-- 
1.9.1


> Cheers,
> 						- Ted

Sebastian
