Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932220Ab3LTCOg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 21:14:36 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:47749 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756318Ab3LTCOf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 21:14:35 -0500
Date: Thu, 19 Dec 2013 18:15:20 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Michal Hocko <mhocko@suse.cz>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        David Gibson <david@gibson.dropbear.id.au>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Hillf Danton <dhillf@gmail.com>
Subject: Re: [PATCH v3 13/14] mm, hugetlb: retry if failed to allocate and
 there is concurrent user
Message-Id: <20131219181520.8a3bfb26.akpm@linux-foundation.org>
In-Reply-To: <20131220015810.GA1084@lge.com>
References: <1387349640-8071-1-git-send-email-iamjoonsoo.kim@lge.com>
	<1387349640-8071-14-git-send-email-iamjoonsoo.kim@lge.com>
	<20131219170202.0df2d82a2adefa3ab616bdaa@linux-foundation.org>
	<20131220015810.GA1084@lge.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Dec 2013 10:58:10 +0900 Joonsoo Kim <iamjoonsoo.kim@lge.com> wrote:

> On Thu, Dec 19, 2013 at 05:02:02PM -0800, Andrew Morton wrote:
> > On Wed, 18 Dec 2013 15:53:59 +0900 Joonsoo Kim <iamjoonsoo.kim@lge.com> wrote:
> > 
> > > If parallel fault occur, we can fail to allocate a hugepage,
> > > because many threads dequeue a hugepage to handle a fault of same address.
> > > This makes reserved pool shortage just for a little while and this cause
> > > faulting thread who can get hugepages to get a SIGBUS signal.
> > > 
> > 
> > So if I'm understanding this correctly...  if N threads all generate a
> > fault against the same address, they will all dive in and allocate a
> > hugepage, will then do an enormous memcpy into that page and will then
> > attempt to instantiate the page in pagetables.  All threads except one
> > will lose the race and will free the page again!  This sounds terribly
> > inefficient; it would be useful to write a microbenchmark which
> > triggers this scenario so we can explore the impact.
> 
> Yes, you understand correctly, I think.
> 
> I have an idea to prevent this overhead. It is that marking page when it
> is zeroed and unmarking when it is mapped to page table. If page mapping
> is failed due to current thread, the zeroed page will keep the marker and
> later we can determine if it is zeroed or not.

Well OK, but the other threads will need to test that in-progress flag
and then do <something>.  Where <something> will involve some form of
open-coded sleep/wakeup thing.  To avoid all that wheel-reinventing we
can avoid using an internal flag and use an external flag instead. 
There's one in struct mutex!

I doubt if the additional complexity of the external flag is worth it,
but convincing performance testing results would sway me ;) Please have
a think about it all.

> If you want to include this functionality in this series, I can do it ;)
> Please let me know your decision.
> 
> > I'm wondering if a better solution to all of this would be to make
> > hugetlb_instantiation_mutex an array of, say, 1024 mutexes and index it
> > with a hash of the faulting address.  That will 99.9% solve the
> > performance issue which you believe exists without introducing this new
> > performance issue?
> 
> Yes, that approach would solve the performance issue.
> IIRC, you already suggested this idea roughly 6 months ago and it is
> implemented by Davidlohr. I remembered that there is a race issue on
> COW case with this approach. See following link for more information.
> https://lkml.org/lkml/2013/8/7/142

That seems to be unrelated to hugetlb_instantiation_mutex?

> And we need 1-3 patches to prevent other theorectical race issue
> regardless any approaches.

Yes, I'll be going through patches 1-12 very soon, thanks.


And to reiterate: I'm very uncomfortable mucking around with
performance patches when we have run no tests to measure their
magnitude, or even whether they are beneficial at all!
