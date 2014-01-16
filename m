Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752656AbaAPMGX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 07:06:23 -0500
Received: from merlin.infradead.org ([205.233.59.134]:35429 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520AbaAPMGV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 07:06:21 -0500
Date: Thu, 16 Jan 2014 13:05:59 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Jason Low <jason.low2@hp.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Waiman Long <Waiman.Long@hp.com>, Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Davidlohr Bueso <davidlohr@hp.com>, Peter Anvin <hpa@zytor.com>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: Re: [RFC 3/3] mutex: When there is no owner, stop spinning after too
 many tries
Message-ID: <20140116120559.GO31570@twins.programming.kicks-ass.net>
References: <1389745990-7069-1-git-send-email-jason.low2@hp.com>
 <1389745990-7069-4-git-send-email-jason.low2@hp.com>
 <1389840330.2944.104.camel@j-VirtualBox>
 <CA+55aFwszXHtjOW53eBLV4aMD-cv0dg7xyBa0BtN1LS4XajwLw@mail.gmail.com>
 <1389854777.2126.20.camel@j-VirtualBox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389854777.2126.20.camel@j-VirtualBox>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 15, 2014 at 10:46:17PM -0800, Jason Low wrote:
> On Thu, 2014-01-16 at 10:14 +0700, Linus Torvalds wrote:
> > On Thu, Jan 16, 2014 at 9:45 AM, Jason Low <jason.low2@hp.com> wrote:
> > >
> > > Any comments on the below change which unlocks the mutex before taking
> > > the lock->wait_lock to wake up a waiter? Thanks.
> > 
> > Hmm. Doesn't that mean that a new lock owner can come in *before*
> > you've called debug_mutex_unlock and the lockdep stuff, and get the
> > lock? And then debug_mutex_lock() will be called *before* the unlocker
> > called debug_mutex_unlock(), which I'm sure confuses things.
> 
> If obtaining the wait_lock for debug_mutex_unlock is the issue, then
> perhaps we can address that by taking care of
> #ifdef CONFIG_DEBUG_MUTEXES. In the CONFIG_DEBUG_MUTEXES case, we can
> take the wait_lock first, and in the regular case, take the wait_lock
> after releasing the mutex.

I think we're already good for DEBUG_MUTEXES, because DEBUG_MUTEXES has
to work for archs that have !__mutex_slowpath_needs_to_unlock() and also
the DEBUG_MUTEXES code is entirely serialized on ->wait_lock.

Note that we cannot do the optimistic spinning for DEBUG_MUTEXES exactly
because of this reason.


