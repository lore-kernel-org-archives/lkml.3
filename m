Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751160AbaKFPJd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 10:09:33 -0500
Received: from mail-qc0-f176.google.com ([209.85.216.176]:35079 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151AbaKFPJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 10:09:31 -0500
Date: Thu, 6 Nov 2014 10:09:27 -0500
From: Tejun Heo <tj@kernel.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        David Rientjes <rientjes@google.com>, Oleg Nesterov <oleg@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: [PATCH 3/4] OOM, PM: OOM killed task shouldn't escape PM suspend
Message-ID: <20141106150927.GB25642@htj.dyndns.org>
References: <20141105130247.GA14386@htj.dyndns.org>
 <20141105133100.GC4527@dhcp22.suse.cz>
 <20141105134219.GD4527@dhcp22.suse.cz>
 <20141105154436.GB14386@htj.dyndns.org>
 <20141105160115.GA28226@dhcp22.suse.cz>
 <20141105162929.GD14386@htj.dyndns.org>
 <20141105163956.GD28226@dhcp22.suse.cz>
 <20141105165428.GF14386@htj.dyndns.org>
 <20141105170111.GG14386@htj.dyndns.org>
 <20141106130543.GE7202@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141106130543.GE7202@dhcp22.suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2014 at 02:05:43PM +0100, Michal Hocko wrote:
> But this is nothing new. Suspend hasn't been checking for fatal signals
> nor for TIF_MEMDIE since the OOM disabling was introduced and I suppose
> even before.
> 
> This is not harmful though. The previous OOM kill attempt would kick the
> current TASK and mark it with TIF_MEMDIE and retry the allocation. After
> OOM is disabled the allocation simply fails. The current will die on its
> way out of the kernel. Definitely worth fixing. In a separate patch.

Hah?  Isn't this a new outright A-B B-A deadlock involving the rwsem
you added?

> > disable() call must be able to fail.
> 
> This would be a way to do it without requiring caller to check for
> TIF_MEMDIE explicitly. The fewer of them we have the better.

Why the hell would the caller ever even KNOW about this?  This is
something which must be encapsulated in the OOM killer disable/enable
interface.

> +bool oom_killer_disable(void)
>  {
> +	bool ret = true;
> +
>  	down_write(&oom_sem);

How would this task pass the above down_write() if the OOM killer is
already read locking oom_sem?  Or is the OOM killer guaranteed to make
forward progress even if the killed task can't make forward progress?
But, if so, what are we talking about in this thread?

> +
> +	/* We might have been killed while waiting for the oom_sem. */
> +	if (fatal_signal_pending(current) || test_thread_flag(TIF_MEMDIE)) {
> +		up_write(&oom_sem);
> +		ret = false;
> +	}

This is pointless.  What does the above do?

-- 
tejun
