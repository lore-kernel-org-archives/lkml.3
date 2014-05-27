Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752088AbaE0NFT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 09:05:19 -0400
Received: from casper.infradead.org ([85.118.1.10]:37618 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751855AbaE0NFQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 09:05:16 -0400
Date: Tue, 27 May 2014 15:05:09 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christoph Lameter <cl@linux.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Mel Gorman <mgorman@suse.de>,
        Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        Mike Marciniszyn <infinipath@intel.com>
Subject: Re: [RFC][PATCH 0/5] VM_PINNED
Message-ID: <20140527130509.GD5444@laptop.programming.kicks-ass.net>
References: <20140526145605.016140154@infradead.org>
 <CALYGNiMG1NVBUS4TJrYJMr92yWGZHSdGUdCGtBJDHoUMMhE+Wg@mail.gmail.com>
 <20140526203232.GC5444@laptop.programming.kicks-ass.net>
 <CALYGNiO8FNKjtETQMRSqgiArjfQ9nRAALUg9GGdNYbpKru=Sjw@mail.gmail.com>
 <20140527102909.GO30445@twins.programming.kicks-ass.net>
 <20140527105438.GW13658@twins.programming.kicks-ass.net>
 <CALYGNiNCp5ShyKLAQi_cht_-sPt79Zxzj=Q=VSzqCvdnsCE5ag@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <CALYGNiNCp5ShyKLAQi_cht_-sPt79Zxzj=Q=VSzqCvdnsCE5ag@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 27, 2014 at 03:11:36PM +0400, Konstantin Khlebnikov wrote:
> On Tue, May 27, 2014 at 2:54 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Tue, May 27, 2014 at 12:29:09PM +0200, Peter Zijlstra wrote:
> >> On Tue, May 27, 2014 at 12:49:08AM +0400, Konstantin Khlebnikov wrote:
> >> > Another suggestion. VM_RESERVED is stronger than VM_LOCKED and extends
> >> > its functionality.
> >> > Maybe it's easier to add VM_DONTMIGRATE and use it together with VM_LOCKED.
> >> > This will make accounting easier. No?
> >>
> >> I prefer the PINNED name because the not being able to migrate is only
> >> one of the desired effects of it, not the primary effect. We're really
> >> looking to keep physical pages in place and preserve mappings.
> 
> Ah, I just mixed it up.
> 
> >>
> >> The -rt people for example really want to avoid faults (even minor
> >> faults), and DONTMIGRATE would still allow unmapping.
> >>
> >> Maybe always setting VM_PINNED and VM_LOCKED together is easier, I
> >> hadn't considered that. The first thing that came to mind is that that
> >> might make the fork() semantics difficult, but maybe it works out.
> >>
> >> And while we're on the subject, my patch preserves PINNED over fork()
> >> but maybe we don't actually need that either.
> >
> > So pinned_vm is userspace exposed, which means we have to maintain the
> > individual counts, and doing the fully orthogonal accounting is 'easier'
> > than trying to get the boundary cases right.
> >
> > That is, if we have a program that does mlockall() and then does the IB
> > ioctl() to 'pin' a region, we'd have to make mm_mpin() do munlock()
> > after it splits the vma, and then do the pinned accounting.
> >
> > Also, we'll have lost the LOCKED state and unless MCL_FUTURE was used,
> > we don't know what to restore the vma to on mm_munpin().
> >
> > So while the accounting looks tricky, it has simpler semantics.
> 
> What if VM_PINNED will require VM_LOCKED?
> I.e. user must mlock it before pining and cannot munlock vma while it's pinned.

So I don't like restrictions like that if its at all possible to avoid
-- and in this case, I already wrote the code and its not _that_
complicated.

But also; that would mean that we'd either have to make mm_mpin() do the
mlock unconditionally (which rather defeats the purpose) or break
userspace assumptions. I'm fairly sure the IB ioctl() don't require the
memory to be mlocked.

