Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972AbaIXPtk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 11:49:40 -0400
Received: from gum.cmpxchg.org ([85.214.110.215]:48580 "EHLO gum.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751902AbaIXPti (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 11:49:38 -0400
Date: Wed, 24 Sep 2014 11:49:34 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH -mm] memcg: zap memcg_can_account_kmem
Message-ID: <20140924154934.GA9670@cmpxchg.org>
References: <1411570361-29361-1-git-send-email-vdavydov@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411570361-29361-1-git-send-email-vdavydov@parallels.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 06:52:41PM +0400, Vladimir Davydov wrote:
> memcg_can_account_kmem() returns true iff
> 
>     !mem_cgroup_disabled() && !mem_cgroup_is_root(memcg) &&
>                                    memcg_kmem_is_active(memcg);
> 
> To begin with the !mem_cgroup_is_root(memcg) check is useless, because
> one can't enable kmem accounting for the root cgroup (mem_cgroup_write()
> returns EINVAL on an attempt to set the limit on the root cgroup).
> 
> Furthermore, the !mem_cgroup_disabled() check also seems to be
> redundant. The point is memcg_can_account_kmem() is called from three
> places: mem_cgroup_salbinfo_read(), __memcg_kmem_get_cache(), and
> __memcg_kmem_newpage_charge(). The latter two functions are only invoked
> if memcg_kmem_enabled() returns true, which implies that the memory
> cgroup subsystem is enabled. And mem_cgroup_slabinfo_read() shows the
> output of memory.kmem.slabinfo, which won't exist if the memory cgroup
> is completely disabled.
> 
> So let's substitute all the calls to memcg_can_account_kmem() with plain
> memcg_kmem_is_active(), and kill the former.
> 
> Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>

Yes, the two checks look indeed redundant.

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
