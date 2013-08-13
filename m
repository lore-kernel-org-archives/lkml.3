Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932068Ab3HMQib (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 12:38:31 -0400
Received: from mail-ve0-f176.google.com ([209.85.128.176]:34078 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758706Ab3HMQiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 12:38:10 -0400
MIME-Version: 1.0
In-Reply-To: <20130813162916.GD24092@twins.programming.kicks-ass.net>
References: <20130812115113.GE27162@twins.programming.kicks-ass.net>
	<CA+55aFznj9WqGa_Qa0B4=5iTio2br54uJG7xkm6otN2sG2P=8w@mail.gmail.com>
	<20130812175830.GB18691@gmail.com>
	<CA+55aFw=S4xxdkKpjQdg77CehBBW6S-13N6-7tq4=-nN_cCUKA@mail.gmail.com>
	<20130813103056.GA2170@gmail.com>
	<20130813122652.GA24092@twins.programming.kicks-ass.net>
	<CA+55aFxieQGUkEi9i=LRzVK2DRvavKgF-YEvskvJhF3-5xiU2A@mail.gmail.com>
	<20130813162916.GD24092@twins.programming.kicks-ass.net>
Date: Tue, 13 Aug 2013 09:38:09 -0700
X-Google-Sender-Auth: T37B-FN99pZH_9AbyqwkphX8owA
Message-ID: <CA+55aFwfqnHQtCVVm8dd8W7pOwrGquyxwJk_0MQo=SxiHaYTeA@mail.gmail.com>
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

On Tue, Aug 13, 2013 at 9:29 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>
> The inverted need_resched that gives decl+jnz idea from Ingo should do
> it though.

I agree that that is a good approach.

> Not entirely sure I understand your MSB + jns suggestion:
>
>   0x80000002 - 1 = 0x80000001
>
> Both are very much signed and neither wants to cause a reschedule.

The thing is, we don't check the preempt count even currently, so the
above isn't fatal. The "need preemption" bit being set (or reset with
the reverse bit meaning) should be the unusual case with preemption
(you have to hit the race), *and* it should be unusual to have deeply
nested preemption anyway, so it's fine to test that in the slow path
(and we do: preempt_schedule() checks the preempt count being zero and
irqs being disabled, *exactly* because the preemption enable check
isn't precise).

But avoiding a few sloppy cases is certainly good, even if they are
unusual, so I do like the reversed bit approach. It also allows us to
pick any arbitrary bit, although I'm not sure that matters much.

               Linus
