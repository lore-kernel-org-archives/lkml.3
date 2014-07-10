Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751051AbaGJT6E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 15:58:04 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:38521 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225AbaGJT6C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 15:58:02 -0400
Date: Thu, 10 Jul 2014 12:56:21 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Sasha Levin <sasha.levin@oracle.com>
cc: Hugh Dickins <hughd@google.com>, Peter Zijlstra <peterz@infradead.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vlastimil Babka <vbabka@suse.cz>, akpm@linux-foundation.org,
        davej@redhat.com, koct9i@gmail.com, lczerner@redhat.com,
        stable@vger.kernel.org, "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: + shmem-fix-faulting-into-a-hole-while-its-punched-take-2.patch
 added to -mm tree
In-Reply-To: <53BEE4D5.2030909@oracle.com>
Message-ID: <alpine.LSU.2.11.1407101247300.20668@eggly.anvils>
References: <53b45c9b.2rlA0uGYBLzlXEeS%akpm@linux-foundation.org> <53BCBF1F.1000506@oracle.com> <alpine.LSU.2.11.1407082309040.7374@eggly.anvils> <53BD1053.5020401@suse.cz> <53BD39FC.7040205@oracle.com> <53BD67DC.9040700@oracle.com>
 <alpine.LSU.2.11.1407092358090.18131@eggly.anvils> <53BE8B1B.3000808@oracle.com> <53BECBA4.3010508@oracle.com> <alpine.LSU.2.11.1407101033280.18934@eggly.anvils> <53BED7F6.4090502@oracle.com> <alpine.LSU.2.11.1407101131310.19154@eggly.anvils>
 <53BEE345.4090203@oracle.com> <alpine.LSU.2.11.1407101203130.19396@eggly.anvils> <53BEE4D5.2030909@oracle.com>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Jul 2014, Sasha Levin wrote:
> On 07/10/2014 03:06 PM, Hugh Dickins wrote:
> > On Thu, 10 Jul 2014, Sasha Levin wrote:
> >> > On 07/10/2014 02:52 PM, Hugh Dickins wrote:
> >>> > > On Thu, 10 Jul 2014, Sasha Levin wrote:
> >>>>> > >> > On 07/10/2014 01:55 PM, Hugh Dickins wrote:
> >>>>>>>>> > >>>> > >> And finally, (not) holding the i_mmap_mutex:
> >>>>>>> > >>> > > I don't understand what prompts you to show this particular task.
> >>>>>>> > >>> > > I imagine the dump shows lots of other tasks which are waiting to get an
> >>>>>>> > >>> > > i_mmap_mutex, and quite a lot of other tasks which are neither waiting
> >>>>>>> > >>> > > for nor holding an i_mmap_mutex.
> >>>>>>> > >>> > > 
> >>>>>>> > >>> > > Why are you showing this one in particular?  Because it looks like the
> >>>>>>> > >>> > > one you fingered yesterday?  But I didn't see a good reason to finger
> >>>>>>> > >>> > > that one either.
> >>>>> > >> > 
> >>>>> > >> > There are a few more tasks like this one, my criteria was tasks that lockdep
> >>>>> > >> > claims were holding i_mmap_mutex, but are actually not.
> >>> > > You and Vlastimil enlightened me yesterday that lockdep shows tasks as
> >>> > > holding i_mmap_mutex when they are actually waiting to get i_mmap_mutex.
> >>> > > Hundreds of those in yesterday's log, hundreds of them in today's.
> >> > 
> >> > What if we move lockdep's acquisition point to after it actually got the
> >> > lock?
> >> > 
> >> > We'd miss deadlocks, but we don't care about them right now. Anyways, doesn't
> >> > lockdep have anything built in to allow us to separate between locks which
> >> > we attempt to acquire and locks that are actually acquired?
> >> > 
> >> > (cc PeterZ)
> >> > 
> >> > We can treat locks that are in the process of being acquired the same as
> >> > acquired locks to avoid races, but when we print something out it would
> >> > be nice to have annotation of the read state of the lock.
> > I certainly hope someone can work on improving that.  I imagine it would
> > be easy, and well worth doing.  But won't be looking into it myself.
> 
> I'd be happy to work on that, just want Peter to confirm that there's no reason
> that this is missing right now.

Great, thanks.  And for this bug (and many others?) it would also be very
helpful if those waiting on a mutex show the current mutex owner's pid.

Don't worry about getting a final mergeable patch, covering all lock types:
just something hacked up to show that i_mmap_mutex owner would help a lot.

But be careful, maybe owner is corrupted, or contains a now-invalid
address, or points to something no longer a task_struct.

Hugh
