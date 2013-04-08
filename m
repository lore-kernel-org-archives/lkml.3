Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936217Ab3DHOQZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 10:16:25 -0400
Received: from mail.skyhub.de ([78.46.96.112]:56433 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936037Ab3DHOQY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 10:16:24 -0400
Date: Mon, 8 Apr 2013 16:15:57 +0200
From: Borislav Petkov <bp@alien8.de>
To: Stefan Bader <stefan.bader@canonical.com>
Cc: Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Whitcroft <apw@canonical.com>, Mel Gorman <mgorman@suse.de>
Subject: Re: x86/mm/pageattr: Code without effect?
Message-ID: <20130408141557.GD4395@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Stefan Bader <stefan.bader@canonical.com>,
	Ingo Molnar <mingo@kernel.org>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Whitcroft <apw@canonical.com>, Mel Gorman <mgorman@suse.de>
References: <515E92CE.2000509@canonical.com>
 <20130405142104.GB29290@pd.tnic>
 <20130406145804.GJ3423@redhat.com>
 <20130406154751.GB3612@pd.tnic>
 <20130408115344.GA7513@gmail.com>
 <20130408115959.GB4395@pd.tnic>
 <5162B7FF.7010603@canonical.com>
 <20130408125129.GC4395@pd.tnic>
 <5162C1A8.4060904@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5162C1A8.4060904@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 08, 2013 at 03:10:00PM +0200, Stefan Bader wrote:
>          * that we limited the number of possible pages already to
>          * the number of pages in the large page.
>          */
>         if (address == (address & pmask) && cpa->numpages == (psize >>
> PAGE_SHIFT)) {
>                 /*
>                  * The address is aligned and the number of pages
>                  * covers the full page.
>                  */
>                 new_pte = pfn_pte(pte_pfn(old_pte), new_prot);
>                                                      ^
> 
> This one. The first patch changed
> 
> -               new_pte = pfn_pte(pte_pfn(old_pte), canon_pgprot(new_prot));
> +               new_pte = pfn_pte(pte_pfn(old_pte), new_prot);
> 
> The fixup patch drops new_prot completely from being initialized and only works
> on req_prot. Probably it would be best to also drop the definition of new_prot.
> I think it then completely unused.

Actually, we do need and initialize new_prot at line 495:

	pfn = pte_pfn(old_pte) + ((address & (psize - 1)) >> PAGE_SHIFT);
	cpa->pfn = pfn;

	new_prot = static_protections(req_prot, address, pfn);		<---

and we need it for the subsequent loop where we go over the 512 PTEs to
decide whether to split or not.

So it is needed after all, AFAICT.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
