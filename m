Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753796Ab3FNWo0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 18:44:26 -0400
Received: from mga02.intel.com ([134.134.136.20]:33367 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752942Ab3FNWoZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 18:44:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,868,1363158000"; 
   d="scan'208";a="353717089"
Subject: Re: Performance regression from switching lock to rw-sem for
 anon-vma tree
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Davidlohr Bueso <davidlohr.bueso@hp.com>
Cc: Ingo Molnar <mingo@elte.hu>, Rik van Riel <riel@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>, Mel Gorman <mgorman@suse.de>,
        "Shi, Alex" <alex.shi@intel.com>, Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michel Lespinasse <walken@google.com>,
        "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>,
        Dave Hansen <dave.hansen@intel.com>, linux-kernel@vger.kernel.org,
        linux-mm <linux-mm@kvack.org>
In-Reply-To: <1371249104.1758.20.camel@buesod1.americas.hpqcorp.net>
References: <1371165333.27102.568.camel@schen9-DESK>
	 <1371167015.1754.14.camel@buesod1.americas.hpqcorp.net>
	 <1371226197.27102.594.camel@schen9-DESK>
	 <1371249104.1758.20.camel@buesod1.americas.hpqcorp.net>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 14 Jun 2013 15:44:28 -0700
Message-ID: <1371249868.27102.607.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> Unfortunately this patch didn't make any difference, in fact it hurt
> several of the workloads even more. I also tried disabling preemption
> when spinning on owner to actually resemble spinlocks, which was my
> original plan, yet not much difference. 
> 

That's also similar to the performance I got.  There are things about
optimistic spinning that I missed that results in the better mutex
performance.  So I'm scratching my head.

> A few ideas that come to mind are avoiding taking the ->wait_lock and
> avoid dealing with waiters when doing the optimistic spinning (just like
> mutexes do).
> 

For my patch, we actually spin without the wait_lock.

> I agree that we should first deal with the optimistic spinning before
> adding the MCS complexity.
> 
> > Matthew and I have also discussed possibly introducing some 
> > limited spinning for writer when semaphore is held by read.  
> > His idea was to have readers as well as writers set ->owner.  
> > Writers, as now, unconditionally clear owner.  Readers clear 
> > owner if sem->owner == current.  Writers spin on ->owner if ->owner 
> > is non-NULL and still active. That gives us a reasonable chance 
> > to spin since we'll be spinning on
> > the most recent acquirer of the lock.
> 
> I also tried implementing this concept on top of your patch, didn't make
> much of a difference with or without it. 
> 

It also didn't make a difference for me.

Tim

