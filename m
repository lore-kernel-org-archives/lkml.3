Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753840AbbAUPLi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 10:11:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54016 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750960AbbAUPLb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 10:11:31 -0500
Date: Wed, 21 Jan 2015 10:10:51 -0500
From: Don Zickus <dzickus@redhat.com>
To: Zhang Zhen <zhenzhang.zhang@huawei.com>
Cc: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        morgan.wang@huawei.com, josh@freedesktop.org, dipankar@in.ibm.com
Subject: Re: RCU CPU stall console spews  leads to soft lockup disabled is
 reasonable ?
Message-ID: <20150121151051.GE116159@redhat.com>
References: <54BCBB33.6060608@huawei.com>
 <20150119084200.GE9719@linux.vnet.ibm.com>
 <54BCC89D.9040702@huawei.com>
 <20150119140612.GI116159@redhat.com>
 <54BDC6DF.6000602@huawei.com>
 <20150120152531.GR116159@redhat.com>
 <54BF0E53.5040409@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54BF0E53.5040409@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2015 at 10:26:27AM +0800, Zhang Zhen wrote:
> > This may not cause other problems but what happens if you comment out the
> > 'touch_softlockup_watchdog' from the touch_nmi_watchdog function like
> > below (based on latest upstream cb59670870)?
> > 
> > The idea is that console printing for that cpu won't reset the softlockup
> > detector.  Again other bad things might happen and this patch may not be a
> > good final solution, but it can help give me a clue about what is going
> > on.
> 
> I commented out the 'touch_softlockup_watchdog' from the touch_nmi_watchdog function
> (based on latest upstream ec6f34e5b552).
> This triggered RCU stall and softlockup, but softlockup just printk only once.

Yes, as expected.  Instead of flooding the console with the same message,
report only once until the high priority task is re-kicked and can re-arm
the softlockup timer again.  So this makes sense.  Based on your double
spin lock test, I don't ever expect this to get re-armed, so you should
not expect to see another message.


> As you mentioned "other bad things" lead to softlockup just printk only once.
> What's the bad thing ?

