Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751656AbaLZJS5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2014 04:18:57 -0500
Received: from galahad.ideasonboard.com ([185.26.127.97]:58311 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165AbaLZJSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2014 04:18:55 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Oded Gabbay <oded.gabbay@amd.com>, David Airlie <airlied@linux.ie>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Dana Elifaz <Dana.Elifaz@amd.com>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        Alexander Deucher <Alexander.Deucher@amd.com>,
        iommu@lists.linux-foundation.org,
        Christian =?ISO-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        Arnd Bergmann <arnd@arndb.de>, Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH 0/2] Change order of linkage in kernel makefiles for amdkfd
Date: Fri, 26 Dec 2014 11:19 +0200
Message-ID: <1621810.aTt9O4Ghzs@avalon>
User-Agent: KMail/4.14.3 (Linux/3.16.5-gentoo; KDE/4.14.3; x86_64; ; )
In-Reply-To: <20141225132058.GA32005@mithrandir>
References: <1419246435-7050-1-git-send-email-oded.gabbay@amd.com> <20141225132058.GA32005@mithrandir>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thierry,

On Thursday 25 December 2014 14:20:59 Thierry Reding wrote:
> On Mon, Dec 22, 2014 at 01:07:13PM +0200, Oded Gabbay wrote:
> > This small patch-set, was created to solve the bug described at
> > https://bugzilla.kernel.org/show_bug.cgi?id=89661 (Kernel panic when
> > trying use amdkfd driver on Kaveri). It replaces the previous patch-set
> > called [PATCH 0/3] Use workqueue for device init in amdkfd
> > (http://lists.freedesktop.org/archives/dri-devel/2014-December/074401.html
> > )
> > 
> > That bug appears only when radeon, amdkfd and amd_iommu_v2 are compiled
> > inside the kernel (not as modules). In that case, the correct loading
> > order, as determined by the exported symbol used by each driver, is
> > not enforced anymore and the kernel loads them based on who was linked
> > first. That makes radeon load first, amdkfd second and amd_iommu_v2
> > third.
> > 
> > Because the initialization of a device in amdkfd is initiated by radeon,
> > and can only be completed if amdkfd and amd_iommu_v2 were loaded and
> > initialized, then in the case mentioned above, this initalization fails
> > and there is a kernel panic as some pointers are not initialized but
> > used nontheless.
> > 
> > To solve this bug, this patch-set moves iommu/ before gpu/ in
> > drivers/Makefile and also moves amdkfd/ before radeon/ in
> > drivers/gpu/drm/Makefile.
> > 
> > The rationale is that in general, AMD GPU devices are dependent on AMD
> > IOMMU controller functionality to allow the GPU to access a process's
> > virtual memory address space, without the need for pinning the memory.
> > That's why it makes sense to initialize the iommu/ subsystem ahead of the
> > gpu/ subsystem.
>
> I strongly object to this patch set. This makes assumptions about how
> the build system influences probe order. That's bad because seemingly
> unrelated changes could easily break this in the future.
> 
> We already have ways to solve this kind of dependency (driver probe
> deferral), and I think you should be using it to solve this particular
> problem rather than some linking order hack.

While I agree with you that probe deferral is the way to go, I believe linkage 
ordering can still be used as an optimization to avoid deferring probe in the 
most common cases. I'm thus not opposed to moving iommu/ earlier in link order 
(provided we can properly test for side effects, as the jump is pretty large), 
but not as a replacement for probe deferral.

> Coincidentally there's a separate thread currently going on that deals
> with IOMMUs and probe order. The solution being worked on is currently
> somewhat ARM-specific, so adding a couple of folks for visibility. It
> looks like we're going to need something more generic since this is a
> problem that even the "big" architectures need to solve.

-- 
Regards,

Laurent Pinchart

