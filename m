Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754510Ab3JNOJ7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 10:09:59 -0400
Received: from merlin.infradead.org ([205.233.59.134]:58130 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926Ab3JNOJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 10:09:58 -0400
Date: Mon, 14 Oct 2013 16:09:42 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Anton Arapov <aarapov@redhat.com>,
        David Smith <dsmith@redhat.com>, "Frank Ch. Eigler" <fche@redhat.com>,
        Martin Cermak <mcermak@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] uprobes: Change uprobe_copy_process() to dup xol_area
Message-ID: <20131014140942.GI28601@twins.programming.kicks-ass.net>
References: <20131013191815.GA32466@redhat.com>
 <20131013191844.GA32502@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131013191844.GA32502@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 13, 2013 at 09:18:44PM +0200, Oleg Nesterov wrote:
> This finally fixes the serious bug in uretprobes: a forked child
> crashes if the parent called fork() with the pending ret probe.
> 
> Trivial test-case:
> 
> 	# perf probe -x /lib/libc.so.6 __fork%return
> 	# perf record -e probe_libc:__fork perl -le 'fork || print "OK"'
> 
> (the child doesn't print "OK", it is killed by SIGSEGV)
> 
> If the child returns from the probed function it actually returns
> to trampoline_vaddr, because it got the copy of parent's stack
> mangled by prepare_uretprobe() when the parent entered this func.
> 
> It crashes because a) this address is not mapped and b) until the
> previous change it doesn't have the proper->return_instances info.
> 
> This means that uprobe_copy_process() has to create xol_area which
> has the trampoline slot, and its vaddr should be equal to parent's
> xol_area->vaddr.
> 
> Unfortunately, uprobe_copy_process() can not simply do
> __create_xol_area(child, xol_area->vaddr). This could actually work
> but perf_event_mmap() doesn't expect the usage of foreign ->mm. So
> we offload this to task_work_run(), and pass the argument via not
> yet used utask->vaddr.
> 
> We know that this vaddr is fine for install_special_mapping(), the
> necessary hole was recently "created" by dup_mmap() which skips the
> parent's VM_DONTCOPY area, and nobody else could use the new mm.
> 
> Unfortunately, this also means that we can not handle the errors
> properly, we obviously can not abort the already completed fork().
> So we simply print the warning if GFP_KERNEL allocation (the only
> possible reason) fails.

Oh cute.. so we could actually ignore this perf_event_mmap() because we
got it for the parent when we inserted the probe, and the perf tools
assume the child mm layout is identical to the parent layout (it doesn't
actually see the VM_DONTCOPY bit).

So we could add: 'if (vma->vm_mm != current->mm) return;' to
perf_event_mmap() with a very big nasty comment.

That said; should we hide the XOL vma from perf altogether? That is; it
will greatly obfuscate the perf data to get hits from the XOL table as
we've got no means of mapping it back to an instruction.

We could transform the perf IP from XOL areas back to the original
instruction site. The only side effect that has is that since the XOL
code is far more expensive than the original single instruction the
instruction appears excessively more expensive than expected.

Thoughts?
