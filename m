Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754759AbaAUOgL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 09:36:11 -0500
Received: from smtp.citrix.com ([66.165.176.89]:4488 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754660AbaAUOgJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 09:36:09 -0500
X-IronPort-AV: E=Sophos;i="4.95,696,1384300800"; 
   d="scan'208";a="94888546"
Date: Tue, 21 Jan 2014 14:22:53 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: David Vrabel <david.vrabel@citrix.com>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Zoltan Kiss <zoltan.kiss@citrix.com>, <jonathan.davies@citrix.com>,
        <wei.liu2@citrix.com>, <ian.campbell@citrix.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <xen-devel@lists.xenproject.org>
Subject: Re: [Xen-devel] [PATCH v3] xen/grant-table: Avoid m2p_override during
 mapping
In-Reply-To: <52DE78BF.2070909@citrix.com>
Message-ID: <alpine.DEB.2.02.1401211416420.21510@kaball.uk.xensource.com>
References: <1390244288-3186-1-git-send-email-zoltan.kiss@citrix.com> <alpine.DEB.2.02.1401211217510.21510@kaball.uk.xensource.com> <52DE78BF.2070909@citrix.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Jan 2014, David Vrabel wrote:
> On 21/01/14 12:26, Stefano Stabellini wrote:
> > On Mon, 20 Jan 2014, Zoltan Kiss wrote:
> >
> >> -		ret = m2p_add_override(mfn, pages[i], kmap_ops ?
> >> -				       &kmap_ops[i] : NULL);
> >> +		if (m2p_override)
> >> +			ret = m2p_add_override(mfn, pages[i], kmap_ops ?
> >> +					       &kmap_ops[i] : NULL);
> >> +		else {
> >> +			unsigned long pfn = page_to_pfn(pages[i]);
> >> +			WARN_ON(PagePrivate(pages[i]));
> >> +			SetPagePrivate(pages[i]);
> >> +			set_page_private(pages[i], mfn);
> >> +			pages[i]->index = pfn_to_mfn(pfn);
> >> +			if (unlikely(!set_phys_to_machine(pfn, FOREIGN_FRAME(mfn))))
> >> +				return -ENOMEM;
> > 
> > What happens if the page is PageHighMem?
> > 
> > This looks like a subset of m2p_add_override, but it is missing some
> > relevant bits, like the PageHighMem check, or the p2m(m2p(mfn)) == mfn
> > check.  Maybe we can find a way to avoid duplicating the code.
> > We could split m2p_add_override in two functions or add yet another
> > parameter to it.
> 
> The PageHighMem() check isn't relevant as we're not mapping anything
> here.  Also, a page for a kernel grant mapping only cannot be highmem.
> 
> The check for a local mfn and the additional set_phys_to_machine() is
> only necessary if something tries an mfn_to_pfn() on the local mfn.  We
> can only omit adding an m2p override if we know thing will try
> mfn_to_pfn(), therefore the check and set_phys_to_machine() is unnecessary.

OK, you convinced me that the two checks are superfluous for this case.

Can we still avoid the code duplication by removing the corresponding
code from m2p_add_override and m2p_remove_override and doing the
set_page_private thing uniquely in grant-table.c?
