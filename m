Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751299AbaKCKbW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 05:31:22 -0500
Received: from www.linutronix.de ([62.245.132.108]:50956 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179AbaKCKbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 05:31:20 -0500
Date: Mon, 3 Nov 2014 11:31:04 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Juergen Gross <jgross@suse.com>
cc: hpa@zytor.com, x86@kernel.org, mingo@redhat.com,
        stefan.bader@canonical.com, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com, konrad.wilk@oracle.com,
        ville.syrjala@linux.intel.com, david.vrabel@citrix.com,
        jbeulich@suse.com, toshi.kani@hp.com, plagnioj@jcrosoft.com,
        tomi.valkeinen@ti.com, bhelgaas@google.com
Subject: Re: [PATCH 10/17] x86: Use new cache mode type in setting page
 attributes
In-Reply-To: <54572182.8080005@suse.com>
Message-ID: <alpine.DEB.2.11.1411031122150.5308@nanos>
References: <1414764033-30011-1-git-send-email-jgross@suse.com> <1414764033-30011-11-git-send-email-jgross@suse.com> <alpine.DEB.2.11.1410311617260.5308@nanos> <54572182.8080005@suse.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Nov 2014, Juergen Gross wrote:
> On 10/31/2014 04:34 PM, Thomas Gleixner wrote:
> > On Fri, 31 Oct 2014, Juergen Gross wrote:
> > > --- a/arch/x86/mm/pageattr.c
> > > +++ b/arch/x86/mm/pageattr.c
> > > @@ -1304,12 +1304,6 @@ static int __change_page_attr_set_clr(struct
> > > cpa_data *cpa, int checkalias)
> > >   	return 0;
> > >   }
> > > 
> > > -static inline int cache_attr(pgprot_t attr)
> > > -{
> > > -	return pgprot_val(attr) &
> > > -		(_PAGE_PAT | _PAGE_PAT_LARGE | _PAGE_PWT | _PAGE_PCD);
> > > -}
> > > -
> > >   static int change_page_attr_set_clr(unsigned long *addr, int numpages,
> > >   				    pgprot_t mask_set, pgprot_t mask_clr,
> > >   				    int force_split, int in_flag,
> > > @@ -1390,7 +1384,7 @@ static int change_page_attr_set_clr(unsigned long
> > > *addr, int numpages,
> > >   	 * No need to flush, when we did not set any of the caching
> > >   	 * attributes:
> > >   	 */
> > > -	cache = cache_attr(mask_set);
> > > +	cache = !!pgprot2cachemode(mask_set);
> > 
> > So this loses _PAGE_PAT_LARGE, right ?
> 
> change_page_attr_set_clr() is never called with _PAGE_PAT_LARGE set in
> mask, so this is no problem.

Ok. The we should have a separate patch which removes it first with a
proper explanation and then the one which uses pgprot2cachemode().

> BTW: correct handling of the PAT bit for large pages is added in
> patch 15. There have been places in the kernel respecting
> _PAGE_PAT_LARGE, but handling has never been complete up to now.

Yes. I've seen that.
 
> > >   int _set_memory_wb(unsigned long addr, int numpages)
> > >   {
> > > +	/* WB cache mode is hard wired to all cache attribute bits being 0 */
> > 
> > I like the comment, but shouldn't we compile time check that
> > assumption somewhere?
> 
> There is a comment in patch 1 where the page_cache_mode enum is set up.
> The translation functions between page_cache_mode and protection values
> have a special check for "0" built in. Isn't this enough?
> 
> BTW: How would you check this assumption at compile time? The
> translation between WB cache mode and protection values is done only
> dynamically...

Indeed.

Thanks,

	tglx
