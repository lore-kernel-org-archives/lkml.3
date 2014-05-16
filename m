Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932585AbaEPPD3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 11:03:29 -0400
Received: from qmta07.emeryville.ca.mail.comcast.net ([76.96.30.64]:50082 "EHLO
	qmta07.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755513AbaEPPD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 11:03:26 -0400
Date: Fri, 16 May 2014 10:03:22 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Vladimir Davydov <vdavydov@parallels.com>
cc: hannes@cmpxchg.org, mhocko@suse.cz, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH RFC 3/3] slub: reparent memcg caches' slabs on memcg
 offline
In-Reply-To: <20140516132234.GF32113@esperanza>
Message-ID: <alpine.DEB.2.10.1405160957100.32249@gentwo.org>
References: <cover.1399982635.git.vdavydov@parallels.com> <6eafe1e95d9a934228e9af785f5b5de38955aa6a.1399982635.git.vdavydov@parallels.com> <alpine.DEB.2.10.1405141119320.16512@gentwo.org> <20140515071650.GB32113@esperanza> <alpine.DEB.2.10.1405151015330.24665@gentwo.org>
 <20140516132234.GF32113@esperanza>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 May 2014, Vladimir Davydov wrote:

> > Do we even know that all objects in that slab belong to a certain cgroup?
> > AFAICT the fastpath currently do not allow to make that distinction.
>
> All allocations from a memcg's cache are accounted to the owner memcg,
> so that all objects on the same slab belong to the same memcg, a pointer
> to which can be obtained from the page->slab_cache->memcg_params. At
> least, this is true since commit faebbfe10ec1 ("sl[au]b: charge slabs to
> kmemcg explicitly").

I doubt that. The accounting occurs when a new cpu slab page is allocated.
But the individual allocations in the fastpath are not accounted to a
specific group. Thus allocation in a slab page can belong to various
cgroups.

> > I wish you would find some other way to do this.
>
> The only practical alternative to re-parenting I see right now is
> periodic reaping, but Johannes isn't very fond of it, and his opinion is
> quite justified, because having caches that will never be allocated from
> hanging around indefinitely, only because they have a couple of active
> objects to be freed, doesn't look very good.

If all objects in the cache are in use then the slab page needs to hang
around since the objects presence is required. You may not know exactly
which cgroups these object belong to. The only thing that you may now (if
you keep a list of full slabs) is which cgroup was in use then the
slab page was initially allocated.

Isnt it sufficient to add a counter of full slabs to a cgroup? When you
allocate a new slab page add to the counter. When an object in a slab page
is freed and the slab page goes on a partial list decrement the counter.

That way you can avoid tracking full slabs.

