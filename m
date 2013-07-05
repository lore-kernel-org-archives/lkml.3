Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751497Ab3GEFlL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 01:41:11 -0400
Received: from www.linutronix.de ([62.245.132.108]:43156 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716Ab3GEFlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 01:41:10 -0400
Date: Fri, 5 Jul 2013 07:41:09 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Alex Shi <alex.shi@intel.com>
cc: hpa@linux.intel.com, tim.c.chen@linux.intel.com,
        linux-kernel@vger.kernel.org, andi.kleen@intel.com,
        a.p.zijlstra@chello.nl, mingo@elte.hu
Subject: Re: [PATCH 3/3] clocksource: fix can not set tsc as clocksource
 bug
In-Reply-To: <51D63413.5020809@intel.com>
Message-ID: <alpine.DEB.2.02.1307050732330.11637@ionos.tec.linutronix.de>
References: <1372916056-24301-1-git-send-email-alex.shi@intel.com> <1372916056-24301-4-git-send-email-alex.shi@intel.com> <alpine.DEB.2.02.1307041227470.11637@ionos.tec.linutronix.de> <alpine.DEB.2.02.1307041419560.11637@ionos.tec.linutronix.de>
 <51D63413.5020809@intel.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Jul 2013, Alex Shi wrote:
> On 07/04/2013 09:04 PM, Thomas Gleixner wrote:
> >>> > >  static int clocksource_watchdog_kthread(void *data)
> >>> > >  {
> >>> > >  	struct clocksource *cs, *tmp;
> >>> > > @@ -412,11 +415,14 @@ static int clocksource_watchdog_kthread(void *data)
> >>> > >  
> >>> > >  	mutex_lock(&clocksource_mutex);
> >>> > >  	spin_lock_irqsave(&watchdog_lock, flags);
> >>> > > -	list_for_each_entry_safe(cs, tmp, &watchdog_list, wd_list)
> >>> > > +	list_for_each_entry_safe(cs, tmp, &watchdog_list, wd_list) {
> >>> > >  		if (cs->flags & CLOCK_SOURCE_UNSTABLE) {
> >>> > >  			list_del_init(&cs->wd_list);
> >>> > >  			list_add(&cs->wd_list, &unstable);
> >>> > >  		}
> >>> > > +		if (cs->flags & CLOCK_SOURCE_VALID_FOR_HRES)
> >>> > > +			clocksource_select();
> >> > 
> >> > Unlikely, but if we have 3 watched clocksources which have the HRES
> >> > bit set, you'd call 3 times clocksource_select().
> > Also the reselect must be called outside the watchdog_lock region.
> 
> Sorry for stupid, the watchdog_lock used protect watchdog related
> resource. but clocksource_select doesn't touch them. So, I know it isn't
> necessary to put reselect under this lock. Just don't know why the
> reselect *must* be called outside of it?

  clocksource_select()
    timekeeping_notify()
      stop_machine()
        get_online_cpus()
	  might_sleep()
	  mutex_lock()

So we need to be in preemptible context when we call clocksource_select().

Thanks,

	tglx
