Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759703Ab3EWQjO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 12:39:14 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:34594
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759546Ab3EWQjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 12:39:12 -0400
Date: Thu, 23 May 2013 18:39:01 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Christoph Lameter <cl@linux.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Vince Weaver <vincent.weaver@maine.edu>,
        linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        trinity@vger.kernel.org
Subject: Re: OOPS in perf_mmap_close()
Message-ID: <20130523163901.GG23650@twins.programming.kicks-ass.net>
References: <alpine.DEB.2.10.1305221523420.9944@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1305221953370.11450@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1305222344060.12929@vincent-weaver-1.um.maine.edu>
 <20130523044803.GA25399@ZenIV.linux.org.uk>
 <20130523104154.GA23650@twins.programming.kicks-ass.net>
 <0000013ed1b8d0cc-ad2bb878-51bd-430c-8159-629b23ed1b44-000000@email.amazonses.com>
 <20130523152458.GD23650@twins.programming.kicks-ass.net>
 <0000013ed2297ba8-467d474a-7068-45b3-9fa3-82641e6aa363-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0000013ed2297ba8-467d474a-7068-45b3-9fa3-82641e6aa363-000000@email.amazonses.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 23, 2013 at 04:12:14PM +0000, Christoph Lameter wrote:
> On Thu, 23 May 2013, Peter Zijlstra wrote:
> 
> > The patch completely fails to explain how RLIMIT_LOCKED is supposed to
> > deal with pinned vs locked. Perf used to account its pages against
> > RLIMIT_LOCKED, with the patch it compares pinned against RLIMIT_LOCKED
> > but completely discards any possible locked pages.
> 
> Pinned pages are different from mlock. Mlock semantics means that the
> pages are kept in memory but the pages are movable (subject to page
> migration f.e.).
> 
> Pinned pages have to stay where they are since the physical addresses may
> be used for device I/O or other stuff.
> 
> Both pinned and mlocked pages cannot be evicted from memory. If one wants
> to account for unevictable pages then both are contributing. However,
> since a pinned page may be mlocked simply adding up the counter may cause
> problems. The sum could be used as a worst case estimate though.
> 
> We could mlock all pinned pages but then the issue arises on how to track
> that properly in order to unpin when the I/O action is done since the app
> may have also mlocked pages.

I know all that, and its completely irrelevant to the discussion.

You cannot simply take away pinned pages from the RLIMIT_MEMLOCK
accounting without mention nor replacement limits.

You now have double the amount of memory you can loose, once to actual
mlock() and once through whatever generates pinned -- if it bothers with
checking limits at all.

Where we had the guarantee that x < y; you did x := x1 + x2; which then
should result in: x1 + x2 < y, instead you did: x1 < y && x2 < y, not
the same and completely wrong.
