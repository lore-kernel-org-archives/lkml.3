Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756039Ab3JNKYj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 06:24:39 -0400
Received: from merlin.infradead.org ([205.233.59.134]:52661 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756007Ab3JNKYh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 06:24:37 -0400
Date: Mon, 14 Oct 2013 12:24:26 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: perf_event_mmap(vma) && !vma->vm_mm
Message-ID: <20131014102426.GX3081@twins.programming.kicks-ass.net>
References: <20131012192203.GA21738@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131012192203.GA21738@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 12, 2013 at 09:22:03PM +0200, Oleg Nesterov wrote:
> Hi,
> 
> I am fighting with uprobe bug, and perf_event_mmap() complicates
> the problem, it is the only reason (afaics) why the forking task
> can not do install_special_mapping(new_child_mm). This means that
> the child should do this itself, say, from task_work_run() but
> this way it can't handle the error if get_xol_area() fails, too
> late to abort the already finished copy_process().
> 
> But please ignore, the only question is that I can't understand
> this
> 
> 	if (!vma->vm_mm) {
> 		name = strncpy(tmp, "[vdso]", sizeof(tmp));
> 		goto got_name;
> 	}
> 
> code in perf_event_mmap_event() and I am just curious. How it is
> possible that vma->vm_mm == NULL ? perf_event_mmap(vma) is never
> called with, say, vma == gate_vma. And even if it was possible
> arch_vma_name() should handle this case?

Uuuhhhh... I wrote that didn't I ;-)

So I think that was due to the x86_32 gate_vma, but yes I don't think
we'd ever call perf_event_mmap() (perf_counter_mmap at the time) on it.

Also, the x86_32 arch_vma_name() didn't deal with the gate_vma (it still
doesn't appear to do so) as opposed to x86_64 which does.

But the main reason I added it was because task_mmu.c:show_map_vma() did
so too; I just wanted to be extra careful.

