Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752525AbaIPF4Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 01:56:24 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:37687 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813AbaIPF4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 01:56:23 -0400
Date: Tue, 16 Sep 2014 14:56:10 +0900
From: Tejun Heo <tj@kernel.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Patch v4 1/2] freezer: check OOM kill while being frozen
Message-ID: <20140916055610.GB805@mtj.dyndns.org>
References: <1409869842-10807-1-git-send-email-xiyou.wangcong@gmail.com>
 <20140909160625.GC4851@dhcp22.suse.cz>
 <20140909164658.GB11748@mtj.dyndns.org>
 <2008100.1EF7gjK5Z6@vostro.rjw.lan>
 <20140910132417.GF25219@dhcp22.suse.cz>
 <20140912234846.GA28183@mtj.dyndns.org>
 <20140915142821.GF19976@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140915142821.GF19976@dhcp22.suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Michal.

On Mon, Sep 15, 2014 at 04:28:21PM +0200, Michal Hocko wrote:
> > Are we gonna introduce an alternate versions for all of them?
> 
> Are they intended for kernel threads in the first place? The primary

There's no restriction in using them and I'm pretty sure some of them
are used by kernel threads.

> objective seems to be to not wake up user tasks just to put them into
> the fridge when you know they are in a "deep" sleep currently. Kernel

That's one of the uses but not the only one.

> threads know they might freeze themselves when returning from schedule,
> no?

I'm not following.  Can you elaborate?

> freezable_schedule{_timeout} seem to be used only by user tasks AFAICS.
> freezable_schedule_unsafe seems to be more complicated due to nfs and
> cifs but both of them are checking for fatal signal pending and return
> ERESTARTSYS which looks like userspace stuff. So maybe we do not need
> any alternate version for kernel threads.
> 
> I haven't check the workqueue_freezable API.

That one is actually easy and should be fine.

> > What do we actually gain?
> 
> I thought we could easily document and add some rules to where
> try_to_freeze can be called from for userspace tasks. Kernel threads
> know when they are safe to get frozen but we should be more careful
> about user tasks. Whether that can be enforced by an API is a question.
> I do admit this much more complicated than I originally anticipated.
> 
> try_to_freeze should be a nice barrier where you know that waking into
> a new world is safe for the caller (there is no state crossing the

It isn't and I'm not sure it can ever be used as "world" barrier.  It
just doesn't mean that.

> freezing point). Whether a separate API makes this happen is an open
> question. I would hope for much higher bar for adding new freezing
> points for users tasks as those are more tricky to check.

Heh, as far as I can recall, freezer usage has always been a rather
large mess.  In the long term, I think the right thing to do is
merging userland freezing into job control stop so that it doesn't get
the special SIGKILL immunity.  We shouldn't have exposed this
unkillable state the beginning.  :(

Thanks.

-- 
tejun
