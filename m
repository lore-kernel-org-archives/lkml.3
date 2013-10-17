Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751788Ab3JQGBd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 02:01:33 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:54504 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933Ab3JQGBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 02:01:32 -0400
X-AuditID: 9c93016f-b7c63ae00000696f-5d-525f7d3a6733
Date: Thu, 17 Oct 2013 15:01:53 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Pekka Enberg <penberg@kernel.org>, Christoph Lameter <cl@linux.com>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 00/15] slab: overload struct slab over struct page to
 reduce memory usage
Message-ID: <20131017060153.GB26617@lge.com>
References: <1381913052-23875-1-git-send-email-iamjoonsoo.kim@lge.com>
 <20131016133457.60fa71f893cd2962d8ec6ff3@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131016133457.60fa71f893cd2962d8ec6ff3@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 16, 2013 at 01:34:57PM -0700, Andrew Morton wrote:
> On Wed, 16 Oct 2013 17:43:57 +0900 Joonsoo Kim <iamjoonsoo.kim@lge.com> wrote:
> 
> > There is two main topics in this patchset. One is to reduce memory usage
> > and the other is to change a management method of free objects of a slab.
> > 
> > The SLAB allocate a struct slab for each slab. The size of this structure
> > except bufctl array is 40 bytes on 64 bits machine. We can reduce memory
> > waste and cache footprint if we overload struct slab over struct page.
> 
> Seems a good idea from a quick look.

Thanks :)

> 
> A thought: when we do things like this - adding additional
> interpretations to `struct page', we need to bear in mind that other
> unrelated code can inspect that pageframe.  It is not correct to assume
> that because slab "owns" this page, no other code will be looking at it
> and interpreting its contents.
> 
> One example is mm/memory-failure.c:memory_failure().  It starts with a
> raw pfn, uses that to get at the `struct page', then starts playing
> around with it.  Will that code still work correctly when some of the
> page's fields have been overlayed with slab-specific contents?

Yes, it would work correctly since the SLUB already overload many fields
of struct page with slab-specific contents. One exception is mapping field
which isn't overloaded by the SLUB. But I guess there is no problem,
because the code inspecting random struct page may be already check
PageSlab() or PageLRU() and then skip it if so.

> 
> And memory_failure() is just one example - another is compact_zone()
> and there may well be others.
> 
> This issue hasn't been well thought through.  Given a random struct
> page, there isn't any protocol to determine what it actually *is*. 
> It's a plain old variant record, but it lacks the agreed-upon tag field
> which tells users which variant is currently in use.

With PageSlab(), we can determine that this page is the slab page.
Do we need more? Is there another user who overload struct page?

Thanks.

> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
