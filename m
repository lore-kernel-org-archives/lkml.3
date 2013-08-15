Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751618Ab3HOUoh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 16:44:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15508 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750901Ab3HOUof (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 16:44:35 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20130815193203.GT17781@fieldses.org>
References: <20130815193203.GT17781@fieldses.org> <1373310444-25862-1-git-send-email-jlayton@redhat.com> <1376482310-7348-1-git-send-email-jlayton@redhat.com>
To: Bruce Fields <bfields@fieldses.org>, paulmck@linux.vnet.ibm.com
Cc: dhowells@redhat.com, Jeff Layton <jlayton@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>
Subject: memory barriers in flock (Re: [PATCH v3] locks: close potential race between setlease and open)
Date: Thu, 15 Aug 2013 21:44:25 +0100
Message-ID: <23198.1376599465@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bruce Fields <bfields@fieldses.org> wrote:

(Adding Paul McKenney who's good at this stuff)

> > v2:
> > - fix potential double-free of lease if second check finds conflict
> > - add smp_mb's to ensure that other CPUs see i_flock changes
> > 
> > v3:
> > - remove smp_mb calls. Partial ordering is unlikely to help here.
> 
> Forgive me here, I still don't understand.  So to simplify massively,
> the situation looks like:
>
> 	setlease		open
> 	------------		------
> 
> 	atomic_read		atomic_inc
> 	write i_flock		read i_flock
> 	atomic_read

Are the three atomic ops reading the same value?  If so, you can have smp_mb()
calls here:

	atomic_read		atomic_inc
				smp_mb()
	write i_flock		read i_flock
	smp_mb()
 	atomic_read

I *think* that memory accesses in one place need to be reverse-ordered wrt to
those in the other place, so:

	atomic_read		atomic_inc
	smp_mb()		smp_mb()
	write i_flock		read i_flock
 	atomic_read

doesn't achieve anything.

> And we want to be sure that either the setlease caller sees the result
> of the atomic_inc, or the opener sees the result of the write to
> i_flock.
> 
> As an example, suppose the above steps happen in the order:
> 
> 	atomic_read [A]
> 	write i_flock [B]
> 	atomic_read [C]
> 				atomic_inc [X]
> 				read i_flock [Y]

(I've labelled the operations for convenience)

> How do we know that the read of i_flock [Y] at the last step reflects the
> latest value of i_flock?  For example, couldn't the write still be stuck in
> first CPU's cache?

Putting in memory barriers doesn't help here.  If A, B and C are all performed
and committed to memory by the time X happens, then Y will see B, but C will
not see X.

The thing to remember is that smp_mb() is not a commit operation: it doesn't
cause a modification to be committed to memory.  The reason you use it is to
make sure the CPU actually does preceding memory ops - eg. makes the
modification in question - before it goes and does any following memory ops.

Linux requires the system to be cache-coherent, so if the write is actually
performed by a CPU then the result will be obtained by any other CPU, no
matter whether it's still lingering in the first CPU's caches or whether it's
been passed on.

-*-

However, I could be wrong.  Memory barriers are mind-bending to try and think
through, especially when it's the operations being ordered are R-W vs R-W
rather than having W-W on at least one side.

Hopefully Paul will be able to chime in

David
