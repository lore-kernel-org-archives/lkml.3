Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933743Ab3GECuC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 22:50:02 -0400
Received: from mga14.intel.com ([143.182.124.37]:29052 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757038Ab3GECuB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 22:50:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,999,1363158000"; 
   d="scan'208";a="327001444"
Message-ID: <51D63413.5020809@intel.com>
Date: Fri, 05 Jul 2013 10:48:51 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: hpa@linux.intel.com, tim.c.chen@linux.intel.com,
        linux-kernel@vger.kernel.org, andi.kleen@intel.com,
        a.p.zijlstra@chello.nl, mingo@elte.hu
Subject: Re: [PATCH 3/3] clocksource: fix can not set tsc as clocksource bug
References: <1372916056-24301-1-git-send-email-alex.shi@intel.com> <1372916056-24301-4-git-send-email-alex.shi@intel.com> <alpine.DEB.2.02.1307041227470.11637@ionos.tec.linutronix.de> <alpine.DEB.2.02.1307041419560.11637@ionos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.02.1307041419560.11637@ionos.tec.linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/04/2013 09:04 PM, Thomas Gleixner wrote:
>>> > >  static int clocksource_watchdog_kthread(void *data)
>>> > >  {
>>> > >  	struct clocksource *cs, *tmp;
>>> > > @@ -412,11 +415,14 @@ static int clocksource_watchdog_kthread(void *data)
>>> > >  
>>> > >  	mutex_lock(&clocksource_mutex);
>>> > >  	spin_lock_irqsave(&watchdog_lock, flags);
>>> > > -	list_for_each_entry_safe(cs, tmp, &watchdog_list, wd_list)
>>> > > +	list_for_each_entry_safe(cs, tmp, &watchdog_list, wd_list) {
>>> > >  		if (cs->flags & CLOCK_SOURCE_UNSTABLE) {
>>> > >  			list_del_init(&cs->wd_list);
>>> > >  			list_add(&cs->wd_list, &unstable);
>>> > >  		}
>>> > > +		if (cs->flags & CLOCK_SOURCE_VALID_FOR_HRES)
>>> > > +			clocksource_select();
>> > 
>> > Unlikely, but if we have 3 watched clocksources which have the HRES
>> > bit set, you'd call 3 times clocksource_select().
> Also the reselect must be called outside the watchdog_lock region.

Sorry for stupid, the watchdog_lock used protect watchdog related
resource. but clocksource_select doesn't touch them. So, I know it isn't
necessary to put reselect under this lock. Just don't know why the
reselect *must* be called outside of it?

-- 
Thanks
    Alex
