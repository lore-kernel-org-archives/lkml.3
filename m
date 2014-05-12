Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755108AbaELMak (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 08:30:40 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:41366 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751510AbaELMaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 08:30:39 -0400
Date: Mon, 12 May 2014 14:30:32 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: Juri Lelli <juri.lelli@gmail.com>, Dario Faggioli <raistlin@linux.it>,
        Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>
Subject: Re: [BUG] sched_setattr() SCHED_DEADLINE hangs system
Message-ID: <20140512123032.GC13467@laptop.programming.kicks-ass.net>
References: <536F8F0E.7020301@gmail.com>
 <53707007.3080003@gmail.com>
 <20140512084727.GN30445@twins.programming.kicks-ass.net>
 <CAKgNAkiGt6xV0JaddmC8pLeTe+fSEu79DNvzg8XbA-MPo_zXyg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKgNAkiGt6xV0JaddmC8pLeTe+fSEu79DNvzg8XbA-MPo_zXyg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 12, 2014 at 11:19:39AM +0200, Michael Kerrisk (man-pages) wrote:
> Hi Peter,
> 
> On Mon, May 12, 2014 at 10:47 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Mon, May 12, 2014 at 08:53:59AM +0200, Michael Kerrisk (man-pages) wrote:
> >> On 05/11/2014 04:54 PM, Michael Kerrisk (man-pages) wrote:
> >
> >> > $ time sudo ./t_sched_setattr d 18446744072 18446744072 18446744073
> >>
> >> I realize my speculation was completely off the mark. time(2) really
> >> is reporting the truth, and the sched_setattr() call returns immediately.
> >> But it looks like with these settings the deadline scheduler gets itself
> >> into a confused state. The process chews up a vast amount of CPU time
> >> for the few actions (including process teardown) that occur after
> >> the sched_setattr() call, and since the SCHED_DEADLINE process has
> >> priority over everything else, the system locks up.
> >
> > Yeah, its doing something weird alright.. let me see if I can get
> > something useful out.
> 
> Thanks!

So I think its because the way we check wrapping

  (s64)(a - b) < 0

This means that its impossible to tell if time went fwd or bwd with
64bit increments. I've not entirely pinpointed where this is wrecking
things, but it seems like a fair bet this is what's going wrong.

So I'm tempted to put a sanity check on all these values to make sure <=
2^63. That way the wrapping logic in the kernel keeps working.

And 2^63 [ns] should be plenty large enough for everyone (famous last
words of course).

> > Btw, you do know about EX_USAGE from sysexits.h ?
> 
> Yes, I'm peripherally aware of them, but have tended to avoid them
> because they're not in POSIX, and don't seem to be all that widely
> used.

Ah, so then its just something weird I've picked up along the way :-)