Well, one of the assumptions here is that if you are going to have
interrupts disabled for a long time and purposely kick the hardlockup
detector (with touch_nmi_watchdog), then you can reasonably assume that
softlockups will go off too if you don't also kick the softlockup detector
(even though there is a window where this isn't true: 2*thresh - thresh).


So the patch I gave you, can lead to false softlockup warnings.


On the flip side, printing to the console also blocks hardlockups from
showing up.  But I believe loooong ago, Paul adjusted the rcu stalls to be
longer than a hardlockup/softlockup timeout to prevent such scenarios.



I am not sure what to do here.  Printing to the console has traditionally
been slow (especially if doing so with interrupts disabled), so a
touch_nmi_watchdog has been necessary.  But a side effect of that, is it
prevents the lockup detectors from going off if printing repeatedly.


Now we can hack up rcu stall to only print once until it is re-armed.
This would show rcu stall printing first, followed two minutes later by
a softlockup, which sorta achieves what you want.



However, at the end of the day, an rcu stall, softlockup or hardlockup is
a bad thing, does it matter if you get one or all of them?  One should be
enough to start an investigation, no?



I don't know.  I am leaning towards 'working as expected' and nothing to
really fix here.  Does anyone have any suggestions on what assumptions we
could change to handle this better?


Cheers,
Don

> 
> / #
> / # echo 60 > /proc/sys/kernel/watchdog_thresh
> / # busybox insmod softlockup_test.ko &
> / # [   39.044058] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=21002 jiffies, g=78, c=77, q=4)
> [   39.044058] INFO: Stall ended before state dump start
> [  102.049045] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=84007 jiffies, g=78, c=77, q=4)
> [  102.049045] INFO: Stall ended before state dump start
> [  160.482123] BUG: soft lockup - CPU#0 stuck for 134s! [busybox:54]
> [  165.054075] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=147012 jiffies, g=78, c=77, q=4)
> [  165.054075] INFO: Stall ended before state dump start
> [  228.059045] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=210017 jiffies, g=78, c=77, q=4)
> [  228.059045] INFO: Stall ended before state dump start
> [  291.064099] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=273022 jiffies, g=78, c=77, q=4)
> [  291.064099] INFO: Stall ended before state dump start
> [  354.069074] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=336027 jiffies, g=78, c=77, q=4)
> [  354.069099] INFO: Stall ended before state dump start
> [  417.074045] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=399032 jiffies, g=78, c=77, q=4)
> [  417.074045] INFO: Stall ended before state dump start
> [  480.079099] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=462037 jiffies, g=78, c=77, q=4)
> [  480.079099] INFO: Stall ended before state dump start
> [  543.084099] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=525042 jiffies, g=78, c=77, q=4)
> [  543.084099] INFO: Stall ended before state dump start
> [  606.089101] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=588047 jiffies, g=78, c=77, q=4)
> [  606.089101] INFO: Stall ended before state dump start
> [  669.094099] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=651052 jiffies, g=78, c=77, q=4)
> [  669.094099] INFO: Stall ended before state dump start
> [  732.099045] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=714057 jiffies, g=78, c=77, q=4)
> [  732.099045] INFO: Stall ended before state dump start
> [  795.104074] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=777062 jiffies, g=78, c=77, q=4)
> [  795.104098] INFO: Stall ended before state dump start
> [  858.109046] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=840067 jiffies, g=78, c=77, q=4)
> [  858.109046] INFO: Stall ended before state dump start
> [  921.114100] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=903072 jiffies, g=78, c=77, q=4)
> [  921.114100] INFO: Stall ended before state dump start
> [  984.119099] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=966077 jiffies, g=78, c=77, q=4)
> [  984.119099] INFO: Stall ended before state dump start
> [ 1047.124075] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=1029082 jiffies, g=78, c=77, q=4)
> [ 1047.124099] INFO: Stall ended before state dump start
> [ 1110.129046] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=1092087 jiffies, g=78, c=77, q=4)
> [ 1110.129046] INFO: Stall ended before state dump start
> [ 1173.134045] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=1155092 jiffies, g=78, c=77, q=4)
> [ 1173.134045] INFO: Stall ended before state dump start
> [ 1236.139101] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=1218097 jiffies, g=78, c=77, q=4)
> [ 1236.139101] INFO: Stall ended before state dump start
> [ 1299.144059] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=1281102 jiffies, g=78, c=77, q=4)
> [ 1299.144059] INFO: Stall ended before state dump start
> [ 1362.149099] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=1344107 jiffies, g=78, c=77, q=4)
> [ 1362.149099] INFO: Stall ended before state dump start
> [ 1425.154059] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=1407112 jiffies, g=78, c=77, q=4)
> [ 1425.154059] INFO: Stall ended before state dump start
> [ 1488.159046] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=1470117 jiffies, g=78, c=77, q=4)
> [ 1488.159046] INFO: Stall ended before state dump start
> [ 1551.164045] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=1533122 jiffies, g=78, c=77, q=4)
> [ 1551.164045] INFO: Stall ended before state dump start
> [ 1614.169057] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=1596127 jiffies, g=78, c=77, q=4)
> [ 1614.169057] INFO: Stall ended before state dump start
> [ 1677.174060] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=1659132 jiffies, g=78, c=77, q=4)
> [ 1677.174060] INFO: Stall ended before state dump start
> [ 1740.179045] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=1722137 jiffies, g=78, c=77, q=4)
> [ 1740.179045] INFO: Stall ended before state dump start
> [ 1803.184075] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=1785142 jiffies, g=78, c=77, q=4)
> [ 1803.184101] INFO: Stall ended before state dump start
> [ 1866.189046] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=1848147 jiffies, g=78, c=77, q=4)
> [ 1866.189046] INFO: Stall ended before state dump start
> [ 1929.194045] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=1911152 jiffies, g=78, c=77, q=4)
> [ 1929.194045] INFO: Stall ended before state dump start
> [ 1992.199083] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=1974157 jiffies, g=78, c=77, q=4)
> [ 1992.199083] INFO: Stall ended before state dump start
> [ 2055.204098] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=2037162 jiffies, g=78, c=77, q=4)
> [ 2055.204098] INFO: Stall ended before state dump start
> [ 2118.209045] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=2100167 jiffies, g=78, c=77, q=4)
> [ 2118.209045] INFO: Stall ended before state dump start
> [ 2181.214098] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=2163172 jiffies, g=78, c=77, q=4)
> [ 2181.214098] INFO: Stall ended before state dump start
> > 
> > Cheers,
> > Don
> > 
> > diff --git a/kernel/watchdog.c b/kernel/watchdog.c
> > index 70bf118..833c015 100644
> > --- a/kernel/watchdog.c
> > +++ b/kernel/watchdog.c
> > @@ -209,7 +209,7 @@ void touch_nmi_watchdog(void)
> >  	 * going off.
> >  	 */
> >  	raw_cpu_write(watchdog_nmi_touch, true);
> > -	touch_softlockup_watchdog();
> > +	//touch_softlockup_watchdog();
> >  }
> >  EXPORT_SYMBOL(touch_nmi_watchdog);
> >  
> > 
> > .
> > 
> 
> 
