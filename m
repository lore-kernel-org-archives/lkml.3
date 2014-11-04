Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753857AbaKDNG7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 08:06:59 -0500
Received: from cantor2.suse.de ([195.135.220.15]:46247 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753293AbaKDNG4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 08:06:56 -0500
Date: Tue, 4 Nov 2014 14:06:52 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: David Miller <davem@davemloft.net>, kirill@shutemov.name,
        akpm@linux-foundation.org, vdavydov@parallels.com, tj@kernel.org,
        linux-mm@kvack.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 1/3] mm: embed the memcg pointer directly into struct page
Message-ID: <20141104130652.GC22207@dhcp22.suse.cz>
References: <20141103210607.GA24091@node.dhcp.inet.fi>
 <20141103213628.GA11428@phnom.home.cmpxchg.org>
 <20141103215206.GB24091@node.dhcp.inet.fi>
 <20141103.165807.2039166055692354811.davem@davemloft.net>
 <20141103223626.GA12006@phnom.home.cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141103223626.GA12006@phnom.home.cmpxchg.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 03-11-14 17:36:26, Johannes Weiner wrote:
[...]
> Also, nobody is using that space currently, and I can save memory by
> moving the pointer in there.  Should we later add another pointer to
> struct page we are only back to the status quo - with the difference
> that booting with cgroup_disable=memory will no longer save the extra
> pointer per page, but again, if you care that much, you can disable
> memory cgroups at compile-time.

There would be a slight inconvenience for 32b machines with distribution
kernels which cannot simply drop CONFIG_MEMCG from the config.
Especially those 32b machines with a lot of memory.

I have checked configuration used for OpenSUSE PAE kernel. Both the
struct page and the code size grow. There are additional 4B with SLAB
and SLUB gets 8 because of the alignment in the struct page. So the
overhead is 4B per page with SLUB.

This doesn't sound too bad to me considering that 64b actually even
saves some space with SLUB and it is at the same level with SLAB and
more importantly gets rid of the lookup in hot paths.

The code size grows (~1.5k) most probably due to struct page pointer
arithmetic (but I haven't checked that) but the data section shrinks
for SLAB. So we have additional 1.6k for SLUB. I guess this is
acceptable.

   text    data     bss     dec     hex filename
8427489  887684 3186688 12501861         bec365 mmotm/vmlinux.slab
8429060  883588 3186688 12499336         beb988 page_cgroup/vmlinux.slab

8438894  883428 3186688 12509010         bedf52 mmotm/vmlinux.slub
8440529  883428 3186688 12510645         bee5b5 page_cgroup/vmlinux.slub

So to me it sounds like the savings for 64b are worth minor inconvenience
for 32b which is clearly on decline and I would definitely not encourage
people to use PAE kernels with a lot of memory where the difference
might matter. For the most x86 32b deployments (laptops with 4G) the
difference shouldn't be noticeable. I am not familiar with other archs
so the situation might be different there.

If this would be a problem for some reason, though, we can reintroduce
the external page descriptor and translation layer conditionally
depending on the arch. It seems there will be some users of the external
descriptors anyway so a struct page_external can hold memcg pointer as
well.

This should probably go into the changelog, I guess.
-- 
Michal Hocko
SUSE Labs
