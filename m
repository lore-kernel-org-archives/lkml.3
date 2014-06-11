Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932678AbaFKPUr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 11:20:47 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:34621 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932646AbaFKPUo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 11:20:44 -0400
Date: Wed, 11 Jun 2014 11:20:30 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: Greg Thelen <gthelen@google.com>, Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Michel Lespinasse <walken@google.com>, Tejun Heo <tj@kernel.org>,
        Roman Gushchin <klamm@yandex-team.ru>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] mm, memcg: allow OOM if no memcg is eligible during
 direct reclaim
Message-ID: <20140611152030.GB22516@cmpxchg.org>
References: <20140611075729.GA4520@dhcp22.suse.cz>
 <1402473624-13827-1-git-send-email-mhocko@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402473624-13827-1-git-send-email-mhocko@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11, 2014 at 10:00:23AM +0200, Michal Hocko wrote:
> If there is no memcg eligible for reclaim because all groups under the
> reclaimed hierarchy are within their guarantee then the global direct
> reclaim would end up in the endless loop because zones in the zonelists
> are not considered unreclaimable (as per all_unreclaimable) and so the
> OOM killer would never fire and direct reclaim would be triggered
> without no chance to reclaim anything.
> 
> This is not possible yet because reclaim falls back to ignore low_limit
> when nobody is eligible for reclaim. Following patch will allow to set
> the fallback mode to hard guarantee, though, so this is a preparatory
> patch.
> 
> Memcg reclaim doesn't suffer from this because the OOM killer is
> triggered after few unsuccessful attempts of the reclaim.
> 
> Fix this by checking the number of scanned pages which is obviously 0 if
> nobody is eligible and also check that the whole tree hierarchy is not
> eligible and tell OOM it can go ahead.
> 
> Signed-off-by: Michal Hocko <mhocko@suse.cz>
> ---
>  mm/vmscan.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 8041b0667673..99137aecd95f 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -2570,6 +2570,13 @@ out:
>  	if (aborted_reclaim)
>  		return 1;
>  
> +	/*
> +	 * If the target memcg is not eligible for reclaim then we have no option
> +	 * but OOM
> +	 */
> +	if (!sc->nr_scanned && mem_cgroup_all_within_guarantee(sc->target_mem_cgroup))
> +		return 0;

We can't just sprinkle `for each memcg in hierarchy` loops like this,
they can get really expensive.

It's pretty stupid to not have a return value on shrink_zone(), which
could easily indicate whether a zone was reclaimable, and instead have
another iteration over the same zonelist and the same memcg hierarchy
afterwards to figure out if shrink_zone() was successful or not.
