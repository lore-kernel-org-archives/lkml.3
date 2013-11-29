Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752033Ab3K2XqW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 18:46:22 -0500
Received: from mail-yh0-f50.google.com ([209.85.213.50]:64840 "EHLO
	mail-yh0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008Ab3K2XqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 18:46:19 -0500
Date: Fri, 29 Nov 2013 15:46:16 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Michal Hocko <mhocko@suse.cz>
cc: Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch] mm: memcg: do not declare OOM from __GFP_NOFAIL
 allocations
In-Reply-To: <20131128102049.GF2761@dhcp22.suse.cz>
Message-ID: <alpine.DEB.2.02.1311291543400.22413@chino.kir.corp.google.com>
References: <1385140676-5677-1-git-send-email-hannes@cmpxchg.org> <alpine.DEB.2.02.1311261658170.21003@chino.kir.corp.google.com> <alpine.DEB.2.02.1311261931210.5973@chino.kir.corp.google.com> <20131127163916.GB3556@cmpxchg.org>
 <alpine.DEB.2.02.1311271336220.9222@chino.kir.corp.google.com> <20131127225340.GE3556@cmpxchg.org> <alpine.DEB.2.02.1311271526080.22848@chino.kir.corp.google.com> <20131128102049.GF2761@dhcp22.suse.cz>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Nov 2013, Michal Hocko wrote:

> > Ok, so let's forget about GFP_KERNEL | __GFP_NOFAIL since anything doing 
> > __GFP_FS should not be holding such locks, we have some of those in the 
> > drivers code and that makes sense that they are doing GFP_KERNEL.
> > 
> > Focusing on the GFP_NOFS | __GFP_NOFAIL allocations in the filesystem 
> > code, the kernel oom killer independent of memcg never gets called because 
> > !__GFP_FS and they'll simply loop around the page allocator forever.
> > 
> > In the past, Andrew has expressed the desire to get rid of __GFP_NOFAIL 
> > entirely since it's flawed when combined with GFP_NOFS (and GFP_KERNEL | 
> > __GFP_NOFAIL could simply be reimplemented in the caller) because of the 
> > reason you point out in addition to making it very difficult in the page 
> > allocator to free memory independent of memcg.
> > 
> > So I'm wondering if we should just disable the oom killer in memcg for 
> > __GFP_NOFAIL as you've done here, but not bypass to the root memcg and 
> > just allow them to spin?  I think we should be focused on the fixing the 
> > callers rather than breaking memcg isolation.
> 
> What if the callers simply cannot deal with the allocation failure?
> 84235de394d97 (fs: buffer: move allocation failure loop into the
> allocator) describes one such case when __getblk_slow tries desperately
> to grow buffers relying on the reclaim to free something. As there might
> be no reclaim going on we are screwed.
> 

My suggestion is to spin, not return NULL.  Bypassing to the root memcg 
can lead to a system oom condition whereas if memcg weren't involved at 
all the page allocator would just spin (because of !__GFP_FS).

> That being said, while I do agree with you that we should strive for
> isolation as much as possible there are certain cases when this is
> impossible to achieve without seeing much worse consequences. For now,
> we hope that __GFP_NOFAIL is used very scarcely.

If that's true, why not bypass the per-zone min watermarks in the page 
allocator as well to allow these allocations to succeed?
