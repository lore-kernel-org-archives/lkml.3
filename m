Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967476Ab3E3Fcn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 01:32:43 -0400
Received: from guitar.tcltek.co.il ([192.115.133.116]:36355 "EHLO
	sivan.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751465Ab3E3Fci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 01:32:38 -0400
Date: Thu, 30 May 2013 08:32:33 +0300
From: Baruch Siach <baruch@tkos.co.il>
To: John Stultz <john.stultz@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Jamie Iles <jamie@jamieiles.com>,
        Dinh Nguyen <dinguyen@altera.com>
Subject: Re: [RFC PATCH 2/2] clocksource: dw_apb: allow build for
 architectures other than arm
Message-ID: <20130530053233.GL25186@sapphire.tkos.co.il>
References: <1369570367-994-2-git-send-email-baruch@tkos.co.il>
 <51A51271.2070506@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51A51271.2070506@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi John,

On Tue, May 28, 2013 at 01:24:17PM -0700, John Stultz wrote:
> On 05/26/2013 05:12 AM, Baruch Siach wrote:
> >ARM is the only architecture providing sched_clock.h and setup_sched_clock().
> >Implement sched_clock() for use by other architectures.
> >
> >Cc: Ingo Molnar <mingo@redhat.com>
> >Cc: Peter Zijlstra <peterz@infradead.org>
> >Cc: John Stultz <john.stultz@linaro.org>
> >Cc: Thomas Gleixner <tglx@linutronix.de>
> >Cc: Jamie Iles <jamie@jamieiles.com>
> >Cc: Dinh Nguyen <dinguyen@altera.com>
> >Signed-off-by: Baruch Siach <baruch@tkos.co.il>
> >---

[snip]

> >@@ -73,6 +77,9 @@ static void add_clocksource(struct device_node 
> >  *source_timer)
> >  }
> >  static void __iomem *sched_io_base;
> >+#ifndef CONFIG_HAVE_SETUP_SCHED_CLOCK
> >+static u64 sched_clock_mult __read_mostly;
> >+#endif
> >  static u32 read_sched_clock(void)
> >  {
> >@@ -97,7 +104,11 @@ static void init_sched_clock(void)
> >  	timer_get_base_and_rate(sched_timer, &sched_io_base, &rate);
> >  	of_node_put(sched_timer);
> >+#ifdef CONFIG_HAVE_SETUP_SCHED_CLOCK
> >  	setup_sched_clock(read_sched_clock, 32, rate);
> >+#else
> >+	sched_clock_mult = NSEC_PER_SEC / rate;
> >+#endif
> >  }
> 
> Can you rework this to not use #ifdefs within the function? They
> make it annoying to read the code.
> 
> Instead maybe have a local setup_sched_clock() function that sets
> the mult value for the !CONFIG_HAVE_SETUP_SCHED_CLOCK case?
> 
> >  static const struct of_device_id osctimer_ids[] __initconst = {
> >@@ -124,3 +135,10 @@ void __init dw_apb_timer_init(void)
> >  	init_sched_clock();
> >  }
> >+
> >+#ifndef CONFIG_HAVE_SETUP_SCHED_CLOCK
> >+unsigned long long notrace sched_clock()
> >+{
> >+	return read_sched_clock() * sched_clock_mult;
> >+}
> >+#endif
> 
> Also, can you try to condense the number of #ifndef
> CONFIG_HAVE_SETUP_SCHED_CLOCK checks to one, and consolidate the
> needed functions all in that one conditional?

Thanks for your comments. I'll rework the patch and resubmit.

I've just noticed that I have a bigger problem. read_sched_clock() returns 
u32, not u64. This means that in a rate of, say, 100MHz it will wrap around 
after a little more than 40 seconds. Would it make sense to put ARM's 32 bin 
sched_clock extension code (arch/arm/kernel/sched_clock.c) is a common place 
(maybe drivers/clocksource), and use that? There seems to be nothing ARM 
specific in this code, after all.

baruch

-- 
     http://baruch.siach.name/blog/                  ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -
