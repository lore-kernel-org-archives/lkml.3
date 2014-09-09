Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757420AbaIIQGa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 12:06:30 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49956 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757086AbaIIQG1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 12:06:27 -0400
Date: Tue, 9 Sep 2014 18:06:25 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Tejun Heo <tj@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Patch v4 1/2] freezer: check OOM kill while being frozen
Message-ID: <20140909160625.GC4851@dhcp22.suse.cz>
References: <1409869842-10807-1-git-send-email-xiyou.wangcong@gmail.com>
 <3827451.ToKxd7Xb2J@vostro.rjw.lan>
 <20140908222253.GB3806@mtj.dyndns.org>
 <2588099.AI1YmNFQ25@vostro.rjw.lan>
 <20140908225012.GE3806@mtj.dyndns.org>
 <20140909151655.GB4851@dhcp22.suse.cz>
 <20140909152336.GB8890@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140909152336.GB8890@mtj.dyndns.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 10-09-14 00:23:36, Tejun Heo wrote:
> On Tue, Sep 09, 2014 at 05:16:55PM +0200, Michal Hocko wrote:
> > But OOM killer doesn't kill kernel threads as they do not own any
> > memory. So the check should be safe, no?
> 
> Even for userland tasks, try_to_freeze() can currently be anywhere in
> the kernel.  The frequently used ones are few but there are some odd

I always thought that user space tasks can be in the fridge only on the
way out from the kernel (get_signal_to_deliver). I have quickly greped
the code and the only place I can see seems to be run_guest but that
one bails out quickly when there are signals pending so it should be
safe in this context.
cifs is doing something suspicious (cifs_reconnect) but I didn't check
more closely all the contexts it is called from.

> ones out, and, again, there's nothing enforcing any structure on
> try_to_freeze() usage. 

Would it make sense to have try_to_freeze_user_task or similar and check
for kernel thread in try_to_freeze and complain loudly if called from
user task context? I mean does it even make sense to call try_to_freeze
in the middle of kernel operation for a user task?

> The other thing is that we may do quite a bit during exiting including
> allocating memory. 

yes, we can allocate memory and even page fault on the exit path. But
TIF_MEMDIE will make sure that the allocation will be successful if
there is some memory left.

> Are those safe for system PM?  Rafael, what exactly are the rules for
> PM?  What shouldn't change?
> 
> Thanks.
> 
> -- 
> tejun

-- 
Michal Hocko
SUSE Labs
