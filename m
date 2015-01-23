Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753719AbbAWGgK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 01:36:10 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:47575 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752027AbbAWGgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 01:36:08 -0500
X-Original-SENDERIP: 10.177.222.153
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
Date: Fri, 23 Jan 2015 15:37:10 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: linux-kernel@vger.kernel.org, m.szyprowski@samsung.com,
        akpm@linux-foundation.org, lauraa@codeaurora.org
Subject: Re: [PATCH 2/3] mm: cma: allocation trigger
Message-ID: <20150123063710.GC809@js1304-P5Q-DELUXE>
References: <1421775513-4460-1-git-send-email-sasha.levin@oracle.com>
 <1421775513-4460-3-git-send-email-sasha.levin@oracle.com>
 <20150122082628.GH21444@js1304-P5Q-DELUXE>
 <54C1B679.5030000@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54C1B679.5030000@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 22, 2015 at 09:48:25PM -0500, Sasha Levin wrote:
> On 01/22/2015 03:26 AM, Joonsoo Kim wrote:
> > On Tue, Jan 20, 2015 at 12:38:32PM -0500, Sasha Levin wrote:
> >> Provides a userspace interface to trigger a CMA allocation.
> >>
> >> Usage:
> >>
> >> 	echo [pages] > alloc
> >>
> >> This would provide testing/fuzzing access to the CMA allocation paths.
> >>
> >> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
> >> ---
> >>  mm/cma_debug.c |   58 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
> >>  1 file changed, 58 insertions(+)
> >>
> >> diff --git a/mm/cma_debug.c b/mm/cma_debug.c
> >> index 3a25413..eda0a41 100644
> >> --- a/mm/cma_debug.c
> >> +++ b/mm/cma_debug.c
> >> @@ -7,9 +7,22 @@
> >>  
> >>  #include <linux/debugfs.h>
> >>  #include <linux/cma.h>
> >> +#include <linux/list.h>
> >> +#include <linux/kernel.h>
> >> +#include <linux/dma-contiguous.h>
> >> +#include <linux/slab.h>
> >>  
> >>  #include "cma.h"
> >>  
> >> +struct cma_mem {
> >> +	struct hlist_node node;
> >> +	struct page *p;
> >> +	unsigned long n;
> >> +};
> >> +
> >> +static HLIST_HEAD(cma_mem_head);
> >> +static DEFINE_SPINLOCK(cma_mem_head_lock);
> >> +
> >>  static struct dentry *cma_debugfs_root;
> >>  
> >>  static int cma_debugfs_get(void *data, u64 *val)
> >> @@ -44,6 +57,48 @@ static void cma_debugfs_add_one(struct cma *cma, int idx)
> >>  	debugfs_create_u32_array("bitmap", S_IRUGO, tmp, (u32*)cma->bitmap, u32s);
> >>  }
> >>  
> >> +static void cma_add_to_cma_mem_list(struct cma_mem *mem)
> >> +{
> >> +	spin_lock(&cma_mem_head_lock);
> >> +	hlist_add_head(&mem->node, &cma_mem_head);
> >> +	spin_unlock(&cma_mem_head_lock);
> >> +}
> >> +
> >> +static int cma_alloc_mem(int count)
> >> +{
> >> +	struct cma_mem *mem;
> >> +	struct page *p;
> >> +
> >> +	mem = kzalloc(sizeof(*mem), GFP_KERNEL);
> >> +	if (!mem) 
> >> +		return -ENOMEM;
> >> +
> >> +	p = cma_alloc(dma_contiguous_default_area, count, CONFIG_CMA_ALIGNMENT);
> >> +	if (!p) {
> >> +		pr_info("CMA: Allocation failed.\n");
> >> +		kfree(mem);
> >> +		return -ENOMEM;
> >> +	}
> > 
> > Hello,
> > 
> > I'm glad to see this patchset. I had similar one privately. :)
> > Without this kind of facility, testing CMA is really hard.
> > 
> > Anyway, dma_contiguous_default_area is defined only in CONFIG_DMA_CMA.
> > So, it would cause build break.
> > 
> > And, I think that it is better for this tester to have an ability to
> > allocate pages on specific CMA reserved region. It could be easily
> > achieved by moving 'alloc' registration to cma_debugfs_add_one(). Is
> > there any reason not to do that?
> 
> Agreed, that would make more sense.
> 
> >> +
> >> +	pr_info("CMA: Allocated %d pages at %p\n", count, p);
> > 
> > I don't think this output is needed. If CONFIG_CMA_DEBUG is enabled,
> > cma_alloc() print similar output.
> 
> I didn't see any other output (and I have CONFIG_CMA_DEBUG set), which
> is why I've added this pr_info().

If you raise up your loglevel, you can see it.
That message is printed through pr_debug().

Thanks.
