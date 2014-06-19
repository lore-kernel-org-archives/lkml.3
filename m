Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757981AbaFSO3s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 10:29:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29279 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757944AbaFSO3r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 10:29:47 -0400
Message-ID: <1403188160.3707.242.camel@ul30vt.home>
Subject: Re: [Intel-gfx] [PATCH v2] iommu/intel: Exclude devices using RMRRs
 from IOMMU API domains
From: Alex Williamson <alex.williamson@redhat.com>
To: Daniel Vetter <daniel@ffwll.ch>
Cc: David Woodhouse <dwmw2@infradead.org>, iommu@lists.linux-foundation.org,
        chegu_vinod@hp.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>
Date: Thu, 19 Jun 2014 08:29:20 -0600
In-Reply-To: <CAKMK7uE6Ab7pvyNvz7sd7QD1ZKDXd6kkEmXHxTzeFCmH1Z_bMQ@mail.gmail.com>
References: <20140613162901.4550.94476.stgit@bling.home>
	 <1402983303.3707.94.camel@ul30vt.home>
	 <1402988692.7595.106.camel@i7.infradead.org>
	 <1403007757.3707.100.camel@ul30vt.home>
	 <1403008864.7595.144.camel@i7.infradead.org>
	 <1403010982.3707.123.camel@ul30vt.home>
	 <20140617134408.GM5821@phenom.ffwll.local>
	 <1403128088.3707.223.camel@ul30vt.home>
	 <1403142438.3707.234.camel@ul30vt.home>
	 <CAKMK7uE6Ab7pvyNvz7sd7QD1ZKDXd6kkEmXHxTzeFCmH1Z_bMQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-06-19 at 08:10 +0200, Daniel Vetter wrote:
> On Thu, Jun 19, 2014 at 3:47 AM, Alex Williamson
> <alex.williamson@redhat.com> wrote:
> > Finding some more specs... the MGGC0 register (50h) seems to indicate
> > the GTT stolen memory size is 2M, which sounds suspiciously like the 2M
> > that the RMRR is reporting.  However, from the IvyBridge MMIO, Media
> > Registers & Programming Env manual:
> >
> >         4.6.1 Changes to GTT
> >
> >         The GTT is constrained to be located at the beginning of a
> >         special section of stolen memory called the GTT stolen memory
> >         (GSM). There is no longer an MMIO register containing the
> >         physical base address of the GTT as on prior devices. Instead of
> >         using the PGTBL_CTL register to specify the base address of the
> >         GTT, the GTT base is now defined to be at the bottom (offset 0)
> >         of GSM.
> >
> >         Since the graphics device (including the driver) knows nothing
> >         about the location of GSM, it does not “know” where the GTT is
> >         located in memory. In fact, the CPU cannot directly access the
> >         GSM containing the GTT.
> >
> > That seems to suggest we can't discover this region from the device, but
> > the device does need to maintain access to it... I don't know how to
> > resolve that without exposing the RMRR through the IOMMU API.
> >
> > In any case, I don't know that any of this should block the original
> > patch.  All of this seems like "acceptable" use of RMRRs that we can
> > later add an exception to allow if we get to the point of understanding
> > it and being able to reproduce any required mappings in the guest.
> > Thanks,
> 
> GTT stolen is the place where the gpu stores page tables. We never
> access them directly but through a special mmio range so that the gpu
> can intercept pte updates and invalidate tlbs accordingly. So yeah, we
> need this, too.

But is there a way for software to discover its location from the
device?  If so, then I think we can recreate all the identity maps we'd
need for a guest from the device.  If not, then we'd need to figure out
some IOMMU API extension to handle the mapping.  The spec excerpt above
seems to indicate that hardware designers decided software doesn't need
to know about it, but the RMRR seems to be the "oh crap" moment when
they realized that yes we do need to know about it.  Thanks,

Alex

