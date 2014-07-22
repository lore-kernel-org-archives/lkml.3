Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756448AbaGVSoq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 14:44:46 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:59989 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751304AbaGVSom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 14:44:42 -0400
Date: Tue, 22 Jul 2014 11:42:52 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Vlastimil Babka <vbabka@suse.cz>
cc: Hugh Dickins <hughd@google.com>, Sasha Levin <sasha.levin@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michel Lespinasse <walken@google.com>,
        Lukas Czerner <lczerner@redhat.com>, Dave Jones <davej@redhat.com>,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Michal Hocko <mhocko@suse.cz>
Subject: Re: [PATCH 0/2] shmem: fix faulting into a hole while it's punched,
 take 3
In-Reply-To: <53CE5494.3030708@suse.cz>
Message-ID: <alpine.LSU.2.11.1407221120240.2555@eggly.anvils>
References: <alpine.LSU.2.11.1407150247540.2584@eggly.anvils> <53C7F55B.8030307@suse.cz> <53C7F5FF.7010006@oracle.com> <53C8FAA6.9050908@oracle.com> <alpine.LSU.2.11.1407191628450.24073@eggly.anvils> <53CDD961.1080006@oracle.com> <alpine.LSU.2.11.1407220049140.1980@eggly.anvils>
 <53CE37A6.2060000@suse.cz> <53CE5494.3030708@suse.cz>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Jul 2014, Vlastimil Babka wrote:
> On 07/22/2014 12:06 PM, Vlastimil Babka wrote:
> > So if this is true, the change to TASK_UNINTERRUPTIBLE will avoid the
> > problem, but it would be nicer to keep the KILLABLE state.
> > I think it could be done by testing if the wait queue still exists and
> > is the same, before attempting finish wait. If it doesn't exist, that
> > means the faulter can skip finish_wait altogether because it must be
> > already TASK_RUNNING.
> > 
> > shmem_falloc = inode->i_private;
> > if (shmem_falloc && shmem_falloc->waitq == shmem_falloc_waitq)
> > 	finish_wait(shmem_falloc_waitq, &shmem_fault_wait);
> > 
> > It might still be theoretically possible that although it has the same
> > address, it's not the same wait queue, but that doesn't hurt
> > correctness. I might be uselessly locking some other waitq's lock, but
> > the inode->i_lock still protects me from other faulters that are in the
> > same situation. The puncher is already gone.
> 
> Actually, I was wrong and deleting from a different queue could corrupt the
> queue head. I don't know if trinity would be able to trigger this, but I
> wouldn't be comfortable knowing it's possible. Calling fallocate twice in
> quick succession from the same process could easily end up at the same
> address on the stack, no?
> 
> Another also somewhat ugly possibility is to make sure that the wait queue is
> empty before the puncher quits, regardless of the running state of the
> processes in the queue. I think the conditions here (serialization by i_lock)
> might allow us to do that without risking that we e.g. leave anyone sleeping.
> But it's bending the wait queue design...
> 
> > However it's quite ugly and if there is some wait queue debugging mode
> > (I hadn't checked) that e.g. checks if wait queues and wait objects are
> > empty before destruction, it wouldn't like this at all...

Thanks a lot for confirming the TASK_KILLABLE scenario, Vlastimil:
that fits with how it looked to me last night, but it helps that you
and Michal have investigated that avenue much more thoroughly than I did.

As to refinements to retain TASK_KILLABLE: I am not at all tempted to
complicate or make it more subtle: please let's just agree that it was
a good impulse to try for TASK_KILLABLE, but having seen the problems,
much safer now to go for the simpler TASK_UNINTERRUPTIBLE instead. 

Who are the fault-while-hole-punching users who might be hurt by removing
that little killability window?  Trinity, and people testing fault versus
hole-punching?  Not a huge and deserving market segment, I judge.

Of course, if trinity goes on to pin some deadlock on lack of killability
there, then we shall have to address it.  I don't expect that, and the
fault path would not normally be killable, while waiting for memory.
But trinity does spring some surprises...

(Of course, we could simplify all this by extending the shmem inode,
but I remain strongly resistant to that, which would have an adverse
effect on all the shmem users, rather than just these testers.  Not that
I've computed the sizes and checked how they currently pack on slab and
slub: maybe there would be no adverse effect today, but a generic change
tomorrow would sooner push us over an edge to poorer object density.)

Hugh
