Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754050AbbAWJyz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 04:54:55 -0500
Received: from casper.infradead.org ([85.118.1.10]:45990 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752884AbbAWJyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 04:54:51 -0500
Date: Fri, 23 Jan 2015 10:54:49 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Jan Beulich <JBeulich@suse.com>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org,
        Rik van Riel <riel@redhat.com>
Subject: Re: sched/fair: avoid using uninitialized variable in
 preferred_group_nid()
Message-ID: <20150123095449.GL2896@worktop.programming.kicks-ass.net>
References: <54C2139202000078000588F7@mail.emea.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54C2139202000078000588F7@mail.emea.novell.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 23, 2015 at 08:25:38AM +0000, Jan Beulich wrote:
> At least some gcc versions - validly afaict - warn about potentially
> using max_group uninitialized: There's no way the compiler can prove
> that the body of the conditional where it and max_faults get set/
> updated gets executed; in fact, without knowing all the details of
> other scheduler code, I can't prove this either.
> 
> Generally the necessary change would appear to be to clear max_group
> prior to entering the inner loop, and break out of the outer loop when
> it ends up being all clear after the inner one. This, however, seems
> inefficient, and afaict the same effect can be achieved by exiting the
> outer loop when max_faults is still zero after the inner loop. For the
> compiler's sake, mark max_group uninitialized, as we're now able to
> prove it's not actually being used uninitalized anymore.


Yes this is somewhat challenging. What compiler version in specific did
you get this warning wiht? I cannot remember seeing it with whatever it
is I use (4.7-4.9 it seems).


> Signed-off-by: Jan Beulich <jbeulich@suse.com>
> Cc: Rik van Riel <riel@redhat.com>
> ---
>  kernel/sched/fair.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> --- 3.19-rc5/kernel/sched/fair.c
> +++ 3.19-rc5-sched-fair-preferred-group-nid/kernel/sched/fair.c
> @@ -1730,7 +1730,7 @@ static int preferred_group_nid(struct ta
>  	nodes = node_online_map;
>  	for (dist = sched_max_numa_distance; dist > LOCAL_DISTANCE; dist--) {
>  		unsigned long max_faults = 0;
> -		nodemask_t max_group;
> +		nodemask_t uninitialized_var(max_group);
>  		int a, b;
>  
>  		/* Are there nodes at this distance from each other? */
> @@ -1764,6 +1764,8 @@ static int preferred_group_nid(struct ta
>  			}
>  		}
>  		/* Next round, evaluate the nodes within max_group. */
> +		if (!max_faults)
> +			break;
>  		nodes = max_group;
>  	}
>  	return nid;

Yes I think you're right; there is no guarantee the faults sum will be
greater than 0, and therefore we might not trigger the assignment and
end up with uninitialized use.


