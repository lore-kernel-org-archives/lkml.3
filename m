Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758879Ab3GaCgQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 22:36:16 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:56611 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428Ab3GaCgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 22:36:14 -0400
X-AuditID: 9c93017e-b7b62ae000000eeb-f8-51f8781d9fce
Date: Wed, 31 Jul 2013 11:36:13 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        David Gibson <david@gibson.dropbear.id.au>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Hillf Danton <dhillf@gmail.com>
Subject: Re: [PATCH 03/18] mm, hugetlb: unify region structure handling
Message-ID: <20130731023613.GB2548@lge.com>
References: <1375075929-6119-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1375075929-6119-4-git-send-email-iamjoonsoo.kim@lge.com>
 <87wqo8ot4m.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87wqo8ot4m.fsf@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 30, 2013 at 10:57:37PM +0530, Aneesh Kumar K.V wrote:
> Joonsoo Kim <iamjoonsoo.kim@lge.com> writes:
> 
> > Currently, to track a reserved and allocated region, we use two different
> > ways for MAP_SHARED and MAP_PRIVATE. For MAP_SHARED, we use
> > address_mapping's private_list and, for MAP_PRIVATE, we use a resv_map.
> > Now, we are preparing to change a coarse grained lock which protect
> > a region structure to fine grained lock, and this difference hinder it.
> > So, before changing it, unify region structure handling.
> >
> > Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> >
> > diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
> > index a3f868a..a1ae3ada 100644
> > --- a/fs/hugetlbfs/inode.c
> > +++ b/fs/hugetlbfs/inode.c
> > @@ -366,7 +366,12 @@ static void truncate_hugepages(struct inode *inode, loff_t lstart)
> >
> >  static void hugetlbfs_evict_inode(struct inode *inode)
> >  {
> > +	struct resv_map *resv_map;
> > +
> >  	truncate_hugepages(inode, 0);
> > +	resv_map = (struct resv_map *)inode->i_mapping->private_data;
> > +	if (resv_map)
> 
> can resv_map == NULL ?

Hello, Aneesh.

Yes, it can.
root inode which is allocated in hugetlbfs_get_root() doesn't allocate a resv_map.

> 
> 
> > +		kref_put(&resv_map->refs, resv_map_release);
> 
> Also the kref_put is confusing. For shared mapping we don't have ref
> count incremented right ? So may be you can directly call
> resv_map_release or add a comment around explaining this more ?

Yes, I can call resv_map_release() directly, but I think that release
via reference management is better than it.

Thanks.

> 
> 
> >  	clear_inode(inode);
> >  }
> >
> > @@ -468,6 +473,11 @@ static struct inode *hugetlbfs_get_inode(struct super_block *sb,
> >  					umode_t mode, dev_t dev)
> >  {
> >  	struct inode *inode;
> > +	struct resv_map *resv_map;
> > +
> > +	resv_map = resv_map_alloc();
> > +	if (!resv_map)
> > +		return NULL;
> 
> -aneesh
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
