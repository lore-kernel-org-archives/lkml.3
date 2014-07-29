Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752898AbaG2IU0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 04:20:26 -0400
Received: from lgeamrelo04.lge.com ([156.147.1.127]:42959 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752873AbaG2IUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 04:20:23 -0400
X-Original-SENDERIP: 10.177.220.145
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
Date: Tue, 29 Jul 2014 17:27:14 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: David Rientjes <rientjes@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@vger.kernel.org,
        Minchan Kim <minchan@kernel.org>,
        Michal Nazarewicz <mina86@mina86.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Subject: Re: [PATCH v5 07/14] mm, compaction: khugepaged should not give up
 due to need_resched()
Message-ID: <20140729082714.GD1610@js1304-P5Q-DELUXE>
References: <1406553101-29326-1-git-send-email-vbabka@suse.cz>
 <1406553101-29326-8-git-send-email-vbabka@suse.cz>
 <20140729065327.GB1610@js1304-P5Q-DELUXE>
 <alpine.DEB.2.02.1407290024550.7998@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1407290024550.7998@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2014 at 12:31:13AM -0700, David Rientjes wrote:
> On Tue, 29 Jul 2014, Joonsoo Kim wrote:
> 
> > I have a silly question here.
> > Why need_resched() is criteria to stop async compaction?
> > need_resched() is flagged up when time slice runs out or other reasons.
> > It means that we should stop async compaction at arbitrary timing
> > because process can be on compaction code at arbitrary moment. I think
> > that it isn't reasonable and it doesn't ensure anything. Instead of
> > this approach, how about doing compaction on certain amounts of pageblock
> > for async compaction?
> > 
> 
> Not a silly question at all, I had the same feeling in 
> https://lkml.org/lkml/2014/5/21/730 and proposed it to be a tunable that 
> indicates how much work we are willing to do for thp in the pagefault 
> path.  It suffers from the fact that past failure to isolate and/or 

Oh... you already suggested the same idea.

> migrate memory to free an entire pageblock doesn't indicate that the next 
> pageblock will fail as well, but there has to be cutoff at some point or 
> async compaction becomes unnecessarily expensive.  We can always rely on 
> khugepaged later to do the collapse, assuming we're not faulting memory 
> and then immediately pinning it.
> 
> I think there's two ways to go about it:
> 
>  - allow a single thp fault to be expensive and then rely on deferred
>    compaction to avoid subsequent calls in the near future, or
> 
>  - try to make all thp faults be as least expensive as possible so that
>    the cumulative effect of faulting large amounts of memory doesn't end
>    up with lengthy stalls.

Hmm, if thp faults want to pay cost as least as possible, how about
making thp faults skip async/sync compaction at all?

Thanks.
