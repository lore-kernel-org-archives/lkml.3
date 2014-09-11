Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751649AbaIKCF6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 22:05:58 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:52383 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250AbaIKCF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 22:05:57 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v2.2.3
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20140219-2
Message-ID: <54110339.6000702@jp.fujitsu.com>
Date: Thu, 11 Sep 2014 11:04:41 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Vladimir Davydov <vdavydov@parallels.com>
CC: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Greg Thelen <gthelen@google.com>, Hugh Dickins <hughd@google.com>,
        Motohiro Kosaki <Motohiro.Kosaki@us.fujitsu.com>,
        Glauber Costa <glommer@gmail.com>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelianov <xemul@parallels.com>,
        Konstantin Khorenko <khorenko@parallels.com>,
        LKML-MM <linux-mm@kvack.org>, LKML-cgroups <cgroups@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] memory cgroup: my thoughts on memsw
References: <20140904143055.GA20099@esperanza> <5408E1CD.3090004@jp.fujitsu.com> <20140905082846.GA25641@esperanza> <5409C6BB.7060009@jp.fujitsu.com> <20140905160029.GF25641@esperanza> <540A4420.2030504@jp.fujitsu.com> <20140908110131.GA11812@esperanza> <540DB4EC.6060100@jp.fujitsu.com> <20140909103943.GA29897@esperanza>
In-Reply-To: <20140909103943.GA29897@esperanza>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-SecurityPolicyCheck-GC: OK by FENCE-Mail
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/09/09 19:39), Vladimir Davydov wrote:

>> For your purpose, you need to implement your method in system-wide way.
>> It seems crazy to set per-cgroup-anon-limit for avoding system-wide-oom.
>> You'll need help of system-wide-cgroup-configuration-middleware even if
>> you have a method in a cgroup. If you say logic should be in OS kernel,
>> please implement it in a system wide logic rather than cgroup.
>
> What if on global pressure a memory cgroup exceeding its soft limit is
> being reclaimed, but not fast enough, because it has a lot of anon
> memory? The global OOM won't be triggered then, because there's still
> progress, but the system will experience hard pressure due to the
> reclaimer runs. How can we detect if we should kill the container or
> not? It smells like one more heuristic to vmscan, IMO.


That's you are trying to implement by per-cgroup-anon+swap-limit, the difference
is heuristics by system designer at container creation or heuristics by kernel in
the dynamic way.

I said it should be done by system/cloud-container-scheduler based on notification.

But okay, let me think of kernel help in global reclaim.

  - Assume "priority" is a value calculated by "usage - soft limit".

  - weighted kswapd/direct reclaim
    => Based on priority of each threads/cgroup,  increase "wait" in direct reclaim
       if it's contended.
       Low prio container will sleep longer until memory contention is fixed.

  - weighted anon allocation
    similar to above, if memory is contended, page fault speed should be weighted
    based on priority(softlimit).

  - off cpu direct-reclaim
    run direct recalim in workqueue with cpu mask. the cpu mask is a global setting
    per numa node, which determines cpus available for being used to reclaim memory.
    "How to wait" may affect the performance of system but this can allow masked cpus
    to be used for more important jobs.

All of them will give a container-manager time to consinder next action.

Anyway, if swap is slow but necessary, you can use faster swap, now.
It's a good age.

Thanks,
-Kame


