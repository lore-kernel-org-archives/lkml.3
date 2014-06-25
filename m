Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752681AbaFYEFc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 00:05:32 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:39885 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750699AbaFYEFb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 00:05:31 -0400
Date: Wed, 25 Jun 2014 00:05:26 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Vladimir Davydov <vdavydov@parallels.com>, mhocko@suse.cz,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH -mm 3/3] page-cgroup: fix flags definition
Message-ID: <20140625040526.GR7331@cmpxchg.org>
References: <9f5abf8dcb07fe5462f12f81867f199c22e883d3.1403626729.git.vdavydov@parallels.com>
 <aacc50fb60eeb9cbe14e07235310fb9295b2658b.1403626729.git.vdavydov@parallels.com>
 <20140624162052.6778a13e3b3f4af251e300e7@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140624162052.6778a13e3b3f4af251e300e7@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 24, 2014 at 04:20:52PM -0700, Andrew Morton wrote:
> On Tue, 24 Jun 2014 20:33:06 +0400 Vladimir Davydov <vdavydov@parallels.com> wrote:
> 
> > Since commit a9ce315aaec1f ("mm: memcontrol: rewrite uncharge API"),
> > PCG_* flags are used as bit masks, but they are still defined in a enum
> > as bit numbers. Fix it.
> > 
> > ...
> >
> > --- a/include/linux/page_cgroup.h
> > +++ b/include/linux/page_cgroup.h
> > @@ -1,12 +1,10 @@
> >  #ifndef __LINUX_PAGE_CGROUP_H
> >  #define __LINUX_PAGE_CGROUP_H
> >  
> > -enum {
> > -	/* flags for mem_cgroup */
> > -	PCG_USED,	/* This page is charged to a memcg */
> > -	PCG_MEM,	/* This page holds a memory charge */
> > -	PCG_MEMSW,	/* This page holds a memory+swap charge */
> > -};
> > +/* flags for mem_cgroup */
> > +#define PCG_USED	0x01	/* This page is charged to a memcg */
> > +#define PCG_MEM		0x02	/* This page holds a memory charge */
> > +#define PCG_MEMSW	0x04	/* This page holds a memory+swap charge */
> >  
> >  struct pglist_data;
> >  
> > @@ -44,7 +42,7 @@ struct page *lookup_cgroup_page(struct page_cgroup *pc);
> >  
> >  static inline int PageCgroupUsed(struct page_cgroup *pc)
> >  {
> > -	return test_bit(PCG_USED, &pc->flags);
> > +	return !!(pc->flags & PCG_USED);
> >  }
> >  #else /* !CONFIG_MEMCG */
> >  struct page_cgroup;
> 
> hm, yes, whoops.  I think I'll redo this as a fix against
> mm-memcontrol-rewrite-uncharge-api.patch:

Ouch, yes please.  Thanks for catching this, Vladimir.

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
