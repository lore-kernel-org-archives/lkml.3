Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751483AbaI2HoW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 03:44:22 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:35726 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911AbaI2HoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 03:44:21 -0400
X-Original-SENDERIP: 10.177.222.183
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
Date: Mon, 29 Sep 2014 16:44:18 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Jeremiah Mahler <jmmahler@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION] [PATCH 1/3] mm/slab: use percpu allocator for cpu
 cache
Message-ID: <20140929074418.GA29310@js1304-P5Q-DELUXE>
References: <1408608675-20420-1-git-send-email-iamjoonsoo.kim@lge.com>
 <20140928062449.GA1277@hudson.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140928062449.GA1277@hudson.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 27, 2014 at 11:24:49PM -0700, Jeremiah Mahler wrote:
> On Thu, Aug 21, 2014 at 05:11:13PM +0900, Joonsoo Kim wrote:
> > Because of chicken and egg problem, initializaion of SLAB is really
> > complicated. We need to allocate cpu cache through SLAB to make
> > the kmem_cache works, but, before initialization of kmem_cache,
> > allocation through SLAB is impossible.
> > 
> > On the other hand, SLUB does initialization with more simple way. It
> > uses percpu allocator to allocate cpu cache so there is no chicken and
> > egg problem.
> > 
> > So, this patch try to use percpu allocator in SLAB. This simplify
> > initialization step in SLAB so that we could maintain SLAB code more
> > easily.
> > 
> > From my testing, there is no performance difference.
> > 
> > Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> 
> I just encountered a problem on a Lenovo Carbon X1 where it will
> suspend but won't resume.  A bisect indicated that this patch
> is causing the problem.
> 
> 997888488ef92da365b870247de773255227ce1f
> 
> I imagine the patch author, Joonsoo Kim, might have a better idea
> why this is happening than I do.  But if I can provide any information
> or run any tests that might be of help just let me know.

Hello,

Yeah, there is a bug. Below will fix your issue.
Could you test it and report the result?

Thanks for reporting it.

--------->8---------------
>From e03ed6cc554e038b86d7b3a72b89d94e9ea808ba Mon Sep 17 00:00:00 2001
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Date: Mon, 29 Sep 2014 16:30:43 +0900
Subject: [PATCH] mm/slab: fix cpu on/off handling

When cpu off, we flush all cpu cached objects to it's own slab.
free_block() is used for this purpose and it's role is just to flush
objects from array_cache to proper slab. It doesn't adjust array_cache's
internal fields so we should manually reset them to proper value.
Without this fix, we maintain free objects duplicately, one is in
cpu cache, and, the other one is in the slab. So system would be broken.

Reported-by: Jeremiah Mahler <jmmahler@gmail.com>
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
---
 mm/slab.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/slab.c b/mm/slab.c
index 1162f0e..ce289b4 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -1102,8 +1102,10 @@ static void cpuup_canceled(long cpu)
 
 		/* cpu is dead; no one can alloc from it. */
 		nc = per_cpu_ptr(cachep->cpu_cache, cpu);
-		if (nc)
+		if (nc) {
 			free_block(cachep, nc->entry, nc->avail, node, &list);
+			nc->avail = 0;
+		}
 
 		if (!cpumask_empty(mask)) {
 			spin_unlock_irq(&n->list_lock);
-- 
1.7.9.5

