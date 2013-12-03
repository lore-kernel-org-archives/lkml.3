Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752938Ab3LCCGK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 21:06:10 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:45163 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998Ab3LCCGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 21:06:07 -0500
X-AuditID: 9c93016f-b7c57ae0000070d3-08-529d3c8def48
Date: Tue, 3 Dec 2013 11:08:32 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mgorman@suse.de>, Hugh Dickins <hughd@google.com>,
        Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Hillf Danton <dhillf@gmail.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 6/9] mm/rmap: use rmap_walk() in try_to_unmap()
Message-ID: <20131203020832.GD31168@lge.com>
References: <1385624926-28883-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1385624926-28883-7-git-send-email-iamjoonsoo.kim@lge.com>
 <20131202150107.7a814d0753356afc47b58b09@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131202150107.7a814d0753356afc47b58b09@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 02, 2013 at 03:01:07PM -0800, Andrew Morton wrote:
> On Thu, 28 Nov 2013 16:48:43 +0900 Joonsoo Kim <iamjoonsoo.kim@lge.com> wrote:
> 
> > Now, we have an infrastructure in rmap_walk() to handle difference
> > from variants of rmap traversing functions.
> > 
> > So, just use it in try_to_unmap().
> > 
> > In this patch, I change following things.
> > 
> > 1. enable rmap_walk() if !CONFIG_MIGRATION.
> > 2. mechanical change to use rmap_walk() in try_to_unmap().
> > 
> > ...
> >
> > --- a/include/linux/rmap.h
> > +++ b/include/linux/rmap.h
> > @@ -190,7 +190,7 @@ int page_referenced_one(struct page *, struct vm_area_struct *,
> >  
> >  int try_to_unmap(struct page *, enum ttu_flags flags);
> >  int try_to_unmap_one(struct page *, struct vm_area_struct *,
> > -			unsigned long address, enum ttu_flags flags);
> > +			unsigned long address, void *arg);
> 
> This change is ugly and unchangelogged.
> 
> Also, "enum ttu_flags flags" was nice and meaningful, but "void *arg"
> conveys far less information.  A suitable way to address this
> shortcoming is to document `arg' at the try_to_unmap_one() definition
> site.  try_to_unmap_one() doesn't actually have any documentation at
> this stage - let's please fix that?

Okay. I will add some comments.

> >
> > ...
> >
> > @@ -1509,6 +1510,11 @@ bool is_vma_temporary_stack(struct vm_area_struct *vma)
> >  	return false;
> >  }
> >  
> > +static int skip_vma_temporary_stack(struct vm_area_struct *vma, void *arg)
> > +{
> > +	return (int)is_vma_temporary_stack(vma);
> > +}
> 
> The (int) cast is unneeded - the compiler will turn a bool into an int.
> 
> Should this function (and rmap_walk_control.skip()) really be returning
> a bool?

Okay. Will do.

> 
> The name of this function is poor: "skip_foo" implies that the function
> will skip over a foo.  But that isn't what this function does.  Please
> choose something which accurately reflects the function's behavior.

Okay.

Thanks.
