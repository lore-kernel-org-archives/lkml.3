Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751761AbaJTQtw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 12:49:52 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:40475 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798AbaJTQtu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 12:49:50 -0400
MIME-Version: 1.0
In-Reply-To: <20141020083326.GA3219@twins.programming.kicks-ass.net>
References: <cover.1413323611.git.luto@amacapital.net> <b6c264b3bb064658af498763e234e3cb4f9db4e2.1413323612.git.luto@amacapital.net>
 <CALCETrXRGNeUipujcGiT30SV+MDHCFpTxG7LOTXj4Z4CbtxdJQ@mail.gmail.com>
 <CALCETrXv=bWUqVWhCekjq3UQeLFgGcbocKFjtNiNqm6DhyPmzA@mail.gmail.com>
 <20141019213341.GF23531@worktop.programming.kicks-ass.net>
 <CALCETrVT9vHjBRRvhTayqfOEebMjyVU9Yw7v80D6EPAmcyREZw@mail.gmail.com>
 <20141019222004.GI23531@worktop.programming.kicks-ass.net>
 <CALCETrXzwA3JH8xYLFcLdUSXAJi05Q62dZP3yOjZJTxgVugDrQ@mail.gmail.com> <20141020083326.GA3219@twins.programming.kicks-ass.net>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 20 Oct 2014 09:49:28 -0700
Message-ID: <CALCETrVHw54Yc0qiTUP7+SiWK4Ch362m=jO8szCkpt8U7_h_dA@mail.gmail.com>
Subject: Re: [RFC 5/5] x86,perf: Only allow rdpmc if a perf_event is mapped
To: Peter Zijlstra <peterz@infradead.org>
Cc: Erik Bosman <ebn310@few.vu.nl>, Ingo Molnar <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>, Kees Cook <keescook@chromium.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 20, 2014 at 1:33 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Sun, Oct 19, 2014 at 03:57:54PM -0700, Andy Lutomirski wrote:
>> > Maybe, but at that point we commit to yet another ABI... I'd rather just
>> > put a 'sane' implementation in a library or so.
>>
>> This cuts both ways, though.  For vdso timekeeping, the underlying
>> data structure has changed repeatedly, sometimes to add features, and
>> sometimes for performance, and the vdso has done a good job insulating
>> userspace from it.  (In fact, until 3.16, even the same exact kernel
>> version couldn't be relied on to have the same data structure with
>> different configs, and even now, no one really wants to teach user
>> libraries how to parse the pvclock data structures.)
>
> Fair enough, but as it stands we've already committed to the data
> structure exposed to userspace.

True.

OTOH, if a vdso function gets added, a few releases go by, and all the
userspace tools get updated, then the old data structure could be
dropped if needed by clearing cap_user_rdpmc.

Anyway, this is so far out of scope for the current project that I'm
going to ignore it.

>> FWIW, something should probably specify exactly when it's safe to try
>> a userspace rdpmc.  I think that the answer is that, for a perf event
>> watching a pid, only that pid can do it (in particular, other threads
>> must not try).  For a perf event monitoring a whole cpu, the answer is
>> less clear to me.
>
> This all was really only meant to be used for self-monitoring, so where
> an event is attached to the very same task, anything else and I'm find
> disabling it.

Actually implementing this might be a touch awkward.  I can check
whether an event has a task context that matches the creating task,
but that's not necessarily the same thing as the task that mmaps it.

--Andy
