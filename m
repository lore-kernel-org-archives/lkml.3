Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965188Ab3DHPeT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 11:34:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5544 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965019Ab3DHPeR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 11:34:17 -0400
Date: Mon, 8 Apr 2013 17:32:23 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Andy Whitcroft <apw@canonical.com>
Cc: Borislav Petkov <bp@alien8.de>, Stefan Bader <stefan.bader@canonical.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Mel Gorman <mgorman@suse.de>
Subject: Re: x86/mm/pageattr: Code without effect?
Message-ID: <20130408153223.GA14121@redhat.com>
References: <515E92CE.2000509@canonical.com>
 <20130405142104.GB29290@pd.tnic>
 <20130406145804.GJ3423@redhat.com>
 <20130408145331.GA3303@dm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130408145331.GA3303@dm>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 08, 2013 at 03:53:31PM +0100, Andy Whitcroft wrote:
> On Sat, Apr 06, 2013 at 04:58:04PM +0200, Andrea Arcangeli wrote:
> 
> > You're right, so this location clearly didn't trigger the problem so I
> > didn't notice the noop here. I only exercised the fix in the other
> > locations of the file that had the same problem.
> > 
> > It was a noop, so it really couldn't hurt but the below change should
> > activate the fix there too. On the same lines, there was a superfluous
> > initialization of new_prot too which I cleaned up.
> 
> Although the new code is essentially noop, the other part of the change
> in try_preserve_large_page() moves the canon_pgprot() up above the
> static_protections() incantation which replaces its value, thus we lose
> the effect of that on the protection bits.  I suspect this only affects
> older CPUs (?) but I do think there is a negative semantic change here:
> 
> +       new_prot = canon_pgprot(new_prot);
> [...]
>         new_prot = static_protections(req_prot, address, pfn);
> [...]
> -               new_pte = pfn_pte(pte_pfn(old_pte), canon_pgprot(new_prot));
> +               new_pte = pfn_pte(pte_pfn(old_pte), new_prot);

Agreed, canon_pgprot is only for old cpus so it went unnoticed. The
patch I posted yesterday will fix that too.

static_protections only clear bits. canon_pgprot only clear bits
too. So the order won't matter. And unless we want to enforce
canon_pgprot to always run after static_protections for whatever
reason it should be fine now. If you want to enforce canon_pgprot to
always run last let me know.

Thanks,
Andrea
