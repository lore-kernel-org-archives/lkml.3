Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754204Ab3G3R1t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 13:27:49 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:44183 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957Ab3G3R1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 13:27:48 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        David Gibson <david@gibson.dropbear.id.au>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Joonsoo Kim <js1304@gmail.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Hillf Danton <dhillf@gmail.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: Re: [PATCH 03/18] mm, hugetlb: unify region structure handling
In-Reply-To: <1375075929-6119-4-git-send-email-iamjoonsoo.kim@lge.com>
References: <1375075929-6119-1-git-send-email-iamjoonsoo.kim@lge.com> <1375075929-6119-4-git-send-email-iamjoonsoo.kim@lge.com>
User-Agent: Notmuch/0.15.2+167~g5306b2b (http://notmuchmail.org) Emacs/24.3.50.1 (x86_64-unknown-linux-gnu)
Date: Tue, 30 Jul 2013 22:57:37 +0530
Message-ID: <87wqo8ot4m.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13073017-9264-0000-0000-0000043B4140
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joonsoo Kim <iamjoonsoo.kim@lge.com> writes:

> Currently, to track a reserved and allocated region, we use two different
> ways for MAP_SHARED and MAP_PRIVATE. For MAP_SHARED, we use
> address_mapping's private_list and, for MAP_PRIVATE, we use a resv_map.
> Now, we are preparing to change a coarse grained lock which protect
> a region structure to fine grained lock, and this difference hinder it.
> So, before changing it, unify region structure handling.
>
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
>
> diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
> index a3f868a..a1ae3ada 100644
> --- a/fs/hugetlbfs/inode.c
> +++ b/fs/hugetlbfs/inode.c
> @@ -366,7 +366,12 @@ static void truncate_hugepages(struct inode *inode, loff_t lstart)
>
>  static void hugetlbfs_evict_inode(struct inode *inode)
>  {
> +	struct resv_map *resv_map;
> +
>  	truncate_hugepages(inode, 0);
> +	resv_map = (struct resv_map *)inode->i_mapping->private_data;
> +	if (resv_map)

can resv_map == NULL ?


> +		kref_put(&resv_map->refs, resv_map_release);

Also the kref_put is confusing. For shared mapping we don't have ref
count incremented right ? So may be you can directly call
resv_map_release or add a comment around explaining this more ?


>  	clear_inode(inode);
>  }
>
> @@ -468,6 +473,11 @@ static struct inode *hugetlbfs_get_inode(struct super_block *sb,
>  					umode_t mode, dev_t dev)
>  {
>  	struct inode *inode;
> +	struct resv_map *resv_map;
> +
> +	resv_map = resv_map_alloc();
> +	if (!resv_map)
> +		return NULL;

-aneesh

