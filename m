Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753071AbaBYOPJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 09:15:09 -0500
Received: from merlin.infradead.org ([205.233.59.134]:42639 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752992AbaBYOPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 09:15:05 -0500
Date: Tue, 25 Feb 2014 15:14:07 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Alex Shi <alex.shi@linaro.org>
Cc: mingo@redhat.com, morten.rasmussen@arm.com, vincent.guittot@linaro.org,
        daniel.lezcano@linaro.org, fweisbec@gmail.com, linux@arm.linux.org.uk,
        tony.luck@intel.com, fenghua.yu@intel.com, james.hogan@imgtec.com,
        jason.low2@hp.com, viresh.kumar@linaro.org, hanjun.guo@linaro.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, pjt@google.com,
        fengguang.wu@intel.com, linaro-kernel@lists.linaro.org,
        wangyun@linux.vnet.ibm.com, mgorman@suse.de
Subject: Re: [PATCH 04/11] sched: unify imbalance bias for target group
Message-ID: <20140225141407.GT9987@twins.programming.kicks-ass.net>
References: <1393293054-11378-1-git-send-email-alex.shi@linaro.org>
 <1393293054-11378-5-git-send-email-alex.shi@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393293054-11378-5-git-send-email-alex.shi@linaro.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 25, 2014 at 09:50:47AM +0800, Alex Shi wrote:
> Old code considers the bias in source/target_load already. but still
> use imbalance_pct as last check in idlest/busiest group finding. It is
> also a kind of redundant job. If we bias imbalance in source/target_load,
> we'd better not use imbalance_pct again.
> 
> After cpu_load array removed, it is nice time to unify the target bias
> consideration. So I remove the imbalance_pct from last check and add the
> live bias using.
> 
> On wake_affine, since all archs' wake_idx is 0, current logical is just
> want to prefer current cpu. so we follows this logical. Just renaming the
> target_load/source_load to wegithed_cpuload for more exact meaning.
> Thanks for reminding from Morten!
> 

So this patch is weird..

So the original bias in the source/target load is purely based on actual
load figures. It only pulls-down/pulls-up resp. the long term avg with a
shorter term average; iow. it allows the source to decrease faster and
the target to increase faster, giving a natural inertia (ie. a
resistance to movement).

Therefore this gives rise to a conservative imbalance.

Then at the end we use the imbalance_pct thing as a normal hysteresis
control to avoid the rapid state switching associated with a single
control point system.


You completely wreck that, you also don't give a coherent model back.


The movement of imbalance_pct into target_load() doesn't make sense to
me either; it's an (expensive) no-op afaict. Seeing how:

  100 * source_load() < imb_pct * target_load()

is very much equal to:

  source_load() < (imb_pct * target_load()) / 100;

Except you get to do that div all over the place.

It also completely muddles the fact that its a normal hysteresis
control. Not a load bias. A fixed bias can never replace the inertial
control we had; it doesn't make sense as a replacement.

Not to mention you seem to ignore all concerns wrt the use of longer
term averages for the bigger domains.

Now I'm all for removing code; and so far the numbers aren't bad; but I
don't like the complete muddle you make of things at all.
