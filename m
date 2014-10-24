Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756525AbaJXPvN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 11:51:13 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:55353 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752197AbaJXPvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 11:51:11 -0400
Date: Fri, 24 Oct 2014 17:51:01 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Christoph Lameter <cl@linux.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Minchan Kim <minchan@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>
Subject: Re: [RFC][PATCH 4/6] SRCU free VMAs
Message-ID: <20141024155101.GE21513@worktop.programming.kicks-ass.net>
References: <20141020215633.717315139@infradead.org>
 <20141020222841.419869904@infradead.org>
 <CA+55aFwd04q+O5ejbmDL-H7_GB6DEBMiiHkn+2R1u4uWxfDO9w@mail.gmail.com>
 <20141021080740.GJ23531@worktop.programming.kicks-ass.net>
 <alpine.DEB.2.11.1410241003430.29419@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1410241003430.29419@gentwo.org>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 24, 2014 at 10:16:24AM -0500, Christoph Lameter wrote:

> Hmmm... One optimization to do before we get into these changes is to work
> on allowing the dropping of mmap_sem before we get to sleeping and I/O and
> then reevaluate when I/O etc is complete? This is probably the longest
> hold on mmap_sem that is also frequent. Then it may be easier to use
> standard RCU later.

The hold time isn't relevant, in fact breaking up the mmap_sem such that
we require multiple acquisitions will just increase the cacheline
bouncing.

Also I think it makes more sense to continue an entire fault operation,
including blocking, if at all possible. Every retry will just waste more
time.

Also, there is a lot of possible blocking, there's lock_page,
page_mkwrite() -- which ends up calling into the dirty throttle etc. We
could not possibly retry on all that, the error paths involved would be
horrible for one.

That said, there's a fair bit of code that does allow the retry, and I
think most fault paths actually do the retry on IO.
