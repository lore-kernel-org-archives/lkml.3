Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758868AbaGBACt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 20:02:49 -0400
Received: from one.firstfloor.org ([193.170.194.197]:41782 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753059AbaGBACr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 20:02:47 -0400
Date: Wed, 2 Jul 2014 02:02:45 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: Re: [PATCH] hwpoison: Fix race with changing page during offlining
 v2
Message-ID: <20140702000245.GM5714@two.firstfloor.org>
References: <1404174736-17480-1-git-send-email-andi@firstfloor.org>
 <20140701152716.b9b4b04ee67cf987844b1aa4@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140701152716.b9b4b04ee67cf987844b1aa4@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > --- a/mm/memory-failure.c
> > +++ b/mm/memory-failure.c
> > @@ -1168,6 +1168,16 @@ int memory_failure(unsigned long pfn, int trapno, int flags)
> >  	lock_page(hpage);
> >  
> >  	/*
> > +	 * The page could have changed compound pages during the locking.
> > +	 * If this happens just bail out.
> > +	 */
> > +	if (compound_head(p) != hpage) {
> 
> How can a 4k page change compound pages?  The original compound page
> was torn down and then this 4k page became part of a differently-size
> compound page?

Yes or it was torn down and now it's its own page.

> 
> > +		action_result(pfn, "different compound page after locking", IGNORED);
> > +		res = -EBUSY;
> > +		goto out;
> > +	}
> > +
> > +	/*
> 
> I don't get it.  We just go and fail the poisoning attempt?  Shouldn't
> we go back, grab the new hpage and try again?

It should be quite rare, so I thought this was safest. An retry loop
would be more difficult to test and may have more side effects.

The hwpoison code by design only tries to handle cases that are
reasonably common in workloads, as visible in page-flags.

I'm not really that concerned about handling this (likely rare case),
just not crashing on it.

-Andi
