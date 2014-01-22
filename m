Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754645AbaAVIMT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 03:12:19 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58171 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754261AbaAVIMQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 03:12:16 -0500
Date: Wed, 22 Jan 2014 09:12:12 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Hugh Dickins <hughd@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Greg Thelen <gthelen@google.com>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -mm 2/2] memcg: fix css reference leak and endless loop
 in mem_cgroup_iter
Message-ID: <20140122081212.GA18154@dhcp22.suse.cz>
References: <20140121083454.GA1894@dhcp22.suse.cz>
 <1390301143-9541-1-git-send-email-mhocko@suse.cz>
 <1390301143-9541-2-git-send-email-mhocko@suse.cz>
 <20140121114219.8c34256dfbe7c2470b36ced8@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140121114219.8c34256dfbe7c2470b36ced8@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 21-01-14 11:42:19, Andrew Morton wrote:
> On Tue, 21 Jan 2014 11:45:43 +0100 Michal Hocko <mhocko@suse.cz> wrote:
> 
> > 19f39402864e (memcg: simplify mem_cgroup_iter) has reorganized
> > mem_cgroup_iter code in order to simplify it. A part of that change was
> > dropping an optimization which didn't call css_tryget on the root of
> > the walked tree. The patch however didn't change the css_put part in
> > mem_cgroup_iter which excludes root.
> > This wasn't an issue at the time because __mem_cgroup_iter_next bailed
> > out for root early without taking a reference as cgroup iterators
> > (css_next_descendant_pre) didn't visit root themselves.
> > 
> > Nevertheless cgroup iterators have been reworked to visit root by
> > bd8815a6d802 (cgroup: make css_for_each_descendant() and friends include
> > the origin css in the iteration) when the root bypass have been dropped
> > in __mem_cgroup_iter_next. This means that css_put is not called for
> > root and so css along with mem_cgroup and other cgroup internal object
> > tied by css lifetime are never freed.
> > 
> > Fix the issue by reintroducing root check in __mem_cgroup_iter_next
> > and do not take css reference for it.
> > 
> > This reference counting magic protects us also from another issue, an
> > endless loop reported by Hugh Dickins when reclaim races with root
> > removal and css_tryget called by iterator internally would fail. There
> > would be no other nodes to visit so __mem_cgroup_iter_next would return
> > NULL and mem_cgroup_iter would interpret it as "start looping from root
> > again" and so mem_cgroup_iter would loop forever internally.
> 
> I grabbed these two patches but I will sit on them for a week or so,
> pending review-n-test.

Yes, there is no rush and this needs a proper review.

> > Cc: stable@vger.kernel.org # mem_leak part 3.12+
> 
> What does this mean?

Dohh. I had both patches in one but then I decided to split it. This is
just left over. Should be 3.12+.

Sorry about the confusion.

-- 
Michal Hocko
SUSE Labs
