Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752015AbaL2IQ1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 03:16:27 -0500
Received: from galahad.ideasonboard.com ([185.26.127.97]:32942 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232AbaL2IQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 03:16:26 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Oded Gabbay <oded.gabbay@amd.com>
Cc: Thierry Reding <thierry.reding@gmail.com>, David Airlie <airlied@linux.ie>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Dana Elifaz <Dana.Elifaz@amd.com>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        Alexander Deucher <Alexander.Deucher@amd.com>,
        iommu@lists.linux-foundation.org,
        Christian =?ISO-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        Arnd Bergmann <arnd@arndb.de>, Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH 0/2] Change order of linkage in kernel makefiles for amdkfd
Date: Mon, 29 Dec 2014 10:16:31 +0200
Message-ID: <1678486.9ZXZnn5och@avalon>
User-Agent: KMail/4.14.3 (Linux/3.16.5-gentoo; KDE/4.14.3; x86_64; ; )
In-Reply-To: <549FEB52.4020103@amd.com>
References: <1419246435-7050-1-git-send-email-oded.gabbay@amd.com> <1621810.aTt9O4Ghzs@avalon> <549FEB52.4020103@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Oded,

On Sunday 28 December 2014 13:36:50 Oded Gabbay wrote:
> On 12/26/2014 11:19 AM, Laurent Pinchart wrote:
> > On Thursday 25 December 2014 14:20:59 Thierry Reding wrote:
> >> On Mon, Dec 22, 2014 at 01:07:13PM +0200, Oded Gabbay wrote:
> >>> This small patch-set, was created to solve the bug described at
> >>> https://bugzilla.kernel.org/show_bug.cgi?id=89661 (Kernel panic when
> >>> trying use amdkfd driver on Kaveri). It replaces the previous patch-set
> >>> called [PATCH 0/3] Use workqueue for device init in amdkfd
> >>> (http://lists.freedesktop.org/archives/dri-devel/2014-December/074401.ht
> >>> ml)
> >>> 
> >>> That bug appears only when radeon, amdkfd and amd_iommu_v2 are compiled
> >>> inside the kernel (not as modules). In that case, the correct loading
> >>> order, as determined by the exported symbol used by each driver, is
> >>> not enforced anymore and the kernel loads them based on who was linked
> >>> first. That makes radeon load first, amdkfd second and amd_iommu_v2
> >>> third.
> >>> 
> >>> Because the initialization of a device in amdkfd is initiated by radeon,
> >>> and can only be completed if amdkfd and amd_iommu_v2 were loaded and
> >>> initialized, then in the case mentioned above, this initalization fails
> >>> and there is a kernel panic as some pointers are not initialized but
> >>> used nontheless.
> >>> 
> >>> To solve this bug, this patch-set moves iommu/ before gpu/ in
> >>> drivers/Makefile and also moves amdkfd/ before radeon/ in
> >>> drivers/gpu/drm/Makefile.
> >>> 
> >>> The rationale is that in general, AMD GPU devices are dependent on AMD
> >>> IOMMU controller functionality to allow the GPU to access a process's
> >>> virtual memory address space, without the need for pinning the memory.
> >>> That's why it makes sense to initialize the iommu/ subsystem ahead of
> >>> the gpu/ subsystem.
> >> 
> >> I strongly object to this patch set. This makes assumptions about how
> >> the build system influences probe order. That's bad because seemingly
> >> unrelated changes could easily break this in the future.
> >> 
> >> We already have ways to solve this kind of dependency (driver probe
> >> deferral), and I think you should be using it to solve this particular
> >> problem rather than some linking order hack.
> > 
> > While I agree with you that probe deferral is the way to go, I believe
> > linkage ordering can still be used as an optimization to avoid deferring
> > probe in the most common cases. I'm thus not opposed to moving iommu/
> > earlier in link order (provided we can properly test for side effects, as
> > the jump is pretty large), but not as a replacement for probe deferral.
> 
> My thoughts exactly. If this was some extreme use case, than it would be
> justified to solve it with probe deferral. But I think that for most common
> cases, GPU are dependent on IOMMU and *not* vice-versa.
> 
> BTW, my first try at solving this was to use probe deferral (using
> workqueue), but the feedback I got from Christian and Dave was that moving
> iommu/ linkage before gpu/ was a much more simpler solution.

To clarify my position, I believe changing the link order can be a worthwhile 
optimization, but I'm uncertain about the long term viability of that change 
as a fix. Probe deferral has been introduced because not all probe ordering 
issues can be fixed through link ordering, so we should fix the problem 
properly.

This being said, if modifying the link order can help for now without 
introducing negative side effects, it would only postpone the real fix, so I'm 
not opposed to it.

> In addition, Linus said he doesn't object to this "band-aid". See:
> https://lkml.org/lkml/2014/12/25/152
> 
> 	Oded
> 
> >> Coincidentally there's a separate thread currently going on that deals
> >> with IOMMUs and probe order. The solution being worked on is currently
> >> somewhat ARM-specific, so adding a couple of folks for visibility. It
> >> looks like we're going to need something more generic since this is a
> >> problem that even the "big" architectures need to solve.

-- 
Regards,

Laurent Pinchart

