Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965323Ab3DHOxg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 10:53:36 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:45382 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965309Ab3DHOxf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 10:53:35 -0400
Date: Mon, 8 Apr 2013 15:53:31 +0100
From: Andy Whitcroft <apw@canonical.com>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>, Stefan Bader <stefan.bader@canonical.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Mel Gorman <mgorman@suse.de>
Subject: Re: x86/mm/pageattr: Code without effect?
Message-ID: <20130408145331.GA3303@dm>
References: <515E92CE.2000509@canonical.com>
 <20130405142104.GB29290@pd.tnic>
 <20130406145804.GJ3423@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130406145804.GJ3423@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 06, 2013 at 04:58:04PM +0200, Andrea Arcangeli wrote:

> You're right, so this location clearly didn't trigger the problem so I
> didn't notice the noop here. I only exercised the fix in the other
> locations of the file that had the same problem.
> 
> It was a noop, so it really couldn't hurt but the below change should
> activate the fix there too. On the same lines, there was a superfluous
> initialization of new_prot too which I cleaned up.

Although the new code is essentially noop, the other part of the change
in try_preserve_large_page() moves the canon_pgprot() up above the
static_protections() incantation which replaces its value, thus we lose
the effect of that on the protection bits.  I suspect this only affects
older CPUs (?) but I do think there is a negative semantic change here:

+       new_prot = canon_pgprot(new_prot);
[...]
        new_prot = static_protections(req_prot, address, pfn);
[...]
-               new_pte = pfn_pte(pte_pfn(old_pte), canon_pgprot(new_prot));
+               new_pte = pfn_pte(pte_pfn(old_pte), new_prot);

-apw
