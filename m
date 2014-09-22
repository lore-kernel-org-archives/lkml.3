Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754233AbaIVOOm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 10:14:42 -0400
Received: from mx2.parallels.com ([199.115.105.18]:35373 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754213AbaIVOOi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 10:14:38 -0400
Date: Mon, 22 Sep 2014 18:14:20 +0400
From: Vladimir Davydov <vdavydov@parallels.com>
To: Michal Hocko <mhocko@suse.cz>
CC: Andrew Morton <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <linux-mm@kvack.org>, Johannes Weiner <hannes@cmpxchg.org>,
        Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH 1/2] memcg: move memcg_{alloc,free}_cache_params to
 slab_common.c
Message-ID: <20140922141420.GD18526@esperanza>
References: <e768785511927d65bd3e6d9f65ab2a9851a3d73d.1411054735.git.vdavydov@parallels.com>
 <20140922135245.GE336@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140922135245.GE336@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2014 at 03:52:45PM +0200, Michal Hocko wrote:
> On Thu 18-09-14 19:50:19, Vladimir Davydov wrote:
> > The only reason why they live in memcontrol.c is that we get/put css
> > reference to the owner memory cgroup in them. However, we can do that in
> > memcg_{un,}register_cache.
> > 
> > So let's move them to slab_common.c and make them static.
> 
> Why is it better?

First, I think that the less public interface functions we have in
memcontrol.h the better. Since the functions I move don't depend on
memcontrol, I think it's worth making them private to slab, especially
taking into account that the arrays are defined on the slab's side too.

Second, the way how per-memcg arrays are updated looks rather awkward:
it proceeds from memcontrol.c (__memcg_activate_kmem) to slab_common.c
(memcg_update_all_caches) and back to memcontrol.c again
(memcg_update_array_size). In the next patch I move the function
relocating the arrays (memcg_update_array_size) to slab_common.c and
therefore get rid this circular call path. I think we should have the
cache allocation stuff in the same place where we have relocation,
because it's easier to follow the code then. So I move arrays alloc/free
functions to slab_common.c too.

The third point isn't obvious. In the "Per memcg slab shrinkers" patch
set, which I sent recently, I have to update per-memcg list_lrus arrays
too. And it's much easier and cleaner to do it in list_lru.c rather than
in memcontrol.c. The current patchset makes cache arrays allocation path
conform that of the upcoming list_lru.

Thanks,
Vladimir
