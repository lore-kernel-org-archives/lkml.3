Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752360AbaDRII2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 04:08:28 -0400
Received: from relay.parallels.com ([195.214.232.42]:37697 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285AbaDRIIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 04:08:12 -0400
Message-ID: <5350DD6A.1020804@parallels.com>
Date: Fri, 18 Apr 2014 12:08:10 +0400
From: Vladimir Davydov <vdavydov@parallels.com>
MIME-Version: 1.0
To: <mhocko@suse.cz>, <hannes@cmpxchg.org>
CC: <akpm@linux-foundation.org>, <glommer@gmail.com>,
        <cl@linux-foundation.org>, <penberg@kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <devel@openvz.org>
Subject: Re: [PATCH RFC -mm v2 0/3] kmemcg: simplify work-flow (was "memcg-vs-slab
 cleanup")
References: <cover.1397804745.git.vdavydov@parallels.com>
In-Reply-To: <cover.1397804745.git.vdavydov@parallels.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.16.96]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

v1 can be found here: https://lkml.org/lkml/2014/4/9/298

Changes in v2:
  - substitute per memcg slab_caches_mutex's with the global
    memcg_slab_mutex and re-split the set.

>
> I really need your help, because I'm far not sure if what I'm doing here
> is right. So I would appreciate if you could look through the patches
> and share your thoughts about the design changes they introduce.
>
> Thanks,
>
> Vladimir Davydov (3):
>    memcg, slab: do not schedule cache destruction when last page goes
>      away
>    memcg, slab: merge memcg_{bind,release}_pages to
>      memcg_{un}charge_slab
>    memcg, slab: simplify synchronization scheme
>
>   include/linux/memcontrol.h |   15 +--
>   include/linux/slab.h       |    8 +-
>   mm/memcontrol.c            |  231 +++++++++++++++-----------------------------
>   mm/slab.c                  |    2 -
>   mm/slab.h                  |   28 +-----
>   mm/slab_common.c           |   22 ++---
>   mm/slub.c                  |    2 -
>   7 files changed, 92 insertions(+), 216 deletions(-)
>
