Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756770AbaFYWTG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 18:19:06 -0400
Received: from 8bytes.org ([85.214.48.195]:56697 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753932AbaFYWTF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 18:19:05 -0400
Date: Thu, 26 Jun 2014 00:18:59 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        David Airlie <airlied@linux.ie>, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: mmu_notifier and i915_gem_userptr.c
Message-ID: <20140625221859.GD7732@8bytes.org>
References: <20140619153655.GG31771@8bytes.org>
 <20140619160257.GB8476@nuc-i3427.alporthouse.com>
 <20140620114350.GH31771@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140620114350.GH31771@8bytes.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Thu Jun 26 00:19:01 2014
X-DSPAM-Confidence: 0.9977
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 53ab4ad520861054813626
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 20, 2014 at 01:43:50PM +0200, Joerg Roedel wrote:
> Change_pte is also called when the underlying page of an address
> changes in the kernel which would matter for DMA. But that can only
> happen in KSM and uprobes code which is probably not of interest for the
> i915 driver.
> 
> The other case where I think it matters is the do_wp_page() path for
> COW. The code works by calling invalidate_range_start -> change_pte ->
> invalidate_range_end. Your driver would react to this by unbinding the
> vma from itself internally (after a fork for example).
> 
> But I have to check whether this really matters here.

Okay, I think it does not matter for the i915 driver. The code-paths
which map pages read-only for COW invoke invalidate_range_start/end on
the page-ranges which causes the driver to unbind the pages.

When get_user_pages() is called again later it will do the COW by
itself, so the driver doesn't need to care.

So I tend to say that the i915 driver does not need a change_pte()
call-back at all. But probably someone should double-check to make sure
I didn't miss something.


	Joerg


