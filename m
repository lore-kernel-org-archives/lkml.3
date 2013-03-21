Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753389Ab3CUVrl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 17:47:41 -0400
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:40639 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752977Ab3CUVrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 17:47:40 -0400
Message-ID: <1363902452.4488.31.camel@thor.lan>
Subject: Re: ipc,sem: sysv semaphore scalability
From: Peter Hurley <peter@hurleysoftware.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rik van Riel <riel@surriel.com>, torvalds@linux-foundation.org,
        davidlohr.bueso@hp.com, linux-kernel@vger.kernel.org,
        hhuang@redhat.com, jason.low2@hp.com, walken@google.com,
        lwoodman@redhat.com, chegu_vinod@hp.com, Dave Jones <davej@redhat.com>
Date: Thu, 21 Mar 2013 17:47:32 -0400
In-Reply-To: <20130321141058.76e028e492f98f6ee6e60353@linux-foundation.org>
References: <1363809337-29718-1-git-send-email-riel@surriel.com>
	 <20130321141058.76e028e492f98f6ee6e60353@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3-0pjh1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-03-21 at 14:10 -0700, Andrew Morton wrote:
> On Wed, 20 Mar 2013 15:55:30 -0400 Rik van Riel <riel@surriel.com> wrote:
> 
> > This series makes the sysv semaphore code more scalable,
> > by reducing the time the semaphore lock is held, and making
> > the locking more scalable for semaphore arrays with multiple
> > semaphores.
> > 
> > The first four patches were written by Davidlohr Buesso, and
> > reduce the hold time of the semaphore lock.
> > 
> > The last three patches change the sysv semaphore code locking
> > to be more fine grained, providing a performance boost when
> > multiple semaphores in a semaphore array are being manipulated
> > simultaneously.
> 
> These patches conflict pretty badly with Peter's:
> 
> ipc-clamp-with-min.patch
> ipc-separate-msg-allocation-from-userspace-copy.patch
> ipc-tighten-msg-copy-loops.patch
> ipc-set-efault-as-default-error-in-load_msg.patch
> ipc-remove-msg-handling-from-queue-scan.patch
> ipc-implement-msg_copy-as-a-new-receive-mode.patch
> ipc-simplify-msg-list-search.patch
> ipc-refactor-msg-list-search-into-separate-function.patch
> ipc-refactor-msg-list-search-into-separate-function-fix.patch
> 
> (they're at http://ozlabs.org/~akpm/mmots/broken-out/)
> 
> 
> 
> We're in a bit of a mess at present.
> 
> Last month Peter sent a ten-patch series which fixed an oops (Subject:
> "ipc MSG_COPY fixes").  The series did other stuff, so we merged into
> mainline just two bugfix patches.  Then davej hit a trinity oops
> (Subject: "ipc/testmsg GPF.") and testing confirmed that the remaining
> eight patches in Peter's series fixed that up.

Just to clarify the history.

A while back on linux-next both Dave and I were hitting ipc oopses on
trinity, which was fallout from the MSG_COPY implementation.

One of those oopses was the ipc/testmsg oops.

I was trying to push out the new tty ldisc patchset and trinity is a
decent tool for exploring race conditions (which the tty layer was full
of), so the oopses were in my way.

Because it was nearly impossible to static analyze the existing ipc
code, I just started cleaning up. As I did, I found the two
by-then-obvious bug fixes. Also, assigning the 'msg' variable in the
search loop looked suspicious so I factored that search loop out as
well. That was the whole 10-patch "ipc MSG_COPY fixes" series.

I wasn't getting the ipc/testmsg bug anymore and I let Dave know, so all
was good.

When Andrew asked me if the whole series needed to go into 3.9, I said I
didn't know.

So when just the 2 of 10 patches went in, Dave started to hit the
ipc/testmsg bug again on 3.9.

> Nobody has yet
> identified which of the eight does the good deed.  So we need to
> either:
> 
> a) revert the original two fixes "ipc: fix potential oops when src
>    msg > 4k w/ MSG_COPY" and "ipc: don't allocate a copy larger than
>    max" or 
> 
> b) try reverting "ipc: don't allocate a copy larger than max", as
>    "ipc: fix potential oops when src msg > 4k w/ MSG_COPY" looks pretty
>    harmless or
> 
> c) work out which of the remaining 8 fixes the new oops and merge that or
> 
> d) merge all 8 fixes or
> 
> e) something else.


The fix is in the other 8 patches. But I have to say, the base code was
such a mess I have no idea which of the other 8 patches fixes the
ipc/testmsg oops or how.

I guarantee reverting those 2 fixes from my series will not make the
ipc/testmsg oops go away.


> Whichever way we go, we should get a wiggle on - this has been hanging
> around for too long.  Dave, do you have time to determine whether
> reverting 88b9e456b1649722673ff ("ipc: don't allocate a copy larger
> than max") fixes things up?



