Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757364AbaC0Uig (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 16:38:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47620 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755086AbaC0Uif (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 16:38:35 -0400
Date: Thu, 27 Mar 2014 13:38:29 -0700
From: Michal Hocko <mhocko@suse.cz>
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, glommer@gmail.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, devel@openvz.org,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>
Subject: Re: [PATCH -mm 2/4] sl[au]b: charge slabs to memcg explicitly
Message-ID: <20140327203829.GA28590@dhcp22.suse.cz>
References: <cover.1395846845.git.vdavydov@parallels.com>
 <1d0196602182e5284f3289eaea0219e62a51d1c4.1395846845.git.vdavydov@parallels.com>
 <20140326215848.GB22656@dhcp22.suse.cz>
 <5333D576.1050106@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5333D576.1050106@parallels.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 27-03-14 11:38:30, Vladimir Davydov wrote:
> On 03/27/2014 01:58 AM, Michal Hocko wrote:
> > On Wed 26-03-14 19:28:05, Vladimir Davydov wrote:
> >> We have only a few places where we actually want to charge kmem so
> >> instead of intruding into the general page allocation path with
> >> __GFP_KMEMCG it's better to explictly charge kmem there. All kmem
> >> charges will be easier to follow that way.
> >>
> >> This is a step towards removing __GFP_KMEMCG. It removes __GFP_KMEMCG
> >> from memcg caches' allocflags. Instead it makes slab allocation path
> >> call memcg_charge_kmem directly getting memcg to charge from the cache's
> >> memcg params.
> > Yes, removing __GFP_KMEMCG is definitely a good step. I am currently at
> > a conference and do not have much time to review this properly (even
> > worse will be on vacation for the next 2 weeks) but where did all the
> > static_key optimization go? What am I missing.
> 
> I expected this question, because I want somebody to confirm if we
> really need such kind of optimization in the slab allocation path. From
> my POV, since we thrash cpu caches there anyway by calling alloc_pages,
> wrapping memcg_charge_slab in a static branch wouldn't result in any
> noticeable performance boost.
> 
> I do admit we benefit from static branching in memcg_kmem_get_cache,
> because this one is called on every kmem object allocation, but slab
> allocations happen much rarer.
> 
> I don't insist on that though, so if you say "no", I'll just add
> __memcg_charge_slab and make memcg_charge_slab call it if the static key
> is on, but may be, we can avoid such code bloating?

I definitely do not insist on static branching at places where it
doesn't help much. The less tricky code we will have the better. Please
document this in the changelog and drop a comment in memcg_charge_slab
which would tell us why we do not have to check for kmem enabling.

Thanks!
-- 
Michal Hocko
SUSE Labs
