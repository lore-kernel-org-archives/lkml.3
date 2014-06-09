Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755186AbaFIRiJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 13:38:09 -0400
Received: from g2t2354.austin.hp.com ([15.217.128.53]:48998 "EHLO
	g2t2354.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752220AbaFIRiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 13:38:08 -0400
Message-ID: <1402335482.6071.36.camel@j-VirtualBox>
Subject: Re: [RFC PATCH 1/3] locking/mutex: Try to acquire mutex only if it
 is unlocked
From: Jason Low <jason.low2@hp.com>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: Peter Zijlstra <peterz@infradead.org>, mingo@kernel.org,
        tglx@linutronix.de, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com,
        tim.c.chen@linux.intel.com, hpa@zytor.com, Waiman.Long@hp.com,
        aswin@hp.com, scott.norton@hp.com, chegu_vinod@hp.com
Date: Mon, 09 Jun 2014 10:38:02 -0700
In-Reply-To: <1401915499.13877.21.camel@buesod1.americas.hpqcorp.net>
References: <1401908911-8947-1-git-send-email-jason.low2@hp.com>
	 <1401908911-8947-2-git-send-email-jason.low2@hp.com>
	 <20140604194322.GN13930@laptop.programming.kicks-ass.net>
	 <1401915420.13877.20.camel@buesod1.americas.hpqcorp.net>
	 <1401915499.13877.21.camel@buesod1.americas.hpqcorp.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-06-04 at 13:58 -0700, Davidlohr Bueso wrote:
> On Wed, 2014-06-04 at 13:57 -0700, Davidlohr Bueso wrote:

> > In addition, how about the following helpers instead:
> > - mutex_is_unlocked() : count > 0
> > - mutex_has_waiters() : count < 0, or list_empty(->wait_list)
>                                       ^ err, that's !list_empty()

Between checking for (count < 0) or checking for !list_empty(wait_list)
for waiters:

Now that I think about it, I would expect a mutex_has_waiters() function
to return !list_empty(wait_list) as that really tells whether or not
there are waiters. For example, in highly contended cases, there can
still be waiters on the mutex if count is 1.

Likewise, in places where we currently use "MUTEX_SHOW_NO_WAITER", we
need to check for (count < 0) to ensure lock->count is a negative value
before the thread sleeps on the mutex.

One option would be to still remove MUTEX_SHOW_NO_WAITER(), directly use
atomic_read() in place of the macro, and just comment on why we have an
extra atomic_read() that may "appear redundant". Another option could be
to provide a function that checks for "potential waiters" on the mutex.

Any thoughts?

