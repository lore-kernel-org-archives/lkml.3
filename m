Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754186AbaJUE7d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 00:59:33 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:51679 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102AbaJUE7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 00:59:32 -0400
Message-ID: <5445E82F.2080805@amacapital.net>
Date: Mon, 20 Oct 2014 21:59:27 -0700
From: Andy Lutomirski <luto@amacapital.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC 2/2] x86_64: expand kernel stack to 16K
References: <CA+55aFzdq2V-Q3WUV7hQJG8jBSAvBqdYLVTNtbD4ObVZ5yDRmw@mail.gmail.com> <20140529072633.GH6677@dastard> <CA+55aFx+j4104ZFmA-YnDtyfmV4FuejwmGnD5shfY0WX4fN+Kg@mail.gmail.com> <20140529235308.GA14410@dastard> <20140530000649.GA3477@redhat.com> <20140530002113.GC14410@dastard> <20140530003219.GN10092@bbox> <20140530013414.GF14410@dastard> <5388A2D9.3080708@zytor.com> <CA+55aFycqAw2AqQGv8aTPs_RxyKZqMdoyeSxWRSDk2N-PiBZeg@mail.gmail.com> <20141021020033.GA8486@redhat.com>
In-Reply-To: <20141021020033.GA8486@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/20/2014 07:00 PM, Dave Jones wrote:
> On Fri, May 30, 2014 at 08:41:00AM -0700, Linus Torvalds wrote:
>  > On Fri, May 30, 2014 at 8:25 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>  > >
>  > > If we removed struct thread_info from the stack allocation then one
>  > > could do a guard page below the stack.  Of course, we'd have to use IST
>  > > for #PF in that case, which makes it a non-production option.

Why is thread_info in the stack allocation anyway?  Every time I look at
the entry asm, one (minor) thing that contributes to general
brain-hurtingness / sense of horrified awe is the incomprehensible (to
me) split between task_struct and thread_info.

struct thread_info is at the bottom of the stack, right?  If we don't
want to merge it into task_struct, couldn't we stick it at the top of
the stack instead?  Anything that can overwrite the *top* of the stack
gives trivial user-controlled CPL0 execution regardless.

>  > 
>  > We could just have the guard page in between the stack and the
>  > thread_info, take a double fault, and then just map it back in on
>  > double fault.
>  > 
>  > That would give us 8kB of "normal" stack, with a very loud fault - and
>  > then an extra 7kB or so of stack (whatever the size of thread-info is)
>  > - after the first time it traps.
>  > 
>  > That said, it's still likely a non-production option due to the page
>  > table games we'd have to play at fork/clone time.

What's wrong with vmalloc?  Doesn't it already have guard pages?

(Also, we have a shiny hardware dirty bit, so we could relatively
cheaply check whether we're near the limit without any weird
#PF-in-weird-context issues.)

Also, muahaha, I've infected more people with the crazy idea that
intentional double-faults are okay.  Suckers!  Soon I'll have Linux
returning from interrupts with lret!  (IIRC Windows used to do
intentional *triple* faults on context switches, so this should be
considered entirely sensible.)

> 
> [thread necrophilia]
> 
> So digging this back up, it occurs to me that after we bumped to 16K,
> we never did anything like the debug stuff you suggested here.
> 
> The reason I'm bringing this up, is that the last few weeks, I've been
> seeing things like..
> 
> [27871.793753] trinity-c386 (28793) used greatest stack depth: 7728 bytes left
> 
> So we're now eating past that first 8KB in some situations.
> 
> Do we care ? Or shall we only start worrying if it gets even deeper ?

I would *love* to have an immediate, loud failure when we overrun the
stack.  This will unavoidably increase the number of TLB misses, but
that probably isn't so bad.

--Andy

