Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542AbaIOO20 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 10:28:26 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39802 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752709AbaIOO2Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 10:28:24 -0400
Date: Mon, 15 Sep 2014 16:28:21 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Tejun Heo <tj@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Patch v4 1/2] freezer: check OOM kill while being frozen
Message-ID: <20140915142821.GF19976@dhcp22.suse.cz>
References: <1409869842-10807-1-git-send-email-xiyou.wangcong@gmail.com>
 <20140909160625.GC4851@dhcp22.suse.cz>
 <20140909164658.GB11748@mtj.dyndns.org>
 <2008100.1EF7gjK5Z6@vostro.rjw.lan>
 <20140910132417.GF25219@dhcp22.suse.cz>
 <20140912234846.GA28183@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140912234846.GA28183@mtj.dyndns.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 13-09-14 08:48:46, Tejun Heo wrote:
> Hello, Michal.
> 
> On Wed, Sep 10, 2014 at 03:24:17PM +0200, Michal Hocko wrote:
> > What do you think about this way to help distinguish kernel threads and
> > user processes and keep the future maintenance of freezer saner?
> 
> I'm not sure either way.  Please note that we have quite a few
> wrappers around try_to_freeze() - freezable_schedule*() and
> wait_event_freezable*() - and several places where a userland can be
> frozen.  

I wasn't aware of those until I discovered freezer_count and company. I
didn't get to study why we need so many freezing point in the kernel yet
and whether they are safe at all. 

> Are we gonna introduce an alternate versions for all of them?

Are they intended for kernel threads in the first place? The primary
objective seems to be to not wake up user tasks just to put them into
the fridge when you know they are in a "deep" sleep currently. Kernel
threads know they might freeze themselves when returning from schedule,
no?

freezable_schedule{_timeout} seem to be used only by user tasks AFAICS.
freezable_schedule_unsafe seems to be more complicated due to nfs and
cifs but both of them are checking for fatal signal pending and return
ERESTARTSYS which looks like userspace stuff. So maybe we do not need
any alternate version for kernel threads.

I haven't check the workqueue_freezable API.

> What do we actually gain?

I thought we could easily document and add some rules to where
try_to_freeze can be called from for userspace tasks. Kernel threads
know when they are safe to get frozen but we should be more careful
about user tasks. Whether that can be enforced by an API is a question.
I do admit this much more complicated than I originally anticipated.

try_to_freeze should be a nice barrier where you know that waking into
a new world is safe for the caller (there is no state crossing the
freezing point). Whether a separate API makes this happen is an open
question. I would hope for much higher bar for adding new freezing
points for users tasks as those are more tricky to check.
-- 
Michal Hocko
SUSE Labs
