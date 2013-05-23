Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759493Ab3EWPZO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 11:25:14 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:34235
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757920Ab3EWPZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 11:25:12 -0400
Date: Thu, 23 May 2013 17:24:58 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Christoph Lameter <cl@linux.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Vince Weaver <vincent.weaver@maine.edu>,
        linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        trinity@vger.kernel.org
Subject: Re: OOPS in perf_mmap_close()
Message-ID: <20130523152458.GD23650@twins.programming.kicks-ass.net>
References: <alpine.DEB.2.10.1305221523420.9944@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1305221953370.11450@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1305222344060.12929@vincent-weaver-1.um.maine.edu>
 <20130523044803.GA25399@ZenIV.linux.org.uk>
 <20130523104154.GA23650@twins.programming.kicks-ass.net>
 <0000013ed1b8d0cc-ad2bb878-51bd-430c-8159-629b23ed1b44-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0000013ed1b8d0cc-ad2bb878-51bd-430c-8159-629b23ed1b44-000000@email.amazonses.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 23, 2013 at 02:09:10PM +0000, Christoph Lameter wrote:
> On Thu, 23 May 2013, Peter Zijlstra wrote:
> 
> > Right it doesn't. I think the easiest solution for now is to not copy the VMA
> > on fork().
> 
> Right. Pinned pages are not inherited. If a page is unpinned then that is
> going to happen for all address spaces that reference the page.
> 
> > But I totally missed patch bc3e53f682d that introduced pinned_vm, AFAICT that
> > also wrecked some accounting. We should still account both against
> > RLIMIT_MEMLOCK.
> 
> The point of the patch was to unwreck accounting. Before the patch mlocked
> pages were counted twice which resulted in stramge VM scenarios where more
> pages were mlocked than memory available. Note that a pinned page may also
> be mlocked.
> 
> Simply adding the two will reintroduce the problems that were fixed by the
> patch.

The patch completely fails to explain how RLIMIT_LOCKED is supposed to
deal with pinned vs locked. Perf used to account its pages against
RLIMIT_LOCKED, with the patch it compares pinned against RLIMIT_LOCKED
but completely discards any possible locked pages.

IMO that's broken.
