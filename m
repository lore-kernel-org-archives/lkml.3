Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932390Ab3EOIdZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 04:33:25 -0400
Received: from mx2.parallels.com ([199.115.105.18]:51615 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756715Ab3EOIdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 04:33:21 -0400
Message-ID: <5193487C.3010607@parallels.com>
Date: Wed, 15 May 2013 12:34:04 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130402 Thunderbird/17.0.5
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: Andrew Morton <akpm@linux-foundation.org>, <linux-mm@kvack.org>,
        <cgroups@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Ying Han <yinghan@google.com>, Hugh Dickins <hughd@google.com>,
        Michel Lespinasse <walken@google.com>,
        Greg Thelen <gthelen@google.com>, Tejun Heo <tj@kernel.org>,
        Balbir Singh <bsingharora@gmail.com>
Subject: Re: [patch v3 -mm 1/3] memcg: integrate soft reclaim tighter with
 zone shrinking code
References: <1368431172-6844-1-git-send-email-mhocko@suse.cz> <1368431172-6844-2-git-send-email-mhocko@suse.cz>
In-Reply-To: <1368431172-6844-2-git-send-email-mhocko@suse.cz>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13/2013 11:46 AM, Michal Hocko wrote:
> Memcg soft reclaim has been traditionally triggered from the global
> reclaim paths before calling shrink_zone. mem_cgroup_soft_limit_reclaim
> then picked up a group which exceeds the soft limit the most and
> reclaimed it with 0 priority to reclaim at least SWAP_CLUSTER_MAX pages.
> 
> The infrastructure requires per-node-zone trees which hold over-limit
> groups and keep them up-to-date (via memcg_check_events) which is not
> cost free. Although this overhead hasn't turned out to be a bottle neck
> the implementation is suboptimal because mem_cgroup_update_tree has no
> idea which zones consumed memory over the limit so we could easily end
> up having a group on a node-zone tree having only few pages from that
> node-zone.
> 
> This patch doesn't try to fix node-zone trees management because it
> seems that integrating soft reclaim into zone shrinking sounds much
> easier and more appropriate for several reasons.
> First of all 0 priority reclaim was a crude hack which might lead to
> big stalls if the group's LRUs are big and hard to reclaim (e.g. a lot
> of dirty/writeback pages).
> Soft reclaim should be applicable also to the targeted reclaim which is
> awkward right now without additional hacks.
> Last but not least the whole infrastructure eats quite some code.
> 
> After this patch shrink_zone is done in 2 passes. First it tries to do the
> soft reclaim if appropriate (only for global reclaim for now to keep
> compatible with the original state) and fall back to ignoring soft limit
> if no group is eligible to soft reclaim or nothing has been scanned
> during the first pass. Only groups which are over their soft limit or
> any of their parents up the hierarchy is over the limit are considered
> eligible during the first pass.
> 
> Soft limit tree which is not necessary anymore will be removed in the
> follow up patch to make this patch smaller and easier to review.
> 
> Changes since v1
> - __shrink_zone doesn't return the number of shrunk groups as nr_scanned
>   test covers both no groups scanned and no pages from the required zone
>   as pointed by Johannes
> 
> Signed-off-by: Michal Hocko <mhocko@suse.cz>

Patch looks fine to me

Reviewed-by: Glauber Costa <glommer@openvz.org>


