Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751827Ab3EJMi1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 08:38:27 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:43223 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216Ab3EJMi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 08:38:26 -0400
Date: Fri, 10 May 2013 14:38:23 +0200
From: Pavel Machek <pavel@denx.de>
To: John Stultz <john.stultz@linaro.org>
Cc: Arnd Bergmann <arnd@arndb.de>, tglx@linutronix.de,
        Jamie Iles <jamie@jamieiles.com>, dinguyen@altera.com, wd@denx.de,
        linux-arm-kernel@lists.infradead.org, olof@lixom.net,
        kernel list <linux-kernel@vger.kernel.org>, jacob.jun.pan@intel.com
Subject: Re: dw_apb_timer_of.c: remove parts that were picoxcell-specific
Message-ID: <20130510123823.GA6451@amd.pavel.ucw.cz>
References: <20130426121433.GA16249@amd.pavel.ucw.cz>
 <201305061545.22587.arnd@arndb.de>
 <20130506155304.GA6645@amd.pavel.ucw.cz>
 <201305062324.17080.arnd@arndb.de>
 <20130507135752.GA3500@amd.pavel.ucw.cz>
 <51892E5E.8090909@linaro.org>
 <20130507201126.GA8169@amd.pavel.ucw.cz>
 <51899CBC.6020003@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51899CBC.6020003@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2013-05-07 17:30:52, John Stultz wrote:
> On 05/07/2013 01:11 PM, Pavel Machek wrote:
> >It seems we made a mistake when creating dw_apb_timer_of.c:
> >picoxcell sched_clock had parts that were not related to
> >dw_apb_timer, yet we moved them to dw_apb_timer_of, and tried to
> >use them on socfpga.
> >
> >This results in system where user/system time is not measured
> >properly, as demonstrated by
> >     time dd if=/dev/urandom of=/dev/zero bs=100000 count=100
> >So this patch switches sched_clock to hardware that exists on both
> >platforms, and adds missing of_node_put() in dw_apb_timer_init().
> >Signed-off-by: Pavel Machek <pavel@denx.de>
> >Acked-by: Jamie Iles <jamie@jamieiles.com>
> 
> Ok. I'm still not a happy about the general issue of
> sched_clock/clockevent code being in drivers/clocksources (I know,
> everyone is sick of my griping about it :), so reviewing this sucks,
> but at least this patch technically isn't making that issue worse.

Is there anything concrete you'd like to improve?

Yes, clocksource/clockevent split is confusing, doubly so because it
is same hardware driving both. Would it make sense to create "use this
clocksource for sched_clock()" helper?

> Additionally, this is an *ugly* driver in my opinion. Its split
> between arch specific logic in arch/x86/kernel/apb_timer.c,
> arch/arm/mach-picoxcell/common.c, and
> arch/arm/mach-socfpga/socfpga.c, and 

Can you elaborate? There's very little logic in socfpga.c, just single
line

        .timer          = &dw_apb_timer,

> then arch independent logic in
> drivers/clocksource/dw_apb_timer.c and
> drivers/clocksource/dw_apb_timer_of.c, but then it seems like much
> of drivers/clocksource/dw_apb_timer_of.c is actually ARM specific.

dw_apb_timer_of.c ... it should not be arm specific. Yes, it was
originally separated from picoxcell code, and so far only picoxcell &
socfpga use it, but it should work on other architectures, too..

> Are there any plans to clean this up in the future?

I can try, but I'd need a bit better idea what needs to be done. Would
"use this clocksource for sched_clock()" helper be acceptable?

> But I've gone ahead and queued this for 3.11.

Thanks!
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
