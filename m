Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030315Ab3LTOCA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 09:02:00 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48852 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030189Ab3LTOB7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 09:01:59 -0500
Date: Fri, 20 Dec 2013 14:01:53 +0000
From: Mel Gorman <mgorman@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>, Rik van Riel <riel@redhat.com>,
        Michal Hocko <mhocko@suse.cz>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        David Gibson <david@gibson.dropbear.id.au>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Joonsoo Kim <js1304@gmail.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Hillf Danton <dhillf@gmail.com>
Subject: Re: [PATCH v3 13/14] mm, hugetlb: retry if failed to allocate and
 there is concurrent user
Message-ID: <20131220140153.GC11295@suse.de>
References: <1387349640-8071-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1387349640-8071-14-git-send-email-iamjoonsoo.kim@lge.com>
 <20131219170202.0df2d82a2adefa3ab616bdaa@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20131219170202.0df2d82a2adefa3ab616bdaa@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 19, 2013 at 05:02:02PM -0800, Andrew Morton wrote:
> On Wed, 18 Dec 2013 15:53:59 +0900 Joonsoo Kim <iamjoonsoo.kim@lge.com> wrote:
> 
> > If parallel fault occur, we can fail to allocate a hugepage,
> > because many threads dequeue a hugepage to handle a fault of same address.
> > This makes reserved pool shortage just for a little while and this cause
> > faulting thread who can get hugepages to get a SIGBUS signal.
> > 
> > To solve this problem, we already have a nice solution, that is,
> > a hugetlb_instantiation_mutex. This blocks other threads to dive into
> > a fault handler. This solve the problem clearly, but it introduce
> > performance degradation, because it serialize all fault handling.
> > 
> > Now, I try to remove a hugetlb_instantiation_mutex to get rid of
> > performance degradation.
> 
> So the whole point of the patch is to improve performance, but the
> changelog doesn't include any performance measurements!
> 

I don't really deal with hugetlbfs any more and I have not examined this
series but I remember why I never really cared about this mutex. It wrecks
fault scalability but AFAIK fault scalability almost never mattered for
workloads using hugetlbfs.  The most common user of hugetlbfs by far is
sysv shared memory. The memory is faulted early in the lifetime of the
workload and after that it does not matter. At worst, it hurts application
startup time but that is still poor motivation for putting a lot of work
into removing the mutex.

Microbenchmarks will be able to trigger problems in this area but it'd
be important to check if any workload that matters is actually hitting
that problem.

-- 
Mel Gorman
SUSE Labs
