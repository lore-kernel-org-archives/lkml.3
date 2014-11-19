Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933048AbaKSXIA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 18:08:00 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:46712 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757796AbaKSXH6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 18:07:58 -0500
Date: Thu, 20 Nov 2014 00:07:55 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, Don Zickus <dzickus@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: frequent lockups in 3.18rc4
Message-ID: <20141119230753.GC11386@lerouge>
References: <20141118215540.GD35311@redhat.com>
 <20141119021902.GA14216@redhat.com>
 <CA+55aFw13opSu6ETXgVo1tjrP+1PLkbsiKewEqRgdBKyBKALWA@mail.gmail.com>
 <20141119145902.GA13387@redhat.com>
 <CA+55aFxBb+aH6GdhbWECkh+wDwsHv43O1ryy4u20O8Bk-oDz+g@mail.gmail.com>
 <CA+55aFym2UfWnXZw0NjA70Q575eybiAOUkx==3Ci+V43u1-ZNQ@mail.gmail.com>
 <20141119190215.GA10796@lerouge>
 <alpine.DEB.2.11.1411192251120.3909@nanos>
 <20141119225615.GA11386@lerouge>
 <CALCETrUX8O9u7+cU_32R+36t=jeB2dvj3_fDGD+uvhTGYZATuA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrUX8O9u7+cU_32R+36t=jeB2dvj3_fDGD+uvhTGYZATuA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19, 2014 at 02:59:01PM -0800, Andy Lutomirski wrote:
> On Wed, Nov 19, 2014 at 2:56 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > On Wed, Nov 19, 2014 at 10:56:26PM +0100, Thomas Gleixner wrote:
> >> On Wed, 19 Nov 2014, Frederic Weisbecker wrote:
> >> > I got a report lately involving context tracking. Not sure if it's
> >> > the same here but the issue was that context tracking uses per cpu data
> >> > and per cpu allocation use vmalloc and vmalloc'ed area can fault due to
> >> > lazy paging.
> >>
> >> This is complete nonsense. pcpu allocations are populated right
> >> away. Otherwise no single line of kernel code which uses dynamically
> >> allocated per cpu storage would be safe.
> >
> > Note this isn't faulting because part of the allocation is swapped. No
> > it's all reserved in the physical memory, but it's a lazy allocation.
> > Part of it isn't yet addressed in the P[UGM?]D. That's what vmalloc_fault() is for.
> >
> > So it's a non-blocking/sleeping fault which is why it's probably fine
> > most of the time except on code that isn't fault-safe. And I suspect that
> > most people assume that kernel data won't fault so probably some other
> > places have similar issues.
> >
> > That's a long standing issue. We even had to convert the perf callchain
> > allocation to ad-hoc kmalloc() based per cpu allocation to get over vmalloc
> > faults. At that time, NMIs couldn't handle faults and many callchains were
> > populated in NMIs. We had serious crashes because of per cpu memory faults.
> 
> Is there seriously more than 512GB of per-cpu virtual space or
> whatever's needed to exceed a single pgd on x86_64?

No idea, I'm clueless about -mm details.

> 
> And there are definitely placed that access per-cpu data in contexts
> in which a non-IST fault is not allowed.  Maybe not dynamic per-cpu
> data, though.

It probably happens to be fine because the code that accesses first the
related data is fault-safe. Or maybe not and some state is silently messed
up somewhere.

This doesn't leave a comfortable feeling.
