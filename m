Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751858AbaJZU36 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2014 16:29:58 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:60252 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751802AbaJZU34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2014 16:29:56 -0400
Date: Sun, 26 Oct 2014 21:29:47 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, X86 ML <x86@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Richard Weinberger <richard.weinberger@gmail.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: vmalloced stacks on x86_64?
Message-ID: <20141026202943.GA9871@lerouge>
References: <CALCETrUmA+5499fEqp7S-nfSBVxTEo76mA9r32zYQ41E3c+YhQ@mail.gmail.com>
 <CAFTL4hz87W1G2atf3mt+aG72Q-z8MwxFpguQgtT9kvHYE7pKEw@mail.gmail.com>
 <CALCETrWyvXZCocPgcbatFvphgBuGbKhsMvYJNuy9EFc4kM-TGw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrWyvXZCocPgcbatFvphgBuGbKhsMvYJNuy9EFc4kM-TGw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 25, 2014 at 10:49:25PM -0700, Andy Lutomirski wrote:
> On Oct 25, 2014 9:11 PM, "Frederic Weisbecker" <fweisbec@gmail.com> wrote:
> >
> > 2014-10-25 2:22 GMT+02:00 Andy Lutomirski <luto@amacapital.net>:
> > > Is there any good reason not to use vmalloc for x86_64 stacks?
> > >
> > > The tricky bits I've thought of are:
> > >
> > >  - On any context switch, we probably need to probe the new stack
> > > before switching to it.  That way, if it's going to fault due to an
> > > out-of-sync pgd, we still have a stack available to handle the fault.
> >
> > Would that prevent from any further fault on a vmalloc'ed kernel
> > stack? We would need to ensure that pre-faulting, say the first byte,
> > is enough to sync the whole new stack entirely otherwise we risk
> > another future fault and some places really aren't safely faulted.
> >
> 
> I think so.  The vmalloc faults only happen when the entire top-level
> page table entry is missing, and those cover giant swaths of address
> space.
> 
> I don't know whether the vmalloc code guarantees not to span a pmd
> (pud? why couldn't these be called pte0, pte1, pte2, etc.?) boundary.

So dereferencing stack[0] is probably enough for 8KB worth of stack. I think
we have vmalloc_sync_all() but I heard this only work on x86-64.

Too bad we don't have a universal solution, I have that problem with per cpu allocated
memory faulting at random places. I hit at least two places where it got harmful:
context tracking and perf callchains. We fixed the latter using open-coded per cpu
allocation. I still haven't found a solution for context tracking.
