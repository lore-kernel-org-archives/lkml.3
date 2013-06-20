Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757903Ab3FTPDe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 11:03:34 -0400
Received: from guitar.tcltek.co.il ([192.115.133.116]:44950 "EHLO
	sivan.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757693Ab3FTPDc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 11:03:32 -0400
Date: Thu, 20 Jun 2013 18:03:21 +0300
From: Baruch Siach <baruch@tkos.co.il>
To: Pavel Machek <pavel@denx.de>
Cc: John Stultz <john.stultz@linaro.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Jamie Iles <jamie@jamieiles.com>,
        Dinh Nguyen <dinguyen@altera.com>
Subject: Re: [RFC PATCH 2/2] clocksource: dw_apb: allow build for
 architectures other than arm
Message-ID: <20130620150321.GH10269@tarshish>
References: <1369570367-994-2-git-send-email-baruch@tkos.co.il>
 <51A51271.2070506@linaro.org>
 <20130530053233.GL25186@sapphire.tkos.co.il>
 <20130620144432.GA22115@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130620144432.GA22115@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel,

On Thu, Jun 20, 2013 at 04:44:33PM +0200, Pavel Machek wrote:
> > > >@@ -73,6 +77,9 @@ static void add_clocksource(struct device_node 
> > > >  *source_timer)
> > > >  }
> > > >  static void __iomem *sched_io_base;
> > > >+#ifndef CONFIG_HAVE_SETUP_SCHED_CLOCK
> > > >+static u64 sched_clock_mult __read_mostly;
> > > >+#endif
> > > >  static u32 read_sched_clock(void)
> > > >  {
> > > >@@ -97,7 +104,11 @@ static void init_sched_clock(void)
> > > >  	timer_get_base_and_rate(sched_timer, &sched_io_base, &rate);
> > > >  	of_node_put(sched_timer);
> > > >+#ifdef CONFIG_HAVE_SETUP_SCHED_CLOCK
> > > >  	setup_sched_clock(read_sched_clock, 32, rate);
> > > >+#else
> > > >+	sched_clock_mult = NSEC_PER_SEC / rate;
> > > >+#endif
> > > >  }
> > > 
> > > Can you rework this to not use #ifdefs within the function? They
> > > make it annoying to read the code.
> > > 
> > > Instead maybe have a local setup_sched_clock() function that sets
> > > the mult value for the !CONFIG_HAVE_SETUP_SCHED_CLOCK case?
> > > 
> > > >  static const struct of_device_id osctimer_ids[] __initconst = {
> > > >@@ -124,3 +135,10 @@ void __init dw_apb_timer_init(void)
> > > >  	init_sched_clock();
> > > >  }
> > > >+
> > > >+#ifndef CONFIG_HAVE_SETUP_SCHED_CLOCK
> > > >+unsigned long long notrace sched_clock()
> > > >+{
> > > >+	return read_sched_clock() * sched_clock_mult;
> > > >+}
> > > >+#endif
> > > 
> > > Also, can you try to condense the number of #ifndef
> > > CONFIG_HAVE_SETUP_SCHED_CLOCK checks to one, and consolidate the
> > > needed functions all in that one conditional?
> > 
> > Thanks for your comments. I'll rework the patch and resubmit.
> > 
> > I've just noticed that I have a bigger problem. read_sched_clock() returns 
> > u32, not u64. This means that in a rate of, say, 100MHz it will wrap around 
> > after a little more than 40 seconds. Would it make sense to put ARM's 32 bin 
> > sched_clock extension code (arch/arm/kernel/sched_clock.c) is a common place 
> > (maybe drivers/clocksource), and use that? There seems to be nothing ARM 
> > specific in this code, after all.
> 
> Also note that there are two conflicting changes to this area
> pending. It seems one in soc-next arm tree will prevail.
> 
> Please take a look...

Now that generic sched_clock implementation is available to all architectures 
(38ff87f77 "sched_clock: Make ARM's sched_clock generic for all architectures" 
in the timers/core branch of the tip tree) this patch is not needed anymore.

Thanks for the head up.

baruch

-- 
     http://baruch.siach.name/blog/                  ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -
