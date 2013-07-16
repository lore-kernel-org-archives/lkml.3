Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758586Ab3GPCMq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 22:12:46 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:56766 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755434Ab3GPCMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 22:12:45 -0400
X-AuditID: 9c930197-b7bfbae000000e88-1d-51e4ac1b7a70
Date: Tue, 16 Jul 2013 11:12:45 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        David Gibson <david@gibson.dropbear.id.au>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/9] mm, hugetlb: add VM_NORESERVE check in
 vma_has_reserves()
Message-ID: <20130716021245.GI2430@lge.com>
References: <1373881967-16153-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1373881967-16153-8-git-send-email-iamjoonsoo.kim@lge.com>
 <87li57j1tb.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87li57j1tb.fsf@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 15, 2013 at 08:41:12PM +0530, Aneesh Kumar K.V wrote:
> Joonsoo Kim <iamjoonsoo.kim@lge.com> writes:
> 
> > If we map the region with MAP_NORESERVE and MAP_SHARED,
> > we can skip to check reserve counting and eventually we cannot be ensured
> > to allocate a huge page in fault time.
> > With following example code, you can easily find this situation.
> >
> > Assume 2MB, nr_hugepages = 100
> >
> >         fd = hugetlbfs_unlinked_fd();
> >         if (fd < 0)
> >                 return 1;
> >
> >         size = 200 * MB;
> >         flag = MAP_SHARED;
> >         p = mmap(NULL, size, PROT_READ|PROT_WRITE, flag, fd, 0);
> >         if (p == MAP_FAILED) {
> >                 fprintf(stderr, "mmap() failed: %s\n", strerror(errno));
> >                 return -1;
> >         }
> >
> >         size = 2 * MB;
> >         flag = MAP_ANONYMOUS | MAP_SHARED | MAP_HUGETLB | MAP_NORESERVE;
> >         p = mmap(NULL, size, PROT_READ|PROT_WRITE, flag, -1, 0);
> >         if (p == MAP_FAILED) {
> >                 fprintf(stderr, "mmap() failed: %s\n", strerror(errno));
> >         }
> >         p[0] = '0';
> >         sleep(10);
> >
> > During executing sleep(10), run 'cat /proc/meminfo' on another process.
> > You'll find a mentioned problem.
> >
> > Solution is simple. We should check VM_NORESERVE in vma_has_reserves().
> > This prevent to use a pre-allocated huge page if free count is under
> > the reserve count.
> 
> You have a problem with this patch, which i guess you are fixing in
> patch 9. Consider two process
> 
> a) MAP_SHARED  on fd
> b) MAP_SHARED | MAP_NORESERVE on fd
> 
> We should allow the (b) to access the page even if VM_NORESERVE is set
> and we are out of reserve space .

I can't get your point.
Please elaborate more on this.

Thanks.

> 
> so may be you should rearrange the patch ?
> 
> >
> > Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> >
> > diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> > index 6c1eb9b..f6a7a4e 100644
> > --- a/mm/hugetlb.c
> > +++ b/mm/hugetlb.c
> > @@ -464,6 +464,8 @@ void reset_vma_resv_huge_pages(struct vm_area_struct *vma)
> >  /* Returns true if the VMA has associated reserve pages */
> >  static int vma_has_reserves(struct vm_area_struct *vma)
> >  {
> > +	if (vma->vm_flags & VM_NORESERVE)
> > +		return 0;
> >  	if (vma->vm_flags & VM_MAYSHARE)
> >  		return 1;
> >  	if (is_vma_resv_set(vma, HPAGE_RESV_OWNER))
> > -- 
> > 1.7.9.5
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
