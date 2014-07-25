Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935088AbaGYVrm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 17:47:42 -0400
Received: from mail-qa0-f52.google.com ([209.85.216.52]:35038 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751350AbaGYVrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 17:47:40 -0400
Date: Fri, 25 Jul 2014 17:47:35 -0400
From: Jerome Glisse <j.glisse@gmail.com>
To: Joerg Roedel <joro@8bytes.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rik van Riel <riel@redhat.com>, Hugh Dickins <hughd@google.com>,
        Mel Gorman <mgorman@suse.de>, Johannes Weiner <jweiner@redhat.com>,
        Jerome Glisse <jglisse@redhat.com>, jroedel@suse.de,
        Jay.Cornwall@amd.com, Oded.Gabbay@amd.com, John.Bridgman@amd.com,
        Suravee.Suthikulpanit@amd.com, ben.sander@amd.com,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, iommu@lists.linux-foundation.org
Subject: Re: [PATCH 1/3] mmu_notifier: Add mmu_notifier_invalidate_range()
Message-ID: <20140725214734.GB5478@gmail.com>
References: <1406212541-25975-1-git-send-email-joro@8bytes.org>
 <1406212541-25975-2-git-send-email-joro@8bytes.org>
 <20140725131639.698f18ff@jbarnes-desktop>
 <20140725213806.GN14017@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140725213806.GN14017@8bytes.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 25, 2014 at 11:38:06PM +0200, Joerg Roedel wrote:
> On Fri, Jul 25, 2014 at 01:16:39PM -0700, Jesse Barnes wrote:
> > > To allow managing external TLBs the MMU-notifiers need to
> > > catch the moment when pages are unmapped but not yet freed.
> > > This new notifier catches that moment and notifies the
> > > interested subsytem when pages that were unmapped are about
> > > to be freed. The new notifier will only be called between
> > > invalidate_range_start()/end().
> > 
> > So if we were actually sharing page tables, we should be able to make
> > start/end no-ops and just use this new callback, assuming we didn't
> > need to do any other serialization or debug stuff, right?
> 
> Well, not completly. What you need with this patch-set is a
> invalidate_range and an invalidate_end call-back. There are call sites
> of the start/end functions where the TLB flush happens after the _end
> notifier (or at least can wait until _end is called). I did not add
> invalidate_range calls to these places (yet). But you can easily discard
> invalidate_range_start, any flush done in there is useless with shared
> page-tables.
> 
> I though about removing the need for invalidate_range_end too when
> writing the patches, and possible solutions are
> 
> 	1) Add mmu_notifier_invalidate_range() to all places where
> 	   start/end is called too. This might add some unnecessary
> 	   overhead.
> 
> 	2) Call the invalidate_range() call-back from the
> 	   mmu_notifier_invalidate_range_end too.
> 
> 	3) Just let the user register the same function for
> 	   invalidate_range and invalidate_range_end
> 
> I though that option 1) adds overhead that is not needed (but it might
> not be too bad, the overhead is an additional iteration over the
> mmu_notifer list when there are no call-backs registered).
> 
> Option 2) might also be overhead if a user registers different functions
> for invalidate_range() and invalidate_range_end(). In the end I came to
> the conclusion that option 3) is the best one from an overhead POV.
> 
> But probably targeting better usability with one of the other options is
> a better choice? I am open for thoughts and suggestions on that.
> 

I should add that for hmm it is crucial to exactly match call to start and
end ie hmm needs to know when it can start again to do cpu page table look
up and expect valid content.

Cheers,
Jérôme
