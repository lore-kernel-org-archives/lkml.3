Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753349Ab3J3Ipn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 04:45:43 -0400
Received: from www.linutronix.de ([62.245.132.108]:59590 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752700Ab3J3Ipl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 04:45:41 -0400
Date: Wed, 30 Oct 2013 09:45:31 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Mel Gorman <mgorman@suse.de>
cc: Peter Zijlstra <peterz@infradead.org>,
        Chris Mason <chris.mason@fusionio.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] futex: Remove requirement for lock_page in
 get_futex_key
In-Reply-To: <20131029173814.GH2400@suse.de>
Message-ID: <alpine.DEB.2.02.1310300929420.19212@ionos.tec.linutronix.de>
References: <20131029173814.GH2400@suse.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Oct 2013, Mel Gorman wrote:

> Thomas Gleixner and Peter Zijlstra discussed off-list that real-time users
> currently have a problem with the page lock being contended for unbounded
> periods of time during futex operations. The three of us discussed the
> possibiltity that the page lock is unnecessary in this case because we are
> not concerned with the usual races with reclaim and page cache updates. For
> anonymous pages, the associated futex object is the mm_struct which does
> not require the page lock. For inodes, we should be able to check under
> RCU read lock if the page mapping is still valid to take a reference to
> the inode.  This just leaves one rare race that requires the page lock
> in the slow path. This patch does not completely eliminate the page lock
> but it should reduce contention in the majority of cases.
> 
> Patch boots and futextest did not explode but I did no comparison
> performance tests. Thomas, do you have details of the workload that
> drove you to examine this problem? Alternatively, can you test it and

The scenario is simple. All you need is a PSHARED futex.

Task A 
     get_futex_key()
     lock_page()

---> preemption

Now any other task trying to lock that page will have to wait until
task A gets scheduled back in, which is an unbound time.

It takes quite some time to reproduce, but I'll ask the people who
have that workload to give it a try.

Thanks,

	tglx
