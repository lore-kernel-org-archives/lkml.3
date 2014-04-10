Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934989AbaDJJQd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 05:16:33 -0400
Received: from mta-out.inet.fi ([195.156.147.13]:54636 "EHLO jenni2.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933057AbaDJJQ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 05:16:28 -0400
Date: Thu, 10 Apr 2014 12:15:44 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Jason Low <jason.low2@hp.com>
Cc: "Michael L. Semon" <mlsemon35@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: 3.14.0+/x86: lockdep and mutexes not getting along
Message-ID: <20140410091544.GA23433@node.dhcp.inet.fi>
References: <alpine.LNX.2.11.1404060059020.8208@bpserver.ds>
 <20140409121940.GA12890@node.dhcp.inet.fi>
 <1397108579.2586.15.camel@j-VirtualBox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397108579.2586.15.camel@j-VirtualBox>
User-Agent: Mutt/1.5.22.1-rc1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 09, 2014 at 10:42:59PM -0700, Jason Low wrote:
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

I'm not able to trigger the lockdep report with the patch applied so far.

-- 
 Kirill A. Shutemov
