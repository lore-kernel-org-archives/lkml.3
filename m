Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933582AbaFSPhB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 11:37:01 -0400
Received: from 8bytes.org ([85.214.48.195]:47039 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932239AbaFSPg7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 11:36:59 -0400
Date: Thu, 19 Jun 2014 17:36:55 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        David Airlie <airlied@linux.ie>, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: mmu_notifier and i915_gem_userptr.c
Message-ID: <20140619153655.GG31771@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Thu Jun 19 17:36:57 2014
X-DSPAM-Confidence: 0.9978
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 53a3039920861458411812
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Chris,

recently I had a look at i915_gem_userptr.c in order to extend the
mmu_notifier call-backs implemented there. My goal is to implement the
change_pte call-back where it is necessary to get rid of it being
wrapped mn_invalidate_range_start/end() calls (for the reason see
commit 6bdb913f).

For most users of mmu_notifiers this is easy, except the i915 driver :)
The invalidate_range_start notifier implemented there can sleep, so it
can't be reused for a change_pte implementation (because change_pte is
called under ptl spin_lock and is not allowed to sleep). On the other
hand you also didn't implement the invalidate_page notifier, so I am not
sure whether the code actually cares about the somewhat similar
change_pte events?

Here is where change_pte is called from:

	* In KSM code when pages are merged (shouldn't be relevant
	  because KSM doesn't merged pages returned by get_user_pages())
	* In uprobes code when a user-page is replaced by a kernel page
	  (should only handle .text sections, so probaly not relevant
	   here)
	* When someone writes to a COW page in mm/memory.c (this looks
	  relevant looking at forked processes, on the other hand,
	  this is currently handled by unbinding the vma from the
	  object list in the i915 driver)

I am not familiar with the i915 hardware and the driver implementation
details, so I wanted to ask whether the driver

	1) Cares about the change_pte event?
	2) If it cares, what is the best way to implement it? What the
	   invalidate_range_start() notifier does seems a bit overkill,
	   since for the change_pte event nothing is unmapped (but maybe
	   remapped)

So any insight you could provide here would be useful :)


Thanks,

	Joerg


