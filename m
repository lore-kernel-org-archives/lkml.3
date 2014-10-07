Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753536AbaJGMXi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 08:23:38 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47660 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752016AbaJGMXg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 08:23:36 -0400
Date: Tue, 7 Oct 2014 14:23:36 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Greg KH <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org
Subject: Re: Please backport commit 3812c8c8f39 to stable
Message-ID: <20141007122336.GB14243@dhcp22.suse.cz>
References: <CAM_iQpVf3ga5vVbhKmXySvK9ibh9bGgnGHFBOFtmag9=uh8D=A@mail.gmail.com>
 <20140930081637.GA4456@dhcp22.suse.cz>
 <CAM_iQpXx3ULtPr50ESTZk1+984vSG9-dKegEjawDZ2yJS3CTdw@mail.gmail.com>
 <20141003151334.GE4816@dhcp22.suse.cz>
 <CAM_iQpW4t_jKSCbS5J1N15FFChd=-UK3QOXrjjst64Rqe5KBTw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM_iQpW4t_jKSCbS5J1N15FFChd=-UK3QOXrjjst64Rqe5KBTw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 03-10-14 11:03:30, Cong Wang wrote:
> On Fri, Oct 3, 2014 at 8:13 AM, Michal Hocko <mhocko@suse.cz> wrote:
> >
> > That commit fixes an OOM deadlock. Not a soft lockup. Do you have the
> > OOM killer report from the log? This would tell us that the killed task
> > was indeed sleeping on the lock which is hold by the charger which
> > triggered the OOM. I am little bit surprised that I do not see any OOM
> > related functions on the stacks (maybe the code is inlined...).
> 
> 
> Oh, did you see __mem_cgroup_try_charge() calls
> schedule_timeout_uninterruptible() in stack trace? Yes, they are inlined
> and I don't see any other possibilities for calling it.

Yes the only place we call schedule_timeout_uninterruptible from is
mem_cgroup_handle_oom. And it happens only for a task which hasn't been
killed by OOM killer.

> > It would be better to know what exactly is going on before backporting
> > this change because it is quite large.
> >
> 
> I thought the stack trace I showed is obvious. :) I am very happy
> to investigate if you see any other path calling
> schedule_timeout_uninterruptible()
> in __mem_cgroup_try_charge().

I was expecting an oom report which kills a task which is sleeping on a
lock which is held on the way up to the charge function. Your report
mentioned a task waiting for i_mutex for too long. It is true that the
charging path is holding an i_mutex as well so it might be the same
situation handled by the said patch. But it is not 100% clear this is
the case without an OOM report which would point to the waiting task.
The memcg might be trashing on the hard limit and reclaim might take a
long time.

-- 
Michal Hocko
SUSE Labs
