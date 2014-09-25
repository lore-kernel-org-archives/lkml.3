Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753076AbaIYOLy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 10:11:54 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:63266 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751989AbaIYOLx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 10:11:53 -0400
Date: Thu, 25 Sep 2014 16:11:48 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
        Tejun Heo <tj@kernel.org>, linux-mm@kvack.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch v2] mm: memcontrol: do not iterate uninitialized memcgs
Message-ID: <20140925141148.GD11080@dhcp22.suse.cz>
References: <1411612278-4707-1-git-send-email-hannes@cmpxchg.org>
 <20140925024054.GA4888@cmpxchg.org>
 <20140925114339.GD12090@dhcp22.suse.cz>
 <20140925135450.GA1822@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140925135450.GA1822@cmpxchg.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 25-09-14 09:54:50, Johannes Weiner wrote:
> On Thu, Sep 25, 2014 at 01:43:39PM +0200, Michal Hocko wrote:
> > On Wed 24-09-14 22:40:55, Johannes Weiner wrote:
> > > Argh, buggy css_put() against the root.  Hand grenades, everywhere.
> > > Update:
> > > 
> > > ---
> > > From 9b0b4d72d71cd8acd7aaa58d2006c751decc8739 Mon Sep 17 00:00:00 2001
> > > From: Johannes Weiner <hannes@cmpxchg.org>
> > > Date: Wed, 24 Sep 2014 22:00:20 -0400
> > > Subject: [patch] mm: memcontrol: do not iterate uninitialized memcgs
> > > 
> > > The cgroup iterators yield css objects that have not yet gone through
> > > css_online(), but they are not complete memcgs at this point and so
> > > the memcg iterators should not return them.  d8ad30559715 ("mm/memcg:
> > > iteration skip memcgs not yet fully initialized") set out to implement
> > > exactly this, but it uses CSS_ONLINE, a cgroup-internal flag that does
> > > not meet the ordering requirements for memcg, and so we still may see
> > > partially initialized memcgs from the iterators.
> > 
> > I do not see how would this happen. CSS_ONLINE is set after css_online
> > callback returns and mem_cgroup_css_online ends the core initialization
> > with mutex_unlock which should provide sufficient memory ordering
> > requirements
> 
> But the iterators do not use the mutex?  We are missing the matching
> acquire for the proper ordering.

OK, I guess you are right. Besides that I am not sure what are the
ordering guarantees of mutex now that I am looking into the code.

Anyway it is definitely better to be explicit about barriers.

-- 
Michal Hocko
SUSE Labs
