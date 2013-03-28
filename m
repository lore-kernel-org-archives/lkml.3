Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754387Ab3C1SaX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 14:30:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4870 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753093Ab3C1SaW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 14:30:22 -0400
Date: Thu, 28 Mar 2013 14:29:18 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Message-ID: <1364495358-2gnie765-mutt-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <515477D4.1060206@openvz.org>
References: <1364485358-8745-1-git-send-email-n-horiguchi@ah.jp.nec.com>
 <1364485358-8745-2-git-send-email-n-horiguchi@ah.jp.nec.com>
 <515477D4.1060206@openvz.org>
Subject: Re: [PATCH 1/2] hugetlbfs: stop setting VM_DONTDUMP in initializing
 vma(VM_HUGETLB)
Mime-Version: 1.0
Content-Type: text/plain;
 charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Mutt-References: <515477D4.1060206@openvz.org>
X-Mutt-Fcc: ~/Maildir/sent/
User-Agent: Mutt 1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 28, 2013 at 09:03:16PM +0400, Konstantin Khlebnikov wrote:
> Naoya Horiguchi wrote:
> >Currently we fail to include any data on hugepages into coredump,
> >because VM_DONTDUMP is set on hugetlbfs's vma. This behavior was recently
> >introduced by commit 314e51b98 "mm: kill vma flag VM_RESERVED and
> >mm->reserved_vm counter". This looks to me a serious regression,
> >so let's fix it.
> 
> That was introduced in my patch? Really?
> Here was VM_RESERVED and it had the same effect as VM_DONTDUMP. At least I thought so.

vma_dump_size() does like this (the diff is the one in 314e51b98):

   static unsigned long vma_dump_size(struct vm_area_struct *vma,
   				   unsigned long mm_flags)
   {
   #define FILTER(type)	(mm_flags & (1UL << MMF_DUMP_##type))
   
   	/* always dump the vdso and vsyscall sections */
   	if (always_dump_vma(vma))
   		goto whole;
  
  	if (vma->vm_flags & VM_DONTDUMP)
   		return 0;
   
   	/* Hugetlb memory check */
   	if (vma->vm_flags & VM_HUGETLB) {
   		if ((vma->vm_flags & VM_SHARED) && FILTER(HUGETLB_SHARED))
   			goto whole;
   		if (!(vma->vm_flags & VM_SHARED) && FILTER(HUGETLB_PRIVATE))
   			goto whole;
   	}
   
   	/* Do not dump I/O mapped devices or special mappings */
  -	if (vma->vm_flags & (VM_IO | VM_RESERVED))
  +	if (vma->vm_flags & VM_IO)
   		return 0;

We have hugetlb memory check after VM_DONTDUMP check, so the following
changed the behavior.

  --- a/fs/hugetlbfs/inode.c
  +++ b/fs/hugetlbfs/inode.c
  @@ -110,7 +110,7 @@ static int hugetlbfs_file_mmap(struct file *file, struct vm_area_struct *vma)
           * way when do_mmap_pgoff unwinds (may be important on powerpc
           * and ia64).
           */
  -       vma->vm_flags |= VM_HUGETLB | VM_RESERVED;
  +       vma->vm_flags |= VM_HUGETLB | VM_DONTEXPAND | VM_DONTDUMP;
          vma->vm_ops = &hugetlb_vm_ops;
   
          if (vma->vm_pgoff & (~huge_page_mask(h) >> PAGE_SHIFT))

I think we don't have to set VM_DONTDUMP on hugetlbfs's vma.

Thanks,
Naoya
