Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752096AbaBCNUG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 08:20:06 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59831 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751472AbaBCNUD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 08:20:03 -0500
Date: Mon, 3 Feb 2014 14:20:01 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [RFC 1/5] memcg: cleanup charge routines
Message-ID: <20140203132001.GE2495@dhcp22.suse.cz>
References: <1387295130-19771-1-git-send-email-mhocko@suse.cz>
 <1387295130-19771-2-git-send-email-mhocko@suse.cz>
 <20140130171837.GD6963@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140130171837.GD6963@cmpxchg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 30-01-14 12:18:37, Johannes Weiner wrote:
> On Tue, Dec 17, 2013 at 04:45:26PM +0100, Michal Hocko wrote:
[...]
> > -static int __mem_cgroup_try_charge(struct mm_struct *mm,
> > -				   gfp_t gfp_mask,
> > +static int __mem_cgroup_try_charge_memcg(gfp_t gfp_mask,
> >  				   unsigned int nr_pages,
> > -				   struct mem_cgroup **ptr,
> > +				   struct mem_cgroup *memcg,
> >  				   bool oom)
> 
> Why not keep the __mem_cgroup_try_charge() name?  It's shorter and
> just as descriptive.

I wanted to have 2 different names with clear reference to _what_ is
going to be charged. But I am always open to naming suggestions.

[...]
> > +static bool mem_cgroup_bypass_charge(void)
> 
> The name and parameter list suggests this consults some global memory
> cgroup state.  current_bypass_charge()?

OK, that sounds better.

> I think ultimately we want to move away from all these mem_cgroup
> prefixes of static functions in there, they add nothing of value.

Yes, I agree that mem_cgroup prefix is clumsy and we should drop it.

[...]
> > +/*
> > + * Charges and returns memcg associated with the given mm (or root_mem_cgroup
> > + * if mm is NULL). Returns NULL if memcg is under OOM.
> > + */
> > +static struct mem_cgroup *mem_cgroup_try_charge_mm(struct mm_struct *mm,
> > +				   gfp_t gfp_mask,
> > +				   unsigned int nr_pages,
> > +				   bool oom)
> 
> We already have a try_get_mem_cgroup_from_mm().
>
> After this series, this function basically duplicates that and it
> would be much cleaner if we only had one try_charge() function and let
> all the callers use the appropriate try_get_mem_cgroup_from_wherever()
> themselves.

try_get_mem_cgroup_from_mm doesn't charge memory itself. It just tries
to get memcg from the given mm. It is called also from a context which
doesn't charge any memory (task_in_mem_cgroup). Or have I misunderstood
you?

> If you pull the patch that moves consume_stock() back into
> try_charge() up front, I think this cleanup would be more obvious and
> the result even better.

OK, I can move it.

Thanks!

-- 
Michal Hocko
SUSE Labs
