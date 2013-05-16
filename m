Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754692Ab3EPWMK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 18:12:10 -0400
Received: from mail-qe0-f53.google.com ([209.85.128.53]:60281 "EHLO
	mail-qe0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752097Ab3EPWMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 18:12:08 -0400
Date: Thu, 16 May 2013 15:12:00 -0700
From: Tejun Heo <tj@kernel.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Ying Han <yinghan@google.com>, Hugh Dickins <hughd@google.com>,
        Glauber Costa <glommer@parallels.com>,
        Michel Lespinasse <walken@google.com>,
        Greg Thelen <gthelen@google.com>, Balbir Singh <bsingharora@gmail.com>
Subject: Re: [patch v3 -mm 1/3] memcg: integrate soft reclaim tighter with
 zone shrinking code
Message-ID: <20130516221200.GF7171@mtj.dyndns.org>
References: <1368431172-6844-1-git-send-email-mhocko@suse.cz>
 <1368431172-6844-2-git-send-email-mhocko@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368431172-6844-2-git-send-email-mhocko@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry about the delay.  Just getting back to memcg.

On Mon, May 13, 2013 at 09:46:10AM +0200, Michal Hocko wrote:
...
> during the first pass. Only groups which are over their soft limit or
> any of their parents up the hierarchy is over the limit are considered

ancestors?

> +static void shrink_zone(struct zone *zone, struct scan_control *sc)
> +{
> +	bool do_soft_reclaim = mem_cgroup_should_soft_reclaim(sc);
> +	unsigned long nr_scanned = sc->nr_scanned;
> +
> +	__shrink_zone(zone, sc, do_soft_reclaim);
> +
> +	/*
> +	 * No group is over the soft limit or those that are do not have
> +	 * pages in the zone we are reclaiming so we have to reclaim everybody
> +	 */
> +	if (do_soft_reclaim && (sc->nr_scanned == nr_scanned)) {
> +		__shrink_zone(zone, sc, false);
> +		return;
> +	}
> +}

Maybe the following is easier to follow?

	if (mem_cgroup_should_soft_reclaim(sc)) {
		__shrink_zone(zone, sc, true);
		if (sc->nr_scanned == nr_scanned)
			__shrink_zone(zone, sc, false);
	} else {
		__shrink_zone(zone, sc, false);
	}

But it's a minor point, please feel free to ignore.

  Reviewed-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
