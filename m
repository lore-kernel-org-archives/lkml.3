Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752203AbaJ0BMa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2014 21:12:30 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:49171 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751813AbaJ0BM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2014 21:12:27 -0400
MIME-Version: 1.0
In-Reply-To: <20141026202943.GA9871@lerouge>
References: <CALCETrUmA+5499fEqp7S-nfSBVxTEo76mA9r32zYQ41E3c+YhQ@mail.gmail.com>
 <CAFTL4hz87W1G2atf3mt+aG72Q-z8MwxFpguQgtT9kvHYE7pKEw@mail.gmail.com>
 <CALCETrWyvXZCocPgcbatFvphgBuGbKhsMvYJNuy9EFc4kM-TGw@mail.gmail.com> <20141026202943.GA9871@lerouge>
From: Andy Lutomirski <luto@amacapital.net>
Date: Sun, 26 Oct 2014 18:12:05 -0700
Message-ID: <CALCETrWqRxDD84o99nRGa3cv4qYqgWpwk0_woe6w60JYzpNEog@mail.gmail.com>
Subject: Re: vmalloced stacks on x86_64?
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, X86 ML <x86@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Richard Weinberger <richard.weinberger@gmail.com>,
        Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 26, 2014 at 1:29 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> On Sat, Oct 25, 2014 at 10:49:25PM -0700, Andy Lutomirski wrote:
>> On Oct 25, 2014 9:11 PM, "Frederic Weisbecker" <fweisbec@gmail.com> wrote:
>> >
>> > 2014-10-25 2:22 GMT+02:00 Andy Lutomirski <luto@amacapital.net>:
>> > > Is there any good reason not to use vmalloc for x86_64 stacks?
>> > >
>> > > The tricky bits I've thought of are:
>> > >
>> > >  - On any context switch, we probably need to probe the new stack
>> > > before switching to it.  That way, if it's going to fault due to an
>> > > out-of-sync pgd, we still have a stack available to handle the fault.
>> >
>> > Would that prevent from any further fault on a vmalloc'ed kernel
>> > stack? We would need to ensure that pre-faulting, say the first byte,
>> > is enough to sync the whole new stack entirely otherwise we risk
>> > another future fault and some places really aren't safely faulted.
>> >
>>
>> I think so.  The vmalloc faults only happen when the entire top-level
>> page table entry is missing, and those cover giant swaths of address
>> space.
>>
>> I don't know whether the vmalloc code guarantees not to span a pmd
>> (pud? why couldn't these be called pte0, pte1, pte2, etc.?) boundary.
>
> So dereferencing stack[0] is probably enough for 8KB worth of stack. I think
> we have vmalloc_sync_all() but I heard this only work on x86-64.
>

I have no desire to do this for 32-bit.  But we don't need
vmalloc_sync_all -- we just need to sync the ony required entry.

> Too bad we don't have a universal solution, I have that problem with per cpu allocated
> memory faulting at random places. I hit at least two places where it got harmful:
> context tracking and perf callchains. We fixed the latter using open-coded per cpu
> allocation. I still haven't found a solution for context tracking.

In principle, we could pre-populate all top-level pgd entries at boot,
but that would cost up to 256 pages of memory, I think.

--Andy
