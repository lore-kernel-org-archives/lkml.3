Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751607Ab3HUKh6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 06:37:58 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:49206 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232Ab3HUKh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 06:37:57 -0400
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
Subject: Re: [PATCH v2 11/20] mm, hugetlb: make vma_resv_map() works for all mapping type
In-Reply-To: <1376040398-11212-12-git-send-email-iamjoonsoo.kim@lge.com>
References: <1376040398-11212-1-git-send-email-iamjoonsoo.kim@lge.com> <1376040398-11212-12-git-send-email-iamjoonsoo.kim@lge.com>
User-Agent: Notmuch/0.15.2+167~g5306b2b (http://notmuchmail.org) Emacs/24.3.50.1 (x86_64-unknown-linux-gnu)
Date: Wed, 21 Aug 2013 16:07:36 +0530
Message-ID: <878uzvgwi7.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13082110-9264-0000-0000-0000045DF0B6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joonsoo Kim <iamjoonsoo.kim@lge.com> writes:

> Util now, we get a resv_map by two ways according to each mapping type.
> This makes code dirty and unreadable. So unfiying it.
>
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
>
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 869c3e0..e6c0c77 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -421,13 +421,24 @@ void resv_map_release(struct kref *ref)
>  	kfree(resv_map);
>  }
>
> +static inline struct resv_map *inode_resv_map(struct inode *inode)
> +{
> +	return inode->i_mapping->private_data;
> +}

it would be nice to get have another function that will return resv_map
only if we have HPAGE_RESV_OWNER. So that we could use that in
hugetlb_vm_op_open/close. ? Otherwise 

Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>




> +
>  static struct resv_map *vma_resv_map(struct vm_area_struct *vma)
>  {
>  	VM_BUG_ON(!is_vm_hugetlb_page(vma));
> -	if (!(vma->vm_flags & VM_MAYSHARE))
> +	if (vma->vm_flags & VM_MAYSHARE) {
> +		struct address_space *mapping = vma->vm_file->f_mapping;
> +		struct inode *inode = mapping->host;
> +
> +		return inode_resv_map(inode);
> +
> +	} else {
>  		return (struct resv_map *)(get_vma_private_data(vma) &
>  							~HPAGE_RESV_MASK);
> -	return NULL;
> +	}
>  }
>
>  static void set_vma_resv_map(struct vm_area_struct *vma, struct resv_map *map)
> @@ -1107,44 +1118,31 @@ static void return_unused_surplus_pages(struct hstate *h,
>  static long vma_needs_reservation(struct hstate *h,
>  			struct vm_area_struct *vma, unsigned long addr)
>  {
> -	struct address_space *mapping = vma->vm_file->f_mapping;
> -	struct inode *inode = mapping->host;
> -
> -	if (vma->vm_flags & VM_MAYSHARE) {
> -		pgoff_t idx = vma_hugecache_offset(h, vma, addr);
> -		struct resv_map *resv = inode->i_mapping->private_data;
> -
> -		return region_chg(&resv->regions, idx, idx + 1);
> +	struct resv_map *resv;
> +	pgoff_t idx;
> +	long chg;
>
> -	} else if (!is_vma_resv_set(vma, HPAGE_RESV_OWNER)) {
> +	resv = vma_resv_map(vma);
> +	if (!resv)
>  		return 1;
>
> -	} else  {
> -		long err;
> -		pgoff_t idx = vma_hugecache_offset(h, vma, addr);
> -		struct resv_map *resv = vma_resv_map(vma);
> +	idx = vma_hugecache_offset(h, vma, addr);
> +	chg = region_chg(resv, idx, idx + 1);
>
> -		err = region_chg(resv, idx, idx + 1);
> -		if (err < 0)
> -			return err;
> -		return 0;
> -	}
> +	if (vma->vm_flags & VM_MAYSHARE)
> +		return chg;
> +	else
> +		return chg < 0 ? chg : 0;
>  }
>  static void vma_commit_reservation(struct hstate *h,
>  			struct vm_area_struct *vma, unsigned long addr)
>  {
> -	struct address_space *mapping = vma->vm_file->f_mapping;
> -	struct inode *inode = mapping->host;
> -
> -	if (vma->vm_flags & VM_MAYSHARE) {
> -		pgoff_t idx = vma_hugecache_offset(h, vma, addr);
> -		struct resv_map *resv = inode->i_mapping->private_data;
> -
> -		region_add(&resv->regions, idx, idx + 1);
> +	struct resv_map *resv;
> +	pgoff_t idx;
>
> -	} else if (is_vma_resv_set(vma, HPAGE_RESV_OWNER)) {
> -		pgoff_t idx = vma_hugecache_offset(h, vma, addr);
> -		struct resv_map *resv = vma_resv_map(vma);
> +	resv = vma_resv_map(vma);
> +	if (!resv)
> +		return;
>
>  	idx = vma_hugecache_offset(h, vma, addr);
>  	region_add(resv, idx, idx + 1);
> @@ -2208,7 +2206,7 @@ static void hugetlb_vm_op_open(struct vm_area_struct *vma)
>  	 * after this open call completes.  It is therefore safe to take a
>  	 * new reference here without additional locking.
>  	 */
> -	if (resv)
> +	if (resv && is_vma_resv_set(vma, HPAGE_RESV_OWNER))
>  		kref_get(&resv->refs);
>  }
>
> @@ -2221,7 +2219,10 @@ static void hugetlb_vm_op_close(struct vm_area_struct *vma)
>  	unsigned long start;
>  	unsigned long end;
>
> -	if (resv) {
> +	if (!resv)
> +		return;
> +
> +	if (is_vma_resv_set(vma, HPAGE_RESV_OWNER)) {
>  		start = vma_hugecache_offset(h, vma, vma->vm_start);
>  		end = vma_hugecache_offset(h, vma, vma->vm_end);
>
> @@ -3104,7 +3105,7 @@ int hugetlb_reserve_pages(struct inode *inode,
>  	 * called to make the mapping read-write. Assume !vma is a shm mapping
>  	 */
>  	if (!vma || vma->vm_flags & VM_MAYSHARE) {
> -		resv_map = inode->i_mapping->private_data;
> +		resv_map = inode_resv_map(inode);
>
>  		chg = region_chg(resv_map, from, to);
>
> @@ -3163,7 +3164,7 @@ out_err:
>  void hugetlb_unreserve_pages(struct inode *inode, long offset, long freed)
>  {
>  	struct hstate *h = hstate_inode(inode);
> -	struct resv_map *resv_map = inode->i_mapping->private_data;
> +	struct resv_map *resv_map = inode_resv_map(inode);
>  	long chg = 0;
>  	struct hugepage_subpool *spool = subpool_inode(inode);
>
> -- 
> 1.7.9.5

