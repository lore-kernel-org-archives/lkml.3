Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753417AbaIVIVf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 04:21:35 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57789 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753166AbaIVIVd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 04:21:33 -0400
Date: Mon, 22 Sep 2014 10:21:30 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Cong Wang <xiyou.wangcong@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Tejun Heo <tj@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Patch v4 1/2] freezer: check OOM kill while being frozen
Message-ID: <20140922082130.GC336@dhcp22.suse.cz>
References: <1409869842-10807-1-git-send-email-xiyou.wangcong@gmail.com>
 <1527959.PBej7RR7ig@vostro.rjw.lan>
 <20140915005657.GA11267@mtj.dyndns.org>
 <4489261.oHB60C5hao@vostro.rjw.lan>
 <20140915093608.GA19976@dhcp22.suse.cz>
 <CAM_iQpXLEvxvf7=iyJ=FiviSenCwFB10cyEWHvX6HSs=f7kt8w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM_iQpXLEvxvf7=iyJ=FiviSenCwFB10cyEWHvX6HSs=f7kt8w@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Sorry for the late reply, I was mostly offline throughout last week]

On Tue 16-09-14 15:55:48, Cong Wang wrote:
> On Mon, Sep 15, 2014 at 2:36 AM, Michal Hocko <mhocko@suse.cz> wrote:
> > This patch builds on top of Cong Wang's. What do you think?
> 
> I think it is should a preliminary of my patch, not a followup.

Well, this looks like a chicken/egg problem. OOM killer currently
doesn't kill any frozen task which is fixed by your patch. So it should
be logically the first to apply. On the other hand that patch opens a
race fixed by this patch. I think the race is really unlikely and we
your patch basically fixes a regression so I would expect it to come
first.

Anyway, I will leave the proper ordering on you if you do not mind.

> I can carry this patch for you if you want.

Would be great, thanks!

> > ---
> > From cdf97a20b107ee584352f07274a88d7c3f014ab2 Mon Sep 17 00:00:00 2001
> > From: Michal Hocko <mhocko@suse.cz>
> > Date: Mon, 15 Sep 2014 10:52:30 +0200
> > Subject: [PATCH] OOM, PM: OOM killed task cannot escape PM suspend
> >
> > PM freezer relies on having all tasks frozen by the time devices are
> > getting frozen so that no task will touch them while they are getting
> > frozen. But OOM killer is allowed to kill an already frozen task in
> > order to handle OOM situtation. In order to protect from late wake ups
> > OOM killer is disabled after all tasks are frozen. This, however, still
> > keeps an window open when a killed task didn't manage to die by the time
> > freeze_processes finishes. Fix this by checking all tasks after OOM
> > killer has been disabled. To prevent from useless check also introduce
> > and check oom_kills count which gets incremented when a task is killed
> > by OOM killer. All the tasks have to be checked only if the counter
> > changes.
> 
> 
> Not sure if I understand your patch correctly, seems you are checking if
> there is any ongoing OOM killer during PM suspend, since oom_kills
> will always increase,

Yeah, I didn't want to pointlessly iterate over all tasks when nothing
happened. OOM is a rare action so this check should be in a slow path.

> maybe a seqlock is more clear?

I wanted to have it as simple as possible and simple counter sounded
like a good fit. seqlock sounds like overkill to me.
-- 
Michal Hocko
SUSE Labs
