Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289AbaBXRzY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 12:55:24 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:36349 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753136AbaBXRzT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 12:55:19 -0500
From: Kevin Hilman <khilman@linaro.org>
To: Mike Galbraith <bitbucket@online.de>
Cc: paulmck@linux.vnet.ibm.com, Tejun Heo <tj@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Zoran Markovic <zoran.markovic@linaro.org>,
        linux-kernel@vger.kernel.org,
        Shaibal Dutta <shaibal.dutta@broadcom.com>,
        Dipankar Sarma <dipankar@in.ibm.com>
Subject: Re: [RFC PATCH] rcu: move SRCU grace period work to power efficient workqueue
References: <1391197986-12774-1-git-send-email-zoran.markovic@linaro.org>
	<52F8A51F.4090909@cn.fujitsu.com>
	<20140210184729.GL4250@linux.vnet.ibm.com>
	<20140212182336.GD5496@localhost.localdomain>
	<20140212190241.GD4250@linux.vnet.ibm.com>
	<20140212192354.GC26809@htj.dyndns.org> <7hk3cx46rw.fsf@paris.lan>
	<1392449804.5517.45.camel@marge.simpson.net>
	<20140216164106.GD4250@linux.vnet.ibm.com>
	<1392612613.5565.78.camel@marge.simpson.net>
Date: Mon, 24 Feb 2014 09:55:16 -0800
In-Reply-To: <1392612613.5565.78.camel@marge.simpson.net> (Mike Galbraith's
	message of "Mon, 17 Feb 2014 05:50:13 +0100")
Message-ID: <7hppmc2y63.fsf@paris.lan>
User-Agent: Gnus/5.130008 (Ma Gnus v0.8) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Galbraith <bitbucket@online.de> writes:

> On Sun, 2014-02-16 at 08:41 -0800, Paul E. McKenney wrote:
>
>> So if there is NO_HZ_FULL, you have no objection to binding workqueues to
>> the timekeeping CPUs, but that you would also like some form of automatic
>> binding in the !NO_HZ_FULL case.  Of course, if a common mechanism could
>> serve both cases, that would be good.  And yes, cpusets are frowned upon
>> for some workloads.
>
> I'm not _objecting_, I'm not driving, Frederic's doing that ;-)
>
> That said, isolation seems to be turning into a property of nohz mode,
> but as I see it, nohz_full is an extension to generic isolation.
>
>> So maybe start with Kevin's patch, but augment with something else for
>> the !NO_HZ_FULL case?
>
> Sure (hm, does it work without workqueue.disable_numa ?).

[ /me returns from vacation ]

Yes, since it happens for every alloc_workqueue_attrs()

> It just seems to me that tying it to sched domain construction would be
> a better fit.  That way, it doesn't matter what your isolation requiring
> load is, whether you run a gaggle of realtime tasks or one HPC task your
> business, the generic requirement is isolation, not tick mode.  For one
> HPC task per core, you want no tick, if you're running all SCHED_FIFO,
> maybe you want that too, depends on the impact of nohz_full mode.  All
> sensitive loads want the isolation, but they may not like the price.
>
> I personally like the cpuset way.  Being able to partition boxen on the
> fly makes them very flexible.  In a perfect world, you'd be able to
> quiesce and configure offloading and nohz_full on the fly too, and not
> end up with some hodgepodge like this needs boot option foo, that
> happens invisibly because of config option bar, the other thing you have
> to do manually.. and you get to eat 937 kthreads and tons of overhead on
> all CPUs if you want the ability to _maybe_ run a critical task or two.

Yeah, my patch only addresses the nohz_full case, but since there
doesn't seem to be any general agreemenet about the generic case, it
seems that exposing all unbound workqueues via WQ_SYSFS is the way to
go.  

Mike, looks like you may have started on that.  Did it get any further?

Kevin
