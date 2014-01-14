Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752348AbaANG42 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 01:56:28 -0500
Received: from relay.parallels.com ([195.214.232.42]:53169 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751709AbaANG41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 01:56:27 -0500
Message-ID: <52D4DF97.1010409@parallels.com>
Date: Tue, 14 Jan 2014 10:56:23 +0400
From: Vladimir Davydov <vdavydov@parallels.com>
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <devel@openvz.org>,
        Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@redhat.com>,
        Dave Chinner <dchinner@redhat.com>, Glauber Costa <glommer@gmail.com>
Subject: Re: [PATCH 3/5] mm: vmscan: respect NUMA policy mask when shrinking
 slab on direct reclaim
References: <7d37542211678a637dc6b4d995fd6f1e89100538.1389443272.git.vdavydov@parallels.com> <a39e4c57c5a8db4d6e5bb8cd070ac807c8c6fce8.1389443272.git.vdavydov@parallels.com> <20140113151132.d07cbc938baf5af70f929120@linux-foundation.org>
In-Reply-To: <20140113151132.d07cbc938baf5af70f929120@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.16.96]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/2014 03:11 AM, Andrew Morton wrote:
> On Sat, 11 Jan 2014 16:36:33 +0400 Vladimir Davydov <vdavydov@parallels.com> wrote:
>
>> When direct reclaim is executed by a process bound to a set of NUMA
>> nodes, we should scan only those nodes when possible, but currently we
>> will scan kmem from all online nodes even if the kmem shrinker is NUMA
>> aware. That said, binding a process to a particular NUMA node won't
>> prevent it from shrinking inode/dentry caches from other nodes, which is
>> not good. Fix this.
> Seems right.  I worry that reducing the amount of shrinking which
> node-bound processes perform might affect workloads in unexpected ways.

Theoretically, it might, especially for NUMA unaware shrinkers. But
that's how it works for cpusets right now - we do not count pages from
nodes that are not allowed for the current process. Besides, when
counting lru pages for kswapd_shrink_zones(), we also consider only the
node this kswapd runs on so that NUMA unaware shrinkers will be scanned
more aggressively on NUMA enabled setups than NUMA aware ones. So, in
fact, this patch makes policy masks handling consistent with the rest of
the vmscan code.

> I think I'll save this one for 3.15-rc1, OK?

OK, thanks.
