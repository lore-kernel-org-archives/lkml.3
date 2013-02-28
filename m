Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753430Ab3B1Oa7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 09:30:59 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33718 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751332Ab3B1Oaz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 09:30:55 -0500
Date: Thu, 28 Feb 2013 15:30:52 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Roman Gushchin <klamm@yandex-team.ru>
Cc: Johannes Weiner-Arquette <hannes@cmpxchg.org>,
        "bsingharora@gmail.com" <bsingharora@gmail.com>,
        "kamezawa.hiroyu@jp.fujitsu.com" <kamezawa.hiroyu@jp.fujitsu.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, "mel@csn.ul.ie" <mel@csn.ul.ie>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Ying Han <yinghan@google.com>
Subject: Re: [PATCH] memcg: implement low limits
Message-ID: <20130228143052.GE6573@dhcp22.suse.cz>
References: <8121361952156@webcorp1g.yandex-team.ru>
 <20130227094054.GC16719@dhcp22.suse.cz>
 <38951361977052@webcorp2g.yandex-team.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <38951361977052@webcorp2g.yandex-team.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 27-02-13 18:57:32, Roman Gushchin wrote:
[...]
> >>  + *
> >>  + */
> >>  +unsigned int mem_cgroup_low_limit_scale(struct lruvec *lruvec)
> >>  +{
> >>  + struct mem_cgroup_per_zone *mz;
> >>  + struct mem_cgroup *memcg;
> >>  + unsigned long long low_limit;
> >>  + unsigned long long usage;
> >>  + unsigned int i;
> >>  +
> >>  + mz = container_of(lruvec, struct mem_cgroup_per_zone, lruvec);
> >>  + memcg = mz->memcg;
> >>  + if (!memcg)
> >>  + return 0;
> >>  +
> >>  + low_limit = res_counter_read_u64(&memcg->res, RES_LOW_LIMIT);
> >>  + if (!low_limit)
> >>  + return 0;
> >>  +
> >>  + usage = res_counter_read_u64(&memcg->res, RES_USAGE);
> >>  +
> >>  + if (usage < low_limit)
> >>  + return DEF_PRIORITY - 2;
> >>  +
> >>  + for (i = 0; i < DEF_PRIORITY - 2; i++)
> >>  + if (usage - low_limit > (usage >> (i + 3)))
> >>  + break;
> >
> > why this doesn't depend in the current reclaim priority?
> 
> How do you want to use reclaim priority here?

But then you can get up to 2*DEF_PRIORITY-2 priority (in
get_scan_count) in the end and we are back to my original and more
fundamental objection that the low_limit depends on the group size
because small groups basically do not get scanned when under/close_to
limit while big groups do get scanned and reclaimed.

> I don't like an idea to start ignoring low limit on some priorities.

Well, but you are doing that already. If you are reclaiming for prio 0 then
you add up just DEF_PRIORITY-2 which means you reclaim for all groups with
more than 1024 pages on the LRUs.
[...]
-- 
Michal Hocko
SUSE Labs
