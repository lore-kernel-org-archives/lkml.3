Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932264Ab3GOOsp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 10:48:45 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:45765 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757662Ab3GOOso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 10:48:44 -0400
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
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: Re: [PATCH 7/9] mm, hugetlb: add VM_NORESERVE check in vma_has_reserves()
In-Reply-To: <1373881967-16153-8-git-send-email-iamjoonsoo.kim@lge.com>
References: <1373881967-16153-1-git-send-email-iamjoonsoo.kim@lge.com> <1373881967-16153-8-git-send-email-iamjoonsoo.kim@lge.com>
User-Agent: Notmuch/0.15.2+167~g5306b2b (http://notmuchmail.org) Emacs/24.3.50.1 (x86_64-unknown-linux-gnu)
Date: Mon, 15 Jul 2013 20:18:30 +0530
Message-ID: <87sizfj2v5.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13071514-7014-0000-0000-00000351D7BF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joonsoo Kim <iamjoonsoo.kim@lge.com> writes:

> If we map the region with MAP_NORESERVE and MAP_SHARED,
> we can skip to check reserve counting and eventually we cannot be ensured
> to allocate a huge page in fault time.
> With following example code, you can easily find this situation.
>
> Assume 2MB, nr_hugepages = 100
>
>         fd = hugetlbfs_unlinked_fd();
>         if (fd < 0)
>                 return 1;
>
>         size = 200 * MB;
>         flag = MAP_SHARED;
>         p = mmap(NULL, size, PROT_READ|PROT_WRITE, flag, fd, 0);
>         if (p == MAP_FAILED) {
>                 fprintf(stderr, "mmap() failed: %s\n", strerror(errno));
>                 return -1;
>         }
>
>         size = 2 * MB;
>         flag = MAP_ANONYMOUS | MAP_SHARED | MAP_HUGETLB | MAP_NORESERVE;
>         p = mmap(NULL, size, PROT_READ|PROT_WRITE, flag, -1, 0);
>         if (p == MAP_FAILED) {
>                 fprintf(stderr, "mmap() failed: %s\n", strerror(errno));
>         }
>         p[0] = '0';
>         sleep(10);
>
> During executing sleep(10), run 'cat /proc/meminfo' on another process.
> You'll find a mentioned problem.
>
> Solution is simple. We should check VM_NORESERVE in vma_has_reserves().
> This prevent to use a pre-allocated huge page if free count is under
> the reserve count.
>
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

May be it is better to say
"non reserved shared mapping should not eat into reserve space. So
return error when we don't find enough free space."


>
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 6c1eb9b..f6a7a4e 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -464,6 +464,8 @@ void reset_vma_resv_huge_pages(struct vm_area_struct *vma)
>  /* Returns true if the VMA has associated reserve pages */
>  static int vma_has_reserves(struct vm_area_struct *vma)
>  {
> +	if (vma->vm_flags & VM_NORESERVE)
> +		return 0;
>  	if (vma->vm_flags & VM_MAYSHARE)
>  		return 1;
>  	if (is_vma_resv_set(vma, HPAGE_RESV_OWNER))
> -- 
> 1.7.9.5

