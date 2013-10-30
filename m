Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753175Ab3J3J0Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 05:26:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39416 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752579Ab3J3J0P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 05:26:15 -0400
Date: Wed, 30 Oct 2013 09:26:11 +0000
From: Mel Gorman <mgorman@suse.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Chris Mason <chris.mason@fusionio.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] futex: Remove requirement for lock_page in
 get_futex_key
Message-ID: <20131030092611.GJ2400@suse.de>
References: <20131029173814.GH2400@suse.de>
 <alpine.DEB.2.02.1310300929420.19212@ionos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1310300929420.19212@ionos.tec.linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 30, 2013 at 09:45:31AM +0100, Thomas Gleixner wrote:
> On Tue, 29 Oct 2013, Mel Gorman wrote:
> 
> > Thomas Gleixner and Peter Zijlstra discussed off-list that real-time users
> > currently have a problem with the page lock being contended for unbounded
> > periods of time during futex operations. The three of us discussed the
> > possibiltity that the page lock is unnecessary in this case because we are
> > not concerned with the usual races with reclaim and page cache updates. For
> > anonymous pages, the associated futex object is the mm_struct which does
> > not require the page lock. For inodes, we should be able to check under
> > RCU read lock if the page mapping is still valid to take a reference to
> > the inode.  This just leaves one rare race that requires the page lock
> > in the slow path. This patch does not completely eliminate the page lock
> > but it should reduce contention in the majority of cases.
> > 
> > Patch boots and futextest did not explode but I did no comparison
> > performance tests. Thomas, do you have details of the workload that
> > drove you to examine this problem? Alternatively, can you test it and
> 
> The scenario is simple. All you need is a PSHARED futex.
> 
> Task A 
>      get_futex_key()
>      lock_page()
> 
> ---> preemption
> 

Ok, so scaling numbers of threads doing something like multiple
consumers using FUTEX_WAIT and then all being woken should trigger it.
Should not be that hard to device a test if something in futextest does
not do it alreayd.

> Now any other task trying to lock that page will have to wait until
> task A gets scheduled back in, which is an unbound time.
> 
> It takes quite some time to reproduce, but I'll ask the people who
> have that workload to give it a try.
> 

Do please. I'd rather not sink time into trying to reproduce a hypothetical
problem when people who are already familiar with it can provide better
data. If it stays quiet for too long then I'll either use an existing
futextest, extend futextest or conclude that the problem was not major
in the first place if the users cannot be arsed testing a patch.

Thanks.

-- 
Mel Gorman
SUSE Labs
