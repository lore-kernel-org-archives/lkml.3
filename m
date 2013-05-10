Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756258Ab3EJQWx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 12:22:53 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:59586
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755936Ab3EJQWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 12:22:53 -0400
Date: Fri, 10 May 2013 18:21:15 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: torvalds@linux-foundation.org, mingo@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 7/9] liblockdep: Support using LD_PRELOAD
Message-ID: <20130510162115.GB885@dyad.programming.kicks-ass.net>
References: <1368115089-8909-1-git-send-email-sasha.levin@oracle.com>
 <1368115089-8909-8-git-send-email-sasha.levin@oracle.com>
 <20130510135716.GA304@dyad.programming.kicks-ass.net>
 <518D1B16.9080904@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <518D1B16.9080904@oracle.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 10, 2013 at 12:06:46PM -0400, Sasha Levin wrote:
> On 05/10/2013 09:57 AM, Peter Zijlstra wrote:
> > So you're doing instance tracking and not creating classes like the kernel
> > lockdep does? While that reduces false positives it also greatly reduces the
> > effectiveness of lockdep.
> > 
> > The power of lock-classes is that it increases the chance of catching potential
> > deadlocks without there ever actually being a deadlock.
> 
> Originally I had classes working as you've pointed out, until the first time I've
> tried running lockdep on qemu.
> 
> They appear to have wrappers for every api call known to man, including all the
> posix locking apis.
> 
> Basically, instead of directly calling pthread_mutex_lock() for example, there's
> a wrapper named qemu_mutex_lock() that calls the api above:
> 
> 	void qemu_mutex_lock(QemuMutex *mutex)
> 	{
> 	    int err;
> 	
> 	    err = pthread_mutex_lock(&mutex->lock);
> 	    if (err)
> 	        error_exit(err, __func__);
> 	}
> 
> So as you might imagine, the first time I ran it my log exploded with warnings.
> 
> I've poked around the source of other big projects, and the example above is
> somewhat common with projects that wrap everything to be compatible with different
> architectures or apis - which is something that doesn't happen in the kernel.

Urgh.. yes that might be a problem. Still it is something that should at least
be clearly stated somewhere (the Changelog for one).

Not being able to do classes sucks though :/

Hmm, we could do something like:

  $ LIBLOCKDEP_CLASS_DEPTH=n LD_PRELOAD=liblockdep.so my_app

where an @n of -1 would indicate per-instance classes and 0+ would be the
__builtin_return_address(n). That way, the above qemu thing should work with 1;
which should be the return address of the wrapper.

Of course, projects mixing different wrapper depths will be immense 'fun' :/

We could make it even worse and make the depth depend on the DSO name.. /me
runs like crazeh :-)
