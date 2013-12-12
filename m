Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751865Ab3LLXRj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 18:17:39 -0500
Received: from relay2.sgi.com ([192.48.179.30]:45645 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751579Ab3LLXRf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 18:17:35 -0500
Date: Thu, 12 Dec 2013 17:17:30 -0600
From: Alex Thorlton <athorlton@sgi.com>
To: Rik van Riel <riel@redhat.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>, Mel Gorman <mgorman@suse.de>,
        Michel Lespinasse <walken@google.com>,
        Benjamin LaHaise <bcrl@kvack.org>, Oleg Nesterov <oleg@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Al Viro <viro@zeniv.linux.org.uk>,
        David Rientjes <rientjes@google.com>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Jiang Liu <jiang.liu@huawei.com>,
        Cody P Schafer <cody@linux.vnet.ibm.com>,
        Glauber Costa <glommer@parallels.com>,
        Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        linux-kernel@vger.kernel.org, Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [RFC PATCH 2/3] Add tunable to control THP behavior
Message-ID: <20131212231730.GD6034@sgi.com>
References: <cover.1386790423.git.athorlton@sgi.com>
 <20131212180050.GC134240@sgi.com>
 <52AA2C87.5040509@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52AA2C87.5040509@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 12, 2013 at 04:37:11PM -0500, Rik van Riel wrote:
> On 12/12/2013 01:00 PM, Alex Thorlton wrote:
> >This part of the patch adds a tunable to
> >/sys/kernel/mm/transparent_hugepage called threshold.  This threshold
> >determines how many pages a user must fault in from a single node before
> >a temporary compound page is turned into a THP.
> 
> >+++ b/mm/huge_memory.c
> >@@ -44,6 +44,9 @@ unsigned long transparent_hugepage_flags __read_mostly =
> >  	(1<<TRANSPARENT_HUGEPAGE_DEFRAG_KHUGEPAGED_FLAG)|
> >  	(1<<TRANSPARENT_HUGEPAGE_USE_ZERO_PAGE_FLAG);
> >
> >+/* default to 1 page threshold for handing out thps; maintains old behavior */
> >+static int transparent_hugepage_threshold = 1;
> 
> I assume the motivation for writing all this code is that "1"
> was not a good value in your tests.

Yes, that's correct.

> That makes me wonder, why should 1 be the default value with
> your patches?

The main reason I set the default to 1 was because the majority of
jobs aren't hurt by the existing THP behavior.  I figured it would be
best to default to having things behave the same as they do now, but
provide the option to increase the threshold on systems that run jobs
that could be adversely affected by the current behavior.

> If there is a better value, why should we not use that?
>
> What is the upside of using a better value?
>
> What is the downside?

The problem here is that what the "better" value is can vary greatly
depending on how a particular task allocates memory.  Setting the
threshold too high can negatively affect the performance of jobs that
behave well with the current behavior, setting it too low won't yield a
performance increase for the jobs that are hurt by the current
behavior.  With some more thorough testing, I'm sure that we could
arrive at a value that will help out jobs which behave poorly under
current conditions, while having a minimal effect on jobs that already
perform well.  At this point, I'm looking more to ensure that everybody
likes this approach to solving the problem before putting the finishing
touches on the patches, and doing testing to find a good middle ground.
 
> Is there a value that would to bound the downside, so it
> is almost always smaller than the upside?

Again, the problem here is that, to find a good value, we have to know
quite a bit about why a particular value is bad for a particular job.
While, as stated above, I think we can probably find a good middle
ground to use as a default, in the end it will be the job of individual
sysadmins to determine what value works best for their particular
applications, and tune things accordingly.

- Alex
