Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755346AbaDTKcw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2014 06:32:52 -0400
Received: from relay.parallels.com ([195.214.232.42]:55830 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754905AbaDTKcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2014 06:32:41 -0400
Message-ID: <5353A23F.4080303@parallels.com>
Date: Sun, 20 Apr 2014 14:32:31 +0400
From: Vladimir Davydov <vdavydov@parallels.com>
MIME-Version: 1.0
To: <akpm@linux-foundation.org>
CC: <mhocko@suse.cz>, <hannes@cmpxchg.org>, <glommer@gmail.com>,
        <cl@linux-foundation.org>, <penberg@kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <devel@openvz.org>
Subject: Re: [PATCH RFC -mm v2 0/3] kmemcg: simplify work-flow (was "memcg-vs-slab
 cleanup")
References: <cover.1397804745.git.vdavydov@parallels.com>
In-Reply-To: <cover.1397804745.git.vdavydov@parallels.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [81.5.110.170]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Please do not apply this set for the time being, because I still have
doubts about the end picture I had in mind when submitting it.

Besides, it won't apply cleanly on top of the mm tree after "slab:
get_online_mems for kmem_cache_{create,destroy,shrink}" has been merged.

I'm going to have a bit more thinking/discussing on the problem and then
will either rework or just rebase the patch set and resend.

Thanks.

On 04/18/2014 12:04 PM, Vladimir Davydov wrote:
> Hi Michal, Johannes,
> 
> This patch-set is a part of preparations for kmemcg re-parenting. It
> targets at simplifying kmemcg work-flows and synchronization.
> 
> First, it removes async per memcg cache destruction (see patches 1, 2).
> Now caches are only destroyed on memcg offline. That means the caches
> that are not empty on memcg offline will be leaked. However, they are
> already leaked, because memcg_cache_params::nr_pages normally never
> drops to 0 so the destruction work is never scheduled except
> kmem_cache_shrink is called explicitly. In the future I'm planning
> reaping such dead caches on vmpressure or periodically.
> 
> Second, it substitutes per memcg slab_caches_mutex's with the global
> memcg_slab_mutex, which should be taken during the whole per memcg cache
> creation/destruction path before the slab_mutex (see patch 3). This
> greatly simplifies synchronization among various per memcg cache
> creation/destruction paths.
> 
> I really need your help, because I'm far not sure if what I'm doing here
> is right. So I would appreciate if you could look through the patches
> and share your thoughts about the design changes they introduce.
> 
> Thanks,
> 
> Vladimir Davydov (3):
>   memcg, slab: do not schedule cache destruction when last page goes
>     away
>   memcg, slab: merge memcg_{bind,release}_pages to
>     memcg_{un}charge_slab
>   memcg, slab: simplify synchronization scheme
> 
>  include/linux/memcontrol.h |   15 +--
>  include/linux/slab.h       |    8 +-
>  mm/memcontrol.c            |  231 +++++++++++++++-----------------------------
>  mm/slab.c                  |    2 -
>  mm/slab.h                  |   28 +-----
>  mm/slab_common.c           |   22 ++---
>  mm/slub.c                  |    2 -
>  7 files changed, 92 insertions(+), 216 deletions(-)
> 

