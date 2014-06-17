Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932859AbaFQMXG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 08:23:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10995 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932455AbaFQMXE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 08:23:04 -0400
Message-ID: <1403007757.3707.100.camel@ul30vt.home>
Subject: Re: [PATCH v2] iommu/intel: Exclude devices using RMRRs from IOMMU
 API domains
From: Alex Williamson <alex.williamson@redhat.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: iommu@lists.linux-foundation.org, chegu_vinod@hp.com,
        linux-kernel@vger.kernel.org,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>
Date: Tue, 17 Jun 2014 06:22:37 -0600
In-Reply-To: <1402988692.7595.106.camel@i7.infradead.org>
References: <20140613162901.4550.94476.stgit@bling.home>
	 <1402983303.3707.94.camel@ul30vt.home>
	 <1402988692.7595.106.camel@i7.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-06-17 at 08:04 +0100, David Woodhouse wrote:
> On Mon, 2014-06-16 at 23:35 -0600, Alex Williamson wrote:
> > 
> > Any idea what an off-the-shelf Asus motherboard would be doing with an
> > RMRR on the Intel HD graphics?
> > 
> > dmar: RMRR base: 0x000000bb800000 end: 0x000000bf9fffff
> > IOMMU: Setting identity map for device 0000:00:02.0 [0xbb800000 - 0xbf9fffff]
> 
> Hm, we should have thought of that sooner. That's quite normal — it's
> for the 'stolen' memory used for the framebuffer. And maybe also the
> GTT, and shadow GTT and other things; I forget precisely what, and it
> varies from one setup to another.

Why exactly do these things need to be identity mapped through the
IOMMU?  This sounds like something a normal device might do with a
coherent mapping.

> I'd expect fairly much all systems to have an RMRR for the integrated
> graphics device if they have one, and your patch¹ is going to prevent
> assignment of those to guests... as you've presumably noticed.
> 
> I'm not sure if the i915 driver is capable of fully reprogramming the
> hardware to completely stop using that region, to allow assignment to a
> guest with a 'pure' memory map and no stolen region. I suppose it must,
> if assignment to guests was working correctly before?

IGD assignment has never worked with KVM.

> Perhaps the better answer here is not to have the special cases in
> 'device_is_rmrr_locked()', and instead allow a device driver to call a
> 'iommu_release_rmrrs()' function once it's reset the hardware to *stop*
> doing whatever DMA the BIOS set it up with.

IGD supports FLR, which is good, but I would assume an FLR doesn't
necessarily release use of this region and being a root complex device I
don't think we have a bigger hammer reset option.  Thanks,

Alex

