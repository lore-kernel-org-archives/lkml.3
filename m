Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967165AbaFTLnz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 07:43:55 -0400
Received: from 8bytes.org ([85.214.48.195]:48457 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965201AbaFTLny (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 07:43:54 -0400
Date: Fri, 20 Jun 2014 13:43:50 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        David Airlie <airlied@linux.ie>, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: mmu_notifier and i915_gem_userptr.c
Message-ID: <20140620114350.GH31771@8bytes.org>
References: <20140619153655.GG31771@8bytes.org>
 <20140619160257.GB8476@nuc-i3427.alporthouse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140619160257.GB8476@nuc-i3427.alporthouse.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Fri Jun 20 13:43:52 2014
X-DSPAM-Confidence: 0.9982
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 53a41e7820865407221250
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 19, 2014 at 05:02:57PM +0100, Chris Wilson wrote:
> Maybe it should hook the invalidate_page notifier. I picked
> invalidate_range() as it seemed to be called first and seemed to cover
> all operations that affected an mm's addr range.  The invalidate_page
> seemed to be only called during writeback, which aiui will not affect gup.
> Should we be hooking more notifiers?

For what you are interested in the invalidate_range_start notifier
should be sufficient. Invalidate_page is only called for page-aging and
swapping (and xip, but that doesn't matter either).

The problem with invalidate_range_start/end is that its semantics make
it somewhat expensive to implement. So it would be good to reduce the
call-sites and get rid of it at least around the change_pte calls in a
first step.

> > I am not familiar with the i915 hardware and the driver implementation
> > details, so I wanted to ask whether the driver
> > 
> > 	1) Cares about the change_pte event?
> 
> I don't think so... If I understand correctly, change_pte only gets
> called when the PTE is updated, not the physical page itself. If that is
> true, then the dma mapping of the page is unaffected, and so the GPU
> view of the page is not affected either. So, as long as the GPU
> maintains a remapped address of a page that is associated by a process
> address, we don't need to change anything.

Change_pte is also called when the underlying page of an address
changes in the kernel which would matter for DMA. But that can only
happen in KSM and uprobes code which is probably not of interest for the
i915 driver.

The other case where I think it matters is the do_wp_page() path for
COW. The code works by calling invalidate_range_start -> change_pte ->
invalidate_range_end. Your driver would react to this by unbinding the
vma from itself internally (after a fork for example).

But I have to check whether this really matters here.

> If need be, start with overkill. I'd rather drop everything and rebuild
> it through the layers of mappings we have, as this is a new area for us
> and we want some solid foundations before trying to be smart.

The main problem I have seen so far is the mutex taken in the
invalidate_range_start call-back. That can't be used in a change_pte
function because change_pte is not preemptible.


	Joerg


