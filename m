Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751513Ab3LLLOg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 06:14:36 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55700 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751371Ab3LLLOe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 06:14:34 -0500
Date: Thu, 12 Dec 2013 12:14:29 +0100
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jan Kara <jack@suse.cz>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        David Cohen <david.a.cohen@linux.intel.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Damien Ramonda <damien.ramonda@intel.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH RFC] mm readahead: Fix the readahead fail in case of
 empty numa node
Message-ID: <20131212111429.GA4312@quack.suse.cz>
References: <1386066977-17368-1-git-send-email-raghavendra.kt@linux.vnet.ibm.com>
 <20131203143841.11b71e387dc1db3a8ab0974c@linux-foundation.org>
 <529EE811.5050306@linux.vnet.ibm.com>
 <20131204004125.a06f7dfc.akpm@linux-foundation.org>
 <529EF0FB.2050808@linux.vnet.ibm.com>
 <20131204134838.a048880a1db9e9acd14a39e4@linux-foundation.org>
 <20131211224917.GF1163@quack.suse.cz>
 <20131211150522.4b853323e8b82f342f81b64d@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131211150522.4b853323e8b82f342f81b64d@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 11-12-13 15:05:22, Andrew Morton wrote:
> On Wed, 11 Dec 2013 23:49:17 +0100 Jan Kara <jack@suse.cz> wrote:
> 
> > >  /*
> > > - * Given a desired number of PAGE_CACHE_SIZE readahead pages, return a
> > > - * sensible upper limit.
> > > + * max_sane_readahead() is disabled.  It can later be removed altogether, but
> > > + * let's keep a skeleton in place for now, in case disabling was the wrong call.
> > >   */
> > >  unsigned long max_sane_readahead(unsigned long nr)
> > >  {
> > > -	return min(nr, (node_page_state(numa_node_id(), NR_INACTIVE_FILE)
> > > -		+ node_page_state(numa_node_id(), NR_FREE_PAGES)) / 2);
> > > +	return nr;
> > >  }
> > >  
> > >  /*
> > > 
> > > Can anyone see a problem with this?
> >   Well, the downside seems to be that if userspace previously issued
> > MADV/FADV_WILLNEED on a huge file, we trimmed the request to a sensible
> > size. Now we try to read the whole huge file which is pretty much
> > guaranteed to be useless (as we'll be pushing out of cache data we just
> > read a while ago). And guessing the right readahead size from userspace
> > isn't trivial so it would make WILLNEED advice less useful. What do you
> > think?
> 
> OK, yes, there is conceivably a back-compatibility issue there.  There
> indeed might be applications which decide the chuck the whole thing at
> the kernel and let the kernel work out what is a sensible readahead
> size to perform.
>
> But I'm really struggling to think up an implementation!  The current
> code looks only at the caller's node and doesn't seem to make much
> sense.  Should we look at all nodes?  Hard to say without prior
> knowledge of where those pages will be coming from.
  Well, I believe that we might have some compatibility issues only for
non-NUMA machines - there the current logic makes sense. For NUMA machines
I believe we are free to do basically anything because results of the
current logic are pretty random.

Thinking about proper implementation for NUMA - max_sane_readahead() is
really interesting for madvise() and fadvise() calls (standard on demand
readahead is bounded by bdi->ra_pages which tends to be pretty low anyway
(like 512K or so)). For these calls we will do the reads from the process
issuing the [fm]advise() call and thus we will allocate pages depending on
the NUMA policy. So depending on this policy we should be able to pick some
estimate on the number of available pages, shouldn't we?

BTW, the fact that [fm]advise() calls submit all reads synchronously is
another reason why we should bound the readahead requests to a sensible
size.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
