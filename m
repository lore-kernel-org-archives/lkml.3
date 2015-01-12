Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752759AbbALKBx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 05:01:53 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:65150 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752388AbbALKBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 05:01:51 -0500
Message-ID: <54B39B8A.7000002@suse.cz>
Date: Mon, 12 Jan 2015 11:01:46 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Hugh Dickins <hughd@google.com>
CC: stable@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        linux-kernel@vger.kernel.org, Konstantin Khlebnikov <koct9i@gmail.com>,
        Mel Gorman <mgorman@suse.de>, Bob Liu <bob.liu@oracle.com>,
        Christoph Lameter <cl@gentwo.org>, Dave Jones <davej@redhat.com>,
        David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 3.12 78/78] mm: let mm_find_pmd fix buggy race with THP
 fault
References: <72002f1f248c28d1715d10454190e209d5a20fe1.1420799385.git.jslaby@suse.cz> <e1c34dac913e87ee8d03c06d7a328a7c2137cafb.1420799385.git.jslaby@suse.cz> <alpine.LSU.2.11.1501092048090.2283@eggly.anvils>
In-Reply-To: <alpine.LSU.2.11.1501092048090.2283@eggly.anvils>
Content-Type: multipart/mixed;
 boundary="------------020005050600010004030609"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020005050600010004030609
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit

On 01/10/2015, 06:01 AM, Hugh Dickins wrote:
> On Fri, 9 Jan 2015, Jiri Slaby wrote:
> 
>> From: Hugh Dickins <hughd@google.com>
>>
>> 3.12-stable review patch.  If anyone has any objections, please let me know.
>>
>> ===============
>>
>> commit f72e7dcdd25229446b102e587ef2f826f76bff28 upstream.
...
> Fine for this to go in, but there is one catch, which I discovered when
> backporting to v3.11: it needed one more hunk.  I haven't checked your
> base tree, but if this applies then I believe you need it - most of the
> time no problem, but it can case page migration to fail to find a
> migration entry it inserted earlier, then BUG_ON(!PageLocked(p)) in
> migration_entry_to_page() soon after.  Here's what I wrote back then:
> 
> Note on rebase to v3.11: added a hunk to replace the use of mm_find_pmd()
> in page_check_address_pmd().  This call had been similarly replaced by
> the time of my v3.16 commit, in Kirill Shutemov's v3.15 b5a8cad376ee
> ("thp: close race between split and zap huge pages"): which we do not
> need as such, since it's fixing v3.13 117b0791ac42 ("mm, thp: move ptl
> taking inside page_check_address_pmd()"), from a split page-table-lock
> series we are not backporting.  But without this additional hunk, rmap
> sometimes broke when the new semantic for mm_find_pmd() was used here.
> 
> (Adding Kirill to Cc: shouldn't he have been Cc'ed already?)
> 
> Hugh

Thanks, I see. So the diff between the hunk below and 117b0791ac42 are
two things:

> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -1584,12 +1584,20 @@ pmd_t *page_check_address_pmd(struct page *page,
>  			      unsigned long address,
>  			      enum page_check_address_pmd_flag flag)
>  {
> +	pgd_t *pgd;
> +	pud_t *pud;
>  	pmd_t *pmd, *ret = NULL;
>  
>  	if (address & ~HPAGE_PMD_MASK)
>  		goto out;
>  
> -	pmd = mm_find_pmd(mm, address);
> +	pgd = pgd_offset(mm, address);
> +	if (!pgd_present(*pgd))
> +		goto out;
> +	pud = pud_offset(pgd, address);
> +	if (!pud_present(*pud))
> +		goto out;
> +	pmd = pmd_offset(pud, address);
>  	if (!pmd)
>  		goto out;

This check is removed by 117b0791ac42. Can actually pmd returned from
pmd_offset be NULL?

>  	if (pmd_none(*pmd))

pmd_none() is replaced by !pmd_present().

My question is: is it OK to take the backport of 117b0791ac42 attached
(to stay with what upstream has)?

thanks,
-- 
js
suse labs

--------------020005050600010004030609
Content-Type: text/x-patch;
 name="0001-thp-close-race-between-split-and-zap-huge-pages.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename*0="0001-thp-close-race-between-split-and-zap-huge-pages.patch"

=46rom f43340a2b0a461572ed53284148f9eb67d93733b Mon Sep 17 00:00:00 2001
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Date: Fri, 18 Apr 2014 15:07:25 -0700
Subject: [PATCH 1/1] thp: close race between split and zap huge pages

commit b5a8cad376eebbd8598642697e92a27983aee802 upstream.

Sasha Levin has reported two THP BUGs[1][2].  I believe both of them
have the same root cause.  Let's look to them one by one.

The first bug[1] is "kernel BUG at mm/huge_memory.c:1829!".  It's
BUG_ON(mapcount !=3D page_mapcount(page)) in __split_huge_page().  From m=
y
testing I see that page_mapcount() is higher than mapcount here.

I think it happens due to race between zap_huge_pmd() and
page_check_address_pmd().  page_check_address_pmd() misses PMD which is
under zap:

	CPU0						CPU1
						zap_huge_pmd()
						  pmdp_get_and_clear()
__split_huge_page()
  anon_vma_interval_tree_foreach()
    __split_huge_page_splitting()
      page_check_address_pmd()
        mm_find_pmd()
	  /*
	   * We check if PMD present without taking ptl: no
	   * serialization against zap_huge_pmd(). We miss this PMD,
	   * it's not accounted to 'mapcount' in __split_huge_page().
	   */
	  pmd_present(pmd) =3D=3D 0

  BUG_ON(mapcount !=3D page_mapcount(page)) // CRASH!!!

						  page_remove_rmap(page)
						    atomic_add_negative(-1, &page->_mapcount)

The second bug[2] is "kernel BUG at mm/huge_memory.c:1371!".
It's VM_BUG_ON_PAGE(!PageHead(page), page) in zap_huge_pmd().

This happens in similar way:

	CPU0						CPU1
						zap_huge_pmd()
						  pmdp_get_and_clear()
						  page_remove_rmap(page)
						    atomic_add_negative(-1, &page->_mapcount)
__split_huge_page()
  anon_vma_interval_tree_foreach()
    __split_huge_page_splitting()
      page_check_address_pmd()
        mm_find_pmd()
	  pmd_present(pmd) =3D=3D 0	/* The same comment as above */
  /*
   * No crash this time since we already decremented page->_mapcount in
   * zap_huge_pmd().
   */
  BUG_ON(mapcount !=3D page_mapcount(page))

  /*
   * We split the compound page here into small pages without
   * serialization against zap_huge_pmd()
   */
  __split_huge_page_refcount()
						VM_BUG_ON_PAGE(!PageHead(page), page); // CRASH!!!

So my understanding the problem is pmd_present() check in mm_find_pmd()
without taking page table lock.

The bug was introduced by me commit with commit 117b0791ac42. Sorry for
that. :(

Let's open code mm_find_pmd() in page_check_address_pmd() and do the
check under page table lock.

Note that __page_check_address() does the same for PTE entires
if sync !=3D 0.

I've stress tested split and zap code paths for 36+ hours by now and
don't see crashes with the patch applied. Before it took <20 min to
trigger the first bug and few hours for second one (if we ignore
first).

[1] https://lkml.kernel.org/g/<53440991.9090001@oracle.com>
[2] https://lkml.kernel.org/g/<5310C56C.60709@oracle.com>

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reported-by: Sasha Levin <sasha.levin@oracle.com>
Tested-by: Sasha Levin <sasha.levin@oracle.com>
Cc: Bob Liu <lliubbo@gmail.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michel Lespinasse <walken@google.com>
Cc: Dave Jones <davej@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>	[3.13+]

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 mm/huge_memory.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 04d17ba00893..04535b64119c 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1541,15 +1541,22 @@ pmd_t *page_check_address_pmd(struct page *page,
 			      unsigned long address,
 			      enum page_check_address_pmd_flag flag)
 {
+	pgd_t *pgd;
+	pud_t *pud;
 	pmd_t *pmd, *ret =3D NULL;
=20
 	if (address & ~HPAGE_PMD_MASK)
 		goto out;
=20
-	pmd =3D mm_find_pmd(mm, address);
-	if (!pmd)
+	pgd =3D pgd_offset(mm, address);
+	if (!pgd_present(*pgd))
 		goto out;
-	if (pmd_none(*pmd))
+	pud =3D pud_offset(pgd, address);
+	if (!pud_present(*pud))
+		goto out;
+	pmd =3D pmd_offset(pud, address);
+
+	if (!pmd_present(*pmd))
 		goto out;
 	if (pmd_page(*pmd) !=3D page)
 		goto out;
--=20
2.2.1


--------------020005050600010004030609--
