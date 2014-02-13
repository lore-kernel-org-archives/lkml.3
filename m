Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752697AbaBMA27 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 19:28:59 -0500
Received: from mail-qa0-f45.google.com ([209.85.216.45]:63856 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381AbaBMA25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 19:28:57 -0500
Date: Wed, 12 Feb 2014 19:28:53 -0500
From: Tejun Heo <tj@kernel.org>
To: Hugh Dickins <hughd@google.com>
Cc: Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        Filipe Brandenburger <filbranden@google.com>,
        Li Zefan <lizefan@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Thelen <gthelen@google.com>,
        Michel Lespinasse <walken@google.com>,
        Markus Blank-Burian <burian@muenster.de>,
        Shawn Bohrer <shawn.bohrer@gmail.com>, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 2/2] cgroup: bring back kill_cnt to order css destruction
Message-ID: <20140213002853.GC2916@htj.dyndns.org>
References: <alpine.LSU.2.11.1402061541560.31342@eggly.anvils>
 <20140207164321.GE6963@cmpxchg.org>
 <alpine.LSU.2.11.1402121417230.5029@eggly.anvils>
 <alpine.LSU.2.11.1402121504150.5029@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.11.1402121504150.5029@eggly.anvils>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Hugh.

On Wed, Feb 12, 2014 at 03:06:26PM -0800, Hugh Dickins wrote:
> Sometimes the cleanup after memcg hierarchy testing gets stuck in
> mem_cgroup_reparent_charges(), unable to bring non-kmem usage down to 0.
> 
> There may turn out to be several causes, but a major cause is this: the
> workitem to offline parent can get run before workitem to offline child;
> parent's mem_cgroup_reparent_charges() circles around waiting for the
> child's pages to be reparented to its lrus, but it's holding cgroup_mutex
> which prevents the child from reaching its mem_cgroup_reparent_charges().
> 
> Further testing showed that an ordered workqueue for cgroup_destroy_wq
> is not always good enough: percpu_ref_kill_and_confirm's call_rcu_sched
> stage on the way can mess up the order before reaching the workqueue.
> 
> Instead bring back v3.11's css kill_cnt, repurposing it to make sure
> that offline_css() is not called for parent before it has been called
> for all children.
> 
> Fixes: e5fca243abae ("cgroup: use a dedicated workqueue for cgroup destruction")
> Signed-off-by: Hugh Dickins <hughd@google.com>
> Reviewed-by: Filipe Brandenburger <filbranden@google.com>
> Cc: stable@vger.kernel.org # v3.10+ (but will need extra care)
> ---
> This is an alternative to Filipe's 1/2: there's no need for both,
> but each has its merits.  I prefer Filipe's, which is much easier to
> understand: this one made more sense in v3.11, when it was just a matter
> of extending the use of css_kill_cnt; but might be preferred if offlining
> children before parent is thought to be a good idea generally.

Not that your implementation is bad or anything but the patch itself
somehow makes me cringe a bit.  It's probably just because it has to
add to the already overly complicated offline path.  Guaranteeing
strict offline ordering might be a good idea but at least for the
immediate bug fix, I agree that the memcg specific fix seems better
suited.  Let's apply that one and reconsider this one if it turns out
we do need strict offline reordering.

Thanks a lot!

-- 
tejun
