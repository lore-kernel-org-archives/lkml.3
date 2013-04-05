Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161888Ab3DEOVL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 10:21:11 -0400
Received: from mail.skyhub.de ([78.46.96.112]:42339 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161777Ab3DEOVJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 10:21:09 -0400
Date: Fri, 5 Apr 2013 16:21:04 +0200
From: Borislav Petkov <bp@alien8.de>
To: Stefan Bader <stefan.bader@canonical.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Andy Whitcroft <apw@canonical.com>,
        Mel Gorman <mgorman@suse.de>
Subject: Re: x86/mm/pageattr: Code without effect?
Message-ID: <20130405142104.GB29290@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Stefan Bader <stefan.bader@canonical.com>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ingo Molnar <mingo@kernel.org>, Andy Whitcroft <apw@canonical.com>,
	Mel Gorman <mgorman@suse.de>
References: <515E92CE.2000509@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <515E92CE.2000509@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 05, 2013 at 11:01:02AM +0200, Stefan Bader wrote:
> When looking through some mm code I stumbled over one part in
> arch/x86/mm/pageattr.c that looks somewhat bogus to me. Cannot
> say what exactly the effects are, but maybe you do (or you could
> explain to me why I am wrong :)).
> 
> commit a8aed3e0752b4beb2e37cbed6df69faae88268da
> Author: Andrea Arcangeli <aarcange@redhat.com>
> Date:   Fri Feb 22 15:11:51 2013 -0800
> 
>     x86/mm/pageattr: Prevent PSE and GLOABL leftovers to confuse
>     pmd/pte_present and pmd_huge
> 
> added the following to try_preserve_large_page:
> 
>  	/*
> +	 * Set the PSE and GLOBAL flags only if the PRESENT flag is
> +	 * set otherwise pmd_present/pmd_huge will return true even on
> +	 * a non present pmd. The canon_pgprot will clear _PAGE_GLOBAL
> +	 * for the ancient hardware that doesn't support it.
> +	 */
> +	if (pgprot_val(new_prot) & _PAGE_PRESENT)
> +		pgprot_val(new_prot) |= _PAGE_PSE | _PAGE_GLOBAL;
> +	else
> +		pgprot_val(new_prot) &= ~(_PAGE_PSE | _PAGE_GLOBAL);
> +
> +	new_prot = canon_pgprot(new_prot);
> +
> +	/*
> 
> but (extending what follows after the changes)
> 
> 	 * old_pte points to the large page base address. So we need
> 	 * to add the offset of the virtual address:
> 	 */
> 	pfn = pte_pfn(old_pte) + ((address & (psize - 1)) >> PAGE_SHIFT);
> 	cpa->pfn = pfn;
> 
> 	new_prot = static_protections(req_prot, address, pfn);
> 
> So new_prot gets completely replaced by req_prot and all changes done to
> new_prot before look to be lost (the PSE and GLOBAL bit settings as well
> as the canon_pgprot call.
> 
> Maybe the hunk is useless anyway, or the breakage is subtle, or I miss something...

Yeah, I had to unwillingly stare at this crazy code recently too and
I can share your confusion. And from trying to grok what's going
on, I *think* what we actually meant to do is sanitize our required
protections first, i.e.

	new_prot = static_protections(req_prot, address, pfn);

and *then* do the _PAGE_PRESENT massaging. It does at least make sense
that way. And this is what we already do in __change_page_attr() for a
4K pte.

Andrea?

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
