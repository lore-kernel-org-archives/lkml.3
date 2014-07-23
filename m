Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757863AbaGWOix (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 10:38:53 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41876 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751754AbaGWOiv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 10:38:51 -0400
Date: Wed, 23 Jul 2014 16:38:47 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Tejun Heo <tj@kernel.org>,
        Vladimir Davydov <vdavydov@parallels.com>, linux-mm@kvack.org,
        cgroups@vger.kernel.org,
        Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch 13/13] mm: memcontrol: rewrite uncharge API
Message-ID: <20140723143847.GB16721@dhcp22.suse.cz>
References: <1403124045-24361-1-git-send-email-hannes@cmpxchg.org>
 <1403124045-24361-14-git-send-email-hannes@cmpxchg.org>
 <20140715082545.GA9366@dhcp22.suse.cz>
 <20140715121935.GB9366@dhcp22.suse.cz>
 <20140718071246.GA21565@dhcp22.suse.cz>
 <20140718144554.GG29639@cmpxchg.org>
 <CAJfpegt9k+YULet3vhmG3br7zSiHy-DRL+MiEE=HRzcs+mLzbw@mail.gmail.com>
 <20140719173911.GA1725@cmpxchg.org>
 <20140722150825.GA4517@dhcp22.suse.cz>
 <CAJfpegscT-ptQzq__uUV2TOn7Uvs6x4FdWGTQb9Fe9MEJr2KjA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpegscT-ptQzq__uUV2TOn7Uvs6x4FdWGTQb9Fe9MEJr2KjA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 22-07-14 17:44:43, Miklos Szeredi wrote:
> On Tue, Jul 22, 2014 at 5:08 PM, Michal Hocko <mhocko@suse.cz> wrote:
> > On Sat 19-07-14 13:39:11, Johannes Weiner wrote:
> >> On Fri, Jul 18, 2014 at 05:12:54PM +0200, Miklos Szeredi wrote:
> >> > On Fri, Jul 18, 2014 at 4:45 PM, Johannes Weiner <hannes@cmpxchg.org> wrote:
> >> >
> >> > > I assumed the source page would always be new, according to this part
> >> > > in fuse_try_move_page():
> >> > >
> >> > >         /*
> >> > >          * This is a new and locked page, it shouldn't be mapped or
> >> > >          * have any special flags on it
> >> > >          */
> >> > >         if (WARN_ON(page_mapped(oldpage)))
> >> > >                 goto out_fallback_unlock;
> >> > >         if (WARN_ON(page_has_private(oldpage)))
> >> > >                 goto out_fallback_unlock;
> >> > >         if (WARN_ON(PageDirty(oldpage) || PageWriteback(oldpage)))
> >> > >                 goto out_fallback_unlock;
> >> > >         if (WARN_ON(PageMlocked(oldpage)))
> >> > >                 goto out_fallback_unlock;
> >> > >
> >> > > However, it's in the page cache and I can't really convince myself
> >> > > that it's not also on the LRU.  Miklos, I have trouble pinpointing
> >> > > where oldpage is instantiated exactly and what state it might be in -
> >> > > can it already be on the LRU?
> >> >
> >> > oldpage comes from ->readpages() (*NOT* ->readpage()), i.e. readahead.
> >> >
> >> > AFAICS it is added to the LRU in read_cache_pages(), so it looks like
> >> > it is definitely on the LRU at that point.
> >
> > OK, so my understanding of the code was wrong :/ and staring at it for
> > quite a while didn't help much. The fuse code is so full of indirection
> > it makes my head spin.
> 
> Definitely needs a rewrite.  But forget the complexities for the
> moment and just consider this single case:
> 
>  ->readpages() is called to do some readahead, pages are locked, added
> to the page cache and, AFAICS, charged to a memcg (in
> add_to_page_cache_lru()).
> 
>  - fuse sends a READ request to userspace and it gets a reply with
> splice(... SPLICE_F_MOVE).  What this means that a bunch of pages of
> indefinite origin are to replace (if possible) the pages already in
> the page cache.  If not possible, for some reason, it falls back to
> copying the contents.  So, AFAICS, the oldpage and the newpage can be
> charged to a different memcg.

OK, thanks for the clarification. I had this feeling but couldn't wrap
my head around the indirection of the code.

It seems that checkig PageCgroupUsed(new) and bail out early in
mem_cgroup_migrate should just work, no?

> > How should we test this code path, Miklos?
> 
>   fusexmp_fh -osplice_write,splice_move /mnt/fuse
> 
> This will mirror / under /mnt/fuse and will use splice to move data
> from the underlying filesystem to the fuse filesystem, hopefully.
> 
> It would be useful if it had some instrumentation telling us the
> actual number of pages successfully moved, but it doesn't have that
> yet.

Thanks I will try to play with this tomorrow when I have more time.
-- 
Michal Hocko
SUSE Labs
