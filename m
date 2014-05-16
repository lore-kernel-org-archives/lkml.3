Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756139AbaEPNWo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 09:22:44 -0400
Received: from mx2.parallels.com ([199.115.105.18]:44789 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755222AbaEPNWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 09:22:43 -0400
Date: Fri, 16 May 2014 17:22:35 +0400
From: Vladimir Davydov <vdavydov@parallels.com>
To: Christoph Lameter <cl@linux.com>
CC: <hannes@cmpxchg.org>, <mhocko@suse.cz>, <akpm@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
Subject: Re: [PATCH RFC 3/3] slub: reparent memcg caches' slabs on memcg
 offline
Message-ID: <20140516132234.GF32113@esperanza>
References: <cover.1399982635.git.vdavydov@parallels.com>
 <6eafe1e95d9a934228e9af785f5b5de38955aa6a.1399982635.git.vdavydov@parallels.com>
 <alpine.DEB.2.10.1405141119320.16512@gentwo.org>
 <20140515071650.GB32113@esperanza>
 <alpine.DEB.2.10.1405151015330.24665@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1405151015330.24665@gentwo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2014 at 10:16:39AM -0500, Christoph Lameter wrote:
> On Thu, 15 May 2014, Vladimir Davydov wrote:
> 
> > I admit that's far not perfect, because kfree is really a hot path,
> > where every byte of code matters, but unfortunately I don't see how we
> > can avoid this in case we want slab re-parenting.
> 
> Do we even know that all objects in that slab belong to a certain cgroup?
> AFAICT the fastpath currently do not allow to make that distinction.

All allocations from a memcg's cache are accounted to the owner memcg,
so that all objects on the same slab belong to the same memcg, a pointer
to which can be obtained from the page->slab_cache->memcg_params. At
least, this is true since commit faebbfe10ec1 ("sl[au]b: charge slabs to
kmemcg explicitly").

> > Again, I'd like to hear from you if there is any point in moving in this
> > direction, or I should give up and concentrate on some other approach,
> > because you'll never accept it.
> 
> I wish you would find some other way to do this.

The only practical alternative to re-parenting I see right now is
periodic reaping, but Johannes isn't very fond of it, and his opinion is
quite justified, because having caches that will never be allocated from
hanging around indefinitely, only because they have a couple of active
objects to be freed, doesn't look very good.

Thanks.
