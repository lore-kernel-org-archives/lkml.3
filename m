Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757793Ab3FMVGg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 17:06:36 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37787 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751999Ab3FMVGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 17:06:35 -0400
Date: Thu, 13 Jun 2013 14:06:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: torvalds@linux-foundation.org, roland@kernel.org, mingo@kernel.org,
        tglx@linutronix.de, kosaki.motohiro@gmail.com, penberg@kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-rdma@vger.kernel.org, Mike Marciniszyn <infinipath@intel.com>
Subject: Re: [PATCH] mm: Revert pinned_vm braindamage
Message-Id: <20130613140632.15982af2ebc443b24bfff86a@linux-foundation.org>
In-Reply-To: <20130606124351.GZ27176@twins.programming.kicks-ass.net>
References: <20130606124351.GZ27176@twins.programming.kicks-ass.net>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let's try to get this wrapped up?

On Thu, 6 Jun 2013 14:43:51 +0200 Peter Zijlstra <peterz@infradead.org> wrote:

> 
> Patch bc3e53f682 ("mm: distinguish between mlocked and pinned pages")
> broke RLIMIT_MEMLOCK.

I rather like what bc3e53f682 did, actually.  RLIMIT_MEMLOCK limits the
amount of memory you can mlock().  Nice and simple.

This pinning thing which infiniband/perf are doing is conceptually
different and if we care at all, perhaps we should be looking at adding
RLIMIT_PINNED.

> Before that patch: mm_struct::locked_vm < RLIMIT_MEMLOCK; after that
> patch we have: mm_struct::locked_vm < RLIMIT_MEMLOCK &&
> mm_struct::pinned_vm < RLIMIT_MEMLOCK.

But this is a policy decision which was implemented in perf_mmap() and
perf can alter that decision.  How bad would it be if perf just ignored
RLIMIT_MEMLOCK?


drivers/infiniband/hw/qib/qib_user_pages.c has issues, btw.  It
compares the amount-to-be-pinned with rlimit(RLIMIT_MEMLOCK), but
forgets to also look at current->mm->pinned_vm.  Duh.

It also does the pinned accounting in __qib_get_user_pages() but in
__qib_release_user_pages(), the caller is supposed to do it, which is
rather awkward.


Longer-term I don't think that inifinband or perf should be dinking
around with rlimit(RLIMIT_MEMLOCK) or ->pinned_vm.  Those policy
decisions should be hoisted into a core mm helper where we can do it
uniformly (and more correctly than infiniband's attempt!).

