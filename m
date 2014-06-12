Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933056AbaFLNWP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 09:22:15 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53604 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932770AbaFLNWK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 09:22:10 -0400
Date: Thu, 12 Jun 2014 15:22:07 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Greg Thelen <gthelen@google.com>, Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Michel Lespinasse <walken@google.com>, Tejun Heo <tj@kernel.org>,
        Roman Gushchin <klamm@yandex-team.ru>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] memcg: Allow guarantee reclaim
Message-ID: <20140612132207.GA32720@dhcp22.suse.cz>
References: <20140611075729.GA4520@dhcp22.suse.cz>
 <1402473624-13827-1-git-send-email-mhocko@suse.cz>
 <1402473624-13827-2-git-send-email-mhocko@suse.cz>
 <20140611153631.GH2878@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140611153631.GH2878@cmpxchg.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 11-06-14 11:36:31, Johannes Weiner wrote:
[...]
> This code is truly dreadful.
> 
> Don't call it guarantee when it doesn't guarantee anything.  I thought
> we agreed that min, low, high, max, is reasonable nomenclature, please
> use it consistently.

I can certainly change the internal naming. I will use your wmark naming
suggestion.
 
> With my proposed cleanups and scalability fixes in the other mail, the
> vmscan.c changes to support the min watermark would be something like
> the following.

The semantic is, however, much different as pointed out in the other email.
The following on top of you cleanup will lead to the same deadlock
described in 1st patch (mm, memcg: allow OOM if no memcg is eligible
during direct reclaim).

Anyway, the situation now is pretty chaotic. I plan to gather all the
patchse posted so far and repost for the future discussion. I just need
to finish some internal tasks and will post it soon.

> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 687076b7a1a6..cee19b6d04dc 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -2259,7 +2259,7 @@ static void shrink_zone(struct zone *zone, struct scan_control *sc)
>  				 */
>  				if (priority < DEF_PRIORITY - 2)
>  					break;
> -
> +			case MEMCG_WMARK_MIN:
>  				/* XXX: skip the whole subtree */
>  				memcg = mem_cgroup_iter(root, memcg, &reclaim);
>  				continue;
> 

-- 
Michal Hocko
SUSE Labs
