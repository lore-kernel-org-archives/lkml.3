Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423170Ab3DFO7J (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Apr 2013 10:59:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49714 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423061Ab3DFO7H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Apr 2013 10:59:07 -0400
Date: Sat, 6 Apr 2013 16:58:04 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Borislav Petkov <bp@alien8.de>, Stefan Bader <stefan.bader@canonical.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Andy Whitcroft <apw@canonical.com>,
        Mel Gorman <mgorman@suse.de>
Subject: Re: x86/mm/pageattr: Code without effect?
Message-ID: <20130406145804.GJ3423@redhat.com>
References: <515E92CE.2000509@canonical.com>
 <20130405142104.GB29290@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130405142104.GB29290@pd.tnic>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

On Fri, Apr 05, 2013 at 04:21:04PM +0200, Borislav Petkov wrote:
> On Fri, Apr 05, 2013 at 11:01:02AM +0200, Stefan Bader wrote:
> > When looking through some mm code I stumbled over one part in
> > arch/x86/mm/pageattr.c that looks somewhat bogus to me. Cannot
> > say what exactly the effects are, but maybe you do (or you could
> > explain to me why I am wrong :)).
> > 
> > commit a8aed3e0752b4beb2e37cbed6df69faae88268da
> > Author: Andrea Arcangeli <aarcange@redhat.com>
> > Date:   Fri Feb 22 15:11:51 2013 -0800
> > 
> >     x86/mm/pageattr: Prevent PSE and GLOABL leftovers to confuse
> >     pmd/pte_present and pmd_huge
> > 
> > added the following to try_preserve_large_page:
> > 
> >  	/*
> > +	 * Set the PSE and GLOBAL flags only if the PRESENT flag is
> > +	 * set otherwise pmd_present/pmd_huge will return true even on
> > +	 * a non present pmd. The canon_pgprot will clear _PAGE_GLOBAL
> > +	 * for the ancient hardware that doesn't support it.
> > +	 */
> > +	if (pgprot_val(new_prot) & _PAGE_PRESENT)
> > +		pgprot_val(new_prot) |= _PAGE_PSE | _PAGE_GLOBAL;
> > +	else
> > +		pgprot_val(new_prot) &= ~(_PAGE_PSE | _PAGE_GLOBAL);
> > +
> > +	new_prot = canon_pgprot(new_prot);
> > +
> > +	/*
> > 
> > but (extending what follows after the changes)
> > 
> > 	 * old_pte points to the large page base address. So we need
> > 	 * to add the offset of the virtual address:
> > 	 */
> > 	pfn = pte_pfn(old_pte) + ((address & (psize - 1)) >> PAGE_SHIFT);
> > 	cpa->pfn = pfn;
> > 
> > 	new_prot = static_protections(req_prot, address, pfn);
> > 
> > So new_prot gets completely replaced by req_prot and all changes done to
> > new_prot before look to be lost (the PSE and GLOBAL bit settings as well
> > as the canon_pgprot call.
> > 
> > Maybe the hunk is useless anyway, or the breakage is subtle, or I miss something...
> 
> Yeah, I had to unwillingly stare at this crazy code recently too and
> I can share your confusion. And from trying to grok what's going
> on, I *think* what we actually meant to do is sanitize our required
> protections first, i.e.
> 
> 	new_prot = static_protections(req_prot, address, pfn);
> 
> and *then* do the _PAGE_PRESENT massaging. It does at least make sense
> that way. And this is what we already do in __change_page_attr() for a
> 4K pte.
> 
> Andrea?

You're right, so this location clearly didn't trigger the problem so I
didn't notice the noop here. I only exercised the fix in the other
locations of the file that had the same problem.

It was a noop, so it really couldn't hurt but the below change should
activate the fix there too. On the same lines, there was a superfluous
initialization of new_prot too which I cleaned up.

==
>From 75598be1156ced0c210271e8958a5c5714a2626a Mon Sep 17 00:00:00 2001
From: Andrea Arcangeli <aarcange@redhat.com>
Date: Fri, 5 Apr 2013 19:43:20 +0200
Subject: [PATCH] mm: pageattr: convert noop to functional fix

commit a8aed3e0752b4beb2e37cbed6df69faae88268da introduced some valid
fix but one location that didn't trigger the bug that lead to finding
those (small) problems, wasn't updated using the right variable.

The wrong variable was also initialized for no good reason, that may
have been the source of the confusion. Remove the noop initialization
accordingly.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
---
 arch/x86/mm/pageattr.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index 091934e..7896f71 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -467,7 +467,7 @@ try_preserve_large_page(pte_t *kpte, unsigned long address,
 	 * We are safe now. Check whether the new pgprot is the same:
 	 */
 	old_pte = *kpte;
-	old_prot = new_prot = req_prot = pte_pgprot(old_pte);
+	old_prot = req_prot = pte_pgprot(old_pte);
 
 	pgprot_val(req_prot) &= ~pgprot_val(cpa->mask_clr);
 	pgprot_val(req_prot) |= pgprot_val(cpa->mask_set);
@@ -478,12 +478,12 @@ try_preserve_large_page(pte_t *kpte, unsigned long address,
 	 * a non present pmd. The canon_pgprot will clear _PAGE_GLOBAL
 	 * for the ancient hardware that doesn't support it.
 	 */
-	if (pgprot_val(new_prot) & _PAGE_PRESENT)
-		pgprot_val(new_prot) |= _PAGE_PSE | _PAGE_GLOBAL;
+	if (pgprot_val(req_prot) & _PAGE_PRESENT)
+		pgprot_val(req_prot) |= _PAGE_PSE | _PAGE_GLOBAL;
 	else
-		pgprot_val(new_prot) &= ~(_PAGE_PSE | _PAGE_GLOBAL);
+		pgprot_val(req_prot) &= ~(_PAGE_PSE | _PAGE_GLOBAL);
 
-	new_prot = canon_pgprot(new_prot);
+	req_prot = canon_pgprot(req_prot);
 
 	/*
 	 * old_pte points to the large page base address. So we need

