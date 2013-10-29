Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752226Ab3J2Ssg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 14:48:36 -0400
Received: from dkim1.fusionio.com ([66.114.96.53]:40523 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469Ab3J2Sse convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 14:48:34 -0400
X-ASG-Debug-ID: 1383072513-03d6a54d1a59c20001-xx1T2L
X-Barracuda-Envelope-From: clmason@fusionio.com
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Mel Gorman <mgorman@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>
From: Chris Mason <chris.mason@fusionio.com>
In-Reply-To: <20131029173814.GH2400@suse.de>
CC: LKML <linux-kernel@vger.kernel.org>
References: <20131029173814.GH2400@suse.de>
Message-ID: <20131029184827.10719.27487@localhost.localdomain>
User-Agent: alot/0.3.4
Subject: Re: [RFC PATCH] futex: Remove requirement for lock_page in get_futex_key
Date: Tue, 29 Oct 2013 14:48:27 -0400
X-ASG-Orig-Subj: Re: [RFC PATCH] futex: Remove requirement for lock_page in get_futex_key
X-Originating-IP: [10.101.1.160]
X-Barracuda-Connect: cas1.int.fusionio.com[10.101.1.40]
X-Barracuda-Start-Time: 1383072513
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 1
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0001 1.0000 -2.0204
X-Barracuda-Spam-Score: -2.02
X-Barracuda-Spam-Status: No, SCORE=-2.02 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.141888
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Mel Gorman (2013-10-29 13:38:14)
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
> see does it help you? I added Chris to the To list because he mentioned
> that some filesystems might already be doing tricks similar to this
> patch that are worth copying.

Unfortunately, all the special cases I see in the filesystems either
have an inode ref or are trylocking the page to safety.

XFS is a special case because they have their own inode cache, but by my
reading they are still using i_count and free by rcu.

The iput in here is a little tricky:

> 
> +               /* Should be impossible but lets be paranoid for now */
> +               if (WARN_ON(inode->i_mapping != mapping)) {
> +                       rcu_read_unlock();
> +                       iput(inode);
> +                       put_page(page_head);
> +                       goto again;
> +               }
> +

Once you call iput, you add the potential to call the filesystem unlink
operation if i_nlink had gone to zero.  This shouldn't be a problem
since you've dropped the rcu lock, but just for fun I'd move the
put_page up a line.

Or, change it to a BUG_ON instead, it really should be impossible.

-chris

