Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755789Ab3HWSQB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 14:16:01 -0400
Received: from merlin.infradead.org ([205.233.59.134]:56787 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754540Ab3HWSP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 14:15:59 -0400
Date: Fri, 23 Aug 2013 20:15:46 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Miao Xie <miaox@cn.fujitsu.com>,
        David Rientjes <rientjes@google.com>, Christoph Lameter <cl@linux.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org, riel@redhat.com
Subject: Re: [PATCH] cpuset: mm: Reduce large amounts of memory barrier
 related damage v3
Message-ID: <20130823181546.GA31370@twins.programming.kicks-ass.net>
References: <20120307180852.GE17697@suse.de>
 <20130823130332.GY31370@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130823130332.GY31370@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 23, 2013 at 03:03:32PM +0200, Peter Zijlstra wrote:
> So I think this patch is broken (still). Suppose we have an
> INTERLEAVE mempol like 0x3 and change it to 0xc.
> 
> Original:	0x3
> Rebind Step 1:	0xf /* set bits */
> Rebind Step 2:	0xc /* clear bits */
> 
> Now look at what can happen with offset_il_node() when its ran
> concurrently with step 2:
> 
>   nnodes = nodes_weight(pol->v.nodes); /* observes 0xf and returns 4 */
> 
>   /* now we clear the actual bits */
>   
>   target = (unsigned int)off % nnodes; /* assume target >= 2 */
>   c = 0;
>   do {
>   	nid = next_node(nid, pol->v.nodes);
> 	c++;
>   } while (c <= target);
> 
>   /* here nid := MAX_NUMNODES */
> 
> 
> This nid is then blindly inserted into node_zonelist() which does an
> NODE_DATA() array access out of bounds and off we go.
> 
> This would suggest we put the whole seqcount thing inside
> offset_il_node().

Oh bloody grrr. Its not directly related at all, the patch in question
fixes a cpuset task_struct::mems_allowed problem while the above is a
mempolicy issue and of course the cpuset and mempolicy code are
completely bloody different :/

So I guess the quick and ugly solution is something like the below. 

--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1762,19 +1762,21 @@ unsigned slab_node(void)
 static unsigned offset_il_node(struct mempolicy *pol,
 		struct vm_area_struct *vma, unsigned long off)
 {
-	unsigned nnodes = nodes_weight(pol->v.nodes);
-	unsigned target;
-	int c;
-	int nid = -1;
+	unsigned nnodes, target;
+	int c, nid;
 
+again:
+	nnodes = nodes_weight(pol->v.nodes);
 	if (!nnodes)
 		return numa_node_id();
+
 	target = (unsigned int)off % nnodes;
-	c = 0;
-	do {
+	for (c = 0, nid = -1; c <= target; c++)
 		nid = next_node(nid, pol->v.nodes);
-		c++;
-	} while (c <= target);
+
+	if (unlikely((unsigned)nid >= MAX_NUMNODES))
+		goto again;
+
 	return nid;
 }
 
