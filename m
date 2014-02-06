Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751703AbaBFXs0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 18:48:26 -0500
Received: from mail-pd0-f181.google.com ([209.85.192.181]:45580 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125AbaBFXsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 18:48:24 -0500
Date: Thu, 6 Feb 2014 15:48:22 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        David Cohen <david.a.cohen@linux.intel.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Damien Ramonda <damien.ramonda@intel.com>, Jan Kara <jack@suse.cz>,
        Linus <torvalds@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH V5] mm readahead: Fix readahead fail for no local
 memory and limit readahead pages
In-Reply-To: <20140206152219.45c2039e5092c8ea1c31fd38@linux-foundation.org>
Message-ID: <alpine.DEB.2.02.1402061537180.3441@chino.kir.corp.google.com>
References: <1390388025-1418-1-git-send-email-raghavendra.kt@linux.vnet.ibm.com> <20140206145105.27dec37b16f24e4ac5fd90ce@linux-foundation.org> <alpine.DEB.2.02.1402061456290.31828@chino.kir.corp.google.com>
 <20140206152219.45c2039e5092c8ea1c31fd38@linux-foundation.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Feb 2014, Andrew Morton wrote:

> On Thu, 6 Feb 2014 14:58:21 -0800 (PST) David Rientjes <rientjes@google.com> wrote:
> 
> > > > +#define MAX_REMOTE_READAHEAD   4096UL
> > > >  /*
> > > >   * Given a desired number of PAGE_CACHE_SIZE readahead pages, return a
> > > >   * sensible upper limit.
> > > >   */
> > > >  unsigned long max_sane_readahead(unsigned long nr)
> > > >  {
> > > > -	return min(nr, (node_page_state(numa_node_id(), NR_INACTIVE_FILE)
> > > > -		+ node_page_state(numa_node_id(), NR_FREE_PAGES)) / 2);
> > > > +	unsigned long local_free_page;
> > > > +	int nid;
> > > > +
> > > > +	nid = numa_node_id();
> > 
> > If you're intending this to be cached for your calls into 
> > node_page_state() you need nid = ACCESS_ONCE(numa_node_id()).
> 
> ugh.  That's too subtle and we didn't even document it.
> 
> We could put the ACCESS_ONCE inside numa_node_id() I assume but we
> still have the same problem as smp_processor_id(): the numa_node_id()
> return value is wrong as soon as you obtain it if running preemptibly. 
> 
> We could plaster Big Fat Warnings all over the place or we could treat
> numa_node_id() and derivatives in the same way as smp_processor_id()
> (which is a huge pain).  Or something else, but we've left a big hand
> grenade here and Raghavendra won't be the last one to pull the pin?
> 

Normally it wouldn't matter because there's no significant downside to it 
racing, things like mempolicies which use numa_node_id() extensively would 
result in, oops, a page allocation on the wrong node.

This stands out to me, though, because you're expecting the calculation to 
be correct for a specific node.

The patch is still wrong, though, it should just do

	int node = ACCESS_ONCE(numa_mem_id());
	return min(nr, (node_page_state(node, NR_INACTIVE_FILE) +
		        node_page_state(node, NR_FREE_PAGES)) / 2);

since we want to readahead based on the cpu's local node, the comment 
saying we're reading ahead onto "remote memory" is wrong since a 
memoryless node has local affinity to numa_mem_id().
