Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755734AbaLHPyQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 10:54:16 -0500
Received: from cpsmtpb-ews01.kpnxchange.com ([213.75.39.4]:55033 "EHLO
	cpsmtpb-ews01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752038AbaLHPyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 10:54:14 -0500
Message-ID: <1418054051.2058.8.camel@x220>
Subject: Re: [PATCH] misc: ioc4: simplify wave period measurement in
 clock_calibrate
From: Paul Bolle <pebolle@tiscali.nl>
To: Richard Leitner <dev@g0hl1n.net>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Prabhakar Lad <prabhakar.csengg@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 08 Dec 2014 16:54:11 +0100
In-Reply-To: <20141208162810.7b009382@frodo>
References: <20141208132720.16356743@frodo> <4066664.BgJJnCmQ3h@wuerfel>
	 <20141208141837.752a9968@frodo>
	 <CA+V-a8tww3bt7rhMT8Bxn0dwyg4qQTeVKbAKKJxh__zXrKrewA@mail.gmail.com>
	 <20141208162810.7b009382@frodo>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 08 Dec 2014 15:54:11.0780 (UTC) FILETIME=[3587D840:01D012FF]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-12-08 at 16:28 +0100, Richard Leitner wrote:
> The loop for measuring the square wave periods over some cycles is
> refactored to be more easily readable. This includes avoiding a
> "by-hand-implemented" for loop with a "real" one and adding some
> comments.
> 
> Furthermore the following compiler warning is avoided by this patch:
> drivers/misc/ioc4.c: In function ‘ioc4_probe’:
> drivers/misc/ioc4.c:194:16: warning: ‘start’ may be used uninitialized
> in this function [-Wmaybe-uninitialized]
>   period = (end - start) /
>                 ^
> drivers/misc/ioc4.c:148:11: note: ‘start’ was declared here
>   uint64_t start, end, period;
>            ^
> 
> Signed-off-by: Richard Leitner <dev@g0hl1n.net>
> ---
> A simplification of this loop was suggested by Andrew Morton [1].
> This is my first proposal of such a simplification.
> 
> Furthermore I'm not sure if the commit message is sufficient.
> Please give me also some feedback on it.
> 
> If this simplification is not needed only initializing start to
> ktime_get_ns() would fix the compiler warning too.
> 
> [1] https://lkml.org/lkml/2014/12/5/76
> ---
>  drivers/misc/ioc4.c | 31 ++++++++++++++++---------------
>  1 file changed, 16 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/misc/ioc4.c b/drivers/misc/ioc4.c
> index 3336ddc..8758d03 100644
> --- a/drivers/misc/ioc4.c
> +++ b/drivers/misc/ioc4.c
> @@ -144,9 +144,9 @@ ioc4_clock_calibrate(struct ioc4_driver_data *idd)
>  {
>  	union ioc4_int_out int_out;
>  	union ioc4_gpcr gpcr;
> -	unsigned int state, last_state = 1;
> +	unsigned int state, last_state;
>  	uint64_t start, end, period;
> -	unsigned int count = 0;
> +	unsigned int count;
>  
>  	/* Enable output */
>  	gpcr.raw = 0;
> @@ -167,19 +167,20 @@ ioc4_clock_calibrate(struct ioc4_driver_data *idd)
>  	mmiowb();
>  
>  	/* Check square wave period averaged over some number of cycles */
> -	do {
> -		int_out.raw = readl(&idd->idd_misc_regs->int_out.raw);
> -		state = int_out.fields.int_out;
> -		if (!last_state && state) {
> -			count++;
> -			if (count == IOC4_CALIBRATE_END) {
> -				end = ktime_get_ns();
> -				break;
> -			} else if (count == IOC4_CALIBRATE_DISCARD)
> -				start = ktime_get_ns();
> -		}
> -		last_state = state;
> -	} while (1);
> +	start = ktime_get_ns();
> +	state = 1; /* make sure the first read isn't a rising edge */
> +	for (count = 0; count <= IOC4_CALIBRATE_END; count++) {
> +		do { /* wait for a rising edge */
> +			last_state = state;
> +			int_out.raw = readl(&idd->idd_misc_regs->int_out.raw);
> +			state = int_out.fields.int_out;
> +		} while (last_state || !state);
> +
> +		/* discard the first few cycles */
> +		if (count == IOC4_CALIBRATE_DISCARD)
> +			start = ktime_get_ns();
> +	}
> +	end = ktime_get_ns();
>  
>  	/* Calculation rearranged to preserve intermediate precision.
>  	 * Logically:

I've had the patch pasted at the end of this message in my local stack
of patches for some time now. It uses another approach: by using a
helper function things become much simpler. I _think_ it doesn't
introduce any functional changes but still need to a quiet day to make
sure that is correct.

Hope this helps,


Paul Bolle
---
>From 6fd7078b622323a2d9b72c9fffad347a1321204d Mon Sep 17 00:00:00 2001
From: Paul Bolle <pebolle@tiscali.nl>
Date: Tue, 19 Aug 2014 09:11:40 +0200
Subject: [PATCH] ioc4: silence GCC warning
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Building ioc4.o triggers a GCC warning since v3.17-rc1:
    drivers/misc/ioc4.c: In function ‘ioc4_probe’:
    drivers/misc/ioc4.c:194:16: warning: ‘start’ may be used uninitialized in this function [-Wmaybe-uninitialized]
      period = (end - start) /
                    ^
    drivers/misc/ioc4.c:148:11: note: ‘start’ was declared here
      uint64_t start, end, period;
               ^

This is a false positive. Apparently the recent change to use
ktime_get_ns() makes it harder for GCC to analyze the codeflow.

Adding a small (inline) function that only returns after a certain
number of wave cycles have been seen allows to reorder the code a bit.
And after reordering it is clearer for both the compiler and the human
reader what's going on here. So let's do that.

Not-yet-signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
 drivers/misc/ioc4.c | 39 +++++++++++++++++++++------------------
 1 file changed, 21 insertions(+), 18 deletions(-)

diff --git a/drivers/misc/ioc4.c b/drivers/misc/ioc4.c
index 3336ddca45ac..e8209fa78713 100644
--- a/drivers/misc/ioc4.c
+++ b/drivers/misc/ioc4.c
@@ -122,11 +122,25 @@ ioc4_unregister_submodule(struct ioc4_submodule *is)
 #define IOC4_CALIBRATE_DEFAULT \
 	(1000*IOC4_EXTINT_COUNT_DIVISOR/IOC4_CALIBRATE_DEFAULT_MHZ)
 
-#define IOC4_CALIBRATE_END \
-	(IOC4_CALIBRATE_CYCLES + IOC4_CALIBRATE_DISCARD)
-
 #define IOC4_INT_OUT_MODE_TOGGLE 0x7	/* Toggle INT_OUT every COUNT+1 ticks */
 
+/* return after count wave cycles have been seen */
+static inline void
+ioc4_clock_wave_cycles(struct ioc4_driver_data *idd, unsigned int count)
+{
+	union ioc4_int_out int_out;
+	unsigned int state, last_state = 1;
+	unsigned int i = 0;
+
+	do {
+		int_out.raw = readl(&idd->idd_misc_regs->int_out.raw);
+		state = int_out.fields.int_out;
+		if (!last_state && state)
+			i++;
+		last_state = state;
+	} while (i < count);
+}
+
 /* Determines external interrupt output clock period of the PCI bus an
  * IOC4 is attached to.  This value can be used to determine the PCI
  * bus speed.
@@ -144,9 +158,7 @@ ioc4_clock_calibrate(struct ioc4_driver_data *idd)
 {
 	union ioc4_int_out int_out;
 	union ioc4_gpcr gpcr;
-	unsigned int state, last_state = 1;
 	uint64_t start, end, period;
-	unsigned int count = 0;
 
 	/* Enable output */
 	gpcr.raw = 0;
@@ -167,19 +179,10 @@ ioc4_clock_calibrate(struct ioc4_driver_data *idd)
 	mmiowb();
 
 	/* Check square wave period averaged over some number of cycles */
-	do {
-		int_out.raw = readl(&idd->idd_misc_regs->int_out.raw);
-		state = int_out.fields.int_out;
-		if (!last_state && state) {
-			count++;
-			if (count == IOC4_CALIBRATE_END) {
-				end = ktime_get_ns();
-				break;
-			} else if (count == IOC4_CALIBRATE_DISCARD)
-				start = ktime_get_ns();
-		}
-		last_state = state;
-	} while (1);
+	ioc4_clock_wave_cycles(idd, IOC4_CALIBRATE_DISCARD);
+	start = ktime_get_ns();
+	ioc4_clock_wave_cycles(idd, IOC4_CALIBRATE_COUNT);
+	end = ktime_get_ns();
 
 	/* Calculation rearranged to preserve intermediate precision.
 	 * Logically:
-- 
1.9.3


