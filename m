Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759271Ab3D3BDa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 21:03:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43218 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757677Ab3D3BD2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 21:03:28 -0400
Date: Mon, 29 Apr 2013 21:03:08 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Cliff Wickman <cpw@sgi.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mgorman@suse.de,
        paul.mundt@nokia.com, dhowells@redhat.com, aarcange@redhat.com,
        hughd@google.com, gorcunov@openvz.org, kamezawa.hiroyuki@gmail.com,
        eag0628@gmail.com, khlebnikov@openvz.org, sasha.levin@oracle.com,
        siddhesh.poyarekar@gmail.com, rientjes@google.com,
        kirill.shutemov@linux.intel.com, viro@ZenIV.linux.org.uk,
        amwang@redhat.com
Message-ID: <1367283788-6nb3mvy8-mutt-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <E1UWva5-0005fY-Km@eag09.americas.sgi.com>
References: <E1UWva5-0005fY-Km@eag09.americas.sgi.com>
Subject: Re: [PATCH] fs/proc: smaps should avoid VM_PFNMAP areas
Mime-Version: 1.0
Content-Type: text/plain;
 charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Mutt-References: <E1UWva5-0005fY-Km@eag09.americas.sgi.com>
X-Mutt-Fcc: ~/Maildir/sent/
User-Agent: Mutt 1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Cliff,

On Mon, Apr 29, 2013 at 04:25:53PM -0500, Cliff Wickman wrote:
> 
> /proc/<pid>/smaps should not be looking at VM_PFNMAP areas.
> 
> Certain tests in show_smap() (especially for huge pages) assume that the
> mapped PFN's are backed with page structures.  And this is not usually true
> for VM_PFNMAP areas.  This can result in panics on kernel page faults when
> attempting to address those page structures.

I think it's strange that you mention to hugepages, because in my understanding
VM_PFNMAP and hugepage related vma (VM_HUGEPAGE or VM_HUGETLB) should not set
at the same time. In what testcase are these flags both set?

And I guess this race can also happen on reading pagemap or numa_maps because
walk_page_range() is called in those code paths. Are you sure the race doesn't
happen on these paths? If not, please add a few more flag checks for them.

Thanks,
Naoya Horiguchi

> VM_PFNMAP areas are used by
> - graphics memory manager   gpu/drm/drm_gem.c
> - global reference unit     sgi-gru/grufile.c
> - sgi special memory        char/mspec.c
> - probably several out-of-tree modules
> 
> I'm copying everyone who has changed fs/proc/task_mmu.c recently, in case
> of some reason to provide /proc/<pid>/smaps for these areas that I am not
> aware of.
> 
> Signed-off-by: Cliff Wickman <cpw@sgi.com>
> ---
>  fs/proc/task_mmu.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> Index: linux/fs/proc/task_mmu.c
> ===================================================================
> --- linux.orig/fs/proc/task_mmu.c
> +++ linux/fs/proc/task_mmu.c
> @@ -589,6 +589,9 @@ static int show_smap(struct seq_file *m,
>  		.private = &mss,
>  	};
>  
> +	if (vma->vm_flags & VM_PFNMAP)
> +		return 0;
> +
>  	memset(&mss, 0, sizeof mss);
>  	mss.vma = vma;
>  	/* mmap_sem is held in m_start */
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
