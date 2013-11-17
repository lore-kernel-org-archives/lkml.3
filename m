Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752469Ab3KQVts (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 16:49:48 -0500
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:54824 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751267Ab3KQVtj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 16:49:39 -0500
Message-ID: <1384724973.2050.14.camel@dabdike.int.hansenpartnership.com>
Subject: Re: [PATCH] aio: fix D-cache aliasing issues
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Helge Deller <deller@gmx.de>
Cc: Benjamin LaHaise <bcrl@kvack.org>, Simon Baatz <gmbnomis@gmail.com>,
        linux-aio@kvack.org, linux-kernel@vger.kernel.org,
        linux-parisc@vger.kernel.org
Date: Sun, 17 Nov 2013 13:49:33 -0800
In-Reply-To: <528933BC.50806@gmx.de>
References: <20131115220529.GA3160@ls3530.box>
	 <1384555325.2003.39.camel@dabdike.int.hansenpartnership.com>
	 <20131116200717.GA18939@schnuecks.de> <20131116200959.GA14098@kvack.org>
	 <528933BC.50806@gmx.de>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.8.5 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-11-17 at 22:23 +0100, Helge Deller wrote:
> On 11/16/2013 09:09 PM, Benjamin LaHaise wrote:
> > On Sat, Nov 16, 2013 at 09:07:18PM +0100, Simon Baatz wrote:
> >> On Fri, Nov 15, 2013 at 02:42:05PM -0800, James Bottomley wrote:
> >>> On Fri, 2013-11-15 at 23:05 +0100, Helge Deller wrote:
> >>>> When a user page mapping is released via kunmap*() functions, the D-cache needs
> >>>> to be flushed via flush_dcache_page() to avoid D-cache aliasing issues.
> >>>>
> >>>> This patch fixes aio on the parisc platform (and probably others).
> >>>
> >>> This should be flush_kernel_dcache_page().  flush_dcache_page() is for
> >>> full coherency but for unmap, we know the page was coherent going in and
> >>> may have been modified by the kernel, so only the kernel view needs to
> >>> be sync'd.  Technically, by the kernel API, the flush should be done
> >>> *before* unmapping.  This would have mattered on parisc until we did
> >>> flush via tmpalias which means we no-longer care if the mapping for the
> >>> flush exists or not because we always recreate it via the tmpalias
> >>> pages.
> >>
> >> On ARM, flush_kernel_dcache_page() actually assumes that the page is
> >> mapped.  It avoids double flushing of highmem pages by not flushing
> >> in those cases where kunmap_atomic() already takes care of flushing.
> > 
> > Helge -- are you going to resubmit a version of this patch that makes the 
> > recommended change?
> 
> Sure, I'll do. May need some time for testing the various machine types though.
> Maybe in the end you can drop my patch since we might be able to fix it in the 
> parisc arch code.
> 
> @James, Dave: The patch I sent here was not used on the C8000. The C8000 (PA8800)
> works out of the box (and it uses the flush_kernel_dcache_page() function which
> is provided by kunmap()). It seems we require the flush_kernel_dcache_page() on
> the other machines too?

Well, this is why I think our in-kernel API (not the parisc one) for
kmap/kunmap is faulty.  I can't see any valid use of kmap/kunmap where
you don't need to flush.  Either you kmapped for reading, in which case
you need to flush user space before the kernel access, or you kmapped
for writing, in which case you need to flush user space just before
mapping (eliminate any dirty user line) and the kernel cache before
unmap (so the modification becomes visible in main memory).  I could see
an argument that flushing all the user mappings is expensive so only do
it if necessary, but I think it looks to be always necessary: even if
you're writing only, which means purging the lines above the user
mappings, most hardware will panic (HPMC) if it sees inequivalent
aliases with clashing dirty lines.

I think the reason for the complexity is issues on ARM.  The user space
cache lines have to remain empty until the kunmap.  On parisc we can
ensure this by purging the tlb entries to prevent speculative move in
(if the user deliberately accesses while we're modifying, it's caveat
emptor), but I don't believe ARM can control this speculation, so they
always need to re-invalidate all of user space before unmap just to
eliminate speculated lines ... in any case, that could still be done as
part of the kunmap API.

James


