Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757140Ab3JNTIJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 15:08:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40994 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755590Ab3JNTII (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 15:08:08 -0400
Date: Mon, 14 Oct 2013 21:00:54 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Anton Arapov <aarapov@redhat.com>,
        David Smith <dsmith@redhat.com>, "Frank Ch. Eigler" <fche@redhat.com>,
        Martin Cermak <mcermak@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] uprobes: Change uprobe_copy_process() to dup
	return_instances
Message-ID: <20131014190054.GA15710@redhat.com>
References: <20131013191815.GA32466@redhat.com> <20131013191841.GA32499@redhat.com> <20131014184548.GG2675@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131014184548.GG2675@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14, Peter Zijlstra wrote:
>
> On Sun, Oct 13, 2013 at 09:18:41PM +0200, Oleg Nesterov wrote:
> > uprobe_copy_process() assumes that the new child doesn't need
> > ->utask, it should be allocated by demand.
> >
> > But this is not true if the forking task has the pending ret-
> > probes, the child should report them as well and thus it needs
> > the copy of parent's ->return_instances chain. Otherwise the
> > child crashes when it returns from the probed function.
>
> So children don't automagically inherit the same probes

They actually do. And in this case they also "inherit" the fact that
the probed function was called, even if the forked child didn't do
this actually.

> so wouldn't simply fixing up the
> child stack be a solution?

This was plan A ;)

> If not; its not entirely clear to my why this isn't a good solution

Tthis doesn't look correct, although "correct" is subjective and we
never tried to enforce the rules before. But at least stap wants to
see the reports from the child.

Another reason is that this needs the arch-specific changes/hooks.
Say, I simply do not know how we can "revert" the effect of
"regs->link = trampoline_vaddr" on powerpc, this looks simply
impossible.

And even on x86 we either need __access_remote_vm() from copy_process()
or or dup_utask() + task_work_run() so that the child can do this itself.

(plus we also need to change prepare_uretprobe(), say, on x86 it should
 record regs->sp in return_instance, but this is minor).

> based on these changelogs.

Note the "the child should report them as well"... but yes, agreed,
I will update the changelog.

Oleg.

