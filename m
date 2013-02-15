Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161934Ab3BONBW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 08:01:22 -0500
Received: from merlin.infradead.org ([205.233.59.134]:45101 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161780Ab3BONBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 08:01:17 -0500
Message-ID: <1360933253.2739.15.camel@laptop>
Subject: Re: [patch v4 05/18] sched: quicker balancing on fork/exec/wake
From: Peter Zijlstra <peterz@infradead.org>
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: Alex Shi <alex.shi@intel.com>, torvalds@linux-foundation.org,
        mingo@redhat.com, tglx@linutronix.de, akpm@linux-foundation.org,
        arjan@linux.intel.com, bp@alien8.de, pjt@google.com,
        namhyung@kernel.org, efault@gmx.de, vincent.guittot@linaro.org,
        gregkh@linuxfoundation.org, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org
Date: Fri, 15 Feb 2013 14:00:53 +0100
In-Reply-To: <511C9C54.4090508@linux.vnet.ibm.com>
References: <1358996820-23036-1-git-send-email-alex.shi@intel.com>
	 <1358996820-23036-6-git-send-email-alex.shi@intel.com>
	 <1360664565.4485.13.camel@laptop> <511C9C54.4090508@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-02-14 at 13:42 +0530, Preeti U Murthy wrote:
> Hi Peter,Alex,
> If the eligible cpus happen to be all the cpus,then iterating over all
> the 
> cpus for idlest would be much worse than iterating over sched domains
> right?

Depends, doing a domain walk generally gets you 2n cpus visited --
geometric series and such. A simple scan of the top-most domain mask
that's eligible will limit that to n. 

> I am also wondering how important it is to bias the balancing of
> forked/woken up
> task onto an idlest cpu at every iteration.

Yeah, I don't know, it seems overkill to me, that code is from before my
time, so far it has survived.

> If biasing towards the idlest_cpu at every iteration is not really the
> criteria,
> then we could cut down on the iterations in fork/exec/wake balancing.
> Then the problem boils down to,is the option between biasing our
> search towards
> the idlest_cpu or the idlest_group.If we are not really concerned
> about balancing
> load across  groups,but ensuring we find the idlest cpu to run the
> task on,then
> Alex's patch seems to have covered the criteria.
> 
> However if the concern is to distribute the load uniformly across
> groups,then
> I have the following patch which might reduce the overhead of the
> search of an
> eligible cpu for a forked/exec/woken up task.

Nah, so I think the whole bias thing was mostly done to avoid
over-balancing and possibly to compensate for some approximations on the
whole weight/load measurement stuff.

