Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752541AbaJTRkO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 13:40:14 -0400
Received: from mail-lb0-f180.google.com ([209.85.217.180]:48144 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752500AbaJTRkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 13:40:09 -0400
MIME-Version: 1.0
In-Reply-To: <CALCETrVHw54Yc0qiTUP7+SiWK4Ch362m=jO8szCkpt8U7_h_dA@mail.gmail.com>
References: <cover.1413323611.git.luto@amacapital.net> <b6c264b3bb064658af498763e234e3cb4f9db4e2.1413323612.git.luto@amacapital.net>
 <CALCETrXRGNeUipujcGiT30SV+MDHCFpTxG7LOTXj4Z4CbtxdJQ@mail.gmail.com>
 <CALCETrXv=bWUqVWhCekjq3UQeLFgGcbocKFjtNiNqm6DhyPmzA@mail.gmail.com>
 <20141019213341.GF23531@worktop.programming.kicks-ass.net>
 <CALCETrVT9vHjBRRvhTayqfOEebMjyVU9Yw7v80D6EPAmcyREZw@mail.gmail.com>
 <20141019222004.GI23531@worktop.programming.kicks-ass.net>
 <CALCETrXzwA3JH8xYLFcLdUSXAJi05Q62dZP3yOjZJTxgVugDrQ@mail.gmail.com>
 <20141020083326.GA3219@twins.programming.kicks-ass.net> <CALCETrVHw54Yc0qiTUP7+SiWK4Ch362m=jO8szCkpt8U7_h_dA@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 20 Oct 2014 10:39:48 -0700
Message-ID: <CALCETrW5M+p4FZ6YPdNVVtXKomkEYRWyNpGGB1ZPbJMkQgU50g@mail.gmail.com>
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

On Mon, Oct 20, 2014 at 9:49 AM, Andy Lutomirski <luto@amacapital.net> wrote:
> On Mon, Oct 20, 2014 at 1:33 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>> On Sun, Oct 19, 2014 at 03:57:54PM -0700, Andy Lutomirski wrote:
>>> > Maybe, but at that point we commit to yet another ABI... I'd rather just
>>> > put a 'sane' implementation in a library or so.
>>>
>>> This cuts both ways, though.  For vdso timekeeping, the underlying
>>> data structure has changed repeatedly, sometimes to add features, and
>>> sometimes for performance, and the vdso has done a good job insulating
>>> userspace from it.  (In fact, until 3.16, even the same exact kernel
>>> version couldn't be relied on to have the same data structure with
>>> different configs, and even now, no one really wants to teach user
>>> libraries how to parse the pvclock data structures.)
>>
>> Fair enough, but as it stands we've already committed to the data
>> structure exposed to userspace.
>
> True.
>
> OTOH, if a vdso function gets added, a few releases go by, and all the
> userspace tools get updated, then the old data structure could be
> dropped if needed by clearing cap_user_rdpmc.
>
> Anyway, this is so far out of scope for the current project that I'm
> going to ignore it.

OK, I lied.

I haven't tested it, but it looks like any existing users of
cap_user_rdpmc may have serious issues.  That flag is set to 1 for
essentially all perf_events on x86, even events that aren't part of
the x86_pmu.  Since the default .event_idx callback doesn't return
zero, lots of other events will appear to be rdpmcable.  This includes
the AMD uncore pmu, which looks like it actually supports rdpmc, but
hwc->idx seems to be missing an offset.

If this is the case, then user code can't reliably use the userpage
rdpmc mechanism, so maybe it should be deprecated (or at least get a
new flag bit).

--Andy
