Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754785Ab3I3BLR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 21:11:17 -0400
Received: from mail-qa0-f51.google.com ([209.85.216.51]:48103 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754509Ab3I3BLP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 21:11:15 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFyx-Lpqd8i2tHvhXCqL+nJZPq-6SikEkb-cQZEU9ogRjA@mail.gmail.com>
References: <1380308424-31011-1-git-send-email-Waiman.Long@hp.com>
	<CA+55aFxXeQ69B1bfrO+0QtBqm0gt688LOshx=ppNjch10JF8FQ@mail.gmail.com>
	<20130928074144.GA17773@gmail.com>
	<CA+55aFyx-Lpqd8i2tHvhXCqL+nJZPq-6SikEkb-cQZEU9ogRjA@mail.gmail.com>
Date: Sun, 29 Sep 2013 18:11:13 -0700
Message-ID: <CANN689GLde8ZY5yLadbgGrC3eagrY_quQRnTdD_nywP8m1McjA@mail.gmail.com>
Subject: Re: [PATCH] rwsem: reduce spinlock contention in wakeup code path
From: Michel Lespinasse <walken@google.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>, Waiman Long <Waiman.Long@hp.com>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Alex Shi <alex.shi@intel.com>, Tim Chen <tim.c.chen@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Matthew R Wilcox <matthew.r.wilcox@intel.com>,
        Dave Hansen <dave.hansen@intel.com>, Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 28, 2013 at 11:55 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> Btw, I really hate that thing. I think we should turn it back into a
> spinlock. None of what it protects needs a mutex or an rwsem.
>
> Because you guys talk about the regression of turning it into a rwsem,
> but nobody talks about the *original* regression.
>
> And it *used* to be a spinlock, and it was changed into a mutex back
> in 2011 by commit 2b575eb64f7a. That commit doesn't even have a reason
> listed for it, although my dim memory of it is that the reason was
> preemption latency.

I was wondering about that too. Regarding latencies, we used to have
unbounded latencies for anon_vma operations as the AVC chains could
get long under some workloads; now that we index the VMAs matching a
given anon_vma with an interval tree this particular source of
latencies should be gone. So yes, it could be worth trying to go back
to a non-sleeping lock.

That said, I am very scared of using rwlock_t here, and I would much
prefer we choose a fair lock (either spinlock or a new rwlock
implementation which guarantees not to starve any locker thread)

-- 
Michel Lespinasse
A program is never fully debugged until the last user dies.
