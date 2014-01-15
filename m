Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751524AbaAOFRO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 00:17:14 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:54175 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751047AbaAOFRM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 00:17:12 -0500
X-AuditID: 9c930179-b7c84ae000000e38-40-52d619d6fe91
Date: Wed, 15 Jan 2014 14:17:58 +0900
From: Minchan Kim <minchan@kernel.org>
To: Weijie Yang <weijie.yang.kh@gmail.com>
Cc: Bob Liu <bob.liu@oracle.com>, Cai Liu <cai.liu@samsung.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux-Kernel <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>, liucai.lfn@gmail.com
Subject: Re: [PATCH] mm/zswap: Check all pool pages instead of one pool pages
Message-ID: <20140115051758.GK1992@bbox>
References: <000101cf0ea0$f4e7c560$deb75020$@samsung.com>
 <20140113233505.GS1992@bbox>
 <52D4909B.7070107@oracle.com>
 <20140114045022.GZ1992@bbox>
 <20140114050528.GA1992@bbox>
 <52D4CE4C.1030809@oracle.com>
 <CAL1ERfMYXuQ48BEi=5pFCbDjAJ75RRRmnUGEanhWpxYh9RgZOQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL1ERfMYXuQ48BEi=5pFCbDjAJ75RRRmnUGEanhWpxYh9RgZOQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 14, 2014 at 02:15:44PM +0800, Weijie Yang wrote:
> On Tue, Jan 14, 2014 at 1:42 PM, Bob Liu <bob.liu@oracle.com> wrote:
> >
> > On 01/14/2014 01:05 PM, Minchan Kim wrote:
> >> On Tue, Jan 14, 2014 at 01:50:22PM +0900, Minchan Kim wrote:
> >>> Hello Bob,
> >>>
> >>> On Tue, Jan 14, 2014 at 09:19:23AM +0800, Bob Liu wrote:
> >>>>
> >>>> On 01/14/2014 07:35 AM, Minchan Kim wrote:
> >>>>> Hello,
> >>>>>
> >>>>> On Sat, Jan 11, 2014 at 03:43:07PM +0800, Cai Liu wrote:
> >>>>>> zswap can support multiple swapfiles. So we need to check
> >>>>>> all zbud pool pages in zswap.
> >>>>>
> >>>>> True but this patch is rather costly that we should iterate
> >>>>> zswap_tree[MAX_SWAPFILES] to check it. SIGH.
> >>>>>
> >>>>> How about defining zswap_tress as linked list instead of static
> >>>>> array? Then, we could reduce unnecessary iteration too much.
> >>>>>
> >>>>
> >>>> But if use linked list, it might not easy to access the tree like this:
> >>>> struct zswap_tree *tree = zswap_trees[type];
> >>>
> >>> struct zswap_tree {
> >>>     ..
> >>>     ..
> >>>     struct list_head list;
> >>> }
> >>>
> >>> zswap_frontswap_init()
> >>> {
> >>>     ..
> >>>     ..
> >>>     zswap_trees[type] = tree;
> >>>     list_add(&tree->list, &zswap_list);
> >>> }
> >>>
> >>> get_zswap_pool_pages(void)
> >>> {
> >>>     struct zswap_tree *cur;
> >>>     list_for_each_entry(cur, &zswap_list, list) {
> >>>         pool_pages += zbud_get_pool_size(cur->pool);
> >>>     }
> >>>     return pool_pages;
> >>> }
> >
> > Okay, I see your point. Yes, it's much better.
> > Cai, Please make an new patch.
> 
> This improved patch could reduce unnecessary iteration too much.
> 
> But I still have a question: why do we need so many zbud pools?
> How about use only one global zbud pool for all zswap_tree?
> I do not test it, but I think it can improve the strore density.

Just a quick glance,

I don't know how multiple swap configuration is popular?
With your approach, what kinds of change do we need in frontswap_invalidate_area?
You will add encoded *type* in offset of entry?
So we always should decode it when we need search opeartion?
We lose speed but get a density(? but not sure because it's dependent on workload)
for rare configuration(ie, multiple swap) and rare event(ie, swapoff).
It's just popped question, not strong objection.
Anyway, point is that you can try it if you want and then, report the number. :)

Thanks.

> 
> Just for your reference, Thanks!
> 
-- 
Kind regards,
Minchan Kim
