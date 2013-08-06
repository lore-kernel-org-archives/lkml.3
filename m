Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754585Ab3HFOJW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 10:09:22 -0400
Received: from mail-qc0-f176.google.com ([209.85.216.176]:61539 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752013Ab3HFOJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 10:09:20 -0400
Date: Tue, 6 Aug 2013 10:09:04 -0400
From: Tejun Heo <tj@kernel.org>
To: Balbir Singh <bsingharora@gmail.com>
Cc: lizefan@huawei.com, Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/5] cgroup, memcg: move cgroup_event implementation to
 memcg
Message-ID: <20130806140904.GA9814@mtj.dyndns.org>
References: <1375632446-2581-1-git-send-email-tj@kernel.org>
 <1375632446-2581-4-git-send-email-tj@kernel.org>
 <CAKTCnz=DdG6QD0yPJ1poRZk0NYrYHdkmabvCXY-AR2qC1GSzYA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKTCnz=DdG6QD0yPJ1poRZk0NYrYHdkmabvCXY-AR2qC1GSzYA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Balbir.

On Tue, Aug 06, 2013 at 08:56:34AM +0530, Balbir Singh wrote:
> [off-topic] Has the unified hierarchy been agreed upon? I did not
> follow that thread

I consider it agreed upon enough.  There of course are objections but
I feel fairly comfortable with the amount of existing consensus and
considering the current state of cgroup in general, especially the API
leaks, I don't think we have many other choices.  The devil is always
in the details but unless we meet a major technical barrier, I'm
pretty sure it's happening.

> > events at fixed points, or if that's too restrictive, configureable
> > cadence or single set of configureable points should be enough.
> 
> Nit-pick: typo on the spelling of configurable

Will update.

> Tejun, I think the framework was designed to be flexible. Do you see
> cgroup subsystems never using this?

I can't be a hundred percent sure that we won't need events which are
configureable per-listener but it's highly unlikely given that we're
moving onto single agent model and the nature of event delivery -
spurious events are unlikely to be noticeable unless the frequency is
very high.  In general, as anything, aiming for extremes isn't a
healthy design practice.  Maximum flexibility sounds good in isolation
but nothing is free and it entails unneeded complexity both in
implementation and usage.  Note that even for memcg, both oom and
vmpressure don't benefit in any way from all the added complexity at
all.  The only other place that I can see event being useful at the
moment is freezer state change notification and that also would only
require unconditional file modified notification.

> > +static int cgroup_write_event_control(struct cgroup_subsys_state *css,
> > +                                     struct cftype *cft, const char *buffer)
> > +{
> > +       struct cgroup *cgrp = css->cgroup;
> > +       struct cgroup_event *event;
> > +       struct cgroup *cgrp_cfile;
> > +       unsigned int efd, cfd;
> > +       struct file *efile;
> > +       struct file *cfile;
> > +       char *endp;
> > +       int ret;
> > +
> 
> Can we assert that buffer is NOT NULL here?

The patch moves the code as-is as things become difficult to review
otherwise.  After the patchset, it belongs to memcg, please feel free
to modify as memcg people see fit.

Thanks.

-- 
tejun
