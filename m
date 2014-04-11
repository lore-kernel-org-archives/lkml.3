Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758701AbaDKNlf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 09:41:35 -0400
Received: from mail-yk0-f171.google.com ([209.85.160.171]:36548 "EHLO
	mail-yk0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756539AbaDKNl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 09:41:29 -0400
Date: Fri, 11 Apr 2014 09:41:19 -0400 (EDT)
From: "Michael L. Semon" <mlsemon35@gmail.com>
To: Jason Low <jason.low2@hp.com>
cc: "Kirill A. Shutemov" <kirill@shutemov.name>,
        "Michael L. Semon" <mlsemon35@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org
Subject: Re: 3.14.0+/x86: lockdep and mutexes not getting along
In-Reply-To: <1397108579.2586.15.camel@j-VirtualBox>
Message-ID: <alpine.LNX.2.11.1404110923200.3964@bpserver.ds>
References: <alpine.LNX.2.11.1404060059020.8208@bpserver.ds> <20140409121940.GA12890@node.dhcp.inet.fi> <1397108579.2586.15.camel@j-VirtualBox>
User-Agent: Alpine 2.11 (LNX 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Apr 2014, Jason Low wrote:

> On Wed, 2014-04-09 at 15:19 +0300, Kirill A. Shutemov wrote:
> > On Sun, Apr 06, 2014 at 01:12:14AM -0400, Michael L. Semon wrote:
> > > Hi!  Starting early in this merge window for 3.15, lockdep has been
> > > giving me trouble.  Normally, a splat will happen, lockdep will shut
> > > itself off, and my i686 Pentium 4 PC will continue.  Now, after the
> > > splat, it will allow one key of input at either a VGA console or over
> > > serial.  After that, only the magic SysRq keys and KDB still work.
> > > File activity stops, and many processes are stuck in the D state.
> > > 
> > > Bisect brought me here:
> > > 
> > > root@plbearer:/usr/src/kernel-git/linux# git bisect good
> > > 6f008e72cd111a119b5d8de8c5438d892aae99eb is the first bad commit
> > > commit 6f008e72cd111a119b5d8de8c5438d892aae99eb
> > > Author: Peter Zijlstra <peterz@infradead.org>
> > > Date:   Wed Mar 12 13:24:42 2014 +0100
> > > 
> > >     locking/mutex: Fix debug checks
> > > 
> > >     OK, so commit:
> > > 
> > >       1d8fe7dc8078 ("locking/mutexes: Unlock the mutex without the wait_lock")
> > > 
> > >     generates this boot warning when CONFIG_DEBUG_MUTEXES=y:
> > > 
> > >       WARNING: CPU: 0 PID: 139 at /usr/src/linux-2.6/kernel/locking/mutex-debug.c:82 debug_mutex_unlock+0x155/0x180() DEBUG_LOCKS_WARN_ON(lock->owner != current)
> > > 
> > >     And that makes sense, because as soon as we release the lock a
> > >     new owner can come in...
> > > 
> > >     One would think that !__mutex_slowpath_needs_to_unlock()
> > >     implementations suffer the same, but for DEBUG we fall back to
> > >     mutex-null.h which has an unconditional 1 for that.
> > > 
> > >     The mutex debug code requires the mutex to be unlocked after
> > >     doing the debug checks, otherwise it can find inconsistent
> > >     state.
> > > 
> > >     Reported-by: Ingo Molnar <mingo@kernel.org>
> > >     Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> > >     Cc: jason.low2@hp.com
> 
> Hello,
> 
> As a starting point, would either of you like to test the following
> patch to see if it fixes the issue? This patch essentially generates the
> same code as in older kernels in the debug case. This applies on top of
> kernels with both commits 6f008e72cd11 and 1d8fe7dc8078.
> 
> Thanks.
> 
> -----
> diff --git a/kernel/locking/mutex-debug.c b/kernel/locking/mutex-debug.c
> index e1191c9..faf6f5b 100644
> --- a/kernel/locking/mutex-debug.c
> +++ b/kernel/locking/mutex-debug.c
> @@ -83,12 +83,6 @@ void debug_mutex_unlock(struct mutex *lock)
>  
>  	DEBUG_LOCKS_WARN_ON(!lock->wait_list.prev && !lock->wait_list.next);
>  	mutex_clear_owner(lock);
> -
> -	/*
> -	 * __mutex_slowpath_needs_to_unlock() is explicitly 0 for debug
> -	 * mutexes so that we can do it here after we've verified state.
> -	 */
> -	atomic_set(&lock->count, 1);
>  }
>  
>  void debug_mutex_init(struct mutex *lock, const char *name,
> diff --git a/kernel/locking/mutex.c b/kernel/locking/mutex.c
> index bc73d33..f1f672e 100644
> --- a/kernel/locking/mutex.c
> +++ b/kernel/locking/mutex.c
> @@ -34,13 +34,6 @@
>  #ifdef CONFIG_DEBUG_MUTEXES
>  # include "mutex-debug.h"
>  # include <asm-generic/mutex-null.h>
> -/*
> - * Must be 0 for the debug case so we do not do the unlock outside of the
> - * wait_lock region. debug_mutex_unlock() will do the actual unlock in this
> - * case.
> - */
> -# undef __mutex_slowpath_needs_to_unlock
> -# define  __mutex_slowpath_needs_to_unlock()	0
>  #else
>  # include "mutex.h"
>  # include <asm/mutex.h>
> @@ -688,6 +681,17 @@ __mutex_unlock_common_slowpath(atomic_t *lock_count, int nested)
>  	unsigned long flags;
>  
>  	/*
> +	 * In the debug cases, obtain the wait_lock first
> +	 * before calling the following debugging functions.
> +	 */
> +#if defined(CONFIG_DEBUG_MUTEXES) || defined(CONFIG_DEBUG_LOCK_ALLOC)
> +	spin_lock_mutex(&lock->wait_lock, flags);
> +#endif
> +
> +	mutex_release(&lock->dep_map, nested, _RET_IP_);
> +	debug_mutex_unlock(lock);
> +
> +	/*
>  	 * some architectures leave the lock unlocked in the fastpath failure
>  	 * case, others need to leave it locked. In the later case we have to
>  	 * unlock it here
> @@ -695,9 +699,9 @@ __mutex_unlock_common_slowpath(atomic_t *lock_count, int nested)
>  	if (__mutex_slowpath_needs_to_unlock())
>  		atomic_set(&lock->count, 1);
>  
> +#if !defined(CONFIG_DEBUG_MUTEXES) && !defined(CONFIG_DEBUG_LOCK_ALLOC)
>  	spin_lock_mutex(&lock->wait_lock, flags);
> -	mutex_release(&lock->dep_map, nested, _RET_IP_);
> -	debug_mutex_unlock(lock);
> +#endif
>  
>  	if (!list_empty(&lock->wait_list)) {
>  		/* get the first entry from the wait-list: */
> 
> 
> 

This works and was given an overnight xfstests run on XFS to prove
itself.  The other patch worked, too, but it was sent on a failing
mission to find an elusive JFS lockdep splat by find'ing, untarring,
and fs_mark'ing everything in sight.  The other patch did fine on 
the original xfstests generic/113 on devel/debug XFS.

Thanks!

Michael
