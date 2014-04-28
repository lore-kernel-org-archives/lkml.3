Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757134AbaD1VTy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 17:19:54 -0400
Received: from mailrelay001.isp.belgacom.be ([195.238.6.51]:42709 "EHLO
	mailrelay001.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756990AbaD1VTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 17:19:53 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqQOAODEXlNXQw00/2dsb2JhbABZgwasEgEBAQWZcgICgRoXdIIlAQEEAScTHBoJBQsIAw4KLjkeBhOIOQwByF8XhVqIKFcHhDkBA458ig8BinOHa4MzO4Et
Date: Mon, 28 Apr 2014 23:21:55 +0200
From: Fabian Frederick <fabf@skynet.be>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
        Anton Vorontsov <anton.vorontsov@linaro.org>
Subject: Re: [PATCH 1/1] MM: make vmpressure_win dynamic
Message-Id: <20140428232155.6fe2d38272dff9dd00949e25@skynet.be>
In-Reply-To: <20140428141025.e8f7604535b4d840a6eeacea@linux-foundation.org>
References: <20140428222521.29a711c33e720ff5e2c00e2d@skynet.be>
	<20140428141025.e8f7604535b4d840a6eeacea@linux-foundation.org>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Apr 2014 14:10:25 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Mon, 28 Apr 2014 22:25:21 +0200 Fabian Frederick <fabf@skynet.be> wrote:
> 
> > Initialize vmpressure_win in vmstat using
> > calculate_normal_threshold() based on each zone/cpu * SWAP_CLUSTER_SIZE
> > 
> > Value refreshed through cpu notifier
> 
> Anton wrote vmpressure so please let's cc him.  `git blame' is useful
> for working out who to cc.
> 
> What were the reasons for this change?  Any testing results?
This patch was mainly addressing the TODO above const definition
("Make the window size depend on machine size" ...)
I can do another version removing the mutex stuff and expose to /sys ...

> 
> > --- a/mm/vmstat.c
> > +++ b/mm/vmstat.c
> > @@ -23,6 +23,23 @@
> >  
> >  #include "internal.h"
> >  
> > +/*
> > + * The window size (vmpressure_win) is the number of scanned pages before
> > + * we try to analyze scanned/reclaimed ratio. So the window is used as a
> > + * rate-limit tunable for the "low" level notification, and also for
> > + * averaging the ratio for medium/critical levels. Using small window
> > + * sizes can cause lot of false positives, but too big window size will
> > + * delay the notifications.
> > + *
> > + * As the vmscan reclaimer logic works with chunks which are multiple of
> > + * SWAP_CLUSTER_MAX, it makes sense to use it for the window size as well.
> > + *
> > + */
> > +#ifdef CONFIG_MEMCG
> > +static DEFINE_SPINLOCK(vmpressure_win_lock);
> > +unsigned long vmpressure_win __read_mostly = SWAP_CLUSTER_MAX * 16;
> > +#endif
> > +
> >  #ifdef CONFIG_VM_EVENT_COUNTERS
> >  DEFINE_PER_CPU(struct vm_event_state, vm_event_states) = {{0}};
> >  EXPORT_PER_CPU_SYMBOL(vm_event_states);
> > @@ -163,11 +180,13 @@ void refresh_zone_stat_thresholds(void)
> >  	struct zone *zone;
> >  	int cpu;
> >  	int threshold;
> > +	unsigned long new_vmpressure_win = 0;
> >  
> >  	for_each_populated_zone(zone) {
> >  		unsigned long max_drift, tolerate_drift;
> >  
> >  		threshold = calculate_normal_threshold(zone);
> > +		new_vmpressure_win += threshold;
> >  
> >  		for_each_online_cpu(cpu)
> >  			per_cpu_ptr(zone->pageset, cpu)->stat_threshold
> > @@ -184,6 +203,11 @@ void refresh_zone_stat_thresholds(void)
> >  			zone->percpu_drift_mark = high_wmark_pages(zone) +
> >  					max_drift;
> >  	}
> > +#ifdef CONFIG_MEMCG
> > +	spin_lock(&vmpressure_win_lock);
> > +	vmpressure_win = new_vmpressure_win * SWAP_CLUSTER_MAX;
> > +	spin_unlock(&vmpressure_win_lock);
> > +#endif
> >  }
> 
> I don't think we need the spinlock really.  It's a ulong - concurrent
> readers will see either the old value or the new one whether or not the
> writer took that lock.
> 
> If we're going to modify this thing on the fly then we probably should
> expose the current value to userspace in some fashion.
> 
