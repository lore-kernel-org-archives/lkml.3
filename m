Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932528Ab3CMLDm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 07:03:42 -0400
Received: from mail-qc0-f172.google.com ([209.85.216.172]:39258 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754623Ab3CMLDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 07:03:41 -0400
MIME-Version: 1.0
In-Reply-To: <20130313032334.GU21651@dastard>
References: <1362612111-28673-1-git-send-email-walken@google.com>
	<1362612111-28673-12-git-send-email-walken@google.com>
	<20130309003221.GE23616@dastard>
	<CANN689F9Zy=cTdi3D4d4iw66eeGLTtpudmAJgxYHGgDUsNU2Mg@mail.gmail.com>
	<20130311001650.GB20565@dastard>
	<CANN689FF+fjphwNqRz_ixpo4hW-rkXq6fbmJf7xDacBbP48BXw@mail.gmail.com>
	<20130312023658.GH21651@dastard>
	<CANN689Hu4S6hQaZ0tytNuToCpwtdJmyisyqyrDrNK+buJXTsKA@mail.gmail.com>
	<20130313032334.GU21651@dastard>
Date: Wed, 13 Mar 2013 04:03:40 -0700
Message-ID: <CANN689Fvc_sETcPx47LEMHbfSQ9n7c4sTgoum_3Kw0T-4+D9RQ@mail.gmail.com>
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

On Tue, Mar 12, 2013 at 8:23 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Mon, Mar 11, 2013 at 11:43:34PM -0700, Michel Lespinasse wrote:
>> I find the name 'barrier' actually confusing when used to describe
>> synchronous operations.  To me a barrier is usualy between
>> asynchronous operations, and it is well defined which operations
>> are ahead or behind of the barrier (either because they were
>> queued by the same thread, or they were queued by different
>> threads which may have synchronized together some other way).
>
> When you have hundreds or thousands of threads doing IO to the one
> file, it doesn't matter if the IO is issued synchronously or
> asynchronously by the threads - you simply have a huge amount of
> data IO concurrency and very, very deep pipelines.
>
> Inserting a metadata modification (truncate, preallocation,
> holepunch, etc) into that pipeline currently causes all new
> submissions to queue behind the metadata modification, waits for
> everything submitted before the metadata modification to complete
> and then runs the metadata modification. Once it completes, it then
> allows everything queued up to the next metadata modification to
> run....
>
> That matches your definition of a barrier pretty well, I think.

The difference I see is that with async operations one can easily tell
when the desired operations made it into the queue:

t1()
async_submit(request X)
t2()
..
..
..
(eventually) request X completes

After t2 we know the operation is queued, and thus we can legitimately
expect that new operations submitted after t2 should logically run
after request X.


With sync operations we can't make that observation as the caller
thread is blocked:

t1()
begin system call
..
..
request X gets queued
..
..
request X completes
..
..
system call completes
t2()

Userspace can't pinpoint exactly when did the request get onto the queue.

If another request Y gets submitted between t1 and t2, userspace can
never know for sure if Y was before of after X in the queue, so the
proposed reordering should be (my claim) not observable by userspace,
in the sense that it never produces a result that wasn't already
possible before.




Anyway, I didn't intend for the proposed change to warrant a thread of
this size. I will abandon patch 10 and propose a different (slightly
longer, but without reordering) change to replace patch 11.

Thanks,

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
