Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756562Ab3JNPC4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 11:02:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36589 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756036Ab3JNPCx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 11:02:53 -0400
Date: Mon, 14 Oct 2013 16:55:39 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Anton Arapov <aarapov@redhat.com>,
        David Smith <dsmith@redhat.com>, "Frank Ch. Eigler" <fche@redhat.com>,
        Martin Cermak <mcermak@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] uprobes: Change uprobe_copy_process() to dup
	xol_area
Message-ID: <20131014145539.GA4319@redhat.com>
References: <20131013191815.GA32466@redhat.com> <20131013191844.GA32502@redhat.com> <20131014140942.GI28601@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131014140942.GI28601@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14, Peter Zijlstra wrote:
>
> On Sun, Oct 13, 2013 at 09:18:44PM +0200, Oleg Nesterov wrote:
> > This finally fixes the serious bug in uretprobes: a forked child
> > crashes if the parent called fork() with the pending ret probe.
> > ...
> >
> > Unfortunately, this also means that we can not handle the errors
> > properly, we obviously can not abort the already completed fork().
> > So we simply print the warning if GFP_KERNEL allocation (the only
> > possible reason) fails.
>
> Oh cute.. so we could actually ignore this perf_event_mmap() because we
> got it for the parent when we inserted the probe, and the perf tools
> assume the child mm layout is identical to the parent layout (it doesn't
> actually see the VM_DONTCOPY bit).
>
> So we could add: 'if (vma->vm_mm != current->mm) return;' to
> perf_event_mmap() with a very big nasty comment.

Perhaps. I can't really comment, but this is really nasty. I mean, this
simply doesn't look good. perf_event_mmap() will be reported or not
depending on how/why the task creates xol_area.

> That said; should we hide the XOL vma from perf altogether? That is; it
> will greatly obfuscate the perf data to get hits from the XOL table as
> we've got no means of mapping it back to an instruction.

Again, I can't really comment. But this creates the special case. OK,
xol_area is "special" anon mapping anyway, but still. And of course
this needs __install_special_mapping().

So I'd prefer to push these changes as is for now. GFP_KERNEL should
"never" fail and we need the fix for stable.

I agree, in the long term we should fix the inability to handle the
errors correctly. But this needs more changes and more uprobes hooks.
To simplify, suppose that we simply remove perf_event_mmap() from
install_special_mapping() (yes, wes, we cant'). Then we should:

	1. revert 1/5, it already moves uprobe_copy_process() to the
	   point-of-no-return (for 4-5).

	2. uprobe_copy_process() can avoid task_work_add() _and_ it can
	   return an error if dup_utask/dup_xol fails.

	3. However, 2. means that we need to handle the potential errors
	   after uprobe_copy_process() suceeds. This means we need, say,
	   uprobe_abort_fork() somewhere near bad_fork_cleanup_mm.

So will you agree with task_work for now?

Oleg.

