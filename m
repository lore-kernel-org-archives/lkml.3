Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755996AbaE3O5N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 10:57:13 -0400
Received: from qmta02.emeryville.ca.mail.comcast.net ([76.96.30.24]:58249 "EHLO
	qmta02.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755212AbaE3O5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 10:57:12 -0400
Date: Fri, 30 May 2014 09:57:10 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
To: Vladimir Davydov <vdavydov@parallels.com>
cc: akpm@linux-foundation.org, hannes@cmpxchg.org, mhocko@suse.cz,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH -mm 7/8] slub: make dead caches discard free slabs
 immediately
In-Reply-To: <5d2fbc894a2c62597e7196bb1ebb8357b15529ab.1401457502.git.vdavydov@parallels.com>
Message-ID: <alpine.DEB.2.10.1405300955120.11943@gentwo.org>
References: <cover.1401457502.git.vdavydov@parallels.com> <5d2fbc894a2c62597e7196bb1ebb8357b15529ab.1401457502.git.vdavydov@parallels.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 May 2014, Vladimir Davydov wrote:

> (3) is a bit more difficult, because slabs are added to per-cpu partial
> lists lock-less. Fortunately, we only have to handle the __slab_free
> case, because, as there shouldn't be any allocation requests dispatched
> to a dead memcg cache, get_partial_node() should never be called. In
> __slab_free we use cmpxchg to modify kmem_cache_cpu->partial (see
> put_cpu_partial) so that setting ->partial to a special value, which
> will make put_cpu_partial bail out, will do the trick.
>
> Note, this shouldn't affect performance, because keeping empty slabs on
> per node lists as well as using per cpu partials are only worthwhile if
> the cache is used for allocations, which isn't the case for dead caches.

This all sounds pretty good to me but we still have some pretty extensive
modifications that I would rather avoid.

In put_cpu_partial you can simply check that the memcg is dead right? This
would avoid all the other modifications I would think and will not require
a special value for the per cpu partial pointer.
