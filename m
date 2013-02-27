Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932098Ab3B0IrP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 03:47:15 -0500
Received: from mail-gg0-f202.google.com ([209.85.161.202]:46759 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757982Ab3B0IrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 03:47:14 -0500
From: Greg Thelen <gthelen@google.com>
To: Roman Gushchin <klamm@yandex-team.ru>
Cc: Johannes Weiner-Arquette <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@suse.cz>, bsingharora@gmail.com,
        kamezawa.hiroyu@jp.fujitsu.com, akpm@linux-foundation.org,
        kosaki.motohiro@jp.fujitsu.com, Rik van Riel <riel@redhat.com>,
        mel@csn.ul.ie, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH] memcg: implement low limits
References: <8121361952156@webcorp1g.yandex-team.ru>
Date: Wed, 27 Feb 2013 00:20:36 -0800
In-Reply-To: <8121361952156@webcorp1g.yandex-team.ru> (Roman Gushchin's
	message of "Wed, 27 Feb 2013 12:02:36 +0400")
Message-ID: <xr93y5eacgmj.fsf@gthelen.mtv.corp.google.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 27 2013, Roman Gushchin wrote:

> Hi, all!
>
> I've implemented low limits for memory cgroups. The primary goal was to add an ability 
> to protect some memory from reclaiming without using mlock(). A kind of "soft mlock()".
>
> I think this patch will be helpful when it's necessary to protect production processes from
> memory-wasting backup processes.
>
> --
>
> Low limits for memory cgroup can be used to limit memory pressure on it.
> If memory usage of a cgroup is under it's low limit, it will not be
> affected by global reclaim. If it reaches it's low limit from above,
> the reclaiming speed will be dropped exponentially.
>
> Low limits don't affect soft reclaim.
> Also, it's possible that a cgroup with memory usage under low limit
> will be reclaimed slowly on very low scanning priorities.

So the new low limit is not a rigid limit.  Global reclaim can reclaim
from a cgroup when its usage is below low_limit_in_bytes although such
reclaim is less aggressive than when usage is above low_limit_in_bytes.
Correct?

Why doesn't memcg reclaim (i.e. !global_reclaim) also consider
low_limit_in_bytes?

Do you have demonstration of how this improves system operation?

Why is soft_limit insufficient?

> Signed-off-by: Roman Gushchin <klamm@yandex-team.ru>
> ---
>  include/linux/memcontrol.h  |    7 +++++
>  include/linux/res_counter.h |   17 +++++++++++
>  kernel/res_counter.c        |    2 ++
>  mm/memcontrol.c             |   67 +++++++++++++++++++++++++++++++++++++++++++
>  mm/vmscan.c                 |    5 ++++
>  5 files changed, 98 insertions(+)

Need to update Documentation/cgroups/memory.txt explaining the external
behavior of this new know and how it interacts with soft_limit_in_bytes.
