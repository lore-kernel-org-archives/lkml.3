Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752926Ab3LPJiW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 04:38:22 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:46642 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769Ab3LPJiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 04:38:20 -0500
Message-ID: <52AEC989.4080509@huawei.com>
Date: Mon, 16 Dec 2013 17:36:09 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Hugh Dickins <hughd@google.com>
CC: Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        <linux-mm@kvack.org>, <cgroups@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: 3.13-rc breaks MEMCG_SWAP
References: <alpine.LNX.2.00.1312160025200.2785@eggly.anvils>
In-Reply-To: <alpine.LNX.2.00.1312160025200.2785@eggly.anvils>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/12/16 16:36, Hugh Dickins wrote:
> CONFIG_MEMCG_SWAP is broken in 3.13-rc.  Try something like this:
> 
> mkdir -p /tmp/tmpfs /tmp/memcg
> mount -t tmpfs -o size=1G tmpfs /tmp/tmpfs
> mount -t cgroup -o memory memcg /tmp/memcg
> mkdir /tmp/memcg/old
> echo 512M >/tmp/memcg/old/memory.limit_in_bytes
> echo $$ >/tmp/memcg/old/tasks
> cp /dev/zero /tmp/tmpfs/zero 2>/dev/null
> echo $$ >/tmp/memcg/tasks
> rmdir /tmp/memcg/old
> sleep 1	# let rmdir work complete
> mkdir /tmp/memcg/new
> umount /tmp/tmpfs
> dmesg | grep WARNING
> rmdir /tmp/memcg/new
> umount /tmp/memcg
> 
> Shows lots of WARNING: CPU: 1 PID: 1006 at kernel/res_counter.c:91
>                            res_counter_uncharge_locked+0x1f/0x2f()
> 
> Breakage comes from 34c00c319ce7 ("memcg: convert to use cgroup id").
> 
> The lifetime of a cgroup id is different from the lifetime of the
> css id it replaced: memsw's css_get()s do nothing to hold on to the
> old cgroup id, it soon gets recycled to a new cgroup, which then
> mysteriously inherits the old's swap, without any charge for it.
> (I thought memsw's particular need had been discussed and was
> well understood when 34c00c319ce7 went in, but apparently not.)
> 
> The right thing to do at this stage would be to revert that and its
> associated commits; but I imagine to do so would be unwelcome to
> the cgroup guys, going against their general direction; and I've
> no idea how embedded that css_id removal has become by now.
> 
> Perhaps some creative refcounting can rescue memsw while still
> using cgroup id?
> 

Sorry for the broken.

I think we can keep the cgroup->id until the last css reference is
dropped and the css is scheduled to be destroyed.

I'll cook a fix tomorrow.

