Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758439Ab3FMXQX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 19:16:23 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:55932 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994Ab3FMXQV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 19:16:21 -0400
Date: Thu, 13 Jun 2013 16:16:34 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Tejun Heo <tj@kernel.org>
Cc: lizefan@huawei.com, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        cl@linux-foundation.org, Michal Hocko <mhocko@suse.cz>,
        Mike Snitzer <snitzer@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
        "Alasdair G. Kergon" <agk@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Glauber Costa <glommer@gmail.com>
Subject: Re: [PATCH 11/11] cgroup: use percpu refcnt for cgroup_subsys_states
Message-ID: <20130613231634.GD28664@moria.home.lan>
References: <1371096298-24402-1-git-send-email-tj@kernel.org>
 <1371096298-24402-12-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371096298-24402-12-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 12, 2013 at 09:04:58PM -0700, Tejun Heo wrote:
> A css (cgroup_subsys_state) is how each cgroup is represented to a
> controller.  As such, it can be used in hot paths across the various
> subsystems different controllers are associated with.
> 
> One of the common operations is reference counting, which up until now
> has been implemented using a global atomic counter and can have
> significant adverse impact on scalability.  For example, css refcnt
> can be gotten and put multiple times by blkcg for each IO request.
> For highops configurations which try to do as much per-cpu as
> possible, the global frequent refcnting can be very expensive.
> 
> In general, given the various and hugely diverse paths css's end up
> being used from, we need to make it cheap and highly scalable.  In its
> usage, css refcnting isn't very different from module refcnting.
> 
> This patch converts css refcnting to use the recently added
> percpu_ref.  css_get/tryget/put() directly maps to the matching
> percpu_ref operations and the deactivation logic is no longer
> necessary as percpu_ref already has refcnt killing.
> 
> The only complication is that as the refcnt is per-cpu,
> percpu_ref_kill() in itself doesn't ensure that further tryget
> operations will fail, which we need to guarantee before invoking
> ->css_offline()'s.  This is resolved collecting kill confirmation
> using percpu_ref_kill_and_confirm() and initiating the offline phase
> of destruction after all css refcnt's are confirmed to be seen as
> killed on all CPUs.  The previous patches already splitted destruction
> into two phases, so percpu_ref_kill_and_confirm() can be hooked up
> easily.
> 
> This patch removes css_refcnt() which is used for rcu dereference
> sanity check in css_id().  While we can add a percpu refcnt API to ask
> the same question, css_id() itself is scheduled to be removed fairly
> soon, so let's not bother with it.  Just drop the sanity check and use
> rcu_dereference_raw() instead.
> 
> v2: - init_cgroup_css() was calling percpu_ref_init() without checking
>       the return value.  This causes two problems - the obvious lack
>       of error handling and percpu_ref_init() being called from
>       cgroup_init_subsys() before the allocators are up, which
>       triggers warnings but doesn't cause actual problems as the
>       refcnt isn't used for roots anyway.  Fix both by moving
>       percpu_ref_init() to cgroup_create().
> 
>     - The base references were put too early by
>       percpu_ref_kill_and_confirm() and cgroup_offline_fn() put the
>       refs one extra time.  This wasn't noticeable because css's go
>       through another RCU grace period before being freed.  Update
>       cgroup_destroy_locked() to grab an extra reference before
>       killing the refcnts.  This problem was noticed by Kent.

Reviewed-by: Kent Overstreet <koverstreet@google.com>
