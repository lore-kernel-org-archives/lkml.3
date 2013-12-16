Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752519Ab3LPJxs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 04:53:48 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49528 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750995Ab3LPJxr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 04:53:47 -0500
Date: Mon, 16 Dec 2013 10:53:45 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Li Zefan <lizefan@huawei.com>
Cc: Hugh Dickins <hughd@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: 3.13-rc breaks MEMCG_SWAP
Message-ID: <20131216095345.GB23582@dhcp22.suse.cz>
References: <alpine.LNX.2.00.1312160025200.2785@eggly.anvils>
 <52AEC989.4080509@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52AEC989.4080509@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 16-12-13 17:36:09, Li Zefan wrote:
> On 2013/12/16 16:36, Hugh Dickins wrote:
> > CONFIG_MEMCG_SWAP is broken in 3.13-rc.  Try something like this:
> > 
> > mkdir -p /tmp/tmpfs /tmp/memcg
> > mount -t tmpfs -o size=1G tmpfs /tmp/tmpfs
> > mount -t cgroup -o memory memcg /tmp/memcg
> > mkdir /tmp/memcg/old
> > echo 512M >/tmp/memcg/old/memory.limit_in_bytes
> > echo $$ >/tmp/memcg/old/tasks
> > cp /dev/zero /tmp/tmpfs/zero 2>/dev/null
> > echo $$ >/tmp/memcg/tasks
> > rmdir /tmp/memcg/old
> > sleep 1	# let rmdir work complete
> > mkdir /tmp/memcg/new
> > umount /tmp/tmpfs
> > dmesg | grep WARNING
> > rmdir /tmp/memcg/new
> > umount /tmp/memcg
> > 
> > Shows lots of WARNING: CPU: 1 PID: 1006 at kernel/res_counter.c:91
> >                            res_counter_uncharge_locked+0x1f/0x2f()
> > 
> > Breakage comes from 34c00c319ce7 ("memcg: convert to use cgroup id").
> > 
> > The lifetime of a cgroup id is different from the lifetime of the
> > css id it replaced: memsw's css_get()s do nothing to hold on to the
> > old cgroup id, it soon gets recycled to a new cgroup, which then
> > mysteriously inherits the old's swap, without any charge for it.
> > (I thought memsw's particular need had been discussed and was
> > well understood when 34c00c319ce7 went in, but apparently not.)
> > 
> > The right thing to do at this stage would be to revert that and its
> > associated commits; but I imagine to do so would be unwelcome to
> > the cgroup guys, going against their general direction; and I've
> > no idea how embedded that css_id removal has become by now.
> > 
> > Perhaps some creative refcounting can rescue memsw while still
> > using cgroup id?
> > 
> 
> Sorry for the broken.
> 
> I think we can keep the cgroup->id until the last css reference is
> dropped and the css is scheduled to be destroyed.

How would this work? The task which pushed the memory to the swap is
still alive (living in a different group) and the swap will be there
after the last reference to css as well.
 
> I'll cook a fix tomorrow.
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

-- 
Michal Hocko
SUSE Labs
