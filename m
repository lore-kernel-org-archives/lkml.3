Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756150AbaAVURV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 15:17:21 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:39829 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752331AbaAVURT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 15:17:19 -0500
Date: Wed, 22 Jan 2014 12:16:43 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Oleg Nesterov <oleg@redhat.com>
cc: Alex Thorlton <athorlton@sgi.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Rik van Riel <riel@redhat.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Al Viro <viro@zeniv.linux.org.uk>, Kees Cook <keescook@chromium.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH 2/2] mm: thp: kill the bogus ->def_flags check in
 hugepage_madvise()
In-Reply-To: <20140122174646.GC29710@redhat.com>
Message-ID: <alpine.LSU.2.11.1401221209520.1541@eggly.anvils>
References: <1bc8f911363af956b37d8ea415d734f3191f1c78.1389905087.git.athorlton@sgi.com> <13c9d1b0213af7cee7afb54de368a0b189e98df8.1389905087.git.athorlton@sgi.com> <20140118234957.GB10970@node.dhcp.inet.fi> <20140120195812.GD18196@sgi.com>
 <20140120201525.GA31416@redhat.com> <20140120204108.GE18196@sgi.com> <20140122174553.GA29710@redhat.com> <20140122174646.GC29710@redhat.com>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Jan 2014, Oleg Nesterov wrote:

> hugepage_madvise() checks "mm->def_flags & VM_NOHUGEPAGE" but
> this can be never true, currently mm->def_flags can only have
> VM_LOCKED.

But line 1087 of arch/s390/mm/pgtable.c says
	mm->def_flags |= VM_NOHUGEPAGE;
from 3eabaee998c787e7e1565574821652548f7fc003
"KVM: s390: allow sie enablement for multi-threaded programs".

Hugh

> 
> And otoh we might want to add VM_NOHUGEPAGE into ->def_flags
> but override it in vma->vm_flags via madvise(MADV_HUGEPAGE).
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---
>  mm/huge_memory.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index bccd5a6..e8b656c 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -1941,8 +1941,6 @@ int hugepage_madvise(struct vm_area_struct *vma,
>  		 */
>  		if (*vm_flags & (VM_HUGEPAGE | VM_NO_THP))
>  			return -EINVAL;
> -		if (mm->def_flags & VM_NOHUGEPAGE)
> -			return -EINVAL;
>  		*vm_flags &= ~VM_NOHUGEPAGE;
>  		*vm_flags |= VM_HUGEPAGE;
>  		/*
> -- 
> 1.5.5.1
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
