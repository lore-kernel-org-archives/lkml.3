Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754330AbaLBTQp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 14:16:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37489 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751060AbaLBTQn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 14:16:43 -0500
Date: Tue, 2 Dec 2014 20:16:22 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        David Rientjes <rientjes@google.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] oom: don't assume that a coredumping thread will
	exit soon
Message-ID: <20141202191622.GA24313@redhat.com>
References: <20141127230349.GA25075@redhat.com> <20141127230405.GA25093@redhat.com> <20141202091947.GB27014@dhcp22.suse.cz> <20141202175041.GA20314@redhat.com> <20141202183130.GM27014@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141202183130.GM27014@dhcp22.suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/02, Michal Hocko wrote:
>
> On Tue 02-12-14 18:50:41, Oleg Nesterov wrote:
> > On 12/02, Michal Hocko wrote:
> > >
> > > I guess the patch as is makes sense and it is an improvement. We need
> > > to call the helper in mem_cgroup_out_of_memory as well, though.
> >
> > Yes, but can't we do this in a separate patch?
>
> I would prefer if it was in the same patch because we might be facing
> the same problem in memcg as with the global case. And worse, smaller
> limit tend to trigger corner cases more often than the global case.

OK, I'll do V2...

But let me explain why I thought about another patch. I do not want
to export task_will_free_mem(). If nothing else, its name matches the
current "quickly exit and free its memory" comments but not the reality.
An exiting thread won't free the memory (ignoring task_struct/etc) if
the process is multithreaded.

I'd rather add another helper for oom_kill.c and memcontrol.c which does

	if (fatal_signal_pending(current) || task_will_free_mem(current)) {
		set_thread_flag(TIF_MEMDIE);
		return true;
	}

	return false;

This way the patch could document that fatal_signal_pending() is not
exactly right as we discussed, and then we can improve this helper.

But OK, probably this helper doesn't really make sense, and I can not
invent the good name for it ;)

> > try_charge() plays with TIF_MEMDIE/PF_EXITING too, but probably this
> > is fine.
>
> try_charge is OK because this is from the time when the allocation has
> been already done and we just decide to bypass the charge.

Yes, thanks, this was my vague understanding but I wasn't sure. However,
I am not sure that PF_EXITING check is 100% right (again, this can only
mean that a single thread from a thread group exits), but I do not
understand this code and I agree this is another story in any case.

Oleg.

