Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932323AbbAOWtY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 17:49:24 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59774 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932258AbbAOWtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 17:49:22 -0500
Date: Thu, 15 Jan 2015 14:49:20 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>,
        Vladimir Davydov <vdavydov@parallels.com>,
        Rik van Riel <riel@redhat.com>, Michal Hocko <mhocko@suse.cz>,
        Mel Gorman <mgorman@suse.de>, Vlastimil Babka <vbabka@suse.cz>,
        Suleiman Souhlal <suleiman@google.com>, linux-mm@kvack.org
Subject: Re: [PATCH] mm/vmscan: fix highidx argument type
Message-Id: <20150115144920.33c446af388ed74c11dc573e@linux-foundation.org>
In-Reply-To: <1421360175-18899-1-git-send-email-mst@redhat.com>
References: <1421360175-18899-1-git-send-email-mst@redhat.com>
X-Mailer: Sylpheed 3.4.1 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Jan 2015 00:18:12 +0200 "Michael S. Tsirkin" <mst@redhat.com> wrote:

> for_each_zone_zonelist_nodemask wants an enum zone_type
> argument, but is passed gfp_t:
> 
> mm/vmscan.c:2658:9:    expected int enum zone_type [signed] highest_zoneidx
> mm/vmscan.c:2658:9:    got restricted gfp_t [usertype] gfp_mask
> mm/vmscan.c:2658:9: warning: incorrect type in argument 2 (different base types)
> mm/vmscan.c:2658:9:    expected int enum zone_type [signed] highest_zoneidx
> mm/vmscan.c:2658:9:    got restricted gfp_t [usertype] gfp_mask

Which tool emitted these warnings?

> convert argument to the correct type.
> 
> ...
>
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -2656,7 +2656,7 @@ static bool throttle_direct_reclaim(gfp_t gfp_mask, struct zonelist *zonelist,
>  	 * should make reasonable progress.
>  	 */
>  	for_each_zone_zonelist_nodemask(zone, z, zonelist,
> -					gfp_mask, nodemask) {
> +					gfp_zone(gfp_mask), nodemask) {
>  		if (zone_idx(zone) > ZONE_NORMAL)
>  			continue;

hm, I wonder what the runtime effects are.

The throttle_direct_reclaim() comment isn't really accurate, is it? 
"Throttle direct reclaimers if backing storage is backed by the
network".  The code is applicable to all types of backing, but was
added to address problems which are mainly observed with network
backing?
