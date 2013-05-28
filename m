Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934756Ab3E1QUl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 12:20:41 -0400
Received: from one.firstfloor.org ([193.170.194.197]:60416 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934660Ab3E1QUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 12:20:40 -0400
Date: Tue, 28 May 2013 18:20:38 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: Basic perf PMU support for Haswell v12
Message-ID: <20130528162038.GG6123@two.firstfloor.org>
References: <1369261073-1275-1-git-send-email-andi@firstfloor.org>
 <20130528062915.GA26467@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130528062915.GA26467@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 28, 2013 at 08:29:15AM +0200, Ingo Molnar wrote:
> 
> * Andi Kleen <andi@firstfloor.org> wrote:
> 
> > All outstanding issues fixed I hope. And I added mem-loads/stores support.
> > 
> > Contains support for:
> > - Basic Haswell PMU and PEBS support
> > - Late unmasking of the PMI
> > - mem-loads/stores support
> > 
> > v2: Addressed Stephane's feedback. See individual patches for details.
> > v3: now even more bite-sized. Qualifier constraints merged earlier.
> > v4: Rename some variables, add some comments and other minor changes.
> > Add some Reviewed/Tested-bys.
> > v5: Address some minor review feedback. Port to latest perf/core
> > v6: Add just some variable names, add comments, edit descriptions, some
> > more testing, rebased to latest perf/core
> > v7: Expand comment
> > v8: Rename structure field.
> > v9: No wide counters, but add basic LBRs. Add some more 
> > constraints. Rebase to 3.9rc1
> > v10: Change some whitespace. Rebase to 3.9rc3
> > v11: Rebase to perf/core. Fix extra regs. Rename INTX.
> > v12: Rebase to 3.10-rc2
> > Add mem-loads/stores support for parity with Sandy Bridge.
> > Fix fixed counters (Thanks Ingo!)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> > Make late ack optional
> > Export new config bits in sysfs.
> > Minor changes
> 
> I reported a pretty nasty regression with the previous version (v10) which 
> made this series break default 'perf top' on non-Haswell systems - but 
> it's unclear from this changelog to what extent you managed to reproduce 
> the bug and fix it, and what the fix was?

Thanks for checking.
I didn't reproduce it, but I found a problem by code review with the 
fixed counter constraints.

I think I fixed it by adding this hunk:

@@ -2227,7 +2313,7 @@ __init int intel_pmu_init(void)
                 * counter, so do not extend mask to generic counters
                 */
                for_each_event_constraint(c, x86_pmu.event_constraints) {
-                       if (c->cmask != X86_RAW_EVENT_MASK
+                       if (c->cmask != FIXED_EVENT_FLAGS
                            || c->idxmsk64 == INTEL_PMC_MSK_FIXED_REF_CYCLES) {
                                continue;
                        }

It would be cleaner to detect the fixed counters in some other way,
but that was the simplest fix I could find.

Testing appreciated 

> I'd really like to make progress with this feature - 11 iterations is 
> ridiculous really.

Thanks.

There are actually more patches unfortunately, this is just a subset.
I'll send the others once that one is in, probably split into less and
more important ones.

https://git.kernel.org/cgit/linux/kernel/git/ak/linux-misc.git/log/?h=hsw/pmu6

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
