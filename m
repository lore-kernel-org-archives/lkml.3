Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758286Ab3HMPjs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 11:39:48 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:54198 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757741Ab3HMPjr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 11:39:47 -0400
MIME-Version: 1.0
In-Reply-To: <20130813122652.GA24092@twins.programming.kicks-ass.net>
References: <20130812115113.GE27162@twins.programming.kicks-ass.net>
	<CA+55aFznj9WqGa_Qa0B4=5iTio2br54uJG7xkm6otN2sG2P=8w@mail.gmail.com>
	<20130812175830.GB18691@gmail.com>
	<CA+55aFw=S4xxdkKpjQdg77CehBBW6S-13N6-7tq4=-nN_cCUKA@mail.gmail.com>
	<20130813103056.GA2170@gmail.com>
	<20130813122652.GA24092@twins.programming.kicks-ass.net>
Date: Tue, 13 Aug 2013 08:39:46 -0700
X-Google-Sender-Auth: gLdYrWmmpjQ8FwKBfrtLdbdAAfQ
Message-ID: <CA+55aFxieQGUkEi9i=LRzVK2DRvavKgF-YEvskvJhF3-5xiU2A@mail.gmail.com>
Subject: Re: [RFC] per-cpu preempt_count
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Mike Galbraith <bitbucket@online.de>, Peter Anvin <hpa@zytor.com>,
        Andi Kleen <ak@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 13, 2013 at 5:26 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>
> So we're now down to something like:
>
>   decl fs:preempt_count
>   cmpl PREEMPT_NEED_RESCHED,fs:preempt_count
>   jnz 1f

Well, this isn't worth doing unless you can make PREEMPT_NEED_RESCHED
be the high bit, and we can combine it into just "decl+jns". Otherwise
we'd be better off with the simpler two separate adjacent variables.

Also, I think your patch is too big, and you should have aim to just
made the "preempt_count()" helper function mask off PREEMPT_MASK, so
that you don't change the semantics of that. I realize that there are
a couple of users that do things like "preempt_count() += x", and you
probably wanted to keep those working, but I think it is easier (and
cleaner) to fix those to "preempt_count_update(x)" instead of adding
all those explicitly PREEMPT_MASK masks.

Hmm?

             Linus
