Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755754AbaHAR2Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 13:28:24 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:45610 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751864AbaHAR2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 13:28:23 -0400
Date: Fri, 1 Aug 2014 19:28:19 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, Michal Hocko <mhocko@suse.cz>,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Mel Gorman <mgorman@suse.de>, Tejun Heo <tj@kernel.org>,
        Christoph Lameter <cl@gentwo.org>,
        Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
        Jianyu Zhan <nasa4836@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Khalid Aziz <khalid.aziz@oracle.com>, linux-mm@kvack.org,
        Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: [PATCH] swap: remove the struct cpumask has_work
Message-ID: <20140801172818.GD13134@localhost.localdomain>
References: <1406777421-12830-3-git-send-email-laijs@cn.fujitsu.com>
 <20140731115137.GA20244@dhcp22.suse.cz>
 <53DA6A2F.100@tilera.com>
 <53DAEFB5.7060501@cn.fujitsu.com>
 <53DBCB55.3050302@tilera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53DBCB55.3050302@tilera.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 01, 2014 at 01:16:05PM -0400, Chris Metcalf wrote:
> On 7/31/2014 9:39 PM, Lai Jiangshan wrote:
> >On 08/01/2014 12:09 AM, Chris Metcalf wrote:
> >>On 7/31/2014 7:51 AM, Michal Hocko wrote:
> >>>On Thu 31-07-14 11:30:19, Lai Jiangshan wrote:
> >>>>It is suggested that cpumask_var_t and alloc_cpumask_var() should be used
> >>>>instead of struct cpumask.  But I don't want to add this complicity nor
> >>>>leave this unwelcome "static struct cpumask has_work;", so I just remove
> >>>>it and use flush_work() to perform on all online drain_work.  flush_work()
> >>>>performs very quickly on initialized but unused work item, thus we don't
> >>>>need the struct cpumask has_work for performance.
> >>>Why? Just because there is general recommendation for using
> >>>cpumask_var_t rather than cpumask?
> >>>
> >>>In this particular case cpumask shouldn't matter much as it is static.
> >>>Your code will work as well, but I do not see any strong reason to
> >>>change it just to get rid of cpumask which is not on stack.
> >>The code uses for_each_cpu with a cpumask to avoid waking cpus that don't
> >>need to do work.  This is important for the nohz_full type functionality,
> >>power efficiency, etc.  So, nack for this change.
> >>
> >flush_work() on initialized but unused work item just disables irq and
> >fetches work->data to test and restores irq and return.
> >
> >the struct cpumask has_work is just premature optimization.
> 
> Yes, I see your point.  I was mistakenly thinking that your patch resulted
> in calling schedule_work() on all the online cpus.
> 
> Given that, I think your suggestion is reasonable, though like Michal,
> I'm not sure it necessarily rises to the level of it being worth changing the
> code at this point.  Regardless, I withdraw my nack, and you can add my
> Reviewed-by: Chris Metcalf <cmetcalf@tilera.com> if the change is taken.

Thing is: static struct cpumask can potentially reserve a bit of memory.
For NR_CPUS=1024 for example it should be 1024 / sizeof(byte) = 128 bytes. It's no
big deal but as I can see sometimes people complaining about the size of the
kernel... Also think about the cacheline it takes.

I mean if the patch really has no side effect in performance, it's probably good to
take.

But I'm not sure it's free of such. It's still an iteration on all online CPUs,
even though a noop, with a high number of CPUs it can be undesired. It depends
what's the usual proportion of has_work CPUs against online?

If most online CPUs are to be found there, we can ignore that but otherwise...
