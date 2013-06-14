Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752865Ab3FNNUa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 09:20:30 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46035 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752660Ab3FNNU2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 09:20:28 -0400
Date: Fri, 14 Jun 2013 15:20:26 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Tejun Heo <tj@kernel.org>
Cc: lizefan@huawei.com, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, koverstreet@google.com,
        linux-kernel@vger.kernel.org, cl@linux-foundation.org,
        Mike Snitzer <snitzer@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
        "Alasdair G. Kergon" <agk@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Glauber Costa <glommer@gmail.com>
Subject: Re: [PATCH 11/11] cgroup: use percpu refcnt for cgroup_subsys_states
Message-ID: <20130614132026.GD10084@dhcp22.suse.cz>
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

On Wed 12-06-13 21:04:58, Tejun Heo wrote:
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
> percpu_ref. 

I have no objections to change css reference counting scheme if the
guarantees we used to have are still valid. I am just missing some
comparisons. Do you have any numbers that would show benefits clearly?

You are mentioning that especially controllers that are strongly per-cpu
oriented will see the biggest improvements. What about others?
A single atomic_add resp. atomic_dec_return is much less heavy than the
new ref counting. Is it possible that those could regress? Or the
differences would be only within the noise?

I do realize that it is not possible to test all controllers but I
would be interested to see at least that those for which it really
matters get a nice boost. Memcg uses css with caution although there are
places which are in really hot paths (e.g. charging) so any improvement
would be really welcome.

Sorry, if this information has been posted along with the series. I was
CCed only on this one and didn't get to look at the rest yet (apart from
"percpu: implement generic percpu refcounting" in your
review-css-percpu-ref branch).
[...]
-- 
Michal Hocko
SUSE Labs
