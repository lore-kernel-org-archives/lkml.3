Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762AbaLBSbf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 13:31:35 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:64701 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754582AbaLBSbd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 13:31:33 -0500
Date: Tue, 2 Dec 2014 19:31:30 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        David Rientjes <rientjes@google.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] oom: don't assume that a coredumping thread will
 exit soon
Message-ID: <20141202183130.GM27014@dhcp22.suse.cz>
References: <20141127230349.GA25075@redhat.com>
 <20141127230405.GA25093@redhat.com>
 <20141202091947.GB27014@dhcp22.suse.cz>
 <20141202175041.GA20314@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141202175041.GA20314@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 02-12-14 18:50:41, Oleg Nesterov wrote:
> On 12/02, Michal Hocko wrote:
> >
> > On Fri 28-11-14 00:04:05, Oleg Nesterov wrote:
> >
> > > Note: this is only the first step, this patch doesn't try to solve other
> > > problems. For example it doesn't try to clear the wrongly set TIF_MEMDIE
> > > (SIGNAL_GROUP_COREDUMP check is obviously racy),
> >
> > I am not sure I understand this. What do you mean by wrongly set
> > TIF_MEMDIE? That we give a process access to reserves even though it is
> > already done with the coredumping?
> 
> I meant that (say) oom_kill_process() can set TIF_MEMDIE because
> PF_EXITING && !SIGNAL_GROUP_COREDUMP, and after that this task can
> participate the coredumping. For example, this thread can exit on its
> own, but before it calls exit_mm() another thread can start the coredump.
> 
> In this case TIF_MEMDIE can fool oom-killer the same way,
> oom_scan_process_thread() returns OOM_SCAN_ABORT if TIF_MEMDIE is set.
> 
> > > fatal_signal_pending() can be false positive, etc.
> >
> > When can this happen?
> 
> I meant "if (fatal_signal_pending(current) || task_will_free_mem(current))"
> in out_of_memory(). Yes, sorry, "false positive" looks confusing. I meant
> that fatal_signal_pending() can be true because of SIGNAL_GROUP_COREDUMP.

Ahh, OK I guess I see what you meant.
 
> > > Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> >
> > I guess the patch as is makes sense and it is an improvement. We need
> > to call the helper in mem_cgroup_out_of_memory as well, though.
> 
> Yes, but can't we do this in a separate patch?

I would prefer if it was in the same patch because we might be facing
the same problem in memcg as with the global case. And worse, smaller
limit tend to trigger corner cases more often than the global case.

> try_charge() plays with TIF_MEMDIE/PF_EXITING too, but probably this
> is fine.

try_charge is OK because this is from the time when the allocation has
been already done and we just decide to bypass the charge.

> > With that feel free to add
> > Acked-by: Michal Hocko <mhocko@suse.cz>
> 
> Thanks.
> 
> > Also the original fix for the coredumping (edd45544c6f0 "oom: avoid
> > deferring oom killer if exiting task is being traced") doesn't work
> > really as per http://marc.info/?l=linux-kernel&m=141711049013620 then
> > this and the follow up patch should be marked for stable I guess.
> 
> Perhaps this makes sense. It looks simple enough.
> 
> Oleg.
> 

-- 
Michal Hocko
SUSE Labs
