Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753284Ab3FAK3T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 06:29:19 -0400
Received: from mail-ye0-f169.google.com ([209.85.213.169]:45372 "EHLO
	mail-ye0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751635Ab3FAK3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 06:29:09 -0400
Date: Sat, 1 Jun 2013 12:29:05 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        cgroups@vger.kernel.org
Subject: Re: [patch] mm, memcg: add oom killer delay
Message-ID: <20130601102905.GB19474@dhcp22.suse.cz>
References: <alpine.DEB.2.02.1305291817280.520@chino.kir.corp.google.com>
 <20130530150539.GA18155@dhcp22.suse.cz>
 <alpine.DEB.2.02.1305301338430.20389@chino.kir.corp.google.com>
 <20130531081052.GA32491@dhcp22.suse.cz>
 <alpine.DEB.2.02.1305310316210.27716@chino.kir.corp.google.com>
 <20130531112116.GC32491@dhcp22.suse.cz>
 <alpine.DEB.2.02.1305311224330.3434@chino.kir.corp.google.com>
 <20130601061151.GC15576@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130601061151.GC15576@cmpxchg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 01-06-13 02:11:51, Johannes Weiner wrote:
[...]
> I'm currently messing around with the below patch.  When a task faults
> and charges under OOM, the memcg is remembered in the task struct and
> then made to sleep on the memcg's OOM waitqueue only after unwinding
> the page fault stack.  With the kernel OOM killer disabled, all tasks
> in the OOMing group sit nicely in
> 
>   mem_cgroup_oom_synchronize
>   pagefault_out_of_memory
>   mm_fault_error
>   __do_page_fault
>   page_fault
>   0xffffffffffffffff
> 
> regardless of whether they were faulting anon or file.  They do not
> even hold the mmap_sem anymore at this point.
> 
> [ I kept syscalls really simple for now and just have them return
>   -ENOMEM, never trap them at all (just like the global OOM case).
>   It would be more work to have them wait from a flatter stack too,
>   but it should be doable if necessary. ]
> 
> I suggested this at the MM summit and people were essentially asking
> if I was feeling well, so maybe I'm still missing a gaping hole in
> this idea.

I didn't get to look at the patch (will do on Monday) but it doesn't
sounds entirely crazy. Well, we would have to drop mmap_sem so things
have to be rechecked but we are doing that already with VM_FAULT_RETRY
in some archs so it should work.

> Patch only works on x86 as of now, on other architectures memcg OOM
> will invoke the global OOM killer.
[...]
-- 
Michal Hocko
SUSE Labs
