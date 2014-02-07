Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753014AbaBGOEK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 09:04:10 -0500
Received: from mail-qa0-f50.google.com ([209.85.216.50]:54159 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752537AbaBGOEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 09:04:07 -0500
Date: Fri, 7 Feb 2014 09:04:02 -0500
From: Tejun Heo <tj@kernel.org>
To: Hugh Dickins <hughd@google.com>
Cc: Filipe Brandenburger <filbranden@google.com>,
        Li Zefan <lizefan@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        Greg Thelen <gthelen@google.com>,
        Michel Lespinasse <walken@google.com>,
        Markus Blank-Burian <burian@muenster.de>,
        Shawn Bohrer <shawn.bohrer@gmail.com>, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] cgroup: use an ordered workqueue for cgroup destruction
Message-ID: <20140207140402.GA3304@htj.dyndns.org>
References: <alpine.LSU.2.11.1402061541560.31342@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.11.1402061541560.31342@eggly.anvils>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Hugh.

On Thu, Feb 06, 2014 at 03:56:01PM -0800, Hugh Dickins wrote:
> Sometimes the cleanup after memcg hierarchy testing gets stuck in
> mem_cgroup_reparent_charges(), unable to bring non-kmem usage down to 0.
> 
> There may turn out to be several causes, but a major cause is this: the
> workitem to offline parent can get run before workitem to offline child;
> parent's mem_cgroup_reparent_charges() circles around waiting for the
> child's pages to be reparented to its lrus, but it's holding cgroup_mutex
> which prevents the child from reaching its mem_cgroup_reparent_charges().
> 
> Just use an ordered workqueue for cgroup_destroy_wq.

Hmmm... I'm not really comfortable with this.  This would seal shut
any possiblity of increasing concurrency in that path, which is okay
now but I find the combination of such long term commitment and the
non-obviousness (it's not apparent from looking at memcg code why it
wouldn't deadlock) very unappealing.  Besides, the only reason
offline() is currently called under cgroup_mutex is history.  We can
move it out of cgroup_mutex right now.

But even with offline being called outside cgroup_mutex, IIRC, the
described problem would still be able to deadlock as long as the tree
depth is deeper than max concurrency level of the destruction
workqueue.  Sure, we can give it large enough number but it's
generally nasty.

One thing I don't get is why memcg has such reverse dependency at all.
Why does the parent wait for its descendants to do something during
offline?  Shouldn't it be able to just bail and let whatever
descendant which is stil busy propagate things upwards?  That's a
usual pattern we use to tree shutdowns anyway.  Would that be nasty to
implement in memcg?

Thanks.

-- 
tejun
