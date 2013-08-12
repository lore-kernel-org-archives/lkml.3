Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755103Ab3HLSx2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 14:53:28 -0400
Received: from mail-ve0-f172.google.com ([209.85.128.172]:45779 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752961Ab3HLSx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 14:53:26 -0400
MIME-Version: 1.0
In-Reply-To: <520920AF.1050407@zytor.com>
References: <20130812115113.GE27162@twins.programming.kicks-ass.net>
	<CA+55aFznj9WqGa_Qa0B4=5iTio2br54uJG7xkm6otN2sG2P=8w@mail.gmail.com>
	<520920AF.1050407@zytor.com>
Date: Mon, 12 Aug 2013 11:53:25 -0700
X-Google-Sender-Auth: yiIN_VvthLfgFgX2hKNiBP8d2Wg
Message-ID: <CA+55aFwP0nXWJ3-YXCxZC3kCJ-5nVG7dEbqqJa-HF5pdEc+xsg@mail.gmail.com>
Subject: Re: [RFC] per-cpu preempt_count
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mike Galbraith <bitbucket@online.de>, Andi Kleen <ak@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 12, 2013 at 10:51 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>
> So we would have code looking something like:
>
>         decl %fs:preempt_count
>         jnz 1f
>         cmpb $0,%fs:need_resched
>         je 1f
>         call __preempt_schedule
> 1:
>
> It's a nontrivial amount of code, but would seem a fair bit better than
> what we have now, at least.

Well, we currently don't even bother checking the preempt count at
all, and we just optimistically assume that we don't nest in the
common case. The preempt count is then re-checked in
__preempt_schedule, I think.

Which sounds like a fair approach.

So the code would be simplified to just

         decl %fs:preempt_count
         cmpb $0,%fs:need_resched
         jne .. unlikely branch that calls __preempt_schedule

which is not horrible. Not *quite* as nice as just doing a single
"decl+js", but hey, certainly better than what we have now.

             Linus
