Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754902Ab3FFNYY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 09:24:24 -0400
Received: from mail.skyhub.de ([78.46.96.112]:43157 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750975Ab3FFNYW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 09:24:22 -0400
Date: Thu, 6 Jun 2013 15:24:06 +0200
From: Borislav Petkov <bp@alien8.de>
To: Matt Fleming <matt@console-pimps.org>
Cc: Linux EFI <linux-efi@vger.kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Jiri Kosina <jkosina@suse.cz>,
        X86-ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH 2/4] x86, cpa: Map in an arbitrary pgd
Message-ID: <20130606132406.GC20972@pd.tnic>
References: <1370177770-26661-1-git-send-email-bp@alien8.de>
 <1370177770-26661-3-git-send-email-bp@alien8.de>
 <20130606102233.GG30420@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130606102233.GG30420@console-pimps.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 06, 2013 at 11:22:33AM +0100, Matt Fleming wrote:
> > @@ -697,7 +714,10 @@ static int __change_page_attr(struct cpa_data *cpa, int primary)
> >  	else
> >  		address = *cpa->vaddr;
> >  repeat:
> > -	kpte = lookup_address(address, &level);
> > +	if (cpa->pgd)
> > +		kpte = __lookup_address_in_pgd(cpa->pgd, address, &level);
> > +	else
> > +		kpte = _lookup_address_cpa(cpa, address, &level);
> 
> Don't you also need to initialise .pgd in __set_pages_p() and
> __set_pages_np()?

Hmm, I don't think so. The idea is to leave the current functionality in
pageattr.c untouched. Currently, it maps PTEs in init_mm.pgd by default
because this is the kernel PGD.

For EFI, we switch the PGD and we want to map the PTEs in this other
PGD, thus we have our own kernel_map_pages_in_pgd() which passes in the
PGD we want to map in through struct cpa_data.

Then, we differentiate the PGD down that code by looking at cpa->pgd.

This was at least the idea.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
