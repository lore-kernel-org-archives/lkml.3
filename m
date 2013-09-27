Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751329Ab3I0LYA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 07:24:00 -0400
Received: from merlin.infradead.org ([205.233.59.134]:49099 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031Ab3I0LX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 07:23:57 -0400
Date: Fri, 27 Sep 2013 13:23:23 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Tim Chen <tim.c.chen@linux.intel.com>, Jason Low <jason.low2@hp.com>,
        Davidlohr Bueso <davidlohr@hp.com>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>, Alex Shi <alex.shi@linaro.org>,
        Andi Kleen <andi@firstfloor.org>,
        Michel Lespinasse <walken@google.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Matthew R Wilcox <matthew.r.wilcox@intel.com>,
        Dave Hansen <dave.hansen@intel.com>, Rik van Riel <riel@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>, linux-kernel@vger.kernel.org,
        linux-mm <linux-mm@kvack.org>, Joe Perches <joe@perches.com>
Subject: Re: [PATCH v6 5/6] MCS Lock: Restructure the MCS lock defines and
 locking code into its own file
Message-ID: <20130927112323.GJ3657@laptop.programming.kicks-ass.net>
References: <1380147049.3467.67.camel@schen9-DESK>
 <CAGQ1y=7Ehkr+ot3tDZtHv6FR6RQ9fXBVY0=LOyWjmGH_UjH7xA@mail.gmail.com>
 <1380226007.2170.2.camel@buesod1.americas.hpqcorp.net>
 <1380226997.2602.11.camel@j-VirtualBox>
 <1380228059.2170.10.camel@buesod1.americas.hpqcorp.net>
 <1380229794.2602.36.camel@j-VirtualBox>
 <1380231702.3467.85.camel@schen9-DESK>
 <1380235333.3229.39.camel@j-VirtualBox>
 <1380236265.3467.103.camel@schen9-DESK>
 <20130927060213.GA6673@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130927060213.GA6673@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 27, 2013 at 08:02:13AM +0200, Ingo Molnar wrote:
> Would be nice to have this as a separate, add-on patch. Every single 
> instruction removal that has no downside is an upside!
> 
> You can add a comment that explains it.

If someone is going to do add-on patches to the mcslock.h file, please
also consider doing a patch that adds comments to the memory barriers in
there.

Also, checkpatch.pl should really warn about that; and it appears there
code in there for that; however:

# grep -C3 smp_mb scripts/checkpatch.pl 
                        }
                }
# check for memory barriers without a comment.
                if ($line =~ /\b(mb|rmb|wmb|read_barrier_depends|smp_mb|smp_rmb|smp_wmb|smp_read_barrier_depends)\(/) {
                        if (!ctx_has_comment($first_line, $linenr)) {
                                CHK("MEMORY_BARRIER",
                                    "memory barrier without comment\n" . $herecurr);
# grep -C3 smp_wmb kernel/mutex.c
                return;
        }
        ACCESS_ONCE(prev->next) = node;
        smp_wmb();
        /* Wait until the lock holder passes the lock down */
        while (!ACCESS_ONCE(node->locked))
                arch_mutex_cpu_relax();
--
                        arch_mutex_cpu_relax();
        }
        ACCESS_ONCE(next->locked) = 1;
        smp_wmb();
}

/*
# scripts/checkpatch.pl -f kernel/mutex.c 2>&1 | grep memory
#

so that appears to be completely broken :/

Joe, any clue what's up with that?
