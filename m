Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756074Ab3H2Jpd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 05:45:33 -0400
Received: from merlin.infradead.org ([205.233.59.134]:60124 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753409Ab3H2Jpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 05:45:32 -0400
Date: Thu, 29 Aug 2013 11:45:25 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Miao Xie <miaox@cn.fujitsu.com>,
        David Rientjes <rientjes@google.com>, Christoph Lameter <cl@linux.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org, riel@redhat.com
Subject: Re: [PATCH] cpuset: mm: Reduce large amounts of memory barrier
 related damage v3
Message-ID: <20130829094525.GY10002@twins.programming.kicks-ass.net>
References: <20120307180852.GE17697@suse.de>
 <20130823130332.GY31370@twins.programming.kicks-ass.net>
 <20130823181546.GA31370@twins.programming.kicks-ass.net>
 <20130829092828.GB22421@suse.de>
 <20130829094342.GX10002@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130829094342.GX10002@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 29, 2013 at 11:43:42AM +0200, Peter Zijlstra wrote:
> > diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> > index 7431001..ae880c3 100644
> > --- a/mm/mempolicy.c
> > +++ b/mm/mempolicy.c
> > @@ -1755,22 +1755,24 @@ unsigned slab_node(void)
> >  }
> >  
> >  /* Do static interleaving for a VMA with known offset. */
> > -static unsigned offset_il_node(struct mempolicy *pol,
> > +static unsigned int offset_il_node(struct mempolicy *pol,
> >  		struct vm_area_struct *vma, unsigned long off)
> >  {
> > -	unsigned nnodes = nodes_weight(pol->v.nodes);
> > -	unsigned target;
> > -	int c;
> > -	int nid = -1;
> > +	unsigned int nr_nodes, target;
> > +	int i, nid;
> >  
> > -	if (!nnodes)
> > +again:
> > +	nr_nodes = nodes_weight(pol->v.nodes);
> > +	if (!nr_nodes)
> >  		return numa_node_id();
> > -	target = (unsigned int)off % nnodes;
> > -	c = 0;
> > -	do {
> > +	target = (unsigned int)off % nr_nodes;
> > +	for (i = 0, nid = first_node(pol->v.nodes); i < target; i++)
> >  		nid = next_node(nid, pol->v.nodes);
> > -		c++;
> > -	} while (c <= target);
> > +
> > +	/* Policy nodemask can potentially update in parallel */
> > +	if (unlikely(!node_isset(nid, pol->v.nodes)))
> > +		goto again;
> > +
> >  	return nid;
> >  }
> 
> So I explicitly didn't use the node_isset() test because that's more
> likely to trigger than the nid >= MAX_NUMNODES test. Its fine to return
> a node that isn't actually part of the mask anymore -- a race is a race
> anyway.

Oh more importantly, if nid does indeed end up being >= MAX_NUMNODES as
is possible with next_node() the node_isset() test will be out-of-bounds
and can crash itself.
