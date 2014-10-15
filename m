Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751822AbaJOPDA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 11:03:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56088 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751429AbaJOPC7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 11:02:59 -0400
Date: Wed, 15 Oct 2014 17:02:56 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Vladimir Davydov <vdavydov@parallels.com>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/5] mm: memcontrol: convert reclaim iterator to simple
 css refcounting
Message-ID: <20141015150256.GF23547@dhcp22.suse.cz>
References: <1413303637-23862-1-git-send-email-hannes@cmpxchg.org>
 <1413303637-23862-2-git-send-email-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413303637-23862-2-git-send-email-hannes@cmpxchg.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 14-10-14 12:20:33, Johannes Weiner wrote:
> The memcg reclaim iterators use a complicated weak reference scheme to
> prevent pinning cgroups indefinitely in the absence of memory pressure.
> 
> However, during the ongoing cgroup core rework, css lifetime has been
> decoupled such that a pinned css no longer interferes with removal of
> the user-visible cgroup, and all this complexity is now unnecessary.
>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> ---
>  mm/memcontrol.c | 250 +++++++++++++++++---------------------------------------
>  1 file changed, 76 insertions(+), 174 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index b62972c80055..67dabe8b0aa6 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
[...]
> +		do {
> +			pos = ACCESS_ONCE(iter->position);
> +			/*
> +			 * A racing update may change the position and
> +			 * put the last reference, hence css_tryget(),
> +			 * or retry to see the updated position.
> +			 */
> +		} while (pos && !css_tryget(&pos->css));
> +	}
[...]
> +	if (reclaim) {
> +		if (cmpxchg(&iter->position, pos, memcg) == pos && memcg)
> +			css_get(&memcg->css);
> +
> +		if (pos)
> +			css_put(&pos->css);

This looks like a reference leak. css_put pairs with the above
css_tryget but no css_put pairs with css_get for the cached one. We
need:
---
>From 2810937ec6c16afc0bf924e761ff8305bd478a42 Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko@suse.cz>
Date: Wed, 15 Oct 2014 16:26:22 +0200
Subject: [PATCH] 
 mm-memcontrol-convert-reclaim-iterator-to-simple-css-refcounting-fix

Make sure that the cached reference is always released.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
---
 mm/memcontrol.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index bdcd0416a017..42842a47b4c1 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1160,9 +1160,17 @@ struct mem_cgroup *mem_cgroup_iter(struct mem_cgroup *root,
 	}
 
 	if (reclaim) {
-		if (cmpxchg(&iter->position, pos, memcg) == pos && memcg)
-			css_get(&memcg->css);
+		if (cmpxchg(&iter->position, pos, memcg) == pos) {
+			if (memcg)
+				css_get(&memcg->css);
+			if (pos)
+				css_put(&pos->css);
+		}
 
+		/*
+		 * pairs with css_tryget when dereferencing iter->position
+		 * above.
+		 */
 		if (pos)
 			css_put(&pos->css);
 
-- 
2.1.1

-- 
Michal Hocko
SUSE Labs
