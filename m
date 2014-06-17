Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755563AbaFQIOZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 04:14:25 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:52124 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754214AbaFQIOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 04:14:21 -0400
Date: Tue, 17 Jun 2014 10:14:13 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Daniel Vetter <daniel@ffwll.ch>,
        Alex Williamson <alex.williamson@redhat.com>,
        iommu@lists.linux-foundation.org, chegu_vinod@hp.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>
Subject: Re: [Intel-gfx] [PATCH v2] iommu/intel: Exclude devices using RMRRs
 from IOMMU API domains
Message-ID: <20140617081413.GC5821@phenom.ffwll.local>
Mail-Followup-To: David Woodhouse <dwmw2@infradead.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	iommu@lists.linux-foundation.org, chegu_vinod@hp.com,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Intel Graphics Development <intel-gfx@lists.freedesktop.org>
References: <20140613162901.4550.94476.stgit@bling.home>
 <1402983303.3707.94.camel@ul30vt.home>
 <1402988692.7595.106.camel@i7.infradead.org>
 <CAKMK7uHvHgWY9RX26Shk3LcBNHdzeLjAAsO+LifFNhTKCgTmHg@mail.gmail.com>
 <1402989691.7595.110.camel@i7.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402989691.7595.110.camel@i7.infradead.org>
X-Operating-System: Linux phenom 3.15.0-rc3+ 
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 17, 2014 at 08:21:31AM +0100, David Woodhouse wrote:
> On Tue, 2014-06-17 at 09:15 +0200, Daniel Vetter wrote:
> > We've always been struggling with stolen handling, and we've' always
> > been struggling with vt-d stuff. Also pass-through seems to be a major
> > pain (I've never tried myself). Given all that I'm voting for keeping
> > the RMRR and everything else as much like for the normal case since I
> > have no idea what exactly must be remapped and what's optional. The
> > gpu is definitely keeping a lot of it's own private stuff in various
> > chunks of stolen memory.
> 
> Keeping it like the normal case is distinctly non-trivial. I raised that
> possibility, and it's hard. You have to make the guests' address maps
> match the host, in that the E820-reserved regions used for DMA and
> listed in RMRRs must also appear as reserved for the guests.
> 
> That was bad enough when it was just 'BIOS might be doing something evil
> behind our back' and we didn't need to let the guest *access* those
> pages. But in the i915 case we do actually map and access the stolen
> region too, so the task is even harder. We'd need to be able to decide
> when those regions should actually be mapped into the guest.

Hm, we check some registers (which iirc are set up by the bios) for stolen
to detect the address and size. And if that's there we use it. So not sure
what to do really.

For my understanding: The tricky part with RMRR isn't the mapping, but
making sure that the gues memory layout has the corresponding range
properly marked as reserved in the e820 map (i.e. like on real machines)?
I guess we wouldn't need to care about the actual memory since the host
linux can't access it either (without i915.ko).
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
