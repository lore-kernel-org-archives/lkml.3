Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754486AbaIKOp1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 10:45:27 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:60037 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118AbaIKOpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 10:45:25 -0400
Date: Thu, 11 Sep 2014 16:45:09 +0200
From: Michal Hocko <mhocko@suse.cz>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Tejun Heo <tj@kernel.org>, Cong Wang <xiyou.wangcong@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Patch v4 1/2] freezer: check OOM kill while being frozen
Message-ID: <20140911144509.GM22042@dhcp22.suse.cz>
References: <1409869842-10807-1-git-send-email-xiyou.wangcong@gmail.com>
 <1973496.9q6IzlQu6V@vostro.rjw.lan>
 <20140911142822.GL22042@dhcp22.suse.cz>
 <23520581.7q253rZGaa@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <23520581.7q253rZGaa@vostro.rjw.lan>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 11-09-14 16:52:50, Rafael J. Wysocki wrote:
> On Thursday, September 11, 2014 04:28:22 PM Michal Hocko wrote:
> > On Thu 11-09-14 16:32:50, Rafael J. Wysocki wrote:
> > > On Thursday, September 11, 2014 04:10:51 PM Michal Hocko wrote:
> > > > On Thu 11-09-14 16:26:56, Rafael J. Wysocki wrote:
> > > > > On Thursday, September 11, 2014 04:04:48 PM Michal Hocko wrote:
> > > > > > On Thu 11-09-14 16:17:56, Rafael J. Wysocki wrote:
> > > > > > [...]
> > > > > > > And I'm still wondering if the OOM killer may be made avoid killing frozen
> > > > > > > tasks.
> > > > > > 
> > > > > > This is really tricky. OOM killer aims at the biggest memory hog. We
> > > > > > shouldn't ignore it just because it hides into the fridge... So even
> > > > > > if we "fix" oom killer to ignore frozen tasks (which is inherently
> > > > > > racy btw.) then we have a potential problem of freezer abuse (e.g. in
> > > > > > container environments). So I strongly believe that the OOM killer has
> > > > > > to be able to kill a frozen tasks.
> > > > > 
> > > > > OK
> > > > > 
> > > > > Is the OOM killer the only place where TIF_MEMDIE is set?
> > > > 
> > > > Yes. To be precise, lowmemorykiller (staging android thingy), global OOM
> > > > killer and memcg OOM killer. Any other users would be an abuse.
> > > 
> > > OK
> > > 
> > > So can we ensure that those things don't trigger during system suspend (or
> > > equivalent) and then simply use the TIF_MEMDIE check in __refrigerator()?
> > 
> > That would require that no memory allocation triggers OOM killer during
> > suspend. I don't think this will work out. OOM killer is the last resort
> > action. We cannot simply give access to memory reserves just because the
> > current context is in the middle of suspend.
> 
> But we can fail the allocation, can't we?

We already do that by oom_killer_disable after all tasks are frozen in
freeze_processes. This is before all other device specific things are
done so I guess we cannot start killing after any device is suspended,
right? This should be sufficient.

> > What is the worst thing that might happen when a task is killed in the
> > middle of suspend? I thought that suspend would fail after several
> > attempts to suspend all existing tasks.
> 
> The problem is what to do when we need to kill a frozen task.
> 
> In that case we need to thaw it and then it will die eventually.  Unfortunately,
> it generally can do something undesirable before dying.  That may be accessing
> a suspended device, for example.

OK, I have misunderstood you obviously. I thought we were discussing OOM
while we are in the middle of freezing tasks. After they are frozen
there is no OOM killer as per above.
-- 
Michal Hocko
SUSE Labs
