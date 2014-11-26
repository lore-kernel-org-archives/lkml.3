Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752261AbaKZGRe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 01:17:34 -0500
Received: from mta-out1.inet.fi ([62.71.2.203]:38754 "EHLO jenni2.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752108AbaKZGRd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 01:17:33 -0500
Date: Wed, 26 Nov 2014 08:17:15 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: James Custer <jcuster@sgi.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, David Rientjes <rientjes@google.com>
Subject: Re: [PATCH] x86: Allow 1GB pages to be SPECIAL similar to 2MB
Message-ID: <20141126061715.GA17897@node.dhcp.inet.fi>
References: <1411656024-33114-1-git-send-email-jcuster@sgi.com>
 <20141125132304.ee475f4ea432a2e52ed4f8b5@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141125132304.ee475f4ea432a2e52ed4f8b5@linux-foundation.org>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 25, 2014 at 01:23:04PM -0800, Andrew Morton wrote:
> On Thu, 25 Sep 2014 09:40:24 -0500 James Custer <jcuster@sgi.com> wrote:
> 
> > Superpages allocated by SGI's superpages module can be backed by 1GB pages,
> > but direct i/o cannot be used. The superpages module uses _PAGE_BIT_SPECIAL
> > to disable direct i/o because some code depends on the memory being backed
> > by page structures. But, because superpages have no backing page structures
> > this causes a panic.
> > 
> > This is the way direct i/o on 1GB pages fails:
> > 
> >                BUG: unable to handle kernel paging request at ffffea0038000000
> > [60463.203795] IP: [<ffffffff8103c93a>] gup_huge_pud+0x9a/0xe0
> > [60463.210058] PGD 83ffd3067 PUD 83ffd2067 PMD 0
> > [60463.215052] Oops: 0000 [#1] SMP
> > 
> > Stack traceback for pid 77136
> > 0xffff8867a88ae300    77136    74825  1   56   R  0xffff8867a88ae970 *readdirectsp
> >  [<ffffffff8103c93a>] gup_huge_pud+0x9a/0xe0
> >  [<ffffffff8103cc33>] gup_pud_range+0x173/0x1b0
> >  [<ffffffff8103cd57>] get_user_pages_fast+0xe7/0x1b0
> >  [<ffffffff8118eac3>] dio_get_page+0x83/0x150
> >  [<ffffffff8118f641>] do_direct_IO+0x81/0x420
> >  [<ffffffff8118fb89>] direct_io_worker+0x1a9/0x340
> >  [<ffffffffa00c5de8>] ext3_direct_IO+0xe8/0x2c0 [ext3]
> >  [<ffffffff810fa527>] generic_file_aio_read+0x237/0x260
> >  [<ffffffff81159878>] do_sync_read+0xc8/0x110
> >  [<ffffffff8115a027>] vfs_read+0xc7/0x130
> >  [<ffffffff8115a193>] sys_read+0x53/0xa0
> >  [<ffffffff81466192>] system_call_fastpath+0x16/0x1b
> > 
> > gup_huge_pud() is trying to find the page structure, and with superpages there
> > is none.
> > 
> > With direct i/o on 2MB pages:
> > 
> > static int gup_pmd_range(pud_t pud, unsigned long addr, unsigned long end,
> >                 int write, struct page **pages, int *nr)
> > {
> >  ...
> >                 if (pmd_none(pmd) || pmd_trans_splitting(pmd))
> >                         return 0;
> > 
> > and pmd_trans_splitting() is testing _PAGE_SPLITTING, which is an alias
> > for _PAGE_SPECIAL which we set on the 2MB or 1GB pages mapped in by superpages.
> > 
> > But gup_pud_range() has no such check:
> > 
> > static int gup_pud_range(pgd_t pgd, unsigned long addr, unsigned long end,
> >                         int write, struct page **pages, int *nr)
> > {
> >   ...
> >                 if (pud_none(pud))
> >                         return 0;
> > 
> > Therefore direct i/o on 1GB pages attempts to get a page structure and panics.
> > 
> > ...
> >
> > @@ -223,7 +221,7 @@ static int gup_pud_range(pgd_t pgd, unsigned long addr, unsigned long end,
> >  		pud_t pud = *pudp;
> >  
> >  		next = pud_addr_end(addr, end);
> > -		if (pud_none(pud))
> > +		if (pud_none(pud) || (pud_val(pud) & _PAGE_SPECIAL))
> >  			return 0;
> >  		if (unlikely(pud_large(pud))) {
> >  			if (!gup_huge_pud(pud, addr, next, write, pages, nr))
> 
> If I'm understanding it correctly, this patch is only needed by SGI's
> superpages module, yes?
> 
> That being said, it looks like a reasonable precaution and we could
> easily carry it.

Previously we used PSE + SOFTW1 in pmd_t for pmd_trans_splitting().
I don't think it's good idea to reserve a bit in page table entries for
use-case kernel by itself doesn't support. Especially, that it's a bit in
present entry.

-- 
 Kirill A. Shutemov
