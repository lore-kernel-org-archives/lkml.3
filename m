Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758292AbaFSQDK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 12:03:10 -0400
Received: from mail.fireflyinternet.com ([87.106.93.118]:56467 "EHLO
	fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757797AbaFSQDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 12:03:06 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Date: Thu, 19 Jun 2014 17:02:57 +0100
From: Chris Wilson <chris@chris-wilson.co.uk>
To: Joerg Roedel <joro@8bytes.org>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        David Airlie <airlied@linux.ie>, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: mmu_notifier and i915_gem_userptr.c
Message-ID: <20140619160257.GB8476@nuc-i3427.alporthouse.com>
Mail-Followup-To: Chris Wilson <chris@chris-wilson.co.uk>,
	Joerg Roedel <joro@8bytes.org>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	David Airlie <airlied@linux.ie>, intel-gfx@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
References: <20140619153655.GG31771@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140619153655.GG31771@8bytes.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 19, 2014 at 05:36:55PM +0200, Joerg Roedel wrote:
> Hey Chris,
> 
> recently I had a look at i915_gem_userptr.c in order to extend the
> mmu_notifier call-backs implemented there. My goal is to implement the
> change_pte call-back where it is necessary to get rid of it being
> wrapped mn_invalidate_range_start/end() calls (for the reason see
> commit 6bdb913f).
> 
> For most users of mmu_notifiers this is easy, except the i915 driver :)
> The invalidate_range_start notifier implemented there can sleep, so it
> can't be reused for a change_pte implementation (because change_pte is
> called under ptl spin_lock and is not allowed to sleep). On the other
> hand you also didn't implement the invalidate_page notifier, so I am not
> sure whether the code actually cares about the somewhat similar
> change_pte events?

Maybe it should hook the invalidate_page notifier. I picked
invalidate_range() as it seemed to be called first and seemed to cover
all operations that affected an mm's addr range.  The invalidate_page
seemed to be only called during writeback, which aiui will not affect gup.
Should we be hooking more notifiers?
 
> Here is where change_pte is called from:
> 
> 	* In KSM code when pages are merged (shouldn't be relevant
> 	  because KSM doesn't merged pages returned by get_user_pages())
> 	* In uprobes code when a user-page is replaced by a kernel page
> 	  (should only handle .text sections, so probaly not relevant
> 	   here)
> 	* When someone writes to a COW page in mm/memory.c (this looks
> 	  relevant looking at forked processes, on the other hand,
> 	  this is currently handled by unbinding the vma from the
> 	  object list in the i915 driver)
> 
> I am not familiar with the i915 hardware and the driver implementation
> details, so I wanted to ask whether the driver
> 
> 	1) Cares about the change_pte event?

I don't think so... If I understand correctly, change_pte only gets
called when the PTE is updated, not the physical page itself. If that is
true, then the dma mapping of the page is unaffected, and so the GPU
view of the page is not affected either. So, as long as the GPU
maintains a remapped address of a page that is associated by a process
address, we don't need to change anything.

> 	2) If it cares, what is the best way to implement it? What the
> 	   invalidate_range_start() notifier does seems a bit overkill,
> 	   since for the change_pte event nothing is unmapped (but maybe
> 	   remapped)

If need be, start with overkill. I'd rather drop everything and rebuild
it through the layers of mappings we have, as this is a new area for us
and we want some solid foundations before trying to be smart.
 
> So any insight you could provide here would be useful :)

Likewise. :-p
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
