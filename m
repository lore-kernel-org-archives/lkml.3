Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752122AbaBQEu3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Feb 2014 23:50:29 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:65004 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851AbaBQEu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Feb 2014 23:50:28 -0500
Message-ID: <1392612613.5565.78.camel@marge.simpson.net>
Subject: Re: [RFC PATCH] rcu: move SRCU grace period work to power efficient
 workqueue
From: Mike Galbraith <bitbucket@online.de>
To: paulmck@linux.vnet.ibm.com
Cc: Kevin Hilman <khilman@linaro.org>, Tejun Heo <tj@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Zoran Markovic <zoran.markovic@linaro.org>,
        linux-kernel@vger.kernel.org,
        Shaibal Dutta <shaibal.dutta@broadcom.com>,
        Dipankar Sarma <dipankar@in.ibm.com>
Date: Mon, 17 Feb 2014 05:50:13 +0100
In-Reply-To: <20140216164106.GD4250@linux.vnet.ibm.com>
References: <1391197986-12774-1-git-send-email-zoran.markovic@linaro.org>
	 <52F8A51F.4090909@cn.fujitsu.com>
	 <20140210184729.GL4250@linux.vnet.ibm.com>
	 <20140212182336.GD5496@localhost.localdomain>
	 <20140212190241.GD4250@linux.vnet.ibm.com>
	 <20140212192354.GC26809@htj.dyndns.org> <7hk3cx46rw.fsf@paris.lan>
	 <1392449804.5517.45.camel@marge.simpson.net>
	 <20140216164106.GD4250@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:/qPihr+D4g91Ao8t3oQushbrICjSj6coN3pm2VvQ4cH
 f13+Un7sLGsznQMWR4Xh+40CFKGpUcSLgGK/97wlrvf5RjGFd0
 8P4XA5H5A2TitjpMcyCYj+kLFi7bdRdzXjdOkX1xsqR2j+zI5M
 c03XmVRDMg8WV9kYcNXUcYgN4bKb7Ja+Rzhz9bKaA94/2oHJ38
 Nsbrv5rWgC2va+WXIIwTGqhSyD79R480Cf7brLzo2kbalE1WMB
 3K/xgE0yBKSaJW7pZ5Tr17vAGtrYBRdnqne8odDPs5hS/sOUiO
 mU/3Z1qo4xvfBCR4EspBT24+VcWq4r07HPfSOaRaqpnMSxHpQD
 1dD396Q1LFvhAa34jSZ/V4IBft91JTGozyeukVKw63hbMR6G7O
 73GSpkWbN9ZCA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-02-16 at 08:41 -0800, Paul E. McKenney wrote:

> So if there is NO_HZ_FULL, you have no objection to binding workqueues to
> the timekeeping CPUs, but that you would also like some form of automatic
> binding in the !NO_HZ_FULL case.  Of course, if a common mechanism could
> serve both cases, that would be good.  And yes, cpusets are frowned upon
> for some workloads.

I'm not _objecting_, I'm not driving, Frederic's doing that ;-)

That said, isolation seems to be turning into a property of nohz mode,
but as I see it, nohz_full is an extension to generic isolation.

> So maybe start with Kevin's patch, but augment with something else for
> the !NO_HZ_FULL case?

Sure (hm, does it work without workqueue.disable_numa ?).

It just seems to me that tying it to sched domain construction would be
a better fit.  That way, it doesn't matter what your isolation requiring
load is, whether you run a gaggle of realtime tasks or one HPC task your
business, the generic requirement is isolation, not tick mode.  For one
HPC task per core, you want no tick, if you're running all SCHED_FIFO,
maybe you want that too, depends on the impact of nohz_full mode.  All
sensitive loads want the isolation, but they may not like the price.

I personally like the cpuset way.  Being able to partition boxen on the
fly makes them very flexible.  In a perfect world, you'd be able to
quiesce and configure offloading and nohz_full on the fly too, and not
end up with some hodgepodge like this needs boot option foo, that
happens invisibly because of config option bar, the other thing you have
to do manually.. and you get to eat 937 kthreads and tons of overhead on
all CPUs if you want the ability to _maybe_ run a critical task or two.

-Mike

