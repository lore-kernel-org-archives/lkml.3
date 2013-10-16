Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934421Ab3JPMxh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 08:53:37 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:56335 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934006Ab3JPMxf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 08:53:35 -0400
Date: Wed, 16 Oct 2013 18:23:27 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Anton Arapov <aarapov@redhat.com>,
        David Smith <dsmith@redhat.com>, "Frank Ch. Eigler" <fche@redhat.com>,
        Martin Cermak <mcermak@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] uprobes: Change uprobe_copy_process() to dup xol_area
Message-ID: <20131016125327.GI19729@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20131013191815.GA32466@redhat.com>
 <20131013191844.GA32502@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20131013191844.GA32502@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13101612-3532-0000-0000-000002355267
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2013-10-13 21:18:44]:

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


I was actually thinking if we can remove the VM_DONTCOPY from
install_special_mapping, But there are obvious issues with that approach
+ lot more house keeping. So your approach is much much better.

> 
> Unfortunately, this also means that we can not handle the errors
> properly, we obviously can not abort the already completed fork().
> So we simply print the warning if GFP_KERNEL allocation (the only
> possible reason) fails.
> 
> Cc: stable@vger.kernel.org # 3.9+
> Reported-by: Martin Cermak <mcermak@redhat.com>
> Reported-by: David Smith <dsmith@redhat.com>
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

-- 
Thanks and Regards
Srikar Dronamraju

