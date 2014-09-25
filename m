Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753745AbaIYC6G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 22:58:06 -0400
Received: from mail-qc0-f171.google.com ([209.85.216.171]:51397 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753238AbaIYC6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 22:58:03 -0400
Date: Wed, 24 Sep 2014 22:57:58 -0400
From: Tejun Heo <tj@kernel.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
        Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch] mm: memcontrol: do not iterate uninitialized memcgs
Message-ID: <20140925025758.GA6903@mtj.dyndns.org>
References: <1411612278-4707-1-git-send-email-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411612278-4707-1-git-send-email-hannes@cmpxchg.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Sep 24, 2014 at 10:31:18PM -0400, Johannes Weiner wrote:
..
> not meet the ordering requirements for memcg, and so we still may see
> partially initialized memcgs from the iterators.

It's mainly the other way around - a fully initialized css may not
show up in an iteration, but given that there's no memory ordering or
synchronization around the flag, anything can happen.

...
> +		if (next_css == &root->css ||
> +		    css_tryget_online(next_css)) {
> +			struct mem_cgroup *memcg;
> +
> +			memcg = mem_cgroup_from_css(next_css);
> +			if (memcg->initialized) {
> +				/*
> +				 * Make sure the caller's accesses to
> +				 * the memcg members are issued after
> +				 * we see this flag set.

I usually prefer if the comment points to the exact location that the
matching memory barriers live.  Sometimes it's difficult to locate the
partner barrier even w/ the functional explanation.

> +				 */
> +				smp_rmb();
> +				return memcg;

In an unlikely event this rmb becomes an issue, a self-pointing
pointer which is set/read using smp_store_release() and
smp_load_acquire() respectively can do with plain barrier() on the
reader side on archs which don't need data dependency barrier
(basically everything except alpha).  Not sure whether that'd be more
or less readable than this tho.

Thanks.

-- 
tejun
