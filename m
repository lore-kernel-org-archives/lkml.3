Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755412AbaGDMQZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 08:16:25 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53243 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751850AbaGDMQX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 08:16:23 -0400
Date: Fri, 4 Jul 2014 14:16:21 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Hugh Dickins <hughd@google.com>, David Rientjes <rientjes@google.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Balbir Singh <bsingharora@gmail.com>
Subject: Re: [PATCH RFC 0/5] Virtual Memory Resource Controller for cgroups
Message-ID: <20140704121621.GE12466@dhcp22.suse.cz>
References: <cover.1404383187.git.vdavydov@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1404383187.git.vdavydov@parallels.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 03-07-14 16:48:16, Vladimir Davydov wrote:
> Hi,
> 
> Typically, when a process calls mmap, it isn't given all the memory pages it
> requested immediately. Instead, only its address space is grown, while the
> memory pages will be actually allocated on the first use. If the system fails
> to allocate a page, it will have no choice except invoking the OOM killer,
> which may kill this or any other process. Obviously, it isn't the best way of
> telling the user that the system is unable to handle his request. It would be
> much better to fail mmap with ENOMEM instead.
> 
> That's why Linux has the memory overcommit control feature, which accounts and
> limits VM size that may contribute to mem+swap, i.e. private writable mappings
> and shared memory areas. However, currently it's only available system-wide,
> and there's no way of avoiding OOM in cgroups.
>
> This patch set is an attempt to fill the gap. It implements the resource
> controller for cgroups that accounts and limits address space allocations that
> may contribute to mem+swap.

Well, I am not really sure how helpful is this. Could you be more
specific about real use cases? If the only problem is that memcg OOM can
trigger to easily then I do not think this is the right approach to
handle it. Strict no-overcommit is basically unusable for many
workloads. Especially those which try to do their own memory usage
optimization in a much larger address space.

Once I get from internal things (which will happen soon hopefully) I
will post a series with a new sets of memcg limits. One of them is
high_limit which can be used as a trigger for memcg reclaim. Unlike
hard_limit there won't be any OOM if the reclaim fails at this stage. So
if the high_limit is configured properly the admin will have enough time
to make additional steps before OOM happens.
[...]
-- 
Michal Hocko
SUSE Labs
