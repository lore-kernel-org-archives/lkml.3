Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755115Ab3I1Tjj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 15:39:39 -0400
Received: from mail-ea0-f181.google.com ([209.85.215.181]:40825 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753722Ab3I1Tjg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 15:39:36 -0400
Date: Sat, 28 Sep 2013 21:39:32 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Waiman Long <Waiman.Long@hp.com>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Alex Shi <alex.shi@intel.com>, Tim Chen <tim.c.chen@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Matthew R Wilcox <matthew.r.wilcox@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Michel Lespinasse <walken@google.com>,
        Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: Re: [PATCH] rwsem: reduce spinlock contention in wakeup code path
Message-ID: <20130928193932.GA8640@gmail.com>
References: <1380308424-31011-1-git-send-email-Waiman.Long@hp.com>
 <CA+55aFxXeQ69B1bfrO+0QtBqm0gt688LOshx=ppNjch10JF8FQ@mail.gmail.com>
 <20130928074144.GA17773@gmail.com>
 <CA+55aFyx-Lpqd8i2tHvhXCqL+nJZPq-6SikEkb-cQZEU9ogRjA@mail.gmail.com>
 <20130928192123.GA8228@gmail.com>
 <CA+55aFyZqV_wJTpd9OVw=kM157Q45byW2F3kjhr5ML5Npz84OA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyZqV_wJTpd9OVw=kM157Q45byW2F3kjhr5ML5Npz84OA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Sat, Sep 28, 2013 at 12:21 PM, Ingo Molnar <mingo@kernel.org> wrote:
> >
> > If we do that then I suspect the next step will be queued rwlocks :-/ The
> > current rwlock_t implementation is rather primitive by modern standards.
> > (We'd probably have killed rwlock_t long ago if not for the
> > tasklist_lock.)
> 
> Yeah, I'm not happy about or rwlocks. That's one lock that currently
> is so broken that I think we could easily argue for making that one
> queued.
> 
> Waiman had a qrwlock series that looked reasonable, and I think his
> later versions were drop-in replacements (ie they automatically just
> did the RightThing(tm) wrt interrupts taking a recursive read lock - I
> objected to the first versions that required that to be stated
> explicitly).
> 
> I think Waiman's patches (even the later ones) made the queued rwlocks
> be a side-by-side implementation with the old rwlocks, and I think
> that was just being unnecessarily careful. It might be useful for
> testing to have a config option to switch between the two, but we
> might as well go all the way.
> 
> The old rwlock's really have been a disappointment - they are slower 
> than spinlocks, and seldom/never end up scaling any better.  Their main 
> advantage was literally the irq behavior - allowing readers to happen 
> without the expense of worrying about irq's.

Yeah.

But at least here the read side will not play, as the AIM7 workloads where 
the testing goes on excercises the write path exclusively I think.

Still, the lack of queueing ought to hurt - the question is by how much.

Thanks,

	Ingo
