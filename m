Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932916Ab3CSXsd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 19:48:33 -0400
Received: from mail-qe0-f49.google.com ([209.85.128.49]:48861 "EHLO
	mail-qe0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754222Ab3CSXsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 19:48:31 -0400
MIME-Version: 1.0
In-Reply-To: <20130319011754.GU6369@dastard>
References: <1362612111-28673-1-git-send-email-walken@google.com>
	<1362612111-28673-12-git-send-email-walken@google.com>
	<20130309003221.GE23616@dastard>
	<CANN689F9Zy=cTdi3D4d4iw66eeGLTtpudmAJgxYHGgDUsNU2Mg@mail.gmail.com>
	<20130311001650.GB20565@dastard>
	<CANN689FF+fjphwNqRz_ixpo4hW-rkXq6fbmJf7xDacBbP48BXw@mail.gmail.com>
	<20130312023658.GH21651@dastard>
	<CANN689Hu4S6hQaZ0tytNuToCpwtdJmyisyqyrDrNK+buJXTsKA@mail.gmail.com>
	<20130313032334.GU21651@dastard>
	<1363226451.25976.170.camel@thor.lan>
	<20130319011754.GU6369@dastard>
Date: Tue, 19 Mar 2013 16:48:30 -0700
Message-ID: <CANN689F8hskgfJ=n+RxBbDgym4Q1PWdq7MfGHgxTRXtNJjYZFQ@mail.gmail.com>
Subject: Re: [PATCH 11/12] rwsem: wake all readers when first waiter is a reader
From: Michel Lespinasse <walken@google.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Peter Hurley <peter@hurleysoftware.com>, Alex Shi <alex.shi@intel.com>,
        Ingo Molnar <mingo@kernel.org>, David Howells <dhowells@redhat.com>,
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

On Mon, Mar 18, 2013 at 6:17 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Wed, Mar 13, 2013 at 10:00:51PM -0400, Peter Hurley wrote:
>> On Wed, 2013-03-13 at 14:23 +1100, Dave Chinner wrote:
>> > We don't care about the ordering between multiple concurrent
>> > metadata modifications - what matters is whether the ongoing data IO
>> > around them is ordered correctly.
>>
>> Dave,
>>
>> The point that Michel is making is that there never was any ordering
>> guarantee by rwsem. It's an illusion.
>
> Weasel words.

Whoaaa, calm down.

You initially made one false statement (that the change meant a stream
of readers would starve a writer forever) and one imprecise statement
(that rwsem used to guarantee that readers don't skip ahead of writers
- this may be true in practice for your use case because the latencies
involved are very large compared to scheduling latencies, but that's a
very important qualification that needs to be added here). That
confused me enough that I initially couldn't tell what your actual
concern was, so I pointed out the source of my confusion and asked you
to clarify. It seems unfair to characterize that as "weasel words" -
I'm not trying to be a smartass here, but only to actually understand
your concern.

>> The reason is simple: to even get to the lock the cpu has to be
>> sleep-able. So for every submission that you believe is ordered, is by
>> its very nature __not ordered__, even when used by kernel code.
>>
>> Why? Because any thread on its way to claim the lock (reader or writer)
>> could be pre-empted for some other task, thus delaying the submission of
>> whatever i/o you believed to be ordered.
>
> You think I don't know this?  You're arguing fine grained, low level
> behaviour between tasks is unpredictable. I get that. I understand
> that. But I'm not arguing about fine-grained, low level, microsecond
> semantics of the locking order....
>
> What you (and Michael) appear to be failing to see is what happens
> on a macro level when you have read locks being held for periods
> measured in *seconds* (e.g. direct IO gets queued behind a few
> thousand other IOs in the elevator waiting for a request slot),
> and the subsequent effect of inserting an operation that requires a
> write lock into that IO stream.
>
> IOWs, it simply doesn't matter if there's a micro-level race between
> the write lock and a couple of the readers. That's the level you
> guys are arguing at but it simply does not matter in the cases I'm
> describing. I'm talking about high level serialisation behaviours
> that might take of *seconds* to play out and the ordering behaviours
> observed at that scale.
>
> That is, I don't care if a couple of threads out of a few thousand
> race with the write lock over few tens to hundreds of microseconds,
> but I most definitely care if a few thousand IOs issued seconds
> after the write lock is queued jump over the write lock. That is a
> gross behavioural change at the macro-level.....

Understood. I accepted your concern and made sure my v2 proposal
doesn't do such macro level reordering.

>> So just to reiterate: there is no 'queue' and no 'barrier'. The
>> guarantees that rwsem makes are;
>> 1. Multiple readers can own the lock.
>> 2. Only a single writer can own the lock.
>> 3. Readers will not starve writers.
>
> You've conveniently ignored the fact that the current implementation
> also provides following guarantee:
>
> 4. new readers will block behind existing writers

In your use case, with large enough queue latencies, yes.

Please don't make it sound like this applies in every use case - it
has never applied for short (<ms) queue latencies, and you might
confuse people by making such unqualified statements.

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
