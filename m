Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755091AbaFJHj3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 03:39:29 -0400
Received: from lgeamrelo04.lge.com ([156.147.1.127]:46729 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754903AbaFJHj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 03:39:28 -0400
X-Original-SENDERIP: 10.177.220.145
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
Date: Tue, 10 Jun 2014 16:43:17 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: akpm@linux-foundation.org, cl@linux.com, rientjes@google.com,
        penberg@kernel.org, hannes@cmpxchg.org, mhocko@suse.cz,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH -mm v2 8/8] slab: make dead memcg caches discard free
 slabs immediately
Message-ID: <20140610074317.GE19036@js1304-P5Q-DELUXE>
References: <cover.1402060096.git.vdavydov@parallels.com>
 <27a202c6084d6bb19cc3e417793f05104b908ded.1402060096.git.vdavydov@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <27a202c6084d6bb19cc3e417793f05104b908ded.1402060096.git.vdavydov@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 06, 2014 at 05:22:45PM +0400, Vladimir Davydov wrote:
> Since a dead memcg cache is destroyed only after the last slab allocated
> to it is freed, we must disable caching of empty slabs for such caches,
> otherwise they will be hanging around forever.
> 
> This patch makes SLAB discard dead memcg caches' slabs as soon as they
> become empty. To achieve that, it disables per cpu free object arrays by
> setting array_cache->limit to 0 on each cpu and sets per node free_limit
> to 0 in order to zap slabs_free lists. This is done on kmem_cache_shrink
> (in do_drain, drain_array, drain_alien_cache, and drain_freelist to be
> more exact), which is always called on memcg offline (see
> memcg_unregister_all_caches)
> 
> Note, since array_cache->limit and kmem_cache_node->free_limit are per
> cpu/node and, as a result, they may be updated on cpu/node
> online/offline, we have to patch every place where the limits are
> initialized.

Hello,

You mentioned that disabling per cpu arrays would degrade performance.
But, this patch is implemented to disable per cpu arrays. Is there any
reason to do like this? How about not disabling per cpu arrays and
others? Leaving it as is makes the patch less intrusive and has low
impact on performance. I guess that amount of reclaimed memory has no
big difference between both approaches.

Thanks.

