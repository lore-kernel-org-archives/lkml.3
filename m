Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751969AbbAMIqN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 03:46:13 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:65327 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751093AbbAMIqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 03:46:11 -0500
Date: Tue, 13 Jan 2015 09:41:01 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>, "\\\"Rafael J. Wysocki\\\"" <rjw@rjwysocki.net>,
        David Rientjes <rientjes@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Oleg Nesterov <oleg@redhat.com>,
        Cong Wang <xiyou.wangcong@gmail.com>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>, linux-pm@vger.kernel.org
Subject: Re: [PATCH -v3 0/5] OOM vs PM freezer fixes
Message-ID: <20150113084101.GB25318@dhcp22.suse.cz>
References: <1420801555-22659-1-git-send-email-mhocko@suse.cz>
 <20150112155935.21b13bc41417ceedde9d640f@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150112155935.21b13bc41417ceedde9d640f@linux-foundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 12-01-15 15:59:35, Andrew Morton wrote:
> On Fri,  9 Jan 2015 12:05:50 +0100 Michal Hocko <mhocko@suse.cz> wrote:
> 
> > Hi,
> 
> I've been cheerily ignoring this discussion, sorry.  I trust everyone's
> all happy and ready to go with this?
> 
> > [what changed since the last patchset]
> >
> > ...
> >
> > [testing results]
> >
> > ...
> >
> > [overview of the 5 patches]
> >
> > ...
> > 
> 
> That's nice, but it doesn't really tell us what the patchset does.  The
> first paragraph of the [5/5] changelog provides hints, but doesn't
> explain why we even need to fix a race which is "quite small and really
> unlikely".

The primary reason for ruling out OOM killer from PM freezing is
described in the changelog of the original "fix" 5695be142e20 (OOM,
PM: OOM killed task shouldn't escape PM suspend) for which this is a
follow up:
"
    PM freezer relies on having all tasks frozen by the time devices are
    getting frozen so that no task will touch them while they are getting
    frozen. But OOM killer is allowed to kill an already frozen task in
    order to handle OOM situtation. In order to protect from late wake ups
    OOM killer is disabled after all tasks are frozen. This, however, still
    keeps a window open when a killed task didn't manage to die by the time
    freeze_processes finishes.
"

The original patch hasn't closed the race window completely because
that would require a more complex solution as it can be seen by this
patchset.
 
> So...  could we please have a few words describing the overall intent
> and effect of this patchset?

The primary motivation was to close the race condition between OOM
killer and PM freezer _completely_. As Tejun pointed out, even though
the race condition is unlikely the harder it would be to debug weird
bugs deep in the PM freezer when the debugging options are reduced
considerably.  I can only speculate what might happen when a task is
still runnable unexpectedly. I can imagine deadlocks or memory
corruptions but I am, by no means, an expert in this area.

On a plus side and as a side effect the oom enable/disable has a better
(full barrier) semantic without polluting hot paths.

Hope that clarifies the things a bit.
-- 
Michal Hocko
SUSE Labs
