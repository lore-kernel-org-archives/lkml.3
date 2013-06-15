Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074Ab3FOGcA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 02:32:00 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:58307 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752326Ab3FOGb6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 02:31:58 -0400
Date: Fri, 14 Jun 2013 23:31:55 -0700
From: Tejun Heo <tj@kernel.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: lizefan@huawei.com, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, koverstreet@google.com,
        linux-kernel@vger.kernel.org, cl@linux-foundation.org,
        Mike Snitzer <snitzer@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
        "Alasdair G. Kergon" <agk@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Glauber Costa <glommer@gmail.com>
Subject: Re: [PATCH 11/11] cgroup: use percpu refcnt for cgroup_subsys_states
Message-ID: <20130615063155.GC7017@htj.dyndns.org>
References: <1371096298-24402-1-git-send-email-tj@kernel.org>
 <1371096298-24402-12-git-send-email-tj@kernel.org>
 <20130614132026.GD10084@dhcp22.suse.cz>
 <20130614223125.GD6593@mtj.dyndns.org>
 <20130615053522.GA7017@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130615053522.GA7017@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 14, 2013 at 10:35:22PM -0700, Tejun Heo wrote:
> On Fri, Jun 14, 2013 at 03:31:25PM -0700, Tejun Heo wrote:
> > I'll play with it a bit more on an actual machine and post more
> > results.  Test program attached.
> 
> So, here are the results from the same test on a dual-socket 2-way
> NUMA opteron 8 core machine.
> 
> Running on one CPU.
> 
>   copy size	atomic		percpu		diff in pct
>   0		535964443	616756827	+15.07%
>   32		399988186	378678713	 -5.33%
>   64		389067476	355073979	 -8.74%
>   128		342192631	315615300	 -7.77%
>   256		281208005	260598931	 -7.33%
>   512		188070912	193225269	 +2.74%
> 
> Running on all eight cores.
> 
>   copy size	atomic		percpu		diff in pct
>   0		121324328	4889425511	+3,930.05%
>   32		 96170193	2999613380	+3,019.07%
>   64		 98139061	2813894184	+2,767.25%
>   128		112610025	2503229487	+2,122.92%
>   256		 96828114	2069865752	+2,037.67%
>   512		 95858297	1537726109	+1,504.17%
> 
> Ration of all cores / single core.
> 
>   copy size	atomic		percpu
>   0		0.23		7.93
>   32		0.24		7.92
>   64		0.25		7.92
>   128		0.33		7.93
>   256		0.34		7.94
>   512		0.51		7.96

I was testing with CONFIG_PREEMPT, which makes rcu_read_[un]lock()s
quite a bit more expensive.  The following is the same test results
with CONFIG_PREEMPT_VOLUNTARY which would the most preemptive server
distros would get anyway.

One CPU.

  copy size	atomic		percpu		diff in pct
  0		534583387	1521561724	+184.63%
  32		399098138	 615962137	+ 54.34%
  64		388128431	 555599274	+ 43.15%
  128		341336474	 464502792	+ 36.08%
  256		280471681	 354186740	+ 26.28%
  512		203784802	 240067596	+ 17.80%

All eight CPUs.

  copy size	atomic		percpu		diff in pct
  0		117213982	12488998111	+10,554.87%
  32		103545751	4940695158	+ 4,671.51%
  64		 98135094	4456370409	+ 4,441.06%
  128		117729659	3725434154	+ 3,064.40%
  256		 95916768	2840992396	+ 2,861.94%
  512		 95795993	1926044518	+ 1,910.57%

Ration of all cores / single core.

  copy size	atomic		percpu
  0		0.22		8.21
  32		0.26		8.02
  64		0.25		8.02
  128		0.34		8.02
  256		0.34		8.02
  512		0.47		8.02	

So, it's faster even with only one CPU.

Thanks.

-- 
tejun
