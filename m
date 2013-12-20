Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756565Ab3LTCb0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 21:31:26 -0500
Received: from g4t0017.houston.hp.com ([15.201.24.20]:14760 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753830Ab3LTCbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 21:31:25 -0500
Message-ID: <1387506681.8363.55.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH v3 13/14] mm, hugetlb: retry if failed to allocate and
 there is concurrent user
From: Davidlohr Bueso <davidlohr@hp.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@suse.cz>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        David Gibson <david@gibson.dropbear.id.au>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Joonsoo Kim <js1304@gmail.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Hillf Danton <dhillf@gmail.com>
Date: Thu, 19 Dec 2013 18:31:21 -0800
In-Reply-To: <20131219170202.0df2d82a2adefa3ab616bdaa@linux-foundation.org>
References: <1387349640-8071-1-git-send-email-iamjoonsoo.kim@lge.com>
	 <1387349640-8071-14-git-send-email-iamjoonsoo.kim@lge.com>
	 <20131219170202.0df2d82a2adefa3ab616bdaa@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-12-19 at 17:02 -0800, Andrew Morton wrote:
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
> Please, run some quantitative tests and include a nice summary of the
> results in the changelog.

I was actually spending this afternoon testing these patches with Oracle
(I haven't seen any issues so far) and unless Joonsoo already did so, I
want to run these by the libhugetlb test cases - I got side tracked by
futexes though :/

Please do consider that performance wise I haven't seen much in
particular. The thing is, I started dealing with this mutex once I
noticed it as the #1 hot lock in Oracle DB starts, but then once the
faults are done, it really goes away. So I wouldn't say that the mutex
is a bottleneck except for the first few minutes.

> 
> This is terribly important, because if the performance benefit is
> infinitesimally small or negative, the patch goes into the bit bucket ;)

Well, this mutex is infinitesimally ugly and needs to die (as long as
performance isn't hurt).

Thanks,
Davidlohr

