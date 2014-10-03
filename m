Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754587AbaJCVTh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 17:19:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64566 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750939AbaJCVTg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:19:36 -0400
Date: Fri, 3 Oct 2014 23:16:10 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        luto@amacapital.net, dvlasenk@redhat.com, tglx@linutronix.de
Subject: Re: [tip:x86/asm] x86: Speed up ___preempt_schedule*() by using
	THUNK helpers
Message-ID: <20141003211610.GA28811@redhat.com>
References: <20140921184153.GA23727@redhat.com> <tip-0ad6e3c5199be12c9745da8f8b9e3c9f8066c235@git.kernel.org> <542E2B05.5080607@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <542E2B05.5080607@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sasha,

On 10/03, Sasha Levin wrote:
>
> On 09/24/2014 11:02 AM, tip-bot for Oleg Nesterov wrote:
> > Commit-ID:  0ad6e3c5199be12c9745da8f8b9e3c9f8066c235
> > Gitweb:     http://git.kernel.org/tip/0ad6e3c5199be12c9745da8f8b9e3c9f8066c235
> > Author:     Oleg Nesterov <oleg@redhat.com>
> > AuthorDate: Sun, 21 Sep 2014 20:41:53 +0200
> > Committer:  Ingo Molnar <mingo@kernel.org>
> > CommitDate: Wed, 24 Sep 2014 15:15:38 +0200
> >
> > x86: Speed up ___preempt_schedule*() by using THUNK helpers
> >
> > ___preempt_schedule() does SAVE_ALL/RESTORE_ALL but this is
> > suboptimal, we do not need to save/restore the callee-saved
> > register. And we already have arch/x86/lib/thunk_*.S which
> > implements the similar asm wrappers, so it makes sense to
> > redefine ___preempt_schedule() as "THUNK ..." and remove
> > preempt.S altogether.
> >
> > Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> > Reviewed-by: Andy Lutomirski <luto@amacapital.net>
> > Cc: Denys Vlasenko <dvlasenk@redhat.com>
> > Cc: Peter Zijlstra <peterz@infradead.org>
> > Cc: Linus Torvalds <torvalds@linux-foundation.org>
> > Link: http://lkml.kernel.org/r/20140921184153.GA23727@redhat.com
> > Signed-off-by: Ingo Molnar <mingo@kernel.org>
> > ---
>
> Hi Oleg,
>
> I *think* that this patch is causing the following trace (arch/x86/lib/thunk_64.S:44
> is new code introduced by this patch):

Not sure, but I'm afraid your guess can be correct...

> [  921.908530] kernel BUG at kernel/sched/core.c:2702!

OK, this is schedule_debug() -> BUG_ON(unlikely(task_stack_end_corrupted(prev)))
in linux-next.

But at first glance this doesn't match the disassembled code... Could you
send me (privately) your kernel/sched/core.c just in case? And .config
please. And, if possible, kernel/sched/core.s

Oleg.

