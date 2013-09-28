Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754564Ab3I1Sz3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 14:55:29 -0400
Received: from mail-vb0-f53.google.com ([209.85.212.53]:64339 "EHLO
	mail-vb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752479Ab3I1Sz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 14:55:27 -0400
MIME-Version: 1.0
In-Reply-To: <20130928074144.GA17773@gmail.com>
References: <1380308424-31011-1-git-send-email-Waiman.Long@hp.com>
	<CA+55aFxXeQ69B1bfrO+0QtBqm0gt688LOshx=ppNjch10JF8FQ@mail.gmail.com>
	<20130928074144.GA17773@gmail.com>
Date: Sat, 28 Sep 2013 11:55:26 -0700
X-Google-Sender-Auth: WPVcdbynsVVNCoExDw26WY7eXsk
Message-ID: <CA+55aFyx-Lpqd8i2tHvhXCqL+nJZPq-6SikEkb-cQZEU9ogRjA@mail.gmail.com>
Subject: Re: [PATCH] rwsem: reduce spinlock contention in wakeup code path
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@kernel.org>
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
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 28, 2013 at 12:41 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
>
> Yeah, I fully agree. The reason I'm still very sympathetic to Tim's
> efforts is that they address a regression caused by a mechanic
> mutex->rwsem conversion:
>
>   5a505085f043 mm/rmap: Convert the struct anon_vma::mutex to an rwsem
>
> ... and Tim's patches turn that regression into an actual speedup.

Btw, I really hate that thing. I think we should turn it back into a
spinlock. None of what it protects needs a mutex or an rwsem.

Because you guys talk about the regression of turning it into a rwsem,
but nobody talks about the *original* regression.

And it *used* to be a spinlock, and it was changed into a mutex back
in 2011 by commit 2b575eb64f7a. That commit doesn't even have a reason
listed for it, although my dim memory of it is that the reason was
preemption latency.

And that caused big regressions too.

Of course, since then, we may well have screwed things up and now we
sleep under it, but I still really think it was a mistake to do it in
the first place.

So if the primary reason for this is really just that f*cking anon_vma
lock, then I would seriously suggest:

 - turn it back into a spinlock (or rwlock_t, since we subsequently
separated the read and write paths)

 - fix up any breakage (ie new scheduling points) that exposes

 - look at possible other approaches wrt latency on that thing.

Hmm?

                Linus
