Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753990AbaKCVwY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 16:52:24 -0500
Received: from mta-out1.inet.fi ([62.71.2.234]:42177 "EHLO jenni1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752335AbaKCVwW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 16:52:22 -0500
Date: Mon, 3 Nov 2014 23:52:06 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        Vladimir Davydov <vdavydov@parallels.com>, Tejun Heo <tj@kernel.org>,
        David Miller <davem@davemloft.net>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/3] mm: embed the memcg pointer directly into struct page
Message-ID: <20141103215206.GB24091@node.dhcp.inet.fi>
References: <1414898156-4741-1-git-send-email-hannes@cmpxchg.org>
 <20141103210607.GA24091@node.dhcp.inet.fi>
 <20141103213628.GA11428@phnom.home.cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141103213628.GA11428@phnom.home.cmpxchg.org>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 03, 2014 at 04:36:28PM -0500, Johannes Weiner wrote:
> On Mon, Nov 03, 2014 at 11:06:07PM +0200, Kirill A. Shutemov wrote:
> > On Sat, Nov 01, 2014 at 11:15:54PM -0400, Johannes Weiner wrote:
> > > Memory cgroups used to have 5 per-page pointers.  To allow users to
> > > disable that amount of overhead during runtime, those pointers were
> > > allocated in a separate array, with a translation layer between them
> > > and struct page.
> > > 
> > > There is now only one page pointer remaining: the memcg pointer, that
> > > indicates which cgroup the page is associated with when charged.  The
> > > complexity of runtime allocation and the runtime translation overhead
> > > is no longer justified to save that *potential* 0.19% of memory.
> > 
> > How much do you win by the change?
> 
> Heh, that would have followed right after where you cut the quote:
> with CONFIG_SLUB, that pointer actually sits in already existing
> struct page padding, which means that I'm saving one pointer per page
> (8 bytes per 4096 byte page, 0.19% of memory), plus the pointer and
> padding in each memory section.  I also save the (minor) translation
> overhead going from page to page_cgroup and the maintenance burden
> that stems from having these auxiliary arrays (see deleted code).

I read the description. I want to know if runtime win (any benchmark data?)
from moving mem_cgroup back to the struct page is measurable.

If the win is not significant, I would prefer to not occupy the padding:
I'm sure we will be able to find a better use for the space in struct page
in the future.

-- 
 Kirill A. Shutemov
