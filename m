Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753026AbaJBOZ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 10:25:27 -0400
Received: from mta-out1.inet.fi ([62.71.2.226]:56524 "EHLO jenni2.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751507AbaJBOZ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 10:25:26 -0400
Date: Thu, 2 Oct 2014 17:25:03 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Sasha Levin <sasha.levin@oracle.com>, Hugh Dickins <hughd@google.com>,
        Dave Jones <davej@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Michel Lespinasse <walken@google.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Mel Gorman <mgorman@suse.de>
Subject: Re: pipe/page fault oddness.
Message-ID: <20141002142503.GA13203@node.dhcp.inet.fi>
References: <20140930164047.GA18354@redhat.com>
 <CA+55aFzKgJ41Mp=Ub8Kq_uFDHYzkHo3zhO3MHOJo_O2iExdYmQ@mail.gmail.com>
 <20140930182059.GA24431@redhat.com>
 <CA+55aFzfvXHd2LUhQ5OiV1H1Oq2y3PL8hX_Hrv-C907PyDNugA@mail.gmail.com>
 <alpine.LSU.2.11.1410010031070.1902@eggly.anvils>
 <CA+55aFyJ09+iv2HX1nfAaDi0-7=L3KxKi11CACbM8K_Coo6kzg@mail.gmail.com>
 <CA+55aFzHgemAV7igyG=0pmctTaV7cZfO4fdqukhrCc8VXTrZuw@mail.gmail.com>
 <CA+55aFzisEwtcBA93Xo74RM-6X9V=_go=YhN7eFJOHLeHs3HEQ@mail.gmail.com>
 <542C7B5E.2020000@oracle.com>
 <CA+55aFy7Y+pmhyEHTJg=K8gLKzLHxzz6j9FBJMt7_Fazfong6g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFy7Y+pmhyEHTJg=K8gLKzLHxzz6j9FBJMt7_Fazfong6g@mail.gmail.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 01, 2014 at 03:42:53PM -0700, Linus Torvalds wrote:
> On Wed, Oct 1, 2014 at 3:08 PM, Sasha Levin <sasha.levin@oracle.com> wrote:
> >
> > I've tried this patch on the same configuration that was triggering
> > the VM_BUG_ON that Hugh mentioned previously. Surprisingly enough it
> > ran fine for ~20 minutes before exploding with:
> 
> Well, that's somewhat encouraging. I didn't expect it to be perfect.
> 
> That said, "ran fine" isn't necessarily the same thing as "worked".
> Who knows how buggy it was without showing overt symptoms until the
> BUG_ON() triggered. But hey, I'll be optimistic.
> 
> > [ 2781.566206] kernel BUG at mm/huge_memory.c:1293!
> 
> So that's
> 
>         BUG_ON(is_huge_zero_page(page));
> 
> and the reason is trivial: the old code used to have a magical special
> case for the zero-page hugepage (see change_huge_pmd()) and I got rid
> of that (because now it's just about setting protections, and the
> zero-page hugepage is in no way special.
> 
> So I think the solution is equally trivial: just accept that the
> zero-page can happen, and ignore it (just un-numa it).
> 
> Appended is a incremental diff on top of the previous one. Even less
> tested than the last case, but I think you get the idea if it doesn't
> work as-is.
> 
>              Linus

> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 14de54af6c38..fc33952d59c4 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -1290,7 +1290,9 @@ int do_huge_pmd_numa_page(struct mm_struct *mm, struct vm_area_struct *vma,
>  	}
>  
>  	page = pmd_page(pmd);
> -	BUG_ON(is_huge_zero_page(page));
> +	if (is_huge_zero_page(page))
> +		goto huge_zero_page;
> +
>  	page_nid = page_to_nid(page);
>  	last_cpupid = page_cpupid_last(page);
>  	count_vm_numa_event(NUMA_HINT_FAULTS);
> @@ -1381,6 +1383,11 @@ out:
>  		task_numa_fault(last_cpupid, page_nid, HPAGE_PMD_NR, flags);
>  
>  	return 0;
> +huge_zero_page:
> +	pmd = pmd_modify(pmd, vma->vm_page_prot);
> +	set_pmd_at(mm, haddr, pmdp, pmd);
> +	update_mmu_cache_pmd(vma, addr, pmdp);
> +	goto out_unlock;

I don't see what prevents the code to make zero page writable here.
We need at least pmd = pmd_wrprotect(pmd) before set_pmd_at();

-- 
 Kirill A. Shutemov
