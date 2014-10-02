Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752210AbaJBQf7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 12:35:59 -0400
Received: from mta-out1.inet.fi ([62.71.2.197]:56287 "EHLO jenni1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751675AbaJBQf6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 12:35:58 -0400
Date: Thu, 2 Oct 2014 19:35:43 +0300
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
Message-ID: <20141002163543.GA14695@node.dhcp.inet.fi>
References: <20140930182059.GA24431@redhat.com>
 <CA+55aFzfvXHd2LUhQ5OiV1H1Oq2y3PL8hX_Hrv-C907PyDNugA@mail.gmail.com>
 <alpine.LSU.2.11.1410010031070.1902@eggly.anvils>
 <CA+55aFyJ09+iv2HX1nfAaDi0-7=L3KxKi11CACbM8K_Coo6kzg@mail.gmail.com>
 <CA+55aFzHgemAV7igyG=0pmctTaV7cZfO4fdqukhrCc8VXTrZuw@mail.gmail.com>
 <CA+55aFzisEwtcBA93Xo74RM-6X9V=_go=YhN7eFJOHLeHs3HEQ@mail.gmail.com>
 <542C7B5E.2020000@oracle.com>
 <CA+55aFy7Y+pmhyEHTJg=K8gLKzLHxzz6j9FBJMt7_Fazfong6g@mail.gmail.com>
 <20141002142503.GA13203@node.dhcp.inet.fi>
 <CA+55aFx691Ymqnw1oBUGJdsKsSrKvJ9sVVjYRwKd8QEhTpos3A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFx691Ymqnw1oBUGJdsKsSrKvJ9sVVjYRwKd8QEhTpos3A@mail.gmail.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 02, 2014 at 09:01:38AM -0700, Linus Torvalds wrote:
> On Thu, Oct 2, 2014 at 7:25 AM, Kirill A. Shutemov <kirill@shutemov.name> wrote:
> >
> > I don't see what prevents the code to make zero page writable here.
> > We need at least pmd = pmd_wrprotect(pmd) before set_pmd_at();
> 
> Do we? If it's the zero page, it had better be an anonymous mapping,
> and vm_page_prot had better not be writable.
> 
> Anonymous pages don't _start_ out writable, we explicitly make them so
> with code like
> 
>         if (vma->vm_flags & VM_WRITE)
>                 entry = pte_mkwrite(pte_mkdirty(entry));
> 
> so it should be fine to just use "pmd_modify(pmd, vma->vm_page_prot);" directly.
> 
> But hey, this is the kind of thing that maybe I'm missing something on..

You're right.
It means we have redundant pmd_wrprotect() in set_huge_zero_page().

==========================================================================

Subject: [PATCH] thp: do not mark zero-page pmd write-protected explicitly

Zero pages can be used only in anonymous mappings, which never have
writable vma->vm_page_prot: see protection_map in mm/mmap.c and __PX1X
definitions.

Let's drop redundant pmd_wrprotect() in set_huge_zero_page().

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 mm/huge_memory.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index d9a21d06b862..2c17d184b56d 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -784,7 +784,6 @@ static bool set_huge_zero_page(pgtable_t pgtable, struct mm_struct *mm,
 	if (!pmd_none(*pmd))
 		return false;
 	entry = mk_pmd(zero_page, vma->vm_page_prot);
-	entry = pmd_wrprotect(entry);
 	entry = pmd_mkhuge(entry);
 	pgtable_trans_huge_deposit(mm, pmd, pgtable);
 	set_pmd_at(mm, haddr, pmd, entry);
-- 
 Kirill A. Shutemov
