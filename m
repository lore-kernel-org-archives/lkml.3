Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760220Ab3CIBUg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 20:20:36 -0500
Received: from mail-ie0-f178.google.com ([209.85.223.178]:61861 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759784Ab3CIBUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 20:20:35 -0500
MIME-Version: 1.0
In-Reply-To: <20130309003221.GE23616@dastard>
References: <1362612111-28673-1-git-send-email-walken@google.com>
	<1362612111-28673-12-git-send-email-walken@google.com>
	<20130309003221.GE23616@dastard>
Date: Fri, 8 Mar 2013 17:20:34 -0800
Message-ID: <CANN689F9Zy=cTdi3D4d4iw66eeGLTtpudmAJgxYHGgDUsNU2Mg@mail.gmail.com>
Subject: Re: [PATCH 11/12] rwsem: wake all readers when first waiter is a reader
From: Michel Lespinasse <walken@google.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Alex Shi <alex.shi@intel.com>, Ingo Molnar <mingo@kernel.org>,
        David Howells <dhowells@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 8, 2013 at 4:32 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Wed, Mar 06, 2013 at 03:21:50PM -0800, Michel Lespinasse wrote:
>> When the first queued waiter is a reader, wake all readers instead of
>> just those that are at the front of the queue. There are really two
>> motivations for this change:
>
> Isn't this a significant change of semantics for the rwsem? i.e.
> that read lock requests that come after a write lock request now
> jump ahead of the write lock request? i.e.the write lock request is
> no longer a barrier in the queue?

Yes, I am allowing readers to skip ahead of writers in the queue (but
only if they can run with another reader that was already ahead).

I don't see that this is a change of observable semantics for correct
programs. If a reader and a writer both block on the rwsem, how do you
known for sure which one got queued first ? rwsem API doesn't give you
any easy way to know whether a thread is currently queued on the rwsem
(it could also be descheduled before it gets onto the rwsem queue).

But yes, if you're making assumptions about queuing order the change
makes it more likely that they'll be observably wrong.

> XFS has long assumed that a rwsem write lock is a barrier that
> stops new read locks from being taken, and this change will break
> that assumption. Given that this barrier assumption is used as the
> basis for serialisation of operations like IO vs truncate, there's a
> bit more at stake than just improving parallelism here.  i.e. IO
> issued after truncate/preallocate/hole punch could now be issued
> ahead of the pending metadata operation, whereas currently the IO
> issued after the pending metadata operation is waiting for the write
> lock will be only be processed -after- the metadata modification
> operation completes...
>
> That is a recipe for weird data corruption problems because
> applications are likely to have implicit dependencies on the barrier
> effect of metadata operations on data IO...

I am confused as to exactly what XFS is doing, could you point me to
the code / indicate a scenario where this would go wrong ? If you
really rely on this for correctness you'd have to do something already
to guarantee that your original queueing order is as desired, and I
just don't see how it'd be done...

That said, it is doable to add support for write lock stealing in the
rwsem write path while still preserving the queueing order of readers
vs writers; I'm just not sure that I fully understand the correctness
concern at this point.

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
