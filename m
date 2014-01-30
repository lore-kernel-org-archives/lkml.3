Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752362AbaA3CMx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 21:12:53 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:54680 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751116AbaA3CMv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 21:12:51 -0500
Date: Wed, 29 Jan 2014 21:12:44 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Rientjes <rientjes@google.com>, Michal Hocko <mhocko@suse.cz>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [patch] mm, oom: base root bonus on current usage
Message-ID: <20140130021244.GC6963@cmpxchg.org>
References: <20140115234308.GB4407@cmpxchg.org>
 <alpine.DEB.2.02.1401151614480.15665@chino.kir.corp.google.com>
 <20140116070709.GM6963@cmpxchg.org>
 <alpine.DEB.2.02.1401212050340.8512@chino.kir.corp.google.com>
 <20140124040531.GF4407@cmpxchg.org>
 <alpine.DEB.2.02.1401251942510.3140@chino.kir.corp.google.com>
 <20140129122813.59d32e5c5dad3efc2248bc60@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140129122813.59d32e5c5dad3efc2248bc60@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 29, 2014 at 12:28:13PM -0800, Andrew Morton wrote:
> On Sat, 25 Jan 2014 19:48:32 -0800 (PST) David Rientjes <rientjes@google.com> wrote:
> 
> > A 3% of system memory bonus is sometimes too excessive in comparison to 
> > other processes and can yield poor results when all processes on the 
> > system are root and none of them use over 3% of memory.
> > 
> > Replace the 3% of system memory bonus with a 3% of current memory usage 
> > bonus.
> 
> This changelog has deteriorated :( We should provide sufficient info so
> that people will be able to determine whether this patch will fix a
> problem they or their customers are observing.  And so that people who
> maintain -stable and its derivatives can decide whether to backport it.
> 
> I went back and stole some text from the v1 patch.  Please review the
> result.  The changelog would be even better if it were to describe the
> new behaviour under the problematic workloads.

Looks good to me, thanks.  How about the below?

> We don't think -stable needs this?

That's actually a good idea, we're putting it into RHEL too.

> From: David Rientjes <rientjes@google.com>
> Subject: mm, oom: base root bonus on current usage
> 
> A 3% of system memory bonus is sometimes too excessive in comparison to
> other processes.
> 
> With a63d83f427fb ("oom: badness heuristic rewrite"), the OOM killer tries
> to avoid killing privileged tasks by subtracting 3% of overall memory
> (system or cgroup) from their per-task consumption.  But as a result, all
> root tasks that consume less than 3% of overall memory are considered
> equal, and so it only takes 33+ privileged tasks pushing the system out of
> memory for the OOM killer to do something stupid and kill sshd or
> dhclient.  For example, on a 32G machine it can't tell the difference
> between the 1M agetty and the 10G fork bomb member.
> 
> The changelog describes this 3% boost as the equivalent to the global
> overcommit limit being 3% higher for privileged tasks, but this is not the
> same as discounting 3% of overall memory from _every privileged task
> individually_ during OOM selection.
> 
> Replace the 3% of system memory bonus with a 3% of current memory usage
> bonus.

By giving root tasks a bonus that is proportional to their actual
size, they remain comparable even when relatively small.  In the
example above, the OOM killer will discount the 1M agetty's 256
badness points down to 179, and the 10G fork bomb's 262144 points down
to 183500 points and make the right choice, instead of discounting
both to 0 and killing agetty because it's first in the task list.

> Signed-off-by: David Rientjes <rientjes@google.com>
> Reported-by: Johannes Weiner <hannes@cmpxchg.org>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Cc: <stable@kernel.org>
