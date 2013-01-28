Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757099Ab3A1Al0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 19:41:26 -0500
Received: from mail-da0-f42.google.com ([209.85.210.42]:38571 "EHLO
	mail-da0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754963Ab3A1AlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 19:41:24 -0500
Message-ID: <1359333683.6763.13.camel@kernel>
Subject: Re: [PATCH 7/11] ksm: make KSM page migration possible
From: Simon Jeons <simon.jeons@gmail.com>
To: Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Petr Holasek <pholasek@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Izik Eidus <izik.eidus@ravellosystems.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Date: Sun, 27 Jan 2013 18:41:23 -0600
In-Reply-To: <alpine.LNX.2.00.1301271506480.17495@eggly.anvils>
References: <alpine.LNX.2.00.1301251747590.29196@eggly.anvils>
	 <alpine.LNX.2.00.1301251802050.29196@eggly.anvils>
	 <1359265635.6763.0.camel@kernel>
	 <alpine.LNX.2.00.1301271506480.17495@eggly.anvils>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-01-27 at 15:12 -0800, Hugh Dickins wrote:
> On Sat, 26 Jan 2013, Simon Jeons wrote:
> > On Fri, 2013-01-25 at 18:03 -0800, Hugh Dickins wrote:
> > > +	while (!get_page_unless_zero(page)) {
> > > +		/*
> > > +		 * Another check for page->mapping != expected_mapping would
> > > +		 * work here too.  We have chosen the !PageSwapCache test to
> > > +		 * optimize the common case, when the page is or is about to
> > > +		 * be freed: PageSwapCache is cleared (under spin_lock_irq)
> > > +		 * in the freeze_refs section of __remove_mapping(); but Anon
> > > +		 * page->mapping reset to NULL later, in free_pages_prepare().
> > > +		 */
> > > +		if (!PageSwapCache(page))
> > > +			goto stale;
> > > +		cpu_relax();
> > > +	}
> > > +
> > > +	if (ACCESS_ONCE(page->mapping) != expected_mapping) {
> > >  		put_page(page);
> > >  		goto stale;
> > >  	}
> > > +
> > >  	if (locked) {
> > >  		lock_page(page);
> > > -		if (page->mapping != expected_mapping) {
> > > +		if (ACCESS_ONCE(page->mapping) != expected_mapping) {
> > >  			unlock_page(page);
> > >  			put_page(page);
> > >  			goto stale;
> > >  		}
> > >  	}
> > 
> > Could you explain why need check page->mapping twice after get page?
> 
> Once for the !locked case, which should not return page if mapping changed.
> Once for the locked case, which should not return page if mapping changed.
> We could use "else", but that wouldn't be an improvement.

But for locked case, page->mapping will be check twice.



