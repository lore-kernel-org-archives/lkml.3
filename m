Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758566Ab3LFTBM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 14:01:12 -0500
Received: from mail-qa0-f52.google.com ([209.85.216.52]:46571 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754301Ab3LFTBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 14:01:09 -0500
Date: Fri, 6 Dec 2013 14:01:05 -0500
From: Tejun Heo <tj@kernel.org>
To: David Rientjes <rientjes@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Pekka Enberg <penberg@kernel.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        Li Zefan <lizefan@huawei.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, cgroups@vger.kernel.org
Subject: Re: [patch 7/8] mm, memcg: allow processes handling oom
 notifications to access reserves
Message-ID: <20131206190105.GE13373@htj.dyndns.org>
References: <20131120152251.GA18809@dhcp22.suse.cz>
 <alpine.DEB.2.02.1311201917520.7167@chino.kir.corp.google.com>
 <20131128115458.GK2761@dhcp22.suse.cz>
 <alpine.DEB.2.02.1312021504170.13465@chino.kir.corp.google.com>
 <alpine.DEB.2.02.1312032116440.29733@chino.kir.corp.google.com>
 <alpine.DEB.2.02.1312032118570.29733@chino.kir.corp.google.com>
 <20131204054533.GZ3556@cmpxchg.org>
 <alpine.DEB.2.02.1312041742560.20115@chino.kir.corp.google.com>
 <20131205025026.GA26777@htj.dyndns.org>
 <alpine.DEB.2.02.1312051537550.7717@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1312051537550.7717@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yo, David.

On Thu, Dec 05, 2013 at 03:49:57PM -0800, David Rientjes wrote:
> Tejun, how are you?

Doing pretty good.  How's yourself? :)

> > Umm.. without delving into details, aren't you basically creating a
> > memory cgroup inside a memory cgroup?  Doesn't sound like a
> > particularly well thought-out plan to me.
> 
> I agree that we wouldn't need such support if we are only addressing memcg 
> oom conditions.  We could do things like A/memory.limit_in_bytes == 128M 
> and A/b/memory.limit_in_bytes == 126MB and then attach the process waiting 
> on A/b/memory.oom_control to A and that would work perfect.

Or even just create a separate parallel cgroup A/memory.limit_in_bytes
== 126M A-oom/memory.limit_in_bytes = 2M and avoid the extra layer of
nesting.

> However, we also need to discuss system oom handling.  We have an interest 
> in being able to allow userspace to handle system oom conditions since the 
> policy will differ depending on machine and we can't encode every possible 
> mechanism into the kernel.  For example, on system oom we want to kill a 
> process from the lowest priority top-level memcg.  We lack that ability 
> entirely in the kernel and since the sum of our top-level memcgs 
> memory.limit_in_bytes exceeds the amount of present RAM, we run into these 
> oom conditions a _lot_.
> 
> So the first step, in my opinion, is to add a system oom notification on 
> the root memcg's memory.oom_control which currently allows registering an 
> eventfd() notification but never actually triggers.  I did that in a patch 
> and it is was merged into -mm but was pulled out for later discussion.

Hmmm... this seems to be a different topic.  You're saying that it'd
be beneficial to add userland oom handling at the sytem level and if
that happens having per-memcg oom reserve would be consistent with the
system-wide one, right?  While I can see some merit in that argument,
the whole thing is predicated on system level userland oom handling
being justified && even then I'm not quite sure whether "consistent
interface" is enough to have oom reserve in all memory cgroups.  It
feels a bit backwards because, here, the root memcg is the exception,
not the other way around.  Root is the only one which can't put oom
handler in a separate cgroup, so it could make more sense to special
case that rather than spreading the interface for global userland oom
to everyone else.

But, before that, system level userland OOM handling sounds scary to
me.  I thought about userland OOM handling for memcgs and it does make
some sense.  ie. there is a different action that userland oom handler
can take which kernel oom handler can't - it can expand the limit of
the offending cgroup, effectively using OOM handler as a sizing
estimator.  I'm not sure whether that in itself is a good idea but
then again it might not be possible to clearly separate out sizing
from oom conditions.

Anyways, but for system level OOM handling, there's no other action
userland handler can take.  It's not like the OOM handler paging the
admin to install more memory is a reasonable mode of operation to
support.  The *only* action userland OOM handler can take is killing
something.  Now, if that's the case and we have kernel OOM handler
anyway, I think the best course of action is improving kernel OOM
handler and teach it to make the decisions that the userland handler
would consider good.  That should be doable, right?

The thing is OOM handling in userland is an inherently fragile thing
and it can *never* replace kernel OOM handling.  You may reserve any
amount of memory you want but there would still be cases that it may
fail.  It's not like we have owner-based allocation all through the
kernel or are willing to pay overhead for such thing.  Even if that
part can be guaranteed somehow (no idea how), the kernel still can
NEVER trust the userland OOM handler.  No matter what we do, we need a
kernel OOM handler with no resource dependency.

So, there isn't anything userland OOM handler can inherently do better
and we can't do away with kernel handler no matter what.  On both
accounts, it seems like the best course of action is making
system-wide kernel OOM handler to make better decisions if possible at
all.  If that's impossible, let's first think about why that's the
case before hastly opening this new can of worms.

Thanks!

-- 
tejun
