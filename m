Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755007AbaBDTgV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 14:36:21 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:57306 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753487AbaBDTgS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 14:36:18 -0500
Date: Tue, 4 Feb 2014 14:36:11 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [PATCH -v2 2/6] memcg: cleanup charge routines
Message-ID: <20140204193611.GS6963@cmpxchg.org>
References: <1391520540-17436-1-git-send-email-mhocko@suse.cz>
 <1391520540-17436-3-git-send-email-mhocko@suse.cz>
 <20140204160509.GN6963@cmpxchg.org>
 <20140204161230.GN4890@dhcp22.suse.cz>
 <20140204164050.GR6963@cmpxchg.org>
 <20140204191125.GA26000@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140204191125.GA26000@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 04, 2014 at 08:11:25PM +0100, Michal Hocko wrote:
> On Tue 04-02-14 11:40:50, Johannes Weiner wrote:
> > On Tue, Feb 04, 2014 at 05:12:30PM +0100, Michal Hocko wrote:
> > > On Tue 04-02-14 11:05:09, Johannes Weiner wrote:
> > > > On Tue, Feb 04, 2014 at 02:28:56PM +0100, Michal Hocko wrote:
> > > > > -	/*
> > > > > -	 * We always charge the cgroup the mm_struct belongs to.
> > > > > -	 * The mm_struct's mem_cgroup changes on task migration if the
> > > > > -	 * thread group leader migrates. It's possible that mm is not
> > > > > -	 * set, if so charge the root memcg (happens for pagecache usage).
> > > > > -	 */
> > > > > -	if (!*ptr && !mm)
> > > > > -		*ptr = root_mem_cgroup;
> > > > 
> > > > [...]
> > > > 
> > > > >  /*
> > > > > + * Charges and returns memcg associated with the given mm (or root_mem_cgroup
> > > > > + * if mm is NULL). Returns NULL if memcg is under OOM.
> > > > > + */
> > > > > +static struct mem_cgroup *mem_cgroup_try_charge_mm(struct mm_struct *mm,
> > > > > +				   gfp_t gfp_mask,
> > > > > +				   unsigned int nr_pages,
> > > > > +				   bool oom)
> > > > > +{
> > > > > +	struct mem_cgroup *memcg;
> > > > > +	int ret;
> > > > > +
> > > > > +	/*
> > > > > +	 * We always charge the cgroup the mm_struct belongs to.
> > > > > +	 * The mm_struct's mem_cgroup changes on task migration if the
> > > > > +	 * thread group leader migrates. It's possible that mm is not
> > > > > +	 * set, if so charge the root memcg (happens for pagecache usage).
> > > > > +	 */
> > > > > +	if (!mm)
> > > > > +		goto bypass;
> > > > 
> > > > Why shuffle it around right before you remove it anyway?  Just start
> > > > the series off with the patches that delete stuff without having to
> > > > restructure anything, get those out of the way.
> > > 
> > > As mentioned in the previous email. I wanted to have this condition
> > > removal bisectable. So it is removed in the next patch when it is
> > > replaced by VM_BUG_ON.
> > 
> > I'm not suggesting to sneak the removal into *this* patch,
> 
> OK
> 
> > just put the simple stand-alone patches that remove stuff first in the
> > series.
> 
> In this particular case, though, the reduced condition is much easier
> to review IMO. Just look at the jungle of different *ptr vs. mm
> combinations described in this patch description which would have to be
> reviewed separately if I moved the removal before this patch.
> The ptr part of the original condition went away naturally here while
> the reasoning why there is no code path implicitly relying on (!ptr &&
> !mm) resulting in bypass would be harder.

You just have to check ptr=NULL callsites...?  "Callsites that don't
provide their own memcg pass a valid mm pointer for lookup."

Anyway, I'm just telling you what threw me off during review.
