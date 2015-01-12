Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754034AbbALXNl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 18:13:41 -0500
Received: from mail-yh0-f52.google.com ([209.85.213.52]:39696 "EHLO
	mail-yh0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752639AbbALXNi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 18:13:38 -0500
Date: Mon, 12 Jan 2015 15:13:29 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Jiri Slaby <jslaby@suse.cz>
cc: "Kirill A. Shutemov" <kirill@shutemov.name>,
        Hugh Dickins <hughd@google.com>, stable@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        linux-kernel@vger.kernel.org, Konstantin Khlebnikov <koct9i@gmail.com>,
        Mel Gorman <mgorman@suse.de>, Bob Liu <bob.liu@oracle.com>,
        Christoph Lameter <cl@gentwo.org>, Dave Jones <davej@redhat.com>,
        David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 3.12 78/78] mm: let mm_find_pmd fix buggy race with THP
 fault
In-Reply-To: <20150112111318.GA16935@node.dhcp.inet.fi>
Message-ID: <alpine.LSU.2.11.1501121448200.1589@eggly.anvils>
References: <72002f1f248c28d1715d10454190e209d5a20fe1.1420799385.git.jslaby@suse.cz> <e1c34dac913e87ee8d03c06d7a328a7c2137cafb.1420799385.git.jslaby@suse.cz> <alpine.LSU.2.11.1501092048090.2283@eggly.anvils> <54B39B8A.7000002@suse.cz>
 <20150112111318.GA16935@node.dhcp.inet.fi>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Jan 2015, Kirill A. Shutemov wrote:
> On Mon, Jan 12, 2015 at 11:01:46AM +0100, Jiri Slaby wrote:
> > On 01/10/2015, 06:01 AM, Hugh Dickins wrote:
> > > On Fri, 9 Jan 2015, Jiri Slaby wrote:
> > > 
> > >> From: Hugh Dickins <hughd@google.com>
> > >>
> > >> 3.12-stable review patch.  If anyone has any objections, please let me know.
> > >>
> > >> ===============
> > >>
> > >> commit f72e7dcdd25229446b102e587ef2f826f76bff28 upstream.
> > ...
> > > Fine for this to go in, but there is one catch, which I discovered when
> > > backporting to v3.11: it needed one more hunk.  I haven't checked your
> > > base tree, but if this applies then I believe you need it - most of the
> > > time no problem, but it can case page migration to fail to find a
> > > migration entry it inserted earlier, then BUG_ON(!PageLocked(p)) in
> > > migration_entry_to_page() soon after.  Here's what I wrote back then:
> > > 
> > > Note on rebase to v3.11: added a hunk to replace the use of mm_find_pmd()
> > > in page_check_address_pmd().  This call had been similarly replaced by
> > > the time of my v3.16 commit, in Kirill Shutemov's v3.15 b5a8cad376ee
> > > ("thp: close race between split and zap huge pages"): which we do not
> > > need as such, since it's fixing v3.13 117b0791ac42 ("mm, thp: move ptl
> > > taking inside page_check_address_pmd()"), from a split page-table-lock
> > > series we are not backporting.  But without this additional hunk, rmap
> > > sometimes broke when the new semantic for mm_find_pmd() was used here.
> > > 
> > > (Adding Kirill to Cc: shouldn't he have been Cc'ed already?)
> > > 
> > > Hugh
> > 
> > Thanks, I see. So the diff between the hunk below and 117b0791ac42 are
> > two things:
> > 
> > > --- a/mm/huge_memory.c
> > > +++ b/mm/huge_memory.c
> > > @@ -1584,12 +1584,20 @@ pmd_t *page_check_address_pmd(struct page *page,
> > >  			      unsigned long address,
> > >  			      enum page_check_address_pmd_flag flag)
> > >  {
> > > +	pgd_t *pgd;
> > > +	pud_t *pud;
> > >  	pmd_t *pmd, *ret = NULL;
> > >  
> > >  	if (address & ~HPAGE_PMD_MASK)
> > >  		goto out;
> > >  
> > > -	pmd = mm_find_pmd(mm, address);
> > > +	pgd = pgd_offset(mm, address);
> > > +	if (!pgd_present(*pgd))
> > > +		goto out;
> > > +	pud = pud_offset(pgd, address);
> > > +	if (!pud_present(*pud))
> > > +		goto out;
> > > +	pmd = pmd_offset(pud, address);
> > >  	if (!pmd)
> > >  		goto out;
> > 
> > This check is removed by 117b0791ac42. Can actually pmd returned from
> > pmd_offset be NULL?
> 
> [ I believe, you mean by b5a8cad376ee, right? ]
> 
> No, pmd cannot be NULL here, if pud is present and valid (pud_page_vaddr()
> is not NULL).

Right, the !pmd test after pmd_offset is just stupid: I thought I was
copying a standard version of that sequence from somewhere, and blindly
duplicating the stupid test; but looking back now, suspect I was the
one introducing that stupidity.  It doesn't do anything wrong, but
it's misleadingly stupid and better removed.

> 
> > 
> > >  	if (pmd_none(*pmd))
> > 
> > pmd_none() is replaced by !pmd_present().
> 
> Both pmd_none() and !pmd_present() would work. pmd_none() can be slightly
> faster.

Right, you can use whichever you feel like.

> 
> > My question is: is it OK to take the backport of 117b0791ac42 attached
> > (to stay with what upstream has)?
> 
> The commit message would be totally misleading, since the fixed bug is not
> present in v3.12. It's better to fold the patch into "mm: let mm_find_pmd
> fix buggy race with THP".

Agreed, it would be inappropriate to incorporate Kirill's changelog:
better just to append the text I supplied pointing to his commits.

Hugh
